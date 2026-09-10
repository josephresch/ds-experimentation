# Replacing a binned markup rule with product-level price optimization

A design study for Wayfair, built from public filings and published benchmarks. The internal
system described is a plausible reconstruction rather than a description of Wayfair's actual
architecture.

## Problem

A retailer with tens of millions of SKUs sets a target gross margin for every product it sells.
The target comes from a **binned rule**. Each SKU is bucketed by class of service, category and
price band, and each bucket carries a markup. "Small-parcel lighting under $100 gets 35%."

The rule is a lookup table. It is crude, but it is robust, explainable, and it produces a price
for a SKU that has sold four units in its life. Any replacement has to be at least as reliable
on the long tail, which is most of the catalog.

The question is where that rule leaves money on the table, and what replaces it.

## Design tensions

| Tension | How it shows up |
|---|---|
| The randomization unit is forced, not chosen | Different posted prices for different customers is price discrimination (a legal, regulatory and brand problem before it is a statistical one) |
| The obvious metric misleads | Rank SKUs by margin rate and you get the long tail. Rank by margin dollars and you get the head, which humans already manage by hand. Neither ordering is "mispriced" |
| Wins do not add up | A price cut on one SKU cannibalizes its substitutes. Product-level gains do not sum to a category-level gain |
| Part of the objective is unmeasurable | Long-run price perception and repeat purchase. No SKU-level test sees them |
| The experimental estimand differs from the decision estimand | A test moves one SKU's price. Shipping moves all of them, and competitors respond |
| The data is awkward | Most SKUs have near-zero weekly demand, stockouts censor demand, and price is endogenous by construction |

The honest conclusion is not "ship it." Deploy on the segment where identification is credible,
and keep the binned rule as the fallback everywhere else.

## Framing

Own-price elasticity is the object of interest, a structural parameter rather than a prediction.
The design therefore leads with identification rather than with architecture. A gradient-boosted
model of units on price, fit without an account of why observed price variation is not exogenous,
answers a different question than the one being asked.

A complementary point cuts the other way. Classical econometrics optimizes for unbiasedness on
one parameter. This problem needs a usable elasticity for tens of millions of SKUs, most of which
will never support an unbiased estimate of their own, so bias-variance tradeoffs and shrinkage
carry weight here that a single-parameter framing does not capture.

## Public figures

- Q1 2026: net revenue $2.93B, gross margin 30.0%, AOV $312, 9.4M orders delivered, 21.4M active
  customers, LTM net revenue per active customer $591, adjusted EBITDA margin 5.2%
- Advertising expense $329M, 11.2% of net revenue (12.6% a year earlier)
- Reported COGS includes inbound and outbound shipping, fulfillment and warehousing, so the 30%
  gross margin is post-logistics and pre-advertising
- The company operates a dedicated pricing strategy and analytics function that sets gross margin
  targets at the SKU level

## Arithmetic

**Break-even on a price cut.** Cutting from `p0` to `p1` pays for itself only if

```
q1 / q0  >  (p0 - c) / (p1 - c)
```

At 30% gross margin, a 5% cut needs `30/25 = 1.20`, a 20% unit increase. Arc elasticity
about -3.5; simple ratio -4.

**Lerner check.** If the current price were already profit-maximizing, `(p - c)/p = 1/|ε|`, so a
30% margin implies management believes `|ε| ≈ 3.3`. The two numbers agree, as they should. The
break-even for a discrete cut sits slightly above the elasticity at the optimum.

**Then allocate advertising to the product.** At roughly 18% contribution margin the same 5% cut
needs `18/13 = 1.385`, a 38.5% unit increase, and a break-even elasticity of about -7.7.

Whether advertising is charged down to the SKU changes the answer by more than any modeling
choice in this document. At 11% of net revenue it is not a rounding error, and it is the first
question worth asking of any retail cost basis.

The Lerner rule maps elasticity to optimal margin.

| ε | Optimal margin |
|---|---|
| -2 | 50% |
| -4 | 25% |
| -10 | 10% |

---

# Design decisions

## 1. Objective and mispricing

The objective is contribution margin dollars, not revenue and not gross margin rate.

Revenue maximization always recommends cutting price, because volume can always be bought with
margin. At 30% margin a 5% cut needs +20% units to hold margin flat but only +5% to hold revenue
flat. Land at +5% and revenue is unchanged while roughly 12% of contribution margin is gone.

Mispricing is a statement about the slope of demand, not about the level of any outcome.

