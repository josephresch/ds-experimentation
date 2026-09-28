# Case 06, we are about to put a target on this

A mock interview for the **Data Metrics** round. 45 minutes. Claude plays a Quora data scientist. To practice
blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. The declining trend is consistent with
`01_engagement-metric-audit.md`, where logged-in weekly actives fall from 12.0M to 8.0M over six quarters.

**What makes this case different from 01 to 05.** All five of those are retrospective. A metric exists, it has
been running, and the work is to find out what it has been doing. This one is prospective: the metric has not
carried a target yet, and the question is what will happen to it when it does. That is the sentence in the
guide the other cases treat as background, and it is the whole of this one:

> "Metrics are important at Quora in order to measure success and hold teams accountable."

The Goodhart reading the guide asks for is a theory of what happens to a metric under an incentive. Every
earlier case diagnoses a metric after that has already happened. This one asks him to predict it, which is
harder and is the thing a data scientist is actually consulted about.

**Why it is product sense forward.** Predicting what a team will do to hit a number is not a statistical
exercise. It requires knowing what levers that team has, which are cheap, and which are cheap *and* invisible.
That is product and organizational reasoning, and the arithmetic in Block 3 only becomes useful once it is done.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide, Data Metrics | "Metrics are important at Quora in order to measure success and hold teams accountable" | The premise |
| Prep guide, how to prepare | "Read up on why metrics fail: Goodhart's law, and the ways measuring performance by numbers backfires" | Block 2, worked forward rather than backward |
| Prep guide, how to prepare | The a16z "16 metrics" pieces, "though the interview digs deeper into one fairly complex metric" | Block 1. Weekly returning readers is exactly the kind of number those pieces warn looks like retention and may not be |
| Prep guide, Data Metrics | "Re-evaluate the metrics to make sure that they are holding up" | Block 4, as a standing policy rather than a periodic review |
| Glassdoor 2019, via `../private/final-round-reports.md` | "If your metric is x, how do I know if it is good or bad?" | Block 3 is that question in its hardest form: not is the level good, but is the target achievable or noise |
| `../private/product.md`, D'Angelo 2016 | Roughly 30 experiments running at once, quarterly goals on Quora | Block 2's levers, and why definition drift is a live risk |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. The metric, before anyone is paid on it | 8 | Metric evaluation |
| 2. War-game the levers | 11 | Predicting behavior under an incentive |
| 3. Can you even set a target | 10 | Benchmarking, rigor |
| 4. The policy that protects it | 11 | Accountability |
| 5. Your questions | 5 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **Do not release the eight quarters of history until Block 3**, and only when he asks for the metric's past
  behavior. Whether he asks before agreeing a target is the central assessment of the case.
- In Block 2, if he lists levers without ranking them by cheapness, ask "which of those would they actually do
  first?" once.
- Do not signal whether the target is reasonable.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard. Criteria match cases 01 to 05.

---

## Block 1, the metric, before anyone is paid on it

About 8 minutes.

**Interviewer.** "We're about to put a team's quarterly goal on a metric for the first time. I want your read
before we commit."

> ### Context
>
> **The metric.** Weekly returning readers. The count of logged-in users who had at least one session in each
> of two consecutive weeks. Reported weekly, averaged over the quarter.
>
> **The team.** The engagement team. Their levers are notifications, the digest email, the home feed's
> composition, and onboarding.
>
> **The proposed goal.** Weekly returning readers up 8% by the end of the quarter.
>
> **Why this metric.** The team argued it is closer to genuine retention than weekly actives, because it
> requires someone to come back rather than merely to appear.
>
> **What it currently carries.** Nothing. It is reported and no goal has ever been set on it.

**Interviewer.** "Is this a good metric to hold a team to?"

**Listen for.**

- **What it measures and what it does not.** It requires a return, which is genuinely better than a single-week
  count. It says nothing about whether the return was worth anything. Eight seconds after a notification
  satisfies it identically to a twenty-minute reading session, so the metric is indifferent between the two
  outcomes a reader would not be indifferent between.
