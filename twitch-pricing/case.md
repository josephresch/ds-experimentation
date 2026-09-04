# Case: Tier 1 price cut

**Prompt:** "Twitch is considering cutting the Tier 1 subscription price in Brazil from R$9.90 to R$7.90. How would you evaluate whether we should do it?"

---

## Intro

Do not ask for context yet and do not start listing metrics. Reframe the question first, because that is what separates you from everyone else answering this today.

> "The thing that makes this hard is that a price cut is a discount to everyone, including the people who would have paid R$9.90 anyway. So the question isn't whether a lower price sells more subs, it obviously does. It's whether the incremental subs cover the money we give up on the ones we were going to win regardless. I'd design around that, and measure it in net revenue rather than subscriber count."

Then one clarifying question, not three:

> "Before I go further, is the objective net platform revenue, or is this a growth play where we'd accept flat revenue to grow the paid base?"

That question does real work. It changes the primary metric, and asking it signals you know objectives are chosen rather than given. If they say revenue, you have your OEC. If they say growth, flip primary to subscriber count, make revenue a non-inferiority guardrail, and say so out loud.

## Time allocation

Forty-five minutes gives you room that thirty does not. Use it on the analysis plan and the threats, which is where the thirty-minute version has to skip. Interviewers interrupt, so treat these as checkpoints rather than a script.

| Minute | Beat | Content |
|---|---|---|
| 0–3 | Reframe, one clarifying question | The inframarginal problem, the objective |
| 3–8 | Metric and population | Net revenue per eligible viewer, pre-treatment triggering, ads cannibalisation |
| 8–18 | Design | Channel randomisation and why, design effect, the recovery levers, duration |
| 18–25 | Analysis plan and health checks | Estimator, pre-registration, what you check before reading the effect |
| 25–34 | The two threats you volunteer | Cross-channel substitution, the existing base |
| 34–41 | Decision rule and recommendation | Five conditions, the alternative you'd propose |
| 41–45 | Their questions, then yours | |

Checkpoints that matter: if you are past minute 18 and have not said "randomisation unit," you are running long and should compress the metric discussion. If you reach minute 25 without having volunteered interference, you have lost the best part of the case.

## Metric and population

Say the metric in one breath, then justify the two non-obvious choices.

> "Primary is net platform revenue per eligible viewer over four weeks. Net, because Twitch keeps 50% on standard channels and 30% under Partner Plus, so the same cut is worth different amounts depending on where the volume lands. Gross subscription revenue would hide that."

Then eligibility, which is cheap to say and lands well:

> "Eligible means viewers who weren't already subscribed when we randomised. They can't respond to a price change on new subscriptions, so leaving them in the denominator adds constant revenue to both arms and dilutes the effect. Subscription status is pre-treatment, so excluding them is free power. What I'd never do is filter on something measured after randomisation, like whether they clicked subscribe, because treatment changes who clicks and the arms stop being comparable."

Pre-treatment against post-treatment filtering is a distinction a lot of candidates get wrong. Stating the rule unprompted is a strong signal.

Then the line that fits this org specifically:

> "Subscribers stop seeing ads on the channel they subscribe to, so every sub we win destroys ad inventory. Commerce's win is partly Ads' loss, and a subscription-only readout would be wrong, not just incomplete. I'd expect the two to partly cancel."

Bits belongs here too, as a guardrail rather than a headline: if viewers have a roughly fixed budget for a channel, some Bits spend moves into the cheaper subscription.

## Design

Lead with the constraint, not the statistics.

> "Channel level. I'd rather randomise viewers because it's far more powerful, but gift subs let one user buy a subscription for another, so treatment leaks between viewers through an ordinary product feature. Mass gifters buy a hundred at a time, so one treated unit can hand treated prices to a hundred control units. Price is also visible in public chat. The unit is forced by how the treatment leaks, and I pay for that in variance."

Then the power consequence:

> "Clustering costs a lot here because channel sizes are power law. The design effect is one plus, in brackets, one plus CV squared times mean cluster size minus one, times ICC. People quote the equal-cluster-size version and badly understate what they need when sizes are that skewed. But that formula assumes simple randomisation and I wouldn't use simple randomisation, so I'd treat it as a starting point and simulate the design I actually intend to run."

At forty-five minutes you have room to walk through the recovery properly, which you would compress at thirty:

> "Three levers, and I'd want to see what each buys. Pair matching on channel size, so most of the between-channel variance is removed before randomisation rather than adjusted for after. CUPED on pre-period revenue, which in this setting correlates around 0.65 with post-period, so it removes over half the variance before I've collected an extra observation. And differencing within pairs, because cluster-robust standard errors don't know about the pairing and come out conservative, which throws away power I already paid for."

