# Case 03, how would you know if the AI answers are any good

A mock interview for the **Data Metrics** round. 45 minutes. Claude plays a Quora data scientist. To
practice blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. AI answers on question pages shipped in 2026 Q1 in
this world, consistent with `01_engagement-metric-audit.md` and `02_asker-success-metric.md`.

**What makes this case different from 01 and 02.** Both of those had metrics whose problem was structural:
a denominator that moved, a success condition that went stale. Here the problem is prior to any of that.
The thing the team needs to know is whether an answer is *correct*, and correctness leaves no trace in a
log. Not a weak trace, none. So the metric cannot be a query, and the design question becomes what
instrument to build, how much of it to buy, and what a cheap daily proxy is allowed to stand in for.

**Why it is product sense forward.** The trap is answering "is this answer good" as though it had one
meaning. A Quora answer's value is partly that a named person is standing behind it, which is exactly what
an AI answer cannot offer. So an AI answer that is factually correct and generically written can still be
the wrong thing to put on a question whose whole value was somebody's lived experience. A candidate who
starts from what a Quora answer is *for* gets a per-question-type definition of good. A candidate who
starts from measurement gets a helpfulness rate.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide, Data Metrics | "Can you come up with a metric that captures 'goodness' for a feature within the constraints of what is practical?" | Block 2. "Practical" here means paying humans, because nothing else works |
| Prep guide, Data Metrics | "The interview digs deeper into one fairly complex metric" | The rated instrument in Block 2, and the helpfulness rate in Block 3 |
| Prep guide, current focus | "Deep audits of ML systems" | The premise |
| Prep guide, FAQ | "You'd evaluate systems, including recommenders, rather than train and ship them" | Joseph's role in the scenario |
| Glassdoor 2019, via `../private/final-round-reports.md` | "If your metric is x, how do I know if it is good or bad?" | Block 4's follow-ups. With no external benchmark for AI answer quality, this question bites hardest here |
| `../private/product.md`, D'Angelo 2016 | Quora assesses answer quality and "surveys catch what metrics miss" | Makes the rated instrument Quora-native rather than an imported idea |
| `../private/product.md` | A machine-written answer once surfaced publicly in Google search with a false claim | Block 1's asymmetry argument, and it is real history rather than a hypothetical |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. What good means here, no metrics allowed | 7 | Product intuition |
| 2. Design the instrument | 11 | Metric design under a hard constraint |
| 3. The team's metric | 8 | Metric evaluation |
| 4. The rated sample | 10 | Reading evidence, benchmarking |
| 5. What you tell the team | 5 | Decision, communication |
| 6. Your questions | 4 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **Enforce Block 1.** If he names a metric, say "hold that, I want to know what good means first." Note that
  it happened.
- **Do not hand over the rated sample until Block 4**, and only when he asks for something like it. Whether
  he proposes a rated instrument in Block 2, unprompted, is the central assessment.
- If he proposes engagement as a quality proxy, do not correct him. Let Block 4 do it.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard. Criteria match cases 01 and 02 so scores are comparable.

---

## Block 1, what good means here, no metrics allowed

About 7 minutes.

**Interviewer.** "We put labeled AI answers on question pages two quarters ago. Nobody can agree on whether
they're good. Here's the setup."

> ### Context
>
> **The feature.** On a question page, a clearly labeled AI-generated answer appears alongside human answers.
> It is generated from Quora's existing content plus a model. Readers can upvote it, downvote it, or react.
>
> **Scale.** AI answers currently exist on about 3.1M question pages. They appear on about 0.42M of the live
> person-asked questions created each month, concentrated on questions with no human answer.
>
> **Why the team shipped it.** 41% of questions real people ask get no answer within a week, and a question
> page with no answer is worthless to a reader arriving from search.
>
> **What the team reports today.** An AI answer helpfulness rate, which is the share of AI answers receiving
> an upvote or positive reaction within 7 days. It currently reads 34%.
>
> **The prompt.** Don't give me a metric yet. Tell me what good would even mean here.

**Interviewer.** "So. What makes an AI answer on Quora a good one?"

**Listen for.**

- **Correctness as the first thing, and as a different kind of thing.** For a human answer, Quora has always
  let the crowd sort quality out through votes. For an AI answer that is not enough, because a confidently
  wrong AI answer is attributed to Quora rather than to a person, and Quora has already had one surface in
  Google with a false claim. The liability changes and so does the standard.
