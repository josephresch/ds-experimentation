# Case 04, the primary metric is fine, now protect it

A mock interview for the **Data Metrics** round. 45 minutes. Claude plays a Quora data scientist. To
practice blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. Feed scale, answer supply and the experiment layer
cap match `01_engagement-metric-audit.md`, `../data-practical/01_answer-request-routing.md` and
`../private/product.md`.

**What makes this case different.** Cases 01, 02 and 03 all hand him a bad metric and ask what is wrong with
it. This one hands him a good one. The primary metric is defensible and is not the question. The question is
the sentence in the invitation email that the other cases treat as a subclause: **"what you'd watch alongside
it to catch unintended effects."** Designing guardrails is a separate skill from designing a primary, and it
is the one most likely to be tested by an interviewer who wants to know whether a candidate can predict
behavior rather than critique arithmetic.

**Why it is the most product sense forward case in the folder.** Critiquing a metric is an analytical act.
Naming its guardrails is an act of prediction: you have to work out how readers will respond, how writers
will be affected, and above all what a team paid on this number will do to raise it. Every good guardrail
here is derived from a mechanism, and a generic list of engagement metrics scores a 4 no matter how long it is.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Email | "What you'd watch alongside it to catch unintended effects" | The entire case |
| Prep guide, Data Metrics | "Can you proactively see what might be wrong with a metric, or what might lead the team to misleading conclusions?" | Block 2, applied to someone else's metric rather than his own |
| Prep guide, Data Metrics | "Metrics are important at Quora in order to measure success and hold teams accountable" | Block 4. A guardrail with no committed stopping value is not a guardrail |
| Prep guide, how to prepare | "Read up on why metrics fail: Goodhart's law" | Block 2 is Goodhart worked forward rather than diagnosed backward |
| Prep guide, what we look for | "Rigor that knows when to stop" | Block 3, where most of the guardrail list has to be cut for being unmeasurable |
| `../private/product.md` | The feed is one ranked list where item types compete for slots; the experiment layer allows up to 20% of feed users | Blocks 2 and 3 |
| `01_engagement-metric-audit.md` | Answers written is heavily zero-inflated and badly underpowered in reader-randomized tests | Block 3's arithmetic |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. The metric, and what it is for | 6 | Product intuition |
| 2. Name the guardrails | 13 | Predicting unintended effects |
| 3. Which of them can actually see the harm | 11 | Rigor that knows when to stop |
| 4. What makes a guardrail a guardrail | 8 | Accountability |
| 5. What you tell the team | 4 | Communication |
| 6. Your questions | 3 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **Do not let him attack the primary metric.** If he starts critiquing it, say "assume it's the right primary,
  I've already had that argument." The case is not about the primary and letting him relitigate it is the
  easiest way to waste the hour. Note if he tries.
- **Accept his guardrail list without reaction in Block 2**, then make him defend it in Block 3. Releasing the
  power arithmetic early kills the block.
- Push once per block for the mechanism behind a guardrail. "What would make that move?"
- Record the time with `date` at each block.
- At the end, debrief with the scorecard. Criteria match cases 01 to 03.

---

## Block 1, the metric, and what it is for

About 6 minutes.

**Interviewer.** "The feed team has landed on a primary metric and I think it's a good one. Their quarterly
goal is going to be set on it. My question for you is the other half."

> ### Context
>
> **The primary metric.** Dwell-qualified reads per feed user per week. A dwell-qualified read is an expand
> followed by at least 20 seconds of reading. The team chose it over expand rate specifically because expands
> are easy to inflate and reading is closer to value.
>
> **The team.** The feed ranking team. Their only real lever is the ranking function: which stories go in
> which slots, and how the score weights predicted reader actions.
>
> **The surface.** The logged-in home feed is one ranked list. Answers, Space posts, suggested questions to
> answer, and ads all compete for the same slots. About 8.0M logged-in users load the feed in a 14-day window.
> The feed experiment layer allows a test to use up to 20% of feed users.
>
> **The goal.** Dwell-qualified reads per feed user up 8% this quarter.
>
> **Your job.** Not to second-guess the primary. To say what we watch alongside it.

