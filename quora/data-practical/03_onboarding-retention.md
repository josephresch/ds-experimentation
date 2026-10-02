# Case 03, the onboarding change that looks like nothing happened

A mock interview for the **Data Practical** round. 60 minutes, live, in R in Google Colab, open book.
Claude plays the interviewer. To practice blind, stop reading after the brief in Task 0 and open the data.

**Base R only.** No tidyverse. The essential function list is at the end of this file.

## Why there is a third case

Two cases cover grain, joins, proportions, funnels and the two bug classes. Neither touches the **time
dimension**, and that is a gap worth closing, because "did the effect hold" is asked in almost every real
readout. This case is built entirely on it: an effect that decays, users observed for different lengths of
time, and a headline metric that hides a large real effect rather than inventing a fake one.

| | Case 01 | Case 02 | Case 03 |
|---|---|---|---|
| Spine | Grain and validity | Funnels and a missing-row bug | **Time, exposure and decay** |
| Outcome | A heavy-tailed count | A proportion | **A count per period, and a binary** |
| Naive metric | Flatters the treatment | Reverses the sign | **Hides a real effect** |
| New routines | Joins, dedup | Event rollup, `prop.test` | **Reshape to a period matrix, censoring, `p.adjust`** |

**Why it is product sense forward.** An onboarding change should, if it works at all, work immediately and
then stop mattering, because onboarding is a thing that happens once. So a candidate who knows what the
feature is expects the effect to be front-loaded and goes looking for it by period. A candidate who reads the
28-day total and reports flat has measured the average of a large effect and three quiet weeks.

**Three things are planted.** Do not read this before practicing.

<details>
<summary>Planted problems (spoiler)</summary>

1. **A ramped rollout.** 10% treatment for the first 7 days, then 50/50. So the arms are 14,283 against
   9,603, a chi-square that reads as a catastrophic sample ratio mismatch and is not a bug. And it means the
   arms have different signup-date distributions, so any outcome sensitive to tenure is confounded.
2. **Right-censoring.** Signups run for 28 days, the data was pulled on day 35. Only 5,777 of 23,886 users
   have a full 28 days, and because of the ramp they are 90% control. So the clean cohort has no power.
3. **A decaying effect.** Week 1 is +21.9%. Weeks 2 to 4 are flat. The 28-day total is -0.7%.

There is no fourth. The tail check on sessions comes back clean, and noticing that in one line and moving on
is the correct behavior rather than a missed finding.
</details>

## Clock

| Task | Minutes | Assessed on |
|---|---|---|
| 0. The brief | 4 | Framing |
| 1. Load, grain, and a split that fails | 12 | Data manipulation |
| 2. Attach sessions and the naive headline | 13 | Data manipulation |
| 3. Censoring and the ramp | 14 | Data intuition |
| 4. Does the effect hold | 12 | Statistical tests |
| 5. Recommendation | 5 | Communication |

## How Claude runs it

- **Do not warn him about the ramp.** It is in the brief in one clause and most candidates skim it. If he
  panics at the chi-square, let him, and see whether he checks the split by day.
- Ask "how many of these users could even have a week-4 outcome" only if he is about to report a 28-day
  number as final and has not asked himself. Once.
- Answer syntax questions directly.
- If he is 4 minutes behind, hand him the number and move on.
- At the end, debrief with the scorecard and diff against the reference.

---

## Task 0, the brief

About 4 minutes.

**Interviewer.** "New-user onboarding. The test finished and the readout said no effect, so it was shelved.
I want to know whether that was right."

> ### Brief
>
> **The change.** A new onboarding sequence for users who have just signed up: a shorter topic-picking step,
> and a first feed seeded from the topics they chose rather than from defaults.
>
> **The experiment.** Assignment at signup. **Ramped: 10% to treatment for the first week, then 50/50.**
> Signups were enrolled for 28 days, from 2026-08-03 to 2026-08-30.
>
> **The data.** Pulled on 2026-09-06.
>
> **The stated outcome.** Sessions in the user's first 28 days.
>
> **What the team concluded.** Flat, so it was shelved.
>
> ### Files
>
> `users.csv`, one row per new user
>
> | Column | Meaning |
> |---|---|
> | user_id | Who |
> | arm | control or treatment |
> | signup_date | When they signed up |
> | platform | ios, android, web |
> | country_group | US, IN, other |
> | days_observed | Days between signup and the data pull |
>
> `sessions.csv`, one row per session
>
> | Column | Meaning |
> |---|---|
> | session_id | The session |
> | user_id | Who |
> | session_date | When |