Profit is `Π(p) = (p - c)·q(p)`. Raising price by a dollar gains a dollar on every unit still
sold and loses the margin on the units no longer sold. The optimum is where those cancel, and
whether they cancel depends only on how fast `q` falls and on `c`.

> The profit-maximizing price depends on the slope of demand and on cost. It does not depend on
> how much the SKU sells.

Two SKUs with identical price sensitivity and 100x different volume have the same optimal margin.
Volume determines how much money is at stake, not what the right price is. No demand *level*
(units, revenue, conversion rate) identifies mispricing. Low unit sales means the product is
unpopular, and unpopular and overpriced are different conditions with different remedies.

The one informative level is price relative to the market. An identical SKU carried 20% cheaper
elsewhere is mispriced, and no model is needed to see it. That is a price level, not a demand
level.

Returns belong in the cost basis, not in the detector. A high return rate raises effective cost
per net sale, so the correct response is a *higher* price, or delisting, not a discount.

### Ranking

The quantity that orders the work is the dollar value of fixing each SKU:

```
Opportunity_i = CM_i(p*_i) - CM_i(p_i)
```

This is circular before the model exists, since `p*` is the model's output. The practical
first-pass screen is three terms multiplied:

1. **Money at stake.** Annual contribution margin dollars.
2. **Evidence the bin is wrong here.** Competitor price gap first, then distance from bin-mates
   on anything that should drive price sensitivity.
3. **Learnability.** Whether the SKU has enough past price movement and volume for a slope to be
   estimable at all.

Rank by dollars. Margin rate sorts into the long tail; revenue sorts into the head.

### Between-bucket or within-bucket

Is the variance in the *optimal* margin mostly *between* buckets or *within* them?

In the between-bucket world, buckets differ and SKUs inside a bucket agree. The rule has the
right shape and the wrong numbers, so redraw the boundaries and stop. No machine learning
required.

In the within-bucket world, SKUs inside one bucket disagree violently. A generic table lamp sold
on ten other sites and an exclusive designer sconce sit in the same bucket and want opposite
margins. No bucketing scheme can be right, because the bucket forces them to share a number.

Only the second case justifies a product-level model, and establishing which world you are in is
the cheapest analysis in the project.

## 2. Decision architecture

**Predict, then optimize.** A demand model produces a curve `q̂(p)`; a deterministic optimizer
computes `argmax_p (p - c)·q̂(p)` subject to constraints. The optimizer is arithmetic, not a
learned object.

The alternative (a model that outputs a price directly, trained on historical prices and
outcomes) fails for four reasons, in order of force:

1. **Behavior cloning.** Trained to predict historical prices from features, its best possible
   version reproduces the legacy rule and whatever the human pricers did. The project rebuilds
   the thing it was meant to replace.
2. **No counterfactual.** It cannot say what happens at any price other than the one it
   recommends, so `CM(p*) - CM(p)` is uncomputable, the opportunity ranking is unavailable, and
   nobody can be told how much money is on the table.
3. **Constraints.** Minimum advertised price, price-match commitments, margin floors, caps on
   movement per cycle. All expressible in an optimizer, none in a learned price.
4. **Objective changes are free.** Charging advertising into `c` changes one line of the
   optimizer and leaves the demand model untouched. A direct model retrains from scratch, and
   still cannot express an objective it never saw.

Endogeneity is *not* one of the reasons. Both architectures train on the same non-random prices.
Identification is a property of the data and the estimator, not of the architecture.

The optimizer needs a demand *curve*, not a demand *forecast*. A point prediction at the current
price contains no information about the decision.

A known weakness of this architecture is worth stating rather than hiding. The demand model is
trained to minimize prediction error, not decision loss. Good average fit can coexist with a
wrong slope exactly where the price decision flips. The decision-focused learning literature
addresses this; at catalog scale, diagnosability and constraint handling still favor the split.

## 3. Estimand and identification

Prices were never set at random. They were set by a person or a rule reacting to the same demand
signal the model is now trying to measure. Clearance is the clean case. Price was cut *because*
the item was not selling, so low prices appear alongside low volume and a naive regression can
conclude that cutting price reduces demand.

Four sources of usable price variation, with very uneven coverage:

| Source | Credibility | Coverage |
|---|---|---|
| Deliberate randomized price tests | Highest | A few thousand SKUs; each costs real margin |
| Cost shocks passed through to price | High (a classic instrument, moving price for supply-side reasons) | Wherever clean wholesale cost history exists |
| Bin-boundary discontinuities | High, and free | SKUs near a price-band edge |
| Controlling for what drove the price | Weakest; rests on an untestable assumption | Everything |

