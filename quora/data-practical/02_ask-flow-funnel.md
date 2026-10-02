# Case 02, did the new duplicate suggestions help or just stop people asking

A mock interview for the **Data Practical** round. 60 minutes, live, in R in Google Colab, open book.
Claude plays the interviewer. To practice blind, stop reading after the brief in Task 0 and open the data.

**Base R only.** No tidyverse in any case in this folder. `install.packages` in Colab R costs minutes you
do not have, and the exercise is about your data reasoning rather than your dialect. Everything in the
reference solutions runs on a bare R 4.3 install.

## What this case adds over case 01

Case 01 gave three pre-aggregated tables and a continuous outcome. This one is a different set of routines,
which is the point of having two.

| | Case 01 | Case 02 |
|---|---|---|
| Data shape | Three tables, one row per unit | An **event log**, one row per event, that you have to roll up |
| Outcome | A count per writer, heavy-tailed | A **proportion** through a multi-step funnel |
| Tests | `t.test`, `wilcox.test`, `lm` | `prop.test`, `chisq.test` |
| The planted bug | Duplicate and extra rows | **Missing rows, non-randomly** |
| The trap | A ratio whose denominator the treatment moved | A denominator taken from the wrong table |
| The product inversion | A flattering ratio | **A funnel step whose failure is the feature working** |

**Why it is product sense forward.** The funnel's last step is posting a question, and the treatment is
designed to stop some people posting, because a person who finds their answer in a suggestion did not need
to ask. So a decline in the final step is both the risk and the intended effect, and no amount of careful
measurement resolves which one you are looking at. That has to come from deciding what the asker wanted.

**Four things are planted.** Do not read this before practicing.

<details>
<summary>Planted problems (spoiler)</summary>

1. On iOS, the treatment arm logs `ask_open` only after the suggestion model returns, so treatment users who
   bail in the first couple of seconds never log it. Assignment is server-side and complete; the client
   funnel's top step is not. **Using `ask_open` as the denominator flips the sign of the headline result.**
2. `events.csv` is the platform-wide log: 1,900 rows belong to users outside the experiment, and some
   `ask_reopen_7d` events fall after the experiment window by design.
3. `chars_typed` is `NA` for about 2,400 typed events because the counter fails on web. `mean()` returns `NA`.
4. The obvious segmentation variable, `chars_typed`, is post-treatment. `prior_questions_90d` and `platform`
   are the clean ones.

Problem 1 changes the answer and reverses its direction. Problem 2 has a subtle half: filtering the log to
the 14-day window silently breaks the 7-day re-ask lookahead.
</details>

## Clock

| Task | Minutes | Assessed on |
|---|---|---|
| 0. The brief | 4 | Framing |
| 1. Load, grain, and where the denominator comes from | 13 | Data manipulation |
| 2. Build the funnel and read it | 12 | Data manipulation, statistical tests |
| 3. Find out why the arms disagree | 13 | Data intuition |
| 4. The right outcome | 13 | Data intuition, metric choice |
| 5. Recommendation | 5 | Communication |

## How Claude runs it

- Interrupt and ask "why that denominator" the first time he computes a rate. That single question is most
  of the case and he should have an answer ready.
- **Do not point at the platform split.** If he never finds it, let him report a sign-flipped result and ask
  in Task 5 how confident he is.
- Answer syntax questions directly. Open book means open book.
- Silence is fine. Do not fill it.
- If he is more than 4 minutes behind at the end of a task, give him the number and move on.
- At the end, debrief with the scorecard and diff his code against the reference.

---

## Task 0, the brief

About 4 minutes.

**Interviewer.** "A test finished on the Add Question flow. The person who ran it says it was flat and moved
on. I want a second read. Two files."

