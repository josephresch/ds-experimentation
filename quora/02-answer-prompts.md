# Growing answer supply with suggested-question cards in the feed

An experiment design study for Quora, built from public product documentation and published
research. The data is synthetic. The internal systems described are a plausible reconstruction
rather than a description of Quora's architecture.

## Problem

Quora is a two-sided product held together by one scarce resource. Readers arrive constantly,
questions are cheap to ask, and answers come from a small minority of accounts. A published analysis
of the site found answers concentrated on a small share of questions, with only about a fifth of
questions attracting four or more answers.

The feed already carries a card that shows a reader a question they might answer, with Answer,
Follow and Pass. Today it goes only to people who have written recently. The proposal is to show it
to readers as well, capped at one card per ten stories, with nothing else about the card changed.

| Scenario quantity | Value |
|---|---|
| Logged-in feed users who wrote an answer in the last 90 days | 7% |
| Questions asked last quarter with no answer after 7 days | 41%, against 33% a year earlier |
| Eligible readers, no answer in 90 days, who load the feed in 14 days | 7.44M |

The decision is whether recruiting writers out of the reading audience produces answers anyone
wanted.

## Design tensions

| Tension | How it shows up |
|---|---|
| Raw supply is the easiest thing to move and the easiest thing to fake | Fifty one-line answers on questions nobody reads counts as a 31% supply increase |
| The stated goal is a property of questions, the test randomizes people | Both arms answer the same pool of questions, so the unanswered-question rate has no arm-level contrast |
| A feed slot is not free | One story in ten becomes a card that most readers pass, and the cost lands on every reader while the benefit lands on the few who write |
| The first answer decides whether there is a second | A first answer that draws no response rarely leads to another, so the selection rule has a long tail |
| Per-answer averages mix populations | Introducing a new kind of answer moves the average without any existing answer changing |
| Supply created in one arm is consumed by both | Answers written by treated readers are read by everyone, so the site-level benefit cannot be measured inside the contrast |

## Framing

The card is a matching intervention, not a writing intervention. Quora's constraint is not that
readers are unwilling to write, it is that writing and demand have to meet on the same question. An
answer to a question nobody asked has the same cost to the writer and none of the value.

That reframes the metric before any design work. Supply is only worth counting where demand exists,
so the quantity of interest is answers that reached somebody, not answers written.

One decomposition carries most of the analysis.

```
upvotes per answer = views per answer × upvotes per view
```

"These answers are bad" and "nobody saw these answers" both push the left side down, and they have
different fixes. The first is a writer problem and the second is a question-selection problem, which
is a product decision the team controls directly.

The same separation between an action and its value appears in [feed ranking](01-feed-ranking.md),
where the model got better at predicting taps and worse at producing appreciation.

## Public figures

- The feed shows suggested questions a reader might answer, with Answer, Follow and Pass. Answers can
  also be written from topic pages and the Write Answer page
- Anyone can send an answer request, and suggested recipients are ranked by their record of answering
  requests, topic expertise and their relationship to the requester
- An automated Quora account has posted machine-generated questions since at least 2023. Writers have
  criticized them as generic and sometimes built on false premises
- A 2013 study of the site found answers concentrated on few questions, with about 20% of questions
  attracting four or more answers, and found that followers of a question's topics wrote roughly half
  of all answers
- Writer monetization narrowed in November 2024, when Space subscriptions and ad revenue sharing
  ended. Quora+ revenue sharing remains and is invite-only

## Scenario

Synthetic, per eligible reader over 14 days.

| Metric | Value |
|---|---|
| Wrote at least one answer | 0.90% |
| First-time writers, never answered before | 0.35% |
| Answers written, mean (SD) | 0.035 (0.5) |
| Days active, mean (SD) | 5.1 (4.2) |
| Stories expanded, mean (SD) | 21.0 (44) |

Upvotes on a new answer mostly arrive in its first 7 days. The feed experiment layer allows a test to
use up to 20% of eligible readers.

## Arithmetic

