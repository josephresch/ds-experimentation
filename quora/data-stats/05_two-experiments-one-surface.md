# Case 05, two experiments won, can we ship both

A mock interview for the **Data Stats** round. 45 minutes, talked through, no coding. Claude plays a
Quora data scientist. To practice blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. Feed scale and experiment capacity match
`../private/product.md`.

**Dominant flavor: non-standard experiment designs and setups.** The guide names that phrase explicitly and
nothing else in this folder is built primarily on it. Quora has run roughly 30 experiments at a time since at
least 2016, and the home feed is a single ranked list where every item type competes for the same slots, so
interaction between concurrent tests is structural here rather than hypothetical.

**Why it is product sense forward.** The question "can we ship both" is not answerable from the two test
results. It is answerable from knowing what the two features do to the same scarce resource. Both of these
changes compete for feed slots and for the reader's attention in one session, so the mechanism predicts
sub-additivity before any number is looked at. A candidate who reasons from the product gets to the answer and
then uses the statistics to check it. A candidate who starts from the statistics gets a wide interval and no view.

**The verdict is unusual and worth knowing in advance:** both experiments are individually valid, and neither
licenses shipping both. The resolution is not to estimate the interaction. It is to stop trying to.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide, Data Stats | "Some may involve non-standard experiment designs and setups" | The whole case |
| Prep guide, Data Stats | "Understanding the assumptions and challenges, and proceeding accordingly" | Block 2, where the assumption is additivity |
| Email | "How you decide on the best course of action when there's more than one reasonable path" | Block 4. Factorial, sequential, or bundle test, and the reasoning is the answer |
| Prep guide, what we look for | "Rigor that knows when to stop" | Block 4's resolution is to abandon the harder estimate for an easier sufficient one |
| `../private/product.md`, D'Angelo 2016 | About 2,000 experiments run, about 30 at a time | Why this situation is routine and not a special case |
| `../private/product.md` | The home feed is one ranked list where item types compete for slots | Why interaction is structural |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. What the two results do and don't say | 8 | Framing, product intuition |
| 2. Whether the tests were even valid | 10 | Design, assumptions |
| 3. What the joint cell says | 10 | Reading an estimate |
| 4. What you would do instead | 12 | Design under constraints |
| 5. Your questions | 5 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **Do not reveal the both-on cell until Block 3.** Whether he realizes it must already exist is the single
  best signal in the case, and handing it over kills that.
- If he proposes a factorial design, ask what it costs. Once.
- Push on additivity in Block 1 if he does not raise it himself.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard.

---

## Block 1, what the two results do and don't say

About 8 minutes.

**Interviewer.** "Two teams finished tests on the home feed last month. Both won. Both want to ship. My question
to you is whether we can ship both, and what we'd expect."

> ### Context
>
> **The surface.** The logged-in home feed is one ranked list mixing answers, Space posts, suggested questions
> to answer, and ads. Slots are the scarce resource. About 8.0M logged-in users load the feed in a 14-day window.
> The feed experiment layer allows up to 20% of feed users per test.
>
> **Experiment A, ranking.** A change to how the feed scores stories, promoting stories from topics the reader
> has engaged with recently. 10% treatment, 10% control, 14 days.
>
> **Experiment B, notifications.** A change to the daily notification that pulls readers back into the feed,
> sending it at a personalized time of day rather than a fixed one. 10% treatment, 10% control, 14 days.
>
> **Results.** Primary metric is an index of reader value per user over 14 days, control set to 100.
>
> | Experiment | Treatment effect on the primary | 95% CI |
> |---|---|---|
> | A, ranking | +2.1 | +1.4 to +2.8 |
> | B, notifications | +1.8 | +1.1 to +2.5 |
>
> Both teams ran independently. Assignment for each was random and independent of the other.

**Interviewer.** "Both are clearly positive. If we ship both, do we get 3.9?"

**Listen for.**

- **No, and the reason is mechanism before statistics.** Both changes work by getting more value out of the same
  session. The ranking change makes the feed better once you are there; the notification change brings you there
  at a better time. They compete for the same finite reader attention and the same finite feed slots. So the
  natural expectation is sub-additive: part of what B delivers is readers arriving to a feed that A has already
  improved, and the improvement cannot be collected twice.
