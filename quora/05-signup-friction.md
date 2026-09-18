# Reducing sign-up friction on the topic selection step

An experiment design study for Quora, built from public product documentation and third-party traffic
estimates. The data is synthetic. The internal systems described are a plausible reconstruction
rather than a description of Quora's architecture.

## Problem

Most visitors arrive logged out from search, on a question page. When one of them signs up, Quora
asks for at least ten topics, and those topics seed the home feed, the digest and notifications.

Roughly seven in ten visitors who start signing up from a question page finish, and the topic step is
where many of the rest stop. The proposal replaces it. A new user starts with the topics of the
question they were reading and is asked to add three more, so nobody picks ten from scratch. The step
fetches its suggestions when it opens.

| Scenario quantity | Value |
|---|---|
| Visitors who start sign-up from a question page in 14 days | about 800,000 |
| Finish sign-up | 71% |
| Active on day 7 | 30.5% |
| Visitors on slow mobile connections | 12% |

One implementation detail decides how this test reads. The sign-up start event fires when the topic
step appears on screen.

## Design tensions

| Tension | How it shows up |
|---|---|
| There is no account yet | Assignment has to run on the browser or device, and a person who switches devices mid-flow can land in both arms |
| The event that defines the population is produced by the treatment | A start is logged when the step renders, and the step is exactly what changed |
| The obvious metric is the step rather than the outcome | Completing sign-up is not using the product, and a new account that never returns is not a win |
| Conditioning on completion changes who is being compared | Retention among finishers compares two different populations once more marginal visitors get through |
| Friction removed is also signal removed | Ten topics seed the feed, six give personalization less to work with, and the deficit shows up after the first week |
| An easier door admits more of everything | Including automated accounts |

## Framing

Every funnel experiment has to answer one question before any metric is chosen. What is the
population, and is the event that defines it safe from the treatment?

Here it is not. A visitor is counted once the topic step renders, and the new step does more work
before rendering. Anything that changes who reaches that render changes who enters the denominator,
and the rates computed on that denominator stop being comparable. The population is downstream of the
treatment, which is the same defect as filtering on a post-treatment outcome, arriving through the
instrumentation instead of through the analysis.

The practical consequence is that a sample ratio check is not a hygiene step in this design, it is
the primary result until it passes. It is also a product signal rather than a data-quality footnote,
because the mechanism that drops people from the count is the same mechanism that drops people from
the funnel.

The same distinction, counting people at assignment rather than at the moment the product decides to
notice them, is what makes the primary metric work in
[suggested-question cards](02-answer-prompts.md) and in
[digest frequency](03-digest-frequency.md), where eligibility is frozen before the treatment can
change it.

## Public figures

- New users are asked to select at least ten topics during sign-up, and those topics seed what they
  see afterward
- Personalization runs mainly on topics, along with follows of people and Spaces, and the help center
  tells readers that the more actions they take, the more the feed learns
- Most traffic arrives from organic search, landing logged out on question pages, and third-party
  estimates put about three quarters of visits on mobile
- A "Sign Up to Continue Reading" prompt appears on logged-out question pages after brief reading,
  described by a third-party write-up in 2026
- Quora's CEO has described the company as caring about speed "down to milliseconds" and has
  described an in-house experiment framework running about 2,000 experiments, roughly 30 at a time

## Scenario

Synthetic, per visitor who starts sign-up from a question page.

| Metric | Value |
|---|---|
| Finished sign-up | 71.0% |
| Active on day 7 | 30.5% |
| Topics followed at sign-up, median | 10 |
| Spam accounts flagged per 1,000 sign-ups | 6.0 |

Sign-up tests randomize by browser or device, since there is no account yet, and can use every
visitor.

## Arithmetic

```
MDE ≈ 2.8 · sqrt(2 · p(1 - p) / n)
```

At 400,000 visitors per arm, day-7 activity at a 30.5% base resolves to about 0.29 points, and
completion at a 71% base to about the same.

The second piece of arithmetic in this study is the split check, which uses the same machinery for a
different purpose. Under a 50/50 assignment with N assigned visitors, the count in one arm has
standard deviation `sqrt(N) / 2`. At `N = 769,274` that is 439 visitors, so an imbalance of a few
thousand is notable and an imbalance of fifteen thousand is not a sampling story. The chi-square
statistic for the observed split below is about 1,257 on one degree of freedom.

---

# Design decisions

## 1. Objective

The decision is whether to replace the topic step for every visitor who starts sign-up from a
question page.

The objective is more of the people who start sign-up becoming users who come back, which is the
first link in the logged-in loop. Accounts created is an intermediate quantity on the way there, and
treating it as the objective would reward a step that lets people through and leaves them with a feed
that has nothing in it.

