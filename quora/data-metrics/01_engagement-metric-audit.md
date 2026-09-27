# Case 01, the engagement metric that stopped working

A mock interview for the **Data Metrics** round of the Quora final round loop. 45 minutes, one file,
written in the order the interview happens. Each step has the interviewer's lines, what to listen
for, follow-ups, a model answer, traps and a score guide. Claude plays the interviewer. To practice
blind, stop reading after the context in Step 2.

All numbers are synthetic and were computed by script so every table agrees. Product mechanics
follow `product.md`. Statistics stay mid-level on purpose: this round is about metric judgment, not
estimation.

**This round is structured differently from cases 01 to 05.** Those follow the first-round shape:
context, design a test, read results, explain a movement. This round has no A/B test in it. It runs
design, then critique, then audit, then repair, on one metric. The rubric at the bottom is different
too, because the stated assessment criteria are different.

## Why this case

| Source | What it says | Where it shows up |
|---|---|---|
| Final round email | "How you pick the right measure for a goal, what you'd watch alongside it to catch unintended effects, and how you re-evaluate a metric when it stops telling you what you need to know" | Steps 2, 3 and 5. That sentence is the case's whole shape |
| Prep guide, Data Metrics | "Going deep in understanding a choice of metrics in a particular area of Quora" | One surface in Step 2, one company metric from Step 4 on |
| Prep guide, Data Metrics | "The interview digs deeper into one fairly complex metric" | VA/WAU, a weighted composite over a moving denominator |
| Prep guide, Data Metrics | Assessed on metric design and metric evaluation, including "what might lead the team to misleading conclusions" | Step 3 is critique of his own metric. Step 5 is a metric actively misleading the company |
| Prep guide, Data Metrics | Prep list names Goodhart's law and how measuring performance by numbers backfires | Step 6 asks what a team held to this metric would ship |
| Prep guide, the team | "Metrics are important at Quora in order to measure success and hold teams accountable" | The metric is a quarterly goal every team ladders up to |
| Prep guide, current focus | "Stabilizing and improving key engagement metrics" and "navigating AI's effect on search-driven traffic" | These are the same problem in this case, which is the point |
| Prep guide, what we look for | "Rigor that knows when to stop" and "a decision on the other end" | Step 6 wants a fix a Head of Data could take to the exec team on Monday |
| `product.md`, reported question | "Can you give a case where the click through rate goes up but Quora product is actually getting worse?" | The premise, moved up from a rate to a company metric |
| `product.md`, reported question | "What metrics can you come up with to measure user engagement?" | Step 2 |
| `product.md`, live tensions | Search dependence, engagement against quality, readers against writers | The three things the broken metric is hiding |

## Clock

| Step | Minutes | Scored on |
|---|---|---|
| 1. Warm-up | 4 | Experience and opinions |
| 2. Design a metric | 8 | Metric design, product intuition |
| 3. Break your own metric | 5 | Metric evaluation |
| 4. The company metric | 7 | Metric evaluation, absorbing context |
| 5. Why it stopped working | 12 | Diagnosis, metric evaluation |
| 6. Fix it | 6 | Accountability and incentives, communication |
| 7. Your questions | 3 | Not scored |

## How Claude runs it

- Default is a full mock. Stay in character as a Quora data scientist. No teaching or grading until the end.
- Say each step's opening line, then let him answer. At most two follow-ups per step, picked for what he missed.
- Paste context, tables and data cuts exactly as written, and only when the step or his request calls for them.
- In Step 5, release a cut only when a request maps to it. A vague request gets "What exactly would you
  look at, and what would you expect to see?"
- Don't lead. No hint about which diagnosis is right, and no reaction to a wrong one beyond releasing
  what was asked for.
- Record the time with `date` at each step. Move on when a step runs a minute or two past target.
- If he says "pause," give short feedback on the current step, then resume.
- If he asks for a fact the file doesn't have, answer consistently with the case, then add it afterward.
- At the end, debrief with the scorecard. Scores per criterion, a hire signal, the three most important
  fixes, and the model answer for any step scored 6 or below.

---

## Step 1, warm-up

About 4 minutes. Real interviewers compress this. If he runs long, cut to one question.

**Interviewer.** "Thanks for making the time. I want to spend most of today on metrics, so let me
start there rather than with your background."

**Q1.** "Tell me about a metric you've worked with that you didn't trust. What was wrong with it,
and what did you do?"

- Listen for a specific metric, a specific mechanism of failure, and an action. Not "metrics can be
  gamed" in the abstract.
