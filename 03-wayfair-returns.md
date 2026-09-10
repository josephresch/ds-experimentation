# Targeting a packaging intervention with a damage-risk model

A design study for Wayfair, built from public filings and published benchmarks. The internal
system described is a plausible reconstruction rather than a description of Wayfair's actual
architecture.

## Problem

About one in five items shipped by an online furniture retailer comes back. On large-parcel
furniture a single return costs more in reverse logistics than the gross margin on the sale, and
roughly a third of returns are transit damage rather than a customer changing their mind.

The question is what to build.

## Design tensions

It is the structural opposite of the price optimization study in this repository. There the target,
own-price elasticity, was unobservable, and the standard supervised toolkit was silent on the
quantity that decided whether the system worked. Here the target is observable and labeled.
Cross-validation works, AUC means something, and hyperparameter tuning is a real activity.

The skill the problem exercises is knowing which of those two worlds you are in, and then using
ordinary machinery well rather than reaching past it.

| Tension | How it shows up |
|---|---|
| The obvious metric is worthless | ~80% of orders are kept, so "never returned" scores 80% accuracy |
| The label is harder than it looks | Return, transit damage, refund without return, replacement, partial return. And it matures over 30 days, which silently poisons any recent-data training set |
| The decision sets the threshold | A false positive suppresses a good order. A false negative eats $165. The ratio comes from the P&L, not from 0.5 |
| Leakage is everywhere | The warehouse holds post-hoc fields (support contacts, refund flags, disposition codes) that do not exist at scoring time |
| The intervention changes the label | Act on the score and the outcome you would have observed stops happening |
| The obvious application is the wrong one | Blocking or surcharging risky orders suppresses revenue on a probabilistic guess. The applications worth building route to root causes |

## Public figures

| | |
|---|---|
| Online furniture return rate | ~22.7% (range 19–23%); bedding and bath 21.3%, home decor 19.4%; all-category online average 19.3% |
| Stated return reasons (multi-select) | size or space mismatch ~58%, color and material appearance gap ~44%, transit damage ~31% |
| Cost of one large-parcel return | $55–$108 all-in, midpoint ~$72–80. Roughly half reverse freight, a quarter damage write-down, a quarter handling and inspection |
| Reverse logistics on bulky items | 100–150% of the original outbound delivery cost |
| Apparel return, for contrast | ~$30 |
| Q1 2026 operating figures | AOV $312, gross margin 30.0%, 9.4M orders delivered, net revenue $2.93B |
| Return window | ~30 days for most items, varying by category |

## Arithmetic

Gross margin on a kept order: `0.30 × $312 ≈ $94`.

A returned order costs that $94, refunded, plus $72–108 of reverse logistics, plus any
write-down. The swing is $165–200 per large-parcel return.

> One prevented return is worth roughly the margin on two additional orders.

At 9.4M orders a quarter, one percentage point off the return rate is ~94,000 returns × ~$165 ≈
$15M a quarter, roughly $60M a year.

The $72–108 figure is large-parcel. Small-parcel returns are far cheaper, so a blended figure
across the catalog is lower, and the number above is the upper end.

---

# Design decisions

## 1. Decision the score feeds

A risk score with no decision attached is a dashboard. The decision determines the unit, the
label, the threshold and the metric, so it has to be settled first.

Returns here are largely preventable, and that is the business case. Size or space mismatch runs
at ~58%, color and material gap at ~44%, transit damage at ~31%. Almost none of that is a customer
changing their mind. It is information failure and logistics failure: wrong dimensions in the
listing, photos that do not render a fabric, one supplier's inadequate packaging, a carrier lane
that breaks things.

That reorders the candidate applications by value:

| Decision | Cost of being wrong in each direction |
|---|---|
| Fix the listing (dimension callouts, room view, swatches, door-clearance tooling) | FP: engineering time on a fine listing. FN: continue absorbing $165 returns |
| Fix the supplier (packaging specification, chargeback, delisting) | FP: damage a commercial relationship over noise. FN: the defect keeps shipping |
| Route differently (protective packaging, white-glove delivery, a different lane) | FP: ~$40 of handling. FN: ~$165. Roughly 4:1, and that ratio *is* the threshold |
| Assortment (drop SKUs with negative return-adjusted margin) | FP: delist a profitable item. FN: sell at a structural loss |
| Cost input to pricing | A continuous cost error, with no threshold at all |

Pricing for returns means accepting the return and charging everyone else for it. A five-point
error in a SKU's return rate moves effective cost roughly $25 on an $800 item, about a 3% price
error. Preventing the return saves $165. Prevention dominates pricing by an order of magnitude.

Blocking or surcharging risky customers' orders is worth naming so it can be rejected. It
suppresses revenue on a probabilistic guess, and it is a hostile customer experience.

One fork determines the model. A score feeding a *cost estimate* needs calibration and has no
threshold. A score feeding an *intervention* lives or dies on the threshold, and precision, recall
and operating points become the whole conversation. These are different systems.

The rest of this document takes the packaging and routing intervention, which has the cleanest
cost matrix.

## 2. Grain and scoring moment

The scoring moment follows the intervention, and the reason to score late is information, not
compute.

At browse time the system does not know quantity, basket composition, ship-to address, delivery
method, carrier, delivery season, or box count. Apartment versus house matters enormously for
furniture, and those fields are among the strongest predictors. Every hour of delay enriches the
feature set.

Compute is negligible for a tree model at order volume. Browse-time scoring is expensive for a
different reason. Page views outnumber orders by two or three orders of magnitude, and browse
scoring is *synchronous*, sitting in the render path with a sub-100ms budget, where order-time and
fulfillment-time scoring are batch-friendly.

Feasibility is a design input, not a validation step. The question is not only what is known at a
given moment but whether the action can be executed there, and that splits the catalog.

| | Per-order intervention | Consequence |
|---|---|---|
| Retailer-warehoused inventory | Feasible, because the retailer controls pick, pack and ship | Order-level model, scored between order and fulfillment |
| Dropship, the majority of the catalog | Not feasible per order. The item is picked in the supplier's warehouse on the supplier's systems, and packaging is a contractual specification agreed in advance | SKU- or supplier-level model feeding standing rules |

The catalog therefore splits into two systems at two different grains. The remainder of this
document describes the order-level system.

The alternative grain deserves a note. A SKU's return count is the sum of its orders' outcomes, so
`returns ~ Binomial(orders_shipped, p_sku)`. Poisson is the approximation valid when `p` is small,
and at a 20% return rate it is not, so beta-binomial is the appropriate family if modeling counts
directly. But the stronger reason to model at order level is that every covariate that matters
(destination, season, customer history, carrier lane, box count) lives there.

> Model at the finest grain the decisions and features support, then aggregate. Never the reverse.

An order-level model aggregates to a SKU-level expected count. A SKU-level count model cannot be
disaggregated.

## 3. Label

The label must be the outcome the intervention can change. If the action is protective packaging,
training on *all returns* means 58% of the positive class is size mismatch, which packaging cannot
fix. The model would flag orders that are risky for the wrong reason and spend $40 preventing
nothing.

So `y = 1` if a damage claim or damage-coded return is filed within the return window.

**Eligible population:** delivered orders whose label window has fully closed. Pre-ship
cancellations and lost-in-transit shipments are excluded, because the denominator is orders that
*could* have been returned. One caveat: lost-in-transit and damaged-in-transit share causes, so
excluding losses sheds some signal about the mechanism being modeled.

### Label maturity

The return window is roughly 30 days from delivery. An order delivered ten days ago carries `y = 0`
in the database, and that zero is not yet true. It is *censored*.

Build the training table naively and recent orders are systematically labeled negative, the model
learns that recent means safe, and anything correlated with recency (a new SKU, a new supplier, a
new carrier lane, a seasonal shift) receives a spuriously low risk score. If the holdout is the
most recent slice, the test set is the most contaminated part of the data.