If asked for numbers: design effect near ten, and CUPED took power from roughly 20% to 90% at fixed sample size. Do not volunteer those unprompted, they invite arithmetic you cannot verify in the room.

Duration and exclusions:

> "Five weeks. Four measured plus a burn-in I drop, and it has to span a renewal cycle because a subscription price change isn't resolved until the first renewal. I'd exclude channels under about fifty regular viewers, which means the result generalises to channels of enrollable size and not the long tail. That belongs in the readout, not a footnote."

## Analysis plan and health checks

This is the section the thirty-minute version skips. Use it.

> "I'd pre-register the estimator: within-pair differences on channel means, CUPED-adjusted, one-sided against zero. I'd report cluster-robust and unweighted channel means alongside it, and if the weighted and unweighted versions disagree that's not a robustness problem, they're different estimands. Unweighted is the average effect per channel, weighted is per viewer. Both correct, different questions, and the gap tells you the effect varies with channel size."

Health checks, said as a gate rather than a formality:

> "Before I look at the effect: sample ratio mismatch at channel and viewer level, a pre-period placebo where I run the exact analysis on data from before launch and it has to come back null, instrumentation symmetry, and missingness by arm. The placebo is the one people skip and it's the most valuable, because it tests the whole pipeline at once. If health checks fail the experiment isn't read. Not read with caveats."

Directional predictions, made before looking:

> "Watch time must not move, because nothing in the design touches viewing. Ad impressions must fall, because subscribers stop seeing ads. If I can't say in advance which metrics have to move, I don't understand the design."

## The two threats you volunteer

Bring these up before you are asked. This is the part that wins the case.

**Cross-channel substitution.**

> "Viewers watch many channels, and if sub budgets are roughly fixed a treated channel takes subs from control channels. What's interesting is that exposure to treated channels is balanced across arms, so the spillover cancels inside the contrast and the ITT is clean. It doesn't cancel at launch, when every channel is cheaper and there's no comparison group left. So the experiment answers 'what if one channel gets cheaper' and the decision needs 'what if they all do.' Partial versus general equilibrium."

How you would handle it:

> "Cheapest version, bound it: compute from pre-period data what share of control viewers' watch time sits in treated channels. If that's small the bias is small. Better version, estimate a dose-response on exposure inside the control arm, where exposure was randomly assigned by the same coin flips. Portfolio size has to be controlled for, because someone watching one other channel has exposure of exactly zero or one while someone watching ten sits near a half, and those groups differ in every other way. If the decision carried more money, a two-stage saturation design traces the curve instead of extrapolating a line."

**The existing base.**

> "We can only test the price on new subscribers, because nobody reprices an active base mid-flight. But if we ship, the base eventually pays R$7.90 too, which is a guaranteed hit with no volume upside attached, and it's usually larger than the acquisition gain because the installed base exceeds one period of new subs."

Then the move that makes it a finding rather than a shrug:

> "I'd solve for the threshold instead of guessing. In steady state the base is new subs over churn, so cutting price 20% is revenue-neutral only if churn also falls 20% in relative terms. That's scale-free, it doesn't depend on the size of the base. A 20% cut buying a 20% churn reduction implies a churn price-elasticity near one, well above published values. So the burden of proof is explicit, and the experiment that settles it is a retention test on the existing base. Different unit, months rather than weeks, nothing exotic."

## Decision rule and recommendation

> "I'd write this down before launch so nobody relitigates it after seeing numbers. Health checks pass or we don't read it. Primary positive, one-sided at 5%. Guardrails clear non-inferiority against a declared margin, because a large p-value against zero means I failed to detect harm, not that there isn't any, and underpowered guardrails pass by default. The effect corrected for interference. And the full P&L positive once the existing-base term is in. All five, or we hold."

Close with an alternative rather than a no:

> "My prior is acquisition looks good on its own and the decision still comes out negative once base repricing goes in. If that's where it lands, the recommendation isn't 'don't cut price,' it's a discounted first month at full price after. That captures the acquisition elasticity without repricing anyone already paying. Two risks I'd design against: it attracts one-month churners, so read at day sixty not day thirty, and it cannibalises people who'd have paid full price, which is why the holdout has to include viewers who would have converted anyway."

## Mid-case pivots to expect at 45 minutes

Longer cases usually introduce a twist. Three likely ones and the shape of the answer.

**"Results came back at plus 1.5%, significant. Ship?"** Not yet. Walk the interference correction and the base repricing, in that order. The number they gave you is the ITT, and the ITT is not the launch effect.

**"The PM says elasticity is past minus one so revenue goes up."** Concede and narrow. Break-even at minus one is correct about subscription revenue on the units that respond. It says nothing about take-rate mix, the ad inventory destroyed, or the existing base. Agreeing and then showing the claim is about a smaller quantity is stronger than disputing it.