- **The specific channel of overlap, named.** If B's effect is partly that readers arrive when they have more time
  and read more, and A's effect is partly that what they read is better matched, then a reader who was going to
  read three stories and now reads four gets A's benefit on four rather than three. That is interaction, and it is
  the ordinary case for two features on the same surface, not an exotic one.
- **What each test actually estimated.** Each estimated its own effect averaged over the world as it was during
  the test, which included roughly 10% of users being in the other test. So each number is an average effect in a
  world where the other change is mostly absent. Neither estimated the effect in a world where both ship.
- Asking whether the two tests overlapped in users at all, which is the door to Block 2.

**Strong signals.**

- Saying that independent randomization keeps each estimate unbiased, and that unbiasedness is not the issue. The
  issue is that the estimand each test targets is not the quantity needed for the decision. That distinction,
  between a valid estimate and a relevant one, is the case in one sentence.
- Predicting the sign of the interaction from the mechanism before asking for any number, and saying how confident
  he is in the sign versus the size. Sub-additive is a reasonable prior; how sub-additive is unknowable from
  mechanism.
- Noticing that a super-additive story is also constructible, and saying why he finds it less likely. If the
  notification arrives when the reader has time and the feed is now worth reading, the two could reinforce. A
  candidate who can argue both directions and then pick has done the reasoning rather than recited a rule.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Both were properly randomized. Isn't each effect valid?" | Each is valid for what it measured, which is its effect in a world where the other change basically doesn't exist. Shipping both creates a world neither test observed. The estimates aren't biased, they're answers to a question nobody is asking now |
| "Give me your best guess at the joint effect." | Somewhere between 1.8 and 3.9, and I'd guess nearer 3 than 3.9, because both work through the same session and the same slots. But that's a guess from mechanism and I wouldn't put it in a plan without checking |
| "Could shipping both be worse than shipping one?" | It's possible and I think unlikely here. It would need genuine interference, for instance if the better-timed notification brings people in at a moment the ranking change serves badly. Worth checking by segment rather than assuming away |
| "Which would you ship if you could only ship one?" | A, on these numbers, and the gap is inside the noise so I wouldn't lean on it. I'd want the cost and reversibility of each, since a ranking change is easier to roll back than a notification schedule people have adjusted to |

**Model answer.** "I wouldn't expect 3.9, and the reason is about the product rather than the statistics. Both of
these work by squeezing more value out of the same session. A makes the feed better once you're in it, B gets you
there at a better time. They share the reader's attention and they share the feed's slots, so part of what B
delivers is people arriving at a feed A has already improved, and that improvement can't be banked twice. I'd
expect sub-additive, so somewhere around 3, though I'd be more confident about the sign than the size. The other
thing worth being precise about: both tests were properly randomized, so both estimates are unbiased. What they're
unbiased for is each change's effect in the world that existed during the test, where the other change was absent
for about 90% of users. Shipping both creates a world neither test observed. So this isn't a validity problem,
it's a mismatch between the estimand each test targeted and the quantity we now need."

**Traps.**

- Adding the effects.
- Declaring the tests invalid. They are valid. This is the most common wrong turn.
- Reaching for interference and SUTVA vocabulary without saying what the shared resource actually is.
- Arguing only for sub-additivity, with no consideration that the opposite is possible.

**Score.** 4 adds the effects, or calls the tests invalid. 6 says the effects may not add and names a shared
resource. 8 distinguishes unbiased from relevant, predicts the sign from mechanism while conceding the size is
unknown, and can argue the super-additive case before rejecting it.

---

## Block 2, whether the tests were even valid

About 10 minutes.

**Interviewer.** "You said both tests are valid. Convince me. They were running at the same time on the same
surface with no coordination."

**Listen for.**

- **Why independent randomization is enough for each main effect.** If assignment to A is independent of
  assignment to B, then B's treatment is balanced across A's arms and vice versa. So B's presence adds variance to
  A's comparison but does not shift its mean. Each test's average effect is unbiased over the distribution of the
  other test's arms. That is the whole argument and it should be stated cleanly, because it is the thing most
  candidates get wrong in one direction or the other.
- **Where it would break.** If the two tests shared a layer that forced mutual exclusivity, or if assignment to
  one depended on the other, or if one test changed who was eligible for the other. A candidate should ask whether
  the feed experiment layer is shared and whether the two tests were orthogonal or exclusive by configuration,
  because the answer determines whether the joint cell exists at all.