The fix is to admit only rows where `delivery_date + return_window + claim-processing buffer ≤ today`.
That has a consequence worth stating. The freshest usable training data is permanently 30–45 days
stale, so the model is structurally behind on drift.

Two refinements. A survival or time-to-event framing uses the censored rows rather than discarding
them, which matters when a month of data is a lot of data. And a faster-maturing label, damage
reported within 14 days of delivery, halves the lag, provided it is validated as a proxy for the
30-day outcome.

### Outcome table and label noise

Derive many labels from one outcome table. Store per-order outcome, reason codes, claim type and
timestamps, and make each binary label a view. The five decisions in section 1 need different
labels, and hard-coding one into the pipeline means rebuilding it for the second stakeholder.

The label is also self-reported. Damaged items get kept out of hassle, get returned under "changed
my mind" because that flow is easier, and some claims are opportunistic. The label is a noisy proxy
for a physical event nobody records.

**Working base rate:** ~20% return rate × ~31% of returns citing damage ≈ 6% of delivered orders,
call it 5–8%. Reason codes are multi-select and damage claims can occur without a return, so it is
a range.

## 4. Features and leakage

The check that mechanizes this is a question to put to every column. What timestamp does the value
carry, and is it strictly before the moment of scoring?

| Column | Verdict | |
|---|---|---|
| `longest_dimension_cm`, `weight_kg`, `box_count` | Safe | Static product attributes, and probably the strongest damage predictors |
| `sku_historical_damage_rate` | Depends | Safe only computed as-of-order-date on a trailing window. As-of-today it includes this order's own outcome |
| `customer_lifetime_return_count` | Depends | Same point-in-time requirement |
| `carrier_id`, `origin_dc`, `destination_zip3` | Depends | Destination is known at order time; carrier is often not assigned until fulfillment |
| `cs_contact_count_for_this_order` | Poison | Post-outcome. Support contacts happen because something went wrong, very nearly a copy of the label |
| `days_in_transit` | Poison | Not known until delivery |
| `supplier_id`, `supplier_defect_rate` | Depends | Point-in-time |
| `product_avg_review_rating`, `review_count` | Depends | A damaged delivery produces a bad review, so the current value partly encodes the outcome |
| `discount_pct_applied` | Safe | Known at order time |

Four of those rows are the same bug. An aggregate feature has to be computed as of the order
timestamp rather than as of now. The bug survives code review, it inflates offline metrics, and it
is the reason feature stores exist.

The taxonomy worth keeping distinct:

| Type | What it is |
|---|---|
| Direct target leakage | The feature is a function of the outcome |
| Point-in-time leakage | A legitimate feature computed with information from after the scoring moment |
| Train/serve skew | Present at training time, absent or computed differently at serving time |
| Group leakage | The same entity appears in both train and test, so the model memorizes |

A distinction here is easy to collapse. "Might not predict well" and "must not be in the model"
are different objections. The first is answered by the model, because a weak feature costs almost
nothing and a gradient-boosted tree requires no monotone relationship, so a feature with no clear
sign is not defective. The second is answered before training, and no amount of validation will
catch it.

## 5. Model class and imbalance

A 6% positive rate with six figures of positives prompts a standard suggestion. Resample, or
synthesize minority examples, so the classes are balanced.

The premise deserves rejecting. "Otherwise the model will just predict the majority class"
describes hard labels at a 0.5 threshold. This pipeline never uses hard labels, because the
threshold comes from the cost matrix. And 6% is not severe imbalance. Severe is 0.1% or 0.01%.

Resampling destroys calibration, which is the one property this model must have, because the score
feeds a cost calculation. Downsample negatives tenfold and the model believes the base rate is 40%.
Every probability is inflated and the cost threshold becomes meaningless.

> Put the cost asymmetry in the decision threshold, not in the training loss.

