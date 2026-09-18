# Validating a home feed ranking model online

An experiment design study for Quora, built from public product documentation, published talks and
third-party traffic estimates. The data is synthetic. The ranking system described is a plausible
reconstruction rather than a description of Quora's architecture.

## Problem

The logged-in home feed is one ranked list. A story is an answer shown as a question plus a
truncated answer that opens on "Read more", a post from a Space, a question suggested for the reader
to answer, or an ad.

The public description of how that list is ordered comes from talks given by Quora's then VP of
Engineering. The value of showing a story is modeled as a weighted sum of reader actions. Models
predict the probability of each action and stories are ranked by expected value, `v = Σ v_a · p(a | x)`.

A new model replaces those action predictions. The weights that combine them are left alone. On last
month's logged data it predicts reader behavior better.

| Offline result | Current model | New model |
|---|---|---|
| Predicting expands, AUC | 0.742 | 0.791 |
| Predicting upvotes, AUC | 0.768 | 0.779 |
| Replay ranking quality, NDCG@10, where a story counts as good if it was expanded or upvoted | 0.412 | 0.437 |
| p95 ranking time | 180 ms | 205 ms, inside a 250 ms budget |

The decision is whether that is enough to ship, and if not, what test settles it.

## Design tensions

| Tension | How it shows up |
|---|---|
| The gain sits in the weakest signal | Expands outnumber upvotes about six to one in this feed. An expand costs a reader one tap and says little about whether the story was worth reading |
| The offline label carries the same bias | A replay label that counts a story as good when it was expanded or upvoted is dominated by the more common action |
| A better component is not a better objective | The weights were tuned against the old predictions. Sharpening one action model changes what the ranked list maximizes without anyone changing the weights |
| Revenue moves with the treatment mechanically | Ads run below an answer once it is expanded, so more expands create more ad inventory whether or not readers valued what they opened |
| The metric closest to the goal is the one the test can barely see | Days active is the short-run stand-in for retention, and the detectable change is around 0.4% |
| Treated readers change what everyone sees | Upvotes feed ranking and writers serve both arms, so part of any ecosystem effect leaks into control |

## Framing

An offline evaluation scores a model against logged behavior. It answers whether the model predicts
what readers did, not whether readers got more out of the feed. The published advice from the same
talks is blunt about it, "whatever you do in the lab, you should trust your AB tests."

The mechanism that makes this case more than a slogan is the scoring function. A weighted sum over
predicted actions is only as good as the actions it counts and the weights it counts them at. If
`p(expand)` improves more than `p(upvote)`, stories whose appeal is an easy tap rise in the ranking,
and no one has touched a weight. The offline table cannot show this, because every number in it is
an accuracy measure over the same actions.

That gap between an action and its value runs through the sibling studies too.
[Suggested-question cards](07-quora-answer-prompts.md) counts answers that earned an upvote rather than
answers written, and [digest frequency](08-quora-digest-frequency.md) counts visits from any source rather
than email opens.

## Public figures

- The feed mixes answers, Space posts and suggested questions. Expanding an answer is a tap on
  "Read more", and ads appear between stories and below an answer once it is expanded
- Feed ranking is publicly described as a weighted sum of predicted reader actions, with relevance
  described as topical, social and timeliness. The description dates from 2016 and 2017, so it is
  the likely shape of the system rather than a current account of it
- Personalization runs mainly on topics. The help center tells readers to follow topics and writers,
  upvote, and remove what they dislike, because "the more actions you take, the more we learn about
  what you want to see"
- Negative controls are downvotes, which show a story to fewer people, and muting a user, topic or
  Space
- In 2016 Quora described an in-house experiment framework running about 2,000 experiments, roughly
  30 at a time, with surveys used to catch what metrics miss
- Third-party estimates put quora.com in the hundreds of millions of monthly visits through 2026,
  about three quarters of them on mobile, with organic search as the largest channel. Estimates from
  different tools disagree, so they are directional only

## Scenario

Synthetic, sized against the public traffic estimates above.

| Quantity | Value |
|---|---|
| Logged-in users who load the feed in 14 days | 8.0M |
| Signed up in the last 30 days | 12% |
| Share of the feed experiment layer available | 20% of feed users |
| Feed sessions on the mobile apps | about 70% |

Per feed user over 14 days.

| Metric | Mean (SD) |
|---|---|
| Days active | 5.1 (4.2) |
| Expands | 21.0 (44) |
| Upvotes | 3.2 (11.0) |
| Shares | 0.40 (2.9) |

## Arithmetic

For a two-sided test at 5% with 80% power, the smallest relative change that can be detected is

```
MDE ≈ 2.8 · SD · sqrt(2 / n) / mean
```

