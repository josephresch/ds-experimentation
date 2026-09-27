# Case 02, did the person who asked get what they needed

A mock interview for the **Data Metrics** round of the Quora final round loop. 45 minutes, one file,
written in the order the interview happens. Claude plays the interviewer. To practice blind, stop
reading after the context in Step 2.

All numbers are synthetic and were computed by script so every table agrees. Product mechanics follow
`../private/product.md`. Where a figure also appears in case 04 of the first-round set
(`../04-instant-answers.md` and `../private/04_ask-instant-answer.md`), this case uses the same value,
so the two do not contradict each other.

**This case is product sense forward on purpose.** Step 2 forbids you from naming a metric. You have to
reason about who asks questions on Quora and what a good outcome even is for them before you are
allowed to measure anything. That ordering is the thing being tested: the prep guide says good
hypotheses come from having a view on how people actually use a product, and a metric proposed before
that view exists is the failure mode.

**Difference from case 01.** Case 01 was an audit. A metric rose 15% while the company shrank, and the
work was forensic. Here the metric falls while the product genuinely improves, and the work is design
and re-evaluation. Different mechanism, opposite verdict. Case 01 also gave "break your own metric" its
own step. That was a concession to practice. The prep guide says to name what could go wrong with a
metric *before anyone asks*, so here it is scored inside Step 3 as unprompted behavior, which is how the
real round will treat it.

**Known overlap.** Case 04 of the first-round set tests an instant AI answer in the ask flow and teaches
that effects differ by question type. That lesson recurs here. The difference is that case 04 asks
whether to launch a feature and this case asks what the team should have been measuring all along, and
the headline lesson here is a metric that punishes a real improvement. Stated rather than papered over.

## Why this case

| Source | What it says | Where it shows up |
|---|---|---|
| Final round email | "How you pick the right measure for a goal, what you'd watch alongside it to catch unintended effects" | Steps 3 and 4 |
| Final round email | "How you re-evaluate a metric when it stops telling you what you need to know" | Step 5. Here it stops working because the product changed, not because the data drifted |
| Prep guide, Data Metrics | "Going deep in understanding a choice of metrics in a particular area of Quora" | One area, the asker, for the whole 45 minutes |
| Prep guide, Data Metrics | "The interview digs deeper into one fairly complex metric" | ASR, a rate whose denominator, success condition and window are each wrong in a different way |
| Prep guide, Data Metrics | "Can you come up with a metric that captures 'goodness' for a feature within the constraints of what is practical?" | Step 3. The asker's own signal exists for about 9% of questions, so "practical" is the whole difficulty |
| Prep guide, Data Metrics | "Practice naming what could go wrong with a metric you propose, before anyone asks" | Scored inside Step 3, unprompted |
| Prep guide, what we look for | "Product intuition with the numbers. We listen for curiosity about the product itself" | Step 2 is product reasoning with no metric allowed |
| Prep guide, what we look for | "Rigor that knows when to stop. Choosing the simpler approach on purpose is a strength here" | Step 3 wants the scrappy logged version first and the rated sample second |
| Prep guide, past projects | "What drives people to ask questions in the first place" | The area. The one named past project nothing else in the prep folder covers |
| Prep guide, current focus | "Navigating AI's effect on search-driven traffic" and deep ML audits | Both product changes in Step 5 are ML systems changing what success looks like |
| `product.md` | Answer requests, suggested questions, duplicate detection and merging, AI-generated questions since 2023 | The mechanics the case runs on |
| `product.md`, D'Angelo 2016 | "Surveys catch what metrics miss," and Quora assesses answer quality | Makes the Step 6 recommendation Quora-native rather than generic |

## Clock

| Step | Minutes | Scored on |
|---|---|---|
| 1. Warm-up | 3 | Experience and opinions |
| 2. The area, no metrics allowed | 8 | Product intuition |
| 3. Design the metric | 10 | Metric design, and unprompted critique |
| 4. The team's metric | 8 | Metric evaluation |
| 5. The product moves under it | 9 | Re-evaluation, diagnosis |
| 6. What you tell the team | 4 | Accountability, communication |
| 7. Your questions | 3 | Not scored |