The loss should estimate `P(y | x)` honestly. Costs change. Freight rates move, an intervention
gets cheaper, someone renegotiates packaging. Costs in the threshold are a configuration edit.
Costs in the loss are a retrain.

The build calls for a point-in-time-correct baseline (SKU historical damage rate, or logistic
regression) that must be beaten and reported; gradient-boosted trees on plain binary log loss with
no resampling and no positive-class weighting; a calibration check on held-out data with isotonic
or Platt scaling if it has drifted; tuning on log loss or directly on expected cost at the
operating point; and the threshold from the cost matrix.

On the metrics side, accuracy is uninformative, and F1 is a poor substitute because it weights
precision and recall equally, an arbitrary assumption that is unnecessary when the cost ratio is
known. F1 is a confession that you do not know your cost ratio.

### When the imbalance toolkit applies

Unequal classes is not itself a problem. Two different problems hide behind the phrase:

- Too few positives in absolute count, a sample-size problem wearing a ratio costume. Resampling
  adds no information. Duplicating 200 positives fifty times still carries 200 positives of
  information.
- An objective that ignores the minority class. This is real when optimizing accuracy. A proper
  scoring rule, class weights, or a moved threshold answers it.

The diagnostic, in order:

1. How many positives, in absolute count? Under roughly 1,000, this is a small-data problem
   and the remedies are different: cut features toward ~10 events per predictor, regularize
   harder, pool across related groups, or use a denser label.
2. Does the decision need a probability or a ranking? A probability feeding an expected value
   means never resample and never reweight. A capacity-constrained ranking makes calibration moot
   and reweighting harmless.
3. Is the ratio extreme enough that compute binds, under 1%? Then downsample negatives for
   speed and recalibrate analytically. Keeping fraction `r` of negatives gives
   `odds_true = odds_model × r`.

| Tool | When it is right |
|---|---|
| Downsample negatives | Extreme ratios, for compute, with mandatory recalibration |
| Oversample / SMOTE | A few hundred positives, continuous low-dimensional features. Nonsense on categoricals, because interpolating two carrier IDs produces a carrier that does not exist |
| Class weights | Ranking-only decisions where calibration does not matter |
| PR-AUC | Useful under rarity when the cost ratio is unknown, and ROC-AUC flatters under imbalance |
| F1 | Only when a cost ratio is unobtainable |

Reweighting and threshold-moving are the same intervention applied in different places. Weighting
by `w` maps `odds → w·odds`, a monotone transform, so thresholding a reweighted score is exactly
equivalent to thresholding the original at a different cutoff. Applying both double-counts the
correction. The right ordering is threshold first (free and exact), then model capacity, then
reweighting, then synthetic sampling, and it reflects that each step costs something the one above
does not.

## 6. Threshold and offline evaluation

The threshold comes from the cost matrix, and it depends on how effective the intervention is:

```
p × $165 × e  >  $40      →      p* = 40 / (165 × e)
```

| Effectiveness `e` | Threshold |
|---|---|
| 1.0 | 0.24 |
| 0.5 | 0.48 |
| 0.3 | 0.81 |

Equivalently `p* = C_FP / (C_FP + C_FN)` = `40 / (40 + 125)`, since a false negative costs $165 but
the $40 would have been spent anyway. Effectiveness is the most uncertain input and it moves the
threshold more than any modeling decision.

### Reading results

A worked example, at a base rate of 6% and a threshold of 0.24:

| | Model | SKU-rate baseline |
|---|---|---|
| Accuracy | 94.1% | 94.0% |
| ROC-AUC | 0.78 | 0.71 |
| PR-AUC | 0.19 | 0.11 |
| Precision @ 0.24 | 0.21 | 0.14 |
| Recall @ 0.24 | 0.34 | 0.22 |

Every machine-learning metric improved. Convert to money:

| Per 100,000 orders | |
|---|---|
| True positives caught (0.34 × 6,000) | 2,040 |
| Orders flagged (2,040 / 0.21) | 9,714 |
| Intervention cost (9,714 × $40) | −$388,600 |
| Damage avoided (2,040 × $165) | +$336,600 |
| **Net** | **−$52,000** |

