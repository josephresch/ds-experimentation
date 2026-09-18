# ds-experimentation

Experiment designs and applied machine learning design studies, worked end to end. Each one
starts from a business decision and follows it through to the thing that would actually be built,
including the parts that do not work.

The data is always synthetic. Product mechanics and financial figures come from public filings,
product documentation and published benchmarks, so the reasoning transfers. Nothing here is internal
to any company.

## Studies

| | Study | Summary |
|---|---|---|
| 01 | [Twitch local subscription pricing test](01-twitch-subscription-pricing.md) | Does cutting the Tier 1 subscription price raise net platform revenue? A full simulated experiment: power, cluster randomization, A/A validation, interference correction, decision memo. Recommendation: do not ship the flat cut. |
| 02 | [Replacing a binned markup rule with product-level price optimization](02-wayfair-pricing.md) | Where a bucketed margin rule leaves money on the table, and what replaces it. Price endogeneity and identification, predict-then-optimize, hierarchical shrinkage across a long tail, off-policy evaluation, exploration collapse. |
| 03 | [Targeting a packaging intervention with a damage-risk model](03-wayfair-returns.md) | Returns cost more than the margin on the sale. Label definition and right-censored label maturity, point-in-time feature correctness, class imbalance and calibration, cost-derived thresholds, treatment-contaminated labels. |
| 04 | [Targeting a coupon program with an uplift model](04-wayfair-promotions.md) | A monthly coupon program reported as 10:1 may be losing $6M a quarter. A target with no label on any row, positivity destroyed by the incumbent targeting model, uplift curves and budget-constrained send depth, pull-forward and deal conditioning. |
| 05 | [Allocating scarce exposure across a long-tail catalog](05-wayfair-underperforming-products.md) | "Which products are underperforming" is the wrong question on a catalog where the median SKU sells zero. Exposure-confounded labels, count models with an offset, a learned prior with a conjugate update, Thompson sampling over a scarce resource, and why the catalog cannot be evaluated. |
| 06 | [Validating a home feed ranking model online](06-quora-feed-ranking.md) | A ranking model with better offline numbers makes the feed worse. Weighted-sum scoring where the improved prediction is the weakest signal, a replay label dominated by one action, mix shift toward cheap engagement, novelty decay, a guardrail read through its interval rather than its p-value. Recommendation: keep the model, change what the score rewards. |
| 07 | [Growing answer supply with suggested-question cards in the feed](07-quora-answer-prompts.md) | Recruiting writers out of the reading audience works, and the answers land on questions nobody reads. Valued supply against raw supply, a per-answer average split into reach and quality, user against question randomization, the first-answer response rate that decides whether a new writer returns. Recommendation: fix the question selection, then rerun. |
| 08 | [Cutting email frequency for readers who stopped opening](08-quora-digest-frequency.md) | Moving dormant subscribers from a daily digest to a weekly one costs visits now and saves reach permanently. A fading cost against a compounding one, unsubscribes as a short-run metric that tracks the long run, a projection carried by its break-even, shared deliverability the test cannot claim. Recommendation: launch with a holdout, and a longer window for recent openers. |
| 09 | [Putting an instant AI answer in the question-asking flow](09-quora-instant-answers.md) | A deflection feature removes a quarter of posted questions on purpose. Which questions it removes, per-question metrics that compare different populations once the mix moves, duplicates priced against new pages, error rates highest where the answer helps least. Recommendation: launch for factual questions only, and keep the post action prominent when nothing matches. |
| 10 | [Reducing sign-up friction on the topic selection step](10-quora-signup-friction.md) | A faster sign-up step reports a 15% retention gain that is not there. A sample ratio mismatch traced to a start event logged at render, a fetch slow enough to remove visitors from the count and from the funnel, three different estimates of one effect. Recommendation: fix the logging and the fetch, then rerun. |


## Layout

Each study sits at the top level for reading. Each company folder holds the full material for
that company.

```
twitch/    README, design document, executed notebook
wayfair/   the four design studies
quora/     the five experiment studies
```
