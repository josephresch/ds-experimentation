# Cutting email frequency for readers who stopped opening

An experiment design study for Quora, built from public product documentation and published sender
guidelines. The data is synthetic. The internal systems described are a plausible reconstruction
rather than a description of Quora's architecture.

## Problem

Quora Digest is a personalized email of questions and answers from a reader's topics. Frequency is a
setting with daily, weekly and never, and most people who receive it are on daily.

A large group of daily subscribers has stopped opening. They still get an email every day. Over six
weeks a few percent of them unsubscribe, and a smaller share mark the email as spam, which affects
how mailbox providers treat every message Quora sends, including the ones engaged readers want.

The proposal is a quiet mode. Daily subscribers with no open in 21 days move to the weekly digest
automatically. The weekly email carries the week's top stories from their topics, says the frequency
changed, and has a one-click link back to daily.

| Scenario quantity | Value |
|---|---|
| Daily subscribers with no open in 21 days | 12.0M |
| Unsubscribe rate among them over six weeks | 3.1% |
| Marked a digest as spam over six weeks | 0.60% |

The decision is whether sending less email to people who ignore it is worth the visits it costs.

## Design tensions

| Tension | How it shows up |
|---|---|
| An unopened email looks free and is not | Unsubscribes are permanent, and complaint rates feed sender reputation for the whole domain |
| The obvious metric moves the wrong way for the right reason | Sending fewer, better emails raises open rate no matter what happens to visits |
| The cost is immediate and the benefit accumulates | A six-week average gives full weight to an adjustment period and almost no weight to a loss that compounds for months |
| Part of the benefit is shared with the control group | Complaints from either arm shape the same sender reputation, so the contrast understates the delivery gain |
| Eligibility is defined by the behavior the treatment changes | Recomputing eligibility mid-test lets the two groups drift into different populations |
| The eligible group is not one group | Someone who last opened 22 days ago and someone who last opened two years ago sit in the same rule |

## Framing

The mechanism is a trade between a visit today and the ability to reach someone at all next quarter.
A daily email works as a reminder even unopened, so removing it costs visits now. The same email
produces unsubscribes and complaints at a steady rate, and each unsubscribe removes a channel
permanently.

That makes the decision a rate question rather than an average question. What matters is how fast
each arm loses reachable people, how much a reachable person is worth, and whether the visit cost
persists or fades. A six-week difference in days active answers none of those three on its own.

Unsubscribes do the work that a long-run metric normally would. They are observable in weeks, they
are close to irreversible, and they map onto a quantity the business cares about over years. A
short-run metric earns that role only when the link to the long run can be stated and priced, which
is the test any stand-in metric has to pass.

The same problem appears from the other direction in [feed ranking](01-feed-ranking.md), where the
short-run metric that moved was the one that carried the least information about value.

## Public figures

- Quora Digest is a personalized email of questions and answers drawn from a reader's topics, and
  its frequency setting offers daily, weekly or never
- Quora described digest ranking in 2017 as similar to feed ranking
- Digest emails carry ads, and advertisers can buy digest placements
- Space answers were added to the digest
- Gmail's published sender guidelines tell bulk senders to keep reported spam rates below 0.3% and
  to aim below 0.1%, and describe reputation as a property of the sending domain rather than of an
  individual message

## Scenario

Synthetic, per eligible user over six weeks.

| Metric | Mean (SD) |
|---|---|
| Days active | 1.80 (3.9) |
| Digest opens | 0.41 |
| Sessions started from a digest | 0.21 |
| Unsubscribed from the digest | 3.1% |

Email tests can use up to 20% of eligible users. Quora also sends notification email, such as upvotes
on a reader's answers, which this change does not touch.

## Arithmetic

```
MDE ≈ 2.8 · SD · sqrt(2 / n) / mean
```

At 1.2M users per arm the detectable change in days active is about 0.8% relative. The unsubscribe
rate is a proportion near 3%, so its standard error is about 0.016 points and the six-week difference
between arms can be read to a few hundredths of a point.

The asymmetry is the point of the design. The metric that decides the case is measured far more
precisely than the metric the objection will be raised on.

---

# Design decisions

## 1. Objective

The decision is whether to move dormant daily subscribers to a weekly digest.

The objective is visits over months from this group, subject to keeping as many of them reachable as
possible. Reachability is not a separate concern, it is the input to every future email campaign,
so a design that maximizes this quarter's sessions by burning the list is optimizing against next
year.

The scope boundary is time. Six weeks can measure the adjustment cost and the rate at which each arm
loses subscribers. It cannot measure the value of a retained subscriber, which has to come from
somewhere else, and cannot observe the multi-quarter outcome that the decision is really about.

## 2. Primary metric

Days active per eligible user, counted from any source rather than from email, read as a trend across
the test rather than as a single six-week total.