Break-even precision is `40/165 = 0.242`. At 0.21 the program loses money.

There is a second finding in the same number. A calibrated model thresholded at `t` must have
precision at least `t`. Every flagged order has `p ≥ t`, so the realized positive rate among
flagged orders cannot be lower. Precision below the threshold is proof of overconfidence. The bad
economics is a symptom. Miscalibration is the disease.

The threshold is a decision variable rather than a given. The deliverable is a net-savings curve as
a function of threshold, with the maximum marked and its sign stated — not a single
precision-recall pair.

### Calibration

A model is calibrated if, among orders scored at `p = 0.30`, about 30% come back damaged. Platt
scaling fits a two-parameter logistic on the score. Isotonic regression fits a non-decreasing step
function, more flexible and hungrier for data. Both are fit on a held-out calibration set the model
never trained on, so the split is train / calibrate / test.

Both are monotone, so ranking and AUC are unchanged and at a fixed rank cutoff nothing moves at
all. What changes is which orders clear a given probability. Recalibrating an overconfident model
flags fewer orders at higher precision. That is a correction, not a recall-for-precision trade.

Diagnose with a reliability diagram and summarize with Brier score or expected calibration error.

### Splitting

Random k-fold is wrong twice over. It is wrong temporally, because it trains on the future, and it
is wrong through group leakage, because the same SKU, supplier and customer land on both sides and
the model memorizes SKU-specific damage rates.

| Split | Question it answers |
|---|---|
| Time-based, respecting the maturity buffer | How will this perform next month? The default |
| Rolling origin | The same, with variance on the estimate rather than one number |
| Grouped by SKU | How does it perform on SKUs never seen? Relevant because new SKUs have no history |

Finally, break performance out by category, supplier, carrier and price band. A model excellent on
case goods and useless on upholstery is two products, and only one of them is worth shipping.

## 7. Online validation

The estimand is `e`, the intervention's effectiveness. That is the one quantity offline data
cannot produce, since historically nobody intervened. There is no prior model to compare against,
and the status quo is no intervention at all.

Randomize only among flagged orders. Below threshold, both arms receive nothing, so those orders
carry no information about `e` and add noise to the net-contribution estimate. This is the same
triggering principle that set the label denominator.

Power is not the constraint. Among flagged orders the damage rate is ~24%, and detecting `e = 0.5`
means 24% → 12%:

```
n ≈ 16 × (0.18 × 0.82) / 0.12²  ≈  165 per arm
```

Even a feeble `e = 0.15` needs about 2,100 per arm. At this order volume that is a rounding error.

The binding constraint is label maturity. Deliver, wait 30 days for the window, wait for claim
processing. So the design is short enrollment and a long wait, enrolling heavily for two weeks and
reading out at week eight. The calendar, not the sample, sets the duration.

Because power is nearly free, equal allocation is wrong. Power fixes the control arm's absolute
size, and the remainder goes to treatment, so the ratio is an output, not an input. Each control
order costs roughly `0.24 × $165 ≈ $40` in expectation, which makes control the expensive arm, an
inversion of the usual asymmetry where the new treatment is the risky one. Unequal allocation does
cost efficiency. An 80/20 split raises the standard error of the difference by 1.25×, paid for
with volume that is free.

Stratify on predicted-probability decile, not only on category. That is where the heterogeneity
lives, and it estimates `e` as a function of `p`, which tests the threshold rather than merely the
intervention.

Guardrails have to relate to the intervention: delivery time, fulfillment cost overrun, support
contact rate. Product rating will not move, because packaging does not change the product. Measure
"missing parts" claims as a secondary. Better packaging plausibly helps there too.

On sequential monitoring, the case-specific answer is stronger than either the naive prohibition or
the standard alpha-spending answer. An early look is nearly uninformative because the outcome has
not happened yet. Thirty days of immature labels is the reason not to peek.

