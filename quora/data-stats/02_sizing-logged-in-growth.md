# Case 02, how big is the logged-in opportunity

A mock interview for the **Data Stats** round. 45 minutes, talked through, no coding. Claude plays a
Quora data scientist. To practice blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. Search sessions, signups and logged-in weekly
actives match `01_search-traffic-shock.md` and `../data-metrics/01_engagement-metric-audit.md`, so the
three cases describe one company.

**Dominant flavor: estimation.** The guide says some questions "require a deeper dive into statistical
models." This is the version of that where there is no dataset at all and the model is arithmetic you
have to build and defend. "Sizing new initiatives" is one of the four things the guide lists as the
team's current focus, and nothing else in this folder touches it.

**Why it is product sense forward.** The binding question is not which formula to use. It is whether the
search visitor who has not signed up is a person who might, and the honest answer is that the ones who
would sign up easily already have. Everything quantitative in this case follows from that one sentence,
and a candidate who does not reach it will multiply optimistic numbers together and produce an answer
five times too large.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide, current focus | "Sizing new initiatives" | The whole case |
| Prep guide, Data Stats | "Framing an open-ended question, understanding the assumptions and challenges, and proceeding accordingly" | Blocks 1 and 2. There is no data to hide behind |
| Prep guide, Data Stats | "Formulating a well-defined model, knowing its assumptions" | Block 2 is literally writing down a model of arithmetic |
| Prep guide, what we look for | "Rigor that knows when to stop. The point at which more precision would not have changed the decision" | Block 4 is that question made explicit |
| Prep guide, what we look for | "A decision on the other end" | Block 5. The decision is whether to fund a team |
| Email | "How you decide on the best course of action when there's more than one reasonable path" | Block 3, two horizons giving two different answers |
| `../private/product.md` | Search dependence, the sign-up wall, logged-out against logged-in as a live tension | The premise |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. Framing and the product read | 6 | Framing, product intuition |
| 2. Build the estimate | 13 | Model formulation |
| 3. The structural correction | 9 | Assumptions and their consequences |
| 4. Sensitivity and where to stop | 10 | Rigor that knows when to stop |
| 5. What you tell leadership | 4 | Decision |
| 6. Your questions | 3 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **Give numbers only when asked, and only the ones asked for.** The point of this case is that he has to
  decide what to ask for. A vague request gets "What would you do with that?"
- **Do not supply the decomposition.** If he asks "what should I multiply," say "that's what I'm asking you."
- Push once per block for the assumption behind a number he uses.
- Let silence sit. This case requires arithmetic done out loud and that takes pauses.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard.

---

## Block 1, framing and the product read

About 6 minutes.

**Interviewer.** "Leadership is deciding whether to fund a dedicated team next year whose whole job is
turning search visitors into logged-in regulars. They want a number from us first. Here's what we know."

> ### Context
>
> **The situation.** Most people who read Quora arrive on a question page from a Google result and are not
> logged in. Search traffic has been falling for six quarters. Logged-in weekly actives have fallen with it.
>
> **What we have.** Synthetic, most recent quarter, monthly.
>
> | Quantity | Value |
> |---|---|
> | Question-page sessions from search | 231M |
> | New accounts originating from those sessions | 0.83M |
> | Logged-in weekly active users | 8.0M |
> | Share of question-page sessions that are a single page | 88% |
>
> **The ask.** How much could logged-in weekly actives grow in twelve months if a team worked on nothing
> but this, and is that worth funding.

**Interviewer.** "Before any arithmetic. Who are these people and which of them could plausibly ever want
an account?"

**Listen for.**

- **Search visitors are not one population.** Someone who arrived on "how many ounces in a cup," got the
  number, and left is not a prospect and never will be. Someone who arrived on "what is it actually like to
  leave academia for industry," read three answers, and came back a week later on a related question is a
  different person entirely. Sizing has to be done on the second group, not on 231M.
- **The selection argument, which is the whole case.** The people for whom signing up is obviously worth it
  have largely signed up. Whoever is left is, by construction, harder to convert and less likely to stick
  around once converted. So the marginal converter is worse than the average converter on both dimensions,
  and any estimate that applies today's conversion and retention rates to tomorrow's marginal user is
  optimistic twice over, in a way that compounds.
