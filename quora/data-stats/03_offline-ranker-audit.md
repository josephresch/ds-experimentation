# Case 03, can we trust the offline evaluation of a new feed ranker

A mock interview for the **Data Stats** round. 45 minutes, talked through, no coding. Claude plays a
Quora data scientist. To practice blind, stop reading after the context in Block 1.

All numbers are synthetic and were computed by script. Feed scale matches `../private/product.md` and
case 01 of the first-round set.

**Dominant flavor: offline against online evaluation, which is a causal problem wearing an engineering
costume.** The guide lists "deep audits of ML systems" as a current team focus, the FAQ says the job is to
"evaluate systems, including recommenders, rather than train and ship them," and the posting names
recommender evaluation in offline and online settings as a preferred qualification. This is the case for
that.

**Why it is product sense forward.** The feed's job is to show a reader things worth their time. A ranker
that helps can only do so by showing things the current one does not show. But offline evaluation scores a
candidate against logged outcomes, and the only items with logged outcomes are the ones the current ranker
chose to show. So the offline metric structurally rewards agreeing with the incumbent and punishes exactly
the behavior that would help. A candidate who sees that has the case. A candidate who reaches for a better
estimator without seeing it does not.

**Known overlap.** Case 01 of the first-round set (`../01-feed-ranking.md`, `../private/01_home-feed-ranking.md`)
also opens with a ranker that looks good offline and disappoints online. That case is about designing and
reading the online A/B test. This one never runs a test: it is about whether the offline number meant
anything in the first place, and what would have to be true for it to. Stated rather than papered over.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide, current focus | "Deep audits of ML systems" | The premise |
| Prep guide, FAQ | "You'd evaluate systems, including recommenders, rather than train and ship them" | The role Joseph is playing in the scenario |
| Posting | Evaluating recommenders "in offline and online settings" as a plus | Blocks 2 and 3 |
| Prep guide, Data Stats | "Non-standard experiment designs and setups" | Block 4. The fix is a design, not an estimator |
| Prep guide, Data Stats | "How those assumptions affect the final conclusions" | Block 3 is that sentence in one concrete instance |
| Email | "Which techniques you'd reach for, the assumptions behind them" | Block 3's follow-ups push on exactly this |
| Recruiter call | "Offline and online experiments" named explicitly | The whole case |

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. What the offline number is measuring | 6 | Framing, product intuition |
| 2. Why it can be wrong | 12 | Identification, assumptions |
| 3. What offline evidence can license | 10 | Assumptions and conclusions |
| 4. How you would fix it | 12 | Non-standard design |
| 5. Your questions | 5 | Not scored |

## How Claude runs it

- Stay in character. No teaching or grading until the end.
- **Release the coverage numbers only when asked.** They are the crux, and whether he asks for something
  like them is most of the assessment. A vague request gets "What would you want to see, and what would
  each way it could come out tell you?"
- If he names an estimator (inverse propensity weighting, doubly robust) before establishing why the naive
  replay is biased, ask "what problem is that solving?" once. Getting the mechanism before the machinery is
  the scored order.
- Don't lead. Do not hint that the offline number is wrong.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard.

---

## Block 1, what the offline number is measuring

About 6 minutes.

**Interviewer.** "The ranking team wants to ship a new feed model. They have offline results and they'd like
to skip the A/B test because the last three were slow and inconclusive. My job is to say whether the offline
evidence is enough. Here's what they sent."

> ### Context
>
> **The feed.** The logged-in home feed is one ranked list. For each candidate story a set of models predicts
> how likely this reader is to expand it, upvote it, share it, comment on it, downvote it or mute its source.
> Those predictions are combined into one score and the top stories are shown. About 8.0M logged-in users load
> the feed in a 14-day window.
>
> **The candidate.** Ranker C, a replacement for the prediction layer. The scoring function is unchanged.
>
> **The offline evaluation.** Last month's logged sessions were replayed. For each session, the candidate
> re-ranked the same candidate pool, and the resulting top 10 was scored against what the reader actually did.
> A story counts as relevant if the reader expanded or upvoted it.
>
> | Offline result | Current | Ranker C |
> |---|---|---|
> | Replay ranking quality, NDCG@10 | 0.412 | 0.436, +5.8% |
> | Predicting expands, AUC | 0.742 | 0.780 |
> | Predicting upvotes, AUC | 0.768 | 0.786 |
>
> **The ask.** The team reads +5.8% as a launch. Is the offline evidence enough, and if not, what would be?