| Metric | MDE at n = 800,000 per arm |
|---|---|
| Days active | 0.36% |
| Expands | 0.93% |
| Upvotes | 1.5% |
| Shares | 3.2% |

The same thing through the rule of thumb `n ≈ 16σ² / δ²`. A 1% move in upvotes is `δ = 0.032` against
`σ = 11`, which needs about 1.9M users per arm. The layer holds 800,000. Small moves in upvotes and
any move in days active under a third of a percent are outside what this test can resolve, which is a
fact about the design rather than a reason to report them as zero.

---

# Design decisions

## 1. Objective

The decision is whether to replace the ranking model for every logged-in feed reader.

The objective is reader value per person, in the sense that keeps people coming back. Activity is
not the objective. A feed that produces more taps and fewer signs of appreciation has moved activity
in the wrong direction, and a feed that produces more ad inventory by producing more taps has moved
revenue for a reason that does not survive readers visiting less.

The scope boundary matters as much as the objective. A two-week test on 20% of feed users can measure
reading behavior, expressed appreciation and a modest move in days active. It cannot measure
long-run retention, and it cannot measure how writers respond to a distribution change, because
writers serve both arms.

## 2. Primary metric

Upvotes plus shares per feed user, over the test window.

An upvote is the cheapest action a reader takes that says the story was worth the time, and a share
is the expensive version of the same statement. Both are counted per assigned user, so the
denominator is fixed at randomization and cannot move with the treatment.

Where dwell time is logged, expands followed by at least five seconds of reading per user is the
better primary, because it counts value the reader received rather than value the reader expressed.
The threshold has to be fixed before the test.

Three tempting alternatives and what each costs.

| Candidate | Why it is rejected |
|---|---|
| Expand rate, expands per impression | It is the quantity the new model was built to predict, so grading the model on it is close to circular. It is also a ratio whose denominator moves with the treatment, and a per-impression binomial test understates variance when users are randomized |
| Time in feed | Opening and closing stories adds time. Without a quality signal beside it, time is unsigned |
| Ad revenue per user | It is produced by expands, so it rises with any change that raises expands. Worth reporting, never the reason to ship |

Days active is the metric closest to the business, and it is the primary only in a test with several
times this sample. Here it is a guardrail read through its interval.

## 3. Secondaries and guardrails

Secondaries explain a movement in the primary rather than decide anything.

- Expands, expand rate, impressions and comments per user
- Share of impressions by story type, and upvotes per expand within each type
- Effect by day, to separate a persistent change from a first-week reaction

Guardrails, each with a stated threshold before launch.

| Guardrail | Why |
|---|---|
| Days active, overall | The closest short-run stand-in for retention |
| Days active, readers who signed up in the last 30 days | The group the model knows least about and the group the business can least afford to lose |
| Downvotes plus mutes per user | Direct negative feedback, rare enough that relative changes look large |
| p95 ranking time | A latency budget of 250 ms |
| Ad revenue per 1,000 users | Reported, not decisive, for the reason in section 2 |

## 4. Randomization

The unit is the logged-in user, assigned on first feed load inside the test window.

| Candidate unit | Why not |
|---|---|
| Session | The same person meets both rankers and carries habits between them, and per-person outcomes such as days active stop meaning anything |
| Story or impression | The treatment is the ordering of a list, not a property of one story, and the decision is about people |
| Device | A logged-in reader uses the app and the web, and the feed follows the account |

Allocation is 10% to each arm inside the shared feed layer, about 800,000 users per arm over 14 days.
Assignment at first feed load, rather than at sign-in, keeps the trigger identical in both arms and
keeps people who never open the feed out of the denominator.

Duration is 14 days, which covers two weekly cycles and gives a changed ranking time to settle.

## 5. Power

The MDE table in the arithmetic section is the design constraint, and it is asymmetric in an
inconvenient way. The metric the decision cares about most moves the least and is measured worst.

Two consequences are written into the analysis plan before the test runs. Days active is read as an
interval, and a result that fails to clear significance is reported as a range of harm the test could
not rule out. A guardrail that cannot rule out a 0.5% loss in days active is not a passed guardrail.

## 6. Health checks

Run before any effect is read.

- Sample ratio, tested against the intended 50/50 within the layer
- p95 ranking time inside budget in the treated arm
- Identical logging in both arms, with the ranking change server side
- Independence from other live tests in the same layer, checked by re-estimating the effect inside
  and outside the overlapping population

## 7. Results

14 days, 10% of feed users per arm. Synthetic.