Counting visits from any source is the load-bearing choice. Sessions attributed to the digest fall by
construction when fewer emails go out, and some of those sessions are visits the person would have
made anyway. Only a source-agnostic count can tell a lost visit from a relabeled one.

| Candidate | Why it is rejected |
|---|---|
| Digest open rate | Rises mechanically when send volume falls. A perfect score is available by sending one email a year |
| Sessions started from a digest | Measures the channel, not the person. It is a secondary for explaining a movement in days active |
| Share who switch back to daily | An opt-out rate, which understates dissatisfaction because switching back requires noticing and caring |

Unsubscribes and spam complaints are read beside the primary rather than below it. They are the term
that outlives the test window.

## 3. Secondaries and guardrails

Secondaries.

- Digest opens, sessions from the digest, sessions from every other source
- Share who switch back to daily
- Days active by two-week window, which is how the trend is read

Guardrails.

| Guardrail | Why |
|---|---|
| Email ad revenue per user | Fewer sends is less inventory, and the loss is immediate |
| Support contacts about email | A silent frequency change can read as a bug |
| Notification email volume | Confirms the change touched only the digest |

## 4. Randomization

The unit is the user. Eligibility, meaning a daily subscriber with no open in 21 days, is evaluated
once on the day the test starts and then frozen.

Freezing eligibility is the design's most important mechanical decision. Quiet mode changes whether
people open, opening is what the eligibility rule reads, and recomputing it daily would let the two
arms diverge into different populations while both still look like "dormant subscribers".

Allocation is 10% per arm, about 1.2M users each. Everyone stays in the arm they were assigned to,
including the 4% who switch back to daily and everyone who unsubscribes. Dropping the switchers would
remove exactly the people who disliked the treatment.

Duration is at least six weeks. Email habits move slowly, unsubscribes accumulate, and the first two
weeks are the least representative part of the window.

## 5. Power

Days active resolves about 0.8% relative, which is enough to see a cost of the size that turned up and
not enough to declare a small residual cost zero. The unsubscribe gap is measured far more precisely,
which is convenient, since the projection rests on that number rather than on the noisier one.

## 6. Health checks

- Sample ratio against the intended split
- Eligibility list frozen at assignment, with no recomputation during the test
- Send logs match assignment, so nobody in quiet mode received daily email
- Sessions attributed to the digest by the same link tracking in both arms

## 7. Results

Six weeks, 10% of eligible users per arm. Synthetic.

| Per eligible user over six weeks | Control | Quiet mode | Change | 95% CI |
|---|---|---|---|---|
| Users | 1,200,412 | 1,199,588 | | |
| Days active | 1.80 | 1.78 | -1.1% | -1.6% to -0.6% |
| Digest emails received | 41.3 | 6.7 | | |
| Digest opens | 0.41 | 0.50 | +22% | +21% to +23% |
| Sessions started from a digest | 0.21 | 0.17 | -19% | -20% to -18% |
| Other sessions | 3.90 | 3.87 | -0.8% | -1.4% to -0.2% |
| Unsubscribed from the digest | 3.1% | 0.9% | -2.2 points | -2.24 to -2.16 |
| Marked a digest as spam | 0.60% | 0.12% | -0.48 points | -0.50 to -0.46 |
| Switched back to daily | | 4.0% | | |

The split is 49.98% treated, p = 0.59.

Both sides of the trade are visible and both are real. Days active falls about 1%, with an interval
clear of zero, and the loss is not only email sessions, since other sessions fall slightly too. The
daily email was reminding some people to visit even when they did not open it.

Against that, unsubscribes fall by roughly 70% and spam complaints by 80%. Opens rise 22% while
sessions from the digest fall 19%, which is the clearest possible demonstration that open rate cannot
arbitrate this decision.

## 8. Diagnosis

Two claims are in contention. Either the cost is a permanent consequence of sending less email, or it
is an adjustment while control quietly loses people it will never reach again.

| Kind | Hypothesis | What the cut must show |
|---|---|---|
| Time | The cost is an adjustment that fades | A shrinking gap across two-week windows |
| Reach | Control keeps losing reachable people | A subscriber gap that widens at a steady rate |
| Who | The cost sits with readers who opened recently | A larger loss in the recent-opener segment |
| Value | The digest is worth enough to price the trade | An outside estimate of what removing the digest costs a subscriber |
| Ecosystem | Fewer complaints improve delivery for everyone | Inbox placement moving, which the test cannot attribute |
| Measurement | Sends or sessions were counted differently | A mismatch between assignment and send logs |

**Days active by two-week window.**

| | Weeks 1 and 2 | Weeks 3 and 4 | Weeks 5 and 6 |
|---|---|---|---|
| Control | 0.620 | 0.600 | 0.580 |
| Quiet mode | 0.606 | 0.595 | 0.579 |
| Change | -2.3% (-2.9% to -1.7%) | -0.8% (-1.5% to -0.1%) | -0.2% (-0.9% to +0.5%) |