- **Good depends on the question type, and this is the whole block.** A factual question wants a correct
  answer and an AI answer can supply one. An experiential question wants a credible first-person account, and
  an AI answer cannot supply one at all, so even a well-written accurate summary is the wrong object on that
  page. A decision question wants perspectives worth weighing, and a single synthesized view actively removes
  what the asker came for. So "good" is at least three different standards and one of them is "should not be
  here."
- **The asymmetry, argued.** A good AI answer on a page that had nothing adds modest value to some readers. A
  wrong one on a page that ranks in Google is durable, public, attributed to Quora, and gets cited elsewhere.
  Those are not symmetric, so the metric should be built to catch errors rather than to celebrate wins.
- **The second-order cost.** An AI answer on an unanswered question reduces the reason for a human to answer
  it. `02_asker-success-metric.md` has that displacement measured. So quality is not only about the answer on
  the page, it is about what the answer prevents.

**Strong signals.**

- Saying that for some question types the right AI answer is no AI answer, and that a quality metric which
  cannot express that is missing the main decision.
- Naming what a Quora answer is for, and noticing that the thing being measured is the one thing Quora has
  that a general-purpose model does not. A candidate who gets there has the case.
- Asking whether the AI answers are generated from Quora's own content, and what that implies. If they are
  synthesized from existing human answers, then on a question with no human answer they are extrapolating,
  which is where errors concentrate, and that is exactly where the feature is being deployed.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Isn't an answer better than no answer?" | On a factual question, usually. On an experiential one I don't think so, because a generic synthesis on a page whose value was somebody's actual experience makes the page look answered while giving the reader nothing they came for, and it takes the question out of the queue for a human who would have done it properly |
| "Readers can downvote a wrong one. Isn't that the system working?" | It's the system working for the readers who can tell. The errors that matter are the ones readers can't check, which is most of why they asked, and those get upvoted at the same rate as anything else |
| "We're only putting these on questions with no human answer. Doesn't that cap the downside?" | It caps the comparison and it concentrates the risk, because a question nobody answered is disproportionately one where the answer isn't in our corpus, so a model synthesizing from our corpus is guessing. The lowest-supply questions are the highest-error ones |

**Model answer.** "Good means at least three different things here and one of them is that the answer
shouldn't exist. On a factual question, good is correct and fast, and an AI answer can do that. On an
experiential question, the thing the reader came for is that a named person did the thing and is telling
them about it, and a synthesized answer can't supply that at any level of accuracy, so the right answer for
that question type is no AI answer at all. On a decision question, the asker wanted a few views to weigh,
and collapsing that into one synthesized position removes the point. So whatever I measure has to know
which type it's looking at, or it'll grade an experiential answer as a success for being accurate. The
second thing I'd want on the table before any metric is that the costs aren't symmetric. A good AI answer
helps some readers a bit. A confidently wrong one sits on a page that ranks in Google, gets attributed to
Quora rather than to a person, and stays there, and we've already had one of those surface publicly. So the
instrument should be built to find errors rather than to count wins. And the third thing is displacement:
these go on questions with no human answer, which means they reduce the reason for a human to write one,
and that cost lands on the corpus rather than on the page. I'd also want to know whether they're generated
from our own content, because if they are, then on a question with no human answer the model is
extrapolating past what we have, which is exactly where it'll be wrong."

**Traps.**

- Naming a metric.
- Treating "is it a good answer" as one question.
- Symmetric treatment of good and bad answers.
- Missing that this is deployed precisely where the error rate should be highest.

**Score.** 4 treats quality as one thing, or jumps to measurement. 6 separates question types and names the
correctness problem. 8 also argues that for some types the right answer is none, names the asymmetry with
the public-error history, and notices the deployment concentrates on the highest-error questions.

---

## Block 2, design the instrument

About 11 minutes.

**Interviewer.** "So how would you measure it?"

**Listen for.**

- **The recognition that correctness is not in the logs, stated as a hard constraint rather than a
  difficulty.** There is no click, dwell, vote or reaction that carries information about whether a claim is
  true. Every logged signal measures whether a reader engaged, and a reader who could verify the claim
  mostly would not have needed the answer. So the primary instrument has to involve humans reading answers
  and judging them.
- **A rated sample as the primary, with a protocol rather than a vibe.** What is rated, by whom, against what
  rubric, and with what per-question-type standard. The rubric is where the Block 1 reasoning cashes out: a
  rater should be able to mark an experiential question's AI answer as "should not be here" without marking
  it factually wrong.