| Per feed user over 14 days | Control | New model | Change | 95% CI |
|---|---|---|---|---|
| Users | 800,912 | 799,618 | | |
| Days active | 5.076 | 5.063 | -0.25% | -0.51% to +0.01% |
| Feed impressions | 181.2 | 179.2 | -1.1% | -1.6% to -0.6% |
| Expands | 21.14 | 22.15 | +4.8% | +4.1% to +5.5% |
| Expand rate | 11.67% | 12.36% | +5.9% | +5.5% to +6.3% |
| Upvotes | 3.214 | 3.121 | -2.9% | -3.9% to -1.9% |
| Shares | 0.402 | 0.388 | -3.5% | -5.7% to -1.3% |
| Downvotes plus mutes | 1.12 | 1.20 | +7.1% | +5.4% to +8.8% |
| Time in feed, minutes | 38.3 | 39.0 | +1.8% | +1.0% to +2.6% |
| Expands followed by 5+ seconds of reading | 14.94 | 14.53 | -2.7% | -3.4% to -2.1% |
| Ad revenue per 1,000 users | $52.40 | $53.92 | +2.9% | +1.6% to +4.2% |
| p95 ranking time | 180 ms | 205 ms | | |

The split is 49.96% treated, p = 0.31. Latency is inside budget.

The shape of the result is readers opening more and valuing less. Expands are up about 5% while
upvotes, shares and sustained reading are all down with intervals clear of zero, and direct negative
feedback is up 7%. Time in feed rises, which is what opening and closing more stories looks like. Ad
revenue rises because ads sit below expanded answers.

Days active is the awkward row. The point estimate is small and the interval covers zero, and the
same interval reaches -0.51%, which across the whole feed would be a material loss. The test cannot
tell those apart, and reporting the row as no change would be a claim the design cannot support.

## 8. Diagnosis

Six explanations, each with the cut that would test it and what that cut has to show.

| Kind | Hypothesis | What the cut must show |
|---|---|---|
| Content | The new model gives more of the feed to a story type that gets opened and not valued | Mix shift toward that type, and lower upvotes per expand within it |
| Reading | The extra expands are quick exits | A rise in the share of expands ending within a few seconds |
| Who | The effect concentrates in readers the model knows least about | A larger shift and a larger loss among new users |
| When | The expand gain is a reaction to a changed feed | The gain decays across the test while the upvote loss does not |
| Direct | Readers themselves rate the feed lower | A drop in a satisfaction survey, concentrated in the same story type |
| Measurement | Logging, platform or an overlapping test explains it | The pattern differs by client or by overlap, or the ranking change is not server side |

**Story mix.**

| Story type | Impression share, control | New model | Expand rate, control | New model | Upvotes per expand, control | New model |
|---|---|---|---|---|---|---|
| Answers | 76.0% | 74.0% | 11.8% | 12.1% | 17.8% | 17.3% |
| Space posts | 16.0% | 18.5% | 15.2% | 17.0% | 5.9% | 5.0% |
| Suggested questions | 8.0% | 7.5% | 3.2% | 3.2% | n/a | n/a |

| Per user | Expands, control | New model | Upvotes, control | New model |
|---|---|---|---|---|
| Answers | 16.25 | 16.09 | 2.89 | 2.78 |
| Space posts | 4.41 | 5.64 | 0.26 | 0.28 |

Space posts hold 16.3% of the top ten slots under the current model and 19.0% under the new one. All
of the additional expands are Space posts, whose expands per user rose about 28% while answer expands
were flat. Posts are opened more often than answers and upvoted about a third as often per expand, so
the mix shift raises taps and lowers appreciation at the same time. The upvote loss sits on answers,
which lost slots.

**Reading depth.**

| | Control | New model |
|---|---|---|
| Expands ending within 5 seconds | 29.3% | 34.4% |
| Answers | 26% | 30% |
| Space posts | 41% | 47% |

Reading that lasts is down 2.7%, in line with upvotes. The extra opens are largely opens and exits.

**New against tenured readers.**

| Segment | Users per arm | Days active, control | Days active | Upvotes | Expands | Post share of impressions |
|---|---|---|---|---|---|---|
| Signed up in the last 30 days | about 96,000 | 3.5 | -1.9% (-2.8% to -1.0%) | -7.5% (-11.4% to -3.6%) | +9.5% (+7.2% to +11.8%) | 21% to 29% |
| Everyone else | about 704,000 | 5.29 | -0.12% (-0.38% to +0.14%) | -2.7% (-3.8% to -1.6%) | +4.5% (+3.8% to +5.1%) | 15.6% to 17.7% |

New readers take the largest mix shift and the largest loss, and their days active interval sits
entirely below zero. Their lower baseline is why the overall days active number is smaller than the
new-user number. This is the cut that decides the case, because a feed that costs new readers 2% of
their active days is a growth problem regardless of what the aggregate says.