**Interviewer.** "Before you open it. What would you expect this change to do, and over what period?"

**Listen for.**

- **Onboarding happens once, so the effect should be front-loaded.** A better first feed should raise
  activity in the first days and then either persist as a habit or fade. Either way, a 28-day total averages
  the period where the effect lives with three periods where it probably does not, so the stated outcome is
  poorly chosen for the hypothesis.
- **Reading the two dates and doing the subtraction.** Enrollment ran to 2026-08-30 and the pull was
  2026-09-06, so a user who signed up on the last day has 7 days of history. The stated outcome needs 28.
  A candidate who spots that from the brief alone, before loading anything, has found the case.
- **The ramp, noticed.** 10% then 50/50 means the arms are not balanced in size and, more importantly, are
  not balanced in when their users joined.

**Traps.** Accepting the 28-day outcome. Missing the date arithmetic. Skipping past the ramp clause.

**Score.** 4 takes the brief at face value. 6 says the effect should be front-loaded. 8 also does the date
subtraction from the brief and flags the ramp as a balance problem before loading anything.

---

## Task 1, load, grain, and a split that fails

About 12 minutes.

**What is there to find.**

| Check | Result |
|---|---|
| `users.csv` rows and unique users | 23,886 and 23,886 |
| `sessions.csv` rows | 175,002, covering 21,560 users |
| Arm split | control 14,283, treatment 9,603 |
| Chi-square on the split | p = 2e-201 |
| Split by signup week | Week 1: 5,196 against 581. Weeks 2 to 4: roughly even |
| Mean `days_observed` | control 22.2, treatment 18.0 |
| Users with 28 or more days observed | 5,777 of 23,886. 36% of control, 6% of treatment |

**Listen for.**

- **The chi-square is not a bug and he should work that out rather than report it.** A sample ratio mismatch
  test assumes a fixed allocation. Here the allocation changed on purpose, so the test is answering a
  question nobody asked. The right move is to check the split **within** signup week, where it is 10/90 in
  week 1 and even afterwards, exactly as designed.
- **The consequence, which is the real finding.** Because treatment is under-represented in week 1, treatment
  users signed up later on average, so they have been observed for less time. 22.2 days against 18.0. Any
  outcome that accumulates over time is confounded with the arm.
- **`days_observed` inspected rather than ignored.** It is in the file, it is the key to the whole case, and a
  candidate who never looks at it will not find the censoring.
- Sessions table covering fewer users than the user table, which is expected: 2,326 users never had a session.
  A join must not silently drop them.

**Strong signals.**

- Saying out loud that the ramp makes this a confounded comparison unless something is done about exposure,
  and naming the two available fixes before computing anything: restrict to users with full exposure, or pick
  an outcome every user can have.
- Checking the balance of the pre-treatment covariates within week rather than overall, since overall balance
  is broken by construction.

**Reference.**

```r
u <- read.csv("users.csv",    stringsAsFactors = FALSE)
s <- read.csv("sessions.csv", stringsAsFactors = FALSE)
u$signup_date  <- as.Date(u$signup_date)
s$session_date <- as.Date(s$session_date)

c(users = nrow(u), uniq = length(unique(u$user_id)),
  sessions = nrow(s), session_users = length(unique(s$user_id)))

table(u$arm)
chisq.test(table(u$arm))$p.value            # p = 2e-201, and it is the ramp, not a bug
table(u$arm, cut(u$signup_date, "week"))    # 10/90 in week 1, even after

tapply(u$days_observed, u$arm, mean)        # 22.2 vs 18.0: the arms differ in exposure
tapply(u$days_observed >= 28, u$arm, mean)  # 36% vs 6% fully observed
table(u$arm, u$platform)                    # covariates balanced within the post-ramp period
```