- The Farmers work is the obvious source. Top-decile lift is a separation metric, and separation is
  not the same as the business outcome of the marketing campaign it fed.
- An academic example works if it is concrete. A model selection criterion that rewarded the wrong
  thing, or a fit statistic that improved while the inference got worse.

**Q2.** "Who at a company should own the definition of a top-line metric, and who should be allowed
to change it?"

- Listen for a position, not a process diagram. Data owns the definition, the business owns the target,
  and changes are versioned, announced, and backfilled so the history stays readable.
- Strong answer names the tension: if the team held accountable to a metric can also redefine it, the
  metric is decorative. If nobody can change it, it rots. Both failures are in this case.

**Follow-ups.** "What did that cost?" "How would you have known sooner?"

**Score.** 4 is generic with no example. 6 is a real example with a named failure mechanism. 8 adds
a position on ownership and names what that position costs.

---

## Step 2, design a metric

About 8 minutes.

**Interviewer.** "I'm going to give you a surface and ask you to build a measure of goodness for it.
Here's the context."

> ### Context, the logged-out question page
>
> Most people who read Quora are not logged in. They arrive on a question page from a Google result,
> read, and leave. This is the largest surface Quora has and the one we understand least.
>
> **What the page is.** One question, a ranked list of answers, related questions in a rail, and ads.
> The first answer is expanded. The rest are collapsed behind "Read more." A sign-up prompt appears
> after some scrolling.
>
> **What we can observe.**
>
> | Signal | Notes |
> |---|---|
> | Page view, referrer, query where Google passes it | Reliable |
> | Scroll depth, per answer and per page | Reliable |
> | Dwell time on page, and time with the tab in focus | Reliable, though app and web instrument it differently |
> | Expands on collapsed answers | Reliable |
> | Click to a related question or another Quora page | Reliable |
> | Return to the search results page within the session | Observable when the browser reports it, about 80% of sessions |
> | Sign-up | Reliable |
> | Return visit within 30 days | Cookie-based. Roughly 40% of mobile sessions have no usable cookie after 7 days |
> | Upvote, share, comment | Requires an account. Essentially absent on this surface |
>
> **Scale, most recent quarter.** About 231M question-page sessions a month from search. About 76% on
> mobile web. About 88% of sessions are a single page. Median time on page is 48 seconds. About 0.83M
> new accounts a month originate here.
>
> **The constraint.** Whatever you propose has to be computable daily from event logs for every session,
> with no survey and no change to the page.

**Interviewer, after he has read it.** "How would you measure whether this surface is doing its
job?"

**Listen for.**

- The goal stated before the metric. The reader came with a question and either got an answer worth
  their time or did not.
- One primary, a small number of secondaries, and guardrails. Not a list of twelve candidates.
- Design inside the constraint. No login means no upvotes, so the usual engagement vocabulary is gone.
- An explicit statement of what he is giving up by choosing this metric.

**Strong signals.**

- **Using the negative signal.** Returning to the search results quickly is the most reliable evidence
  Quora has that the page failed, and it is the standard search-quality measure. Absence of a return is
  weaker evidence of success, because the tab may simply have been closed.
- **Normalizing dwell by content length.** Raw dwell rewards long answers. Reading speed against the
  length of the answer that was actually on screen is the honest version.
- **Saying that a rate needs a total next to it.** A satisfaction rate per session can rise while the
  number of satisfied sessions falls, and on a shrinking surface that is the likely case.
- **Refusing sign-up as the primary.** Sign-up measures Quora's interest, not the reader's, and
  optimizing it leads straight to a more aggressive wall.
**Follow-ups.**
| Follow-up | Answer |
|---|---|
| "Why not time on page?" | It cannot tell reading from confusion, and it rewards long answers and slow pages. It is a secondary that needs a length normalization and a quality signal next to it |
| "Why not sign-up rate? That's what the company wants." | It is a company outcome, not a reader outcome, and a metric that rises when we make the wall harsher is a metric that will make the wall harsher. Report it, don't steer on it |
| "About 20% of sessions don't report whether the user went back to search. What do you do?" | Report the metric on the 80% where it is observable and check that the missing 20% isn't a distinct population, mostly Safari and iOS. If it is, the metric is browser-biased and I would say so on the dashboard rather than impute it |
| "Give me the scrappy version I can have this week." | Share of question-page sessions with at least one answer read to completion, and short-return-to-search rate as the counterweight. Both are computable from existing events today |
| "Say we ship your metric and it comes back at 34%. Is that good?" | On its own it is not anything, it is a baseline. To mean something it needs one of three things: the same metric on a surface we already believe works, so I have an internal yardstick; its value on cohorts of pages we independently judged good and bad, which turns it into a calibrated scale; or its movement across a past launch whose verdict we already know. Until one of those exists I would report it as a baseline and refuse to attach a target, because a target on an uncalibrated metric is how a team ends up optimizing a number nobody can interpret |