> ### Brief
>
> **The flow.** A user opens the Add Question window and starts typing. While they type, Quora shows similar
> existing questions. They can click one of those, or post their question, or leave.
>
> **The change.** A better duplicate-suggestion model. The thesis is that the old one surfaced weak matches
> that people ignored, so real duplicates got posted again.
>
> **The experiment.** Users randomized 50/50 **server-side, at the moment the Add Question window is
> requested**. Ran 14 days, 2026-09-01 to 2026-09-14 inclusive.
>
> **What the team wants.** Ship it or not.
>
> ### Files
>
> `assignments.csv`, one row per assignment
>
> | Column | Meaning |
> |---|---|
> | assignment_id | The assignment |
> | user_id | Who |
> | arm | control or treatment |
> | platform | ios, android or web |
> | prior_questions_90d | Questions this user asked in the 90 days before the test |
> | assigned_ts | When the window was requested |
>
> `events.csv`, one row per event
>
> | Column | Meaning |
> |---|---|
> | event_id | The event |
> | user_id | Who |
> | event_name | One of `ask_open`, `ask_type`, `suggest_shown`, `suggest_click`, `ask_post`, `ask_reopen_7d` |
> | event_ts | When |
> | platform | Client that logged it |
> | chars_typed | Characters typed, on `ask_type` rows |
>
> `ask_reopen_7d` fires when a user opens the Add Question window again within 7 days of a suggestion click.

**Interviewer.** "Before you load anything. What's the outcome, and what's the denominator?"

**Listen for.**

- **The denominator comes from `assignments.csv`, not from the funnel's first event.** Everyone randomized
  belongs in the denominator, whatever they did afterwards, because that is what randomization gives you.
  A funnel computed off its own first step conditions on a post-randomization event. Saying this before
  opening the files is the single strongest opening available, and it is exactly what the case is built on.
- **A guess at the mechanism, and a worry about it.** The treatment should raise suggestion clicks. It may
  also lower posts, and that is ambiguous: a person who found their answer did not need to ask, and a person
  who gave up did. The same number covers both.
- Naming the outcome he would actually judge it on, which should not be posting.

**Traps.** Naming post rate as the outcome without hesitation. Planning to compute the funnel from
`ask_open`. No view on what a lost post means.

**Score.** 4 takes post rate as the goal. 6 names the ambiguity in a falling post rate. 8 also insists the
denominator comes from the assignment table, before seeing any data.

---

## Task 1, load, grain, and where the denominator comes from

About 13 minutes.

**What is there to find.**

| Check | Result |
|---|---|
| `assignments.csv` rows against unique `user_id` | 50,000 and 50,000. One row per user, clean |
| Arm split | 25,000 and 25,000. Exact, because assignment is server-side |
| `events.csv` rows | 144,600 |
| Event users not in the experiment | 1,900 |
| Events before the window | 0 |
| Events after the window | 134, all `ask_reopen_7d` |
| `mean(chars_typed)` on `ask_type` rows | `NA`. 2,408 rows are missing it, concentrated on web |

**Listen for.**

- Grain stated for both tables and then checked. The assignment table is clean, which is worth confirming
  rather than assuming, because the whole case rests on it being the trustworthy one.
- **Scoping the event log to the experiment.** 1,900 rows belong to users who were never assigned.
- **The window filter, and its exception.** The funnel steps belong inside the 14 days. The `ask_reopen_7d`
  lookahead legitimately runs past the end of the window, so filtering the whole log to the window drops 27%
  of re-ask events and inflates the deflection measure later. A candidate who filters everything and never
  revisits it has planted a bias he will not see.
- **The `NA` in `chars_typed`.** `mean()` returns `NA` and the fix is `na.rm = TRUE`, and the second question
  is whether `NA` means zero characters or an unlogged count. Here it means unlogged, so dropping is right
  and imputing zero would be wrong.

**Strong signals.**

- Cross-checking the assignment count against the `ask_open` count and noticing they do not match. That is
  the thread that leads to Task 3, and pulling it here rather than there is a strong signal.
- Saying which table is authoritative for what: assignments for the population and the arm, events for
  behavior. Stating that split explicitly is what stops the denominator error.

**Reference.**

