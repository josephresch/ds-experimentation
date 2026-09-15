# Allocating scarce exposure across a long-tail catalog

A design study for Wayfair, built from public filings and the company's published engineering
writing. The internal system described is a plausible reconstruction rather than a description of
Wayfair's actual architecture.

## Problem

A retailer carries more than 30 million products from 25,000 suppliers and adds more than 200,000 a
quarter. Merchandising attention, photography budget, top search positions and warehouse slots are
all finite.

The question as it arrives from the business is which products are underperforming. The question that
can actually be built is different, and most of the work is getting from one to the other.

## Design tensions

| Tension | How it shows up |
|---|---|
| The naive definition flags most of the catalog | Fewer units sell in a quarter than there are SKUs listed. Low sales is the modal state, not a defect |
| The measurement is caused by the decision it feeds | Low sales is driven by low exposure as much as by low quality, and exposure is set by a ranking system that reads past sales |
| Age censors everything | A SKU listed three weeks ago has low cumulative sales by construction |
| The distribution breaks the default loss | Zero-inflated and heavy-tailed. Squared error on units optimizes the head and ignores the tail, which is the population in question |
| "It costs money to carry" is mostly false | The marginal cost of carrying a dropship listing is near zero. The real cost is opportunity cost in scarce attention |
| A point estimate is not the decision | Delisting is hard to reverse, so the downside matters and the decision needs a distribution rather than a number |
| Cold start is not an edge case | 200,000 products a quarter have no history at all |

The honest conclusion is not a drop list. It is a reallocation of exposure, a small delisting tail,
and the observation that the largest available win is finding products that would have performed and
never got the chance.

## Framing

Three of the tensions above are the same tension. Sales, revenue and conversion are *levels*, and
every level in this catalog is jointly produced by product quality and exposure. Exposure is assigned
by a ranking system that reads past sales, so a level is partly a record of what the incumbent system
already believed. Sorting the catalog by any of them ranks products by how much attention they have
received, with quality as a secondary term.

> Most apparent underperformance is unmeasured rather than bad, and no level-based metric can tell
> the difference.

That reframes the deliverable. The object is not a classifier that labels products good or bad. It is
an allocation policy for a scarce resource under uncertainty, which is a different kind of system with
a different objective, a different output type and a different validation strategy.

Wayfair has published its own version of the inverted problem. Its Predicted Winners models score new
products at or before launch from intrinsics (wholesale cost, images, descriptions) and separately
from early engagement time series, feeding storefront sort position and supplier exclusivity
negotiations. Two details of that published design are load-bearing here and are adopted below. The
targets are distributions rather than point predictions (Bernoulli with log-normal for revenue,
negative binomial for order counts) explicitly to produce a measure of uncertainty, and a single
model spans product classes so that knowledge transfers to classes with little history. The company
also describes a continuous testing framework, Sentinel, that controls exposure variables to prevent
a self-fulfilling bias in which products are identified as winners. That last piece is the central
threat in this case, named by the company that built the system.

The same structure recurs across the sibling studies in this repo. [Price optimization](01-pricing.md)
narrows its own inputs, [damage-risk targeting](02-returns.md) destroys its own labels, and
[promotional uplift](03-promotions.md) changes who is treated. Here the model sets the exposure that
generates its own measurement.

## Public figures

- Catalog: 30M+ products, 25,000+ suppliers, 200,000+ new products per quarter
- Q1 2026: net revenue $2.93B, gross margin 30.0%, AOV $312, 9.4M orders delivered, 21.4M active
  customers, LTM net revenue per active customer $591
- Advertising expense $329M, 11.2% of net revenue
- Predicted Winners scores feed storefront sort position and supplier exclusivity negotiations

## Arithmetic

The catalog is larger than the quarter's unit volume. At 9.4 million orders and roughly two items
per order, about 19 million units ship per quarter against more than 30 million listed SKUs. At three
items per order it is 28 million, still below the catalog count.