**Model answer.** "The page's job is that someone who arrived with a question leaves with an answer
worth their time. I'd make the primary the share of question-page sessions that contain at least one
satisfied read, where a satisfied read is reaching the end of an answer with dwell consistent with
actually reading it for that answer's length. I'd pair it with a counterweight, the share of
sessions that return to the search results within about 30 seconds, because that is the one signal
that tells me directly the page failed. Secondaries would be answers read per session,
related-question click rate, and depth beyond the first answer, which tell me why the primary moved.
Guardrails are page latency, ad density, and sign-up prompt dismissals. I'd report the rate and the
absolute count of satisfied sessions side by side, because the rate can improve while the surface
shrinks, and on this surface it probably is shrinking. What I'm giving up is that I cannot see
whether the answer was correct. Dwell and scroll measure attention, not truth, and nothing in the
logs fixes that."

**Traps.**

- Proposing a composite score in the first minute, before a single simple measure has been defended.
  This is his documented failure mode and it fires here.
- Listing eight candidate metrics without picking one.
- Ignoring the constraint and proposing a survey or a thumbs-up widget.
- Sign-up rate or ad revenue as the primary.

**Score.** 4 is a metric that could apply to any website, or a list with no choice made. 6 has a
defensible primary tied to this surface, with secondaries and guardrails. 8 names the measurement
constraint before the metric, uses the return-to-search signal, and says what the metric
deliberately cannot see.

---

## Step 3, break your own metric

About 5 minutes. This step is scored hardest against the guide's "can you proactively see what might
be wrong with a metric." If he already did most of this unprompted in Step 2, say so and move
faster.

**Interviewer.** "Suppose we adopt exactly what you proposed and put a team's quarterly goal on it.
It's twelve months later and the number is up 15%. Tell me every way that could have happened
without readers being better off."

**Listen for.** Failure modes in different families, not five versions of one idea. The families:

| Family | Example on his metric |
|---|---|
| Denominator | Fewer low-intent sessions arrive, so the rate rises while satisfied sessions fall |
| Threshold | Answers got shorter, so "read to completion" became an easier bar for the same behavior |
| Instrumentation | The app and web measure dwell differently, and the mix between them moved |
| Gaming | The team shortens answers, truncates aggressively, or reorders to put a quick answer first |
| Population | Cookie loss means the measured population skews to Chrome and Android |
| Goal conflict | Reducing return-to-search can be achieved by making the back button worse, not the page better |

**Strong signals.**

- Naming the denominator problem first. It is the largest and it is the one that fires in Step 5.
- Noticing that "read to completion" is a function of answer length, which the writer, the ranker and
  an AI summarizer all move.
- Saying which of these he would actually instrument against, rather than listing all six as equal.
  Rigor that knows when to stop is an explicit criterion for this loop.

**Follow-up.** "Rank those. If you could only put one check on the dashboard next to the metric,
which?"

- The answer is the absolute count next to the rate, plus the session mix by referrer. That catches the
  denominator failure, which is both the most likely and the most damaging.

**Model answer.** "The biggest one is the denominator. If Google sends us fewer casual clicks, the
sessions we lose are the ones least likely to contain a satisfied read, so the rate rises while the
number of satisfied readers falls. That is a rise I'd have to report as a decline. Second, the
threshold moves under me: 'read to completion' depends on answer length, and if answers get shorter,
the same reading behavior clears a lower bar. Third, instrumentation, since app and web log dwell
differently and the mix between them shifts. Fourth, gaming, because a team held to this would learn
that shorter answers and a faster first answer move it, which is fine up to the point where it
becomes truncation. And the return-to-search counterweight has a nasty version, which is that it
improves if the reader gives up entirely and closes the tab. The one check I'd put next to the
metric is the absolute count of satisfied sessions and the session mix by referrer, because that
catches the denominator failure, which is the most likely of these and the one that would survive
longest before anyone noticed."

**Traps.**

- Defending the metric instead of attacking it. The question is an invitation, not a challenge.
- Listing failure modes without ranking them.
- Treating gaming as the main risk. It is the most discussed and the least likely to be the actual cause.