```r
a <- read.csv("assignments.csv", stringsAsFactors = FALSE)
e <- read.csv("events.csv",      stringsAsFactors = FALSE)

c(assign_rows = nrow(a), assign_users = length(unique(a$user_id)),
  event_rows  = nrow(e), event_users  = length(unique(e$user_id)))
table(a$arm)
table(e$event_name)

START <- as.POSIXct("2026-09-01", tz = "UTC")
END   <- as.POSIXct("2026-09-15", tz = "UTC")
e$ts <- as.POSIXct(e$event_ts, tz = "UTC")
c(outside = sum(!e$user_id %in% a$user_id), before = sum(e$ts < START), after = sum(e$ts >= END))
table(e$event_name[e$ts >= END])          # all ask_reopen_7d: the lookahead, not dirt

e <- e[e$user_id %in% a$user_id, ]        # scope to the experiment
inw <- e[e$ts >= START & e$ts < END, ]    # funnel steps use the window
                                          # the 7-day lookahead deliberately does NOT

ty <- inw[inw$event_name == "ask_type", ]
c(mean(ty$chars_typed), mean(ty$chars_typed, na.rm = TRUE), sum(is.na(ty$chars_typed)))
tapply(is.na(ty$chars_typed), ty$platform, mean)   # the gap is on web
```

**Traps.** Assuming one row per user without checking. Not scoping the event log. Filtering the whole log to
the window. `mean()` without `na.rm` and moving on when it returns `NA`. Imputing zero for `chars_typed`.

**Score.** 4 loads and starts computing. 6 checks both grains, scopes the log, handles the `NA`. 8 also
notices the post-window events are the lookahead and keeps them out of the window filter, and cross-checks
assignment counts against `ask_open`.

---

## Task 2, build the funnel and read it

About 12 minutes.

**What the data gives.** Per-user flags, counted over the 50,000 assigned users.

| Step | Control | Treatment |
|---|---|---|
| Assigned | 25,000 | 25,000 |
| `ask_open` logged | 24,758 | 23,311 |
| `ask_type` | 17,948 | 17,919 |
| `suggest_shown` | 16,478 | 17,129 |
| `suggest_click` | 1,334 | 2,537 |
| `ask_post` | 10,682 | 10,117 |

**The two readings of the same result.**

| Post rate computed on | Control | Treatment | Change |
|---|---|---|---|
| Assigned users | 42.73% | 40.47% | **-5.3%**, p = 3e-07 |
| Users who logged `ask_open` | 43.15% | 43.40% | **+0.6%** |

**Listen for.**

- **Both numbers, and the recognition that the denominator decides the sign.** This is the case. On the
  assignment denominator the treatment clearly loses posts. On the `ask_open` denominator it looks like a
  small win. The person who ran the test reported flat, which is what the second reading gives.
- **A reason for preferring the assignment denominator that is about randomization, not preference.**
  `ask_open` is an event that happens after assignment and can be affected by the treatment. Conditioning
  on it breaks the comparison. That argument is the same one as filtering on a post-treatment variable, and
  it should be recognizable as such.
- Suggestion clicks up 90%, which is the treatment doing what it was built to do and should be reported as
  the mechanism working rather than as the result.
- `prop.test` rather than a t-test on a 0/1 column. Either gives nearly the same interval at this n and the
  right tool signals fluency.

**Reference.**

```r
for (nm in c("ask_open","ask_type","suggest_shown","suggest_click","ask_post"))
  a[[nm]] <- as.integer(a$user_id %in% inw$user_id[inw$event_name == nm])
a$reask <- as.integer(a$user_id %in% e$user_id[e$event_name == "ask_reopen_7d"])  # full log, not inw

steps <- c("ask_open","ask_type","suggest_shown","suggest_click","ask_post")
funnel <- sapply(steps, function(s) tapply(a[[s]], a$arm, sum))
funnel

n_arm  <- as.integer(table(a$arm))
n_open <- funnel[, "ask_open"]
rbind(on_assigned = funnel[, "ask_post"] / n_arm,
      on_ask_open = funnel[, "ask_post"] / n_open)

rate <- function(x) {
  t <- prop.test(tapply(x, a$arm, sum), n_arm, correct = FALSE)
  c(control = t$estimate[[1]], treatment = t$estimate[[2]],
    pct = (t$estimate[[2]] / t$estimate[[1]] - 1) * 100, p = t$p.value)
}
round(t(sapply(list(post = a$ask_post, click = a$suggest_click), rate)), 4)
```