- **It is a count, not a rate, and that cuts both ways.** A count cannot rise by shedding light users, which is
  the failure that wrecked VA/WAU in case 01, so this is a real improvement. But a count can rise through
  acquisition, which is a different team's work, so the engagement team can be credited or blamed for something
  it does not control.
- **The window is two weeks, which is the cheapest thing in the product to move.** Anything that gets somebody
  to open the app once in week two counts. Notifications and email are exactly that, and they are the team's
  primary levers, so the metric and the cheapest lever are almost the same thing.
- **The composition problem, unprompted.** The quarter's number is heavily determined by who was already active
  when it started. A team can front-load acquisition or reactivation in the first two weeks and coast, because
  those users then have eleven weeks to keep satisfying the two-week condition.
- Asking who can change the definition of a session. This is the question that determines whether the metric
  can survive being a target at all, and it comes up in `01_engagement-metric-audit.md` too.

**Strong signals.**

- Saying the metric is better than weekly actives and still not safe to target, and treating those as separate
  judgments. A good metric and a good target are different things and the case turns on that.
- Noticing that "returning" and "valuable" have been quietly equated. The team's own justification is that it
  requires coming back, which is true, and coming back is a proxy for having got something out of it, which is
  the assumption doing the work and which nothing here tests.
- Asking what the metric did over the last several quarters before saying whether 8% is sensible. If he asks
  here rather than in Block 3, credit it and hold the data until Block 3 anyway.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "It's better than weekly actives. Isn't that enough?" | It's better and better isn't the same as safe to pay someone on. It's a count so it can't be gamed by losing light users, which is the main thing wrong with a per-user average, and it's indifferent between a genuine session and an eight-second bounce off a notification, and the team's cheapest lever is notifications |
| "What would you want alongside it?" | Something that makes the return mean something. Session depth or a dwell-qualified read on the returning visit, so a return that was worth nothing doesn't count the same as one that was. And notification volume plus mute and unsubscribe rate, because that's the lever they'll reach for first |
| "Who should own the definition of a session?" | Not the team being measured. If the engagement team can decide what counts as a session while being held to a count of sessions, the number isn't holding them to anything, and that's true even if nobody intends to game it, because definitions drift when there's a reason for them to |

**Score.** 4 calls it a good or bad metric without distinguishing metric from target. 6 identifies that it is
indifferent to the quality of the return and that notifications are the cheap lever. 8 also credits the count
over a rate for a stated reason, raises the composition problem, and asks who owns the definition.

---

## Block 2, war-game the levers

About 11 minutes.

**Interviewer.** "Assume we set it. The team has a quarter and a number. Walk me through what they do."

**Listen for.** The levers, ranked by how cheap they are, with the mechanism for each. A candidate who lists
without ranking has not answered the question, because the prediction is about what a team does *first*.

| Rank | Lever | Why it is cheap | What it costs |
|---|---|---|---|
| 1 | More notifications and more digest email | Directly produces a session in week two, requires no product work, and is entirely within the team's control | Mute and unsubscribe rates, which are permanent. An unsubscribe is not recoverable next quarter |
| 2 | Reactivation campaigns to dormant users | A dormant user who returns twice counts the same as a genuine regular | Mostly a one-time stock draw. The pool of reachable dormant users empties and the following quarter is harder |
| 3 | Front-loading the quarter | Users activated in weeks one and two have eleven weeks to keep qualifying | Nothing visible. This is the cheapest and least detectable of all |
| 4 | Lowering the effective bar for a session | An instrumentation or definition change, possibly with an honest reason | Everything, and it is invisible unless the definition is frozen |
| 5 | Feed changes that raise return rates | Actual product work | Slow, uncertain, and competes with other teams for feed slots |

**Strong signals.**

- **Getting the ranking right, and specifically that the genuine product work is last.** Not because the team
  is cynical but because it is the slowest and least certain path to a number due in twelve weeks. That is the
  Goodhart mechanism stated correctly: the incentive does not make people dishonest, it makes the cheap lever
  rational.
- **Naming front-loading as the most dangerous one.** It is the only lever on the list with no visible cost and
  no obvious signature, and it produces a quarter that looks like success and leaves the next quarter worse.
- **Noticing that the first two levers borrow from the future.** Unsubscribes are permanent and the dormant pool
  is finite, so a quarter hit this way makes the following quarter harder, which means the metric under a target
  degrades over time rather than staying neutral.