**Interviewer.** "Take a minute. What is that 5.8% actually measuring?"

**Listen for.**

- **The mechanism of a replay, stated plainly.** The candidate is scored on how well the ordering it produces
  agrees with outcomes that were observed. Outcomes were only observed for stories the current ranker chose to
  show and the reader then saw. So the replay is scoring the candidate on a set of items the incumbent selected.
- **The product consequence, which is the case.** A ranker can only improve the feed by showing things the
  current one does not show. Those are precisely the items with no logged outcome. So the metric cannot reward
  the behavior that would help, and can only reward the candidate for reordering the incumbent's own choices.
- Asking what happens to a story the candidate ranks highly that was never shown. There are two possible
  answers and both are bad: the replay treats it as not relevant, which penalizes originality, or it drops it,
  which silently changes the denominator and inflates agreement.
- **Selection, named as selection.** This is the same structure as any observational study. Outcomes are
  observed only for the treated, and the treatment assignment was made by a policy correlated with the outcome.

**Strong signals.**

- Getting to "the offline metric partly measures similarity to the incumbent" unprompted. That is the sentence
  the whole case is built to elicit.
- Noticing that the label counts an expand the same as an upvote, and that expands are far more common, so the
  relevance definition is mostly about expands, which is the weakest evidence a reader valued something. That
  is a second, independent problem with the offline number and it is visible in the table without any extra data.
- Asking what the candidate pool was at replay time and whether it is the same pool the live system would have
  had. Candidate generation moves, and replaying a new ranker over an old pool bounds what it can do.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "AUC improved on both targets. Isn't that model-independent evidence?" | It's evidence the model predicts logged behavior better, on logged behavior. Same problem. A model can predict what people did with what they were shown better than the incumbent and still make the feed worse, because the thing we want is what they'd do with something they weren't shown |
| "The scoring function didn't change. Doesn't that isolate the model quality?" | It isolates the change, which is useful, and it doesn't help with the evaluation. Holding the scoring function fixed means a better predictor of expands moves expandable stories up, and if expands are the weakest value signal, a better predictor makes the feed more tappable and not necessarily better |
| "So is offline evaluation useless?" | No, and I'd be careful about that conclusion. It's a screen. It can tell us a candidate is worse, and it's cheap enough to run on every candidate, which an A/B test isn't. What it can't do is license a launch |

**Model answer.** "The 5.8% is telling me that on the stories our current ranker chose to show, Ranker C orders
them better with respect to what readers did. That's a real thing and it's a narrower thing than the team
thinks. The feed can only get better if we show people something we're not showing them now, and those stories
are exactly the ones with no logged outcome, so they can't contribute to the metric. Whatever the replay does
with a story the candidate likes and we never showed, either it scores it as irrelevant, which punishes the
candidate for disagreeing with us, or it drops it, which quietly changes what's being averaged. Either way the
metric is partly a measure of how much Ranker C agrees with the incumbent. That's a selection problem and it's
the same shape as any observational study: we only see outcomes where the old policy acted, and the old policy
chose where to act for reasons related to the outcome. Separately, the relevance label counts an expand the same
as an upvote and expands are far more common, so this is mostly an expand-prediction metric, and an expand is
the weakest sign a reader got anything out of a story."

**Traps.**

- Accepting the offline table and moving to design an A/B test. The question was about the offline evidence.
- Naming an off-policy estimator in the first two minutes. The mechanism has to come first.
- Criticizing NDCG as a metric on technical grounds while missing that its label set is the problem.
- Declaring offline evaluation worthless.

**Score.** 4 treats the offline result as evidence of quality, or critiques the metric without finding the
selection problem. 6 identifies that outcomes are only logged for shown items. 8 also states that the metric
therefore rewards agreement with the incumbent, and notices the expand-weighted label independently.

---

## Block 2, why it can be wrong

About 12 minutes.

**Interviewer.** "Say you're right that there's a selection problem. Show me it's material here, not just
theoretically."

**Release on request.** These are the crux of the case.

