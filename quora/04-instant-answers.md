# Putting an instant AI answer in the question-asking flow

An experiment design study for Quora, built from public product documentation, published interviews
and reported incidents. The data is synthetic. The internal systems described are a plausible
reconstruction rather than a description of Quora's architecture.

## Problem

A person types a question into the Add Question window. Quora already suggests similar existing
questions while they type. If they post, the question goes live and human writers answer over the
following hours or days, and a large share of questions never get an answer at all.

The proposal is to show an instant answer, generated and clearly labeled as such, before the question
is posted. Two buttons follow it, "This helped" and "Post my question anyway". Posting works exactly
as it does today.

| Scenario quantity | Value |
|---|---|
| Logged-in users who start a question in 14 days | 1.2M |
| Posted questions with no answer after 7 days | 41% |
| Human answers per posted question within 7 days | 1.57 |

The feature is a deflection. It is designed to stop some questions from being posted, so the decision
is not whether questions fall but which ones, and what they were worth.

## Design tensions

| Tension | How it shows up |
|---|---|
| Success and damage are the same event | Every question the instant answer resolves is a question that does not get posted, and posted questions are the site's inventory |
| The treatment changes the population inside the metrics | Answers per posted question compares one set of questions against a different set once the mix of what gets posted moves |
| Most of a question's value arrives later | A question page can draw search visits for years, and a three-week test sees the first fraction of that |
| The satisfaction signal exists in one arm only | "This helped" has no control counterpart and is self-reported at the moment of relief |
| A confident wrong answer costs more than a right one earns | Quora has already had a machine-written answer surface publicly in Google search with a false claim |
| Writers cannot be randomized here | They see questions from both arms, so how supply responds to fewer questions is outside the contrast |

## Framing

A deflection feature moves value between parties. The asker gains immediately and measurably. The
costs land on people who are not in the interaction, writers who lose questions to answer and
searchers who never find a page that was never created.

That is what makes the duplicate distinction the center of the case. Deflecting a question that
duplicates an existing one is close to free, since the asker gets an answer faster and the site loses
a page that would have been merged anyway. Deflecting a question with no close match removes a page
that would have carried search traffic for years. Both look identical in a question count.

So the count is not the quantity of interest, and neither is the asker's reaction. The study needs a
value per deflected question, which has to come from historical data on what similar questions earned
rather than from anything inside the test.

Two of the sibling studies hit the same wall from other directions. In
[suggested-question cards](02-answer-prompts.md) the supply created is worth nothing unless demand
exists for it, and in [feed ranking](01-feed-ranking.md) the measurable action moves in the opposite
direction from the value.

## Public figures

- The Add Question window suggests similar existing questions while a person types
- Quora began generating answers with a language model around 2022 and shows them on selected
  question pages. The company's stated finding is that the best use is niche questions no human has
  answered
- Quora's CEO stated in 2024 that the goal is for machine-written answers to be ranked fairly and to
  sit above a human answer only when they are more useful
- In September 2023 a machine-written answer claiming an egg can be melted sat at the top of a
  question page and was surfaced by Google
- Duplicate detection and question merging are longstanding machine learning applications at Quora,
  and the company released a 400,000-pair duplicate question dataset in 2017
- Organic search is the largest single channel into the site by third-party estimates, which is what
  makes a question page an asset rather than a thread

## Scenario

Synthetic, per user who starts typing a question, over 14 days.

| Metric | Value |
|---|---|
| Posted a question | 62.0% |
| Questions posted | 0.80 |
| Came back to Quora within 7 days | 55.0% |
| Days active, mean (SD) | 4.90 (4.2) |

The ask flow sits in its own experiment layer, so a test can use every starter.

## Arithmetic

```
MDE ≈ 2.8 · sqrt(2 · p(1 - p) / n)          for a rate
MDE ≈ 2.8 · SD · sqrt(2 / n) / mean          for a mean
```

At 600,000 starters per arm the return rate resolves to about 0.25 points, the posting rate to about
the same, and days active to about 0.45% relative.

The precision is not the constraint in this design. Every metric that can be measured inside three
weeks is measured well, and the quantity that decides the case, what a deflected question would have
been worth, is not measurable inside three weeks at any sample size.

---

# Design decisions

## 1. Objective

The decision is whether to show an instant answer before posting, and to whom.

The objective is askers getting good answers without hollowing out the question supply that writers
answer and that search traffic arrives on. Those two halves move in opposite directions by
construction, so the design has to price them rather than declare one of them primary and call the
other a guardrail breach.

The scope boundary is the horizon. The test measures the asker's experience, the immediate question
supply and the first weeks of answers. The value of a question page accrues over years, so the
long-run term enters the decision as an estimate from historical data and a launch holdout, never as
a test result.

## 2. Primary metric

The share of starters who return to Quora within 7 days.

It is measurable in both arms, it is not self-reported, and it tracks whether asking went well
overall rather than whether one screen was liked. Days active over the same window sits beside it as
the fuller version of the same idea.

