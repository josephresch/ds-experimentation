# Case 04, why are our best writers leaving

A mock interview for the **Data Stats** round. 45 minutes, talked through, no coding. Claude plays a
Quora data scientist. To practice blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. Writer concentration matches
`../private/product.md` and `../data-practical/01_answer-request-routing.md`.

**Dominant flavor: statistical models.** The guide gives this round's modeling portion an unusually
specific instruction: "The emphasis on the modeling portion is not on coming up with fancy models, but on
being able to formulate a well-defined model, clearly understand the assumptions behind it and how those
assumptions affect the final conclusions, and interpret it for both prediction and statistical inference."
This case is that sentence, end to end. It is also the case where the honest answer is that the question as
asked cannot be answered at this sample size, and where a smaller answerable question has to be offered in
its place.

**Why it is product sense forward.** The population is roughly 1,650 people. At that scale the question
"what makes a writer stop writing" is a question about human motivation that a feature-importance table
cannot answer, and knowing that is the point. A candidate who treats it as a modeling exercise will produce
a model that cannot be fit. A candidate who starts from why a person writes on Quora at all will get to the
right reframe and the right recommendation, which is to go and ask them.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide, Data Stats | "Not on coming up with fancy models, but on being able to formulate a well-defined model" | Block 2 |
| Prep guide, Data Stats | "Clearly understand the assumptions behind it and how those assumptions affect the final conclusions" | Block 3, where the assumption that breaks is that the model is identified at all |
| Prep guide, Data Stats | "Interpret it for both prediction and statistical inference" | Block 4. The two questions need different reframes and only one survives |
| Prep guide, how to prepare | "Practice stating the assumptions behind a model out loud, and what breaks if each one fails" | The whole case |
| Prep guide, current focus | "Stabilizing and improving key engagement metrics" | Answer supply is the metric behind the premise |
| `../private/product.md` | Writers are about 2% of users a month, the top 1% write about half of all answers, writer departures are a live tension | The premise and the population |
| Email | "How you decide on the best course of action when there's more than one reasonable path" | Block 4, where prediction and inference diverge |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. Framing and the product read | 7 | Framing, product intuition |
| 2. Formulate the model | 11 | Model formulation |
| 3. Is it identified | 11 | Assumptions and their consequences |
| 4. Prediction against inference | 11 | Interpreting for both |
| 5. Your questions | 5 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **Do not volunteer the event count.** The whole case turns on whether he asks how many churn events there
  are before or after specifying a model. Note which.
- If he names a method, ask what has to be true for it to work. Once per block.
- **Do not accept "I'd add regularization" as an answer to an identification problem.** Ask what it buys and
  what it costs for inference specifically.
- Let silence sit.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard.

---

## Block 1, framing and the product read

About 7 minutes.

**Interviewer.** "Answer volume has been drifting down for a couple of years and the thing that worries
leadership most is the top of the writer distribution. Here's the brief."

> ### Context
>
> **Who writes.** About 2% of logged-in users write an answer in a given month. Of all answers written, about
> half come from the top 1% of writers. Losing one of those writers is not like losing a reader.
>
> **The cohort in question.** The team defines its core writer cohort as the top 1% by answers written in the
> last 90 days, which is **1,650 people**.
>
> **The ask, as it arrived.** "Build a model of writer churn for the core cohort so we can predict who is at
> risk and understand what causes it. We have about 40 candidate features: tenure, answer volume, upvotes
> received, upvote rate, answer requests received and answered, follower count and growth, comment activity,
> topic concentration, whether they hold a moderator or Space-owner role, Quora+ earnings, notification
> volume, session frequency, device mix, and so on."
>
> **The ask, restated by leadership in the same meeting.** "Mainly we want to know if it's the answer request
> changes that are driving people away."

**Interviewer.** "Before you tell me about the model. What do you make of this?"

**Listen for.**

- **Two different questions have been asked and only one of them is a model.** Predicting who is at risk so
  you can intervene is a ranking problem. Finding out whether the answer request changes caused departures is
  a causal question about one specific factor. They need different things and conflating them is the error the
  rest of the case is built on.
- **Asking how many people actually left.** 1,650 is a small population and churn is the outcome, so the
  number of events is the binding constraint on everything. A candidate who specifies a model before asking
  how many events exist has told me something.