- **The variance cost.** Running concurrent tests adds noise to every test, because some of the outcome variation
  comes from other treatments. It does not bias anything and it does widen intervals, which matters when 30 tests
  run at once.
- **The genuine threat that is not about the two tests.** Both touch the same feed slots. If one test's treatment
  changes the pool of content available to the other, through shared popularity or ranking signals, that is real
  interference and it is not solved by independent randomization. On a feed where treated users' engagement feeds
  back into what everyone sees, some leakage is expected, and the honest answer is that it is usually small and
  worth checking rather than assumed away.

**Strong signals.**

- Distinguishing three things that get confused: independent randomization, mutual exclusivity, and interference.
  The first makes main effects unbiased. The second is a configuration choice that destroys the joint cell. The
  third is a property of the product that neither of the first two fixes.
- Saying that the variance penalty is the actual everyday cost of 30 concurrent tests, and that it is one reason
  the earlier tests on this surface came back inconclusive.
- Asking whether both tests' control groups were the same users. If the platform holds a shared control, the two
  control groups overlap and the two estimates are correlated, which matters if anyone wants to compare A against
  B rather than each against control.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "If concurrent tests are fine, why do platforms ever force exclusivity?" | Because sometimes you can't render both treatments at once, or the combination is known to be nonsense, or the product needs a clean read for a launch decision. It's a deliberate trade: exclusivity buys a clean comparison and destroys the ability to learn anything about the combination, and it costs traffic |
| "Does the other test's noise matter at these sample sizes?" | At 800,000 per arm, not much for a 2% effect. It matters when you're chasing something small, and it's part of why a surface with 30 live tests produces more inconclusive results than the sample sizes suggest |
| "Was there interference between them?" | Independent randomization handles the assignment side. What it doesn't handle is that both change what gets engaged with, and engagement feeds ranking, so treated users shift the content pool that control users see. That's usually small. The check is whether A's effect looks different among users also in B, which is the same data I'd need for the interaction anyway |

**Model answer.** "Each main effect is fine, and the argument is short. Assignment to A was independent of
assignment to B, so B's treatment is balanced across A's arms. That means B adds variance to A's comparison but
doesn't move its mean, and each test's effect is unbiased averaged over whatever the other test was doing. Three
things get confused here and I'd keep them apart. Independent randomization, which is what makes the main effects
valid. Mutual exclusivity, which is a configuration choice that would have made both tests cleaner and destroyed
any chance of learning about the combination. And interference, which is a property of the feed rather than of
the assignment: both changes affect what gets engaged with, engagement feeds ranking, so treated users shift the
content pool everyone sees. That last one isn't fixed by randomizing independently, and it's usually small, and
the way to check is to look at whether A's effect differs among people also in B. The real everyday cost of 30
concurrent tests isn't bias, it's variance, and that's part of why tests on this surface come back inconclusive
more often than the sample sizes would suggest."

**Traps.**

- Concluding the tests are contaminated and should be rerun.
- Claiming concurrent tests bias each other.
- Conflating mutual exclusivity with independence.
- Missing that feed interference is a separate issue from concurrent assignment.

**Score.** 4 says the tests are contaminated, or that concurrency biases them. 6 gives the balance argument
correctly. 8 separates independence, exclusivity and interference, names the variance cost as the real price of a
busy surface, and proposes the check.

---

## Block 3, what the joint cell says

About 10 minutes.

**Interviewer.** "Suppose I told you the assignment was orthogonal, not exclusive."

**Listen for, before anything else.** He should realize immediately that **the both-on cell already exists**. With
independent 10% assignments, roughly 1% of feed users got both changes. The data to estimate the interaction has
been sitting there the whole time and nobody looked. A candidate who says that unprompted has had the best moment
available in this case.

**Release once he asks for the four cells.**

> Primary metric index, control 100.
>
> | Cell | Approximate users | Index |
> |---|---|---|
> | Neither | 6.4M | 100.0 |
> | A only | 0.72M | 102.1 |
> | B only | 0.72M | 101.8 |
> | Both | 0.08M | 103.1 |
>
> Standard error of each cell mean, in index points: 0.354 for the large cells. The both-on cell is much smaller
> and its own standard error is correspondingly larger; for this exercise treat the interaction's standard error
> as 0.71.

**The arithmetic.**