The third is worth dwelling on. A SKU crossing a $100 price-band boundary receives a
discontinuously different target margin for a reason unrelated to its own demand. That is a
regression discontinuity sitting in the warehouse already, and it turns the legacy system into
the identification strategy for replacing it.

### Estimate, predict, pool

The strong methods cover a sliver of the catalog; the method that covers everything cannot be
defended. The resolution is to change what is being estimated. Rather than an elasticity per SKU,
the object is a model that predicts elasticity from SKU features, trained on the subset where
elasticity is credibly identified.

1. **Estimate** where variation is credible, using randomized tests, cost shocks and bin
   boundaries. The output is a pair per SKU, an elasticity and its standard error. These are
   training labels.
2. **Predict** elasticity from static features that exist for every SKU on day one, including
   ones that have never sold. This stage never reads the SKU's own price history, or it cannot
   serve the SKUs it exists to serve.
3. **Pool.** Where a SKU has its own credible estimate, shrink between it and the feature-model
   prediction: `ε̂ = w·ε̂_own + (1-w)·ε̂_pred` with `w = τ²/(τ² + se²)`. Tight own-estimate,
   trust it; noisy own-estimate, fall back on the model. The weight sets itself.

This also solves cold start. It is the principled version of what binning was approximating, soft
pooling with a data-driven weight in place of hard pooling with a discontinuity at the bin
boundary.

### Three caveats

Rather than discard the weak estimator, correct it. On SKUs with both randomized and
observational variation, the size of the observational estimator's error is directly measurable.
That correction transfers to SKUs with only observational data, which rescues the only method
that covers the catalog.

Selection compounds the coverage problem. Randomized tests run on SKUs somebody chose, usually
high volume where the test is cheap to power. Elasticity is therefore identified on the head and
applied to the tail — an extrapolation into a region the training data never covered.

An unbiased but noisy estimate is not the safe choice in a decision problem. Taking an `argmax`
over a noisy objective systematically selects wherever the noise happened to look favorable,
which is the optimizer's curse. The Lerner rule is violently unstable near `ε = -1`, so variance
in the parameter becomes catastrophe in the price. The criterion is expected contribution margin
under the resulting policy, not bias of the parameter.

## 4. Features

> Elasticity is a property of the buyer's alternatives, not of the product.

Every useful feature is a proxy for one question. How easily can this buyer get something else
that satisfies the same need? Features that predict how *much* a SKU sells predict the level and
say little about the slope.

The three strongest:

1. **Off-site comparison availability and price gap.** How many retailers carry this exact item,
   and the distance to the cheapest. The substitute set outside the site. A commodity floor lamp
   sold on ten sites is checkable in thirty seconds; an exclusive cannot be checked at all.
2. **On-site substitute density.** Count of near-identical SKUs shown alongside it, the
   substitute set inside the site. The same object later defines the randomization unit.
3. **Traffic composition, exact-model search versus browse.** Whether the buyer arrived knowing
   what they wanted. A behavioral proxy for whether comparison shopping is happening at all.

Also useful are private-label and exclusivity flags, price percentile within category, urgency
versus postponeability, reference-price knowledge, and promotional conditioning. Price point cuts
both ways (expensive items get more deliberation but are also more differentiated), so the sign
is a matter for the model rather than for assertion.

### Data quality

- Stockouts censor demand, and stockouts correlate with price. Cheap things sell out. Left
  unmasked, the model learns that low prices reduce sales.
- Recorded price is not paid price. Coupons, sitewide events and financing offers mean the list
  price is a number no customer faced.
- Cost data is stale and estimated. Wholesale updates lag and freight is usually an estimate.
  `c` enters the optimizer directly, so an error in cost is an error in price with no statistical
  machinery to catch it. That is more dangerous than comparable noise in `ε`, which at least has
  shrinkage protecting it.
- SKU identity is not stable. Dropship suppliers relist items under new IDs, splitting one item's
  price history into fragments too short to fit anything.

## 5. Boundary behavior

Suppose the feature model returns `|ε| < 1` for part of the catalog (customers barely responding
to price).

The Lerner rule requires a margin of `1/|ε|`, and margin cannot exceed 100%, so `|ε| ≤ 1` admits
no finite optimal price. The profit function increases in `p` without bound. Raising price raises
revenue, and falling volume cuts cost. Both terms move the same way. The optimizer does not return
a high price; it runs to the edge of its search range. In closed form, `p* = c·ε/(1+ε)` returns a
negative number at `ε = -0.5`, which is the algebra reporting that no interior solution exists.