- **What "churn" even means for a writer.** A person who wrote 40 answers last quarter and 3 this quarter has
  not churned by a zero-answers definition and has churned in every way that matters to answer supply. The
  outcome definition is a modeling choice that will determine the answer, and it should be made deliberately
  rather than inherited.
- **Why people write on Quora at all.** Audience, being asked, status and followers, sometimes earnings. Those
  are the mechanisms, and a feature list of 40 columns is a proxy for them at best. Saying that early is the
  product-sense move that earns the reframe later.
- **The selection in the cohort definition.** Top 1% by the last 90 days is defined on the outcome window's
  doorstep. Someone who was winding down already ranks lower and may not be in the cohort, so the cohort
  is conditioned on recent activity and will show regression to the mean regardless of anything the product did.

**Strong signals.**

- Getting to the two-questions split unprompted and saying which one leadership actually cares about. The
  restatement in the room ("is it the answer request changes") is the real question and the 40-feature model is
  the thing someone asked for on the way to it.
- Naming the regression-to-the-mean problem in the cohort definition. It is the subtlest thing in the block and
  it will contaminate any naive before-and-after comparison.
- Asking whether anybody has talked to writers who left. At n = 1,650 with a handful of events, twenty
  interviews is a larger sample of the phenomenon than the model will have events, and saying so is not a dodge.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "They asked for a model. Why are you relitigating the question?" | Because the two things they asked for in the same meeting need different work, and if I build the 40-feature model I'll answer neither well. The prediction version is doable and the causal version probably isn't at this size, and it's better to say that now than in six weeks |
| "How would you define churn?" | I'd want a volume-based definition rather than a zero-based one, something like a drop below a fraction of their own prior rate sustained over two months, because a top writer going from 40 answers to 3 is the event we care about and a zero definition misses it. I'd also check how much the answer changes between definitions, because if it does, that's the headline |
| "Isn't talking to twenty writers anecdotal?" | It's a small sample of a phenomenon we have very few instances of either way. If the model has 58 events and 40 features, the interviews aren't the soft option, they're the larger sample. I'd do both and use the interviews to pick which five features are worth modeling |

**Model answer.** "Two questions got asked and I'd separate them before anything else. One is predict who's at
risk, which is a ranking problem where I need the ordering to be useful and I don't need any coefficient to
mean anything. The other is did the answer request changes cause people to leave, which is a causal question
about one factor, and the restatement in the room tells me that's what leadership actually wants. Those need
different work. Then the question I'd want answered before I specify anything: how many people in this cohort
actually left in the window? 1,650 people is small and churn is rare among your best writers almost by
definition, so the event count is going to bind everything. I'd also want to fix the outcome definition
deliberately. A top writer dropping from 40 answers a quarter to 3 hasn't churned on a zero-answer definition
and has churned in every way that matters to supply, so I'd use a volume-drop definition and check whether the
conclusion changes when I move it. One more thing about the cohort: it's the top 1% by the last 90 days, so
it's conditioned on recent activity. Anyone already winding down has fallen out of it, and whoever's in it will
drift down next quarter through regression to the mean whatever we do. Any before-and-after on this cohort will
show decline for that reason alone."

**Traps.**

- Specifying a model. Anything from "I'd fit a logistic regression" onward before asking about event counts.
- Accepting the 40 features as a feature set rather than as a wish list.
- Accepting a zero-answers churn definition.
- Treating the two asks as one.

**Score.** 4 starts specifying a model or a feature-selection procedure. 6 separates prediction from causation
and asks about the event count. 8 also interrogates the churn definition, names the regression-to-the-mean
problem in the cohort, and reasons about why people write before reasoning about features.

---

## Block 2, formulate the model

About 11 minutes.

**Interviewer.** "Take the prediction version. Write me the model."

**Release on request.**

> | Quantity | Value |
> |---|---|
> | Cohort | 1,650 writers |
> | Churn events in the last quarter, on a volume-drop definition | **58** |
> | Churn events over the last four quarters, same definition | 232 |
> | Candidate features | 40 |
> | Share of the cohort holding a moderator or Space-owner role | 8% |

**Listen for.**