- **What an account is actually for.** It buys a personalized feed, the ability to follow topics, and
  notifications. That is worth something to someone who wants to read Quora repeatedly and nothing at all
  to someone who wanted one fact. So the size of the opportunity is bounded by how many search visitors
  have a repeat-reading need they do not know about yet.
- Asking what the current conversion rate is before being handed it, and what "sustained" would mean.

**Strong signals.**

- Getting to the selection point unprompted, and naming its consequence for the arithmetic before doing any.
- Asking for the repeat-visit rate among logged-out visitors. That is the closest observable proxy for
  latent repeat-reading intent and it is the number that would bound the whole estimate. Whether Quora can
  measure it well is itself a good question, since cookie loss is heavy on mobile Safari.
- Saying that 88% single-page sessions is a ceiling signal, not just a descriptive fact.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Give me a rough ceiling before you do anything careful." | The repeat visitors are the only plausible pool, and if roughly one in eight sessions is a return visit, the addressable group is maybe 25 to 30 million people a month rather than 231 million. That is the number I'd size against, and I'd want the actual repeat rate before I trusted it |
| "Why not size against all 231M? Some of them will convert." | Because a rate estimated on today's converters applied to a population that has already declined to convert is the mistake the whole estimate lives or dies on. A few will, and they're in the tail, and treating them as average is how you get a number nobody believes |
| "Does it matter who they are if we only care about the total?" | Yes, because the two populations have different sustain rates, and sustain is what turns a signup into a weekly active. A signup that never comes back is a rounding error on the metric leadership is asking about |

**Model answer.** "The first thing I'd do is refuse to size against 231 million sessions, because those
aren't 231 million prospects. Most of them are someone who wanted a fact, got it, and has no reason to
want an account. An account buys you a personalized feed and notifications, which is worth something only
if you want to read Quora repeatedly. So the addressable pool is the people showing signs of repeat
reading, and the first number I'd ask for is the repeat-visit rate among logged-out visitors, with a caveat
that it's cookie-based and lossy on mobile. The second thing, which matters more than any parameter, is
that the people who find signing up obviously worthwhile have already done it. Whoever is left declined,
so the marginal converter is harder to convert and less likely to stick. That means I can't take today's
conversion rate and today's retention rate and apply both to a bigger push, because pushing harder moves
you down the intent curve and both numbers get worse together. I'd expect any naive estimate to be
optimistic by a multiple, not a margin."

**Traps.**

- Starting the arithmetic. The step is four minutes of product reasoning and reaching for a formula is the
  documented failure mode.
- Sizing against 231M.
- Treating conversion rate and retention rate as independent parameters to be improved separately.

**Score.** 4 starts multiplying, or sizes against all sessions. 6 segments the population and asks for the
current conversion rate. 8 names the selection argument and its consequence for the arithmetic before doing
any arithmetic, and asks for the repeat-visit rate.

---

## Block 2, build the estimate

About 13 minutes.

**Interviewer.** "Alright. Build me a number."

**Release on request only.**

> | Quantity | Value |
> |---|---|
> | Share of new accounts from search still a logged-in weekly active at 3 months | 11% |
> | Monthly churn rate of an established logged-in weekly active | 4% |
> | Repeat-visit rate among logged-out search visitors within 30 days, cookie-based | 12.4% |
> | What a dedicated team could plausibly do to the conversion rate, engineering's guess | 1.5x to 3x |

**Listen for.**

- **A decomposition written down explicitly**, with each factor either sourced or flagged as an assumption.
  Something like: sessions, times conversion rate, times the share that sustains, equals monthly inflow of
  sustained logged-in actives. Then a separate step to turn an inflow into a stock.
- **The current inflow computed as a baseline before any uplift.** 0.83M signups a month times 11% sustaining
  gives about 91,000 added sustained weekly actives a month. That number is the anchor for everything.
- Noticing that the 8.0M base and a 91,000 monthly inflow are not independent facts, and asking what the
  relationship is. That is the door to Block 3.