> Fewer units sell in a quarter than there are products listed.

The conclusion survives either assumption. The median SKU sells zero in a
quarter, so any definition of underperformance resting on a sales threshold flags the majority of the
catalog and is useless as a work queue.

Gross margin per order is `0.30 × $312 ≈ $94`.

Impression volume. At an order rate on the close order of 1% per product impression, 9.4 million
orders implies roughly 900 million to 2 billion product impressions a quarter. That number sets the
budget for everything downstream, and section 9 shows it is the binding constraint on the whole
design.

The scarce resource is impressions, not catalog slots. A dropship listing is nearly free to carry.

---

# Design decisions

## 1. Underperformance

Relative beats absolute. An absolute unit threshold drifts with site traffic, seasonality and
macro conditions, so a SKU changes classification without changing. Normalization within category is
also required, since a $40 pillow and a $2,000 sectional are not comparable on absolute contribution.

Share of total margin is degenerate on this catalog. With the median SKU selling zero, the metric
is zero for most of the catalog and a percentile rank is a rank of ties. A definition that flags the
majority is a restatement of the catalog, not a queue.

The fix is the denominator. Use contribution margin per thousand impressions. That makes the
denominator carry the information:

| Sales | Impressions | Verdict |
|---|---|---|
| 0 | 50,000 | Proven bad. The market answered |
| 0 | 12 | Never tested. Missing data, not a verdict |

Rate for comparison, dollars for prioritization. Contribution per impression says which products
are efficient. Total contribution at risk says which to work on first. Ranking on the rate alone
favors low-exposure SKUs with lucky numerators, since one sale in ten impressions reads as 10%, so
rate rankings require shrinkage toward the category rate.

This is frequency modeling. The structure is a count normalized by opportunity, fit as a rate
with `log(exposure)` as an offset. Orders per impression is claims per earned exposure, and the
insurance literature on that problem transfers directly.

The score feeds three decisions with very different economics, and they cannot share a threshold:

| Decision | Character |
|---|---|
| Sort position boost | Cheap, continuous, reversible, can go to many SKUs |
| Merchandising package: photography, copy, attribute enrichment, roughly 20,000 SKUs a quarter | Costly, finite, discrete, irreversible spend |
| Delist or renegotiate with the supplier | Rare, high bar, hard to undo |

## 2. Decision architecture

The system is a bandit, not a scoring problem. There are 30 million arms and each impression is a
pull. The pathology named in section 1, where never-tested products stay never-tested because ranking
reads past sales, is exactly what a pure-exploit policy does to a catalog.

That explains why the published design predicts distributions rather than point values. **The
uncertainty is what tells the system what to try.** Thompson sampling over a per-SKU posterior is the
textbook policy, and it removes the need to hand-code an exploration rule. Zero orders on 50,000
impressions is a tight posterior near zero, zero on twelve is a wide one, and sampling produces the
right ordering for free.

| | |
|---|---|
| Response | Orders (count) over the horizon |
| Offset | `log(impressions)` |
| Family | Negative binomial, or zero-inflated / hurdle |
| What the model estimates | Log conversion rate per impression |
| Output | A posterior over that rate, multiplied by margin per order |

Horizon follows the duration of the consequences, not the timing of the decision. Merchandising
photography persists for years, so the relevant prediction is long-horizon cumulative contribution. A
sort boost is re-evaluated weekly, so a short horizon is adequate there because errors self-correct.

Not every decision is a ranking. Delisting is binary and irreversible, and it needs a threshold on
the downside of the posterior rather than on the mean or the rank.

The exploration budget has a price. Every impression given to an untested SKU is taken from a
proven one. That number is computable and should be stated before anyone asks whether exploration is
affordable.

Contribution margin and attribution collide. Margin is an accounting property of a transaction.
Attribution is a property of the measurement. A SKU that pulls traffic converting on other SKUs
contributes value that per-SKU contribution cannot see, and delisting a low-contribution traffic
driver loses money that cannot be traced.