## How Claude runs it

- Default is a full mock. Stay in character as a Quora data scientist. No teaching or grading until the end.
- Say each step's opening line, then let him answer. At most two follow-ups per step, picked for what he missed.
- Paste context and tables exactly as written, and only when the step or his request calls for them.
- **Enforce Step 2.** If he names a metric during Step 2, say "Hold the metrics for a minute, I want your
  read on the asker first." Note that it happened. It is the most diagnostic moment in the case.
- Release a Step 3 or Step 5 figure only when a request maps to it. A vague request gets "What exactly
  would you want to know, and what would you do differently depending on the answer?"
- Don't lead. No hint about which criticism is the important one.
- Record the time with `date` at each step. Move on when a step runs a minute or two past target.
- If he says "pause," give short feedback on the current step, then resume.
- If he asks for a fact the file doesn't have, answer consistently with the case, then add it afterward.
- At the end, debrief with the scorecard. Same criteria as case 01, so scores are comparable.

---

## Step 1, warm-up

About 3 minutes. Keep it short. The value of this round is in Steps 2 to 5.

**Interviewer.** "I want to spend today on one area of the product and the metrics around it. Quick
question to start."

**Q1.** "What's a product you use where you think the company is measuring the wrong thing, and what
would you measure instead?"

- Listen for a real product, a specific mechanism, and a metric he would actually put in place. This is
  a product sense question wearing a metrics costume, which is a fair preview of the round.
- A Quora answer here is fine and slightly bold. If he uses Quora, he should be specific about which
  surface, and he should not open with criticism of the company he is interviewing at without also
  saying what is hard about the problem.

**Follow-up.** "What would the company lose by switching?"

**Score.** 4 is generic or has no replacement metric. 6 is a specific product and a credible replacement.
8 also names what the current metric was right about and what the switch would cost.

---

## Step 2, the area, no metrics allowed

About 8 minutes. The hardest step to do well and the easiest to skip past.

**Interviewer.** "Today's area is the asker. Someone types a question into Quora and posts it. Here's
some context on how that works."

> ### Context, asking a question on Quora
>
> **The flow.** A user opens the Add Question window and types. Quora suggests similar existing questions
> while they type. If they post, the question goes live on its own page. From there it can reach writers
> three ways: answer requests the asker sends by hand, answer requests Quora routes to likely answerers,
> and suggested questions in the home feed with options to answer, follow or pass.
>
> **Merging.** Quora runs duplicate detection. A question judged to be a duplicate of an existing one is
> merged into it, and the asker is routed to the existing question's answers. A merged question does not
> accumulate answers of its own.
>
> **Who asks.** Asking is much rarer than reading. A Quora account has also posted generated questions
> since at least 2023, and writers have criticized them as generic and sometimes built on a false premise.
>
> **Volume, per month.** Synthetic.
>
> | Quantity | Value |
> |---|---|
> | Questions created | 4.20M |
> | Asked by a logged-in person | 1.80M |
> | Created by Quora question accounts | 2.40M |
> | Person-asked questions merged as duplicates | 12% |
>
> **The prompt.** Don't propose a metric yet. I want your read on the asker first.

**Interviewer.** "Who is asking, what do they want, and what would count as a good outcome for them?"

**Listen for.**

- **Question types with different success conditions.** A factual question wants one correct answer fast.
  A decision or advice question wants two or three perspectives worth weighing. An experiential question
  wants a credible first-person account, where one is worth more than ten generic ones. An opinion or
  discussion question wants range. One success condition applied across all four will mis-grade most
  questions, and this is the insight the whole case rests on.
- **The asker controls none of the outcome.** Almost every product metric measures something the user did.
  This one measures what strangers did for them, on a timeline nobody controls. That changes what a
  "good" rate even means, and it makes the metric partly a measure of writer supply.