**Score.** 4 defends the metric or names one generic failure. 6 names several real failure modes
across families. 8 ranks them by how likely each is to mislead a real decision, and picks one check
to ship.

---

## Step 4, the company metric

About 7 minutes.

**Interviewer.** "Good. Now let me show you the metric we actually run the company on, and I want
your read on it."

> ### Context, VA/WAU
>
> **Definition.** Value Actions per Weekly Active User, reported as a four-week trailing average.
>
> The numerator is a weighted count of actions taken by logged-in users in a week.
>
> | Action | Weight |
> |---|---|
> | Dwell-qualified read, an expand followed by 20 or more seconds | 1 |
> | Upvote | 4 |
> | Share | 6 |
> | Comment | 6 |
> | Answer written | 20 |
> | Question asked | 10 |
>
> The denominator is logged-in weekly active users, defined as a logged-in user who loads any Quora
> surface during the week.
>
> **Where the weights came from.** A 2021 analysis regressed 90-day retention on action counts and
> scaled the coefficients so that a dwell-qualified read equals 1. The same relative weights are used
> in the home feed ranker's scoring function. The weights have not been re-fit since.
>
> **How it is used.** Every product team's quarterly KRs ladder up to VA/WAU. The current company goal
> is VA/WAU up 4% quarter over quarter. It appears in the board deck.

**Interviewer.** "Before I show you any numbers. What do you think of this metric?"

**Listen for.**

- The population. It is logged-in only, and Quora's readership is overwhelmingly logged out. The largest
  surface in the company is invisible to the metric that runs the company.
- The ratio. A per-user average over a denominator that moves for reasons unrelated to the product.
- The weights being shared with the feed ranker. The metric and the thing it is supposed to referee
  optimize the same objective, so a ranking launch moves the metric by construction.
- The weights being five years stale and never re-fit, while the product and the user base changed.
- Heterogeneity in the numerator. Answers weigh 20 but about 2% of users write in a month and the top
  1% write about half of all answers, so a heavily weighted component is driven by a handful of people.

**Strong signals.**

- Getting to the logged-out blind spot unprompted. It is the single largest problem and it connects to
  the thing the company is actually worried about.
- Naming the circularity between the metric and the ranker in plain language: "we grade the feed on the
  feed's own scoring function."
- Asking what happened to the metric's components rather than accepting the headline.
- Asking what a team is supposed to do with it. A composite tells you a direction, not an action.
**Follow-ups.**
| Follow-up | Answer |
|---|---|
| "The weights came from a retention regression. Isn't that principled?" | It was, in 2021, for the users and the product of 2021. Retention weights are a snapshot of a correlation, not a constant of nature, and nothing has re-checked them since. It is also observational, so the weights describe what engaged users do, not what makes users engaged |
| "What's wrong with a composite? It stops teams optimizing one thing." | It stops them optimizing one thing visibly. A composite can move entirely from its cheapest component and still look like broad health, and a single number cannot tell you which component moved. I'd want it reported with its decomposition attached, always |
| "We can't measure logged-out users the way we measure logged-in ones. Isn't excluding them the honest choice?" | Excluding them from the numerator is defensible. Excluding them from the company's view is not. If the headline metric cannot see the largest surface, the company needs a second number next to it, even a cruder one |

**Model answer.** "Three things stand out before any data. First, it only sees logged-in users, and
most of Quora's readers are not logged in, so our top-line metric is blind to our largest surface.
That matters more than usual right now, because if search traffic is what's changing, it changes the
logged-out side first and reaches this metric only indirectly. Second, it's a ratio with a
denominator that moves for reasons that have nothing to do with whether the product got better. If
the users we lose are the light ones, the average rises. Third, the weights are the feed ranker's
weights, which means we're grading the feed against its own objective function, and they were fit in
2021 and never re-checked. I'd also flag that a weight of 20 on answers sits on an action about 2%
of users take, so a large slice of the numerator rides on a very small group. I'd want to see the
metric decomposed before I trusted its direction."

**Traps.**

- Admiring the metric. A weighted composite with a retention justification is designed to look rigorous.
- Going straight to "it can be gamed." Gaming is real here but it is not the top problem.
- Missing the logged-out population entirely.

**Score.** 4 accepts it or critiques only the weights. 6 names the ratio problem and the stale
weights. 8 gets to the logged-out blind spot and the circularity with the ranker unprompted, and
asks for the decomposition before forming a view.

---

## Step 5, why it stopped working

About 12 minutes. The core of the round.