Writing is a rare event, so the binomial form of the sample size rule governs the design.

```
n ≈ 16 · p(1 - p) / δ²
```

At a 0.90% writer rate, detecting a 10% relative lift means `δ = 0.0009` and needs about 176,000
readers per arm. The layer holds four times that.

| Metric | MDE at n = 744,000 per arm |
|---|---|
| Writer rate | 4.8% relative |
| Answers per reader | 6.6% relative |
| Days active | 0.38% relative |

Writer metrics are comfortably powered. The reader guardrail is the binding constraint, which is the
opposite of the usual worry in a supply experiment and shapes how the guardrail is read.

---

# Design decisions

## 1. Objective

The decision is whether to show suggested-question cards to readers who have not written recently.

The objective is answers that someone wanted, per reader exposed, at a reader cost small enough to
be worth paying. Writing that nobody reads is not a smaller version of success, it is a different
outcome with its own costs, including moderation load and a discouraged first-time writer.

The scope boundary is the site-level goal. Fewer unanswered questions is what the change is for, and
it is not measurable in this design, because a question answered by a treated reader is answered for
the control arm too.

## 2. Primary metric

Answers that received at least one upvote within 7 days of posting, per eligible reader.

The numerator counts supply that reached somebody. The denominator is every reader assigned,
including the roughly 99% who never write, which keeps the metric an average treatment effect rather
than a statement about writers.

| Candidate | Why it is rejected |
|---|---|
| Answers written per reader | Moves with effort rather than value, and a card that produces short answers on unread questions is indistinguishable from one that works |
| Card taps or the share who tap Answer | An adoption number. It rises by construction and says nothing about what happens after the tap |
| Unanswered-question rate | A property of questions. Both arms draw from the same question pool, so there is no contrast to read. It needs a question-randomized test |
| Upvotes received per reader | The right idea with the wrong distribution. Upvote counts are heavy-tailed enough that the interval will span zero at this sample size, as the results below show |

The 7-day window is fixed in advance so that every answer is measured at the same age.

## 3. Secondaries and guardrails

Secondaries locate the effect rather than decide it.

- Share of readers who write, first-time writers, repeat writers
- Answers per reader
- Views per answer and upvotes per view, split by whether the answer came from a card
- Share of cards passed

Guardrails protect the reading experience, which is what the feed slot is taken from.

| Guardrail | Why |
|---|---|
| Days active | The reader-side retention proxy, and the metric with the tightest tolerance |
| Stories expanded per reader | Direct measure of the displaced story |
| Upvotes given per reader | Reading engagement, distinct from writing |
| Moderation removals on new answers | Supply that costs more than it returns |

## 4. Randomization

The unit is the eligible reader, assigned on first feed load inside the test window. Eligibility is
no answer in the last 90 days, evaluated before assignment, and readers who already see these cards
stay out of the test because their experience does not change.

Question-level randomization measures what the team actually wants, how fast a question gets answered
and how many views those answers draw. It is rejected here for a specific reason rather than a
general one. Every reader would see cards for some questions and not others, so there is no clean
reader control group, and neither reader experience nor writer behavior could be measured. The two
designs answer different questions. The reader test runs first because the reader cost is the thing
that could kill the feature.

Allocation is 10% per arm, about 744,000 readers each. Enrollment runs 14 days, then the readout
waits a further 7 days so answers written on the last day of exposure get the same upvote window as
answers written on the first. Reading at day 21 rather than day 14 is the difference between a
maturity artifact and a result.

## 5. Power

The design is powered for the writer side and tight on the reader side. Days active resolves changes
of about 0.4%, so the guardrail can confirm that the cost is small and cannot confirm that it is
zero. The analysis plan states the acceptable loss in advance, so the guardrail has a threshold
rather than a hope.

## 6. Health checks

- Sample ratio against the intended split
- Cards rendered only in the treated arm
- Answer entry points logged identically in both arms, from server logs unchanged during the test
- Every answer's views and upvotes measured exactly 7 days after posting

## 7. Results

14 days of exposure on 10% of eligible readers per arm, read at day 21. Synthetic.