The scope boundary is the personalization question. Two weeks plus a week of follow-up can see
whether a thinner start costs first-week engagement. Whether six topics instead of ten costs
retention at day 30 or day 90 is a later readout, and it is the reason the launch keeps a check
rather than closing the case.

## 2. Primary metric

Day-7 activity per sign-up start, where a start is every assigned visitor who clicked sign up.

The denominator is the load-bearing half of that sentence. It has to be the click, which the
treatment cannot influence, rather than the rendered step, which it can.

| Candidate | Why it is rejected |
|---|---|
| Completion rate | Finishing a form is not using the product. It is a secondary, and it is the metric most likely to move for reasons that do not last |
| Day-7 activity among visitors who finished | Conditions on an outcome the treatment changes. If more marginal visitors get through, this can fall while the product improves, or rise while it does not |
| Topics followed | An input to personalization, not a result. The new step lowers it by design |
| Day-7 activity per logged start | Fine in principle and unusable here, because the logged start is produced by the treatment |

## 3. Secondaries and guardrails

Secondaries.

- Completion rate, and drop-off at each step of the flow
- Topics followed at sign-up
- First-week engagement, read with the population caveat attached

Guardrails.

| Guardrail | Why |
|---|---|
| Spam accounts flagged per 1,000 sign-ups | Lower friction admits more automated sign-ups |
| Time for the topic step to appear, by connection speed | The new step fetches suggestions on open, so it has a latency cost that falls unevenly |
| Day-30 retention | A thinner starting feed would show up here rather than in week one |

## 4. Randomization

The unit is the browser or device, assigned at the moment the visitor clicks sign up. Allocation is
50/50 across all qualifying visitors, about 400,000 per arm over 14 days, with a further 7 days
before the readout so that day-7 activity exists for everyone enrolled.

Assigning and counting at the click is the whole design. Any later trigger is contaminated by the
treatment, and the contamination is invisible in the rates it produces.

Two known limits of device assignment are accepted rather than solved. About 2% of visitors switch
devices during sign-up and can appear in both arms, which dilutes the measured difference slightly,
and a returning visitor with cleared storage is a new unit. Both effects are symmetric and neither
can be removed without an account, which is the thing being created.

## 5. Power

Well powered for the effect sizes in question, with detectable changes of about a third of a point on
both completion and day-7 activity. Power is not the risk in this design. The risk is that a
well-powered estimate is computed on a population the treatment selected, which produces a tight
interval around the wrong number.

## 6. Health checks

Run before any rate is read, and failing any of them stops the readout.

- Sample ratio at assignment, meaning the click, and separately at every logged step of the flow
- Time for the topic step to appear, split by connection speed and platform
- Spam filtering identical across arms
- Device switching rates equal across arms

The split check has to run at more than one point in the funnel. A design whose only ratio check sits
at the same event the treatment moves cannot detect this failure at all.

## 7. Results

14 days of enrollment, 50/50, read at day 21. Synthetic. The dashboard, as the team first saw it.

| Per logged sign-up start | Control | New step | Change |
|---|---|---|---|
| Sign-up starts logged | 400,188 | 369,086 | |
| Finished sign-up | 71.0% | 81.2% | +10.2 points |
| Active on day 7 | 30.5% | 35.1% | +4.6 points, about +15% |
| Active on day 7, among those who finished | 43.0% | 43.3% | |
| Topics followed at sign-up, median | 10 | 6 | |
| Spam accounts flagged per 1,000 sign-ups | 6.0 | 9.0 | +3.0 |

The split is 47.98% of logged starts in the new step arm. Against a 50/50 assignment with 769,274
logged starts, the chi-square statistic is about 1,257 and the p-value is effectively zero.

That single line invalidates every rate in the table. Roughly 31,000 visitors are missing from the
treated arm relative to control, and the reason they are missing is almost certainly related to the
treatment, so they are not a random sample of it. If the people who disappeared were the ones least
likely to finish, the new step's completion and retention rates improve without anything real having
happened.

Nothing below the first row gets interpreted until the missing visitors are found.

## 8. Diagnosis

| Kind | Hypothesis | What the cut must show |
|---|---|---|
| Assignment | The randomizer is broken | An imbalance already present at the click |
| Measurement | People are lost between the click and the logged start | A balanced click split with an unbalanced render rate |
| Who | The missing visitors share a platform or connection | An imbalance concentrated in one slice |
| Product | The new step's fetch is slow enough that people leave | A render time gap in that slice |
| Value | The change helps where it renders normally | A clean result in the balanced slice |
| Overall | The effect over everyone assigned is smaller | A per-click estimate below the dashboard number |

**Split at the click.**

| | Control | New step |
|---|---|---|
| Sign-up clicks, logged at assignment | 402,300 | 401,900 |
| Share of clicks | 50.02% | 49.98%, p = 0.66 |
| Clicks where the topic step appeared | 99.5% | 91.8% |