**Interviewer.** "Here's the last six quarters. Every team has hit its VA/WAU goal, five quarters
running. Leadership is asking why the company doesn't feel like it's growing."

> | Quarter | VA/WAU | QoQ |
> |---|---|---|
> | 2025 Q1 | 23.50 | |
> | 2025 Q2 | 23.89 | +1.7% |
> | 2025 Q3 | 24.68 | +3.3% |
> | 2025 Q4 | 25.40 | +2.9% |
> | 2026 Q1 | 26.27 | +3.4% |
> | 2026 Q2 | 27.10 | +3.1% |
>
> Up 15.3% over six quarters.

**Interviewer.** "What's your read, and what do you want to look at?"

**Listen for.**

- Asking for the denominator immediately. A ratio moving with no context is not information.
- Naming hypotheses in families before asking for data, and predicting what each cut should show.
- Updating out loud after each cut.
- Getting to a verdict, not an investigation plan.

**Hypotheses a strong candidate raises.**

| Family | Hypothesis | Cut | What it shows |
|---|---|---|---|
| Denominator | The user base shrank and the lost users were light ones | A | Confirms. The whole story |
| Same-user | Individual users genuinely engage more | B | Refutes. Fixed cohort is down 7% |
| Numerator | The rise is carried by one cheap component | C | Confirms. Upvotes, the overweighted action |
| Population | The damage is on a surface the metric can't see | D | Confirms. Logged-out funnel down hard |
| Measurement | The dwell threshold or logging changed meaning | E | Partly. Makes the true decline worse, not better |
| Product | A launch caused a real improvement | F | Refutes. The rise is smooth with no step |

**Data cuts.** Release each only when he asks for something that maps to it.

**Cut A, the denominator.** Release when he asks about WAU, the user base, total volume, or asks to
decompose the ratio.

> | Quarter | Logged-in WAU | Total VA per week | VA/WAU |
> |---|---|---|---|
> | 2025 Q1 | 12.00M | 282.0M | 23.50 |
> | 2025 Q2 | 11.37M | 271.6M | 23.89 |
> | 2025 Q3 | 10.53M | 259.9M | 24.68 |
> | 2025 Q4 | 9.65M | 245.1M | 25.40 |
> | 2026 Q1 | 8.75M | 229.9M | 26.27 |
> | 2026 Q2 | 8.00M | 216.8M | 27.10 |
>
> Split by how the user's sessions typically start:
>
> | Segment | WAU 2025 Q1 | WAU 2026 Q2 | VA per user 2025 Q1 | VA per user 2026 Q2 |
> |---|---|---|---|---|
> | Core, app, direct or notification | 6.00M | 5.40M | 38.0 | 36.0 |
> | Search-arriving logged-in | 6.00M | 2.60M | 9.0 | 8.6 |

Read. WAU fell 33% and total VA fell 23%. The ratio rose because the segment that left was the
low-engagement one, which was half the logged-in base and is now a third. Within each segment, VA
per user fell. The metric rose because of who left, not because of anything anyone shipped.

**Cut B, fixed cohort.** Release when he asks whether the same users engage more, or asks for a
cohort or same-user view.

> Users active in all six quarters, about 3.8M.
>
> | | 2025 Q1 | 2026 Q2 |
> |---|---|---|
> | VA per user per week | 44.2 | 41.1, -7.0% |

Read. Hold the population fixed and engagement is down 7%. There is no version of this data in which
individual users are getting more out of Quora.

**Cut C, what the numerator is made of.** Release when he asks which actions drive VA, or asks to
decompose the numerator. Core segment only, so mix is already removed.

> | Action | Weight | Count 2025 Q1 | VA | Count 2026 Q2 | VA | Change in count |
> |---|---|---|---|---|---|---|
> | Dwell-qualified read | 1 | 21.50 | 21.50 | 17.66 | 17.66 | -17.9% |
> | Upvote | 4 | 2.70 | 10.80 | 3.20 | 12.80 | +18.5% |
> | Share | 6 | 0.30 | 1.80 | 0.31 | 1.86 | +3.3% |
> | Comment | 6 | 0.38 | 2.28 | 0.42 | 2.52 | +10.5% |
> | Answer written | 20 | 0.042 | 0.84 | 0.032 | 0.64 | -23.8% |
> | Question asked | 10 | 0.078 | 0.78 | 0.052 | 0.52 | -33.3% |
> | **Total** | | | **38.00** | | **36.00** | |
>
> Upvotes as a share of VA: 28.4% to 35.6%. Writing as a share of VA: 4.3% to 3.2%.