- **Not accusing the team.** The framing matters. A candidate who presents this as the team cheating will not be
  listened to; one who presents it as what any reasonable team does under a twelve-week deadline will be. The
  guide describes a culture of rational decision making, and this is what rational looks like under that
  incentive.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "You're assuming they'd game it." | I'm assuming they'd do the cheapest thing that works, which is what I'd do. Notifications produce a week-two session reliably and a feed improvement might not land inside the quarter. That's not gaming, that's a rational response to a deadline, and it's why the incentive has to be designed rather than just the metric |
| "Which of those would worry you most?" | Front-loading, because it's the only one with no visible cost. Notifications show up in mute rates and reactivation shows up in the dormant pool emptying. Front-loading just looks like a good quarter, and the bill arrives after the review |
| "So don't set targets?" | No, set them with the guardrails attached and the definition frozen. A metric with no target doesn't get anyone's attention, which is its own failure. The problem isn't targets, it's targets without the three or four things that stop the cheap levers |
| "What if they just do the product work?" | Then they probably miss, and that's the part I'd want understood before we commit, because a target the honest path can't reach teaches the team that the honest path doesn't pay |

**Model answer.** "I'd rank them by cost to the team rather than list them, because the prediction is about what
they do first. Cheapest is notifications and email, which produce a week-two session directly, need no product
work, and are entirely theirs. Second is reactivation of dormant users, because a dormant user who comes back
twice counts identically to a regular. Third, and this is the one I'd worry about most, is front-loading the
quarter: anyone activated in the first fortnight has eleven weeks to keep satisfying a two-week condition, so
the incentive is to spend early and coast. Fourth is the definition of a session drifting, which may happen for
an honest reason and is invisible unless we freeze it. Last is the actual product work on the feed and
onboarding, which is last because it's slow and uncertain and might not land inside twelve weeks. I want to be
careful how I say this, because it isn't an accusation. Any reasonable team facing a twelve-week deadline does
the cheap reliable thing first, and I'd do the same. The reason it matters is that the first two borrow from the
future, since an unsubscribe is permanent and the dormant pool is finite, so a quarter hit this way makes the
next one harder. And front-loading is the dangerous one precisely because it has no signature. It just looks
like a good quarter."

**Traps.**

- An unranked list.
- Presenting it as the team behaving badly.
- Missing front-loading, which is the least obvious and the most damaging.
- Not noticing that the first two levers deplete a finite resource.

**Score.** 4 lists levers with no ranking or mechanism. 6 ranks them and identifies notifications as first.
8 also names front-loading as the invisible one, notes that the cheap levers borrow from the future, and frames
the whole thing as rational rather than dishonest.

---

## Block 3, can you even set a target

About 10 minutes. The block the case exists for.

**Interviewer.** "Fine. Is 8% the right number?"

**He should ask for the metric's history before answering.** Release it when he does. If he answers without
asking, note it, then release it and watch him revise.

> Weekly returning readers, quarter over quarter change, last eight quarters:
>
> | | Q-o-Q |
> |---|---|
> | 1 | -1.2% |
> | 2 | -4.1% |
> | 3 | +2.3% |
> | 4 | -3.8% |
> | 5 | -0.6% |
> | 6 | -5.2% |
> | 7 | +1.4% |
> | 8 | -2.9% |
>
> Mean drift -1.8% per quarter. Standard deviation 2.7 percentage points.

**The arithmetic.**

| Target | Distance above recent drift | Rough chance of landing there without a real effect |
|---|---|---|
| +8% | 3.6 SD | Essentially zero |
| +3% | 1.8 SD | About 4% |
| 0%, stop the decline | 0.7 SD | About 26% |
| -1.8%, equal to the drift | 0 SD | About 50% |

**Listen for.**

- **That the target cannot be assessed without the metric's natural variation, and he asks for it.** This is the
  Glassdoor benchmark question in its hardest form. Not "is 34% good," which is about a level, but "is +8% a
  target," which is about whether the metric can referee it at all.
