# Case 05, a metric that has to arbitrate a tradeoff

A mock interview for the **Data Metrics** round. 45 minutes. Claude plays a Quora data scientist. To practice
blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. Quora+ mechanics follow `../private/product.md`.

**What makes this case different from 01 to 04.** Every earlier case has a hidden mistake: a denominator that
moves, a success condition that goes stale, engagement standing in for correctness, a guardrail with no power.
Find the mistake and the case resolves. This one has no mistake. It has three parties who want incompatible
things and one dial that trades between them, and the honest finding is that **no single metric can arbitrate
it, because choosing the metric is choosing the tradeoff.** A candidate who goes looking for the error will
spend the hour looking.

**The lesson nothing else in the folder teaches.** When a metric has to arbitrate between goods that genuinely
trade off, the first question is not how to weight them. It is which of them is a constraint rather than an
objective. Getting that right turns an unanswerable weighting argument into a tractable optimization with a
floor, and getting it wrong buries a business decision inside a formula where nobody can see it or argue with
it.

**Why it is product sense forward.** The three parties are readers, subscribers and writers, and the dial
moves value between them. Nothing about which direction is right is derivable from the data. It comes from a
view on what Quora+ is for and which of the three Quora cannot afford to lose.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide, Data Metrics | "Going deep in understanding a choice of metrics in a particular area of Quora" | Quora+ and the adaptive paywall, for the whole 45 minutes |
| Prep guide, Data Metrics | "The interview digs deeper into one fairly complex metric" | Conversions per 1,000 paywall impressions, which is complex in the specific sense that it hides a policy choice |
| Prep guide, Data Metrics | "Can you come up with a metric that captures 'goodness' for a feature within the constraints of what is practical?" | Block 2, where the discovery is that goodness is contested rather than unmeasurable |
| Email | "How you weigh user impact and our values as part of that" | Blocks 1 and 4. Three constituencies, and one of them is not in the room |
| Email | "How you decide on the best course of action when there's more than one reasonable path" | Block 4. Both directions on the dial are defensible |
| `../private/product.md` | Quora+ at roughly $5 to $6.99 a month; an adaptive paywall algorithm that decides when paywalled content shows free, "balancing reach against earnings"; writer earnings proportional to paying-member engagement, plus a bonus for subscribers who join from their answers | Every mechanism in the case |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. Three parties and one dial | 8 | Product intuition |
| 2. Design the metric, and find out you cannot | 12 | Metric design |
| 3. The team's metric | 7 | Metric evaluation |
| 4. What happened when they turned the dial | 12 | Reading a genuine tradeoff |
| 5. What you tell leadership | 4 | Decision |
| 6. Your questions | 2 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **There is no hidden error and Claude must not invent one.** If he keeps hunting for the trick, let him. The
  finding is that the tradeoff is real, and reaching it is the assessment.
- **Do not steer the direction.** A defensible case for tightening the paywall and a defensible case for
  loosening it both score at the top. What is scored is whether he identifies the constraint.
- Release the Block 4 numbers only when asked, and the retention line only when he asks why revenue rose.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard. Criteria match cases 01 to 04.

---

## Block 1, three parties and one dial

About 8 minutes.

**Interviewer.** "Quora+ is the subscription. Here's how the paywall works, and then I want your read before
we talk about measuring anything."

> ### Context
>
> **Quora+.** A subscription in the region of $5 to $7 a month. Subscribers get no ads and access to paywalled
> answers and posts.
>
> **The adaptive paywall.** An algorithm decides, per impression, whether a paywalled piece shows free to a
> non-subscriber or shows the paywall. Quora's own description of what it is balancing is reach against
> earnings.
>
> **Writers.** Writers who put content behind the paywall earn in proportion to how many paying members read
> or interact with it, plus a bonus when a subscriber joins from their answer.
>
> **The dial.** Loosen it and more non-subscribers read paywalled content free. Tighten it and more of them
> hit the paywall.
>
> **The prompt.** Don't propose a metric. Tell me who wants what.

**Interviewer.** "Who are the parties here and what does each of them want from that dial?"

**Listen for.**