**Traps.** Computing the funnel off `ask_open` and never trying the other denominator. Reporting the
suggestion click rise as the headline. `t.test` on a proportion when `prop.test` exists. Not noticing the
sign flip.

**Score.** 4 reports one rate with no view on the denominator. 6 uses the assignment denominator and tests it
properly. 8 computes both, shows the sign flip, and explains the preference as an argument about
conditioning on post-treatment events.

---

## Task 3, find out why the arms disagree

About 13 minutes.

**Interviewer.** "You've got two denominators giving opposite answers. Which is wrong and why?"

**What is there to find.** `ask_open` rate, as a share of assigned users, by platform and arm.

| Platform | Control | Treatment |
|---|---|---|
| android | 0.9907 | 0.9899 |
| ios | 0.9897 | **0.8536** |
| web | 0.9908 | 0.9899 |

And the same story visible from the other direction, post rate on the `ask_open` denominator:

| Platform | Control | Treatment |
|---|---|---|
| android | 0.4272 | 0.4143 |
| ios | 0.4390 | **0.4771** |
| web | 0.4250 | 0.4010 |

**Listen for.**

- **One cell, not one arm.** Treatment's `ask_open` rate is normal on android and web and 14 points low on
  iOS. That is an instrumentation failure in one client, not a treatment effect on whether the window opens.
- **The mechanism, reasoned out.** If the treatment's client waits for the suggestion model before firing
  `ask_open`, then treatment users who leave in the first couple of seconds never log it. Those users are
  the ones least likely to post, so removing them from the denominator raises treatment's apparent post
  rate. That is exactly the size and direction of the sign flip.
- **The second route in, which is arguably better.** The effect on the `ask_open` denominator *reverses* on
  iOS while android and web agree with each other. An effect that flips sign in one platform and nowhere else
  is almost always instrumentation, not heterogeneity. A candidate who finds it this way has a habit worth
  having.
- **Naming what is and is not affected.** The assignment table is server-side and complete, so the
  assignment denominator is unaffected and the fix is simply to use it. The bug does not require dropping
  iOS or re-running anything.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Maybe the treatment really does stop the window opening on iOS." | Then it would show up on android and web too, because the model is server-side and the client is the only thing that differs. And it would have to be a 14-point failure that nobody noticed in QA. Instrumentation is much likelier and it's checkable: if the missing users are all sub-two-second sessions, that's the answer |
| "Should we drop iOS?" | No. iOS is 42% of the sample and there's nothing wrong with the users, only with one event's logging. The assignment table is complete, so using it as the denominator fixes the problem for every platform at once |
| "Would you re-run the test?" | Not for this. The randomization is intact and the outcome events are intact, so the analysis is recoverable. I'd file the logging bug, because every funnel anyone builds off `ask_open` between now and the fix will be wrong in the same way |

**Reference.**

```r
asn <- table(a$platform, a$arm)                                  # assigned
opn <- tapply(a$ask_open, list(a$platform, a$arm), sum)          # logged ask_open
round(opn / asn, 4)                                              # one cell is 14 points low

pst <- tapply(a$ask_post, list(a$platform, a$arm), sum)
round(pst / opn, 4)                                              # the effect reverses on ios only
round(pst / asn, 4)                                              # on the right denominator it does not
```

**Traps.** Concluding the treatment broke the window. Dropping iOS. Calling for a re-run. Finding the
imbalance and not working out which direction it biases.

**Score.** 4 notices the arms differ and stops. 6 localizes it to iOS and treatment. 8 also gives the
mechanism, argues why instrumentation beats heterogeneity, says the fix is the denominator rather than a
re-run, and notes the bug will poison every future funnel until it is fixed.

---

## Task 4, the right outcome

About 13 minutes.

**Interviewer.** "Posts are down 5%. Is that bad?"

**Listen for.**

- **No, or not necessarily, and the reason.** The treatment's job is to stop duplicate questions being
  posted. Someone who clicks a suggestion and never comes back did not need to ask. Someone who leaves
  without clicking or posting did. The post metric treats those identically.