- **The finding: +8% is not a stretch target, it is an unreachable one.** The metric has been declining at
  1.8% a quarter with 2.7 points of noise, so +8% requires reversing the trend and then clearing three standard
  deviations. It will be missed almost regardless of what the team does, which means it carries no information
  about the team's performance. A target missed every time is not demanding, it is uninformative.
- **The counterintuitive part: the informative target is "stop the decline."** At 0%, the chance of getting
  there on noise alone is about a quarter, so hitting it is meaningfully better than luck and missing it is
  meaningfully worse. That is what a target is for. Saying this is the strongest single move in the case,
  because it inverts the instinct that a harder target is a better one.
- **The lower bound on any target: roughly two standard deviations, about 5 points.** Inside that range the
  metric cannot distinguish performance from noise, so any target within about 5 points of the drift is
  decided by chance. That bounds the whole conversation.

**Strong signals.**

- Asking where the 8% came from before evaluating it. A target with no provenance is usually a round number
  someone wanted, and knowing that changes the conversation from statistical to organizational.
- Noticing the asymmetry in what a missed target teaches. A team that misses an impossible target learns that
  the honest path does not pay, which is precisely the condition under which the cheap levers from Block 2 get
  used. So an unreachable target does not merely fail to motivate, it actively selects for gaming.
- Separating two things the target could be for: a forecast of what should happen, or a stretch to change
  behavior. Those want different numbers and conflating them is why targets end up arbitrary.
- Proposing to express the target against the counterfactual trend rather than against zero. "Beat the
  underlying drift by 4 points" is readable where "+8%" is not, and it survives a quarter where the whole
  company declines for reasons nobody controls.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Leadership wants an ambitious number." | Then ambitious has to mean reachable-but-hard, not arithmetically out of range. At 2.7 points of quarterly noise and a 1.8 point decline, the ambitious honest target is somewhere around flat to plus three. Eight isn't ambitious, it's decorative, and everyone will know by week six |
| "Doesn't a stretch target make people try harder?" | Up to the point where it's obviously unreachable, and then it stops. What it does after that is make the cheap levers rational, because the honest path definitely misses and the notification lever might not. So an impossible target doesn't just fail to motivate, it selects for the behavior we were trying to avoid |
| "Hold on, you're saying aim for zero growth?" | I'm saying that's the target that would tell you something. Whether zero growth is an acceptable ambition for the company is a different question and not mine, and if the answer is no then the honest conversation is about what would change the trend rather than about what number to write down |
| "What if the whole metric is declining because of search traffic?" | Then almost all of the drift is outside this team's control, and holding them to an absolute number is holding them to Google's roadmap. That's the strongest argument for setting the target against the counterfactual trend rather than against zero |

**Model answer.** "I can't say whether 8% is right without knowing how this metric moves on its own, so that's
what I'd ask for first. On the last eight quarters it's been drifting down about 1.8% a quarter with a standard
deviation of 2.7 points. So +8% is about three and a half standard deviations above the drift, which means it
requires reversing the trend and then beating noise by a wide margin. That's not a stretch target, it's one
that gets missed essentially every time, and a target that's always missed carries no information about the
team. The number that would actually tell you something is around zero: stop the decline. At flat, the chance
of getting there on noise alone is roughly a quarter, so hitting it is meaningfully better than luck and
missing it is meaningfully worse, which is what a target is supposed to do. And the general bound is that with
2.7 points of noise, nothing inside about five points of the drift can be refereed by this metric at all. The
part I'd press hardest on isn't the statistics though. An unreachable target doesn't just fail to motivate. It
makes the cheap levers rational, because the honest path definitely misses and notifications might not. So
setting 8% is the decision most likely to produce exactly the gaming we were worried about in the last block.
One more thing: most of that drift is probably search traffic collapsing, which isn't this team's doing, so
I'd want the target expressed against the underlying trend rather than against zero. Beat the drift by three
points is readable. Plus eight isn't."

**Traps.**

- Evaluating the target without asking for the metric's history.
- Treating 8% as merely ambitious.
- Not connecting the impossible target back to Block 2's cheap levers.
- Missing that the drift is largely exogenous.