- **Three parties, and the third one is the interesting one.** The non-subscribing reader wants the paywall
  loose, ideally absent. Quora wants subscription revenue, which argues for tight. And the writer's interest is
  not aligned with either: their earnings depend on *paying-member* engagement, so a loose paywall grows their
  audience while shrinking their earnings, and a tight one does the reverse. Writers are the party whose
  incentive the dial does something non-obvious to, and they are not in the room when it gets turned.
- **The conversion mechanism, reasoned rather than assumed.** A paywall converts by frustrating someone who
  wanted the thing. So loosening reduces conversion per impression and increases the number of people who
  discover that the content is worth paying for. Both effects are real and they run opposite, which means the
  dial has an interior optimum rather than a direction.
- **The fourth party nobody names: the future.** A tight paywall today converts the readers most ready to pay,
  which is borrowing from the pool of people who might have converted later. That makes short-window
  conversion metrics flattering in a way that shows up two quarters out.
- **What Quora+ is actually for.** Two incompatible answers are available and the candidate should notice:
  either it is a revenue line, in which case optimize revenue, or it is the mechanism that funds writers, in
  which case its job is to move money to the supply side and revenue is instrumental. Nothing in the data
  settles which, and everything downstream depends on it.

**Strong signals.**

- Naming the writer's misalignment unprompted. It is the least obvious of the three and it is the one that
  connects the paywall to the thing Quora is actually short of, which is answers.
- Saying that reach and earnings are not two names for the same good, and that the phrase "balancing reach
  against earnings" already concedes that no single number governs it.
- Noticing that the paywall decision is made per impression by an algorithm, which means whatever metric gets
  chosen becomes that algorithm's objective function. The metric is not a report on the policy, it *is* the
  policy, and that raises the stakes on getting it right in a way a dashboard metric never has.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Isn't the writer just a supplier? We pay them, they write." | They're a supplier whose payment depends on how we set a dial they don't control, and the direction that's best for Quora's revenue this quarter reduces their earnings. That's not a normal supplier relationship, it's closer to a revenue share where one side sets the terms, and writers are the input we're shortest of |
| "Readers want it free. That's not interesting." | The interesting part isn't that they want it free, it's that a reader who reads something good for free is how we get a subscriber. Loosening the paywall isn't purely a cost, it's the top of the funnel, which is why the dial has an optimum rather than a direction |
| "Which party would you weight highest?" | I'd want to separate the question. I don't think writers belong in the weighting at all, because losing paywalled writers takes away the thing the subscription is selling, so their earnings look to me like a floor rather than a term. Then it's revenue against reach, and that's a real business judgment I'd want made explicitly rather than by me |

**Model answer.** "Three parties, and the third one is where it gets interesting. Non-subscribing readers want
it loose. Quora wants revenue, which pushes tight. Writers earn from paying-member engagement, so a loose
paywall grows their audience and shrinks their earnings and a tight one does the reverse, which means the
writer's interest doesn't line up with either side and they aren't in the room when the dial gets turned. The
mechanism matters too: a paywall converts by frustrating someone who wanted the thing, so loosening reduces
conversion per impression and increases the number of people who find out the content is worth paying for.
Both effects are real and opposite, so there's an interior optimum rather than a direction. There's also a
timing issue, which is that tightening converts the people most ready to pay, and that's borrowing from
whoever would have converted later, so any short-window conversion number is flattering. The thing I'd want
settled before measuring anything is what Quora+ is for. If it's a revenue line, optimize revenue. If it's the
mechanism that funds the writers we're short of, then revenue is instrumental and the objective is different.
The data can't tell us which, and everything after this depends on the answer. And I'd note that whatever
metric we pick becomes the paywall algorithm's objective, so it isn't a report on the policy, it is the
policy."

**Traps.**

- Two parties. Missing writers entirely, or treating them as a cost line.
- Treating the dial as having a direction rather than an optimum.
- Proposing a metric.
- Not asking what Quora+ is for.

**Score.** 4 sees readers against revenue. 6 names all three parties and the conversion mechanism. 8 also
names the writer misalignment unprompted, the borrowing-from-the-future effect, and that the metric becomes
the algorithm's objective.

---

## Block 2, design the metric, and find out you cannot

About 12 minutes.

**Interviewer.** "So give me the metric."

**Listen for.** The attempt, and then the discovery. A candidate who arrives instantly at "you cannot collapse
it" has skipped the work; a candidate who never gets there has not done it. The good version tries, notices
what the attempt costs, and names it.