**Traps.** Reporting the chi-square as a broken experiment. Never opening `days_observed`. Joining sessions
to users in a way that drops the 2,326 users with none.

**Score.** 4 reports an SRM and stops, or ignores the split. 6 traces it to the ramp by checking the split by
week. 8 also connects the ramp to unequal exposure, quantifies it, and names both fixes before computing.

---

## Task 2, attach sessions and the naive headline

About 13 minutes.

**Listen for.**

- **Computing the session week relative to each user's own signup date**, not to a calendar week. Users enrol
  continuously, so a calendar week means something different for each of them.
- **The base R gotcha on dates.** `s$session_date - u$signup_date[...]` returns a `difftime`, and `%/%` is not
  defined for it. `as.integer()` or `as.numeric()` first. This costs people a couple of minutes live and it
  is worth having in muscle memory.
- **Getting zeros for users with no sessions.** `table(factor(user_id, levels = u$user_id), week)` keeps every
  user, including the 2,326 with nothing. A `merge` or a plain `table` drops them and inflates every mean.
- The naive headline, computed and reported as naive: 28-day sessions 7.349 against 7.294, -0.7%, p = 0.68.
  That is the number that got the test shelved.

**What the data gives.**

| Metric | Control | Treatment | Change | p |
|---|---|---|---|---|
| Sessions in first 28 days | 7.349 | 7.294 | -0.7% | 0.675 |

**Strong signals.**

- Noticing, before doing anything else with it, that this metric is arithmetically forced toward zero:
  treatment has more users who could not possibly have 28 days, and their later weeks are structural zeros.
  So the naive metric does not merely fail to detect an effect, it actively suppresses one.
- Building the per-week matrix rather than only the total, because it costs nothing extra and it is what Task
  4 needs.

**Reference.**

```r
s$elapsed <- as.integer(s$session_date - u$signup_date[match(s$user_id, u$user_id)])
s$week    <- s$elapsed %/% 7L + 1L            # as.integer FIRST: %/% is undefined for difftime
s <- s[s$week >= 1 & s$week <= 4, ]

wk <- table(factor(s$user_id, levels = u$user_id), s$week)   # keeps users with zero sessions
for (w in 1:4) u[[paste0("w", w)]] <- as.integer(wk[, as.character(w)])
u$total28 <- rowSums(u[, paste0("w", 1:4)])

t.test(total28 ~ arm, data = u)                # -0.7%, p = 0.68: the reported result
tapply(u$total28, u$arm, mean)
```

**Traps.** Calendar weeks instead of weeks since signup. `%/%` on a difftime. Dropping zero-session users.
Reporting the 28-day number without noticing what censoring does to it.

**Score.** 4 computes a total and reports flat. 6 gets weeks-since-signup right and keeps zero-session users.
8 also says the metric is structurally biased toward zero by the censoring before analysing it further.

---

## Task 3, censoring and the ramp

About 14 minutes. The heart of the case.

**Interviewer.** "So it's flat. Are we done?"

**Listen for.**

- **The two fixes, tried, with the cost of each.**

| Fix | Result | The problem with it |
|---|---|---|
| Restrict to users with 28 full days | 9.445 against 9.491, +0.5%, p = 0.91 | n = 5,777, of which 5,196 control and 581 treatment. The ramp put almost all the fully observed users in control, so this has no power |
| Pick an outcome every user can have | Week-1 sessions, 3.963 against 4.830, **+21.9%, p = 1.4e-20** | It answers a narrower question, and that is the right trade here |

- **The recognition that the restriction fix is destroyed by the ramp.** Those two planted problems interact:
  censoring alone would be fixable by restricting, and the ramp makes the restricted sample useless. A
  candidate who tries the restriction, sees 581 treatment users, and understands why, has done the work.
- **The week-1 result, and its size.** +21.9% with a p of 1.4e-20 is not a marginal finding. The test that
  was shelved as flat contains a very large effect on the period where the hypothesis said it would be.
- **Saying plainly that the original readout was wrong, and why it was an honest mistake.** The stated outcome
  needed 28 days of history and three quarters of the sample did not have it.

**Strong signals.**

- Framing the choice as "which question can this data answer" rather than "which fix is correct." The data can
  answer week 1 cleanly for everyone and cannot answer week 4 for anyone much. Both statements are useful.