| Quantity | Value |
|---|---|
| Main effect of A | +2.1 |
| Main effect of B | +1.8 |
| Naive sum | +3.9 |
| Observed both-on | +3.1 |
| Interaction estimate | -0.80 |
| 95% CI on the interaction | -2.19 to +0.59 |

**Listen for.**

- **Reading the interaction interval for what it fails to exclude.** The point estimate says sub-additive by 0.8,
  which matches the mechanism. The interval runs from -2.19 to +0.59. The lower end is close to complete
  substitution, meaning B adds almost nothing on top of A. The upper end is mild synergy. So the data cannot
  distinguish "shipping both gets us 1.9" from "shipping both gets us 3.9," which is the entire range of practical
  interest. The estimate is directionally consistent with the mechanism and useless for planning.
- **The power arithmetic, and it should be automatic.** In a balanced two-by-two, the main effect contrast puts
  weights of plus and minus one half on four cell means and the interaction contrast puts weights of plus and minus
  one. So the interaction's standard error is twice the main effect's, which means four times the sample for the
  same size effect. And an interaction is usually smaller than the main effects it sits between, so if it is half
  the size you need sixteen times. That is why nobody powers for interactions and why the joint cell here is tiny.
- **Not over-reading the point estimate.** +3.1 looks like a clean answer and it carries the both-on cell's own
  large uncertainty. A candidate who reports "we'd get 3.1" has read the table and not the intervals.

**Strong signals.**

- Saying the interaction estimate is worth having anyway, because it rules out the catastrophic case. The interval
  does not reach far enough negative to suggest shipping both is worse than shipping one, which is a real and
  useful conclusion even though it cannot pin the size.
- Noticing that the both-on cell being 1% of traffic is not an accident of this case but a structural feature of
  orthogonal assignment: the joint cell is the product of the two allocations, so it is always the smallest and
  always the least powered. Wanting a bigger joint cell means deliberately over-allocating to it, which is a design
  choice available in advance and almost never taken.
- Being precise that this is the interaction on the additive scale, and that sub-additivity on an index can be an
  artifact of the scale if effects are multiplicative. Checking whether the numbers are closer to additive in logs
  is a cheap and legitimate move, and saying it without making it the centerpiece is the right weight.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "The both-on cell says 3.1. Can we plan on 3.1?" | Not as a point. It's the best estimate and its interval is wide enough that the honest planning range is roughly 1.9 to 3.9. If the plan works at 1.9 we're fine either way, and if it needs 3.5 we don't have the evidence |
| "Why is the interaction so much noisier than the main effects?" | Because of how the contrasts are built. Main effects average two cells against two; the interaction differences two differences, which doubles the standard error. Four times the sample for the same effect size, sixteen if the interaction is half as big. Plus the joint cell here is only 1% of traffic, since it's the product of two 10% allocations |
| "So was running them orthogonally a mistake?" | No, it was the right default and it's the reason we have any joint evidence at all. Exclusive assignment would have given cleaner main effects and zero information about the combination. The mistake, if any, was not deciding in advance that we'd want to read the joint cell, because then we'd have over-allocated to it |
| "Would a log scale fix the sub-additivity?" | It might reduce it, and I'd check, because if the effects are multiplicative then additive sub-additivity is partly a scale artifact. I wouldn't lead with it, because the planning question is on the raw metric and the interval is too wide either way |

**Model answer.** "The first thing is that if assignment was orthogonal, the both-on cell already exists. Ten
percent times ten percent is about 1% of feed users who got both, so the evidence has been there the whole time.
Looking at the four cells: A alone is 2.1, B alone is 1.8, naive sum 3.9, and both together 3.1. So the
interaction is minus 0.8, sub-additive, which is what the mechanism predicted. The problem is the interval, which
runs from minus 2.19 to plus 0.59. The bottom end is near-complete substitution and the top is mild synergy, so
the data can't separate 'both gets us 1.9' from 'both gets us 3.9,' which is the whole range anyone cares about.
That's not a surprise once you look at how the contrast is built: main effects average two cells against two,
the interaction differences two differences, so its standard error is twice as large and it needs four times the
sample for the same effect size, sixteen if the interaction is half the size of the main effects. And the joint
cell is the product of the two allocations, so it's always the smallest cell. What I'd take from it: the sign
agrees with the mechanism, the size is unresolvable, and it does rule out the case where shipping both is worse
than shipping one, which is worth knowing."