| Candidate | Why it is rejected |
|---|---|
| Clicks on "This helped" | Control never sees the button, so there is nothing to compare against. It describes the treatment rather than measuring it |
| Questions posted | Falls by design. A drop is the mechanism working, and the count cannot separate a duplicate from a new question |
| Human answers per posted question | The treatment changes which questions are posted, so the metric compares different populations before and after |
| Share of questions with no answer after 7 days | Same defect. Removing the question types that attract fewest answers improves it without anyone answering more |

## 3. Secondaries and guardrails

Secondaries, all read by question type.

- Share who post, questions posted per starter
- Time to a first human answer
- Share who click "This helped", as a description of the treated arm

Guardrails.

| Guardrail | Why |
|---|---|
| Human answers received per starter | The per-asker version of supply, computed as questions posted times answers per question, which does not move with the mix |
| Instant answers reported as wrong, per 1,000 shown | The failure mode with the largest tail, read against the report rate for human answers |
| Days active | The reader-side check that nothing else regressed |
| Search visits to newly created questions | The long-run term, measurable only against a holdout after launch |

## 4. Randomization

The unit is the user, assigned the first time they open the ask flow during the test, so the same
person always meets the same experience.

Randomizing each question attempt instead would let one person see an instant answer sometimes and
not others, teach them to expect it, and make their return rate impossible to attribute. Allocation
is 50/50 because the ask flow has its own layer, about 600,000 starters per arm over 14 days.

Two mechanics are fixed before launch.

Question type is classified from the text the person typed before any instant answer appears, which
keeps the segmentation pre-treatment. Splitting on anything produced after the answer shows, most
obviously on whether they posted, would compare groups the treatment created.

Everyone assigned stays in the analysis, including the 3% of the treated arm whose instant answer
timed out and never appeared. The comparison is intent to treat, and dropping the failures would
select on the treatment working.

Enrollment runs 14 days, then the readout waits 7 more so questions posted near the end have the same
time to attract answers and askers the same time to return.

## 5. Power

Well powered on everything it can see. The interesting constraint is the opposite of the usual one,
since the quantities that decide the case are either outside the window, such as search traffic to
new pages, or outside the randomization, such as how writers respond to a smaller question pool.

## 6. Health checks

- Sample ratio against the intended 50/50
- Rate at which the instant answer fails to appear, reported rather than filtered
- The type classifier run identically in both arms on pre-answer text
- Question creation and answer logging unchanged during the test

## 7. Results

14 days of enrollment, 50/50, read at day 21. Synthetic.

| Per starter | Control | Instant answer | Change | 95% CI |
|---|---|---|---|---|
| Starters | 600,214 | 599,786 | | |
| Came back within 7 days | 55.0% | 56.1% | +1.1 points | +0.9 to +1.3 |
| Days active over 14 days | 4.90 | 4.94 | +0.8% | +0.5% to +1.1% |
| Posted a question | 62.0% | 47.0% | -15.0 points | -15.2 to -14.8 |
| Questions posted | 0.800 | 0.606 | -24.2% | -24.6% to -23.8% |
| Human answers received per starter | 1.26 | 1.04 | -17.5% | -18.2% to -16.8% |
| Human answers per posted question | 1.57 | 1.71 | +8.9% | +8.1% to +9.7% |
| Posted questions with no answer after 7 days | 41.0% | 39.1% | -1.9 points | -2.2 to -1.7 |
| Saw an instant answer | | 97% | | |
| Clicked "This helped" | | 38% | | |
| Instant answers reported as wrong, per 1,000 shown | | 6.7 | | |

The split is 49.98% treated, p = 0.70.

Askers are modestly better off. They return about a point more often and are active slightly more,
both with intervals clear of zero. Question supply falls by about a quarter, which is the feature
working as designed.

The two rows that look like good news for the supply side are the ones to hold at arm's length.
Answers per posted question rose 8.9% and the unanswered share fell 1.9 points, and both are
computed over a set of questions the treatment changed. The per-asker version, which holds the
population fixed, shows human answers received falling 17.5%.

## 8. Diagnosis

The contested claim is whether the deflected questions were duplicates nobody needed or new questions
that would have carried traffic.

| Kind | Hypothesis | What the cut must show |
|---|---|---|
| Who | The drop and the benefit both concentrate in one question type | A large posting drop and a large return gain in the same type |
| Mix | The per-question gains are composition, not effort | Equal answers per question within each type across arms |
| What | Deflected questions were mostly duplicates | A high near-duplicate share among questions not posted |
| Value | The new questions carry the lost value | Historical search visits by question type, applied to the deflected set |
| Quality | Errors concentrate where the model is weakest | A wrong-answer rate that varies by type |
| Measurement | Classification or failures differ between arms | A difference in the classifier or in instant-answer failures |

**By question type.** Type is assigned from the text typed before any answer appeared.

| Type | Share of starters | Posted, control | Instant answer | Clicked "This helped" | Returned in 7 days, control | Instant answer |
|---|---|---|---|---|---|---|
| Factual or how-to | 55% | 59% | 35% | 56% | 53.1% | 55.1% (+2.0, +1.8 to +2.2) |
| Advice or personal experience | 30% | 66% | 63% | 12% | 58.0% | 57.8% (-0.2, -0.5 to +0.1) |
| Opinion or other | 15% | 65% | 59% | 24% | 56.0% | 56.4% (+0.4, -0.1 to +0.9) |

