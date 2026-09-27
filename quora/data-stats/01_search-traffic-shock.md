# Case 01, how much of the search decline is AI Overviews

A mock interview for the **Data Stats** round of the Quora final round loop. 45 minutes, one file,
written in the order the interview happens. Claude plays the interviewer. To practice blind, stop
reading after the context in Block 1.

No coding. This round is talked through, and the guide says so by omission: coding lives in the Data
Practical. Write the model on a shared doc or say it out loud, and expect to defend every term in it.

All numbers are synthetic and were computed by script so every table agrees. Public figures are labeled
as such. Product mechanics follow `../private/product.md`. Search clicks here run 392M to 231M a month,
the same figures as `../data-metrics/01_engagement-metric-audit.md`, so the two cases describe one world.

## The shape of this round, and why it differs from the metrics cases

The guide describes this round more specifically than any other, so the structure is copied from its
wording rather than invented.

| The guide says | So the case does this |
|---|---|
| "A series of questions involving a simulated scenario" | One scenario, five blocks of questions on it. Not one arc with a verdict at the end |
| "Some questions may be based on observational data" | Block 2. Attribution with no experiment available |
| "Some may involve non-standard experiment designs and setups" | Block 3. What is testable when you cannot randomize Google |
| "Some may require a deeper dive into statistical models" | Block 4, the longest block |
| "Not on coming up with fancy models, but on being able to formulate a well-defined model" | Block 4 penalizes sophistication. The winning answer is a short equation you can defend |
| "Clearly understand the assumptions behind it and how those assumptions affect the final conclusions" | Every block asks for the assumption before the estimate |
| "Interpret it for both prediction and statistical inference" | Block 4's second half. The same data, two models, and saying why one model cannot do both |
| Email: "how you decide on the best course of action when there's more than one reasonable path" | Block 5. Two defensible options and no right answer, only a defensible choice |

**Why this scenario is product sense forward.** The identification strategy and the product insight are
the same thing. Quora's defensible queries are the ones where the value is a person's judgment or lived
experience rather than a fact, and those are exactly the queries Google's AI Overviews are worst at and
least likely to appear on. So a candidate who has a real view on what Quora is for gets the control group
for free, and a candidate who does not will reach for a technique and pick the wrong comparison. Block 1
is where that separates, and it is scored heavily for a block with no statistics in it.

## Clock

| Block | Minutes | Scored on |
|---|---|---|
| 1. Framing and the product read | 4 | Framing, product intuition |
| 2. Observational, how much is AI Overviews | 11 | Identification and assumptions |
| 3. Non-standard design, what can you even test | 9 | Design under constraints |
| 4. The model, its assumptions, prediction against inference | 13 | Model formulation, prediction against inference |
| 5. Two reasonable paths | 5 | Choosing among paths |
| 6. Your questions | 3 | Not scored |

## How Claude runs it

- Default is a full mock. Stay in character as a Quora data scientist. No teaching or grading until the end.
- Say each block's opening line, then let him answer. At most two follow-ups per block, picked for what he missed.
- Paste context and tables exactly as written, and only when the block or his request calls for them.
- **Release data on request only.** A vague request gets "What exactly would you want to see, and what
  would you conclude from each way it could come out?"
- **Do not accept a technique as an answer.** If he names a method before naming the assumption it rests
  on, ask "and what has to be true for that to work?" once per block. That is the whole round.
- Don't lead. No hint about which design is preferred, and no reaction to a wrong one beyond releasing
  what was asked for.
- Record the time with `date` at each block. Move on when a block runs a minute or two past target.
- If he says "pause," give short feedback on the current block, then resume.
- If he asks for a fact the file doesn't have, answer consistently with the case, then add it afterward.
- At the end, debrief with the scorecard. Criteria are specific to this round.

---

## Block 1, framing and the product read

About 4 minutes.

**Interviewer.** "Here's the situation. I'll give you the numbers in a minute, but first I want to know
how you'd think about it."

> ### Context, Quora and Google
>
> **The dependence.** Organic search is Quora's largest channel by a wide margin. Third-party estimates
> put it somewhere between about 48% and 80% of visits. Question pages rank on long-tail informational
> queries, and most people who arrive that way are not logged in and never sign in.
>
> **What changed.** Google now shows an AI Overview, a generated answer above the organic results, on a
> growing share of queries. Pew has published that link clicks fall from 15% of Google searches to 8%
> when an AI Overview appears. That figure is not Quora-specific.
>
> **Public traffic estimates for Quora.** About 506M monthly visits in April 2025, 442M in October 2025,
> 358M in January 2026, under 300M by mid-2026. These come from third-party tools that disagree with each
> other, so treat them as directional only.
>
> **What Quora can see in its own data.** Daily sessions by referrer. Google Search Console impressions,
> clicks, and average position, by query and by landing page. Its own query classification into nine
> classes. What it cannot see in Search Console is whether an AI Overview appeared. That requires a
> third-party rank tracker, and Quora runs one on a sample of 40,000 queries.
>
> **The decision on the table.** Leadership is deciding how much to move investment out of search and
> into logged-in growth, and they want to know two things: what search clicks will look like twelve
> months from now, and how much of the decline so far was caused by AI Overviews.