- Checking that week 1 is itself fully observed for everyone. It is: the minimum `days_observed` is 7.
- Noticing that comparing the restricted-cohort estimate against the week-1 estimate is not a contradiction,
  because they measure different periods on different samples.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Can't you just weight the censored users?" | Weighting fixes a known sampling probability and this is a missing outcome, not a missing sample. Their week-3 and week-4 sessions haven't happened yet, so there's nothing to weight up. The honest options are to wait, or to measure a period everyone has |
| "Isn't restricting to the full cohort the textbook answer?" | It is, and the ramp breaks it, because 90% of the fully observed users are control. With 581 treatment users the interval on a 28-day count is wide enough to contain almost anything, so the textbook fix gives a technically clean answer to no useful precision |
| "So the original analyst just got it wrong?" | They picked an outcome that needed 28 days on a sample where most users had fewer, and they didn't check. It's the kind of mistake that doesn't announce itself, because the number comes back looking ordinary rather than broken |

**Reference.**

```r
full <- u[u$days_observed >= 28, ]
table(full$arm)                                  # 5196 control, 581 treatment
t.test(total28 ~ arm, data = full)               # +0.5%, p = 0.91: clean and powerless

min(u$days_observed)                             # 7, so week 1 is complete for everyone
t.test(w1 ~ arm, data = u)                       # +21.9%, p = 1.4e-20
tapply(u$w1, u$arm, mean)
```

**Traps.** Reporting the restricted-cohort result as the answer. Proposing to weight the censored users.
Never trying an outcome everyone has. Treating the two estimates as contradictory.

**Score.** 4 stays with the 28-day number, or restricts and reports the powerless result as final. 6 finds
the week-1 effect. 8 also explains why the restriction fix fails specifically because of the ramp, and frames
the whole thing as which question the data can answer.

---

## Task 4, does the effect hold

About 12 minutes.

**Interviewer.** "A 22% lift in week one. Does it last?"

**What the data gives.** Each week tested on the users who were observed long enough to have it.

| Week | Eligible n | Control | Treatment | Change | 95% CI | p |
|---|---|---|---|---|---|---|
| 1 | 23,886 | 3.963 | 4.830 | +21.9% | +17.3% to +26.5% | 1.4e-20 |
| 2 | 17,960 | 2.323 | 2.373 | +2.1% | -2.8% to +7.1% | 0.394 |
| 3 | 12,314 | 1.731 | 1.856 | +7.2% | +0.3% to +14.2% | 0.042 |
| 4 | 5,777 | 1.426 | 1.301 | -8.8% | -21.1% to +3.6% | 0.163 |

Multiple comparisons across the four weekly tests:

| Week | raw p | Bonferroni | Benjamini-Hochberg |
|---|---|---|---|
| 1 | 1.4e-20 | 5.5e-20 | 5.5e-20 |
| 2 | 0.394 | 1.000 | 0.394 |
| 3 | 0.042 | 0.169 | 0.085 |
| 4 | 0.163 | 0.653 | 0.218 |

**Listen for.**

- **The eligible set changing per week, handled deliberately.** Week 4 can only be computed on the 5,777
  users with 28 days, and 581 of those are treatment. So the week-4 test is not a weak finding, it is barely a
  test. Saying that rather than reporting -8.8% as a decline is the point.
- **Week 3 treated as noise.** p = 0.042 across four tests is 0.17 under Bonferroni and 0.085 under
  Benjamini-Hochberg, and it sits between two flat weeks with no mechanism to explain it. A candidate who
  reports it as a finding has not corrected and has not asked whether it makes sense.
- **The shape, named.** A large immediate effect that is gone by week 2. That is what an onboarding change
  should look like if it improves the first session and does not change the habit, and it is consistent with
  the hypothesis rather than a disappointment.
- **The honest statement about persistence: it is unmeasured, not absent.** The week-4 interval runs from -21%
  to +4% on 581 treatment users. Reading that as "the effect does not persist" is the same error as reading a
  non-significant result as no effect, and it is the error the whole folder keeps testing.

**Strong signals.**