- **Three rating outcomes, not two.** Defensible, materially wrong, and unverifiable. Collapsing unverifiable
  into either of the others is the most common protocol error, and the unverifiable share is itself a finding,
  because a claim nobody can check is a claim Quora should probably not be publishing unattributed.
- **A logged daily proxy, explicitly subordinate.** Something is needed for a dashboard, and it should be
  calibrated against the rated sample and re-checked on a schedule, never trusted on its own. Downvote rate
  and mute rate are the least bad candidates because they are at least negative signals.
- **Cost, named before being asked.** A candidate who proposes human rating without acknowledging it costs
  money has not finished the thought. 2,000 answers a month at eight minutes each is about 267 hours, roughly
  $8,000 a month or under $100,000 a year, with a fifth double-rated for reliability. That is a small standing
  cost against a metric the company steers a strategic feature on, and having the number ready is what makes
  the proposal survive a budget conversation.

**Strong signals.**

- **Sizing the sample by what it has to detect rather than by what sounds reasonable.** To see the material
  error rate move from 12% to 9%, a 25% relative reduction, needs roughly 1,640 rated answers per period. To
  see 12% to 10% needs about 3,840. So 2,000 a month can read a large improvement and cannot read a small
  one, and that fact should determine the sample, not the other way round.
- **Stratifying the sample rather than drawing it at random.** A simple random sample of AI answers is mostly
  factual questions and will be uninformative about the experiential ones where the feature is most
  questionable. Oversampling by question type, and by whether a human answer exists, is what makes the
  instrument answer the decision.
- Inter-rater reliability treated as a number to report rather than a box to tick. If two raters disagree on
  a third of answers, the rubric is the problem and the headline rate means little.
- Saying what he would *not* do: build a model to predict correctness. It would be trained on the ratings, so
  it inherits the sample it came from and cannot generalize to the errors nobody has seen yet, and it would
  give the team a number with no ground truth behind it, which is the situation they are already in.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Human rating is slow and expensive. Sell it to me." | Under $100,000 a year for the only trustworthy read on a feature we're putting on three million pages and betting strategy on. And it's not an alternative to the dashboard, it's what tells us whether the dashboard still means anything. The expensive option is the one where we find out from a journalist |
| "Could readers rate them? A thumbs up and down on the AI answer." | That gives me volume and it doesn't give me correctness, because the readers who can check the claim mostly didn't need the answer. It's useful for the reading experience and it's the same class of signal as an upvote |
| "Why three rating categories?" | Because unverifiable is a real and different outcome, and folding it into either of the others hides the thing I'd most want to know. A claim no rater can check is a claim we're publishing without attribution and without support, and I'd want that share reported on its own |
| "How often would you rate?" | Monthly, and sized for the change worth acting on rather than for a round number. 2,000 a month reads a 12 to 9 point move in the error rate and can't read 12 to 10, so if the decision hinges on smaller moves the sample has to grow |

**Model answer.** "The constraint that decides the design is that correctness isn't in the logs at all. Every
signal we have measures whether a reader engaged, and a reader who could have checked the claim mostly
wouldn't have needed the answer. So the primary instrument is people reading answers against a rubric, and
the rubric carries the question-type distinction from a minute ago: a rater should be able to mark an
experiential answer as one that shouldn't be on the page without marking it factually wrong. Three outcomes,
not two, because unverifiable is its own finding and I'd report it separately. On sizing, I'd set the sample
by the smallest move in the material error rate that would change what we do. If that's 12% to 9%, it's
about 1,640 a month; if it's 12% to 10%, it's nearly 3,900, so this is a decision about budget and it should
be made deliberately. I'd stratify rather than sample at random, by question type and by whether a human
answer already exists, because a random sample is mostly factual questions and the interesting cases are
elsewhere. Cost is around $8,000 a month at 2,000 answers with a fifth double-rated, which is under
$100,000 a year, and I'd rather have that number ready than be asked for it. Then a logged proxy for the
daily dashboard, calibrated against the rated sample and re-checked quarterly, and I'd use downvotes and
mutes rather than upvotes because at least they're negative signals. The thing I wouldn't do is train a
model to predict correctness from the ratings, because it can only learn the errors we've already seen and
it would hand the team a confident number with nothing behind it."

**Traps.**

- A logged metric as the primary.
- Human rating proposed with no protocol, no sample size and no cost.
- Two rating categories.
- A random sample.
- Proposing a correctness classifier as the answer.