**Interviewer.** "Before any analysis. Why does anyone click a Quora link out of a Google result, and
which of those clicks do you expect to lose?"

**Listen for.**

- **What Quora is uniquely for.** A question whose good answer is a person's judgment, experience or
  taste. "What is it actually like to work at a small company," "should I take less money for more
  autonomy," "is this normal." A generated summary can answer a fact. It cannot credibly answer "what
  happened when you did this," because the value of that answer is that a named human is standing behind it.
- **The corollary, which is the whole case.** Quora's vulnerable clicks are the factual ones, where the
  answer is a fact and the Overview can produce it. Its defensible clicks are experiential and opinion
  queries. So the loss should be concentrated by query type, and that is both the prediction and the
  comparison group he will need in Block 2.
- **Two different decisions, two different analyses.** A twelve-month forecast and a causal attribution
  are not the same question and do not want the same model. Saying that here, unprompted, is the single
  strongest opening in the case.
- **The measurement constraint named early.** AI Overview presence is not in the logs. Everything
  downstream is limited by a 40,000-query sample.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "If the Overview answers the question, hasn't the user been served? Why should we care?" | The user has been served and Quora has not been paid, which is the business problem, and separately the Overview is answering out of content people wrote for Quora. The part I'd want to measure is whether the queries where a human answer is genuinely better are also losing clicks, because if they are, something other than substitution is happening |
| "Leadership wants one number. Why are you giving me two analyses?" | Because the forecast tells you how much runway you have and the attribution tells you whether the cause is permanent. If half the decline is Google's product and half is our own ranking and product decisions, the second half is ours to fix and the investment case is different |
| "Which queries would you look at first?" | The ones where we rank well and the answer is a fact, since that is where the Overview competes most directly, and the experiential ones as the comparison, since that is where it competes least |

**Model answer.** "People click Quora out of a search result when what they want is a person's answer
rather than a fact. 'What's the boiling point of water' was never really ours. 'What's it actually like
to leave academia for industry' is, because the value of that answer is that a named human is behind it
and a summary cannot fake that. So my prior is that the loss is concentrated on factual queries and that
experiential and opinion queries hold up much better. That has two consequences. It's the first thing
I'd check, and if it's true, those resilient queries are also the comparison group I'd use to measure
the effect, because they share Google's algorithm and our own product changes but not much of the
Overview exposure. The other thing I'd separate now is that you're asking me two questions. What clicks
will be in twelve months is a forecast, and how much of the decline was Overviews is a causal question.
Those want different models and I'd rather build two than compromise one. And the practical limit on all
of this is that Overview presence isn't in Search Console, so anything causal runs off the 40,000-query
tracked sample."

**Traps.**

- Opening with a method. Difference-in-differences before establishing what the comparison group is and
  why it is credible is the documented over-engineering reflex in this round's costume.
- Treating all search traffic as one homogeneous thing.
- Missing that the forecast and the attribution are separate questions.
- Talking about AI Overviews without ever saying what Quora is good for.

**Score.** 4 describes search traffic generically or names a technique. 6 gets that vulnerability varies
by query type. 8 also derives the comparison group from the product reasoning and separates the forecast
from the attribution before being asked.

---

## Block 2, observational, how much is AI Overviews

About 11 minutes.

**Interviewer.** "Here's what our own search data looks like."

> | Quarter | Impressions | Clicks | CTR | Average position |
> |---|---|---|---|---|
> | 2025 Q1 | 9.80B | 392M | 4.00% | 8.4 |
> | 2025 Q2 | 9.62B | 361M | 3.75% | 8.6 |
> | 2025 Q3 | 9.45B | 330M | 3.49% | 8.9 |
> | 2025 Q4 | 9.20B | 300M | 3.26% | 9.1 |
> | 2026 Q1 | 9.05B | 268M | 2.96% | 9.4 |
> | 2026 Q2 | 8.90B | 231M | 2.60% | 9.6 |

**Interviewer.** "Clicks are down 41%. How much of that is AI Overviews?"

**Listen for.**

- **The free decomposition before any causal work.** Clicks are impressions times CTR. In logs, the total
  move is -0.527, of which impressions account for -0.096 and CTR for -0.431. So 18% of the decline is
  fewer impressions and 82% is a lower click rate on the impressions we still get. An Overview can only
  work through CTR and position, so this already bounds the story, and it costs nothing.