**Interviewer.** "Before you list anything. What is this metric going to make the team do?"

**Listen for.**

- **Reasoning from the lever, not from the metric.** The team can only reorder the feed. So every route to
  raising the metric is a reordering, and the question is which reorderings raise dwell-qualified reads. That
  framing produces the guardrails; starting from a list of engagement metrics does not.
- **The three cheap routes, identified.** More items that get opened, which means a content mix shift toward
  whatever is most tappable. Longer items, because a 20-second threshold is easier to clear on a long answer
  than a short one. And more slots given to the story types that produce reads, which necessarily means fewer
  slots for the story types that do not, and the ones that do not include the prompts that generate answers.
- **The denominator, noticed early.** Per feed user per week. Losing light users raises the average. The team
  does not control acquisition, so this is less of a gaming route than an interpretation hazard, and it needs
  the total next to the rate either way.
- **Who else is affected.** Writers, because answer prompts compete for the same slots. Advertisers, because
  ads do too. New users, because personalization has the least to work with for them and a metric optimized
  in aggregate will be optimized for tenured users.

**Strong signals.**

- Saying out loud that the metric is good and its failure modes are still predictable, and that those are not
  the same claim. A good primary metric does not need fewer guardrails, it needs better-aimed ones.
- Noticing the 20-second threshold is a lever the team does not control but writers and content length do, so
  the metric drifts with the answer-length distribution even when the team does nothing.
- Getting to the slot competition unprompted. It is the mechanism that connects a reader metric to writer
  supply, and it is the thing that makes this case Quora-specific rather than generic.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Isn't dwell-qualified reading already the hard-to-game version?" | It's much better than expand rate and it isn't ungameable. A 20-second threshold rewards longer content and slower content, and the team can reach it by giving slots to whatever clears it most reliably, which isn't necessarily what readers value most |
| "The team can't change answer length. Why does it matter?" | Because the metric moves when the length distribution moves, whoever caused it. If AI answers or Space posts shift typical length, the metric shifts, and the team gets credit or blame for something that isn't theirs. That's a reason to watch length as a diagnostic even though it isn't a guardrail against the team |
| "Who gets hurt if this goes well?" | Whoever was in the slots that now go to reads. Suggested questions are the main one, because that's where answer writing starts, and the feed is where most answering sessions begin |

**Score.** 4 lists metrics with no mechanism. 6 identifies content mix and the threshold as routes. 8 reasons
from the team's only lever, gets slot competition and writer supply unprompted, and separates gaming routes
from interpretation hazards.

---

## Block 2, name the guardrails

About 13 minutes.

**Interviewer.** "Alright. What do we watch?"

**Listen for.** Guardrails paired with the specific mechanism each one catches. A candidate who produces a
list without mechanisms has produced a dashboard.

| Guardrail | The mechanism it catches |
|---|---|
| Story type mix in the top slots | The cheapest route: give slots to whatever gets opened, regardless of value |
| Upvotes and shares per read | Reads rising while value per read falls, which is the same trap case 01's Ranker B fell into |
| Read completion rate, and the share of expands ending under 5 seconds | A 20-second threshold cleared by long content that nobody finishes |
| Answer prompts shown, and answers written per feed user | The slot cost to writer supply. The one that matters most and the one that cannot be measured, see Block 3 |
| Negative feedback, downvotes plus mutes | Readers opening more and liking less |
| Days active, and feed users | The denominator, and whether the rate rose because people left |
| The metric for new users separately | Personalization serves them worst, so aggregate optimization ignores them |
| Ad revenue per user | Moves mechanically with expands and scroll depth, so it is a diagnostic rather than a goal |
| Median answer length in the feed | The threshold drifting for reasons outside the team |

**Strong signals.**

- **Grouping them by what they protect rather than listing them flat.** Reader value, supply, the population,
  and the metric's own integrity are four different things to protect, and a candidate who organizes that way
  will not miss a category.