- Checking the tail and saying it is fine in one line. The top 1% of users hold 9% of sessions and
  winsorising at the 99th percentile moves the 28-day effect from -0.7% to -0.7%. The check is worth thirty
  seconds and dwelling on it is over-engineering.
- Choosing the right outcome for a retention question in week 4: the binary, any session in week 4, rather
  than the count. It is 54.52% against 54.39%, which is flat, and it is the quantity a retention question
  actually asks about. Reporting both and saying which one answers the question is the strong version.
- Working out when the question becomes answerable. The last signup was 2026-08-30, so every user reaches day
  28 on 2026-09-27, which is 21 days after the data was pulled. That is a concrete, cheap recommendation.

**Reference.**

```r
for (w in 1:4) {
  el <- u[u$days_observed >= 7 * w, ]; col <- paste0("w", w)
  tt <- t.test(el[[col]] ~ el$arm)
  cat(sprintf("week %d  n=%5d  %.3f -> %.3f  %+6.1f%%  p=%.3g\n", w, nrow(el),
      tt$estimate[1], tt$estimate[2], (tt$estimate[2]/tt$estimate[1]-1)*100, tt$p.value))
}

p <- sapply(1:4, function(w) {
  el <- u[u$days_observed >= 7*w, ]; t.test(el[[paste0("w",w)]] ~ el$arm)$p.value })
data.frame(week = 1:4, p = signif(p,3),
           bonf = signif(p.adjust(p, "bonferroni"),3), BH = signif(p.adjust(p, "BH"),3))

# a retention question wants a binary, not a count
el <- u[u$days_observed >= 28, ]
prop.test(tapply(el$w4 > 0, el$arm, sum), as.integer(table(el$arm)), correct = FALSE)

# does the tail matter? no. one line, then move on
cap <- quantile(u$total28, 0.99)
c(raw = mean(u$total28[u$arm=="treatment"]) / mean(u$total28[u$arm=="control"]) - 1,
  win = mean(pmin(u$total28,cap)[u$arm=="treatment"]) /
        mean(pmin(u$total28,cap)[u$arm=="control"]) - 1)

max(u$signup_date) + 28        # 2026-09-27: when every user has 28 days
```

**Traps.** Reporting week 3 as a finding. Reading week 4 as evidence the effect faded. Not correcting for
four tests. A count metric for a retention question. Spending five minutes on winsorising.

**Score.** 4 reports the weekly numbers with no correction and calls the effect faded. 6 corrects for multiple
tests and notes week 4 is underpowered. 8 also switches to a binary for the retention question, checks the
tail in one line, and computes the date on which the question becomes answerable.

---

## Task 5, recommendation

About 5 minutes.

**Model answer.** "The readout that shelved this was wrong, and for a reason that doesn't look like an error.
The stated outcome was sessions in the first 28 days, and only 5,777 of 23,886 users had 28 days at the pull,
because enrollment ran to August 30 and the data came out on September 6. Treatment is hit harder, because
the rollout was 10% for the first week, so treatment users joined later and were observed for 18 days against
control's 22. Their later weeks are structural zeros, so the 28-day total is pushed toward zero and it came
back at -0.7%. On an outcome every user actually has, week-one sessions, it's 3.96 against 4.83, up 21.9%,
with a p of 1.4e-20. That's a large real effect on exactly the period an onboarding change should move. What I
can't tell you is whether it lasts. Week 4 is computable on 581 treatment users and the interval runs from
-21% to +4%, so that's unmeasured rather than flat, and the week-3 result at p = 0.042 doesn't survive
correcting for four tests and sits between two quiet weeks, so I'd treat it as noise. The textbook fix here,
restricting to the fully observed cohort, doesn't work because the ramp left 90% of that cohort in control. So
my recommendation is don't ship yet and don't shelve it either. Every user in this test reaches day 28 on
September 27, which is three weeks after the pull, so the cheapest thing available is to re-pull then and read
week 4 properly on a balanced sample. If the week-one effect is all there is, this is still probably worth
shipping for activation alone, and that's a decision I'd want made knowingly rather than by default. One
process note: the ramp is what made this hard, and if we'd held 50/50 from day one the restricted cohort
would have answered it already."