- **Position as a competing explanation for the CTR fall.** Average position went from 8.4 to 9.6, and
  CTR falls with position mechanically. That has to be separated before the Overview gets credit.
- **Asking for Overview exposure rather than assuming it.** The word "Overviews" is in the question, and
  the data that would speak to it has not been offered.
- **Naming the assumption before the design.** Whatever comparison he proposes, parallel trends or its
  equivalent should be stated as an assumption that could fail, with the direction it would bias.

**Release on request.**

**Within-position CTR.** Release when he asks whether the CTR fall is explained by ranking.

> | Position bucket | CTR 2025 Q1 | CTR 2026 Q2 | Change |
> |---|---|---|---|
> | 1 to 3 | 12.8% | 8.1% | -36.7% |
> | 4 to 10 | 4.2% | 2.9% | -31.0% |
> | 11 to 20 | 1.1% | 0.8% | -27.3% |

Read. CTR fell inside every bucket, so the fall is not a mix shift toward worse positions. Note which
bucket fell hardest: positions 1 to 3, which is what displacement above the fold looks like rather than
what a ranking change looks like. Losing the top slot's prominence costs more than losing a slot further
down that was never prominent.

**The tracked sample.** Release when he asks for Overview exposure.

> A third-party rank tracker covers 40,000 queries, about 12% of click volume. Queries are grouped by
> whether an Overview was present for them in 2026 Q2.
>
> | | Overview present | Overview absent |
> |---|---|---|
> | Share of 2025 Q1 clicks in the tracked sample | 57.5% | 42.5% |
> | CTR 2025 Q1 | 4.31% | 3.62% |
> | CTR 2026 Q2 | 2.28% | 3.11% |
> | Change | -47.1% | -14.1% |

**Pre-trends.** Release when he asks for a pre-period check, and give him credit for asking.

> The same two groups over 2024 Q1 to 2024 Q4, before Overviews appeared at scale. Change in log CTR:
> -0.061 for the group that would later be exposed, -0.042 for the group that would not. A differential
> of about -0.006 per quarter.

**The arithmetic, if he gets there.**

| Step | Value |
|---|---|
| Difference in differences, log CTR | -0.485, so exposed CTR is about 38% below its counterfactual |
| Weighted by the 57.5% exposed share of base clicks | -0.279 of the -0.431 log CTR move, so 65% of the CTR decline |
| As a share of the total click decline of -0.527 | 53% |
| After removing the pre-existing differential trend of -0.006 per quarter over five quarters | DiD becomes -0.453, and the share becomes 49% |

So: about half the decline, and the parallel-trends assumption is carrying that number.

**Strong signals.**

- Doing the decomposition first and saying out loud that it was nearly free.
- Asking for pre-trends without being prompted, and then reporting that the correction moved the answer
  from 53% to 49%, which is to say the check mattered and did not change the headline. Saying both halves
  of that is the mark of someone who has done this before.
- **Naming both directions of bias.** The control group is contaminated, because if people learn that
  Google answers questions directly they issue different queries and click less everywhere, which makes
  DiD understate. And exposure is not random, because Google likely turned Overviews on first where it
  had confident answers, which are queries already losing clicks, which makes DiD overstate. A candidate
  who names both and then says he does not know the net sign, and proposes to bound it, is at the top of
  the scale. A candidate who names one and treats the estimate as clean is not.
- Refusing to give a point estimate without a range.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Pew says clicks fall from 15% to 8% when an Overview appears. That's 47%. Your treated group fell 47% too. Nice confirmation?" | Those are three different quantities and I wouldn't line them up. Pew is a cross-sectional contrast between searches with and without an Overview, on any click. My -47% is a before-and-after on Quora's own CTR, which includes everything else that changed in five quarters. The cross-sectional version of my number is 2.28% against 3.11% in 2026 Q2, which is -27%, and the identified estimate is the -38% difference in differences. The fact that a raw before-after happens to match a published cross-section is a coincidence, not a validation |
| "So we can tell leadership Overviews caused half of it." | I'd say about half, with the range between roughly 40% and 60% depending on how the assumption fails, and I'd tell them what the assumption is in one sentence. Two biases run in opposite directions and I can't sign the net, so a false-precision number here would be worse than the range |
| "What's the other half?" | About 18% of the decline is fewer impressions, which is roughly 7 of the 41 points and is a ranking and query-volume story rather than an Overview story, and the remainder is CTR we lost inside positions that the exposed-against-unexposed contrast doesn't attribute to Overviews. Candidates for that: more ads and other rich results above us, competitors like Reddit ranking above us, and the possibility that searchers have learned to skip Quora results, which is our own product problem and the one I'd most want to test |
| "How would you bound it?" | Two ways. Re-run on the markets where Overviews arrived later, since that design fails differently, and agreement between the two is the evidence. And bound the contamination by looking at the unexposed group's query volume, because if the contamination story is right, unexposed queries should show falling impressions too |

