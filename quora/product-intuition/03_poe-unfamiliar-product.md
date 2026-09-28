# Case 03, a product you do not use

A mock interview for the **Product Intuition** round. 45 minutes, with the hiring manager. Claude plays
Nick Sher.

**Priority note, read this first.** The recruiter said at the first meeting that this role is on Quora, and
Joseph has asked him to confirm it in writing. See the asterisk in `../private/final-round-email.md`. If that
confirmation arrives, **this is the lowest-priority case in the folder** and one read-through is enough. It
exists because the invitation email says questions "can touch either Quora or Poe," and because the skill it
drills is worth having whether or not Poe comes up: reasoning usefully about a product you have barely used,
and saying so without either bluffing or going passive.

**Why it is product sense forward.** There is no fallback here. On a Quora question he can lean on having
used the product. On Poe he cannot, so everything has to come from first principles about who pays, what they
are paying for, and where the money goes. That is product sense with the training wheels off, and it is the
most honest test of it in the folder.

## What Poe actually is

Verified from Poe's own pages and contemporaneous reporting, September 2026. Do not go into the room with more
than this unless he has used it.

| Fact | Detail |
|---|---|
| What it is | A multi-model AI chat product. One subscription, many underlying models from OpenAI, Anthropic, Google, Meta, Mistral, Cohere and others, plus image and video tools |
| Platforms | Web, iOS, Android, macOS, Windows |
| Bots | Millions of community-created bots sit on top of the underlying models, alongside official ones |
| Tiers | A free tier, a Starter tier around $4.99 a month, and Premium at $19.99 a month or $199.99 a year |
| The metering | Subscribers get a monthly allowance of compute points. Each message consumes points, and the cost per message varies a lot by model, so a frontier model burns the allowance far faster than a cheap one |
| Creator monetization | A pool funded by setting aside about $10 per monthly subscription and $20 per annual one, distributed to creators whose bots drove the conversion; referral bounties up to about $20 per converted subscriber; and creators can set their own per-message price |
| Strategic position | Poe has had most of the company's investment attention since at least 2024, and took a $75M round from Andreessen Horowitz in January 2024 aimed at it |

**What that structure means, and it is the thing to have thought about beforehand.** Poe is a reseller with a
variable cost of goods sold that it does not control. Every message costs Poe real money at a rate the model
providers set, and revenue is a flat subscription. So the compute points allowance is not a feature, it is
the mechanism that keeps a fixed-price product solvent against a variable cost, and every interesting product
decision on Poe runs through it.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Invitation email | "Questions in every round are framed around our products, and can touch either Quora or Poe" | The entire premise |
| Prep guide | "We'll provide context for any feature we discuss, but familiarity helps you build intuition" | Block 1. Context will be provided. Intuition will not |
| Nick, in the guide | "If you get stuck, say so; I would rather see you think out loud than watch you perform" | Block 1 is that sentence made into a test |
| Email | "What evidence you'd want before making a call, and how you weigh user impact" | Block 3 |
| Prep guide, FAQ | "Do I need to be an AI expert? No. What we look for is judgment about when it helps and when it's risky" | Block 5 |
| Prep guide | This role sits on Quora | Block 5, where the transfer question is asked honestly |

## Clock

| Block | Minutes | Assessed |
|---|---|---|
| 1. Have you used it | 5 | Honesty under uncertainty |
| 2. What is Poe for, and who pays | 9 | Product reasoning from first principles |
| 3. The allowance decision | 15 | Product judgment, evidence, user impact |
| 4. How you would get up to speed | 6 | Self-direction |
| 5. What transfers | 6 | Role fit |
| 6. His questions | 4 | Not scored |

## How Claude runs it

