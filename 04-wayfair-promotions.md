# Targeting a coupon program with an uplift model

A design study for Wayfair, built from public filings and published benchmarks. The internal
system described is a plausible reconstruction rather than a description of Wayfair's actual
architecture.

## Problem

A retailer emails a 10% off coupon to a large share of its customer base every month. The list is
built from RFM scores crossed with a propensity-to-purchase model, taking top scorers plus a lapsed
win-back segment. About 6 million of 21.4 million active customers receive it each month.

Last quarter the program produced 480,000 redemptions, $15 million of discount against roughly
$150 million of attributed revenue. Marketing reports it as 10:1 and the program is considered a
success.

The question is who should be receiving it, and whether the program should exist at the size it does.

## Design tensions

| Tension | How it shows up |
|---|---|
| The target is unobservable in principle | No customer reveals what they would have done without the coupon. One potential outcome per person, always |
| The obvious model targets the wrong people | Predicting `P(purchase)` and sending to high scorers subsidizes customers who were going to buy anyway. The naive model is close to anti-correlated with the right answer |
| Negative effects are real | A discount email can remind a lapsed customer to unsubscribe, or teach a loyal one to wait for the next sale |
| The training data does not exist yet | Uplift cannot be recovered from the observational record, because the targeting model that built the list destroyed the overlap needed to estimate it |
| Standard evaluation is meaningless | No error per row, so no MSE and no AUC on the quantity that matters |
| The action is continuous | Who receives an offer, and how deep, under a budget |
| The objective is contested | Short-run margin against acquisition and reactivation. A coupon that loses money on the order may win a customer |

The honest conclusion is not "retarget it." The winnable segment is likely much smaller than the
business expects, and a large share of the current program should be switched off rather than aimed
somewhere else.

## Framing

The quantity of interest is a treatment effect, not an outcome. That single classification sets the
whole design. An outcome can be labeled and predicted with ordinary supervised learning. A treatment
effect has no label on any row, so the data has to be built before the model can exist, the estimator
has to target the difference rather than the level, and validation can only ever be aggregate.

This case sits alongside two others on the same axis. [Product-level price optimization](02-wayfair-pricing.md)
estimates a structural parameter, never directly observed and requiring an identification argument.
[Damage-risk targeting](03-wayfair-returns.md) predicts an outcome that is observed and labeled. Promotional
uplift is the third case. It is not observed and not observable, not even in principle.

## Public figures

- Q1 2026: net revenue $2.93B, gross margin 30.0%, AOV $312, 9.4M orders delivered, 21.4M active
  customers, LTM net revenue per active customer $591
- Advertising expense $329M, 11.2% of net revenue
- Reported COGS includes inbound and outbound shipping, fulfillment and warehousing, so the 30%
  gross margin is post-logistics and pre-advertising
- Publicly posted coupon depths in the category run roughly 10% to 25% off

## Arithmetic

Let `d` be the discount as a fraction of list price and `m` the gross margin rate.

An incremental redeemer contributes `(m − d)·P` of margin that would not otherwise exist. A redeemer
who would have bought anyway costs `d·P`, margin handed over for nothing. Break-even is

```
i·(m − d) = (1 − i)·d      →      i = d / m
```

**Break-even incrementality is the discount divided by the gross margin.**

| Discount at 30% margin | Share of redemptions that must be incremental |
|---|---|
| 10% | 1 in 3 |
| 15% | 1 in 2 |
| 20% | 2 in 3 |
| 30% | Every one, so never |

Past `d = m` the incremental sale carries no margin itself, and no targeting rescues it.

In dollars at AOV $312, full-price margin is $93.60 and discounted margin $62.40, with $31.20 given away on
every non-incremental redemption. The two outcomes differ by a factor of two, which is why the
break-even sits at one third rather than one half.

Expected value per redemption is `i × 62.40 − (1 − i) × 31.20`. Applied to 480,000 quarterly
redemptions:

| Incrementality | Per redemption | Per quarter |
|---|---|---|
| 20% | −$12.48 | −$6.0M |
| 33% | $0 | Break-even |
| 50% | +$15.60 | +$7.5M |

**The program swings $13.5 million a quarter on a parameter nobody currently measures.** The reported
10:1 ratio is consistent with every point in that range, including losing $6 million.

---

# Design decisions

## 1. Objective and break-even