| Per eligible reader over 14 days | Control | Treatment | Change | 95% CI |
|---|---|---|---|---|
| Readers | 744,130 | 743,512 | | |
| Answers with at least one upvote, per 1,000 readers | 15.4 | 16.6 | +8% | +4% to +12% |
| Wrote at least one answer | 0.90% | 1.26% | +40% | +36% to +44% |
| First-time writers | 0.35% | 0.56% | +60% | +52% to +68% |
| Answers per reader | 0.035 | 0.046 | +31% | +26% to +37% |
| Upvotes per answer at 7 days | 3.30 | 2.60 | -21% | -29% to -13% |
| Answers with at least one upvote | 44.0% | 36.2% | -7.8 points | -8.8 to -6.9 |
| Upvotes received per 1,000 readers | 115.5 | 119.6 | +4% | -19% to +26% |
| Days active | 5.105 | 5.100 | -0.1% | -0.36% to +0.16% |
| Stories expanded | 21.1 | 20.8 | -1.4% | -2.1% to -0.7% |
| Upvotes given | 3.21 | 3.18 | -0.9% | -2.0% to +0.2% |
| Cards shown per reader | 0 | 15.0 | | |
| Cards passed, share of cards shown | | 6% | | |

The split is 49.98% treated, p = 0.61.

Writing responds strongly and the reader cost is small. Days active is flat inside a quarter of a
percent either way, and expands fall by about the size of the slot the card occupies.

The value side is where the result stops being simple. Answers rose 31% while answers that earned any
upvote rose 8%, and the share of answers getting no response at all moved almost eight points.
Upvotes received per reader has a point estimate of +4% and an interval from -19% to +26%, which is
a metric reporting that this design cannot answer that question.

## 8. Diagnosis

The per-answer drop has two candidate causes with different remedies, and the decomposition separates
them before any hypothesis is named.

| Kind | Hypothesis | What the cut must show |
|---|---|---|
| Reach | Card answers are seen by far fewer people | A views gap, with upvotes per view roughly intact |
| Selection | The question rule picks questions with no audience | Card questions with low prior traffic and few followers |
| Time | New questions need longer to accumulate traffic | The gap closes at 30 days |
| Effort | Card answers are shorter and lower effort | Lower length, higher removal rate, lower upvotes per view |
| Writers | First-time writers are weaker and do not return | Lower repeat rate per reader, not only per writer |
| Measurement | Answers or upvotes were counted differently | A logging or maturity difference between arms |

**Reach and quality by origin.**

| Answers written during the test | Control | Treatment, from a card | Treatment, other routes |
|---|---|---|---|
| Share of the arm's answers | 100% | 26% | 74% |
| Views in 7 days, mean | 110 | 26 | 109 |
| Views in 7 days, median | 45 | 9 | 44 |
| Upvotes per 100 views | 3.0 | 2.7 | 3.0 |
| Share with at least one upvote | 44% | 14% | 44% |

Card answers reach about a quarter of the usual audience while converting views to upvotes at almost
the usual rate. Answers written through other routes in the treated arm are indistinguishable from
control, which also rules out a general contamination of the arm.

**The questions behind the answers.**

| | Questions answered by control readers | Questions answered from cards |
|---|---|---|
| Page views in the 30 days before the answer, median | 240 | 20 |
| Followers, median | 3 | 1 |
| Asked less than 2 days before the answer | 18% | 61% |
| Created by the automated question account | 5% | 34% |

The selection rule, recent questions with fewer than two answers, is a rule for finding questions
with no audience. A third of them were generated by an automated account. The feature is working
exactly as specified and the specification is the defect.

**Time.** Answers written in the first week, measured again two weeks after the readout.

| Mean views per answer | At 7 days | At 30 days |
|---|---|---|
| Control answers | 110 | 190 |
| Answers from cards | 26 | 41 |

The gap does not close, so newness is not the explanation.

**Effort.**