**Score.** 4 assesses the target without the history, or calls 8% ambitious. 6 gets the history and identifies
8% as far outside the noise. 8 also names flat as the informative target, gives the roughly five-point bound,
connects an unreachable target to selecting for gaming, and proposes measuring against the counterfactual trend.

---

## Block 4, the policy that protects it

About 11 minutes.

**Interviewer.** "Say we go ahead with something sensible. What do you want in place before the quarter starts?"

**Listen for.** A small number of commitments, each aimed at a specific lever from Block 2. A generic
governance answer scores a 4 no matter how thorough.

| Commitment | The lever it stops |
|---|---|
| Freeze the definition of a session and of a return for the quarter; any change requires a backfill and a restated baseline | Definition drift, the invisible one |
| Pair the goal with guardrail targets, not guardrail watching: hitting the goal does not count if notification volume rises more than X or mute and unsubscribe rates rise more than Y | Notifications, the first lever |
| Report the metric by cohort, splitting returns from users already active at quarter start from newly activated ones | Front-loading, which is otherwise undetectable |
| Report a quality-weighted companion, such as returns with a dwell-qualified read | The indifference between a genuine session and an eight-second bounce |
| Definition ownership sits outside the team being measured | All of them, and this is the one that makes the rest enforceable |
| Report against the counterfactual drift, not against zero | Holding the team to Google's roadmap |

**Strong signals.**

- **The cohort split as the answer to front-loading.** It is the only commitment on the list that turns an
  invisible lever into a visible one, and a candidate who identified front-loading in Block 2 and then does not
  propose the split has left his best finding unaddressed.
- **Guardrail targets rather than guardrail watching**, with numbers agreed before the quarter. Case 04 makes
  the same point; a candidate who has internalized it says it here without prompting.
- **The definition freeze with a backfill requirement.** It costs nothing, it is the single highest-leverage
  policy on the list, and it is almost never in place. The backfill clause is what stops a mid-quarter
  redefinition from quietly resetting the baseline.
- Saying what he would *not* do. He would not add more metrics, and he would not build a composite that tries
  to be gaming-proof, because a composite is just a metric with more places to hide. Rigor that knows when to
  stop, applied to governance.
- Naming the one thing no policy fixes: if the decline is mostly exogenous, no target on this metric makes the
  team's work legible, and the honest move might be to hold them to a leading indicator they control rather
  than to a lagging one they do not.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "This is a lot of process for one goal." | It's four things and three of them are free. Freezing a definition costs nothing, splitting a report by cohort is a query, and agreeing two guardrail numbers is a conversation. The expensive one is the quality-weighted companion and that's the one I'd drop if we had to |
| "What if the definition genuinely needs to change mid-quarter?" | Then it changes, with a backfill and a restated baseline so the history stays readable and the target moves with it. What I'd stop is a change that resets the baseline quietly, which is what happens by default |
| "Who enforces any of this?" | Whoever owns the goal, not me and not the team. My job is to have proposed it in writing before the quarter, so that if it isn't in place we all know that was a choice |
| "And if none of it gets adopted?" | Then I'd say plainly that the number at the end of the quarter won't be interpretable, and I'd still report the cohort split, because that one I can do without anyone's permission and it's the one that catches the most damaging lever |

**Model answer.** "Four things, and three of them are free. Freeze the definition of a session and of a return
for the quarter, with any change requiring a backfill and a restated baseline, because definition drift is the
one lever with no signature at all and this costs nothing to prevent. Pair the goal with two guardrail numbers
agreed before we start rather than watched afterwards: notification volume, and mute plus unsubscribe rate,
because those are the first lever and an unsubscribe is permanent. Split the metric by cohort, separating
returns from people already active at quarter start from newly activated ones, which is the only way
front-loading becomes visible, and it's a query. And report against the underlying drift rather than against
zero, because most of the decline looks exogenous and otherwise we're holding this team to Google's roadmap. If
there's budget for a fifth thing it's a quality-weighted companion, returns that included a real read, so an
eight-second bounce doesn't count the same as a session. What I wouldn't do is add more metrics or build a
composite designed to be gaming-proof, because a composite is a metric with more places to hide. And the thing
no policy fixes: if the drift is mostly search traffic, then no target on this number makes this team's work
legible, and the better answer might be to hold them to something upstream they actually control."