- Naming the unit of the answer. Leadership asked about weekly actives, which is a stock. Conversions are a
  flow. A candidate who reports a flow as though it answered a question about a stock has made the error the
  next block is about.

**Strong signals.**

- Computing the naive answer, and labeling it naive on the spot. Doubling the conversion rate and doubling
  the sustain rate, summed over twelve months, gives about 4.4 million new weekly actives, a 55% increase on
  the base. A candidate who produces that number and immediately says it cannot be right is in better shape
  than one who never produces it, because the naive number is what leadership will have in their heads.
- **Identifying which multiplication is illegitimate.** Doubling conversion and doubling sustain are not two
  independent wins. They trade against each other, because a harder push recruits lower-intent people whose
  sustain rate is worse. Assuming both double is the single largest error available in this case and it is
  worth a factor of three on its own.
- Sanity-checking against the base. If 0.83M signups a month sustain at 11%, where did 8.0M come from? Either
  other channels supply most of it, or the sustain rate used to be much better, and either answer changes how
  you read the opportunity.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Engineering says 3x conversion is achievable. Use it." | I'll use it as the top of a range, and I'd also say that 3x conversion almost certainly comes with a sustain rate below 11%, because the extra converters are the ones who declined at 1x. If I have to pick one number I'd take 2x conversion at a lower sustain rather than 3x at the same sustain |
| "Why not just report the 4.4M? It's what they asked for." | Because it assumes two things improve independently that in reality trade off, and because it adds up monthly flows as though nobody churns. I'd rather hand them a smaller number I can defend than a big one that falls apart in the first meeting where someone checks it |
| "You're using 11% sustain. Where does that come from and what if it's wrong?" | It's measured on today's converters, which is exactly the population I've argued is not representative of tomorrow's. So it's an upper bound on the marginal sustain rate, not an estimate of it. That's the parameter I'd most want measured properly |

**Model answer.** "Let me write down the chain and then put the naive number on the table so we can kill it.
Monthly search sessions, times conversion to a signup, times the share of signups that become a sustained
logged-in weekly active, gives an inflow. Today that's 231 million times about 3.6 per thousand, which is
830,000 signups, times 11% sustaining, so about 91,000 added sustained weekly actives a month. Now the naive
version: assume a dedicated team doubles conversion and doubles sustain, and add up twelve months. That's
four times 91,000 times twelve, or 4.4 million, which would be 55% growth on an 8 million base. I don't
believe it and I'd say so before anyone else does. Two things are wrong with it. The bigger one is that
doubling conversion and doubling sustain aren't independent. Converting twice as many people means reaching
into a group that already declined once, and those people sustain worse, so the product of the two factors
goes up by much less than four. If I had to guess I'd say doubling conversion buys you maybe 1.6x on the
product rather than 4x. The second problem is that I've added up flows for twelve months as if the people we
added in month one are all still there in month twelve, and they aren't, because logged-in actives churn at
about 4% a month. I'd want to handle that properly rather than with a fudge."

**Traps.**

- No explicit decomposition. An answer that arrives at a number without a written chain cannot be
  sensitivity-tested and cannot be argued with, which is the point of doing it.
- Multiplying two optimistic factors and not noticing they are correlated.
- Reporting a flow when the question was about a stock.
- Refusing to produce a number at all. This loop scores for reaching a decision.

**Score.** 4 produces a number with no chain, or refuses to estimate. 6 writes a clean decomposition and
computes the current inflow. 8 also puts the naive number up and kills it, identifying the correlated-factors
error as the dominant one.

---

## Block 3, the structural correction

About 9 minutes.

**Interviewer.** "You said adding up twelve months of flows isn't right. Fix it."

**Listen for.**

- **A stock-and-flow model, in words if not in symbols.** The stock of logged-in weekly actives rises with
  inflow and falls in proportion to itself. It does not grow without limit; it approaches a level where
  inflow equals churn. At 91,000 a month inflow and 4% monthly churn, that level is about 2.3 million, which
  is 29% of the current 8.0 million base. So this channel already supports roughly 2.3 million of the base and
  other channels supply the rest.
