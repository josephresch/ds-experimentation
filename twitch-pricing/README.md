# Twitch local subscription pricing test

A simulated pricing experiment run end to end: design, data generating process, power, randomization, A/A validation, health checks, analysis, interference correction, decision memo.

The data is synthetic. The product structure it is calibrated against is public. Twitch sets Tier 1 prices by viewer country, the subscription split is 50/50 or 70/30 under Partner Plus, and subscribers stop seeing ads on the channel they subscribe to. Nothing here is internal to any company.

## The question

Tier 1 costs R$9.90 a month in this market. Commerce wants to cut it to R$7.90 and expects volume to more than cover the discount.

A price cut is a discount to everyone, including the people who would have paid full price. So the question is whether the subscriptions gained cover the money given up on the ones we were going to win anyway.

## What happened

The experiment came back clean, powered, and positive. Net platform revenue per eligible viewer rose 1.38% (95% CI 0.54% to 2.22%, one-sided p = 0.0007), conversion up 37%, midpoint elasticity −1.39, past the break-even value of −1.

The recommendation is still don't ship, for three reasons the headline number does not contain.

The Bits guardrail fails its non-inferiority test. Viewers move spend out of Bits and into the cheaper subscription, and the interval reaches past the 2% margin declared before launch.

Most of the measured gain is channels taking subscriptions from each other. Exposure to treated channels is balanced across arms, so the substitution cancels inside the experimental contrast. It does not cancel at launch, when every channel is cheaper and there is no comparison group left. Correcting leaves about 0.30%.

Shipping reprices the existing subscriber base, which the experiment could not touch. In this market that costs roughly 34 times the corrected acquisition gain. For the base alone to break even, monthly churn has to fall by the same percentage the price fell, implying a churn price-elasticity near 1.0.

The sealed generating parameters, opened in section 19, confirm the estimator recovered the true ITT and that the true launch effect was about a third of what the experiment measured.

## Files

| File | What it is |
|---|---|
| `twitch_pricing_experiment.ipynb` | The whole thing, executed with outputs. Runs top to bottom in about seven minutes. |
| `EXPERIMENT_DESIGN.md` | The design document, written before any data existed. |

## Three things it demonstrates

**The randomization unit is set by the leakage structure of the treatment, and you pay for that choice in variance.** Gift subscriptions let one viewer buy on another's behalf, so treatment moves between units through an ordinary product feature. That forces channel-level clustering, and the design effect that follows is severe because channel sizes are power law. The equal-cluster-size formula understates it badly.

**Pre-treatment triggering is free power. Post-treatment triggering is selection bias wearing the same clothes.** Excluding viewers who were already subscribed roughly triples the detectable signal and is valid because subscription status was fixed before randomization. Filtering on anything measured after assignment would look identical and be worthless.

**A clean, powered, correctly analysed experiment can still be the wrong input to a decision.** Nothing went wrong here. The ITT was the right answer to the question the design could ask, and the wrong answer to the question the business asked.

## Method notes

Randomization is pair-matched on channel size. CUPED on pre-period revenue takes power from 22% to 92% at the same sample size, and the analysis differences within pairs because that is how the assignment was drawn.

The A/A section runs the full pipeline 120 times on a world with no effect. The naive per-viewer t-test declares a winner 45% of the time. That number is why the A/A exists.

Interference is handled by estimating an exposure dose-response inside the control arm, where exposure was randomly assigned by the same coin flips, controlling for portfolio size. Without that control the slope is confounded, because viewers who watch one other channel have exposure of exactly 0 or 1 while viewers who watch ten sit near 0.5.

Heterogeneous effects are shrunk with empirical-Bayes partial pooling. The channel-size quartiles mostly wash out; the casual against engaged split survives. That is what shrinkage is for, separating findings from things that look like findings.