**What pushes it to an 8.** Explaining why the original readout was an honest mistake rather than
incompetence. Refusing to call the effect faded. The specific date. The process point about the ramp.
Saying the week-one effect may be sufficient on its own, which is a product judgment rather than a
statistical one.

**Traps.** Reporting the test as flat. Saying the effect faded. No date. No verdict.

**Score.** 4 confirms flat, or calls the effect faded. 6 finds the week-one effect and reaches a verdict.
8 explains the censoring mechanism, refuses to call week 4, gives the re-pull date, and makes the ramp point.

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
| Data manipulation | Calendar weeks, or drops zero-session users | Weeks since signup, zeros kept, per-week matrix built | Handles the difftime, and inspects `days_observed` before computing anything |
| Statistical tests | No correction, reads week 4 as a decline | Corrects for four tests, flags week 4 as underpowered | Switches to a binary for the retention question and reads the interval for what it cannot rule out |
| Data intuition | Reports the SRM as a broken test | Traces it to the ramp | Connects the ramp to unequal exposure, and explains why the restriction fix fails because of it |
| Defending choices | Explains at the end | Justifies when prompted | Says the 28-day metric is structurally biased before analysing it |
| Pace | No recommendation | Reaches it, rushed | Finds the week-one effect by minute 40, verdict with time left |

**Case-specific checks.**

- Did he do the date arithmetic from the brief, before loading?
- Did he report the chi-square as a broken experiment?
- Did he look at `days_observed` unprompted?
- Did he try the restricted cohort, and did he understand why it failed?
- Did he report week 3 as a finding?
- How long did he spend on the winsorising check? Target is under a minute.

| Task | Target | Actual |
|---|---|---|
| 0. Brief | 4 min | |
| 1. Load and the split | 12 min | |
| 2. Attach sessions | 13 min | |
| 3. Censoring and the ramp | 14 min | |
| 4. Does it hold | 12 min | |
| 5. Recommendation | 5 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Running it in Colab

New notebook, Runtime, Change runtime type, R. Upload `data-03/users.csv` and `data-03/sessions.csv`.
`data-03/make_data.R` regenerates both from a fixed seed.

---
---

# Essential base R for the Data Practical

Everything below is base R, available on a bare install, no packages. Ordered by when you need it rather
than alphabetically. The gotchas are the ones that actually cost minutes.

## Loading and first look

```r
d <- read.csv("f.csv", stringsAsFactors = FALSE)   # always set this; factors will bite you otherwise
str(d); dim(d); names(d); head(d); summary(d)
nrow(d); ncol(d); length(unique(d$id))
```

`str()` is the fastest way to see types and spot a date that came in as character. `summary()` shows NAs per
column for free, which is the cheapest missing-data check there is.

## Grain: is the key unique

```r
nrow(d) == length(unique(d$id))
sum(duplicated(d$id))                    # how many extra rows
names(which(table(d$id) > 1))            # which ids repeat
d[!duplicated(d$id), ]                   # keep the first of each
```

`table()` on an id column is the single most useful grain check. `duplicated()` is `TRUE` from the second
occurrence onward, so `sum(duplicated(x))` is the count of surplus rows, not the count of affected ids.

## Filtering, scoping, and set membership

```r
d[d$arm == "treatment", ]
d[d$id %in% keep_ids, ]
d[!d$id %in% other$id, ]                 # anti-join
subset(d, arm == "treatment" & n > 0)    # convenient interactively; d[...] is safer in scripts
```

`%in%` is the workhorse. Note that `d[d$x > 5, ]` keeps `NA` rows as all-`NA` rows, which is almost never
what you want. `d[which(d$x > 5), ]` drops them.

## Missing values

```r
sum(is.na(d$x)); colSums(is.na(d))
mean(d$x)                                # NA if any value is NA
mean(d$x, na.rm = TRUE)                  # the fix
complete.cases(d)
ifelse(is.na(d$x), 0, d$x)               # only if NA genuinely means zero
```

**The gotcha.** `mean`, `sum`, `sd`, `var`, `median`, `quantile`, `cor` all return `NA` if anything is
missing. `na.rm = TRUE` is not a formality, it is a decision: ask whether `NA` means zero or unlogged. In
case 02 it means unlogged, so dropping is right and imputing zero would bias the answer.