- **The consequence for the twelve-month number.** Doubling inflow doubles the level this channel eventually
  supports, adding about 2.3 million, but you do not get there in a year. With 4% monthly churn the approach
  is about 38% complete after twelve months, so the twelve-month gain is about 870,000, not 2.3 million and
  certainly not 4.4 million.
- Naming the time constant. One over the churn rate is 25 months, which is how long this takes to play out.
  A team funded on a twelve-month horizon is being measured before its work has mostly landed, and saying so
  is the most useful thing in this block for the actual decision.

**The full reconciliation, if he gets there.**

| Step | Twelve-month gain | What changed |
|---|---|---|
| Naive: double conversion and sustain, sum the flows | 4.4M | |
| Fix the correlated factors: double the inflow, not quadruple it | 1.09M | Factor of 4. The dominant error |
| Fix the stock and flow: added users churn during the window | 0.87M | Factor of 1.26 |

**Strong signals.**

- **Getting the relative sizes right.** The correlated-factors error is worth a factor of four and the
  stock-and-flow error is worth a factor of 1.26. A candidate who treats the structural fix as the headline
  has the statistics right and the priorities wrong, and this is a good place to test whether he sizes his own
  corrections. The product-sense error was five times more expensive than the mathematical one.
- Noticing that stock and flow matters much more over a longer horizon than a shorter one. Over twelve months
  at 4% churn, summing the flows is only 26% too high. Over three years it is badly wrong. So the structural
  model earns its keep when the question is about steady state and barely earns it when the question is about
  the first year.
- Asking whether 4% churn is the right churn to use. It is measured on established users. A newly converted
  search visitor almost certainly churns faster, which makes the inflow number optimistic again.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "So which of your two corrections actually mattered?" | The first one, by a lot. Assuming both factors double is worth a factor of four. The churn correction is worth about 26%. I'd lead with the first and mention the second, and I'd have been wrong to present them as equally important |
| "Is the steady-state number the one to report, or the twelve-month one?" | Twelve months is what they asked for and 2.3 million is what the work is actually worth if it holds. I'd give both and label the horizon on each, because a team funded against the twelve-month number will look like it failed even if it succeeded |
| "What if churn on new converts is 8% a month, not 4%?" | Then the steady state this channel supports is halved, and the twelve-month number moves much less than you'd expect, because faster churn lowers the ceiling and speeds up the approach at the same time. That partial cancellation is worth knowing before anyone spends a quarter measuring churn precisely |

**Model answer.** "The right structure is a stock with an inflow and a proportional outflow. Weekly actives
rise with conversions and fall at about 4% a month, so the stock approaches the level where those balance,
which at 91,000 a month inflow is about 2.3 million. That's a useful sanity check on its own: this channel
supports roughly 29% of our 8 million base, so most of the base comes from somewhere else. Double the inflow
and the level this channel supports goes to about 4.6 million, a gain of 2.3 million, but the time constant is
one over the churn rate, which is 25 months, so twelve months gets you about 38% of the way there. That's
about 870,000. Putting the two corrections next to each other: the naive 4.4 million was wrong by a factor of
four because I'd doubled two things that trade off, and wrong by a further 26% because I'd ignored churn
inside the window. The first error was the expensive one, and I want to be clear that the product reasoning
mattered five times more here than the stock-and-flow arithmetic did."

**Traps.**

- Presenting the stock-and-flow correction as the main finding. It is the smaller of the two.
- Reporting the steady-state number as though it were the twelve-month number.
- Using established-user churn for newly converted users without flagging it.

**Score.** 4 adds up monthly flows. 6 builds the stock-and-flow model and gets the twelve-month number. 8 also
reconciles the two corrections by size, says the product error was the expensive one, and names the time
constant as a problem for how the team will be judged.

---

## Block 4, sensitivity and where to stop

About 10 minutes. The block the guide's "rigor that knows when to stop" is aimed at.

**Interviewer.** "You've got a number. How much do you trust it, and what would you go measure?"

**The sensitivity, released a row at a time if he asks for it.** Twelve-month gain, varying one factor at a
time from the base case of a doubled inflow.