- **The best outcome can be not posting.** If the answer already exists, the ideal path is the suggestion
  in the Add Question window or a merge. A good ask flow should reduce posted question volume, so a
  metric with posted questions as its unit of value has the sign backwards.
- **Most questions have no asker.** 2.40M of 4.20M are generated. They cannot succeed or fail at
  satisfying anyone, and a metric that includes them is mostly measuring something else.
- **The asker usually leaves.** Satisfaction is felt by someone who is not there to be measured.
- **The other side of the market.** Every satisfied asker consumes writer attention, which is the scarce
  resource. `product.md` puts writing at about 2% of users in a month, with the top 1% of writers
  producing about half of all answers. Asker success is a claim on that, not a free good.

**Strong signals.**

- Getting to question types unprompted and giving different success conditions for at least three.
- Saying that a merge is a success and probably the best one available, since it is instant and lands on
  content that already proved itself.
- Asking who the 2.40M generated questions are for. They are for readers and for search, not askers,
  which means Quora has two products sharing one object.
- Naming the supply constraint before being asked about guardrails.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Why should I care about askers at all? Most of our traffic is readers from search." | Because questions are the inventory readers arrive on, and a person-asked question is the only kind with evidence that a real human wanted to know. They are also the seed of the loop: someone whose question gets answered has a reason to come back, and almost nothing else on Quora gives a logged-in user that |
| "Aren't most of these questions bad?" | Many are duplicates, vague or built on a false premise, and handling those is product work rather than a measurement problem. Merging a duplicate and declining to surface a bad-premise question are both successes, and a metric should be able to record them as such |
| "Give me the one thing you'd want to know about askers that you don't know from this." | What share of askers ever came back to look. Everything downstream depends on whether the asker is a person waiting for an answer or someone who typed a question and left |

**Model answer.** "The asker is a much rarer user than the reader and shows up with a specific need, so
I'd start by splitting them by what kind of need it is. A factual question succeeds with one correct
answer quickly. A decision question succeeds with a few perspectives good enough to weigh against each
other. An experiential question succeeds with one credible first-person account and gets almost nothing
from volume. A discussion question wants range. Those are four different definitions of good, with
different natural speeds, so anything I measure has to know which one it's looking at. Two structural
things stand out. First, the asker doesn't produce their own outcome. Strangers do, over a timeline
nobody controls, which means asker success is partly a measure of writer supply rather than of the ask
experience. Second, for a factual question the best outcome may be that they never post, because the
suggestion in the Add Question window or a merge gets them there faster and lands on content that
already proved itself. So a good ask flow should reduce posted questions, which is the opposite of what
a volume metric would reward. I'd also separate the 2.40M generated questions out entirely. They have no
asker, so they can't succeed at this, and mixing them in means measuring mostly something else. The last
thing I'd hold onto is that satisfying askers spends writer attention, and writing is about 2% of users
in a month with half the answers from the top 1%. That's the binding constraint behind any answer I give
you later."

**Traps.**

- Naming a metric. The step explicitly says not to, and reaching for one anyway is the documented
  over-engineering reflex in its most visible form.
- Treating askers as a smaller version of readers.
- Missing that generated questions have no asker.
- Talking only about the asker and never about the writers who have to produce the outcome.

**Score.** 4 describes a generic user who wants a good answer, or jumps to metrics. 6 separates question
types and names the supply constraint. 8 also gets that a merge is a success and that a good ask flow
reduces posted volume, and asks what the generated questions are for.

---

## Step 3, design the metric

About 10 minutes.

**Interviewer.** "Now build it. How would you measure whether the ask experience is working?"

**Release on request only.**

> | Quantity, person-asked questions | Value |
> |---|---|
> | No answer within 7 days | 41% |
> | Human answers per posted question within 7 days | 1.57 |
> | Four or more answers within 7 days | 12% |
> | No answer within 30 days | 36% |
> | Median time to first answer, among answered | 4.2 hours |
> | 75th percentile | 2.1 days |
> | 90th percentile | 9 days |
> | Eventual first answers arriving after day 7 | 14% |
> | Askers who view their own question page again within 7 days | 34% |
> | Askers who upvote any answer to their own question | 9% |

