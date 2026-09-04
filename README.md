# ds-experimentation

Simulated experiments, built end to end. Each folder is one company, one question, one full design and analysis pass: the design document, the data generating process, power work, randomization, health checks, analysis, and a decision memo.

The data is synthetic in every case. Product mechanics are calibrated to publicly documented behaviour so the reasoning transfers. Nothing here is internal to any company.

## Experiments

| Folder | Company | Question | Status |
|---|---|---|---|
| `twitch-pricing/` | Twitch | Does cutting the local Tier 1 subscription price raise net platform revenue? | Complete. Recommendation: do not ship the flat cut. |

## How a case is built

Pick a company and a product area, then design a scenario that forces the most instructive decisions rather than the most realistic ones. Good scenarios share a few properties: the randomisation unit is forced by the product rather than chosen, the naive metric misleads, one team's win is another team's loss inside the same P&L, and something the decision needs is structurally unmeasurable by the experiment.

The design document is written and frozen before any data exists. Then the notebook, built against a sealed set of generating parameters and checked against them at the end. Then the interview synthesis.

## Why simulated

Simulation lets you check whether an estimator recovers a known truth. That is the part real experiments cannot give you, since the ground truth is never observed. Every analysis here is run blind against a sealed data generating process, then compared against it at the end.