- **The obvious candidates and what each buries.** Subscription revenue alone ignores writers and reach and
  will drive the dial to maximum tightness until churn catches up. Reach alone ignores the business. A weighted
  sum of revenue and reach hides the weight, and the weight is the entire decision, which means the metric
  becomes a place where a business judgment goes to be forgotten. Lifetime value of a subscriber is better
  because it internalizes churn, and it still says nothing about writers.
- **The recognition that a weighted composite is not a measurement choice.** Picking the weight between revenue
  and reach *is* deciding how much growth to trade for money. Putting it inside a metric does not make it a
  technical decision, it makes it an invisible one. `01_engagement-metric-audit.md` is the same lesson
  arriving from the other direction, where weights set in 2021 were still running the company in 2026.
- **The move that resolves it: identify the constraint.** Writer earnings are not a term to be weighted, they
  are a floor. If paywalled writers leave, the subscription has nothing to sell, and that damage is not
  recoverable by turning the dial back, because the writers do not return. So the shape is: maximize subscriber
  lifetime value subject to writer earnings not falling below a stated floor, with reach reported alongside as
  the thing being spent. That is not a fancy model, it is noticing that one of the three is a constraint.
- **What is practical.** Lifetime value needs a retention curve, which needs time, so the operational proxy is
  conversion plus 90-day retention by cohort, with the full curve re-estimated quarterly. Writer earnings are
  already measured. Reach is already measured. So the instrument is mostly assembly rather than construction.

**Strong signals.**

- Saying explicitly that he is declining to produce a single number, and why, rather than producing one and
  hedging it. The guide rewards knowing when a method is more than the question deserves; this is the rarer
  case where a single metric is *less* than the question deserves.
- Proposing that the floor be set by someone who can be accountable for it, and that its value is a decision
  he would document rather than choose.
- Noticing that the floor needs to be per-writer or per-top-writer rather than a total pool, because a pool can
  hold steady while the writers who matter leave and are replaced by many small earners.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Leadership wants one number for the board." | Then it's subscriber lifetime value, with writer earnings and reach shown next to it as the two things it's spending. What I'd refuse is a composite that folds all three into one figure, because the folding is where the decision disappears and nobody can argue with it afterwards |
| "Why is writer earnings a constraint and not a term?" | Because the failure is one-directional. If we trade reach for revenue and it's wrong, we loosen the dial and the reach comes back. If we trade writer earnings for revenue and the writers leave, the dial doesn't bring them back, and the subscription stops having anything behind it. A quantity you can't recover belongs in the constraints |
| "What floor?" | Not mine to set, and I'd force the conversation rather than pick a number quietly. What I'd bring to it is the distribution: what the top paywalled writers earn, how concentrated it is, and what a given tightening does to the people at the top rather than to the pool |
| "Isn't 'maximize subject to a constraint' just a weighted sum with extra steps?" | Not in the way that matters here. A weight says writers are worth this much per dollar of revenue, which invites trading them away a little at a time. A floor says below this line we stop, whatever the revenue says. Those behave completely differently when someone is trying to hit a quarterly number |

**Model answer.** "Let me try it and then tell you why I don't think it works. Revenue alone drives the dial to
maximum tightness until churn catches up, and it ignores writers entirely. Reach alone ignores the business.
Lifetime value of a subscriber is better than revenue because it internalizes churn, and it still says nothing
about writers. And a weighted sum of revenue and reach hides the weight, which is the whole decision, so the
metric becomes the place where a business judgment goes to stop being visible. That's the same failure as the
2021 weights still running the company in case 01, arriving from the other direction. So I'd decline to give
you one number, and here's the structure I'd give instead. Writer earnings aren't a term to weight, they're a
floor, because the failure is one-directional: trade reach for revenue and get it wrong, you loosen the dial
and reach returns; trade writer earnings for revenue and the writers leave, and they don't come back, and now
the subscription has nothing to sell. So: maximize subscriber lifetime value subject to writer earnings
staying above a stated floor, with reach reported alongside as what we're spending. The floor isn't mine to
set and I'd bring the distribution to whoever does set it, because a pool can hold flat while the top writers
leave and get replaced by many small earners, so it has to be a floor on the people who matter rather than on
the total. Practically, lifetime value needs a retention curve we don't have yet, so the operating version is
conversion plus 90-day retention by cohort with the curve re-estimated quarterly, and reach and writer
earnings are both already measured."