## 3. Exploratory analysis

The first plot is orders against impressions, log-log, one point per SKU. It answers three
questions at once and it decides whether the project is real.

- **Slope.** Is conversion stable across exposure? A slope of 1 means exposure explains sales. Below
  1 means saturation. Above 1 means the ranking has a rich-get-richer effect
- **Vertical scatter is the product signal.** Points hugging the line mean there are no good or bad
  products, only well and badly exposed ones. **The residual variance around the exposure line is an
  upper bound on what any model can win**
- **The marginal distribution of impressions** says what share of the catalog is evaluable at all

Vertical residual is estimated quality and horizontal position is how much to trust
it. Exploration is a function of the x axis, exploitation of the y axis. A SKU at five impressions
with one order sits far above the line and means nothing.

Lifecycle. Cumulative rate against days listed sets the minimum observation window before a SKU
is judgeable, and convergence is legitimately slower for low-exposure SKUs.

Seasonality is structure, not noise. Outdoor furniture sells in spring. The fix is to
compare each SKU against its own category's seasonal curve rather than to restrict the window.

Two cheap checks decide model form. Zero inflation by exposure decile settles zero-inflated
against plain count, and the conversion rate distribution by category settles pooling against
per-category models.

The ordering matters. Lead with the plot that tests whether the project is real, not the one that
tests whether the data is clean.

## 4. Features and data quality

Pass raw counts through and let the error bounds be wide for thin SKUs. Do not impute behavioral
history and do not drop the SKU. The posterior does that work.

Winsorize measurement artifacts, never the outcome. Dwell time yes, since a tab left open
overnight is an artifact. Orders, contribution and impressions no, because a count model with a log
link handles skew structurally.

Dropping high-missingness SKUs is backwards. They are the newest listings and those from the
least sophisticated suppliers, which is the population the model exists to serve. Dropping them
creates a training and serving population mismatch in the one segment that matters.

Missingness is a feature and possibly the answer. Attributes are missing because a supplier did
not fill in a form, so the mechanism is not missing-at-random. Attribute completeness is a strong
predictor and plausibly causal, since nobody buys a sofa without dimensions, which points at a
merchandising ticket rather than a delisting.

**Two feature regimes, and therefore two models.**

| | Day zero | Mature |
|---|---|---|
| Available | Wholesale cost, price, category, dimensions, material, image and text embeddings, supplier history | Everything above, plus visits, add-to-cart, saves, dwell, orders |

A single model trained on both learns to lean on the behavioral features and leaves the intrinsic
ones under-fit, so it has nothing useful to say about a day-zero SKU.

Three features carry disproportionate weight. Supplier identity is the strongest day-zero signal and
needs shrinkage toward category. Add-to-cart rate is the fastest reliable behavioral signal, with the
same shape as purchase at far higher frequency, so it shortens the observation window from months to
days. Image and text embeddings are what make a universal cross-category model possible. Customer
affinity is the wrong grain unless aggregated to the SKU.

## 5. Model class and estimation

A convolutional network is for data with local spatial structure, not for large datasets in general,
and the embeddings are computed upstream in any case. What is needed downstream maps a few hundred
dense dimensions plus tabular features to a distribution.

**Architecture: a learned prior with a conjugate update.**

- Any predictor (negative binomial GLM, gradient-boosted trees, a small MLP) maps day-zero features
  to a prior rate `λ̂(x)`
- Convert to `Gamma(α, β)` with `α/β = λ̂(x)` and `β` interpreted as prior strength in pseudo-impressions
- The per-SKU posterior is `Gamma(α + orders, β + impressions)`

The conjugacy lives in the update rather than in the model, so any predictor can fill the first role.
Posterior width falls with exposure automatically, reproducing the geometry from section 3, and day-zero
and mature SKUs live in one framework instead of two.