**"What if the effect is flat?"** Then the interesting question is whether you were powered to detect what you cared about. Report the minimum detectable effect and say plainly whether a decision-relevant effect could have been missed. "We could not have detected the effect you're asking about" is a senior answer.

## What to cut

Even at forty-five minutes you cannot properly cover multiple comparisons, heterogeneity and shrinkage, estimator comparisons, the A/A, and Bayesian methods. Naming one and moving on reads as judgment. Working through all of them reads as someone who cannot prioritise.

---

## Optional depth, if there is room or they invite it

One or two of these, not all. Deploy when they ask "anything else you'd think about" or when you have visibly finished early.

**A/A validation.** "I'd run the pipeline on a null world before launch. A naive per-viewer t-test on cluster-randomised data fires on close to half of null experiments. Knowing that number for your own data beats knowing the theory."

**Bayesian, where it earns its place.** "Asymmetric loss. Reversing a price cut churns customers and makes news in a way that never cutting doesn't, so shipping a bad cut costs far more than missing a good one. Null hypothesis testing has no way to express that. A posterior does: expected loss under each action, and report the probability revenue clears break-even rather than a p-value against zero. Also partial pooling on subgroup effects, which handles the winner's curse and gives you numbers you can act on, where a multiplicity correction only tells you which slices to distrust."

Then immediately name where it does not help, because this is what stops it sounding like enthusiasm:

> "Where it gets oversold is peeking. The posterior's interpretation survives optional stopping, but frequentist error rates don't, and if the org cares about false positive rates you still have to simulate them."

**Sensitivity analysis instead of assuming no confounding.** This one pairs well with the interference discussion, and it is the sharpest thing you can say about the non-experimental part of the analysis.

> "There's one piece of this analysis that isn't randomised, and it's the piece that flips the decision. The spillover dose-response is a regression of outcome on exposure with controls for portfolio size and pre-period spend. Exposure was randomly assigned conditional on a viewer's channel portfolio, but I'm leaning on those controls being sufficient, and I can't verify that. So rather than assert unconfoundedness I'd report how strong an unobserved confounder would have to be to overturn it."

Then the mechanism, briefly:

> "Cinelli and Hazlett's framework, which is in the sensemakr package. It gives you a robustness value: the minimum share of residual variation a confounder would need to explain in both the exposure and the outcome to knock the estimate to zero, or to knock it out of significance. And you benchmark that against covariates you did observe. So instead of saying 'I assume no confounding,' the sentence becomes 'a confounder would have to be three times as strongly associated with exposure and outcome as portfolio size is, and I don't find that plausible.' That's a claim someone can argue with, which is the point."

Where else it applies here:

> "It would matter more for the confirmatory step. Once the channel test gives an effect size, the natural rollout is staged by country and read with synthetic control or difference-in-differences, and that is fully observational. A concurrent marketing push in one market is exactly the kind of confounder you can't rule out by design, so I'd report a robustness value alongside the point estimate."

And the connection to the threshold analysis, which shows it is a habit rather than a package you have heard of:

> "It's the same epistemics as the churn threshold I described earlier. In both cases I don't have the number, so instead of assuming one I report how extreme it would have to be to change the decision."

Honest limit, and say it before they do:

> "For the primary randomised comparison none of this is needed. Randomisation handles confounding, and reaching for sensitivity analysis there would be a tell. It's for the parts of the analysis that aren't randomised."

Where this came from is worth a half sentence if it comes up naturally: Chad Hazlett is at UCLA, and the approach is a standard reference point in the causal inference sequence there.

## Failure modes to watch for in yourself

**Opening with clustering.** If your first substantive sentence contains "ICC" or "design effect," you led with the method instead of the question. Reframe the business problem first, every time.

**Statistician framing.** "I'd test whether conversion differs between arms" is weaker than "I'd test whether the incremental subs pay for the discount to everyone else." Same experiment, different room.

**Over-engineering under pressure.** If you feel yourself reaching for graph cluster randomization or a degree-corrected block model, stop. Say the bounding version, then say "and if that number came back ugly, here's where I'd escalate." The escalation path is the impressive part, not the machinery.

**Filling the extra fifteen minutes with volume.** Forty-five minutes is not thirty minutes with more talking. It is thirty minutes plus a real analysis plan and a real threats discussion. If you find yourself elaborating on something you already made the point about, stop and move to the next beat.

**Silence while thinking.** Say what you are weighing. "I'm deciding whether the denominator should be all viewers or only eligible ones, and I think it has to be eligible, because..." Thinking out loud is the product here.