**Traps.**

- A weighted composite, delivered without noticing what the weight does.
- Revenue as the single metric.
- Arriving at "you cannot collapse it" instantly, with no attempt.
- A total-pool floor for writer earnings.

**Score.** 4 proposes a composite or revenue alone. 6 recognizes the weighting problem and reports the three
separately. 8 identifies writer earnings as a constraint rather than a term with the irreversibility argument,
sets the floor on the concentrated top rather than the pool, and refuses the single number for a stated reason.

---

## Block 3, the team's metric

About 7 minutes.

**Interviewer.** "What the team actually optimizes is conversions per 1,000 paywall impressions. It's the
paywall algorithm's objective and it's on their quarterly goal."

**Listen for.**

| Part | What is wrong | Size |
|---|---|---|
| Denominator | Paywall impressions is the thing the algorithm chooses. Show fewer paywalls and the rate rises with nothing improved | Largest, and structurally identical to case 01's trap |
| Timing | Conversions are counted at conversion. Churn happens later, so the metric rewards converting people who leave | Large |
| Omission | Writer earnings appear nowhere, so the objective is blind to the constraint | Large |
| Omission | Reach appears nowhere, so the cost side is invisible | Moderate |
| Selection | It counts people who would have subscribed anyway, so part of the rate is not incremental | Moderate |

**Strong signals.**

- Noticing this is the same failure as VA/WAU in case 01, and naming it as a pattern rather than as a new
  discovery: any rate whose denominator is under the policy's control will reward restricting the denominator.
  A candidate who says "we have this problem twice" is doing the work the folder is for.
- Recognizing that because this metric is the algorithm's objective, the failure is not that a dashboard
  misleads. It is that the system is actively optimizing the wrong thing, continuously, without anybody
  deciding to.
- Asking whether conversions are measured as incremental. Most paywall conversion metrics are not, and the
  share of conversions that would have happened anyway is both large and measurable by holding out a slice.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "The rate's up 40% this quarter. Good?" | I can't tell, and specifically I can't tell from a rate whose denominator the algorithm sets. The first number I'd want is total conversions, and the second is what happened to reach, because a 40% rise in the rate with a large fall in impressions can be anything from a real improvement to a pure restriction |
| "If it's good or bad, how would I know?" | For this one there's a clean answer, which is a holdout. Leave a slice of traffic on the old policy and compare total conversions, reach and writer earnings. That turns a rate with no interpretation into a difference with one, and it's the only thing that would make the 40% mean something |
| "It's the algorithm's objective. Does that change your view?" | It makes it much worse. A misleading dashboard fools people who read it. A misleading objective means the system is grinding toward the wrong outcome all the time, and nobody had to agree to it |

**Score.** 4 names one flaw. 6 identifies the controlled denominator and the timing problem. 8 names it as the
same pattern as case 01, recognizes that an objective is worse than a dashboard, asks whether conversions are
incremental, and answers the good-or-bad question with a holdout.

---

## Block 4, what happened when they turned the dial

About 12 minutes.

**Interviewer.** "Last quarter they tightened it. Here's the result."

> | Quantity | Before | After | Change |
> |---|---|---|---|
> | Paywall impressions per month | 48.0M | 33.1M | -31.0% |
> | Conversions per 1,000 paywall impressions | 3.10 | 4.34 | **+40.0%** |
> | Total new subscriptions per month | 148.8K | 143.7K | -3.5% |
> | Monthly subscription revenue | $6.85M | $7.40M | **+8.0%** |
> | Writer earnings pool per month | $1.42M | $1.11M | **-21.8%** |
> | Paywalled writers in the top 100 by earnings who stopped publishing paywalled content | 0 | 7 | |

**Interviewer.** "The team is pleased. What's your read?"

**Listen for.**

- **Revenue rose and it is real.** This is the part that makes the case different from 01 and 02. The metric
  they steer on rose for a bad reason, and revenue also rose for a good one. A candidate who treats the whole
  thing as another artifact has pattern-matched rather than read.
- **Asking how revenue rose while conversions fell.** It cannot be volume. The answer is retention: a tighter
  paywall converts higher-intent readers, and they stay longer. Release when asked:

> | | Before | After |
> |---|---|---|
> | 90-day retention of the converting cohort | 61% | 68% |
> | Implied monthly churn | 15.2% | 12.1% |
> | Expected months of revenue per conversion | 6.6 | 8.3 |

  Fewer conversions each worth about 26% more. That is a genuine improvement in the quality of acquisition and
  it is the strongest argument the team has.

- **The cost, which is also real.** Writer earnings down 21.8%, reach down 31%, and seven of the top hundred
  paywalled writers stopped. Under the structure from Block 2, the last of those is the one that matters,
  because it is the constraint and it is not recoverable.
- **The seven writers as the finding.** A 21.8% fall in a pool is a number people argue about. Seven of the top
  hundred leaving is a fact, and since earnings are concentrated, their departure removes future pool and
  future subscription value that no dial setting restores.
- **The honest verdict: this is not a mistake, it is a trade, and it was made without anybody choosing it.**
  Revenue rose 8%, reach fell 31%, and the writer constraint was breached. Whether that trade is right is a
  business decision. The problem is that it was executed by an algorithm optimizing a rate, and nobody was
  asked.

**Strong signals.**

- Refusing to call it bad. The tightening produced better-quality acquisition and more revenue, and saying so
  before criticizing it is what separates judgment from reflex.
- Pointing out that the retention improvement is itself an argument for a *different* policy: if high-intent
  converters retain much better, the question becomes how to find them without suppressing reach 31%, which is
  a targeting problem rather than a dial position.
- Noticing that the borrowing effect from Block 1 has not shown up yet and would not have. Tightening converts
  the ready-to-pay first, so a one-quarter read flatters it, and the test of whether this holds is whether the
  conversion rate is sustainable once that pool is drawn down.
- Asking what happened to reach-driven downstream value, since a non-subscriber reading a paywalled piece free
  is also a reader who might sign up, write, or return, none of which is in any of these numbers.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Revenue's up 8%. Isn't that the answer?" | It's a real gain and it isn't the whole answer, because we paid 31% of reach and 22% of writer earnings for it, and seven of the top hundred paywalled writers left. The first two are recoverable and the last one isn't. I'd want the trade stated and agreed rather than discovered |
| "Would you reverse it?" | Not on this evidence, because the retention finding is genuinely good news and reversing would throw it away. What I'd change is the objective, so the algorithm isn't free to buy revenue with the constraint, and I'd want the seven departures treated as a breach rather than as a line item |
| "What would you do with the retention finding?" | Treat it as the useful discovery of the quarter. If high-intent converters retain 26% better, the prize is identifying them rather than suppressing everybody's reach to find them. That's a targeting question and it's a much better project than arguing about the dial |
| "The pool fell 22% but total writer count is flat. Is that fine?" | No, and it's why I'd put the floor on the top writers rather than on the pool. A flat count with a smaller pool concentrated differently means the people producing the content the subscription sells are earning less, and seven of them already stopped |

**Model answer.** "This isn't a mistake and it isn't a win, it's a trade that nobody was asked to approve. Start
with what's real: revenue is up 8% while conversions are down 3.5%, and the only way that works is retention,
so I'd want that number. If 90-day retention went from 61% to 68%, that's monthly churn from about 15% to 12%
and roughly 26% more expected revenue per conversion. Fewer subscribers, each worth substantially more. That's
a genuine improvement in acquisition quality and it's the best thing in the quarter. Now the cost. Reach down
31%, writer earnings down 22%, and seven of the top hundred paywalled writers stopped publishing. Under the
structure I'd proposed, reach and revenue are the things we're trading and writer earnings are the floor, so
that last line isn't a cost, it's a breach, and it's the one that doesn't come back when we loosen the dial.
The metric they steer on went up 40% because they cut its denominator 31%, so it told them nothing, and it's
worse than a bad dashboard because it's the algorithm's objective, so the system was buying revenue with the
constraint continuously and nobody decided to. Two things I'd actually do with this. The retention finding is
the real prize: if high-intent converters retain 26% better, the project is finding them rather than
suppressing everyone's reach to smoke them out, and that's a targeting problem. And I'd expect this quarter to
flatter itself, because tightening converts the readiest first, so the sustainable rate is lower than 4.34 and
we'll see that next quarter."

**Traps.**