- **A definition of success that can tell them apart**, built from what is in the log: posted, or clicked a
  suggestion and did not open the Add Question window again within 7 days. That is what `ask_reopen_7d` is
  for and it is the only signal available that distinguishes a satisfied deflection from an abandonment.
- **The lookahead trap, handled.** The re-ask flag must come from the full log, not the window-filtered one.
  Getting it wrong moves need-met from +1.4% to +1.8% and its p from 0.17 to 0.08, which is the difference
  between inconclusive and borderline.

**What the data gives.**

| Metric, over assigned users | Control | Treatment | Change | p |
|---|---|---|---|---|
| Posted | 42.73% | 40.47% | -5.3% | 3e-07 |
| Clicked a suggestion | 5.34% | 10.15% | +90.2% | 4e-90 |
| Deflected, clicked and did not re-ask | 1.28% | 4.15% | +224.4% | 7e-87 |
| **Need met, posted or deflected** | **44.01%** | **44.62%** | **+1.4%** | **0.168** |

In counts: 565 fewer posts, 718 more successful deflections, a net 153 more users whose need was met.

**Strong signals.**

- **Refusing to treat 718 against 565 as the trade.** Not all of the extra deflections came from people who
  would otherwise have posted; some would have abandoned anyway. That is why the net has to be read off the
  need-met rate rather than off the difference of two counts, and saying so is a precision point most
  candidates miss.
- **Reading +1.4% at p = 0.17 correctly.** Not significant, and the interval does not rule out a meaningful
  gain or a meaningful loss. So the honest statement is that the feature moved a lot of people between two
  routes and the net effect on asker need is unmeasured.
- **The product argument that breaks the tie, and it is not statistical.** A posted question becomes a page
  that draws search traffic for years. A deflection is one satisfied person and no page. So a post and a
  deflection are not worth the same, which means a roughly even trade is a net loss to the corpus even if
  need-met were exactly flat. That is the strongest thing available in this task.
- **Segmenting on a pre-treatment variable.** `prior_questions_90d` and `platform` are clean.
  `chars_typed` is not, because the treatment changes how much people type before finding a suggestion, and
  a candidate who segments on it has repeated case 01's error in a place where it is much easier to make.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Need met is up. Isn't that a ship?" | It's up 1.4% and I can't distinguish it from zero, so on that metric we know less than the number suggests. And even if it were exactly flat I'd be against shipping, because we'd be trading question pages for deflections one for one, and a page keeps earning search traffic while a deflection is a one-off |
| "Why not segment on how much people typed?" | Because typing happens after the treatment is applied. If better suggestions appear sooner, people type less, so the segments aren't comparable between arms. Prior questions asked and platform are fixed before assignment, so those are the ones I'd cut on |
| "What's the strongest argument for shipping?" | That we removed a lot of duplicate questions, which makes the corpus cleaner and makes merging cheaper downstream, and that's a real benefit this test can't see. If someone wants to make that case, the number they'd need is what a duplicate question costs us, and nobody has it |

**Reference.**

```r
a$deflect  <- as.integer(a$suggest_click == 1 & a$ask_post == 0 & a$reask == 0)
a$need_met <- as.integer(a$ask_post == 1 | a$deflect == 1)
round(t(sapply(list(post = a$ask_post, click = a$suggest_click,
                    deflect = a$deflect, need_met = a$need_met), rate)), 4)

rbind(posted = tapply(a$ask_post, a$arm, sum), deflected = tapply(a$deflect, a$arm, sum))

a$seg <- ifelse(a$prior_questions_90d == 0, "never asked", "has asked")   # pre-treatment
for (s in unique(a$seg)) {
  i <- a$seg == s
  t <- prop.test(tapply(a$need_met[i], a$arm[i], sum),
                 as.integer(table(a$arm[i])), correct = FALSE)
  cat(sprintf("%-12s n=%6d  %.3f -> %.3f  %+5.1f%%  p=%.3g\n", s, sum(i),
      t$estimate[1], t$estimate[2], (t$estimate[2]/t$estimate[1]-1)*100, t$p.value))
}
```

**Traps.** Treating the post decline as the verdict. Building the re-ask flag from the window-filtered log.
Comparing 718 against 565 as though it were the net. Segmenting on `chars_typed`. Reading p = 0.17 as no
effect.