**Score.** 4 proposes an engagement or logged metric as the primary. 6 proposes human rating with a rubric.
8 also sizes the sample by the smallest actionable change, stratifies by question type, has the cost ready,
uses three rating outcomes, and declines to build a classifier for a stated reason.

---

## Block 3, the team's metric

About 8 minutes.

**Interviewer.** "The team reports a 34% helpfulness rate and it's gone up two quarters running. What do you
make of it?"

**Listen for.** The criticisms, separated and ranked.

| Part | What is wrong | Size |
|---|---|---|
| What it measures | An upvote is a reader's reaction, not a verdict on accuracy. It measures whether the answer read well | Largest |
| Direction | It counts positives only, on a feature whose main risk is a rare severe negative | Large |
| Denominator | AI answers shown. The team controls where they appear, so showing them on easier questions raises the rate | Moderate |
| Aggregation | One rate across question types with different standards, including types where the right answer is none | Moderate |
| Who votes | Upvotes come from readers who mostly cannot check the claim | The reason the whole thing fails |
| Trend | Two quarters of rises could be the answers improving, the placement getting easier, or readers getting used to the format | Unresolvable as reported |

**Strong signals.**

- Predicting that the helpfulness rate and correctness will turn out to be uncorrelated, before seeing any
  evidence, and saying why: an upvote rewards fluency and confidence, and a confidently wrong answer is
  fluent and confident. That is a mechanism-based prediction and Block 4 either confirms it or does not.
- Noticing that a metric made of positives cannot govern a feature whose failure mode is a rare bad event.
  Counting wins on a thing whose risk is tail-shaped is a category error, and the fix is to lead with an
  error rate.
- Asking what drove the two-quarter rise before crediting it, and naming placement as the likeliest
  explanation given the team controls it.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "34% seems decent. Is it good or bad?" | I can't tell from the number and neither can anyone else, which is most of what's wrong with it. There's no external benchmark for AI answer helpfulness, no internal comparison because human answers get voted on under completely different conditions, and no calibration against anything we've independently judged good. On its own it's a baseline, and I wouldn't attach a target to it |
| "Give me a version of it I could compare against something." | The nearest honest comparison is the upvote rate on human answers on the same questions, and even that is confounded because a human answer carries an author people may follow. The comparison I'd actually build is the rated sample, because raters judge against a standard rather than against each other |
| "Isn't a rising number good news?" | Only if I know which of three things caused it. If the answers got better, good. If we moved them onto easier questions, that's a placement change dressed as a quality improvement. If readers got used to seeing them, that's habituation. The team controls the second one, which is why I'd want it ruled out first |

**Model answer.** "It measures whether an answer read well, and it's being used as though it measures whether
an answer is true. Those come apart in a specific and bad way: an upvote rewards fluency and confidence, and
a confidently wrong answer is fluent and confident, so I'd expect this rate to be close to uncorrelated with
accuracy and I'd want to check that. The second problem is direction. This is a feature whose main risk is a
rare severe error, and the metric counts positives, so the thing we most need to see can't move it. Any
metric governing this should lead with an error rate. Then the denominator is AI answers shown, and the team
chooses where to show them, so moving onto easier questions raises the rate without changing anything. And
it's one number across question types where the standards differ and where for some types the right answer
is not to be on the page at all. On the two-quarter rise: that could be the answers improving, the placement
getting easier, or readers habituating, and as reported I can't distinguish them. On whether 34% is good, I
don't think anyone can say, because there's no benchmark, no comparable, and no calibration. It's a baseline
and it shouldn't carry a target."

**Traps.**

- Stopping at "upvotes aren't quality."
- Missing that the metric counts only positives.
- Accepting the two-quarter trend.
- Answering "is 34% good" with a guess instead of with what would make it interpretable.

**Score.** 4 names one flaw. 6 identifies that engagement is not accuracy and that the denominator is
controlled. 8 predicts the zero correlation from mechanism, names the positives-only problem as a category
error for a tail risk, and handles the benchmark question by saying what would make the number interpretable.

---

## Block 4, the rated sample

About 10 minutes.

**Interviewer.** "We did run a rated sample once, last quarter. 2,000 answers. Nobody did much with it."

> | Rating | Share | Count | Upvote rate within the group |
> |---|---|---|---|
> | Factually defensible | 71% | 1,420 | 35% |
> | Contains a material error | 12% | 240 | 38% |
> | Unverifiable from available sources | 17% | 340 | 30% |
> | **All** | | **2,000** | **34.5%** |