**Traps.**

- Generic governance with no lever mapping.
- Guardrails to be watched rather than guardrail targets.
- No cohort split, having identified front-loading.
- Proposing a composite.
- No view on what happens if none of it is adopted.

**Score.** 4 gives generic process. 6 maps commitments to levers and commits guardrail numbers. 8 also proposes
the cohort split for front-loading, the definition freeze with a backfill clause, declines to add metrics for a
stated reason, and says what he would still do unilaterally.

---

## Block 5, your questions

About 5 minutes. Not scored.

- "When a quarterly goal gets set here, does anyone check the metric's own variance first?"
- "Can a team change the definition of a metric it's being held to, mid-quarter?"
- "Are goals set against an absolute number or against an expected trend?"
- "What happened the last time a team missed a goal that turned out to have been unreachable?"

---

## Scorecard

Same criteria as cases 01 to 05.

| Criterion | Score | Evidence |
|---|---|---|
| Metric evaluation, Block 1 | | |
| Predicting behavior under an incentive, Block 2 | | |
| Benchmarking and rigor, Block 3 | | |
| Accountability and incentives, Block 4 | | |
| Product intuition | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Metric evaluation | Good or bad, without separating metric from target | Indifferent to return quality; notifications are the cheap lever | Credits the count over a rate, raises composition, asks who owns the definition |
| Predicting behavior | Unranked list, or accuses the team | Ranks the levers, notifications first | Names front-loading as the invisible one, notes the cheap levers deplete a finite pool, frames it as rational |
| Benchmarking and rigor | Assesses the target with no history | Gets the history, sees 8% is far outside noise | Names flat as the informative target, gives the five-point bound, connects an impossible target to gaming |
| Accountability | Generic governance | Commitments mapped to levers, numbers agreed in advance | Cohort split for front-loading, definition freeze with backfill, declines to add metrics, acts unilaterally where he can |
| Product intuition | Treats it as arithmetic | Knows the team's levers | Predicts which lever is cheap and invisible, and separates exogenous drift from the team's work |
| Communication | Lists everything | Short, prioritized | Says which commitments are free and which he would drop, and what he would do if none were adopted |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he ask for the metric's history before evaluating the target?
- Did he name front-loading in Block 2, and did he address it in Block 4?
- Did he frame the levers as rational rather than as cheating?
- Did he arrive at flat as the informative target, or only at "8% is too high"?

| Block | Target | Actual |
|---|---|---|
| 1. The metric | 8 min | |
| 2. War-game the levers | 11 min | |
| 3. Can you set a target | 10 min | |
| 4. The policy | 11 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Bank status for this folder

| Case | The metric's problem | Main lesson | Verdict shape | Status |
|---|---|---|---|---|
| `01_engagement-metric-audit` | A ratio with a moving denominator | The metric rose 15% while the company shrank 33% | Replace the ratio with two numbers | Written |
| `02_asker-success-metric` | A success condition that went stale | The metric fell 15% while the product improved 25% | Rename it, build the real one, anchor to a rated sample | Written |
| `03_ai-answer-quality` | The thing that matters is not in the logs at all | Engagement is uncorrelated with correctness | Lead with an error rate, buy a rated instrument | Written |
| `04_guardrails-for-someone-elses-metric` | The primary is fine; the guardrails are decorative | An underpowered guardrail manufactures false confidence | Three guardrails with committed numbers, one dimension declared unmeasured | Written |
| `05_paywall-built-in-tradeoff` | No mistake at all, a genuine three-way tradeoff | Ask which good is a constraint rather than an objective | Keep the gain, fix the objective, hand the floor upward | Written |
| `06_setting-a-target` | Nothing yet; the question is what a target will do to it | An unreachable target selects for the gaming it was meant to prevent | Flat is the informative target, plus four commitments | Written |

Uncovered, if a seventh is ever wanted: a metric that has to span logged-in and logged-out populations that
cannot be compared; a metric for a feature with too little usage to measure at all, where the answer may be
that it should not have one yet; and the circularity case, a feed team whose metric must not be its own
ranker's objective, which case 01 touches as one criticism among six and which would carry a case on its own.