**Score.** 4 calls the post decline the answer. 6 builds a need-met metric and reads it. 8 also gets the
lookahead right, refuses the raw count comparison, reads the interval honestly, and makes the argument that a
post and a deflection are not worth the same.

---

## Task 5, recommendation

About 5 minutes.

**Model answer.** "Don't ship it, and the reason isn't the number that was reported. The person who ran this
computed the funnel off `ask_open`, which is a client event that fires after assignment, and on iOS the
treatment's client only fires it once the suggestion model returns. So treatment is missing its fastest
abandoners on one platform, its `ask_open` rate there is 85% against 99% everywhere else, and the post rate
on that denominator comes out +0.6% when on the assignment denominator it's -5.3% with a p of three in ten
million. The reported result has the wrong sign. On what the feature actually did: suggestion clicks are up
90%, so the model works, and successful deflections are up 224%. Posts are down 565 and deflections are up
718, but I wouldn't read that as the trade, because some of those deflections would never have posted
anyway. The net is the need-met rate, posted or deflected without coming back, and that's +1.4% with a p of
0.17, so it's unmeasured rather than positive. Which leaves a judgment call rather than a statistical one. We
moved a lot of people from posting to deflecting at roughly one for one, and those aren't worth the same: a
posted question becomes a page that earns search traffic for years and a deflection is one satisfied person.
So on current evidence this trades durable inventory for one-off satisfaction and I'd hold it. Two things to
do regardless: file the iOS logging bug, because every funnel built off `ask_open` between now and the fix
will be wrong the same way, and get someone to put a number on what a duplicate question costs us, because
that's the figure that would actually decide this."

**What pushes it to an 8.** Leading with the sign flip rather than with the metric philosophy. Refusing the
raw count comparison. Naming the post-versus-deflection value asymmetry as the deciding argument and saying
it is a business question rather than a measurement one. Filing the bug as a separate finding.

**Traps.** Leading with the need-met metric design. Shipping on +1.4%. Recommending a re-run. Forgetting the
bug.

**Score.** 4 gives no verdict or ships on the funnel number. 6 gets the denominator right and reaches a
verdict. 8 leads with the sign flip, reads need-met honestly, makes the value-asymmetry argument, and files
the bug.

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| Data manipulation | | |
| Applying statistical tests | | |
| Data intuition | | |
| Defending choices while working | | |
| Pace and reaching an outcome | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Data manipulation | Builds the funnel off its own first event | Scopes the log, handles the NA, uses the assignment denominator | Keeps the lookahead out of the window filter, and cross-checks assignment against `ask_open` |
| Statistical tests | t-test on a proportion, or no interval | `prop.test` with intervals | Reads p = 0.17 as unmeasured rather than null, and refuses the raw count comparison |
| Data intuition | Post decline is the verdict | Builds a need-met outcome | Localizes the bug to one cell with a mechanism, and argues the post-versus-deflection value asymmetry |
| Defending choices | Explains at the end | Justifies when prompted | Says where the denominator comes from before being asked |
| Pace | No recommendation | Reaches it, rushed | Cleaning inside 13 minutes, verdict with time left |

**Case-specific checks.**

- Did he say the denominator comes from the assignment table before opening the files?
- Did he compute the post rate both ways, or only one?
- Did he find the iOS cell unprompted? Via the `ask_open` gap or via the reversing effect?
- Did he build the re-ask flag from the window-filtered log?
- Did he segment on `chars_typed`?

| Task | Target | Actual |
|---|---|---|
| 0. Brief | 4 min | |
| 1. Load and grain | 13 min | |
| 2. Build the funnel | 12 min | |
| 3. Why the arms disagree | 13 min | |
| 4. The right outcome | 13 min | |
| 5. Recommendation | 5 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Running it in Colab

New notebook, Runtime, Change runtime type, R. Upload `data-02/assignments.csv` and `data-02/events.csv`.
`events.csv` is about 10MB, so give the upload a moment. `data-02/make_data.R` regenerates both files
exactly from a fixed seed if you want a fresh variant.