- **Naming the one that matters most and saying why.** Answers written is the guardrail that protects the thing
  the company cannot recover: if the feed stops generating answering sessions, the corpus stops growing, and
  that damage compounds over years while the reader metric looks fine every quarter.
- **Distinguishing guardrails from diagnostics.** Ad revenue and answer length are things you watch to explain
  a movement. They are not things that should stop a launch. Calling everything a guardrail dilutes the word
  and, more practically, means nobody commits a stopping value to any of them.
- Naming a guardrail against the team's own incentive rather than only against user harm. The mix of story
  types in the top slots is partly a check on whether the team is solving the problem or relocating it.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "That's nine things. Nobody watches nine things." | Agreed, and that's the next conversation. Four of them are guardrails that should have stopping values and the rest are diagnostics for explaining a movement. If I had to take three into a launch review they'd be upvotes and shares per read, answers written per feed user, and the new-user cut |
| "Why answers written? The team can't affect writing." | They can and it's indirect. Suggested questions live in the same ranked list, so every slot that goes to a read is a slot that didn't go to a prompt, and the feed is where most answering sessions start. It's the clearest case here of one team's metric being paid for out of another team's |
| "Why new users separately?" | Because personalization has almost nothing to work with for someone who signed up last week, so a ranking change tuned on the aggregate is tuned on tenured users, and new users are where growth comes from. They're also about 12% of the feed, so they can be badly hurt without moving the average |
| "Anything you'd watch that isn't a metric?" | Whether the shift in story mix is the kind we'd be comfortable explaining. If the top slots fill up with a content type that reads well and nobody would describe as what Quora is for, that's a judgment call a number won't make for us, and I'd want it looked at rather than inferred |

**Model answer.** "I'd group them by what they protect rather than give you a list. Reader value: upvotes and
shares per read, negative feedback, and read completion, because the whole risk with a read-based metric is
more reading of less valuable things. Supply: answer prompts shown and answers written per feed user, because
prompts live in the same ranked list and every slot that goes to a read is a slot that didn't go to a prompt,
and the feed is where most answering sessions start. That's the one I care about most, because it's the only
damage on the list that compounds and can't be undone in a quarter. Population: days active, feed users, and
the metric cut for new users separately, since personalization is worst for them and they're about an eighth
of the feed, so they can be hurt badly without moving the average. And the metric's own integrity: story type
mix in the top slots, and median answer length, because a 20-second threshold drifts with content length
whoever caused it. I'd separate those last two and ad revenue out as diagnostics rather than guardrails. They
explain a movement, they shouldn't stop a launch, and if everything is called a guardrail then nothing gets a
stopping value."

**Traps.**

- A flat list with no mechanisms.
- Missing answer prompts and writer supply, which is the Quora-specific one.
- Calling everything a guardrail.
- Proposing a composite guardrail score.

**Score.** 4 lists generic engagement metrics. 6 names guardrails with mechanisms, including reader value and
the denominator. 8 groups them by what they protect, identifies writer supply as the one that compounds,
separates diagnostics from guardrails, and adds a non-metric judgment check.

---

## Block 3, which of them can actually see the harm

About 11 minutes. The block the case exists for.

**Interviewer.** "You said answers written is the one you care about most. Suppose the test runs at the layer
cap, 20% of feed users, ten and ten. Can that guardrail see anything?"

**The arithmetic, released as he works toward it.**

> | Quantity | Value |
> |---|---|
> | Answers written per feed user over 14 days | Mean 0.060, SD about 0.90, heavily zero-inflated |
> | Feed users available at the 20% layer cap | 1.6M, so 800,000 per arm |
> | Smallest detectable change at 800,000 per arm | 0.0040, which is 6.6% of the base |
> | Users per arm needed to detect a 5% drop | About 1.41M, which is 35% of feed users and above the cap |
> | Users per arm needed to detect a 10% drop | About 353,000, comfortably available |

**Listen for.**

- **The conclusion, stated plainly: the guardrail can see a 10% drop in answer supply and cannot see a 5% one,
  and it cannot be made to.** The sample needed for 5% exceeds what the experiment layer allows. So this is
  not a matter of running longer or allocating more; within this design the guardrail is blind to the harm
  most likely to occur.