**Model answer.** "Before attributing anything, clicks are impressions times CTR, and in logs 18% of the
41% is fewer impressions and 82% is a lower click rate. An Overview works through the click rate and
through pushing us down the page, so the CTR side is where it can live. Position went from 8.4 to 9.6,
which lowers CTR on its own, so I'd want CTR inside position buckets before I credit the Overview with
anything. If CTR fell inside every bucket, and hardest at positions 1 to 3, that's displacement above the
fold rather than ranking. Then I need exposure, which isn't in Search Console, so I'm on the tracked
sample. Comparing exposed against unexposed queries before and after, exposed CTR is about 38% below its
counterfactual, and weighting by the exposed share of clicks that's roughly half the total decline. I'd
check pre-trends first, and if the groups were already diverging slightly, correcting for it takes the
estimate from 53% to 49%, so about half either way. The number rests on parallel trends and I can name
two ways it fails in opposite directions. Unexposed queries are probably also affected, because Overviews
change how people search in general, which makes me understate. And Google likely turned Overviews on
first where it had a confident answer, which are queries already in decline, which makes me overstate.
I can't sign the net of those, so I'd report about half with a range of roughly 40 to 60 and say what the
assumption is, rather than a point estimate I'd have to walk back."

**Traps.**

- Reaching for difference-in-differences before decomposing clicks into impressions and CTR.
- Attributing the whole CTR fall to Overviews without separating position.
- Treating the tracked sample as a random sample of queries.
- One bias named, or none. The estimate presented as clean.
- A point estimate with no range on an observational question this confounded.
- Two-way fixed effects on staggered exposure pooled into a single coefficient, without noticing that
  exposure turned on at different times for different queries.

**Score.** 4 attributes the decline to Overviews from the time series alone, or names a method with no
assumption. 6 decomposes into impressions and CTR, separates position, and runs a credible comparison.
8 also checks pre-trends unprompted, names both directions of bias, refuses a point estimate, and
proposes a second design that fails differently.

---

## Block 3, non-standard design, what can you even test

About 9 minutes.

**Interviewer.** "You've told me what you think happened. Now I want to do something about it. Nobody
here can randomize Google. What can we actually test?"

**Listen for.**

- **Randomize our response, not the exposure.** Quora cannot assign Overviews. It can assign its own
  changes: what the page looks like above the fold, how the answer is summarized, whether a structured
  summary sits at the top, when the sign-up prompt appears, which questions get editorial attention.
- **The interference problem, which is the point of this block.** Quora's pages compete with each other
  for the same search results. Improve half of them and Google reallocates rank between them, so the
  control pages are affected by the treatment. The no-interference assumption fails through Google's
  ranking system rather than through users talking to each other. A page-level A/B test on anything that
  touches ranking or click-through is contaminated by construction, and the contamination has the wrong
  sign: control pages get pushed down, so the treatment looks better than it is.
- **The fix follows from the mechanism.** Randomize at a level where treated and control rarely appear on
  the same results page. Cluster by topic or query cluster. Accept fewer, larger units and less precision
  in exchange for a contrast that means something.
- **What a page-level test is still fine for.** Anything measured after the click. Post-click behavior
  does not affect which pages rank against each other in the short run, so on-page tests for reading
  depth or sign-up are legitimate at the page level. Pre-click effects are the ones that need clustering.
- **Index lag.** A page change takes days to weeks to propagate into rankings. A two-week test measures
  the ramp, not the effect. Duration has to be set by how fast Google recrawls, not by how fast the team
  wants an answer.
- **The unit cannot be the user.** This traffic is logged out and cookie-poor, so user-level assignment
  is unreliable and user-level outcomes like return visits are badly measured.

**Strong signals.**

- Proposing the geo or language design as a second identification strategy: Overviews arrived at
  different times in different markets, and Quora operates in 24 languages. It is a natural experiment
  with entirely different failure modes from the query-class comparison, and two designs that disagree
  are more informative than one design that looks clean.
- Saying what the geo design assumes and why it is weak: markets differ in competitors, language model
  quality and Quora's own content depth, so parallel trends across countries is a stronger claim than
  parallel trends across query classes. Offering it anyway, as a check rather than as the primary.
- A switchback or time-based design at the site level for something that genuinely cannot be split, with
  an honest statement of what it costs: no cross-sectional control, so any site-wide shock in the same
  window is indistinguishable from the effect.