**Traps.**

- Not realizing the joint cell exists, and having to be told.
- Reporting +3.1 as the planning number.
- Treating the wide interval as a reason to conclude nothing.
- Presenting the scale point as the main finding.

**Score.** 4 needs to be told the joint cell exists, or reports 3.1 as the answer. 6 computes the interaction and
reads its interval. 8 realizes the cell exists unprompted, does the four-times power arithmetic from the contrast
weights, and extracts the one conclusion the wide interval does support.

---

## Block 4, what you would do instead

About 12 minutes.

**Interviewer.** "Both teams are waiting. What do we do?"

**Listen for the reframe, which is the point of the case.** Nobody needs the interaction. The decision is whether
to ship the pair. So test the pair against control directly: one arm with both changes on, one arm with neither,
sized for the joint effect of roughly 3 index points rather than for an interaction of roughly 1. That is a far
easier test. On these standard errors the bundle contrast against control has a standard error of about 0.50 and a
z of about 6, so it is comfortably powered where the interaction is hopeless.

| Option | What it costs | What it answers |
|---|---|---|
| Estimate the interaction properly | Four to sixteen times the traffic of a main-effect test | How much the two features overlap. Nobody needs this |
| Ship both, watch the metric | Nothing, and no counterfactual | Whether the metric moved, confounded with everything else that shipped |
| Ship sequentially, measure each | Two waiting periods, and the second read is against a base the first one moved | Each increment, slowly |
| **Test the bundle against control** | One short test, easily powered | Exactly the decision on the table |

**Listen for.**

- **Choosing the bundle test and saying why it is easier.** The interaction is the hard quantity and it is not the
  decision-relevant one. Substituting an easier sufficient question for a harder complete one is the
  "rigor that knows when to stop" criterion in its purest available form.
- **Naming what the bundle test gives up.** It will not tell you how the two features interact, so if either is
  later changed or rolled back you learn nothing about what happens to the other. That is an acceptable trade and
  it should be stated rather than glossed.
- **Handling the sequencing question honestly.** Shipping A then measuring B against the new base is a legitimate
  alternative and it answers a slightly different question, namely B's incremental effect given A. If the plan is
  to ship A regardless, that is exactly the right question and the bundle test is unnecessary. So the choice
  between them depends on whether A is already decided, and asking that is the strongest move in the block.
- **A forward-looking process fix.** With 30 tests live on one surface, this situation recurs. The cheap policy is
  that any two tests on the same surface expected to ship together get flagged in advance and a joint cell is
  deliberately over-allocated. That costs almost nothing when planned and is impossible to retrofit.

**Strong signals.**

- Asking whether A is already a foregone conclusion, and letting that determine the design rather than picking a
  design first. If A ships regardless, the only open question is B given A, and the test is B against control
  inside an A-on world.
- Proposing a short holdout after launch rather than a full test, if the teams are time-pressured: ship both to
  most traffic, keep a small neither-cell for a few weeks, and read the pair against it. It answers the same
  question, it costs less delay, and its weakness is that it is no longer a clean pre-launch decision.
- Saying plainly that the bundle test does not need to be long, because the joint effect is large relative to the
  noise, and giving the rough z to show it.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Both teams will say they already won. Why another test?" | They did win, individually, and neither test observed the world we're about to create. It's one short test on a large effect, so it's days rather than weeks, and it replaces a planning number that currently has a range of 1.9 to 3.9 |
| "Could we just ship both and watch the metric?" | We'd see the metric move and we wouldn't know by how much or because of what, since other things ship every week. If we're going to do that, the cheap fix is to hold out a small control for a few weeks so there's something to compare against |
| "What if A is going to ship no matter what?" | Then the interaction was never the question and neither is the bundle. The question is B's effect given A, and the test is B against control with A on for everyone. That's cheaper than either option I just described, and I'd want to know that A is decided before I design anything |
| "Give me the policy change." | Any two tests on the same surface that might ship together get flagged at design time, and the joint cell gets deliberately over-allocated rather than left as the product of two allocations. It's free if you plan it and impossible afterwards |