Read. Reading is down 18%, answers down 24%, questions down 33%. The only thing up is upvotes, the
cheapest action to take and the second most heavily weighted. There is a second lesson in the VA
column. Writing carries the heaviest weights in the definition and contributes about 4% of the
metric, because almost nobody writes. So the metric announces that it values supply and is
structurally incapable of reacting when supply falls by a quarter. A single number hid a supply
collapse behind a tapping increase.

**Cut D, the surface the metric can't see.** Release when he asks about logged-out users, search
traffic, or the top of the funnel.

> Monthly, logged-out question pages from search:
>
> | | 2025 Q1 | 2026 Q2 |
> |---|---|---|
> | Question-page sessions from search | 392M | 231M, -41% |
> | Sessions reaching a second page | 11.4% | 10.2% |
> | New account sign-ups originating here | 1.62M | 0.83M, -49% |
> | Sign-ups per 1,000 search sessions | 4.13 | 3.59, -13% |

Read. The funnel is both smaller and worse. Sign-ups fell faster than sessions, so the surface is
converting less well on top of receiving less. None of this appears anywhere in VA/WAU, and it is
the direct cause of the logged-in decline one step later.

**Cut E, measurement check.** Release when he asks about logging, the dwell threshold, or app
against web.

> | | 2025 Q1 | 2026 Q2 |
> |---|---|---|
> | Median answer length on question pages | 1,180 chars | 890 chars |
> | Share of expands crossing 20 seconds | 34.1% | 36.8% |
> | Share of expands reaching the end of the answer | 28.5% | 24.0% |
> | App share of logged-in sessions | 58% | 66% |
>
> The app logs dwell on the expanded card. Web logs dwell against scroll position. For identical
> content the app records about 12% more dwell.

Read. This does not rescue the metric, it indicts it further. Answers got shorter, so 20 seconds is
a looser bar than it was, and the app now makes up more of the mix and reads high. The
dwell-qualified read count is flattered on both counts, while the share of expands actually
finishing an answer fell from 28.5% to 24.0%. True reading is down by more than the 18% in Cut C.

**Cut F, launch timeline.** Release when he asks whether a launch caused it, or asks about the shape
of the trend.

> | Quarter | Notable launches | VA/WAU QoQ |
> |---|---|---|
> | 2025 Q2 | Digest frequency controls | +1.7% |
> | 2025 Q3 | Space posts added to digest | +3.3% |
> | 2025 Q4 | Feed ranker v9 | +2.9% |
> | 2026 Q1 | AI answer labels on question pages | +3.4% |
> | 2026 Q2 | Related-questions model refresh | +3.1% |

Read. Refutes the product explanation. The rise is smooth and uncorrelated with any launch, which is
what a mix shift looks like and what a product win does not.

**Model answer, before the data.** "A per-user ratio rising 15% while the company doesn't feel like
it's growing has three candidate explanations and I'd rank them. Most likely, the denominator moved:
we lost users, and the ones we lost were light, so the average went up mechanically. Second, the
numerator is being carried by one cheap component. Third, and least likely, it's real. I'd ask for
WAU and total VA first, because if WAU is down and total VA is down, nothing else matters much and
the rest is detail. Then a fixed cohort, to see whether any real person is doing more. Then the
numerator by action type. I'd also want the logged-out funnel, because if search traffic is falling,
that's upstream of everything here and the metric can't see it."

**Model answer, after the cuts.** "The metric is measuring the wrong thing and has been for at least
six quarters. WAU is down 33% and total value actions are down 23%. VA/WAU rose because the users we
lost were search-arriving light users, who were half our logged-in base and are now a third, so the
average of who's left is higher. Hold the population fixed and engagement is down 7%. Inside the
core segment, reading is down 18%, answers down 24%, questions down 33%, and the only thing that
grew is upvotes, which happens to carry a weight of 4. Writing has the heaviest weights and
contributes about 4% of the number, so the metric cannot move when supply collapses. And the dwell
threshold got easier as answers got shorter, so the reading decline is understated. Upstream, search
sessions are down 41% and sign-ups from them down 49%. So the honest summary is that the company is
shrinking, supply is contracting faster than demand, and the top-line metric went up every quarter
while it happened. Every team hit its goal, and the goal was measuring the composition of our user
base rather than the health of the product."

**Traps.**