If he asks how this compares to the outside record: a 2013 study found about 20% of questions had four
or more answers against 12% here, because question volume has grown far faster than writer supply.

**Listen for.**

- **The scrappy logged version first**, then the honest version, with the reason for both. This loop names
  choosing the simpler approach on purpose as a strength.
- **The practical constraint named out loud.** The asker's own signal exists for about 9% of questions.
  That is the binding limit and it should shape the design rather than be discovered later.
- **Merged questions counted as a success path**, not dropped.
- **Person-asked denominator.**
- **A window justified rather than asserted**, ideally different by question type, with the 14% tail
  acknowledged.
- **Unprompted critique.** He should tell me what is wrong with his own metric before I ask.

**Strong signals.**

- Separating the source of truth from the dashboard. A rated sample of a few thousand questions a month,
  judged against the question's own type, is the honest measure. A logged proxy reported daily is
  calibrated against it and re-checked on a schedule. Saying this in that order, and saying he would not
  try to make the logged proxy measure correctness directly, is the best answer in the case.
- Using the 9% who upvote an answer to their own question as a validation signal rather than as the metric.
- A writer-attention guardrail: answer requests and notifications spent per satisfied asker.
- Noticing that a metric which rewards answers on posted questions fights the merge path, and building
  merge-to-answered in from the start so the two do not compete.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Only 9% of askers give you any signal. So why not just use answer count?" | Because answer count is a supply measure dressed as a satisfaction measure. Ten generic answers to an experiential question is a failure and one good one is a success, and count cannot tell them apart. The 9% is too small to be the metric and big enough to validate one |
| "You want a human-rated sample. That's expensive and slow. Sell it to me." | A few thousand questions a month is a small standing cost against a metric every asker-side team is held to. And it is the only thing that can tell me whether the logged proxy still means what it meant, which is the failure that actually happens |
| "Defend your window." | Type-dependent. A factual question unanswered at 24 hours has mostly failed. A discussion question can keep earning for weeks. 14% of eventual first answers land after day 7, so any single short window systematically under-credits the slow half. I'd report at 48 hours and 30 days and treat the gap between them as information |
| "Give me the version I can ship this week." | Share of person-asked questions that either merged into a question with an existing answer or received at least one substantive answer within 48 hours, where substantive is a length and not-deleted floor. Split by question type. It is crude on quality and honest about it |
| "Your metric comes back at 46%. Good or bad?" | I cannot tell from the number, and that is the honest answer in the first quarter of any new metric. What makes it interpretable is the rated sample, because raters judge individual cases against the question type, so I can say what a 46% world looks like rather than only where it sits. I would also split it by question type immediately, since one figure across four question types with four different success conditions is an average of things that should not be averaged, and the split usually shows one type doing badly enough to act on |

**Model answer.** "I'd separate what I report daily from what I trust. The thing I trust is a rated
sample: a few thousand person-asked questions a month, each rated against its own question type, asking
whether this asker got something they could use. That is the only measure that can survive the product
changing, and it costs a standing rater budget. The thing I report daily is a logged proxy calibrated to
that sample, and the scrappy first version is the share of person-asked questions that either merged
into a question with an existing answer or picked up at least one substantive answer within 48 hours,
split by question type. Denominator is person-asked only, because generated questions have no asker.
Merges count as successes, and I'd build that in from the start, otherwise the metric fights the merge
path, which is the fastest good outcome we have. Secondaries are time to first answer by type, the
30-day figure next to the 48-hour one so I can see the slow tail, and the 9% of askers who upvote an
answer to their own question as a validation signal rather than as the metric. Guardrails are writer
attention spent per satisfied asker, since answer requests and notifications are the cost side, and
merge precision, since an aggressive merge is a silent failure. Three things are wrong with what I just
gave you. The substantive floor measures length, not correctness, so a confident wrong answer scores as
a success and only the rated sample catches it. The proxy is partly a writer supply metric, so it will
move when nothing about the ask experience changed. And a team held to it will send more answer requests,
which is why the writer-attention guardrail is not optional."