> **Coverage of Ranker C's choices against the logs.**
>
> | Quantity | Value |
> |---|---|
> | Ranker C's top-10 picks that appear anywhere in that session's logged impressions | 61% |
> | Ranker C's top-10 picks that were in the logged top 10 | 34% |
> | Replay treatment of a pick with no logged impression | Scored as not relevant |
>
> **Two other evaluations that exist.**
>
> | Evaluation | Ranker C against current |
> |---|---|
> | Replay on logged sessions, NDCG@10 | +5.8% |
> | Same metric computed on a 1% slice of traffic where the top 10 is randomly shuffled before display | -1.2% |
> | The online A/B test the team ran last quarter and dismissed as inconclusive, upvotes per user | -0.9%, CI -2.4% to +0.6% |

**Listen for.**

- **Reading 39% as the size of the problem.** Nearly two in five of the candidate's preferred stories are being
  scored as irrelevant with no evidence whatsoever, purely because the incumbent never showed them. And only a
  third of its picks were in the logged top 10, so the replay is mostly scoring it on items the incumbent
  ranked but did not feature.
- **The direction of the bias, argued rather than asserted.** Scoring unshown picks as irrelevant penalizes
  disagreement. So a candidate that differs a lot from the incumbent is penalized and a candidate that mostly
  reproduces it is rewarded. Ranker C scored well, which means it largely agrees, which is not what you want
  from a replacement.
- **The randomized slice is the tiebreaker and he should recognize why.** On 1% of traffic the displayed order
  is shuffled, so what got shown is independent of what the incumbent preferred. That restores the overlap the
  replay lacks, and on that slice Ranker C is worse. The slice and the online test agree with each other and
  disagree with the replay, which is the pattern selection bias produces.
- **Reinterpreting the "inconclusive" A/B test.** Its interval runs from -2.4% to +0.6%. That is not evidence of
  no effect. Combined with the randomized slice pointing the same way, the weight of evidence is that Ranker C
  is mildly worse, and the team dismissed the one honest signal it had.

**Strong signals.**

- Saying that the replay and the shuffled slice compute *the same metric* on *different data*, so the gap
  between +5.8% and -1.2% is an estimate of the selection bias rather than a disagreement between methods. That
  framing is the strongest thing available in this block.
- Noticing that the online test and the shuffled slice agree to within noise (-0.9% and -1.2%), which is
  exactly what you would expect if the shuffled slice is unbiased, and using that as validation of the slice
  rather than of the test.
- Asking how the shuffled slice is powered and whether 1% of traffic gives a usable estimate, rather than
  accepting -1.2% as precise.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Maybe the shuffled slice is just a worse experience, so everything looks bad on it." | Shuffling hurts absolute engagement on that slice, certainly. It shouldn't bias the comparison between two rankers evaluated on it, because both are scored against the same randomized exposure. If the team thinks it does, the way to check is whether the incumbent's own offline score on the slice tracks its live performance |
| "61% coverage sounds high. Isn't that mostly fine?" | 61% coverage means 39% of its picks are scored as failures without evidence. And the coverage we actually need is the top-10 figure, 34%, because that's where the metric's weight sits. A metric that scores two thirds of the candidate's featured choices on absent evidence isn't mostly fine |
| "The A/B test wasn't significant. Why bring it up?" | Because non-significant isn't no effect. Its interval reaches -2.4%, which on upvotes per user across the whole feed is a real loss, and it points the same way as the randomized slice. One inconclusive test is weak evidence. Two independent things pointing the same direction isn't |
| "Which number would you put in the readout?" | -1.2% from the randomized slice, as the best available estimate, with the replay's +5.8% shown next to it and labeled as what it actually measures. The gap between them is the interesting number, because it sizes how much our offline evaluation flatters candidates that agree with us |

**Model answer.** "The coverage numbers make it material. Only 61% of Ranker C's top-10 picks appear anywhere in
the logged impressions for that session, and only 34% were in the logged top 10, so somewhere between a third
and two thirds of what it wants to show is being scored on absent evidence. And the replay scores those as not
relevant, which means the metric actively penalizes a candidate for disagreeing with the incumbent. Ranker C
scored well on it, so by that logic Ranker C mostly agrees with us, which is a strange property for a
replacement. Then the shuffled slice settles it. That's the same metric computed on data where what got shown
was randomized, so the overlap problem is gone, and there Ranker C is 1.2% worse. And that agrees with the
online test the team dismissed, which was -0.9% with an interval reaching -2.4%. Two independent unbiased-ish
reads say slightly worse, one biased read says 5.8% better, and the gap between them is a measurement of how
much our offline evaluation flatters candidates that look like the incumbent. I'd also push back on calling that
A/B test inconclusive. It couldn't rule out a 2.4% loss, which isn't the same as finding nothing."