- Noticing that Google, not Quora, chooses the snippet shown in the results page, so "test a better
  snippet" is not directly a thing Quora can randomize.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "We want to test a summary box at the top of question pages. Page-level split, 50/50, two weeks. Fine?" | Two problems. Our pages compete with each other in search, so improving half of them pushes the other half down and the control arm is treated in the opposite direction, which flatters the result. And two weeks is mostly recrawl lag, so most of the window has no treatment in it. I'd cluster by topic so treated and control pages rarely meet on the same results page, and run it long enough that the index has settled, with the first stretch excluded |
| "Clustering by topic leaves us maybe forty clusters. Is that enough?" | It is enough to run and not much more. As a rule of thumb, cluster-robust standard errors get unreliable somewhere below about thirty to fifty clusters, and too small rather than too large, so I'd expect a wide interval and I'd say up front what effect size the design can actually detect. If that number is larger than the effect we care about, the honest move is to say the test can't answer it rather than run it and read noise |
| "Could we just look at pages we've already improved over the last year?" | That's observational and the selection is the worst kind, because we improved the pages we thought were worth improving, which correlates with their trajectory. It's worth doing as a descriptive prior and it would not settle anything |
| "What would you test first?" | Whether searchers are avoiding us, because it's the one candidate cause in Block 2 that is ours to fix. The sign-up prompt is the obvious suspect and it is randomizable at the session level without touching ranking |

**Model answer.** "We can't assign Overviews, so I'd randomize our response to them. The constraint that
shapes everything is that our own pages compete with each other in Google, so if I improve half of them
the other half get pushed down, and control is treated in the opposite direction. That breaks the
no-interference assumption through the ranking system, and it breaks it in the flattering direction, so a
page-level test of anything that affects ranking or click-through will overstate. So I'd cluster by topic
or query cluster, so treated and control pages seldom appear on the same results page, and accept fewer
units and a wider interval for a contrast that means something. I'd also set duration off Google's
recrawl rate rather than off how fast we want an answer, and throw out the ramp. Page-level splits are
still fine for anything measured after the click, because post-click behavior doesn't change which of our
pages rank against each other, so on-page reading and sign-up tests don't need the clustering. And I'd
add one thing that isn't a test: Overviews launched at different times in different markets, and we're in
24 languages, so there's a second natural experiment with completely different failure modes from the
query-class comparison. Countries are less comparable than query classes, so I'd use it as a check rather
than as the primary, and if the two designs land in the same place that agreement is worth more than
either one alone."

**Traps.**

- A conventional user-level A/B test on logged-out search traffic.
- Missing the interference through ranking. This is the block's whole content.
- A two-week test with no mention of index lag.
- Proposing to randomize something Google controls, such as the snippet or the Overview itself.
- Offering the geo design without saying what makes it weaker.

**Score.** 4 proposes a standard A/B test with no acknowledgment of the constraints. 6 gets that the unit
cannot be the user and proposes a page or cluster design. 8 identifies the interference through Google's
ranking, says which direction it biases, splits pre-click from post-click tests accordingly, and offers a
second design with different failure modes.

---

## Block 4, the model, its assumptions, prediction against inference

About 13 minutes. The longest block, matching the guide's emphasis.

**Interviewer.** "Leadership wants two things. A twelve-month forecast of search clicks for planning, and
the attribution number for the investment case. Write me a model."

### Part A, formulate it

**Listen for.** A short equation, its units, and what varies over what. Something like a panel of nine
query classes by month:

> log(clicks) for class c in month t = class effect + month effect + β times Overview exposure share + error

**Strong signals.**

- Stating the panel structure and what the fixed effects absorb. Class effects absorb the permanent
  differences between factual and experiential queries. Month effects absorb anything hitting all classes
  at once, including seasonality and site-wide Google updates.
- **Not controlling for position or impressions, and saying why.** Both are downstream of Overview
  exposure, for different reasons. Position is displaced directly, because the Overview sits above the
  organic results. Impressions are downstream more weakly, through exposure changing query volume and
  what Google chooses to show. Putting either on the right-hand side changes the estimand from the total
  effect of an Overview to its direct effect on click rate holding placement fixed, which is not what the
  investment case is asking. A candidate who writes the model with
  position in it and does not notice is making the central error of the block. A candidate who includes it
  deliberately, names it as a mediator, and says which question each version answers is at the top.
- **Not adding class-specific time trends.** Overview exposure rolled in slowly and monotonically, so a
  class-specific trend is nearly collinear with the treatment and will absorb it. This is the same error
  as controlling for a mediator, arriving by a different route.
- Log form justified rather than assumed: effects on clicks are plausibly proportional, and the log keeps
  the coefficient interpretable as a percentage.

**Assumptions he should volunteer, with what breaks.**

