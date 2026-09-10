# ds-experimentation

Experiment designs and applied machine learning design studies, worked end to end. Each one
starts from a business decision and follows it through to the thing that would actually be built,
including the parts that do not work.

The data is always synthetic. Product mechanics and financial figures come from public filings
and published benchmarks, so the reasoning transfers. Nothing here is internal to any company.

## Studies

| | Study | Summary |
|---|---|---|
| 01 | [Twitch local subscription pricing test](01-twitch-subscription-pricing.md) | Does cutting the Tier 1 subscription price raise net platform revenue? A full simulated experiment: power, cluster randomization, A/A validation, interference correction, decision memo. Recommendation: do not ship the flat cut. |
| 02 | [Replacing a binned markup rule with product-level price optimization](02-wayfair-pricing.md) | Where a bucketed margin rule leaves money on the table, and what replaces it. Price endogeneity and identification, predict-then-optimize, hierarchical shrinkage across a long tail, off-policy evaluation, exploration collapse. |
| 03 | [Targeting a packaging intervention with a damage-risk model](03-wayfair-returns.md) | Returns cost more than the margin on the sale. Label definition and right-censored label maturity, point-in-time feature correctness, class imbalance and calibration, cost-derived thresholds, treatment-contaminated labels. |


## Layout

Each study sits at the top level for reading. Each company folder holds the full material for
that company.

```
twitch/    README, design document, executed notebook
wayfair/   the two design studies
```