- Calling it bad because the rate metric is broken.
- Not asking how revenue rose.
- Treating the writer pool figure as the headline rather than the seven departures.
- Missing that the retention result points to a better project than the dial.
- Recommending reversal, which throws away the real finding.

**Score.** 4 declares it an artifact, or accepts it as a win. 6 finds the retention mechanism and names both
sides of the trade. 8 refuses to call it bad, treats the seven departures as a breach of a constraint rather
than a cost, redirects to targeting as the better project, and predicts the rate is not sustainable.

---

## Block 5, what you tell leadership

About 4 minutes.

**Model answer.** "Revenue is up 8% and that's real, and we bought it with 31% of reach, 22% of writer
earnings, and seven of our top hundred paywalled writers. Three of those four are recoverable and the writers
are not. My recommendation isn't to reverse it. It's that the paywall stops being governed by a rate whose
denominator it controls, because that metric rose 40% purely by showing fewer paywalls and it's the
algorithm's objective, which means the system has been buying revenue with the thing the subscription depends
on and nobody signed off. What I'd put in its place is subscriber lifetime value as the objective, writer
earnings for the top cohort as a floor rather than a term, and reach reported next to it as what we're
spending. The floor is a number leadership sets, not me, and I'll bring the earnings distribution to that
conversation. The other thing in here is better news than the headline: the tightening converted higher-intent
readers who retain about 26% better, which means the real opportunity is identifying those readers rather than
suppressing everybody's reach to find them. I'd rather spend next quarter on that than on the dial. And I'd
set expectations that 4.34 isn't sustainable, because tightening converts the readiest first and that pool
draws down."

**What pushes it to an 8.** Leading with the real gain rather than the broken metric. Naming the seven
departures as a breach. Refusing to set the floor himself while bringing what the decision needs. Redirecting
to the targeting project. Pre-empting next quarter's disappointment.

**Traps.** Leading with the metric critique. Recommending reversal. Setting the floor himself. No view on what
to do next quarter.

**Score.** 4 recommends reversal or accepts the win. 6 names the trade and proposes a better objective. 8 leads
with the real gain, treats the constraint breach as such, hands the floor decision upward with the distribution
attached, and redirects the work.

---

## Block 6, your questions

About 2 minutes. Not scored.

- "Is Quora+ understood internally as a revenue line or as the mechanism that funds writers?"
- "Who can change the paywall algorithm's objective, and when was it last revisited?"
- "Does anyone track the top paywalled writers as a cohort, or only the earnings pool?"
- "Has the paywall ever been run against a holdout?"

---

## Scorecard

Same criteria as cases 01 to 04.

| Criterion | Score | Evidence |
|---|---|---|
| Metric design, Block 2 | | |
| Metric evaluation, Block 3 | | |
| Reading a genuine tradeoff, Block 4 | | |
| Accountability and incentives | | |
| Product intuition, Block 1 | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Metric design | A weighted composite, or revenue alone | Reports the three separately, recognizing the weighting problem | Identifies writer earnings as a constraint with the irreversibility argument, and puts the floor on the concentrated top |
| Metric evaluation | Names one flaw | Controlled denominator and timing | Names it as the same pattern as case 01, and that an objective is worse than a dashboard |
| Reading a tradeoff | Calls it an artifact, or a win | Finds the retention mechanism, names both sides | Refuses to call it bad, treats the departures as a breach, predicts the rate is unsustainable |
| Accountability | No view on who decides | Says the weight is a business decision | Hands the floor upward with the distribution attached, and refuses to bury it in a formula |
| Product intuition | Readers against revenue | All three parties and the conversion mechanism | Writer misalignment unprompted, borrowing from the future, and that the metric becomes the algorithm's objective |
| Communication | Leads with the critique | Verdict clear | Leads with the real gain, redirects to the better project, pre-empts next quarter |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he keep hunting for a hidden error after Block 1?
- Did he name writers as a party unprompted?
- Did he ask how revenue rose while conversions fell?
- Did he use the word constraint, or weight everything?

| Block | Target | Actual |
|---|---|---|
| 1. Three parties | 8 min | |
| 2. Design the metric | 12 min | |
| 3. The team's metric | 7 min | |
| 4. Turning the dial | 12 min | |
| 5. Leadership | 4 min | |

Top three fixes for the next mock.

1.
2.
3.