| Assumption | If it fails |
|---|---|
| Exposure is as good as randomly assigned given class and month effects | β absorbs whatever made Google choose those queries first. This is the one doing the real work |
| No class-specific shocks in the window | A Google quality update aimed at factual queries loads onto β. Month effects cannot catch it |
| Position and impressions are not controlled for | Controlling for them gives a direct effect, not a total effect. Both are legitimate, they answer different questions |
| Effects are proportional, so the log form fits | A floor effect, where some clicks never go away regardless, would show up as misspecification at high exposure |
| Errors are independent across classes | They are not. Cluster by class, and note that nine clusters makes cluster-robust standard errors optimistic, so either move to query-level clustering or bootstrap |
| Exposure is measured without error | It is imputed for 88% of clicks. Classical measurement error attenuates β toward zero. Non-classical error, correlated with query type, has an unknown sign |
| No anticipation, no spillover across classes | Spillover is likely, since Overviews change search behavior generally, and it biases β toward zero |

### Part B, prediction against inference

**Interviewer.** "Can one model do both jobs?"

**The answer the block is built around: no, and the reason is specific.** Release this table if he gets
close, or after his answer if he does not.

> The same panel, four specifications.
>
> | Specification | β on Overview exposure | 12-month out-of-sample error |
> |---|---|---|
> | 1. Class and month effects only | -0.49 | 14.2% |
> | 2. Plus position and log impressions | -0.19 | 11.8% |
> | 3. Plus class-specific linear trends | -0.11 | 9.1% |
> | 4. Plus lagged log clicks | -0.04 | 4.3% |

Read. Forecast accuracy improves monotonically down the table while β collapses toward zero, and that is
not a coincidence. Every term that improves the forecast does so by absorbing persistent variation, and
the Overview rollout is persistent variation. Specification 4 is the best forecaster in the table and its
β is meaningless, because last month's clicks already contain the Overview effect. Specification 1 is the
only one whose β is a total effect, and it is the worst forecaster.

**Strong signals.**

- **Cross-checking specification 1 against Block 2.** β of -0.49 on log clicks against the
  difference-in-differences of -0.485 on log CTR. These are not the same quantity, and the best version of
  the observation says so: β should equal the CTR effect plus the impressions channel, so a gap of about
  half a percent means the impressions channel is near zero for exposed queries, which agrees with the
  Block 2 decomposition. Two designs on different outcomes reconciling is the real evidence, and noticing
  it unprompted is the best single moment available in this case.
- Saying that forecast error and causal credibility are not comparable currencies, so "the model that
  fits better" is not an argument for its β. The forecast model is judged out of sample. The causal model
  is judged on whether its assumption is believable, and no held-out sample can tell you that.
- **The forecast needs a path for exposure, which is Google's decision.** So the honest forecast is
  scenario-based rather than a point estimate with an interval: exposure holds at today's share, rises
  toward saturation, or is partly withdrawn. Three paths, three click numbers.
- Saying that the model's own prediction interval understates the real uncertainty, because the dominant
  uncertainty is which scenario happens, not the residual variance. Presenting a tight interval around a
  forecast of another company's product roadmap is the mistake.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Specification 4 forecasts three times better. Use its β." | No. It forecasts better because lagged clicks already contain the Overview effect, so β is only picking up whatever is left over month to month. It's the right model for the planning question and it has nothing to say about cause |
| "Then just report specification 1's β and specification 4's forecast." | That's what I'd do, and I'd label them as two models rather than presenting one table with both columns, because putting them side by side invites someone to ask why the coefficients differ and there's no good short answer that isn't the whole explanation |
| "Give me the forecast as one number." | I'd rather give three. Twelve months out, the answer depends mostly on how far Google pushes Overview coverage, which we don't control and can't forecast. A single number would be a forecast of Google's roadmap wearing a statistical costume. If you need one for the plan, take the middle scenario and I'll tell you what it assumes |
| "What would make you trust β more?" | The geo design agreeing with it, a pre-trend check that comes back flat, and the estimate holding up when I use only the tracked queries where exposure is observed rather than imputed |
| "Nine classes and you're clustering on them. Talk me through the standard errors." | Nine clusters is too few for cluster-robust errors to be trustworthy, and they'll be too small. I'd move the analysis to the query level so there are thousands of clusters, or keep the class panel and use a wild cluster bootstrap. Either way I'd report the interval and expect it to be wide enough that the honest claim is "about half," not a two-decimal number |

