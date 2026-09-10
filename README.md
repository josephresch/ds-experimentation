# ds-experimentation

Experiment designs and applied machine learning design studies, worked end to end. Each one
starts from a business decision and follows it through to the thing that would actually be built,
including the parts that do not work.

The data is always synthetic. Product mechanics and financial figures come from public filings
and published benchmarks, so the reasoning transfers. Nothing here is internal to any company.

## Studies

| | Study | What it is about |
|---|---|---|
| 01 | [Twitch local subscription pricing test](01-twitch-subscription-pricing.md) | Does cutting the Tier 1 subscription price raise net platform revenue? A full simulated experiment: power, cluster randomization, A/A validation, interference correction, decision memo. Recommendation: do not ship the flat cut. |
| 02 | [Replacing a binned markup rule with product-level price optimization](02-wayfair-pricing.md) | Where a bucketed margin rule leaves money on the table, and what replaces it. Price endogeneity and identification, predict-then-optimize, hierarchical shrinkage across a long tail, off-policy evaluation, exploration collapse. |
| 03 | [Targeting a packaging intervention with a damage-risk model](03-wayfair-returns.md) | Returns cost more than the margin on the sale. Label definition and right-censored label maturity, point-in-time feature correctness, class imbalance and calibration, cost-derived thresholds, treatment-contaminated labels. |

Studies 02 and 03 are deliberately opposite. In the first the target is an unobservable
structural parameter and the standard supervised toolkit is silent on the quantity that decides
whether the system works. In the second the target is observable and labeled, and the ordinary
machinery is exactly right. Knowing which situation you are in is most of the problem.

## Layout

Each study sits at the top level for reading. Each company folder holds the full material for
that company.

```
twitch/    README, design document, executed notebook
wayfair/   the two design studies
```

## Method

Pick a company and a decision, then design the scenario to force the most instructive choices
rather than the most realistic ones. The good ones share a few properties. The randomization unit
is forced by the product rather than chosen. The obvious metric moves in a direction that does
not answer the business question. One team's win is another team's loss inside the same P&L. And
something the decision needs is structurally unmeasurable, so it gets a threshold analysis
instead of a guess.

For experiments, the design document is written and frozen before any data exists. Then the
notebook, built against a sealed set of generating parameters and checked against them at the
end. Design studies stop at the design, and say so.

## Why simulated

Simulation lets you check whether an estimator recovers a known truth. That is the part real
experiments cannot give you, since the ground truth is never observed. Every analysis here is run
blind against a sealed data generating process, then compared against it at the end.

It is a one-way test. It can condemn an estimator and it can never acquit a model.