- Accepting the headline and looking for what caused a genuine improvement.
- Asking for every cut at once instead of saying what each should show.
- Finding the mix shift and stopping there, without the numerator decomposition or the logged-out funnel.
- Treating Cut E as exculpatory. It makes the picture worse.
- Calling it "a Goodhart problem" and moving on. Nobody gamed this metric. It broke on its own, which
  is the harder and more common case.

**Score.** 4 accepts the trend or guesses without asking for the denominator. 6 finds the mix shift
and asks for a cohort view. 8 predicts what each cut should show before seeing it, gets the
denominator first, connects the logged-out funnel to the logged-in decline as cause and effect, and
states plainly that the company shrank while the metric rose.

---

## Step 6, fix it

About 6 minutes.

**Interviewer.** "I have to take something to the exec team on Monday. What do I tell them, and what
do we measure instead?"

**Material.** Release the re-fit if he asks whether the weights still hold.

> The 2021 retention regression, re-run on 2026 data:
>
> | Action | Weight in use | Re-fit |
> |---|---|---|
> | Dwell-qualified read | 1 | 1 |
> | Upvote | 4 | 1.4 |
> | Share | 6 | 3.1 |
> | Comment | 6 | 5.8 |
> | Answer written | 20 | 24 |
> | Question asked | 10 | 7 |
>
> Applying the re-fit weights to the core segment: 29.97 in 2025 Q1 to 26.67 in 2026 Q2, an 11.0%
> decline, against the 5.3% decline the current weights report.

**Listen for.**

- A verdict in the first sentence, then the reasoning. This loop names "a decision on the other end" as
  an explicit criterion.
- A fix that separates the two distinct failures: the ratio should never have been a headline, and the
  population was wrong.
- Something shippable this week alongside the proper redesign.
- A view on incentives. What does a team held to the new metric do, and is that what Quora wants?

**Strong signals.**

- **Report the total, not only the rate.** Total weekly value actions, and logged-in WAU, as two
  separate headline numbers. Most of the damage came from compressing them into one.
- **Add a logged-out number to the top line.** Even a crude one, such as satisfied question-page
  sessions per month from Step 2, so the largest surface is visible in the board deck.
- **Split supply from demand.** Answers and questions written should not sit inside a reader engagement
  metric at all. Writing is about 4% of VA despite the heaviest weights, so a 24% collapse in answers
  moves the headline by almost nothing. A weight cannot fix that. Writing supply needs to be a separate
  health metric with its own target.
- **Re-fit the weights on a schedule,** and break the shared definition with the feed ranker so the
  metric can referee ranking changes instead of inheriting their objective.
- **Naming the incentive change honestly.** A team held to total value actions has to grow the user
  base or deepen usage, and can no longer be rewarded for losing light users.

**Follow-ups.**
| Follow-up | Answer |
|---|---|
| "If we switch, every team misses its goal this quarter. How do you handle that?" | Backfill the new metric over the last six quarters and reset targets against that history, so nobody is punished for a definition change. The retro also tells you which teams were genuinely delivering, which is worth knowing |
| "Can't we just keep VA/WAU and add a segment breakdown?" | The breakdown is necessary either way, but the headline number is what goes in the board deck and what sets targets. If the headline is still a ratio over a moving denominator, the same thing happens again |
| "Isn't a single number the point? Execs want one number." | Then make it the total rather than the average, because the total cannot rise by losing users. Two numbers, logged-in and logged-out, is the minimum this company can honestly report |
| "What would have caught this earlier?" | A standing rule that every ratio reported to leadership carries its numerator and denominator next to it, and a scheduled re-validation of the weights. Both are cheap. The second one is the kind of framework this team says it wants |

**Model answer.** "The headline is that the metric has been reporting the opposite of what happened.
The company lost a third of its logged-in weekly actives and 23% of total value actions over six
quarters, and VA/WAU rose 15% because the users who left were the light ones. What I'd change is
three things. Replace the ratio with two numbers, total weekly value actions and logged-in WAU,
reported side by side, because a total can't rise by losing users. Add a logged-out number to the
top line, even a crude one, since the largest surface in the company is currently invisible in the
board deck and it's where the decline starts. And pull writing out of the composite entirely.
Answers are down 24% and questions down 33%, and writing is only about 4% of VA despite carrying the
heaviest weights, so the metric is incapable of reacting to a supply collapse no matter how the
weights are set. Separately, the weights need re-fitting. On 2026 data upvotes are worth 1.4, not 4,
and under re-fit weights the core decline is 11.0% rather than 5.3%, so the stale weights were
hiding about half of it. I'd backfill the new metrics over the six quarters and reset targets
against that history, so teams aren't penalized for a definition change. The thing I'd say to the
exec team beyond the numbers is that nobody gamed this. The metric broke quietly while everyone
behaved well, which is the argument for putting a re-validation date on it rather than trusting the
next one to hold."