The unit of account is margin, not revenue. The discount comes entirely out of margin, because COGS
does not move when the price does. Attributed revenue counts every purchase from a session that
touched the promotion, including the ones that would have happened anyway, so it is an upper bound on
incremental revenue and usually a loose one. A 10:1 ratio built from attributed revenue is not
evidence about the program.

Cost scales with redemptions, not with list size. A coupon nobody redeems costs only the email. This
matters for the design. Expanding the list is nearly free, and the expensive failure mode is sending
to people who redeem without being moved.

The objective is not self-evident and is worth establishing before the modeling starts. Reactivation,
acquisition, AOV lift, inventory clearance and competitive defense imply different target populations
and different success criteria. The choice moves the break-even materially. At $591 LTM net revenue
per active customer, a reactivated customer is worth far more than one order, so an
objective that counts reactivation lowers the bar a redemption has to clear.

Negative uplift is an occupied quadrant, not a curiosity. A discount email can remind a lapsed
customer that they are still subscribed, and it can teach a loyal full-price buyer to wait for the
next offer. Both effects are permanent and neither is visible in a redemption count.

## 2. Estimand

A propensity-to-purchase model selects for customers who were going to buy anyway. A high score comes
mostly from base rate, not from responsiveness, so the current list is close to anti-correlated with
the right target. A customer moving from 0.40 to 0.45 scores at the top of the list with 0.05 of
uplift. A customer moving from 0.02 to 0.12 has double the uplift and never appears.

| | Buys if treated | Does not buy if treated |
|---|---|---|
| **Buys if untreated** | Sure things. Uplift zero, pure cost | Sleeping dogs. Uplift negative |
| **Does not buy if untreated** | Persuadables. The only group that pays | Lost causes. Harmless, never redeem |

The estimand is expected incremental margin in dollars:

```
τ_margin(x) = P₁(x) × $62.40 − P₀(x) × $93.60
```

Send when it is positive. Rearranged, that is `P₁(x) / P₀(x) > 1.5`. The coupon must raise this
customer's purchase probability by 50% **relative to their own baseline**, not by 0.50 in absolute
terms. It agrees exactly with `i = d/m` viewed from the individual side. At a ratio of 1.5, one
redemption in three is incremental.

Rank in dollars rather than in the ratio. A ratio of 1.6 on an $800 basket beats 3.0 on a $40 one.
Ranking matters only because of the budget. Unconstrained, the rule is to send to everyone with
positive `τ_margin` and to nobody else.

The treatment is a bundle rather than a price cut. A discount, an email, an expiry date, and a reason to
think about the brand today. Testing the email and the discount separately in a 2x2 is cheap and
answers whether the reminder is doing the work. If it is, the program is paying 10% of margin for a
free notification.

## 3. Training data

Uplift cannot be recovered from the observational record here, and the reason is specific. The coupon
was assigned by a model on observed covariates, which makes unconfoundedness plausible and **destroys
positivity**. The propensity `e(X)` is 1 above the score cutoff and 0 below it. There are no
comparable untreated customers in the treated region, and inverse-propensity weights divide by zero.

> The better the incumbent targeting model, the worse the overlap, and the less the historical data
> can say about what the coupon did.

The diagnostic runs before any estimation. Plot the propensity distributions for treated and
untreated and look for common support. Trimming to the region where both exist leaves a narrow band
around the cutoff, which identifies a local effect at the boundary by regression discontinuity. That
is a legitimate estimate of a different quantity, not the surface the policy needs.

"Never received a coupon" fails for an independent reason. That group is defined by the assignment
rule persistently excluding it, so it differs systematically on exactly the covariates the rule uses.

Carryover is real. Customers conditioned by years of monthly offers behave differently in off months.
Randomization neutralizes it as a confounder rather than removing it, because a holdout drawn from
the treated population shares its conditioning history.

The design is to randomly withhold from the existing send rather than to build a new campaign.

| Arm | Population | What it identifies |
|---|---|---|
| Holdout | Random 5% to 10% of the current 6M, receives nothing | `P₀` inside the targeted region |
| Send-out | Random slice of currently excluded customers, receives the coupon | `P₁` outside it |

Without the second arm the data supports `τ(x)` only where the old model already sends, and the
persuadables it missed stay invisible forever. The unit is the customer. Propensities are known by
design, so the weights carry no estimation error.

**Cost of the experiment, against the objection that randomization is expensive.** A 5% holdout of
6 million customers at a 2.7% redemption rate forgoes about 8,100 redemptions a month, worth
`8,100 × [i × 62.40 − (1 − i) × 31.20]`.