**Traps.**

- Not asking for coverage or anything like it, and arguing the selection problem only in the abstract.
- Getting the bias direction backwards, or not arguing it at all.
- Treating the +5.8% and the -1.2% as two methods disagreeing rather than one metric on two populations.
- Accepting "inconclusive" for the A/B test.

**Score.** 4 argues the problem only theoretically. 6 asks for coverage and reads it correctly. 8 argues the bias
direction from the scoring rule, frames the replay-versus-slice gap as a measurement of the bias, and reinterprets
the dismissed A/B test through its interval.

---

## Block 3, what offline evidence can license

About 10 minutes.

**Interviewer.** "The ranking team can't A/B test every candidate. They run offline evaluation on dozens a
quarter. What should they be allowed to conclude from it?"

**Listen for.**

- **The asymmetry.** Offline evaluation can rule out and cannot rule in. A candidate that does worse on the
  items where labels exist is probably genuinely worse on those items, and that is enough to kill it. A candidate
  that does better has only shown it agrees with the incumbent's choices more agreeably, which is not a reason
  to ship.
- **Screening against licensing.** The right role for offline evaluation is a cheap filter that removes bad
  candidates before they cost live traffic. Keeping it in that role is compatible with running it on dozens of
  candidates. Promoting it to a launch criterion is not.
- **What makes the asymmetry hold.** Ruling out is safe because a candidate that is worse on covered items is
  worse on the region where we have evidence, and there is no reason to expect it to be better on the region
  where we do not. Ruling in fails because the uncovered region is where the upside would have to come from.
  A candidate who states that argument rather than asserting the asymmetry is doing the thing this round scores.
- The honest limit on ruling out too: a candidate designed to explore, which deliberately shows different
  things, will look bad offline for the same structural reason, so the screen has a false-negative mode and it
  is worth knowing which candidates it will unfairly kill.

**Strong signals.**

- Proposing a different offline label rather than a different estimator. If the relevance definition were
  reading that lasts, or upvotes only, rather than expands, the offline metric would at least be measuring
  something closer to value on the items it can see. That is a cheap change with a real payoff and it does not
  require any new machinery.
- Naming the reweighting family and immediately scoping it. Inverse propensity weighting and doubly robust
  estimators are the textbook fix for scoring a new policy on another policy's logs, and they need the logging
  policy's propensities, which a deterministic top-k ranker does not have, and they need overlap, which the 34%
  figure says is absent. So the honest position is that the machinery does not rescue this and the data
  collection has to change. Saying that is much stronger than either ignoring the estimators or reaching for them.
- Distinguishing what he would tell the team this week from what he would want to build.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Could you use inverse propensity weighting on the logs we have?" | Not on these logs. It needs the probability the logging policy assigned to each item, and the current ranker is deterministic top-k, so those probabilities are zero or one. Where they're zero, no amount of weighting recovers anything, because there's no data to reweight. That's the same positivity problem that kills an observational study with no overlap, and the fix is to change how the data is collected, not how it's analyzed |
| "What if we estimate propensities with a model?" | Then the weights inherit that model's errors and, worse, it can't manufacture support where the incumbent never showed an item. I'd rather spend the effort on a small randomized slice, which gives real propensities by construction |
| "Give me the rule you'd write down for the team." | Offline evaluation is a screen, not a gate. A candidate that loses offline is dead. A candidate that wins offline earns live traffic, not a launch. And any candidate whose whole point is showing different things gets evaluated on the randomized slice instead, because the screen is unfair to it by construction |