**Effect by day.**

| | Days 1 to 3 | Days 4 to 7 | Days 8 to 14 |
|---|---|---|---|
| Expands | +7.6% (+6.3% to +8.9%) | +4.8% (+3.6% to +6.0%) | +3.2% (+2.2% to +4.2%) |
| Upvotes | -2.7% (-4.8% to -0.6%) | -2.9% (-4.8% to -1.0%) | -3.0% (-4.6% to -1.4%) |

The gain decays and the loss does not, so the trade gets worse with time rather than better. A reader
adjusting to an unfamiliar feed explains part of the expand gain and none of the upvote drop.

**Survey.** A "was this worth your time" prompt on a small random sample of stories, about 58,000
responses per arm, returns 71.2% yes in control against 68.9% in treatment, a drop of 2.3 points
(-3.0 to -1.6). By type the answer is 74.0% against 72.5% for answers and 58.0% against 53.7% for
posts. Readers say the same thing the behavioral metrics say, which closes off the argument that
upvotes are noise.

**Measurement.** The pattern holds on both clients, expands +4.9% on the apps against +4.6% on the
web with matching upvote drops, actions are logged identically in both arms, and the effect inside
the overlapping Spaces test (+5.6% expands) sits within noise of the effect outside it (+4.7%).

The mechanism is one sentence. The new model is much better at predicting which stories get opened,
the score still counts an expand the way it always did, so stories that are easy to open moved up the
list and stories that get appreciated moved down.

## 9. Decision

Do not ship the model as scored. Keep the model and change what the score rewards.

The model is not the defect. Its predictions are better, including on upvotes. The defect is that a
scoring function tuned against weaker predictions now points somewhere else, and nothing in the
offline evaluation could see that, because the replay label counted an expand as a success.

The next step has three parts that follow from the diagnosis.

- Re-tune the weights so appreciation and sustained reading count for more and a quick exit counts
  against a story
- Re-run the offline evaluation against a label built on reading and upvotes rather than expands,
  which makes the offline stage capable of failing a model for the reason this test failed one
- Re-test for two weeks with upvotes plus shares per user as the primary, days active for new
  readers as a named guardrail, and a small permanent holdout after any launch

The tempting middle path, shipping to tenured readers only, does not survive the segment table.
Tenured readers still lose upvotes at 2.7% with an interval clear of zero. The segment cut explains
where the damage is worst, not where it is absent.

## 10. Limits

| Cannot fix | Why | What to do instead |
|---|---|---|
| Writer response | Writers serve both arms, so a change in what gets distributed cannot be randomized to them | Measure writer-side effects after launch against a holdout, or run a separate test that randomizes at the question or topic level |
| Long-run retention | Two weeks of days active is a proxy for a decision that plays out over months | Keep a permanent holdout and read the same metrics quarterly |
| Signal spillover | Treated readers' upvotes feed ranking for everyone, so the contrast understates any ecosystem effect | Bound it by comparing against a period with no overlapping ranking change, and keep the effect size in mind rather than claiming precision |
| Survey self-report | A satisfaction prompt measures what readers say about a story they just saw | Use it as corroboration for behavioral metrics, never as the primary |
| The weights themselves | The test compares two prediction models under one weighting. It says nothing about whether that weighting is right | Test weightings directly, as a separate experiment with the same primary metric |

## Sources

- [Xavier Amatriain, Approaches to Recommendation in Industry, RecSys Summer School 2017](https://pro.unibz.it/projects/schoolrecsys17/RecsysSummerSchool-XavierAmatriain.pdf)
- [Forbes, How does Quora use machine learning in 2017](https://www.forbes.com/sites/quora/2017/04/19/how-does-quora-use-machine-learning-in-2017/)
- [Quora Help Center, personalizing the feed](https://help.quora.com/hc/en-us/articles/115004230006-How-do-I-personalize-my-Quora-feed)
- [Quora Help Center, muting users](https://help.quora.com/hc/en-us/articles/360021529911-How-can-I-hide-a-user-from-my-Quora-feed)
- [Quora Ads support, where ads appear](https://quoraadsupport.zendesk.com/hc/en-us/articles/115010300687-Where-do-Quora-ads-appear)
- [EconTalk, Adam D'Angelo on knowledge, experimentation, and Quora, 2016](https://www.econtalk.org/adam-dangelo-on-knowledge-experimentation-and-quora/)
- [Similarweb, quora.com](https://www.similarweb.com/website/quora.com/)
- [Contrary Research, Quora business breakdown](https://research.contrary.com/company/quora)