| Incrementality | Monthly effect of the holdout |
|---|---|
| 20% | **Makes** $101,000 |
| 33% | Zero |
| 50% | Costs $126,000 |

Worst case is roughly $378,000 over a quarter to resolve a $13.5 million question. Pricing the
experiment before conceding it is unaffordable is the whole move, and in the pessimistic scenario the
holdout is not a cost at all.

Power is not the binding constraint, since roughly 2,600 customers per arm suffice for the average effect.
**The binding constraint is the outcome window.** A coupon may only pull a purchase forward. Measured
over 30 days that looks fully incremental. Measured over 12 months it is worth nothing. Months 2
through 6 have to be compared against control before any result is believed.

Two SUTVA wrinkles matter. Household contamination, where a treated and an untreated customer share an
address, and code leakage to coupon aggregator sites, which delivers the treatment to the control arm
silently. Single-use codes tied to the customer, specified up front, close the second one.

## 4. Features

> Uplift lives in the gap between wanting and buying, and a coupon only helps when price is what sits
> in that gap.

Browse activity, visits and cart adds are the backbone of any propensity model. Used as levels they
reproduce the list being replaced. The signal is **intent that has not converted**, which is a ratio
or a residual, never a level.

| Family | Features | Why |
|---|---|---|
| Unconverted intent | Cart adds not converted, saved items never bought, repeat views of one SKU, price-drop alerts set, browse-to-purchase ratio | Wanting is established, buying is not |
| Price as the blocker | Share of past orders on promotion, historical discount depth taken, abandoned basket value relative to their own typical order, price gap between items browsed and items bought | Separates "cannot afford this one" from "not interested" |
| Sure-thing markers | Very recent purchase, high recency by frequency, repeated full-price buying, rewards membership | Negative predictors of uplift, positive predictors of purchase |
| Sleeping-dog markers | Long tenure with no promotional response, low email engagement with unsubscribe risk, consistently full-price high-value buying | The quadrant that costs money twice |
| Deal conditioning | Coupons received in 12 months, share of purchases made with one, time since last | Predictive, and a trap. See below |
| Treatment features | Discount depth, expiry, channel, category scope | Required if depth is to be optimized rather than fixed |

The deal-conditioning family carries a specific hazard. A conditioned customer has a depressed `P₀`
because they are waiting for the next offer, so their measured uplift is inflated by pull-forward
rather than by genuine persuasion. **The segment that looks most persuadable may be the one the
program created.** Nothing in the feature set distinguishes the two, which is why the outcome window
in section 3 is load-bearing.

Inferred demographics are legally and reputationally fraught in promotion targeting. Use context
features rather than protected-class proxies, and say so before anyone asks.

## 5. Estimation

Fitting two models, one on the treated and one on the control, and differencing them is the
T-learner. It fails here for a precise reason. Each model minimizes error on the
**level**, while the quantity wanted is the **difference**. Base conversion is around 3% and uplift
is around 1 percentage point, so the signal is 0.01 against per-model error several times larger, and
the two errors compound rather than cancel.

> Model the effect directly. Do not model two levels and subtract.

Seed instability is the diagnostic that separates "no effect" from "no power to see the effect." A
null world produces a *stable* ranking near zero. A ranking that reshuffles across seeds is
fitting noise.

Two non-fixes are worth knowing because they get proposed. Cross-validation does not denoise
predictions and cannot see a quantity that has no per-row label. And a monotone transform cannot
change a ranking, by definition, so recalibrating the two level models leaves the ordering untouched.

| Method | What it does |
|---|---|
| Logistic regression with treatment by covariate interactions | The honest baseline. Interpretable, valid inference, limited by having to specify the interactions in advance |
| Transformed outcome | `Z = Y(W − e) / (e(1 − e))` has `E[Z\|X] = τ(X)` exactly, so any regressor now fits the effect. High variance |
| Causal forest | Splits chosen to maximize heterogeneity in `τ` rather than to reduce outcome error. Honest splitting gives valid intervals |
| X-learner | Built for imbalanced arms, which a 95/5 holdout is |
| Direct policy learning | Skips `τ(x)` and learns the send rule as weighted classification |

The S-learner, a single model with treatment as one more feature, fails differently. Regularization
shrinks a feature that explains little outcome variance, so the model can ignore the treatment
entirely and return uplift of zero everywhere. Feature attribution on the treatment column explains
the model, not the world. Predicting twice and differencing is the minimum repair.