**Model answer.** "The rule I'd give them is that offline evidence can kill a candidate and can't ship one. It
can kill one because a candidate that's worse on the items where we do have labels is worse in the region where
we have evidence, and there's no reason to think it makes that back in the region where we don't. It can't ship
one because the upside of any real improvement lives precisely in the uncovered region, so a good offline score
is mostly a statement about agreement with the incumbent. That's compatible with running it on dozens of
candidates a quarter, which is what it's for. Two things I'd change. First, the relevance label: if it were
reading that lasts, or upvotes, rather than expand-or-upvote with expands dominating, the screen would at least
measure something closer to value on the items it can see. That's a cheap fix. Second, I'd be explicit that the
screen is unfair to exploratory candidates, so anything whose thesis is showing different things has to be
evaluated somewhere else. On the estimator question, the textbook answer is propensity weighting or a doubly
robust version, and it doesn't work here, because a deterministic top-k ranker assigns probability zero to
everything it didn't show and weighting can't recover data that doesn't exist. That's a positivity failure, and
positivity failures are fixed by collecting different data, not by a better estimator."

**Traps.**

- Proposing an estimator as the solution without noticing the overlap problem defeats it.
- Ignoring the estimators entirely, which reads as not knowing them.
- Symmetric conclusions: treating offline as weak evidence in both directions rather than valid in one.
- Missing the cheap label fix.

**Score.** 4 either ignores off-policy methods or proposes them as the fix. 6 states the rule-out asymmetry.
8 argues why the asymmetry holds, proposes the label change as the cheap improvement, and explains precisely why
propensity methods fail on a deterministic logging policy.

---

## Block 4, how you would fix it

About 12 minutes. The guide's "non-standard experiment designs and setups," in the form where the design exists
to generate evaluable data rather than to test a hypothesis.

**Interviewer.** "So what would you build? You have one quarter and you're not the one shipping models."

**Listen for.**

- **A permanent randomized exploration slice.** A small share of traffic, on the order of 1%, where the
  displayed ordering is randomized within the top candidates. That produces logs with known propensities and
  genuine overlap, which is the data every offline evaluation afterwards needs. This is the central answer.
- **The cost, named honestly.** Those users get a worse feed. That is a real and ongoing cost paid by real
  people, and the case for it is that it is the price of being able to evaluate anything at all. A candidate who
  proposes it without naming the cost has skipped the part Nick's round would push on.
- **Sizing the slice against what it has to support.** 1% of 8.0M feed users is 80,000 users, which is enough
  for a coarse ranker comparison and not enough for a precise one. The slice should be sized by the smallest
  offline difference the team needs to resolve, not picked because 1% sounds small.
- **Interleaving as the cheaper and more sensitive alternative for pairwise comparisons.** Mix the two rankers'
  results into one list for the same user and see which side's items get engaged with. It is randomized, it is
  within-user so it removes between-user variance, and it is far more sensitive than a user-split test. Its
  limits are that it only compares two rankers at a time, it cannot measure whole-session or downstream effects,
  and a list assembled from two rankers is not a list either would have produced.

**Strong signals.**

- Distinguishing the two designs by what they are for. Interleaving is for deciding which of two rankers is
  better on immediate engagement, cheaply and sensitively. The exploration slice is for producing a log that can
  evaluate any future candidate, including on outcomes interleaving cannot see. They are complements.
- Noting that the exploration slice's value compounds, because it accumulates a reusable unbiased log, whereas an
  A/B test's value ends when the test does. That is the argument that justifies the ongoing cost.
- Connecting it back to the incentive problem: the ranking team wanted to skip A/B tests because they were slow
  and inconclusive. The slice makes the offline screen trustworthy enough that fewer candidates need a live test,
  which gives the team what it actually wanted by a route that works.
- Proposing to backfill the audit: recompute past launch decisions on the slice once it exists, to find out how
  many previous shipped rankers would have failed.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "1% of users get a deliberately worse feed forever. Sell that to me." | It's a real cost and I'd want it minimized rather than hidden: randomize within the top candidates rather than across everything, so the degradation is small, and cap it. The argument for paying it is that without it we can't tell a good ranker from one that agrees with us, and the last three launches went out on evidence we now know was biased. The cost of not having it is spread across all 8 million users and it's invisible |