- **A clean, small specification, stated with its unit of observation.** One row per writer per quarter, or one
  row per writer with a fixed window. Logistic regression on a handful of pre-window predictors is the right
  answer and saying so plainly is better than reaching for something with a name.
- **Discrete-time survival as the better frame, offered simply.** One row per writer-month with a churn
  indicator, which handles the fact that people leave at different times and that recent entrants are censored.
  It is a logistic regression on person-period data, so it is not a fancier model, it is the same model on a
  better-shaped table. A candidate who explains it that way has understood something. A candidate who says
  "Cox proportional hazards" and stops has named a thing.
- **Time-varying predictors need care.** Answer requests received is measured over time and is plausibly
  affected by the writer winding down, so using its contemporaneous value predicts churn with a symptom of
  churn. Everything on the right-hand side has to be lagged to before the window in which churn is measured.
- **The features that would matter, chosen from mechanism rather than from a list.** Being asked (request volume
  and answered share), audience (views and upvotes per answer, follower growth), and reciprocity (comments and
  upvotes received on recent answers). Three or four constructs, not forty columns.

**Strong signals.**

- Doing the events-per-variable arithmetic out loud the moment the 58 lands. At the usual rule of ten events per
  predictor, 58 events supports about five predictors. Forty is not a candidate set, it is a guarantee of an
  overfit model with uninterpretable coefficients.
- Choosing to pool quarters to get to 232 events, and immediately naming the cost: the same writer appears in
  several rows so the observations are not independent and the standard errors need clustering by writer, and
  pooling across quarters assumes the churn process is stable across a period in which the product changed.
- Saying what he would do about the 40 features rather than running a selection procedure on them. Group them
  into constructs by hand and pick one indicator per construct. Stepwise selection on 40 features with 58 events
  will produce a model, and the model's coefficients and p-values will be meaningless.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Why not use all 40 and regularize?" | Regularization would give me a usable predictor and it would cost me the thing leadership asked for. Lasso coefficients are shrunk and selected, so they aren't interpretable as effects, and with correlated features the selection is close to arbitrary. If the deliverable is a ranking, regularize. If the deliverable is "does answer requests matter," regularization is the wrong tool and 58 events is the wrong sample |
| "Why lag everything? Recent activity is the most predictive." | Because it's predictive by being the same thing as the outcome. If someone's request volume fell because they stopped engaging, I've built a model that detects churn using churn. For a ranking that might still be operationally useful, and for a causal claim it's fatal, and I'd want the two versions to be clearly different models |
| "Cox or discrete-time?" | Discrete time, and mostly for practical reasons: the data is monthly, ties are everywhere, and person-period logistic regression handles time-varying predictors without any additional machinery. It's the same likelihood family, shaped for how the data actually arrives |
| "Do you need a model at all for the ranking?" | Possibly not. A short scorecard on three lagged signals might rank nearly as well as anything fitted, and it would be explainable to the people doing the outreach. I'd check that baseline first and only fit something if it clearly beats it |

**Model answer.** "One row per writer-month, churn indicator as the outcome, discrete-time survival which in
practice is a logistic regression on person-period data. That handles people leaving at different times and
handles censoring for anyone who joined the cohort recently, without needing anything exotic. Every predictor
lagged to before the month I'm predicting, because things like answer requests received move with the writer
winding down, and if I use the contemporaneous value I'm predicting churn from a symptom of churn. On features:
58 events is the number that matters. At ten events per predictor that supports about five, so forty isn't a
candidate set. I'd group them by mechanism instead of selecting statistically: being asked, which is request
volume and the share answered; audience, which is views and upvotes per answer and follower growth; and
reciprocity, which is comments and upvotes on recent answers. One indicator each, plus tenure and baseline
volume as controls, and that's already at the limit. I'd pool four quarters to get to 232 events, cluster the
standard errors by writer since the same person appears repeatedly, and flag that pooling assumes the churn
process was stable across a period when we changed the product, which it probably wasn't. And before fitting
anything I'd check whether a three-signal scorecard ranks nearly as well, because if it does that's what the
outreach team should actually get."

**Traps.**

- Forty features, or a stepwise selection on them.
- No lagging.
- Naming Cox proportional hazards without saying why, or treating survival analysis as necessarily fancier.
- Not doing the events-per-variable arithmetic.
- Pooling quarters without mentioning clustering or stability.