| Change | Twelve-month gain | Against base |
|---|---|---|
| Base case | 0.87M | |
| Inflow multiplier 1.5x instead of 2x | 0.44M | -50% |
| Inflow multiplier 3x | 1.74M | +100% |
| Sustain rate 6% instead of 11% | 0.47M | -45% |
| Sustain rate 16% | 1.27M | +45% |
| Churn 2% a month instead of 4% | 0.97M | +12% |
| Churn 6% a month | 0.78M | -10% |

**Listen for.**

- **The ordering, and why it is what it is.** The answer is most sensitive to the inflow multiplier and the
  sustain rate, and barely sensitive to churn. The churn result is the interesting one: halving churn only
  moves the twelve-month number 12%, because a lower churn rate raises the eventual ceiling and slows the
  approach to it, and over a one-year window those two effects mostly cancel.
- **The honest caveat about the ordering.** A sensitivity table's ranking is partly an artifact of the ranges
  chosen. Inflow was varied from 1.5x to 3x because that is engineering's stated range; sustain was varied
  plus and minus 45% around the measured 11%; churn plus and minus 50% around 4%. Different ranges would
  reorder the table, so the ranges have to be justified, not assumed. A candidate who presents a tornado
  ordering as a property of the model rather than of his chosen ranges has missed something real.
- **Where to stop.** The decision is binary: fund a team or not. The range across every plausible combination
  is roughly 0.4M to 1.7M, which is 5% to 21% on the base. If leadership's threshold for funding sits inside
  that range, more precision is needed. If it sits outside, it does not and the work should stop.
- **What to measure, and it is one thing.** The sustain rate of the *marginal* converter. Every number in the
  chain is measurable off existing logs except that one, which by construction cannot be observed until
  somebody pushes harder on conversion and watches what happens. It is also the parameter that decides whether
  this is a real opportunity or a treadmill.

**Strong signals.**

- Proposing to buy that number rather than model it. Run a conversion push on a random slice of search traffic,
  convert people who would not otherwise have converted, and follow them for a quarter. That is a small,
  cheap, genuinely randomized experiment, and it turns the load-bearing assumption into data.
- Saying explicitly that measuring churn precisely would be a waste of the quarter, on the evidence of the
  sensitivity table. Declining to measure something, with a reason, is the strongest version of the criterion
  this block scores.
- Reporting the estimate as a range with the binding assumption named, rather than as a point.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Leadership will want one number." | 0.9 million over twelve months, and about 2.3 million once it settles, which takes two years. But the number I'd actually put in front of them is the range and the one parameter it hinges on, because a point estimate here would imply precision I don't have |
| "Isn't 'go run an experiment' just deferring the question?" | It would be if the experiment were slow or expensive. This one is a conversion push on a slice of traffic and a quarter of follow-up, and it replaces the single assumption that the whole estimate rests on. I'd rather spend a quarter on that than a year on a team funded against a number nobody tested |
| "What if you can't run it?" | Then I'd bound the sustain rate from below using the people who converted late or after multiple visits, since they're the closest thing we have to reluctant converters, and I'd report the estimate with that as the floor and say plainly that the top of the range is untested |

**Model answer.** "The range across plausible inputs is about 0.4 to 1.7 million over twelve months, so 5 to
21% on the base. Whether that's precise enough depends entirely on where leadership's funding threshold sits,
and if it's outside that range we're done and I'd stop here. The table is most sensitive to how hard we can
push conversion and to the sustain rate, and it's barely sensitive to churn, which surprised me until I worked
out why: lowering churn raises the ceiling and slows the climb, and over twelve months those mostly cancel. I'd
flag that the ordering depends on the ranges I chose, so I'd want those agreed rather than assumed. The one
thing I'd go measure is the sustain rate of the marginal converter, because every other number in the chain is
already in the logs and that one isn't, and it's the difference between a real opportunity and a treadmill.
It's also buyable: push conversion on a random slice of search traffic, convert people who wouldn't otherwise
have converted, follow them for a quarter. I would explicitly not spend the quarter nailing down churn."

**Traps.**