## Joins

```r
merge(a, b, by = "id")                              # inner
merge(a, b, by = "id", all.x = TRUE)                # left
b$val[match(a$id, b$id)]                            # lookup, no row explosion
```

**The gotcha.** `merge()` on a key that repeats in both tables multiplies rows. If `nrow()` goes up after a
`merge` you did not intend, that is the bug. `match()` returns the first match only, which is exactly what
you want for attaching an attribute, and it silently gives `NA` for no match, which you should check.

## Aggregation

```r
tapply(d$y, d$arm, mean)                            # one grouping
tapply(d$y, list(d$platform, d$arm), sum)           # two, returns a matrix
aggregate(y ~ arm + platform, data = d, FUN = mean) # returns a data frame
ave(d$y, d$id, FUN = sum)                           # group total, same length as d
rowsum(d$y, d$id)                                   # fast group sums by key
by(d, d$arm, summary)
```

`tapply` with a `list()` of two grouping vectors returning a matrix is the fastest route to a
platform-by-arm table, and case 02's bug is found in exactly that call.

## Counting, and keeping the zeros

```r
table(d$arm)
table(d$arm, d$platform)
table(factor(d$user_id, levels = all_users))        # keeps users with zero rows
xtabs(n ~ arm + week, data = d)
as.data.frame(table(d$arm))
prop.table(table(d$arm, d$posted), margin = 1)      # row proportions
addmargins(table(d$arm, d$platform))                # with totals
```

**The gotcha, and it matters in both cases.** `table()` only lists values that appear. Wrapping in
`factor(x, levels = ...)` forces every level into the output, including the ones with count zero. Without it,
users with no sessions vanish and every per-user mean is computed on the wrong denominator.

## Flags and per-unit rollup from an event log

```r
d$posted <- as.integer(d$user_id %in% ev$user_id[ev$event_name == "ask_post"])
wk <- table(factor(ev$user_id, levels = d$user_id), ev$week)   # users x weeks matrix
d$w1 <- as.integer(wk[, "1"])
d$total <- rowSums(d[, c("w1","w2","w3","w4")])
```

This pattern, a membership flag per event type plus a `table` into a matrix, does the whole of case 02's
funnel and case 03's weekly counts without a single package.

## Dates and times

```r
as.Date(d$day)                                       # "2026-09-01"
as.POSIXct(d$ts, tz = "UTC")                         # "2026-09-01 12:34:56"
format(d$ts, "%Y-%m-%d"); format(d$ts, "%H")
difftime(t2, t1, units = "days")
as.integer(d2 - d1)                                  # days between Dates
seq(as.Date("2026-09-01"), by = "day", length.out = 14)
cut(d$day, "week"); cut(d$ts, "hour")                # bucketing, returns a factor
weekdays(d$day); months(d$day)
trunc(d$ts, "days")
```

**The gotcha that bit me writing case 03.** Subtracting two `Date`s gives a `difftime`, and `%/%` and `%%`
are **not defined** for it. Wrap in `as.integer()` or `as.numeric()` first:

```r
week <- as.integer(s$session_date - u$signup_date[match(...)]) %/% 7L + 1L
```

Also: `as.Date` on a timestamp string silently truncates the time, and comparing a `Date` to a `POSIXct`
coerces in ways that are easy to get wrong. Pick one type per column and stick to it.

## Binning and segments

```r
cut(d$prior, c(-1, 0, 4, 19, Inf), labels = c("none","light","mid","heavy"))
ifelse(d$prior == 0, "never", "has")
findInterval(d$x, c(0, 10, 100))
quantile(d$x, c(.5, .9, .99))
cut(d$x, breaks = quantile(d$x, 0:4/4), include.lowest = TRUE)   # quartiles
```

**The judgment, not the syntax.** Only ever segment on a variable fixed **before** assignment. In case 02,
`chars_typed` is post-treatment and `prior_questions_90d` is not.

## Tests