**Score.** 4 fits a model on the full feature set, or selects features statistically. 6 gives a small clean
specification with lagged predictors. 8 also does the events-per-variable arithmetic unprompted, groups features
by mechanism, and offers the unfitted baseline as a serious option.

---

## Block 3, is it identified

About 11 minutes. The heart of the case.

**Interviewer.** "Now the other question. Leadership wants to know whether the answer request changes drove
people away. Same data. Can you answer that?"

**Listen for.**

- **A direct answer: no, not to the precision the question implies, and here is the arithmetic.** With 1,650
  writers and 58 quarterly events, the standard error on a log odds ratio for a predictor split evenly across
  the cohort is about 0.27. That puts the 95% interval on the odds ratio at roughly 0.59 to 1.69. So the study
  can detect a factor that nearly doubles the odds of churning and is blind to anything smaller. Most real
  product effects are smaller than that.
- **The prevalence problem, which is worse.** Moderator or Space-owner status is held by 8% of the cohort, so it
  carries about five events. The standard error there is about 0.49 and the interval on the odds ratio runs from
  0.38 to 2.63. That predictor cannot be studied at all in this data, and it is exactly the kind leadership will
  ask about.
- **What widening the window buys, and what it costs.** Four quarters gives 232 events and tightens the
  detectable odds ratio to roughly outside 0.76 to 1.32, which is a real improvement. Three years would give
  about 700 events and get to roughly 0.82 to 1.22. But a three-year window on a 1,650-person cohort means a
  large fraction of the cohort churns during it, the cohort composition changes, and "churn" in 2023 and in 2026
  are not the same event in the same product. So precision is bought with relevance and the trade has to be
  named, not assumed away.
- **The identification problem, separate from the power problem.** Even with unlimited events, answer request
  volume was not randomly assigned. It is set by a routing model that targets writers likely to answer, so
  request volume is a function of predicted engagement, which is a function of the same things that predict
  churn. Conditioning on observed features does not fix that, because the routing model uses features too and
  there is no variation in request volume left within a cell of them. That is the same overlap argument as in
  case 01, in a different costume.

**Strong signals.**

- **Separating the two failures cleanly.** Not enough events is a precision problem. Non-random assignment of
  request volume is an identification problem. They have different fixes and a candidate who collapses them into
  "we need more data" has missed that more data fixes only one.
- **Finding the design that does exist.** The routing change itself was shipped, presumably at a time or to a
  subset. If it rolled out in stages, that is a natural experiment with writers as units. Better still,
  `../data-practical/01_answer-request-routing.md` describes a randomized routing experiment on this exact
  population, so the causal question may already have an answer from a properly randomized test, and the right
  move is to go find it rather than to model observational data.
- Saying what the model can honestly contribute to the causal question: nothing decisive, and it can generate the
  hypothesis worth testing.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "So the answer is 'we can't know'? That's not useful." | The useful version is narrower. We can't detect anything short of roughly a doubling of churn odds from this data, and we can't separate the effect of request volume from the reasons the router chose to send it. What we can do is look for a randomized or staged rollout of the routing change, because if one exists it answers the question properly, and if it doesn't, the answer is to run one on a slice going forward |
| "Could you match writers on observables?" | Matching would make the two groups look alike on the features I can see, and the router chose request volume using features too, so within a matched cell there's very little variation in request volume left to exploit. Matching manufactures comparability it can't verify, and here it would produce a confident number I couldn't defend |
| "What if you widen to three years?" | That gets me to about 700 events and a detectable odds ratio outside roughly 0.82 to 1.22, which is genuinely better precision. It also means most of the original cohort has turned over and I'm pooling across three different versions of the product, so I'd be estimating an average effect over a period nobody is asking about. I'd take one extra year, not three |
| "Add regularization and report the coefficient on request volume." | That gives me a shrunk coefficient with no valid interval, on a variable that wasn't randomly assigned. It would look like an answer and it would be one of the more misleading things I could hand leadership |