- Play Nick. He knows Poe well and Joseph does not, and he is not trying to catch him out.
- **In Block 1, if he bluffs, ask a specific follow-up he cannot answer** ("which model do you find burns
  points fastest?"). Do it once, without malice. The recovery is what is being scored.
- **Supply Poe mechanics freely when asked.** The guide says context will be provided. Withholding it tests
  nothing useful. What is scored is what he does with it.
- Do not signal a preferred answer in Block 3.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard.

---

## Block 1, have you used it

About 5 minutes. Short, and the most diagnostic block in the case.

**Nick.** "Before we get into it. How much have you used Poe?"

**The three answers, and only one of them works.**

| Answer | How it lands |
|---|---|
| Bluffing. Implying regular use, or answering as though he has one | Fails on the first specific follow-up, and then everything after it is discounted. The worst available outcome and it is entirely self-inflicted |
| Over-apologizing. "Not much, sorry, I should have" and then waiting | Reads as passive. Nick's note says he would rather see someone think out loud than perform, and going quiet is a kind of performance too |
| Honest and then immediately useful | "I've used it a little and I'm not a regular. Here's what I understand the product to be and where I'd expect I'm wrong, and you can correct me." Then reason |

**Listen for.**

- **The structure of the good answer: state the limit, state what he does understand, invite correction, keep
  going.** Four beats, about twenty seconds. The limit is stated once and not returned to.
- No repeat apologizing. Saying it once is honest; saying it three times makes it the topic.
- Asking one good orienting question rather than five. "Is the subscription the whole business, or is there an
  API or enterprise side?" is a question whose answer changes how he would reason about everything else.

**Strong signals.**

- Having a view on it anyway. Not using a product is not the same as having no opinion about its shape, and a
  candidate who has thought about why someone would pay for a multi-model wrapper has done the work that
  matters.
- Naming what he would be careful about. Anything that depends on the texture of daily use, such as which
  interactions feel good, is where his read is unreliable, and flagging that is more useful than a confident
  guess.

**Follow-ups.**

| Follow-up | What it tests |
|---|---|
| "Which model do you find burns points fastest?" | Only asked if he bluffed. The recovery is the score |
| "Does it bother you to reason about a product you don't use?" | Whether he is defensive about it |
| "What would you want to know first?" | Whether his orienting question is load-bearing or generic |

**Traps.**

- Bluffing.
- Three apologies.
- Going passive and waiting to be led.
- Pivoting immediately to Quora, which reads as dodging.

**Score.** 4 bluffs, or apologizes and stops. 6 is honest and then engages. 8 states the limit once, offers a
structural read anyway, asks one question whose answer would change his reasoning, and never mentions the gap
again.

---

## Block 2, what is Poe for, and who pays

About 9 minutes.

**Nick.** "Fine. So reason it out for me. Who pays $19.99 a month for Poe when they could pay roughly the same
for ChatGPT or Claude directly?"

**Listen for.**

- **The obvious answer and its weakness.** The obvious answer is breadth: one subscription, many models. The
  weakness is that breadth is only worth paying for if the user genuinely switches between models, and most
  people settle on one. So the population that values Poe is the population that switches, and how large that
  is is the central question about the business.
- **Who actually switches.** People whose work spans tasks the models are differently good at, people who want
  to compare outputs, people building or using specialized bots, and people who want access to a new model the
  day it lands without another subscription. That is a real population and it is plausibly a narrow one.
- **The bots as the answer to the substitution problem.** Millions of community bots are the thing a direct
  subscription cannot replicate. That is Poe's actual moat if it has one, and it means the interesting question
  is whether people come for the models and stay for the bots or the reverse.
- **The economics, unprompted.** Flat revenue, variable cost that a supplier sets. That makes Poe structurally
  different from a first-party model provider, whose cost is its own infrastructure. Poe cannot get cheaper by
  being clever about serving; it can only manage which models get used and how much.
- The creator pool as a customer acquisition cost rather than as generosity. Setting aside $10 of a $19.99
  subscription is a very large share, and it makes sense as paying for distribution.

**Strong signals.**

- Getting to the variable-cost point without being handed it. It is the fact that makes every subsequent
  decision legible.
- Noticing that the creator payout and the compute cost are both charged against the same subscription, so
  Poe's margin is squeezed from both ends, and that the points allowance is the only lever it fully controls.
- Asking whether the free tier is a funnel or a cost sink, and what share of subscribers come from bots versus
  direct.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "So is breadth enough of a reason?" | For a minority, and I'd want to know how big it is. The number I'd ask for is the share of subscribers who send meaningful volume to more than one model family in a month. If that's small, breadth is the marketing story and something else is the retention story, probably the bots |
| "Why give creators $10 out of $19.99?" | Because it isn't generosity, it's acquisition. If a bot brings a subscriber who stays two years, $10 once is cheap. The thing I'd want to check is whether the subscribers creators bring retain as well as the ones who arrive directly, because if they churn faster the payout is buying worse customers at the same price |
| "What's the biggest risk to the business?" | That the model providers move up the stack. Poe's cost is set by companies that also sell the end product, so its margin exists at their discretion. The defense is the bots and the switching, and neither is owned |

**Model answer.** "The pitch is one subscription for many models, and that's only worth paying for if you
actually switch, which most people don't. So the population that values Poe is the switchers, and I'd want to
know how big that is: the share of subscribers sending real volume to more than one model family in a month.
If it's small, breadth is the marketing and the bots are the retention, because millions of community bots are
the one thing a direct ChatGPT subscription can't give you. The structural thing I'd want to understand before
anything else is that Poe is a reseller with a variable cost it doesn't set. Every message costs real money at
a rate the providers choose, and revenue is flat. That's completely different from OpenAI's position, where
the cost is their own infrastructure. And the subscription is getting charged twice, once for compute and
once for the creator pool, where $10 out of $19.99 is a lot. So the points allowance isn't a feature, it's the
only lever Poe fully controls between a fixed price and a cost somebody else sets. Everything interesting
about this product probably runs through it."

**Traps.**

- Stopping at "convenience, one subscription."
- Treating Poe as a smaller ChatGPT rather than as a different kind of business.
- Missing the variable cost structure.
- Talking about models and never about who pays.

**Score.** 4 gives the convenience answer and stops. 6 identifies switchers as the relevant population and the
bots as differentiation. 8 gets to the reseller cost structure unprompted, sees the creator pool as
acquisition, and identifies the points allowance as the only controlled lever.

---

## Block 3, the allowance decision

About 15 minutes. Scenario is synthetic and labeled as such; the mechanics it runs on are real.

**Nick.** "Here's a live version of exactly that. Synthetic numbers, real shape."

> ### The situation
>
> The newest frontier models cost several times more per message than the ones most subscribers used a year
> ago, and subscribers have shifted toward them. Premium's gross margin has gone from comfortable to thin.
> Three options are on the table.
>
> | Option | What it does |
> |---|---|
> | A. Cut the points allowance | Premium keeps its $19.99 price and gets fewer points a month |
> | B. Raise the price | Premium goes to $24.99, allowance unchanged, existing subscribers grandfathered for six months |
> | C. Steer usage | Default new conversations to a cheaper model, with the expensive ones a deliberate choice |
>
> Whichever is chosen applies to Premium, which is most of the revenue.

**Nick.** "Which one, and what would you want to know first?"

**No right answer. Claude must not signal one.** What is scored:

**Listen for.**

- **Recognizing that the three options fall on different people.** A cuts the product for heavy users, who are
  the ones burning the points and are plausibly the most engaged and most likely to be creators or advocates.
  B charges everyone, including light users who were profitable already, and light users churn more readily on
  a price change because they were marginal anyway. C changes the product for everyone slightly and costs
  nothing to whoever notices and switches back. Working out who pays under each option is the core of the
  answer.
- **The takeaway asymmetry.** A reduces something people already have inside a subscription they already
  bought. That is experienced differently from a price increase for new subscribers, and it generates more
  anger per dollar recovered. B's grandfathering is an attempt to buy that off and it only delays it.
- **The distribution question, which is the piece of evidence that matters most.** Points consumption is
  almost certainly extremely skewed. If a small share of subscribers burns most of the compute, then A can be
  calibrated to touch almost nobody, and the whole decision changes. If consumption is broad, A is a
  across-the-board degradation. Asking for the consumption distribution before choosing is the single
  strongest move available.
- **C's hidden cost, which is the interesting one.** Steering to a cheaper model degrades the product in a way
  that is hard to see and hard to complain about, which makes it attractive to management and corrosive over
  time. People do not churn the week the answers get slightly worse; they churn three months later and say the
  product stopped being useful. That is the option whose damage is least measurable, which is a reason to be
  careful with it rather than a reason to prefer it.

**Strong signals.**

- Proposing a version of A that is calibrated to the distribution rather than flat: leave the allowance alone
  for the great majority and introduce metering only in the tail, which recovers most of the cost and touches
  the fewest people. Whether that is the right call is arguable; recognizing that A is a family of options
  rather than one is the insight.
- Naming the measurement problem honestly. The outcome that matters is churn, which is slow, and you cannot
  cleanly A/B test a price change on existing subscribers without them noticing and without a fairness problem.
  So the evidence will be worse than usual and the decision has to be made with that acknowledged. A candidate
  who proposes a clean experiment here has not thought about who would see it.
- Distinguishing the reversible from the irreversible. C is reversible. A is partly reversible. B is not,
  practically, because rolling back a price increase is an admission.
- Naming the creator side. Heavy users are disproportionately likely to be bot creators, and creators drive
  acquisition through the referral pool, so degrading heavy users has a second-order cost on the growth engine
  that does not show up in a margin calculation.

**Nick's counterarguments.** Argue against whatever he chooses.

| If he chose | Nick pushes |
|---|---|
| A, cut the allowance | "So we're degrading the product for our most engaged users to protect a margin. Those are our advocates" |
| B, raise the price | "Every light subscriber who was already profitable now has a reason to look at their bank statement. Why would you touch them?" |
| C, steer usage | "You've just made the product quietly worse and given yourself no way to know. How would you ever detect that?" |
| Any | "You want the consumption distribution. It'll take a week and the margin is thin now. Pick one today" |

**Model answer, one defensible version.** "Before choosing I'd want one number: the distribution of points
consumption across Premium subscribers. My guess is it's extremely skewed, and if it is, these three options
stop being comparable. A flat allowance cut hits everyone to solve a problem a small minority creates, and a
tail-calibrated version of A recovers most of the cost while touching almost nobody. That's the option I'd
push for, and it's not really option A as written, it's a fourth one the list doesn't have. On the others: B
charges light subscribers who were already profitable, and they're the ones most likely to churn on a price
change because they were marginal to begin with, so it recovers money from the wrong end. Grandfathering for
six months doesn't solve that, it schedules it. C worries me most, and not because it's the smallest change.
It degrades the product in a way nobody can see and nobody complains about, so it feels cheap and the cost
shows up three months later as people saying Poe stopped being useful, with no way to attribute it. The option
whose damage is hardest to measure isn't the safest one. On user impact specifically: a points cut is a
takeaway from something people already bought, which generates more anger per dollar than charging new
subscribers more, and I'd weigh that as a real cost rather than a PR problem. And I'd flag a second-order
effect, which is that heavy users are disproportionately bot creators, and creators drive acquisition through
the referral pool, so degrading them has a growth cost that a margin calculation won't show. The honest thing
about the evidence is that the outcome that matters is churn, it's slow, and we can't cleanly test a price
change on existing subscribers without them noticing. So this gets decided with worse evidence than we'd like,
and the thing I'd insist on is a measurable canary, which is why I'd take the reversible option over the
elegant one if we can't get the distribution this week."

**Traps.**

- Choosing without asking for the consumption distribution.
- Treating C as the safe option because it is the least visible.
- Proposing a clean A/B test on price to existing subscribers.
- Ignoring the creator flywheel.
- Reasoning about margin and never about the person whose product got worse.

**Score.** 4 picks an option with no evidence and no view on who pays. 6 asks for the distribution and reasons
about incidence. 8 also recognizes A is a family rather than one option, names C's unmeasurability as a reason
for caution rather than comfort, names the creator second-order effect, and is honest that the evidence here
will be poor.

---

## Block 4, how you would get up to speed

About 6 minutes.

**Nick.** "Say you ended up working on Poe. How would you get to the point of having useful opinions?"

**Listen for.**

- **Use it seriously, as the first item.** Not a demo. A month of actually trying to get work done with it,
  including hitting the points limit, which is where the product's real constraint lives and is invisible to
  anyone who has not hit it.
- Reading what churned subscribers said, which is the cheapest source of product understanding in any
  subscription business and is usually sitting unread.
- Talking to bot creators, since they are both a supply side and an acquisition channel and their incentives
  are the least intuitive part of the system.
- **A specific first analysis rather than a general plan.** Something like the consumption distribution and its
  relationship to retention, because it is the thing every pricing and packaging decision runs through and it
  is almost certainly not well understood.
- Naming a time box. Four to six weeks before he would expect to be useful, with a specific deliverable at the
  end, is a better answer than an open-ended learning plan.

**Traps.** A reading list. "I'd talk to stakeholders" with no named question. No time box. Not mentioning
using the product until prompted.

**Score.** 4 gives a generic onboarding plan. 6 includes using the product and talking to people, with a
question in mind. 8 names hitting the points ceiling as the specific experience that matters, names one first
analysis and why, and time-boxes it.

---

## Block 5, what transfers

About 6 minutes.

**Nick.** "This role is on Quora, to be clear. But does anything about how you'd think about Poe change how
you'd think about Quora?"

**Listen for.**

- **The structural comparison, honestly drawn.** Both are two-sided. On Quora the supply side is writers paid
  in audience and status; on Poe it is bot creators paid in cash through a referral pool. Both have a scarce
  resource that everything competes for, feed slots on one and compute points on the other. Both have most of
  their value created by a small minority of the people on them.
- The difference that matters: Quora's marginal cost per reader is near zero and Poe's is real and set by
  somebody else. That changes which decisions are even available. On Quora you can serve more content to more
  people and argue about whether it is good. On Poe every additional message has a price.
- A view, not a diplomatic non-answer, on the fact that Poe has had most of the company's attention. The
  honest framing is that it is relevant context for what the Quora data team's job is, because a product
  expected to fund the company and a product expected to grow it get different questions asked of them.

**Strong signals.**

- Saying what the comparison buys practically: the compute-points skew and the writer-volume skew are the same
  shape, so the analytical habits transfer even though the products do not.
- Handling the investment-attention question without either complaining about it or pretending not to have
  noticed. "It changes what questions Quora's data team is being asked, and I'd want to know which ones" is the
  adult version.

**Traps.** Claiming the products are basically the same. Diplomatic evasion on the investment question.
Treating "this role is on Quora" as permission to stop thinking about Poe.

**Score.** 4 says they are both AI products, or evades. 6 draws the two-sided comparison. 8 names the marginal
cost difference as the thing that changes which decisions exist, and handles the investment question with a
view rather than a dodge.

---

## Block 6, his questions

About 4 minutes. Not scored.

- "How much does the Quora data team interact with Poe's, and are the metrics shared or separate?"
- "Does the Quora side get asked different questions because Poe is where the investment is?"
- "Is there a single top-line metric that spans both products, or are they run independently?"
- "If I joined on Quora, how likely is it I'd be pulled onto a Poe question?"

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| Honesty under uncertainty | | |
| Product reasoning from first principles | | |
| Product judgment | | |
| Evidence and user impact | | |
| Self-direction | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Honesty under uncertainty | Bluffs, or apologizes and stops | Honest and then engages | States the limit once, offers a structural read anyway, asks one load-bearing question, never returns to the gap |
| First principles | Convenience, one subscription | Identifies switchers and the bots | Reaches the reseller cost structure unprompted and identifies the points allowance as the only controlled lever |
| Product judgment | Picks an option with no evidence | Asks for the distribution and reasons about incidence | Sees A as a family of options, treats C's unmeasurability as a risk, names the creator second-order effect |
| Evidence and user impact | Margin reasoning only | Weighs the takeaway against the price rise | Honest that churn evidence will be poor and that a clean price test is not available, and insists on a canary |
| Self-direction | A reading list | Uses the product, talks to people | Names hitting the points ceiling, one first analysis, and a time box |
| Communication | Hedges throughout | Clear positions | Positions held under counterargument, gap acknowledged once and not performed |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he bluff in Block 1? If so, how did the recovery go?
- How many times did he apologize for not using Poe?
- Did he reach the variable-cost structure before it was handed to him?
- Did he ask for the consumption distribution before choosing?

| Block | Target | Actual |
|---|---|---|
| 1. Have you used it | 5 min | |
| 2. What is Poe for | 9 min | |
| 3. The allowance decision | 15 min | |
| 4. Getting up to speed | 6 min | |
| 5. What transfers | 6 min | |

Top three fixes for the next mock.

1.
2.
3.