**What pushes it to an 8.**

- The framework contribution stated as a rule, not a one-off. Every ratio in an exec report carries its
  numerator and denominator. That is the "tooling and methodology" 20% of this job.
- Handling the awkward organizational fact directly. Six quarters of goals were met on a broken metric,
  and how you reset that without punishing anyone is part of the answer.
- Knowing when to stop. He does not need a new composite with better weights. He needs fewer composites.

**Traps.**

- Proposing a new, more sophisticated composite. That is the same mistake with better arithmetic, and
  it is his documented over-engineering reflex.
- Fixing the weights and leaving the ratio and the population alone. The weights are the third-largest
  problem here, not the first.
- No verdict. An investigation plan is not what a Head of Data needs on Monday.
- Forgetting that someone has to explain six quarters of met goals.

**Score.** 4 proposes a new metric with no diagnosis behind it, or only re-fits the weights. 6
replaces the ratio with a total and adds guardrails. 8 fixes the population, splits supply from
demand, gives a standing rule that prevents the next one, and handles the target reset.

---

## Step 7, your questions

About 3 minutes. Not scored, but this round is run by a data scientist who lives with these metrics.

- "What's the top-line metric here today, and when was the last time someone seriously challenged it?"
- "When search traffic moves, how long does it take to show up in the metrics the teams are held to?"
- "Who can change a metric definition, and what does that process look like?"
- "How does the team measure the logged-out side, given most readers never sign in?"

---

## Scorecard

Filled in during the debrief. Criteria differ from cases 01 to 05, matching the stated assessment
for this round: metric design, metric evaluation, and the three qualities in the prep guide.

| Criterion | Score | Evidence |
|---|---|---|
| Metric design, Step 2 | | |
| Metric evaluation, Steps 3 and 4 | | |
| Diagnosing a broken metric, Step 5 | | |
| Accountability and incentives, Step 6 | | |
| Product intuition | | |
| Communication and pragmatism | | |
| Hire signal | | |
| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Metric design | Could apply to any app, or no choice made | Defensible primary tied to the surface, with secondaries and guardrails | Names the measurement constraint first, designs inside it, says what the metric cannot see |
| Metric evaluation | Defends a metric when challenged | Names real failure modes when asked | Breaks it before being asked and ranks failures by how likely each is to mislead a decision |
| Diagnosing a broken metric | Accepts the trend, or guesses without data | Decomposes into mix and rate, asks for the right cut | Asks for the denominator first, predicts each cut, connects logged-out cause to logged-in effect |
| Accountability and incentives | No view on how teams respond | Notes Goodhart in general terms | Says what a team held to the metric ships, and designs the fix to remove that incentive |
| Product intuition | Generic engagement talk | Ties choices to Quora's actual loop | Connects the metric problem to Quora's search dependence unprompted |
| Communication and pragmatism | Method before answer, over-engineers | Verdict first most of the time | Verdict first every time, simple before rigorous, names when more precision would not change the call |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

| Step | Target | Actual |
|---|---|---|
| 1. Warm-up | 4 min | |
| 2. Design a metric | 8 min | |
| 3. Break your own metric | 5 min | |
| 4. The company metric | 7 min | |
| 5. Why it stopped working | 12 min | |
| 6. Fix it | 6 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Next cases for this folder
Premises only, so nothing is spoiled. Ranked on the same evidence rules as `case-format.md`.
| Rank | Premise | Why it is likely | What it would stress |
|---|---|---|---|
| 1 | Design a quality metric for AI-generated answers shown next to human answers | The guide names deep ML audits and AI's effect on search as current focus. `product.md` lists human against AI answers as a live tension | Measuring correctness rather than engagement, no ground truth, rater cost, long-run writer supply |
| 2 | A single metric for the Quora+ adaptive paywall, where reach and earnings trade off | A real mechanism in `product.md`, and a genuinely two-sided metric | Metrics with a built-in tradeoff, whose objective gets encoded, writer against reader |
| 3 | Choose the metric for a home feed team whose only lever is ranking | Their most likely "particular area of Quora" | Metric independent of the ranker's own objective, the circularity trap head on |
| 4 | A north star for new-user activation when personalization has no history | New against tenured is a named tension | Surrogate metrics, short windows, survivorship in activation rates |