The economics says such an estimate is almost never a finding.

> A profit-maximizing firm never operates on the inelastic part of its demand curve.

If demand is inelastic, raising price is strictly better on both revenue and cost, so the price
would already have been raised. An estimate of `|ε| < 1` at the current price is therefore a bug
until proven otherwise. The candidates are noise, censored demand, promotion-only price
variation, or a binding constraint outside the model such as a minimum advertised price or a
deliberate loss leader.

Three layers of fix:

1. **Constrain by construction.** `ε = -1 - softplus(f(x))` cannot emit a degenerate value. This
   does not repair a bad estimate; it converts an unbounded failure into a bounded, visible one.
2. **Optimize expected contribution margin over the elasticity posterior**, rather than plugging
   in a point estimate. The profit function is asymmetric, so uncertainty pulls the recommendation
   back toward the incumbent price without any hand-tuned cap. Where the optimizer cannot produce
   a confident answer, the binned rule is the fallback.
3. **Cap the per-cycle move**, and route anything exceeding the cap to a randomized test instead
   of to production. An extreme model output is an experiment recommendation, not a price
   recommendation. The model generates its own test queue.

As a diagnostic, if the degenerate set concentrates in low-volume SKUs, the shrinkage is too weak
and the bug is in stage 3. If it concentrates in one category, suspect that category's cost or
availability feed.

## 6. Offline evaluation

Cross-validation cannot validate this model. It measures held-out prediction of units, and a
confounded model predicts units well, because it fits all the historical reasons prices moved.
Cross-validation detects variance and overfitting; it is silent on bias, which is the failure
mode that decides whether the system works.

The general problem is **off-policy evaluation**, scoring a new policy on data collected under an
old one. It requires the new policy's actions to appear in the logs with some probability, and a
deterministic binned rule guarantees they do not. Randomized price variation is therefore a
prerequisite for evaluation, not only for estimation.

What can be established before any customer sees a new price:

1. **Backtest on held-out randomized tests.** Fit without them, predict into them, regress
   measured percentage change on predicted. The slope is the headline. A slope of 1.0 is
   calibrated; 0.4 means the model overstates responsiveness by two and a half times.
2. **Calibration by predicted-elasticity bucket.** Establishes *where* the model can be trusted,
   which scopes the launch. A model calibrated between -2 and -4 and unreliable past -6 supports
   a defensible partial rollout.
3. **Disagreement profile against the incumbent.** A risk claim rather than a performance claim.
   It reports what share of the catalog moves more than 5%, which categories concentrate the
   large moves, and what the dollar exposure is if the model is wrong in the worst plausible
   direction.
4. **Simulation against a sealed truth.** Generate a synthetic catalog with known elasticities,
   run the pipeline blind, compare recovered parameters and prices to truth. This validates the
   machinery, not the fit, and it is a one-way test that can condemn an estimator and never
   acquit a model. Its value comes from simulating a world the model does *not* assume, with
   logit demand fit with a log-log model, prices confounded by construction, and stockouts
   introduced deliberately.
5. **Projected lift with a threshold.** State plainly that the projection uses the model's own
   beliefs to score the model, then give how wrong the elasticities would have to be for the lift
   to vanish.
6. **Segment audit.** Where prices rise, and on whom.

Three distinct exercises share the name "offline evaluation" and answer different questions.
Simulation asks whether the method works. Backtest or replay asks what would have happened.
Held-out experiment asks whether the model is right about the real world. Only the third is
evidence about this business.

Offline evaluation is easy when a model predicts and hard when it decides. A forecast does not
change the world; a price does.

## 7. Online validation

The randomization unit follows the intervention. This is not a general rule about clustering.

- Shipping one SKU's price at a time makes own-price elasticity the estimand, so individual SKU
  randomization is correct, provided substitutes are not split across arms. Cutting A's price
  does steal units from B, and that stealing *is* A's own-price elasticity, not contamination of
  it.
- Shipping a category-wide reprice makes the category-level effect the estimand, so the unit is a
  cluster of substitutes, built from the on-site substitute-density feature.
- Where substitute density is low (exclusives, one-of-a-kind items, the long tail), individual
  randomization is correct and far more powerful. Mixed-unit designs are appropriate.

What breaks is substitutes split across arms. Control's depressed sales inflate the
treatment-minus-control difference, and the contamination is largest exactly on the SKUs whose
prices the model most wants to move.

Customer-level randomization is barred only for the posted price. Different posted prices for
different customers is price discrimination. The legal, regulatory and brand exposure ends the
design before any statistical objection is reached. Targeted promotions and coupons are ordinary
retail practice and randomize at the customer level normally.