Order-level randomization here is SUTVA-clean. Packaging one order does not affect another, and
that is unusual enough to be worth stating. The one exception is capacity. If protective packaging
stock or white-glove slots are scarce, heavy treatment volume degrades service on control.

## 8. Production behavior

The intervention destroys its own training signal. Treated high-risk orders stop getting damaged.
The next retrain reads that feature profile as low-risk, predicted probabilities fall, fewer orders
clear the threshold, and the flag rate declines. Fewer interventions means fewer prevented damages
and shrinking savings.

Offline metrics stay stable throughout, because the model is being graded against a world it
created. It predicts the now-suppressed outcomes accurately, and its ranking is still correct on
data where the treatment already happened.

This is a distinct failure from the pricing system's exploration collapse. There the model narrowed
the *inputs*, so the variation that identified the parameter disappeared. Here the features vary
normally and the *label* is contaminated by the treatment.

Two fixes, required together:

1. A permanent untreated holdout, a random slice of flagged orders never treated. Those are the
   only uncontaminated labels, and they give a continuous re-estimate of `e`.
2. Model the treatment explicitly, with a treatment indicator as a feature, so the model learns
   `P(damage | x, untreated)`, which is what the decision needs. This requires variation in
   treatment at a given `x`, which requires the holdout.

A second mechanism is that the cost inputs go stale. If intervention cost moves from $40 to $70,
the threshold moves from 0.24 to 0.42 and the flag rate falls. Someone has to own the $40 and the
$165, and something has to alert when they change. In most systems they are hard-coded and quietly
wrong.

Monitoring is all leading indicators, because label maturity blinds the system for 30 days or more.
Watch score distribution over time, which is the monitor that catches the collapse; flag rate as a
first-class tracked metric; feature drift, null rates and batch-job freshness SLAs on the
point-in-time aggregates; the share of scores served from cold-start fallback; and train/serve skew.

On that last one, log the served feature vector and train on logged features rather than on
recomputed history. That eliminates skew by construction.

## 9. Limits

These hold even given a perfect, calibrated untreated damage probability for every order.

| Cannot fix | What to do instead |
|---|---|
| **Coverage of the reason mix.** Damage is ~31% of returns. Size mismatch at 58% and color at 44% are larger, and packaging is irrelevant to them | Separate projects with separate labels. Expect interaction effects. A listing-accuracy fix changes the denominators and shifts measured `e` |
| **The label is self-reported.** Claims are observed, but damage is not. Under-reporting and opportunistic reporting are invisible and may differ by segment | Threshold analysis: how far reporting rates would have to differ by segment to flip the decision |
| **`e` is an average over unlike mechanisms.** Packaging helps impact and abrasion and does nothing against a forklift through a pallet | Estimate `e` by damage category where reason codes allow, and accept the residual |
| **Dropship coverage.** Per-order intervention is impossible for most of the catalog | Standing SKU and supplier rules there, and a smaller addressable base |
| **The objective does not price the customer.** $165 is the P&L cost, and it does not carry the three-week wait and the broken sofa | Long-run holdback on repeat purchase, plus a threshold on how far repeat rate must fall to change the answer |
| **Supplier leverage.** Correctly identifying a dropship supplier's packing defect is not the same as getting it changed | Route to category management as a commercial action rather than an engineering one |
| **The band-aid problem.** Wrapping a fragile product better makes a bad SKU economically viable, which removes the pressure to fix the design or the supplier | Report prevented-damage spend per SKU as a cost of carrying it, so it surfaces in assortment review |

A useful test for this list is that anything fixable by collecting more data and adding it to the
feature store does not belong on it.

## Sources

- [Wayfair Q1 2026 results](https://investor.wayfair.com/news/news-details/2026/Wayfair-Announces-First-Quarter-2026-Results-Reports-Strong-Share-Capture-and-a-Return-to-Active-Customer-Growth/default.aspx)
- [Furniture and home return rate benchmarks](https://eightx.co/blog/average-furniture-and-home-return-rate-benchmarks)