**Traps.**

- Opening with a weighted composite. Same reflex as case 01, different disguise.
- Answers per question, or time to first answer alone, as the primary. Both are supply metrics.
- Dropping merges, which quietly makes the metric hostile to the best outcome available.
- Waiting to be asked what is wrong with it. The prep guide says to volunteer this.
- Proposing a survey of askers without noticing that two thirds of them never come back.

**Score.** 4 is answer count or time to answer, with all questions in the denominator. 6 has a defensible
primary on person-asked questions, secondaries and guardrails. 8 separates the rated source of truth from
the logged dashboard proxy, counts merges as a success path, and volunteers the metric's own failures
without being asked.

---

## Step 4, the team's metric

About 8 minutes.

**Interviewer.** "Here's what the asker-side team is actually held to. Tell me how it compares to yours."

> ### Context, ASR
>
> **Answered Satisfaction Rate.** The share of questions created in a month that receive at least one
> answer with two or more upvotes within seven days.
>
> - The denominator is all questions created, generated questions included.
> - It has been the asker-side team's headline metric for three years and sits in the quarterly goal.
> - Current level: 13.7%.

**Listen for.** Criticisms separated by which part of the definition is broken, because they have
different sizes and different fixes.

| Part | What is wrong | Size |
|---|---|---|
| Denominator | 57% of questions have no asker, so most of the metric is measuring content seeding | Large and loud |
| Success condition | Two upvotes is a reader signal. It requires the answer to get distribution, so the metric partly measures feed and search reach rather than whether the asker was helped | Largest, and quiet |
| Success condition | A merged question can never clear the bar, so the best outcome scores zero | Large |
| Window | Seven days drops 14% of eventual first answers, unevenly across question types | Moderate |
| Unit | One rate across four question types, so it grades an experiential question the way it grades a factual one | Moderate |
| Incentive | Upvotes need readers, and broad generic questions get more readers than specific ones. A team held to ASR is rewarded for steering Quora toward generic questions | The one that compounds |

**Strong signals.**

- Ranking the criticisms. The denominator is the easiest to see and is not the biggest.
- Getting the incentive mechanism concretely: optimizing for upvotes on answers pushes toward questions
  with wide audiences, which is the generic-question drift writers already complain about.
- Noticing that ASR is not a subset of a correct metric, it is a different set. It counts some answers
  that never helped the asker and misses successes that never earned an upvote.
- Not claiming ASR is worthless. It is a real signal about whether questions get answers readers value,
  which is a legitimate thing to know. It is just not asker satisfaction.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Two upvotes is a quality bar. Isn't that better than counting any answer?" | It is a better quality bar than nothing and it is the wrong person's opinion. Upvotes come from readers who arrived later, so the bar rises and falls with how much distribution the answer got. An answer that perfectly resolved a niche question and was read by four people fails it |
| "If we fix the denominator, are we fine?" | It is the necessary first fix and it is not close to sufficient. The success condition is the deeper problem, because it defines helping the asker as producing an answer readers upvote, and those come apart |
| "Three years of goals were set on this. What do you do about that?" | Backfill the replacement over those three years and reset targets against that history. Nobody should be penalized for a definition change, and the retro tells you which years were real |
| "Would you keep ASR at all?" | Yes, renamed, as a reader-value metric on answers, which is what it actually measures. The mistake was the label, not the arithmetic |