The cost is concentrated immediately after the switch and is indistinguishable from zero by the last
window. The six-week average is therefore a statement about the transition, not about the steady
state.

**Reachable subscribers over time.**

| Still subscribed to the digest | End of week 2 | End of week 4 | End of week 6 |
|---|---|---|---|
| Control | 98.9% | 97.9% | 96.9% |
| Quiet mode | 99.7% | 99.4% | 99.1% |

The gap widens by about 0.37 points a week and shows no sign of slowing. This is the term that makes
the decision, because it compounds while the visit cost does not.

**By how recently the reader last opened.**

| Segment | Share of eligible users | Days active, control | Days active | Unsubscribed, control | Quiet mode |
|---|---|---|---|---|---|
| Opened in the last 90 days, not the last 21 | 35% | 3.60 | -1.4% (-2.1% to -0.7%) | 2.2% | 0.7% |
| No open in 90 days | 65% | 0.83 | -0.4% (-1.3% to +0.5%) | 3.6% | 1.0% |

The visit cost is concentrated in readers who opened recently, who are also the more active half of
the group. For long-dormant readers there is no cost the test can distinguish from zero and the
unsubscribe saving is largest. The rule as written treats these two populations identically, and it
does not have to.

**What a subscriber is worth.** A previous holdout stopped the digest at random for a sample of
subscribers. Those users had about 18% fewer days active over the following three months. That
holdout covered all digest subscribers, most of whom open the email, so 18% is an upper bound for
this dormant group.

**Projection.** At 0.37 points a week, the subscriber gap reaches about 4.8 points over a quarter.
Priced at the holdout's 18%, that is roughly 0.9% of days active that control gives up permanently,
against quiet mode's residual cost of about 0.2%.

The projection's assumption is doing visible work, so the break-even is the more useful number. Quiet
mode comes out ahead over a quarter as long as the digest is worth more than about 4% of a dormant
subscriber's visits, since `0.2 / 4.8 ≈ 4%`. The first two-week window, where removing the daily
email cost 2.3%, already suggests the true figure is well above that.

**Delivery.** Inbox placement across all Quora digest email measured 91% the month before the test
and 92% during it. Complaints from both arms feed the same sender reputation, so this cannot be
attributed to the test, and it points in the direction that says the test understates the benefit.

**Measurement.** Eligibility was frozen before assignment, send logs match assignment, and session
attribution is identical across arms.

## 9. Decision

Launch quiet mode with a permanent holdout, and use a longer inactivity window for readers who opened
recently.

The cost is real, front-loaded and fading. The benefit is smaller per week and permanent, and it
compounds at a rate the test measured precisely. The break-even sits far below any plausible value of
the digest to these readers.

Three qualifications belong in the same recommendation.

- Recent openers, meaning readers who opened in the last 90 days, carry most of the visit cost. Move
  them at 45 days without an open instead of 21, and test that threshold directly rather than
  assuming it
- Keep 2% of eligible users on daily for at least a quarter, to confirm the steady state and to
  measure email ad revenue, which falls with send volume
- Report the projection as a projection. The 18% figure comes from a different population, the
  break-even does not depend on it, and that is why the break-even is the number to lead with

## 10. Limits

| Cannot fix | Why | What to do instead |
|---|---|---|
| The value of a reachable subscriber | No six-week test prices a channel that pays off over years | Use the standing holdout, and refresh the estimate on the dormant population specifically |
| Shared deliverability | Complaints from both arms move one sender reputation, so the contrast understates the benefit | Treat the measured gain as a floor, and read seed-account inbox placement at the domain level |
| Long-run adaptation | Readers may treat the weekly email as the new normal, or may drift further away over a year | The permanent holdout is the only instrument that sees this |
| The eligibility threshold | The test compares 21 days against no change, not 21 days against 45 | A follow-up test across thresholds on the recent-opener segment |
| Cross-channel substitution | Push notifications and on-site prompts may absorb some of the lost visits | Report notification volume and push opt-outs alongside, so a channel shift is not read as a recovery |

## Sources

- [Quora Help Center, personalizing the feed](https://help.quora.com/hc/en-us/articles/115004230006-How-do-I-personalize-my-Quora-feed)
- [Leave Me Alone, Quora email settings, 2026](https://leavemealone.com/how-to-unsubscribe-from/quora/)
- [Forbes, How does Quora use machine learning in 2017](https://www.forbes.com/sites/quora/2017/04/19/how-does-quora-use-machine-learning-in-2017/)
- [Quora Ads support, where ads appear](https://quoraadsupport.zendesk.com/hc/en-us/articles/115010300687-Where-do-Quora-ads-appear)
- [Gmail Help, email sender guidelines](https://support.google.com/mail/answer/81126?hl=en)