| | Control answers | Answers from cards | Treatment, other routes |
|---|---|---|---|
| Median length, words | 120 | 60 | 118 |
| Written on the mobile app | 58% | 83% | 59% |
| Removed by moderation | 1.1% | 1.6% | 1.1% |

Card answers are shorter and mostly typed on phones, which fits the small gap in upvotes per view.
This is a real quality difference and it is a minor term next to reach.

**First-time writers.**

| | Control | Treatment |
|---|---|---|
| First-time writers, share of readers | 0.35% | 0.56% |
| First answer got zero upvotes in 7 days | 61% | 72% |
| Wrote again within 14 days, share of first-time writers | 22% | 17% |
| Repeat writers, share of all readers | 0.077% | 0.095% (+23%, +10% to +37%) |

The drop in the third row is the trap in this table. It compares two different populations, because
the cards recruited a larger and more marginal set of first-time writers. Measured per assigned
reader, which holds the population fixed, repeat writers rose 23%. The design cannot separate a
composition effect from a discouragement effect here, and the honest statement is that both are
consistent with the data. What is not ambiguous is that nearly three in four first answers in the
treated arm drew no response.

**Measurement.** Views and upvotes were counted exactly 7 days after each answer in both arms, and
answer entry points come from server logs that did not change during the test.

## 9. Decision

Do not ship this version. Change the question selection and run it again.

The reader-side question is settled. A card in one of ten stories costs a fraction of a percent of
reading and no measurable retention, and it moves writing more than any feed change would be expected
to. The supply-side question is not settled, because the supply produced went to questions with no
audience.

The rerun changes one thing and keeps the rest.

- Select under-answered questions with demonstrated demand, using recent page views, search entries
  or followers, and exclude automatically generated questions
- Before rerunning, count how many eligible questions each reader would have under the new rule using
  last month's data, since a stricter rule can starve the card and turn it into a repeat
- Keep the primary, the reader guardrails and the 7-day maturity window, so the two runs are
  comparable
- Watch the share of first answers that draw no response, which is the leading indicator for whether
  a recruited writer ever comes back

If the decision moves to the site-level goal, fewer unanswered questions, that needs a
question-randomized test rather than a bigger version of this one.

## 10. Limits

| Cannot fix | Why | What to do instead |
|---|---|---|
| The site-level benefit | Answers written in the treated arm are read by both arms, so the contrast measures what readers write, not what the site gains from reading it | Question-randomized test for question outcomes, or a launch holdout |
| Writer lifetime | Two weeks plus a maturity window sees a first answer and sometimes a second. Whether a recruited writer is still writing in a year is outside the design | Track recruited cohorts after launch against a holdout |
| The discouragement question | The first-answer retention comparison mixes a composition change with a treatment effect | Hold the writer population fixed by comparing per assigned reader, and test the response-rate fix directly |
| Demand elasticity of the question pool | A stricter selection rule may not have enough questions to fill the card | Size the eligible pool per reader before the rerun, not after |
| Moderation capacity | A 31% increase in answers is a 31% increase in review volume at a higher removal rate | Report removal volume to the moderation team as part of the launch decision |

## Sources

- [Quora Help Center, how to write an answer](https://help.quora.com/hc/en-us/articles/115004229886-How-do-I-write-an-answer-on-Quora)
- [Quora Help Center, Request Answers](https://help.quora.com/hc/en-us/articles/360057977972-What-does-Request-Answers-mean-and-how-does-it-work)
- [Wang et al., Wisdom in the Social Crowd, an analysis of Quora, WWW 2013](https://gangw.cs.illinois.edu/quora-www13.pdf)
- [Quora Help Center, earnings programs and the November 2024 discontinuations](https://help.quora.com/hc/en-us/articles/360059643172-What-earnings-programs-are-available-to-writers-on-Quora)
- [Language Lovers, the Quora question bot, 2023](https://languagelover.org/2023/11/13/quora-bot-invasion/)
- [Quora Help Center, personalizing the feed](https://help.quora.com/hc/en-us/articles/115004230006-How-do-I-personalize-my-Quora-feed)