**Model answer.** "One model can't do both, and the table shows why. I'd write a panel of query classes by
month, log clicks on class effects, month effects and Overview exposure share, and nothing else. Class
effects absorb the permanent difference between factual and experiential queries, month effects absorb
anything hitting everything at once. I would deliberately not put position or impressions in it, because
an Overview pushes our link down the page, so position is downstream of the treatment and controlling for
it turns the total effect into a direct effect on click rate at fixed placement. That's a legitimate
quantity and it is not the one the investment case needs. Same reasoning rules out class-specific trends,
because exposure rolled in slowly and a trend per class is nearly collinear with it. The assumption
carrying the whole thing is that exposure is as good as random given those effects, and I don't fully
believe it, for the two reasons I gave earlier. For the forecast I'd want the opposite model: lagged
clicks and flexible trends, which is what specification 4 is, and its β is worthless precisely because
lagged clicks already contain the effect. So two models, labeled as two, judged in different currencies.
Out-of-sample error is the test for one and the credibility of an assumption is the test for the other,
and no amount of held-out data settles the second. The other thing I'd say about the forecast is that it
needs a path for exposure going forward, which is a Google product decision. So I'd give three scenarios
rather than a point estimate, and I'd say plainly that the model's prediction interval is much too narrow,
because the real uncertainty is which scenario we're in. One check worth mentioning: specification 1's
β of -0.49 is on log clicks and the difference-in-differences of -0.485 is on log CTR, so they aren't the
same quantity. β should be the CTR effect plus whatever runs through impressions, and the gap between them
is only about half a percent, which says the impressions channel is close to nothing for exposed queries.
That's consistent with what the first decomposition showed, and two designs on different outcomes lining
up that way is the strongest evidence in the exercise."

**Traps.**

- Controlling for position and impressions without noticing they are mediators.
- Adding class-specific trends, which absorbs the treatment.
- Choosing the specification by fit or by out-of-sample error and reading its β.
- A fancy model. A state-space model, a hierarchical Bayesian panel, or a machine learning forecaster is
  a losing answer in a round that says explicitly it is not looking for fancy. If he wants to mention one,
  the only defensible framing is that it would improve the forecast and would not touch identification,
  and that he would not start there.
- A single forecast number with a confidence interval, as though the uncertainty were statistical.
- Never cross-checking the regression against Block 2.

**Score.** 4 writes a model with mediators in it, or picks the specification by fit. 6 writes a clean
specification, states real assumptions, and separates the two jobs. 8 excludes the mediators for the
stated reason, explains why forecast accuracy and causal credibility are not comparable, gives the
forecast as scenarios, and cross-checks β against the difference-in-differences.

---

## Block 5, two reasonable paths

About 5 minutes. This block exists because the email names it: how you decide when more than one path is
reasonable.

**Interviewer.** "Last thing. You need the attribution number by Friday and you have two options."

> **Path A.** Estimate on the 40,000 tracked queries, where Overview presence is observed directly.
> Measurement is clean. The sample is 12% of clicks and was chosen by volume, not at random.
>
> **Path B.** Estimate on all queries, imputing Overview exposure from a classifier trained on the
> tracked sample. Full coverage. Exposure is measured with error.

**Interviewer.** "Which one, and why?"

**Listen for.**

- **The decision first, not the method.** What hangs on this number is a binary investment call. If both
  paths put the answer on the same side of whatever threshold leadership is using, the choice does not
  matter and the right move is to do the cheap one and stop. That is the answer this loop is built to
  reward, and it is the "rigor that knows when to stop" criterion in its most explicit form.
- **The bias directions, named.** Path A's weakness is external validity: high-volume queries are not
  typical and are plausibly more exposed, so A probably overstates. Path B's weakness is attenuation:
  classical measurement error pulls β toward zero, so B probably understates, and if the classifier's
  errors correlate with query type the error is not classical and the sign is unknown. So the two paths
  likely bracket the truth, which is more useful than either alone.
- **Running both is cheap.** These are not weeks apart. The grown-up answer is A first because it is
  faster and cleaner, B as a check, and the gap between them reported as part of the uncertainty rather
  than resolved.
- **A third path he should offer.** Reweight the tracked sample to match the full population on
  observable query characteristics: class, volume, position. Recovers most of Path B's coverage argument
  without the imputation, and costs an afternoon.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "They come back at 61% and 38%. Now what?" | Then the gap is the finding and I'd chase it, because a spread that wide means one of the two assumptions is badly wrong. First check is whether the tracked queries are more exposed than the population, which is a one-day job and would explain it. Until then I'd report the range and say the investment case has to survive both ends |
| "They come back at 48% and 51%. Now what?" | Then I stop, report about half, and go do something else. More precision on this number doesn't change the decision, and saying so is part of the job |
| "You're the only person who'll understand the difference. Why not just report the better one?" | Because whichever I report, someone will eventually ask why it moved, and I'd rather be the person who already knew. One line in the readout saying the two approaches give 48% and 51% costs nothing and buys the number credibility it wouldn't otherwise have |