Two other candidates fail here. Geography fails because pricing is national and regional
differences are detectable and newsworthy. Switchback in time fails because furniture has long
consideration windows, so customers who notice simply wait for the cheap period.

Stratify on the existing bins. They are the natural blocking variable and they yield bin-level
readouts for free. Power is measured in clusters rather than SKUs, with the design effect for
unequal cluster sizes.

A gap in this design is worth stating unprompted. A clean test measures a partial-equilibrium
effect on a few thousand clusters. Shipping moves a third of the catalog, which changes site-wide
price perception and invites competitive response. The measured effect and the shipped effect are
different quantities.

## 8. Production behavior

**Exploration collapse.** The model sets prices, then retrains on the data those prices generated.
Month by month the price variation in the training set shrinks toward whatever the model chose,
and the variation that identified elasticity disappears.

The errors then become self-confirming. A SKU wrongly judged inelastic gets a higher price, and
the resulting low volume at a high price is exactly what that belief predicts. Nothing in the data
contradicts it.

Offline metrics stay green throughout, because they score prediction under the prices the model
itself selected. Rolling back a model version does not help, since the data is contaminated
regardless of which version reads it.

What prevents it:

1. **A permanent randomized exploration budget.** A rotating few percent of SKUs perturbed at all
   times. It costs margin, and that cost is the price of a system that can still learn.
2. **A permanent holdout on the incumbent rule.** A small random set never handed to the model.
   It gives a continuously refreshed answer to whether the replacement is still beating what it
   replaced.
3. **Propensity logging.** Which policy set each price and with what probability. Trivial on day
   one, impossible to retrofit, and the precondition for any later off-policy evaluation.

Monitoring that would catch the collapse covers variance of price changes in the training data
over time, the share of each elasticity coming from own-SKU variation rather than the feature
model, and the holdout gap.

Dashboards miss other twelve-month failures: stale cost data, silent because `c` has no shrinkage
protecting it; competitive response invalidating elasticities measured in an older environment;
supplier response to systematically higher margins; price perception showing up in traffic rather
than in pricing metrics; and the **ratchet**, where a per-cycle move cap combined with a model
that prefers higher prices walks prices upward indefinitely while no single cycle looks wrong.
Catching that requires monitoring cumulative movement from baseline, not movement per cycle.

## 9. Limits

These hold even given a perfect elasticity for every SKU.

| Cannot fix | Why | What to do instead |
|---|---|---|
| **Cannibalization** | The sum of per-SKU optima is not the category optimum, and the full cross-elasticity matrix is unidentifiable at catalog scale | Optimize at category level with a constraint on the average move; measure the gap at category level in the test rather than estimating the matrix |
| **Competitive response** | Elasticity was measured while competitors held still; shipping is a general-equilibrium change | Stage the rollout, keep the incumbent-rule holdout to detect baseline drift, monitor competitor price gaps as a leading indicator |
| **Long-run price perception and LTV** | Margin captured this quarter may cost traffic and repeat purchase over years, and no four-week test sees it | Long-run holdback cohort, plus a threshold: how far repeat-purchase rate would have to fall to erase the gain |
| **Supplier response** | Most inventory is not owned. Systematically higher margins invite cost increases or delisting, so `c` is not exogenous | Monitor cost changes correlated with own price moves; exclude strategic suppliers from aggressive repricing |
| **An incomplete objective** | Per-SKU per-period contribution margin cannot see basket effects, customer acquisition, or assortment breadth, so loss leaders are systematically overpriced | Carve them out and price them to a different rule |
| **Residual confounding** | The exclusion restriction is untestable | Bound it: how large the bias would have to be to flip the decision |

Two things do not belong on this list.

Cold start is solved by the design. A new SKU has every stage-2 feature on the day it is listed.
That is what the feature model is for.

The long tail is not automatically ignorable. Tens of millions of SKUs at small per-SKU
opportunity adds up, and the tail is precisely where the binned rule's error is largest, because
the head is already managed by hand. Size it before dismissing it.

## Sources

- [Wayfair Q1 2026 results](https://investor.wayfair.com/news/news-details/2026/Wayfair-Announces-First-Quarter-2026-Results-Reports-Strong-Share-Capture-and-a-Return-to-Active-Customer-Growth/default.aspx)
- [In Practise — Wayfair's pricing strategy and mature gross margin](https://inpractise.com/articles/wayfairs-pricing-strategy-and-mature-gross-margin)