```r
t.test(y ~ arm, data = d)                            # Welch by default, which is what you want
t.test(y ~ arm, data = d, var.equal = TRUE)          # rarely justified
prop.test(c(x1, x2), c(n1, n2), correct = FALSE)     # two proportions
prop.test(table(d$arm, d$posted))
binom.test(x, n, p = 0.5)                            # one proportion, exact
chisq.test(table(d$arm))                             # sample ratio mismatch
chisq.test(table(d$arm, d$platform))                 # independence
wilcox.test(y ~ arm, data = d)                       # different hypothesis, not a safer t-test
var.test(y ~ arm, data = d)
p.adjust(pvals, method = "BH")                       # or "bonferroni"
```

**Two gotchas.**

R orders factor levels alphabetically, so `t.test(y ~ arm)` returns **control minus treatment**. The printed
interval is in that direction. Getting the sign backwards reverses your recommendation, and it is the easiest
mistake in the whole round. Check with `tapply(d$y, d$arm, mean)` every time.

`correct = FALSE` on `prop.test` gives the plain two-proportion test. The default continuity correction is
conservative and makes hand-checking harder.

## Models

```r
lm(y ~ arm, data = d)                                # same estimate as the t-test
lm(y ~ arm + prior, data = d)                        # regression adjustment on a pre-treatment covariate
summary(m)$coefficients
confint(m)
glm(posted ~ arm + prior, data = d, family = binomial)
predict(m, newdata = nd, type = "response")
```

`summary(m)$coefficients["armtreatment", ]` is how you pull one row without printing the whole table, which
matters when you are sharing a screen.

## Shaping

```r
reshape(d, direction = "wide", idvar = "user_id", timevar = "week", v.names = "n")
reshape(w, direction = "long", idvar = "user_id", varying = list(2:5), v.names = "n")
t(m); rowSums(m); colSums(m); rowMeans(m); apply(m, 1, max)
do.call(rbind, lapply(groups, function(g) data.frame(g = g, est = f(g))))
stack(list(a = x, b = y)); unstack(df)
```

`reshape()` has an awkward interface and you will be faster building the matrix with `table()` or `tapply()`
and converting with `as.data.frame()`. The `do.call(rbind, lapply(...))` idiom for a per-segment results table
is worth memorising, because it is how you produce the segment tables in every case in this folder.

## Sorting, ranking, running totals

```r
d[order(d$y, decreasing = TRUE), ]
d[order(d$arm, -d$y), ]
rank(d$y); cumsum(d$y); cummax(d$y); rev(d$y)
head(sort(d$y, decreasing = TRUE), 10)
which.max(d$y); which.min(d$y)
pmin(d$y, cap); pmax(d$y, 0)                         # winsorising
```

## Strings and ids

```r
grepl("^ios", d$platform); grep("ios", d$platform)
sub("_.*$", "", d$user_id); gsub("-", "", d$day)
substr(d$user_id, 1, 2)
strsplit(d$variant, "_")
sprintf("%.1f%%", 100 * x); paste0("w", 1:4)
nchar(d$text); tolower(d$s); trimws(d$s)
```

## Sanity and output

```r
stopifnot(nrow(d) == length(unique(d$id)))
round(x, 3); signif(p, 3)
cat(sprintf("%-12s %6.3f -> %6.3f  %+5.1f%%  p=%.3g\n", lab, a, b, (b/a-1)*100, p))
options(scipen = 999)                                # stop scientific notation in printed output
set.seed(1)
```

`stopifnot()` on a grain assumption is how you make an assumption visible instead of silent, and saying "I'm
asserting one row per user here" while typing it is exactly the narration this round wants.

## The seven that decide the round

If you only drill a handful, drill these.

| | Why |
|---|---|
| `table(factor(x, levels = all))` | Keeps the zeros. Without it your denominators are wrong and nothing tells you |
| `tapply(y, list(g1, g2), f)` | The two-way table where platform-by-arm bugs live |
| `match()` over `merge()` | Attaches an attribute without ever exploding rows |
| `as.integer()` before date arithmetic | The difftime gotcha, and it stalls people live |
| `na.rm = TRUE`, and asking what NA means | One silent `NA` turns a whole analysis into a blank |
| `prop.test(..., correct = FALSE)` | The right tool for a funnel, and it signals you have done this before |
| `tapply(y, arm, mean)` after every `t.test` | Because R subtracts in alphabetical order and the sign matters |