**Model answer.** "The thing I'd stop doing is trying to estimate the interaction. Nobody needs it. The decision
is whether to ship the pair, so I'd test the pair: one arm with both on, one with neither, sized for a joint
effect around 3 rather than for an interaction around 1. On these standard errors that's a z of about 6, so it's
days not weeks, where the interaction would need four to sixteen times the traffic. What it gives up is that we
learn nothing about how the two overlap, so if either gets rolled back later we're blind about the other, and
that's a trade I'd take. Before designing it though, I'd ask one question: is A shipping regardless? Because if
it is, the interaction and the bundle are both beside the point, and the only live question is B's effect given A,
which is a cheaper test still. And whichever way this goes, the process fix is worth more than the test: with 30
experiments live on one surface this will happen again, so any two tests that might ship together should be
flagged at design time and the joint cell deliberately over-allocated. That's free in advance and impossible to
retrofit, which is exactly the situation we're in now."

**Traps.**

- Designing a properly powered factorial. It is the textbook answer and it is four to sixteen times the cost for a
  quantity nobody needs.
- Shipping both with no counterfactual.
- Not asking whether A is already decided.
- No process fix, on a surface running 30 concurrent tests.

**Score.** 4 proposes a powered factorial, or ships both and watches. 6 proposes the bundle test against control.
8 also asks whether A is already decided and lets that pick the design, names what the bundle test gives up, and
proposes the advance-flagging policy.

---

## Block 5, your questions

About 5 minutes. Not scored.

- "How many experiments are usually live on the home feed at once, and are they orthogonal or
exclusive by default?"
- "Has the team ever gone looking for the joint cell of two concurrent tests?"
- "When two teams both want to ship into the same surface, who decides and on what evidence?"
- "How often does a launch get sized on the sum of two separate test results here?"

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| Framing an open-ended question | | |
| Design and assumptions | | |
| Reading an estimate | | |
| Design under constraints | | |
| Product intuition | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Framing | Adds the two effects | Says they may not add, names a shared resource | Distinguishes unbiased from relevant, predicts the sign from mechanism, can argue the other direction first |
| Design and assumptions | Calls the concurrent tests contaminated | Gives the balance argument for independent assignment | Separates independence, exclusivity and interference, and names variance as the real cost of a busy surface |
| Reading an estimate | Reports the both-on cell as the answer | Computes the interaction and reads its interval | Realizes the joint cell exists unprompted, derives the 4x from the contrast weights, extracts the one supportable conclusion |
| Design under constraints | Powered factorial, or ship and watch | Bundle test against control | Asks whether A is already decided and lets that choose, names the trade, proposes the advance-flagging policy |
| Product intuition | Treats it as a statistics puzzle | Knows both features share the session | Derives sub-additivity from feed slots and attention before seeing any number |
| Communication | Method first, no verdict | Clear recommendation | Recommends abandoning the harder estimate, and says why that is the rigorous choice rather than the lazy one |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he realize the both-on cell must exist, or did it have to be revealed?
- Did he add the two effects at any point?
- Did he propose a powered factorial before arriving at the bundle test?
- Did he ask whether A was already decided?

| Block | Target | Actual |
|---|---|---|
| 1. What the results say | 8 min | |
| 2. Were the tests valid | 10 min | |
| 3. The joint cell | 10 min | |
| 4. What to do instead | 12 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Bank status for this folder

| Case | Dominant flavor | Main lesson | Verdict shape | Status |
|---|---|---|---|---|
| `01_search-traffic-shock` | Observational | Prediction and inference want different specifications; decompose before attributing | "About half, and the assumption carries it" | Written |
| `02_sizing-logged-in-growth` | Estimation | The deliverable is the sensitivity and the binding assumption, not the point estimate | "A range, and go measure one parameter" | Written |
| `03_offline-ranker-audit` | Offline evaluation | Offline scoring rewards agreement with the incumbent; it can rule out, not rule in | "Don't trust it; buy the data with an exploration slice" | Written |
| `04_writer-churn-model` | Statistical models | At this event count the causal question is not identified; prediction and inference need different reframes | "The question can't be answered; here's the one that can" | Written |
| `05_two-experiments-one-surface` | Non-standard design | Orthogonal tests are individually valid and jointly uninformative; substitute an easier sufficient question | "Both valid, neither licenses the pair; test the bundle" | Written |

Uncovered premises, if a sixth is ever wanted: a metric movement with no launch attached, diagnosed from scratch;
a switchback design where users cannot be split; and a test whose result reverses after the novelty period, where
the question is which read to trust.