Almost the entire posting drop and the entire return gain sit in factual questions, where more than
half of askers say the instant answer helped. People asking for advice or personal experience rarely
find it useful, post anyway, and are no happier afterward. That is the expected result for a product
whose stated purpose is human experience, and it is the split the decision turns on.

**Answers by type.**

| Type | Share of posted questions, control | Instant answer | Human answers per posted question, both arms | No answer after 7 days, both arms |
|---|---|---|---|---|
| Factual or how-to | 52.3% | 41.0% | 1.0 | 49% |
| Advice or personal experience | 31.9% | 40.2% | 2.3 | 30% |
| Opinion or other | 15.7% | 18.8% | 2.0 | 37% |

Within every type, questions get the same number of answers as before. The 8.9% gain is entirely the
mix, since factual questions attract the fewest answers and make up a smaller share of what now gets
posted. Nobody answered anything more.

**What was not posted, and what it was worth.**

- Of the factual questions that treated askers did not post, 60% closely matched an existing question
  and 40% had no close match
- Search visits in the first 90 days after posting, from the previous quarter's questions, average
  260 for a new factual question, 30 for a near-duplicate factual question because it usually gets
  merged, 150 for an advice question and 70 for an opinion question
- Inside the deflected set, the new questions carry about 85% of the lost value, since
  `0.4 × 260 = 104` against `0.6 × 30 = 18`
- Applying those per-type values to everything these askers would have posted gives an estimated 18%
  drop in search visits to their questions over 90 days. The estimate is sensitive to the duplicate
  share among questions that still get posted, which is lower than in the deflected set, so it is a
  range rather than a point

Both readings are partly right, and the two claims are not in conflict. Most deflected questions were
duplicates, and most of the lost value was in the minority that were not.

**Answer quality by type.**

| Type | Instant answers reported as wrong, per 1,000 shown |
|---|---|
| Factual or how-to | 4 |
| Advice or personal experience | 11 |
| Opinion or other | 8 |

The model is least reliable exactly where askers find it least useful, which is a rare case of two
arguments pointing the same way.

**Measurement.** The classifier is the same in both arms and runs on pre-answer text. The 3% of
treated starters whose answer never appeared stay in the treated arm.

## 9. Decision

Launch for factual and how-to questions. Do not launch for advice and personal experience.

For factual questions the instant answer helps more than half of askers, they return about two points
more often, it is the type where the model is most reliable, and most of what it deflects is
duplicate. For advice questions it is rarely useful, it is wrong most often, and askers post anyway,
so it adds a step to the flow and a risk to the page.

One change goes in before launch. When a factual question has no close match among existing
questions, keep the post action as prominent as the instant answer. That is the 40% carrying roughly
85% of the deflected value, and the matching signal needed to identify them already exists in the
similar-question suggester.

After launch, hold out a small share of starters for a quarter and read three things against it,
human answers received per asker, wrong-answer reports against the equivalent rate for human answers,
and search visits to newly created questions. The last one is the number this test could not produce
and the one that decides whether the launch was right.

## 10. Limits

| Cannot fix | Why | What to do instead |
|---|---|---|
| Long-run search value | A question page earns for years and the test observes weeks | Launch holdout, with the 90-day search estimate as the interim number and its assumption stated |
| Writer response to thinner supply | Writers see questions from both arms, so their behavior is not randomized | Measure against the holdout after launch, or randomize at the question level in a separate test |
| Self-reported helpfulness | "This helped" exists in one arm and is collected at the moment of relief | Use it to describe the treated arm, never as evidence of effect |
| The counterfactual answer quality | The test cannot show what a human answer would have said on a deflected question | Sample deflected questions, post a subset deliberately, and compare answers |
| Error severity | A report rate counts incidents and not their cost, and one wrong answer on a medical or legal question is not one unit of harm | Classify reported errors by topic sensitivity and set a separate threshold for sensitive types |

## Sources

- [Quora, user question on similar-question suggestions in the Add Question window](https://www.quora.com/When-asking-questions-do-you-sometimes-go-to-similar-questions-Quora-suggests-on-the-Add-Question-window-and-answer-share-from-there-instead)
- [TechCrunch, Adam D'Angelo on AI and Poe, May 2024](https://techcrunch.com/2024/05/06/adam-dangelo-quora-poe-open-ai/)
- [Forbes, inside Quora's quest for relevance, May 2024](https://www.forbes.com/sites/richardnieva/2024/05/20/quora-adam-dangelo-poe/)
- [Futurism, the melted-egg answer surfaced in Google, September 2023](https://futurism.com/google-search-ai-melt-eggs)
- [Kaggle, Quora Question Pairs](https://www.kaggle.com/competitions/quora-question-pairs)
- [Forbes, How does Quora use machine learning in 2017](https://www.forbes.com/sites/quora/2017/04/19/how-does-quora-use-machine-learning-in-2017/)
- [Similarweb, quora.com](https://www.similarweb.com/website/quora.com/)