Aleatoric and epistemic uncertainty are different quantities. A quantile GBM gives noise in the
outcome. Exploration needs uncertainty about the *rate*, which is the part that shrinks as impressions
accumulate. A prediction interval on the count conflates the two. The conjugate update separates them.

Baseline first. A negative binomial GLM with a log-impressions offset. Fit it, beat it, and report
the size of the beat.

Three splits answer three questions. Listing date asks whether the model can score an unseen
cohort, and it is the primary split. Grouping by supplier asks whether it can score a new supplier.
Stratifying by category crossed with impression bin checks coverage. Tune on
held-out log-likelihood rather than on squared error.

## 6. Offline evaluation

Four layers, cheapest first.

**Fit.** Held-out negative binomial log-likelihood on later cohorts, against two baselines: the
negative binomial GLM, and a category-average rate. A number without both baselines is not a result.

**Calibration.** A PIT histogram, and separately **coverage by exposure decile**. The entire design
rests on the posterior being wide for thin SKUs, and aggregate calibration hides failure in exactly
that bin.

**Decision value.** The model selects 20,000 SKUs for the merchandising package, the incumbent
selects 20,000, and the comparison is realized contribution in dollars on held-out data. Report the
overlap. If the two lists agree 95% of the time, there is no project regardless of what the
likelihood says.

**Structure.** This is the layer that decides the case. The labels were generated by the current
ranking system, so the best achievable held-out log-likelihood is the one that reproduces that
system's biases perfectly. No held-out metric can distinguish a model that learned product quality
from a model that learned the ranker.

Three partial checks, none sufficient:

1. Beat a baseline of `log(impressions)` plus category. A model that cannot is measuring exposure
2. Audit features for circularity, meaning anything downstream of past rank position
3. Report performance on low-exposure SKUs specifically, since that is where the claim is being made

The only clean answer is randomized exposure, which is why section 7 is a prerequisite for this
section rather than a follow-up to it.

A second structural worry is invisible in every metric above. Supplier concentration in the selected
20,000. A system that entrenches incumbent suppliers and stops discovering new ones scores well on
everything here.

## 7. Online validation

**Search slots are fixed, so boosting one SKU demotes another.** SKU-level randomization is broken by
construction. The demoted SKUs are the control arm and they are harmed by the treatment, so the
difference overstates the effect. The site-level effect can be zero while every pairwise comparison
looks positive.

**Two experiments, not one.**

| | Unit | Answers | Duration |
|---|---|---|---|
| Randomized exposure | SKU | Does the score predict the return to an extra impression? Generates unconfounded training data | Permanent |
| Policy test | User or session | Is the site net better off? | Fixed window |

The first is data collection rather than a test, and it is the published Sentinel idea. Control
the exposure variable so the system can tell whether it found intrinsic potential or created the
winner it predicted.

Power, computed rather than asserted. With contribution per session around $2.35 and a standard
deviation around $15, `n ≈ 16σ²/δ²` gives roughly 6 million sessions per arm for a 1% relative lift
and 1.5 million for 2%. Feasible at this scale, and the point is that it was derived.

The primary metric is contribution margin per session, not NDCG. Ranking metrics are computed
relative to the items shown, so a better-ordered set of low-margin items scores well while
contribution falls. Never validate online on the quantity the model was trained to optimize.

A short experiment measures the cost of exploration and none of its benefit. The fix is the
horizon, or explicit information-value accounting, not a penalty term bolted onto the metric.

## 8. Production behavior

> A pipeline that crashes wakes someone up. A pipeline that succeeds using yesterday's data does not.

| Layer | Watches | Catches |
|---|---|---|
| Input | Freshness SLA per table, null rate, drift | Broken upstream jobs |
| Output | Score distribution, fallback share, per-segment coverage | Model or feature failure |
| Seam | Does the consumer reflect today's scores | The failure nobody instruments |
| Outcome | The holdout gap | The model being wrong rather than broken. Lagged |