- **Why that is worse than having no guardrail.** A guardrail that comes back flat gets read as safety. So an
  underpowered guardrail does not merely fail to protect, it actively manufactures confidence. That is the
  sharpest point in the case and it is the reason this arithmetic has to be done before the launch review
  rather than after.
- **Whether 5% matters.** It does. A 5% sustained reduction in answers written, compounding across quarters on
  a corpus that is already shrinking, is exactly the slow damage nobody notices. So the undetectable range and
  the range that matters are the same range.
- **What to do instead**, rather than reporting the guardrail with a caveat. Three honest options: run the
  feed test and accept that supply is unmeasured, saying so explicitly; add a writer-randomized companion test
  where the unit is the writer and the variance works out differently; or ship with a long-running holdout and
  monitor supply over quarters rather than over a test.

**Strong signals.**

- Applying the same arithmetic to the rest of the list and cutting it. Upvotes and shares per read are
  plentiful and fine. Negative feedback is rare, so relative changes look large and the interval is wide, and
  it needs care. Days active is slow and has its own power problem. New-user cuts are on 12% of the sample, so
  they are underpowered by construction, which means the new-user guardrail is also decorative unless the
  allocation is deliberately skewed toward new users.
- **Proposing to over-allocate new users into the test**, which is available at design time and impossible to
  retrofit, and costs nothing. This is the same move as over-allocating a joint cell in
  `../data-stats/05_two-experiments-one-surface.md`.
- Saying that the honest output of this block is a shorter list. Rigor that knows when to stop, applied to his
  own proposal from ten minutes earlier.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "So report it with a caveat." | Caveats don't travel. It'll appear in a launch review as a flat guardrail, someone will read that as no harm, and the caveat will be in a footnote nobody opens. I'd rather say it's unmeasured in this design and name what would measure it |
| "You've cut half your own list. Wasn't it any good?" | The mechanisms were right and half of them can't be watched at this sample size, which I should have checked before offering them. The list I'd take into a review is upvotes and shares per read, negative feedback with a wide interval expected, and story type mix, plus a new-user cut only if we skew the allocation to make it readable |
| "What if we ran it for six weeks instead of two?" | That helps the slow metrics like days active and it barely helps answers written, because the variance is driven by how few people write rather than by the window. Three times the duration buys about a 1.7 times improvement in what's detectable, so 6.6% becomes about 3.8%, which is closer and costs a quarter of the team's time |
| "Is there a version of the supply guardrail that works?" | Yes, and it isn't in this test. Randomize writers rather than readers, which is what `../data-practical/01_answer-request-routing.md` does, and the variance works out because the outcome is measured on people who actually write. Inside a reader-randomized feed test, supply is a post-launch monitoring problem rather than a guardrail |

**Model answer.** "At the layer cap it can see a 10% drop and not a 5% one, and getting to 5% needs about 35%
of feed users, which is above what the layer allows. So this isn't fixable by running longer or asking for
more traffic. The reason that matters more than it sounds is that an underpowered guardrail doesn't fail
quietly, it comes back flat and gets read as safety. So it's worse than not having one. And the range it
can't see is the range that matters: a 5% sustained reduction in answers written, compounding on a corpus
that's already shrinking, is precisely the damage nobody notices in time. Applying the same arithmetic to the
rest of what I gave you, the list gets shorter. Upvotes and shares per read are fine, there's plenty of
signal. Negative feedback is rare so I'd expect a wide interval and I'd say so up front rather than
over-reading it. Days active is slow and needs the longer window. And the new-user cut is on about 12% of the
sample, so it's underpowered by construction unless we deliberately over-allocate new users into the test,
which is free at design time and impossible afterwards. On supply, the honest answer is that a
reader-randomized feed test can't measure it, and I'd say that in the review rather than report a flat number
with a caveat. If we want it measured, it's a writer-randomized companion test or a long-running holdout
watched over quarters."

**Traps.**

- Reporting the guardrail with a caveat.
- Not applying the arithmetic to the rest of his own list.
- Claiming a longer run fixes it.
- Missing that the new-user guardrail has the same problem.