**Model answer.** "It depends on what the number has to be right enough for, so I'd ask what threshold
leadership is using. If the call is whether to shift investment to logged-in growth and the answer flips
somewhere around a third, then both paths are going to land well above that and the choice is irrelevant.
In that case I'd run A, because it's faster and its measurement is clean, and run B as a check, and
report both. On their weaknesses: A's high-volume queries are probably more exposed than average, so A
likely overstates, and B's measurement error attenuates toward zero, so B likely understates, which means
together they bracket. That's more useful than picking one and defending it. The cheap third option I'd
actually do first is to reweight the tracked sample to look like the population on class, volume and
position, which gets most of the coverage argument for an afternoon's work. And if A and B come back far
apart, that gap is the finding and I'd go look at whether the tracked queries are systematically more
exposed before reporting anything."

**Traps.**

- Picking a path on methodological grounds without asking what the number is for.
- Treating this as a question with a right answer.
- Not noticing that both can be run.
- Getting the attenuation direction backwards.

**Score.** 4 picks one on method alone. 6 picks one and names both weaknesses. 8 asks what decision the
number feeds, says the choice may not matter, gets both bias directions right, and offers the reweighting.

---

## Block 6, your questions

About 3 minutes. Not scored. This round is run by a data scientist who works on this problem.

- "How much of the search decline does the team currently attribute to Overviews, and how confident is it?"
- "Do you have Overview presence for a sample of queries, or is it inferred?"
- "When you can't randomize, what's the design the team reaches for most often here?"
- "Has the team found anything that wins a click back once an Overview is on the page?"

---

## Scorecard

Criteria are specific to this round, taken from the guide's stated assessment rather than reused from the
metrics cases.

| Criterion | Source in the guide | Score | Evidence |
|---|---|---|---|
| Framing an open-ended question | "Framing an open-ended question" | | |
| Identification and assumptions | "Understanding the assumptions and challenges, and proceeding accordingly" | | |
| Model formulation | "Formulating a well-defined one, knowing its assumptions" | | |
| Prediction against inference | "Interpreting it for prediction and inference" | | |
| Choosing among reasonable paths | Email: "more than one reasonable path" | | |
| Product intuition | "Product intuition with the numbers" | | |
| Communication and pragmatism | "Rigor that knows when to stop" | | |
| Hire signal | | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Framing | Starts from a method | Separates the questions being asked | Derives the comparison group from product reasoning, and splits forecast from attribution unprompted |
| Identification | Names a technique with no assumption attached | States the assumption and checks pre-trends when asked | Checks pre-trends unprompted, names biases in both directions, refuses a point estimate, proposes a second design that fails differently |
| Model formulation | Mediators in the model, or specification chosen by fit | Clean specification with real assumptions stated | Excludes mediators for the stated reason and says which question each version answers |
| Prediction against inference | Treats them as one problem | Says one model can't do both | Explains why every term that helps the forecast absorbs the treatment, and gives the forecast as scenarios |
| Choosing among paths | Picks on method alone | Picks and names both weaknesses | Asks what decision it feeds, says the choice may not matter, gets the bias directions right |
| Product intuition | Search traffic as one homogeneous thing | Vulnerability varies by query type | Knows what Quora is irreplaceable for and uses it as the design |
| Communication and pragmatism | Method before answer, reaches for a fancy model | Verdict first most of the time, simple model | Free decomposition before the causal work, and says when more precision would not change the call |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks, recorded separately.**

- Did he decompose clicks into impressions and CTR before proposing a causal design? Yes or no.
- Did he cross-check the regression coefficient against the difference-in-differences? Yes or no.
- Did he name a fancy model at any point, and did he say why he wasn't using it?

| Block | Target | Actual |
|---|---|---|
| 1. Framing and the product read | 4 min | |
| 2. Observational | 11 min | |
| 3. Non-standard design | 9 min | |
| 4. The model | 13 min | |
| 5. Two reasonable paths | 5 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Next cases for this folder

Premises only. Ranked on the guide's wording for this round.

| Rank | Premise | Why it is likely | What it would stress |
|---|---|---|---|
| 1 | Size a logged-in growth initiative that does not exist yet | "Sizing new initiatives" is a named team focus and nothing in the prep folder covers it | Estimation from assumptions, stating what you assumed, sensitivity rather than precision |
| 2 | Audit a recommender offline when the online test is underpowered | "Deep audits of ML systems," and the FAQ says you evaluate systems rather than build them | Offline against online, surrogate outcomes, what an offline metric can and cannot license |
| 3 | A model of writer retention where the outcome is rare and the population is tiny | Readers against writers is a live tension and the top 1% write half the answers | Rare events, heavy tails, whether a model is identified at all at that sample size |
| 4 | Two experiments on the same surface with interacting effects | "Non-standard experiment designs and setups," and Quora runs about 30 tests at once | Interaction, shared layers, what a factorial buys and what it costs |