**Model answer.** "Two separate problems and they have different fixes. The first is precision. With 58 events
in 1,650 writers, the standard error on a log odds ratio for an evenly split predictor is about 0.27, so the
interval on the odds ratio runs from about 0.59 to 1.69. I can detect a factor that nearly doubles churn odds
and nothing smaller, and most product effects are smaller. For something like moderator status, held by 8% of
the cohort and carrying about five events, the interval runs 0.38 to 2.63, which is no information at all.
Pooling four quarters gets me to 232 events and tightens it to roughly outside 0.76 to 1.32, which is a real
gain, and going to three years buys less than you'd think because the cohort turns over and I'd be averaging
across three different products. The second problem is bigger and more data won't touch it. Request volume
wasn't randomly assigned. A routing model chose it, targeting writers it predicted would answer, so request
volume is a function of predicted engagement, which is built from the same things that predict whether someone
keeps writing. Conditioning on observed features doesn't rescue that, because the router used features too, so
there's essentially no variation in request volume left within a cell of them. That's an overlap failure, not a
sample size failure. So what I'd actually do is go find out whether the routing change was rolled out in stages
or tested, because a randomized or staged rollout answers this properly and I believe one exists. If it does,
the observational model is beside the point. If it doesn't, the recommendation is to randomize the next routing
change on a slice of writers, and in the meantime tell leadership we have a hypothesis rather than a finding."

**Traps.**

- Collapsing power and identification into "more data."
- Matching or propensity scores as the fix.
- Reporting a coefficient with a caveat attached. The caveat does not survive the trip to the meeting.
- Not looking for the randomized evidence that already exists.

**Score.** 4 fits the model and reports the coefficient. 6 identifies the power problem with arithmetic.
8 separates power from identification, gets both the common and the rare predictor arithmetic, names the cost of
widening the window, and goes looking for the randomized rollout.

---

## Block 4, prediction against inference

About 11 minutes.

**Interviewer.** "Last thing. You said the prediction version is doable and the causal version mostly isn't.
Walk me through what that means for what you'd actually deliver."

**Listen for.**

- **Different success criteria, named as different.** The prediction model is judged out of sample, on whether the
  ranking puts the people who left near the top. Precision at the top of the list is the operationally relevant
  measure, because the outreach team can only contact so many people. The causal question is judged on whether
  the assumption behind the estimate is credible, and no amount of held-out data speaks to that.
- **The specification diverges, and in the direction opposite to case 01's.** For the ranking, contemporaneous
  and short-lag features are allowed and helpful, because a writer whose activity is already sliding is exactly
  who you want flagged, and it does not matter that the signal is a symptom rather than a cause. For the causal
  question those same features are disqualifying. So the better predictor is the worse explanation, by
  construction.
- **What each deliverable is actually for.** The ranking feeds an intervention: someone reaches out to the top
  fifty at-risk writers. That has a testable value, namely whether outreach to a flagged writer changes anything,
  and that is randomizable even though churn causes are not. The causal question feeds a roadmap decision, and
  with this data it cannot.
- **The honest package.** A short scorecard that ranks the cohort, delivered with an explicit statement that its
  inputs are symptoms and not causes; plus a recommendation to randomize the outreach so the intervention gets
  evaluated even though the cause does not.

**Strong signals.**

- **Noticing that the intervention is randomizable even when the cause is not.** You cannot randomize why writers
  leave. You can randomize who gets contacted among the flagged. So the prediction model, which cannot answer the
  causal question, can still generate a randomized experiment about something the team controls. That is the best
  move available in this case and it is the one that turns a disappointing answer into a plan.
- Pointing out that a good risk model makes the causal question harder to answer politically, because once
  everyone can see a list of at-risk writers, the team will intervene on them, and future observational data is
  contaminated by the interventions. Saying that before it happens is a real contribution.
- Refusing to deliver the coefficient table alongside the ranking, on the grounds that anyone who receives both
  will read the coefficients as causes regardless of what the caveat says.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Can I have the feature importances? People will ask." | I'd rather not hand them over, and I'd say why rather than just refusing. The model is built from symptoms and lagged correlates, so the importances say which signals precede churn, not which things cause it. If they go in a deck they'll be read as causes, and the caveat won't travel with the slide. What I'd give instead is the three signals the outreach team should look at, described as warning signs |