**Score.** 4 keeps the full list, or accepts a caveat. 6 does the arithmetic and identifies the supply
guardrail as underpowered. 8 also argues that an underpowered guardrail manufactures false confidence, cuts
his own list accordingly, proposes over-allocating new users, and names the writer-randomized alternative.

---

## Block 4, what makes a guardrail a guardrail

About 8 minutes.

**Interviewer.** "The team's goal is up 8% on the primary. Suppose they hit it and one of your guardrails
moved. Then what?"

**Listen for.**

- **A stopping value committed in advance, per guardrail.** "We'll watch upvotes per read" is a dashboard.
  "The launch doesn't proceed if upvotes per read falls more than 2%" is a guardrail. Only the second survives
  contact with a team that wants to ship, and the difference is entirely about when the number was agreed.
- **Who agrees it, and when.** Before the test, with the team and whoever owns the decision. A stopping value
  proposed after the results are in is a negotiation, and the team will win it, because by then there is a
  launch everybody has planned around.
- **The asymmetry with the primary.** The primary needs to clear a bar to justify shipping. A guardrail needs
  to fail to stop it. Those are different decision rules and conflating them produces the situation where a
  guardrail moving the wrong way gets traded off against the primary in the room.
- **What happens when a guardrail is underpowered, stated as a rule.** If a guardrail cannot detect the harm
  worth stopping for, it does not get a stopping value, it gets an explicit statement that this dimension is
  unmeasured. Giving it a stopping value it can never trigger is the worst of the available options.

**Strong signals.**

- Distinguishing a guardrail that stops a launch from one that triggers a follow-up. Not everything needs a
  veto, and some things warrant shipping with a commitment to monitor. Being explicit about which is which is
  what makes the framework usable rather than obstructive.
- Naming the failure mode where the team owns both the primary and the guardrail definitions. If the feed team
  can define what counts as a dwell-qualified read and also what counts as an acceptable drop in negative
  feedback, the guardrails are decorative. Definition ownership has to sit outside the team being measured.
- Saying that the 8% target itself needs checking against the metric's natural variation, and that this is a
  separate conversation he would want to have.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Committing numbers in advance sounds rigid. What if the situation is more nuanced than the number?" | Then we write down in advance what the nuance would be. The problem isn't rigidity, it's that after the results arrive everyone's judgment gets recruited by the outcome they were hoping for, including mine. A number agreed beforehand isn't smarter than us, it's just written down before we had a stake |
| "Who sets the stopping values?" | Data proposes them, the decision owner agrees them, and the team being measured doesn't get to change them mid-quarter. That last part matters more than who proposes, because a metric a team can redefine while being held to it isn't holding them to anything |
| "The team hits 8% and upvotes per read is down 1.5% against a 2% threshold. Ship?" | By the rule we agreed, yes, and I'd say out loud that it's close and that I'd want it watched post-launch. What I wouldn't do is renegotiate the threshold in the room, in either direction |

**Model answer.** "A guardrail is only a guardrail if there's a number attached and the number was agreed
before anyone saw the result. Otherwise it's a dashboard, and what happens in the review is that the primary
cleared its bar, a guardrail moved a bit, and the two get traded off by whoever argues best. So for each of
the three or four that survived the power check, I'd want a stopping value written down beforehand, agreed
with the decision owner, and not changeable by the team being measured. The asymmetry is worth being explicit
about: the primary has to clear a bar to justify shipping, a guardrail only has to fail to stop it, and those
are different rules. I'd also split them into ones that veto and ones that trigger a follow-up, because not
everything needs a veto and pretending otherwise gets the whole framework ignored. And for the dimensions we
established can't be measured at this sample size, the honest treatment isn't a stopping value that can never
fire, it's a line in the review saying supply is unmeasured in this design. The other thing I'd raise
separately is the 8% itself, because I'd want to know what this metric's natural quarterly variation is
before agreeing that 8% is a target rather than a coin flip."

**Traps.**