**Model answer.** "It overlaps mine in one place and diverges in three. The loudest problem is the
denominator, since 57% of these questions have no asker, so most of ASR is measuring whether generated
questions attract answers readers like. That is a real thing to know and it is not asker satisfaction.
The deeper problem is the success condition. Two upvotes is a reader's verdict, not the asker's, and
upvotes require distribution, so ASR partly measures how much reach an answer got. An answer that
resolved a specific question for the person who asked it and was read by four people fails the bar.
Merged questions can never clear it at all, so the fastest good outcome we have scores zero. Then the
window drops 14% of eventual first answers, and it is one rate across four question types with different
natural speeds. The part I'd flag hardest is the incentive, because upvotes need readers and broad
generic questions have more readers than specific ones, so a team held to ASR is being paid to push
Quora toward generic questions, which is the drift writers already complain about. I'd keep the
arithmetic and rename it a reader-value metric on answers, which is what it measures, and build the
asker metric separately."

**Traps.**

- Stopping at the denominator.
- Declaring the metric useless. It measures something real under the wrong name.
- Missing the incentive. This is the Goodhart content the prep guide points at, and here it has a
  specific product consequence rather than a general one.

**Score.** 4 names one flaw or attacks the metric wholesale. 6 finds the denominator and the window and
proposes fixes. 8 ranks the flaws, identifies the success condition as the deep one, spells out the
generic-question incentive, and keeps ASR under an honest name.

---

## Step 5, the product moves under it

About 9 minutes. The step the round is built around.

**Interviewer.** "Two things shipped last quarter, neither of them from your team. A new
duplicate-detection model, and the merge threshold loosened with it. And AI answers now appear on
question pages, labeled. Here's what ASR did."

> | | Before | After | Change |
> |---|---|---|---|
> | ASR, as implemented | 13.73% | 11.68% | -14.9% |

**Interviewer.** "Leadership wants to know why the asker experience got 15% worse, and there's pressure
to roll back the merge threshold. What do you think happened?"

**Listen for.**

- Asking what the two launches did mechanically before interpreting the number. Both changes remove
  questions from the population that could clear ASR's bar.
- Recognizing that a metric can fall because the product got better, and that ASR's definition makes that
  the expected result here rather than a surprise.
- Asking for a measure that does not share ASR's success condition before agreeing to any rollback.
- Refusing the rollback, and being able to say what evidence would change that.

**Mechanics.** Release when he asks what the launches did.

> | | Before | After |
> |---|---|---|
> | Person-asked questions merged | 12% (0.216M) | 19% (0.342M) |
> | Merge precision, merges landing on a question with a good existing answer | 88% | 86% |
> | Live person-asked questions | 1.584M | 1.458M |
> | Live questions with at least one human answer in 7 days | 59% | 56% |
> | Live questions where a labeled AI answer appears | 0 | 0.42M |
> | Live questions clearing ASR's bar | 22.0% | 18.0% |
> | Generated questions clearing ASR's bar | 9.5% | 9.5% |

Read. Merging removed 126,000 more questions a month from the pool, and the ones it removed were
disproportionately the easy duplicates that would have been answered well, so the remaining live pool is
harder. AI answers reach 0.42M questions and take some of the human answering with them, and an AI answer
rarely collects two upvotes. Every one of those is a reason ASR falls that has nothing to do with askers
being worse off.

**Three readings of the same quarter.** Release the second row when he asks what happens if the
denominator is fixed, and the third when he asks for a measure independent of ASR's success condition.

> | Measure | Before | After | Change |
> |---|---|---|---|
> | ASR, as implemented | 13.73% | 11.68% | -14.9% |
> | ASR with the denominator fixed and merges counted as successes | 31.36% | 33.58% | +7.1% |
> | Rated sample, did the asker get something usable | 42.2% | 52.6% | +24.6% |

Rated-sample composition, per month, out of 1.80M person-asked questions:

> | Success path | Before | After |
> |---|---|---|
> | Merged onto a question with a good existing answer | 0.190M | 0.294M |
> | Substantive human answer the asker could use | 0.570M | 0.498M |
> | Labeled AI answer the asker could use | 0 | 0.155M |
> | **Total** | **0.760M** | **0.947M** |

Read. The asker experience improved about 25%. Human answering did get worse, down from 0.570M to
0.498M, and that is a real cost worth naming. It was more than covered by two paths ASR cannot see:
faster routing to answers that already existed, and AI answers that resolved questions which previously
got nothing at all.