- A tornado chart with no justification for the ranges.
- Recommending that everything be measured more precisely.
- Missing that churn is the cheap thing to be imprecise about.
- Not connecting the precision question to the funding threshold.

**Score.** 4 reports a point estimate or asks for more data generally. 6 runs the sensitivity and names the
sensitive parameters. 8 explains the churn cancellation, flags that the ordering depends on his chosen ranges,
ties precision to the funding threshold, and proposes buying the one unmeasurable parameter with a small
randomized push.

---

## Block 5, what you tell leadership

About 4 minutes.

**Model answer.** "Best estimate is 0.9 million additional logged-in weekly actives over twelve months, with
a plausible range of 0.4 to 1.7 million, which is 5 to 21% on today's 8 million. If the work holds it's worth
about 2.3 million at steady state, but the time constant is two years, so a team judged on twelve months will
look like it underdelivered even if it succeeded, and I'd fix the measurement horizon before funding rather
than after. The number everyone will have in their head is closer to 4 million, because that's what you get
from doubling conversion and doubling retention and adding up the months. Both of those moves are wrong and the
bigger one isn't the arithmetic: you can't double conversion and retention together, because converting twice
as many people means converting people who already declined once, and they stick around less. The whole estimate
hinges on that one parameter, the sustain rate of the marginal converter, and it's the only number in the chain
we can't get from existing logs. So my recommendation isn't fund it or don't. It's spend one quarter buying that
number with a conversion push on a slice of search traffic, then decide with it. If the marginal converter
sustains anywhere near 11%, this is worth a team. If it's closer to 5%, we'd be funding a treadmill."

**What pushes it to an 8.** Naming the number leadership already has in their head and dismantling it, rather
than only presenting his own. Flagging the horizon mismatch as a condition of funding. Recommending a
measurement instead of a verdict, with the measurement scoped to one quarter and one parameter.

**Traps.** A point estimate. Recommending fund or don't fund when the decisive parameter is unmeasured. Leading
with the stock-and-flow model, which is the smaller correction.

**Score.** 4 gives a number with no range or no recommendation. 6 gives the range and a recommendation.
8 dismantles the naive number, names the horizon problem, and scopes the one measurement that would settle it.

---

## Block 6, your questions

About 3 minutes. Not scored.

- "Do you know the sustain curve for search-originated signups separately from other channels?"
- "How does the team usually size something that doesn't exist yet, and how often does the estimate
get checked afterward?"
- "Is there an agreed churn number for logged-in actives, or does everyone use their own?"
- "When a sizing estimate turns out wrong here, does anyone go back and find out which assumption broke?"

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| Framing an open-ended question | | |
| Model formulation | | |
| Assumptions and their consequences | | |
| Rigor that knows when to stop | | |
| Product intuition | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Framing | Sizes against all 231M sessions | Segments the population, asks for the conversion rate | Names the selection argument and its arithmetic consequence before computing anything |
| Model formulation | A number with no written chain | An explicit decomposition with sourced factors | Also builds the stock-and-flow step and sanity-checks the inflow against the base |
| Assumptions | Multiplies optimistic factors independently | Notices the correlation when pushed | Kills the naive number unprompted and sizes his own two corrections against each other |
| Rigor that knows when to stop | Wants everything measured better | Runs a sensitivity and names what matters | Explains the churn cancellation, justifies his ranges, ties precision to the funding threshold, declines to measure churn |
| Product intuition | Treats search visitors as one population | Distinguishes fact-seekers from repeat readers | Derives the whole estimate's binding constraint from what an account is actually for |
| Communication | Point estimate, method first | Range with a verdict | Dismantles the number leadership already holds, and recommends a measurement rather than a verdict |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he produce the naive 4.4M himself, or did it have to be handed to him?
- Did he rank his two corrections by size, or present them as equally important?
- Did he decline to measure anything?

| Block | Target | Actual |
|---|---|---|
| 1. Framing | 6 min | |
| 2. Build the estimate | 13 min | |
| 3. Structural correction | 9 min | |
| 4. Sensitivity | 10 min | |
| 5. Leadership | 4 min | |

Top three fixes for the next mock.

1.
2.
3.