Run the cheap check first. Compare the average effect across a handful of pre-registered segments. If
they agree within noise there is no heterogeneity to model, and the correct deliverable is one global
decision about program size rather than a targeting system.

## 6. Offline evaluation

There are no uplift labels, on a holdout or anywhere, because every customer yields one potential
outcome. Evaluation is therefore **per bucket, not per row**. Within a bucket both arms exist, and
randomization makes their difference unbiased.

**The uplift curve.** On held-out experimental data, score every customer, sort descending by
predicted uplift, and at each depth compute the *observed* treated-minus-control difference among the
top k. Plot cumulative incremental conversions against share of population targeted. A useful model
rises steeply and then flattens. A worthless one traces the diagonal. A model with sleeping dogs at
the top dips below it. The Qini coefficient is the area between the curve and the diagonal.

**The cutoff is not a threshold on `τ`.** Convert the curve to cumulative incremental margin minus
cumulative discount spend. That curve has a maximum, and its argmax is the send depth. The first
question to ask of it is whether the peak is positive at all. If it is not, no targeting rescues the
program and the recommendation is to shrink or stop it.

Calibration by decile, predicted average uplift against observed, is the second check. Ranking
correctly while being wrong about magnitude is entirely possible, and the dollar decision needs the
magnitude, not the order.

**Imbalance.** A 3% positive rate with roughly 180,000 positives a month prompts the standard
resampling suggestion, and it should be refused. The decision needs a probability, not a hard label,
and 3% is not severe. The specific damage here is worse than in a plain classification setting:
resampling preserves the **odds** ratio and not the **probability** ratio, so the `P₁/P₀ > 1.5` rule
that defines the estimand no longer means what it says. Treatment imbalance at 95/5 is a different
problem, and it is what the X-learner addresses.

## 7. Policy validation

Test the policy, not the model. Randomize customers between the incumbent propensity list and the
uplift list **at equal budget**, and compare net contribution per customer.

Per-redemption metrics flatter whichever policy sends less, because a policy that only touches its
best cases has an excellent average and possibly a worse total. The denominator has to be one the
policy does not control, which makes the customer the right unit and net contribution the right
numerator.

Validate the cutoff rather than assuming it transfers from the offline curve. Run two send depths and
confirm the peak sits where the curve said it would.

Keep a permanent holdout so the counterfactual survives launch. Without one, the program returns to
being unmeasurable the moment the experiment ends, which is the state it started in.

## 8. Production behavior

Once the model targets, the treated population stops being random, and the training data for the next
model is contaminated. This is the third variant of one pattern across these studies. Price
optimization narrows its own inputs, damage-risk targeting destroys its own labels, and promotional
targeting changes who is treated.

> Any model whose outputs influence the world that generates its next training set degrades quietly
> unless something is held back from it.

The fix is the same in each case: a permanent randomized holdout, and assignment logging on every
send.

Two decay mechanisms need monitoring rather than a fixed retraining calendar:

- **Deal conditioning deepens** as the program targets responsive customers harder, so measured
  uplift falls over time even if the model is unchanged
- **Pull-forward accumulates**, so short-window gains reverse in later periods, and a metric measured
  at 30 days drifts further from the truth the longer the program runs

Uplift is less stable than propensity because it depends on the whole promotional environment,
including competitors' offers and the retailer's own sitewide events. It needs refreshing more often
than a purchase-propensity model would.

## 9. Limits

Individual treatment effects are never observable, so validation is only ever aggregate. There is no
diagnostic that identifies which individual customers the model got wrong.

The estimand is the effect on a customer base already conditioned by years of monthly coupons, not
the effect on a fresh customer. A program that has trained its audience to wait for offers has
changed the population it is being evaluated on, and the experiment measures the conditioned
population because that is the only one that exists.

Customers also see sitewide events, seasonal sales and competitor promotions. The control condition
is "no targeted coupon," not "no promotion," and the gap between those two is not recoverable from
this design.

Per-order margin cannot see lifetime value. A coupon that loses money on the order may still win a
customer worth $591 a year, and the design measures the order. Bounding that gap requires a
long-horizon holdback, which is a different and slower study.

## Sources

- [Wayfair Q1 2026 results](https://investor.wayfair.com/news/news-details/2026/Wayfair-Announces-First-Quarter-2026-Results-Reports-Strong-Share-Capture-and-a-Return-to-Active-Customer-Growth/default.aspx)