**The point about the middle row.** Fixing the denominator flips the sign and still understates the change
by two thirds. That is the lesson. The denominator was the loudest error and not the largest one. The
largest was that ASR defines asker success as a human answer readers upvote, and two of the three ways
askers now succeed do not involve one.

**Guardrail that did move.** Release if he asks what the merge change cost.

> Merge precision fell from 88% to 86%, so about 48,000 questions a month are now merged onto a question
> without a good answer, up from about 26,000. Those askers are worse off than before, and the rated
> sample counts them as failures.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "So we should roll back the merge threshold?" | No. Merging is now the largest single source of asker success and it grew by 104,000 satisfied askers a month. What I'd fix is precision, which slipped two points and is costing about 22,000 askers a month. That is a threshold and model quality question, not a reason to merge less |
| "The rated sample is the only thing that says we improved. Why should I believe it over three years of ASR?" | Because it is the only one of the three defined without assuming how askers succeed. ASR encodes an assumption that stopped being true last quarter. And you shouldn't take it on faith: the sample is auditable, so read a hundred of the merged cases yourself |
| "Human answers per satisfied asker went down. Isn't that bad for the writer ecosystem?" | It is the thing I'd watch hardest. Askers are better off and writers wrote less, which is fine this quarter and corrosive if it runs for a year, because the existing answers the merge path depends on were written by people who need a reason to keep writing. It belongs in the supply metric, not in this one |
| "What if the AI answers are wrong?" | Then the rated sample is where it shows up, because raters judge the answer and logs cannot. That is the main argument for having it at all, and I'd oversample AI-answered questions for exactly this reason |

**Model answer.** "ASR fell because the product changed in two ways its definition cannot represent, and
I would not roll anything back on this evidence. Both launches take questions out of the only population
that can clear ASR's bar. Merging moved 126,000 more questions a month off their own pages, and it
removed the easy duplicates first, so what's left is harder. AI answers now appear on 0.42M questions,
rarely collect two upvotes, and displace some human answering. So the expected result of two genuine
improvements, under this definition, is exactly the decline we're looking at. On the rated sample the
asker experience went from 42% to 53%. Merge successes rose from 190,000 to 294,000 a month and AI
answers resolved 155,000 questions that previously got nothing. Human answering really did fall, from
570,000 to 498,000, and that's the one cost I'd take seriously, though it belongs in a writer supply
metric rather than this one. The thing worth fixing from last quarter isn't the threshold, it's
precision, which slipped from 88% to 86% and is costing roughly 22,000 askers a month who now get merged
onto a question with no good answer. And I'd note that fixing ASR's denominator, which is the criticism
everyone reaches for first, gets the direction right and still understates the improvement by two
thirds. The denominator was the loud error. The success condition was the big one."

**Traps.**

- Accepting the 15% decline and looking for what broke.
- Agreeing to the rollback, or hedging on it. This loop scores for reaching a decision.
- Finding the denominator problem and treating that as the answer.
- Declaring total victory. Human answering fell and merge precision slipped, and a candidate who does
  not name both is reading selectively.
- Assuming the AI answers are good because the rated sample went up. The sample says askers found them
  usable, which is not the same as correct, and that distinction is worth saying out loud.

**Score.** 4 accepts the decline or agrees to the rollback. 6 identifies that both launches mechanically
depress ASR and asks for an independent measure. 8 also refuses the rollback with a reason, names the
precision slip and the human answering decline as the real costs, and says why fixing the denominator is
not the fix.

---

## Step 6, what you tell the team

About 4 minutes.

**Interviewer.** "Give me the version I can take into the asker-team review tomorrow."

**Listen for.** A verdict in the first sentence. Then at most three changes, each with a reason. Then the
one thing that prevents a repeat.