| "How would you know the risk model is any good?" | Out of sample, and specifically precision in the top decile, because outreach capacity is the constraint. If we can contact fifty writers a month, the only thing I care about is how many of the fifty were genuinely at risk. Overall AUC would be the wrong headline |
| "Isn't randomizing the outreach cruel? We'd withhold help." | It's a real cost and it's smaller than it looks, because we don't know that the outreach helps, and if it doesn't we'd be spending a team's time on it indefinitely. I'd randomize among the flagged, keep the control small, and stop the test as soon as there's a clear effect either way |
| "What do you tell leadership about the answer request question?" | That we have a hypothesis and not a finding, that the observational data can't separate it from how the router chose who to ask, and that the thing that would answer it is a randomized routing change, which I believe we may already have run. And I'd chase that before building anything |

**Model answer.** "They're different deliverables judged in different currencies. The risk model gets judged out
of sample on precision in the top decile, because outreach capacity is the binding constraint and I only care
whether the fifty people we contact were genuinely at risk. The causal question gets judged on whether its
identifying assumption is believable, and there's no held-out sample that can tell me that. The specifications
also diverge, and in the opposite direction from what people expect. For ranking, I want the recent
activity-slide signals in, because someone whose volume is already falling is exactly who I want flagged, and it
doesn't matter that the signal is a symptom. For the causal version those same features are disqualifying. So
the better predictor is the worse explanation, and I'd build them as two things rather than one thing with
caveats. What I'd actually deliver is a short scorecard on three lagged signals, labeled as warning signs rather
than causes, and I'd decline to hand over feature importances, because they'll get read as causes whatever the
caveat says. Then the part I think matters most: we can't randomize why writers leave, but we can randomize who
gets contacted among the ones we flag. So the risk model, which can't answer the causal question, can still
produce a clean experiment about the one thing we control. I'd set that up, and I'd flag now that once a risk
list exists people will act on it, which means future observational data on writer churn is contaminated from
that day forward."

**Traps.**

- Claiming one model serves both.
- Delivering feature importances as an explanation.
- AUC as the headline for an intervention with capacity constraints.
- Missing that the intervention is randomizable.

**Score.** 4 treats prediction and inference as one deliverable. 6 separates them and names different success
criteria. 8 also explains why the better predictor is the worse explanation, proposes randomizing the outreach,
and warns that acting on the list contaminates future observational data.

---

## Block 5, your questions

About 5 minutes. Not scored.

- "Was the answer request routing change rolled out in stages, or tested on a subset of writers?"
- "How does the team define writer churn today, and has that definition been revisited?"
- "Has anyone interviewed writers who stopped? At this cohort size that might be the larger sample"
- "When a model here can't answer the question that was asked, how does that usually land?"

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| Framing an open-ended question | | |
| Model formulation | | |
| Assumptions and their consequences | | |
| Prediction against inference | | |
| Product intuition | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Framing | Specifies a model before asking about event counts | Separates prediction from causation, asks about events | Also interrogates the churn definition and names the regression to the mean in the cohort |
| Model formulation | Forty features, or statistical selection | Small specification, lagged predictors, person-period data | Events-per-variable arithmetic unprompted, features grouped by mechanism, unfitted baseline offered seriously |
| Assumptions | Reports a coefficient with a caveat | Identifies the power problem | Separates power from identification, gets the rare-predictor arithmetic, names the cost of widening the window |
| Prediction against inference | One model for both | Different criteria named | Explains why the better predictor is the worse explanation, and randomizes the intervention |
| Product intuition | Treats it as a feature-importance problem | Reasons about why people write | Concludes that at n = 1,650 talking to writers is the larger sample, and says so without it reading as a dodge |
| Communication | Hands over a coefficient table | Verdict clear | Declines to deliver importances, with a reason, and reframes a disappointing answer into a plan |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he ask for the event count before or after specifying a model?
- Did he do the events-per-variable arithmetic himself?
- Did he separate the power problem from the identification problem, or merge them into "more data"?
- Did he find the randomizable intervention?

| Block | Target | Actual |
|---|---|---|
| 1. Framing | 7 min | |
| 2. Formulate | 11 min | |
| 3. Is it identified | 11 min | |
| 4. Prediction against inference | 11 min | |

Top three fixes for the next mock.

1.
2.
3.