| "Why not just A/B test more?" | Because a test costs weeks and only answers one question, and the team already told us the tests were slow and inconclusive, which is a power problem we'd be repeating. The slice pays once and then every candidate can be screened honestly against it |
| "Where does interleaving fit?" | It's the right tool for choosing between two specific rankers, and it's much more sensitive than a user split because each user sees both. I'd use it for head-to-heads and the slice for building the evaluation log. What interleaving can't tell me is anything about the session as a whole or about whether people come back, because the list it produces isn't a list either ranker would have served |
| "What if leadership says no to the slice?" | Then I'd say the honest consequence out loud: offline evaluation stays a one-directional screen, every launch candidate needs live traffic, and we should stop quoting offline lifts as launch evidence. That's a worse world and it's a coherent one. What I wouldn't do is keep shipping on the replay number |

**Model answer.** "Two things, and they do different jobs. The one that matters most is a permanent randomized
exploration slice: take something like 1% of feed traffic and shuffle the ordering within the top candidates
before display. That gives us logs where exposure is independent of what the incumbent preferred, which is
exactly the overlap the replay is missing, and from then on any candidate can be screened against it honestly.
The cost is real and I'd say it plainly: 80,000 people get a slightly worse feed on an ongoing basis. The case
for paying it is that the alternative is what we've been doing, which is shipping on a number that rewards
agreement with the incumbent, and the cost of that is spread across all 8 million users where nobody can see it.
I'd size the slice by the smallest offline difference we need to resolve rather than by what sounds small. The
second thing is interleaving for head-to-head comparisons, where you mix two rankers' results into one list for
the same user. It's randomized, it's within-user so it's far more sensitive than a user split, and it's the fast
way to settle which of two candidates readers prefer. Its limits are that it's pairwise, it can't see
session-level or return-visit effects, and the blended list isn't one either ranker would have produced. The
thing I'd add on top is a backfill: once the slice exists, re-evaluate the rankers we already shipped, because
if the replay has been flattering agreement all along, some of those launches were mistakes and we'd want to
know which."

**Traps.**

- Proposing only more A/B testing, which is what the team already complained about.
- Proposing the exploration slice without naming its cost.
- Confusing interleaving with a user-split A/B test, or claiming it can measure retention.
- Picking 1% because it sounds small, with no reference to what it needs to detect.

**Score.** 4 proposes more A/B tests or a better estimator. 6 proposes an exploration slice. 8 also names its
ongoing human cost and sizes it against the smallest difference to resolve, adds interleaving with its actual
limits, and proposes backfilling past decisions.

---

## Block 5, your questions

About 5 minutes. Not scored. This round is run by a data scientist who may work on exactly this.

- "Does the feed have a randomized exploration slice today, or is all the logged data from the live policy?"
- "When an offline evaluation and an A/B test disagree here, which one wins, and has that changed?"
- "How many ranker candidates a quarter get offline-screened, and how many reach live traffic?"
- "Has anyone gone back to check whether a shipped ranker held up after the test ended?"

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| Framing an open-ended question | | |
| Identification and assumptions | | |
| Assumptions and their consequences | | |
| Non-standard design | | |
| Product intuition | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Framing | Accepts the offline table, or moves to designing an A/B test | Identifies that labels exist only for shown items | States that the metric therefore rewards agreement with the incumbent, and catches the expand-weighted label independently |
| Identification | Argues selection abstractly, asks for no evidence | Asks for coverage and reads it | Argues the bias direction from the scoring rule and frames the replay-versus-slice gap as a measurement of the bias |
| Assumptions and conclusions | Symmetric conclusions from offline evidence | States the rule-out asymmetry | Argues why the asymmetry holds, and why propensity methods fail against a deterministic logging policy |
| Non-standard design | More A/B tests | An exploration slice | Names its human cost, sizes it against a target difference, adds interleaving with its real limits, backfills past decisions |
| Product intuition | Treats it as a metrics problem | Knows the feed's job is reader value | Derives the whole case from the fact that a helpful ranker must show different things |
| Communication | Machinery before mechanism | Verdict clear | Mechanism first, machinery scoped, and a rule the team can actually apply |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- Did he ask for something like coverage, or did it have to be offered?
- Did he name an off-policy estimator before or after establishing the mechanism?
- Did he reinterpret the dismissed A/B test through its interval?
- Did he name the exploration slice's cost to real users without being pushed?

| Block | Target | Actual |
|---|---|---|
| 1. What the number measures | 6 min | |
| 2. Why it can be wrong | 12 min | |
| 3. What it can license | 10 min | |
| 4. How you would fix it | 12 min | |

Top three fixes for the next mock.

1.
2.
3.