Failure modes specific to this system, all of which leave the job green:

- **Stale features rather than null features.** Nulls are caught, yesterday's values are not
- **The score computed and never consumed**, so the ranking silently stops reflecting it
- **Embedding version drift.** A new encoder produces a different space, plausible-range noise, no error
- **A segment falling to default scores**, invisible in an aggregate distribution
- **The exploration budget quietly disabled** by a configuration change, which stops the data
  collection the entire design depends on

Labels here are transaction counts, so mislabeling is not the likely failure. Immature labels and bad
joins after a supplier relists are.

The feedback loop is the thing to instrument above all. Ranking reads past sales and sets exposure,
exposure generates the sales the next model trains on, and the loop closes without anyone deciding
that it should. The permanent randomized exposure arm from section 7 is the only thing that keeps the
system estimable, which makes it infrastructure rather than an experiment.

## 9. Limits

**The catalog cannot be evaluated, and the arithmetic says so.** Moving a SKU off its prior requires
enough impressions for the order count to carry information. At roughly 1% orders per impression,
1,000 impressions buys an expected 10 orders and a relative standard error of about 32%. Thirty
million SKUs at that dose is 30 billion impressions, against something on the order of 900 million
site-wide impressions a quarter. One pass over the catalog costs roughly 32 quarters of the entire
site's traffic, or 638 quarters at a 5% exploration budget. Pushing every assumption in the favorable
direction, 100 impressions per SKU at 2% conversion, still gives about eight years.

The consequence is the finding. **For most of the catalog the posterior is the prior, permanently.**
The system is a day-zero model applied to the tail with an update that only ever fires on the head,
and its accuracy on the majority of SKUs is the accuracy of that prior, which is never measured on
those SKUs because they never generate data.

The prior is fit on a selected sample. The day-zero model trains on SKUs that accumulated enough
exposure to have an outcome. SKUs that never got exposure carry no label and are absent from
training, so the prior is estimated on the exposed population and applied to the unexposed. Randomized
exposure repairs this inside the randomized slice, and the paragraph above bounds how large that
slice can be.

Delisting is absorbing. Every other action leaves the SKU generating data, so an error
self-corrects. A delisted SKU generates nothing, its posterior freezes at the moment of the decision,
and the error rate on delisting is unmeasurable by construction. The only remedy is a deliberate
reinstatement sample, which spends money to re-litigate a decision already made.

Halo and substitution are invisible at this grain. The session-level policy test detects that the
portfolio got worse and cannot say which decision caused it.

Assortment is a portfolio and the model scores items. A category needs breadth to be a
destination, and contribution per impression has no representation of coverage, so the system thins
the middle of a category and the loss appears later as a category-level traffic decline with no
attributable cause.

The features are supplier-controlled, so they degrade adversarially. Once suppliers learn that
attribute completeness and image quality are rewarded, those features predict sophistication about
the system rather than product quality, and retraining relearns the gamed relationship rather than
correcting it. Large suppliers adapt first, which compounds the concentration problem from section 6.

Per-SKU returns do not sum to the site effect. Randomized exposure measures the return to an
extra impression against the current mix on the page. Shipping reallocates exposure across the
catalog and changes that mix everywhere.

The horizon that justifies the largest spend is the one the design cannot measure. A merchandising
package persists for years and the experiment runs for weeks. The honest substitute is a threshold
analysis rather than a guess. Solve for how long the effect must persist for the spend to break even,
and report how extreme that requirement is.

## Sources

- [Wayfair Q1 2026 results](https://investor.wayfair.com/news/news-details/2026/Wayfair-Announces-First-Quarter-2026-Results-Reports-Strong-Share-Capture-and-a-Return-to-Active-Customer-Growth/default.aspx)
- [How Wayfair uses Predicted Winners models to accelerate success for new products](https://www.aboutwayfair.com/careers/tech-blog/how-wayfair-uses-predicted-winners-models-to-accelerate-success-for-new-products)