**Model answer.** "Headline: the asker experience improved about 25% last quarter and our metric reported
a 15% decline, so the metric is now an obstacle to the right roadmap and there's a rollback being
discussed on the strength of it. Three changes. Rename ASR to what it measures, reader value on answers,
and keep it, because it's a real signal under a wrong label. Stand up an asker metric on person-asked
questions only, counting all three ways an asker can succeed, which are a merge onto good existing
content, a substantive human answer, and a labeled AI answer, reported by question type at 48 hours and
30 days. Anchor it to a rated sample of a few thousand questions a month, because last quarter is the
proof that a logged success condition goes stale when the product changes and nothing in the logs tells
you it happened. Two things I'd fix that aren't metric changes: merge precision is down two points and
costing about 22,000 askers a month, and human answering fell 13% on live questions, which is fine for a
quarter and a problem if it runs, so it needs to sit in the writer supply metric with its own target.
The standing rule I'd ask for is that any metric a team is held to gets re-validated against a rated
sample when a system upstream of it ships. Both launches last quarter came from other teams and neither
triggered a review of a metric they broke."

**What pushes it to an 8.**

- The standing rule stated as a process, not a one-off. A metric gets re-validated when an upstream system
  changes. That is the "frameworks that make the whole company smarter about data" 20% of the job, and it
  is the generalizable lesson from the quarter.
- Naming the organizational fact plainly. The rollback pressure is the real damage, not the wrong number.
- Not proposing a composite. Three success paths reported separately beats one weighted score, and saying
  why is the "rigor that knows when to stop" criterion.

**Traps.**

- Leading with the method or the rated sample instead of the verdict.
- A new weighted composite.
- Forgetting the rollback, which is the decision actually on the table.
- Claiming ASR should be deleted.

**Score.** 4 gives a metric proposal with no verdict. 6 gives the verdict and a replacement metric. 8 adds
the costs he is not hiding, the standing re-validation rule, and kills the rollback explicitly.

---

## Step 7, your questions

About 3 minutes. Not scored.

- "How much of question volume is generated now, and who owns whether that number goes up or down?"
- "When a system from another team changes what a metric means, how does that surface here today?"
- "Does the team have a rated or surveyed source of truth for answer quality, or is it all logged?"
- "What's the current view internally on whether AI answers help askers or cost you writers?"

---

## Scorecard

Same criteria as case 01, so scores are comparable across the folder.

| Criterion | Score | Evidence |
|---|---|---|
| Metric design, Step 3 | | |
| Metric evaluation, Steps 3 and 4 | | |
| Diagnosing a broken metric, Step 5 | | |
| Accountability and incentives, Steps 4 and 6 | | |
| Product intuition, Step 2 | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Metric design | Could apply to any app, or no choice made | Defensible primary tied to the surface, with secondaries and guardrails | Names the measurement constraint first, designs inside it, says what the metric cannot see |
| Metric evaluation | Defends a metric when challenged | Names real failure modes when asked | Breaks it before being asked and ranks failures by how likely each is to mislead a decision |
| Diagnosing a broken metric | Accepts the trend, or guesses without data | Decomposes into mix and rate, asks for the right cut | Asks for the mechanism first, predicts each cut, separates a definition failure from a product failure |
| Accountability and incentives | No view on how teams respond | Notes Goodhart in general terms | Says what a team held to the metric ships, and designs the fix to remove that incentive |
| Product intuition | Generic engagement talk | Ties choices to Quora's actual loop | Reasons about the user before the measurement, and gets there without prompting |
| Communication and pragmatism | Method before answer, over-engineers | Verdict first most of the time | Verdict first every time, simple before rigorous, names when more precision would not change the call |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific check, recorded separately.** Did he name a metric during Step 2 before being allowed to?
Yes or no. This is the cleanest read in the folder on whether the over-engineering reflex is fixed.

| Step | Target | Actual |
|---|---|---|
| 1. Warm-up | 3 min | |
| 2. The area, no metrics allowed | 8 min | |
| 3. Design the metric | 10 min | |
| 4. The team's metric | 8 min | |
| 5. The product moves under it | 9 min | |
| 6. What you tell the team | 4 min | |

Top three fixes for the next mock.

1.
2.
3.