**Interviewer.** "What does that tell you?"

**Listen for.**

- **The headline: the helpfulness rate is measuring nothing about correctness.** Materially wrong answers are
  upvoted at 38% against 35% for defensible ones. The correlation between being upvoted and being right is
  about +0.02, which is to say zero, and if anything it points the wrong way. The 34% the team reports and
  the 34.5% here are the same number, so the reported metric is reproduced exactly by a sample in which
  accuracy is irrelevant.
- **The number that should lead instead: 12% material error.** On 3.1M question pages that is roughly 370,000
  pages carrying an error, and these pages rank in Google. Stating it in absolute terms rather than as a rate
  is what makes it a decision rather than a statistic.
- **The 17% unverifiable, which is the quietly interesting one.** A sixth of the answers make claims no rater
  could check against a source. Whether that is acceptable is a policy question rather than a measurement
  one, and it is not visible anywhere in the current reporting.
- **Reading the wrong-answers-do-better finding correctly.** It is not that errors are rewarded on purpose.
  It is that a confident, fluent, well-structured answer gets upvoted, and confidence is uncorrelated with
  correctness in a generated answer. That mechanism is worth stating because it generalizes to every
  engagement-based quality proxy anyone will ever propose for this feature.

**Strong signals.**

- Asking whether the sample was stratified, and what it would look like split by question type. If the 12%
  concentrates on questions with no human answer, or on experiential questions, that is the operational
  finding and the fix is placement rather than model quality.
- Noticing that 2,000 rated answers is right at the edge of useful. It can detect the error rate moving from
  12% to 9% and cannot detect 12% to 10%, so if the team commits to an improvement target, the sample has to
  grow with the precision the target implies.
- Asking about inter-rater agreement before treating 12% as precise.
- Saying plainly that this sample already existed and nobody acted on it, and that the reason is that it was
  a one-off rather than an instrument. A number produced once is a study; a number produced monthly with a
  protocol is a metric, and only the second kind changes behavior.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "So the helpfulness rate is useless?" | For quality, yes, and it's measuring something real about the reading experience. I'd keep it under an honest name and stop letting it answer the accuracy question |
| "Is 12% error good or bad?" | It's bad in absolute terms because 12% of 3.1M pages is around 370,000 pages with an error on them, indexed and attributed to us. Whether it's bad relative to something, I don't have a comparison and I'd be careful about inventing one. What I'd do is set the bar from the consequence rather than from a benchmark: decide what error rate we'd accept on a page that ranks in Google under our name, and work back |
| "What would you do with the 17% unverifiable?" | Report it separately and escalate it as a policy question, because it isn't really about quality. We're publishing unattributed claims that nobody can check, and whether that's acceptable is a decision for someone above me. The measurement job is making sure it's visible |
| "The sample is a quarter old. Still valid?" | The error rate almost certainly moved, because the model and the placement both changed. Which is the argument for it being monthly rather than an argument for discounting it |

**Model answer.** "The first thing is that the helpfulness rate and correctness have nothing to do with each
other. Materially wrong answers were upvoted at 38% and defensible ones at 35%, so the correlation is
roughly zero and if anything it's backwards. And the sample reproduces the reported 34% almost exactly,
which means the metric the team has been watching for two quarters is fully explained by something that
doesn't involve accuracy. The mechanism is that an upvote rewards fluency and confidence, and a generated
answer's confidence tells you nothing about whether it's right, and that generalizes to every
engagement-based proxy anyone will propose for this. The number that should be leading is the 12% material
error rate, and I'd state it as about 370,000 question pages carrying an error, indexed under our name,
because the rate makes it sound like a statistic and the count makes it a decision. Then the 17%
unverifiable, which I'd report separately and push upward as a policy question rather than a measurement
one. What I'd want next is the 12% split by question type and by whether a human answer exists, because if
the errors concentrate where the model is extrapolating past our corpus, the fix is placement rather than
the model. I'd also want inter-rater agreement before I treat 12% as a precise number. And the thing worth
saying about this sample is that it existed and nobody used it, which is what happens to a study. Run
monthly with a protocol it would be a metric, and that's the difference that changes behavior."

**Traps.**

- Not noticing that the sample's overall upvote rate reproduces the reported metric.
- Reporting 12% as a rate and never as a count of pages.
- Folding the 17% into either of the other two.
- Treating 12% as precise without asking about rater agreement.
- Missing that a one-off sample is not a metric.

