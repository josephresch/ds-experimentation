# ds-experimentation

Simulated experiments, built end to end. Each folder is one company, one question, one full design and analysis pass: the design document, the data generating process, power work, randomization, health checks, analysis, and a decision memo.

The data is synthetic in every case. Product mechanics are calibrated to publicly documented behaviour so the reasoning transfers. Nothing here is internal to any company.

## Experiments

| Folder | Company | Question | Status |
|---|---|---|---|
| `twitch-pricing/` | Twitch | Does cutting the local Tier 1 subscription price raise net platform revenue? | Design phase |

## Why simulated

Simulation lets you check whether an estimator recovers a known truth. That is the part real experiments cannot give you, since the ground truth is never observed. Every analysis here is run blind against a sealed data generating process, then compared against it at the end.