- "We'd discuss it" as the answer.
- Stopping values set after the results.
- Giving a stopping value to an underpowered guardrail.
- No view on who owns the definitions.

**Score.** 4 says it would be discussed. 6 commits stopping values in advance. 8 also distinguishes veto from
follow-up, puts definition ownership outside the team, refuses a stopping value on an unmeasurable dimension,
and flags the target itself as needing a variance check.

---

## Block 5, what you tell the team

About 4 minutes.

**Model answer.** "The primary is fine and I'm not going to argue about it. Three things alongside it, with
numbers agreed before we start: upvotes and shares per read, negative feedback with a wide interval expected
because it's rare, and story type mix in the top slots. A new-user cut as a fourth, but only if we skew the
allocation toward new users at design time, because at 12% of the sample it's unreadable otherwise and that's
free to fix now and impossible to fix later. Then the thing I'd want on the record: answers written per feed
user is the guardrail I care about most, because prompts compete for the same slots and it's the only damage
here that compounds, and this test cannot see it. At the layer cap it detects a 10% drop and not a 5% one,
and 5% is the range that matters. That's not a caveat, it's a dimension we're shipping blind on, and I'd
rather the review say so than show a flat number people read as safety. If we want it measured it's a
writer-randomized companion test or a long-run holdout. Separately, I'd want to look at what this metric's
natural quarterly variation is before we commit to 8%, because if it swings 5% on its own then the target is
mostly measuring luck."

**What pushes it to an 8.** Declining to relitigate the primary. Cutting his own list and saying why. Naming
the unmeasurable dimension as a shipping decision rather than a footnote. The design-time allocation fix.
Raising the target's provenance without being asked.

**Traps.** A list of nine. Reporting the supply guardrail with a caveat. No numbers agreed in advance.

**Score.** 4 gives a list with no stopping values. 6 gives a short list with committed numbers. 8 adds the
explicit unmeasured dimension, the allocation fix, and the target variance question.

---

## Block 6, your questions

About 3 minutes. Not scored.

- "When a launch review has a guardrail that moved, how does that conversation usually go?"
- "Are stopping values agreed before tests here, or decided at the review?"
- "Who owns the definition of a dwell-qualified read, and can the feed team change it?"
- "Does anything protect answer supply from feed changes today, or is it watched after the fact?"

---

## Scorecard

Same criteria as cases 01 to 03.

| Criterion | Score | Evidence |
|---|---|---|
| Metric design, Block 2 | | |
| Metric evaluation, Blocks 2 and 3 | | |
| Diagnosing, Block 3 | | |
| Accountability and incentives, Block 4 | | |
| Product intuition, Block 1 | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Metric design | A flat list of engagement metrics | Guardrails with mechanisms | Grouped by what they protect, writer supply identified as the compounding one, diagnostics separated |
| Metric evaluation | Attacks the primary instead | Predicts the cheap routes to raising it | Reasons from the team's only lever, and separates gaming routes from interpretation hazards |
| Diagnosing | Keeps the full list | Does the power arithmetic on the supply guardrail | Argues an underpowered guardrail manufactures confidence, cuts his own list, proposes the allocation fix |
| Accountability | "We'd discuss it" | Stopping values agreed in advance | Veto against follow-up, definition ownership outside the team, refuses a threshold on an unmeasurable dimension |
| Product intuition | Generic feed reasoning | Knows slots are the scarce resource | Connects a reader metric to writer supply through slot competition, unprompted |
| Communication | Long list, no priorities | Short list with numbers | Declines to relitigate the primary, names the blind dimension as a shipping decision, raises the target's provenance |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he try to attack the primary metric? How many times?
- Did he reach writer supply through slot competition unprompted?
- Did he cut his own list after the power arithmetic, or defend it?
- Did he propose committing stopping values before being asked?

| Block | Target | Actual |
|---|---|---|
| 1. The metric | 6 min | |
| 2. Name the guardrails | 13 min | |
| 3. Which can see the harm | 11 min | |
| 4. What makes a guardrail | 8 min | |
| 5. What you tell the team | 4 min | |

Top three fixes for the next mock.

1.
2.
3.