**Score.** 4 notes that upvotes are imperfect and moves on. 6 identifies the zero correlation and leads with
the error rate. 8 also converts the rate to a page count, separates the unverifiable share as a policy
question, asks for the split by question type and for rater agreement, and names why the earlier sample
changed nothing.

---

## Block 5, what you tell the team

About 5 minutes.

**Model answer.** "Headline: we've been reporting a number that doesn't measure what we think it does, and
we already have the evidence, we just didn't use it. The helpfulness rate is fully explained by how well an
answer reads, and materially wrong answers get upvoted slightly more often than correct ones, so two
quarters of rises tell us nothing about accuracy. What I'd change is three things. Lead with the material
error rate rather than a helpfulness rate, and report it as a count of affected pages, which is currently
around 370,000. Rename the helpfulness rate to what it measures, reader reaction, and keep it, because the
reading experience is worth knowing about. And turn the rated sample from a one-off into a monthly
instrument with a protocol, three outcomes including unverifiable, stratified by question type, sized for
the smallest error-rate move we'd act on. That's about $8,000 a month, under $100,000 a year, which is small
against a feature on three million pages. Two things I'd escalate rather than solve. The 17% unverifiable is
a policy question about whether we publish unattributed claims nobody can check, and that isn't mine to
decide. And the error rate is likely concentrated on questions where no human answered, because that's where
the model is extrapolating past our own corpus, which would mean the highest-value fix is where we place
these rather than how we generate them. I'd want that split before anyone touches the model."

**What pushes it to an 8.** Naming that the evidence already existed and the failure was organizational
rather than analytical. Having the cost ready. Separating what he would fix from what he would escalate.
Pointing at placement rather than model quality as the likely lever, which is a product recommendation
rather than a measurement one.

**Traps.** Leading with the instrument design instead of the finding. No cost. Recommending a model change
before the error split is known. Treating the unverifiable share as his call.

**Score.** 4 proposes a new metric with no verdict. 6 gives the verdict and the replacement. 8 adds the page
count, the cost, the escalation boundary, and the placement hypothesis.

---

## Block 6, your questions

About 4 minutes. Not scored.

- "Is there a rated or surveyed read on answer quality that runs regularly, or is it all logged?"
- "Who decides whether an AI answer should appear on a given question, and is question type an input?"
- "What's the current view on the tradeoff between filling an unanswered question and discouraging a
human from answering it?"
- "Has the error rate on AI answers ever been reported to leadership?"

---

## Scorecard

Same criteria as cases 01 and 02, so scores are comparable across the folder.

| Criterion | Score | Evidence |
|---|---|---|
| Metric design, Block 2 | | |
| Metric evaluation, Blocks 3 and 4 | | |
| Diagnosing a broken metric, Block 4 | | |
| Accountability and incentives, Blocks 3 and 5 | | |
| Product intuition, Block 1 | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Metric design | A logged metric as the primary | Human rating with a rubric | Sample sized by the smallest actionable change, stratified, costed, three outcomes, declines to build a classifier |
| Metric evaluation | Names one flaw | Engagement is not accuracy, denominator is controlled | Predicts the zero correlation from mechanism, and calls positives-only a category error for a tail risk |
| Diagnosing | Notes upvotes are imperfect | Leads with the error rate | Converts the rate to affected pages, separates the unverifiable share, asks for the type split and rater agreement |
| Accountability | No view on how the metric shapes behavior | Notes the team controls placement | Says a one-off study is not a metric and explains why the earlier sample changed nothing |
| Product intuition | Quality as one thing | Separates question types | Argues that for some types the right answer is none, and that deployment concentrates on the highest-error questions |
| Communication | Method before finding | Verdict first | Cost ready, escalation boundary drawn, and a product recommendation rather than only a measurement one |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he name a metric during Block 1?
- Did he propose a rated instrument in Block 2 unprompted, or only after the sample was shown?
- Did he predict the zero correlation before seeing Block 4?
- Did he ever state the error rate as a count of pages rather than a percentage?

| Block | Target | Actual |
|---|---|---|
| 1. What good means | 7 min | |
| 2. Design the instrument | 11 min | |
| 3. The team's metric | 8 min | |
| 4. The rated sample | 10 min | |
| 5. What you tell the team | 5 min | |

Top three fixes for the next mock.

1.
2.
3.