Randomization is sound. The loss happens between the click and the step appearing, and it is stable
across every day of the test, which rules out a one-off incident.

**By connection speed.**

| Connection | Logged starts, control | New step | Share in new step | Median time to render, control | New step |
|---|---|---|---|---|---|
| Fast | 352,165 | 351,815 | 49.98%, p = 0.68 | 0.4 s | 0.6 s |
| Slow | 48,023 | 17,271 | 26.5% | 0.9 s | 2.8 s |

The entire imbalance sits on slow connections, where the new step takes nearly three seconds to
appear and about two thirds of those visitors leave before it does. They were never logged, so the
dashboard computed its rates on the visitors who waited.

This is the point where a data-quality finding becomes a product finding. The same delay that removed
those visitors from the denominator also removed them from the funnel.

**Fast connections, where the split is balanced.**

| Fast connections | Control | New step | Change | 95% CI |
|---|---|---|---|---|
| Finished sign-up | 74.5% | 82.5% | +8.0 points | +7.8 to +8.2 |
| Active on day 7 | 33.3% | 36.3% | +3.0 points, about +9% | +2.8 to +3.2 |

Where the page renders normally the change works. This is a valid estimate for a subgroup defined by
a pre-treatment attribute, and it is not the launch decision, because launching ships to everyone.

**Everyone who clicked.** Visitors who left before the step appeared are counted as not signed up,
which is what happened to them.

| Per sign-up click | Control | New step | Change | 95% CI |
|---|---|---|---|---|
| Finished sign-up | 70.6% | 74.5% | +3.9 points | +3.7 to +4.1 |
| Active on day 7 | 30.3% | 32.2% | +1.9 points, about +6% | +1.7 to +2.1 |

On slow connections alone, 44.8% of clicks finished sign-up in control against 19.0% with the new
step, and day-7 activity per click was 9.9% against 3.9%.

Three numbers now describe the same experiment. The dashboard says +15%, the balanced subgroup says
about +9%, and the estimate over everyone assigned says about +6% with severe harm concentrated in
12% of visitors. Only the third is an answer to the launch question.

**After sign-up.** Median topics followed fall from 10 to 6. First-week stories expanded per day-7
active user fall from 38 to 34, which compares different populations, since the new step admits more
casual visitors, and is a reason to check day 30 rather than a result. Spam accounts flagged rise
from 6.0 to 9.0 per 1,000 sign-ups.

**Measurement.** Bot filtering is identical across arms, and about 2% of visitors switch devices
during sign-up, evenly split.

## 9. Decision

Do not launch on this result, and do not discard the change either. Fix two things and run it again.

The instrumentation fix is to log a sign-up start at the click rather than at the render, so both
arms are counted at a moment the treatment cannot move. The product fix is to send the suggested
topics with the page instead of fetching them when the step opens, which removes the delay that
caused both the missing visitors and the real harm behind them.

The rerun keeps day-7 activity per click as the primary, adds render time by connection speed and
spam accounts as guardrails, and schedules a day-30 readout because new users now start with six
topics instead of ten.

One process change is worth more than the result. An automatic sample ratio test at assignment and at
every logged funnel step, run before any dashboard is shown, would have caught this in a day and
would catch the next instance without anyone thinking to look.

## 10. Limits

| Cannot fix | Why | What to do instead |
|---|---|---|
| Device identity | Assignment happens before an account exists, so a person can be two units | Accept the dilution, report device-switch rates, and confirm they match across arms |
| Personalization depth over time | A thinner topic seed shows up after the first week, and the test reads at day 7 | Day-30 and day-90 readouts on the launched cohort against a holdout |
| The composition of new sign-ups | An easier flow admits different people, so any post-sign-up average mixes a treatment effect with a population change | Compare per assigned visitor, and read post-sign-up metrics only as descriptions |
| Harm from latency in the tail | Connection speed is a proxy for a distribution of conditions the test measures in two buckets | Report render time percentiles by market and device class, not a median split |
| What the ten-topic step was buying | The test compares a new step with the old one, not personalization depth directly | Separate test varying the number of topics requested, with day-30 retention as the primary |

## Sources

- [Hogatoga, creating a Quora account, 2024](https://hogatoga.com/how-to-create-account-on-quora/)
- [Quora Help Center, personalizing the feed](https://help.quora.com/hc/en-us/articles/115004230006-How-do-I-personalize-my-Quora-feed)
- [EconTalk, Adam D'Angelo on knowledge, experimentation, and Quora, 2016](https://www.econtalk.org/adam-dangelo-on-knowledge-experimentation-and-quora/)
- [Third-party description of the logged-out experience, April 2026](https://mathewsachin.github.io/blog/2026/04/10/quora-devtools-bypass.html)
- [Similarweb, quora.com](https://www.similarweb.com/website/quora.com/)
- [Contrary Research, Quora business breakdown](https://research.contrary.com/company/quora)
