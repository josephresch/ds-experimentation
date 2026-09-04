# Local Subscription Pricing Test — Experiment Design

**Owner:** Joseph Resch · **Team (simulated):** Twitch Commerce, Ads & Sponsorships DS
**Status:** Design / pre-registration · **Repo:** `TwitchExperimentation`

> **What this is.** A complete, end-to-end simulated pricing experiment: design → power →
> randomization → A/A → execution → analysis → decision memo. The data is synthetic and the
> market is fictional. The *structure* (local pricing by viewer country, 50/50 vs. 70/30
> revenue splits, subscribers getting ad-free viewing on the channel) is real and publicly
> documented, so the reasoning transfers. Nothing here is Twitch-internal.

---

## 1. The business question

Twitch prices Tier 1 subscriptions locally — the price a viewer pays depends on their country,
not the streamer's. In our market (call it **Market BR**, Tier 1 web = **R$9.90/mo**), paid
subscriber growth has been flat for three quarters while viewing hours are up.

The Commerce PM's hypothesis: **R$9.90 is above the revenue-maximizing price for this market.**
Proposal: cut Tier 1 to **R$7.90** (−20.2%) and let volume more than make up the difference.

**Decision we owe the business:** ship the cut, hold at R$9.90, or come back with a different
price / a targeted variant. Not "is the p-value below 0.05."

### 1.1 The framing that matters (and the one to avoid)

The naive statistical question is *"does the price cut change subscription conversion?"* Of course
it does — prices move quantities, that is not in doubt and it is not worth an experiment.

The business question is **whether net revenue goes up**, and that is what we test directly:
net platform revenue per active viewer, one-sided, against zero. Revenue is the metric the
decision is made on, so revenue is the metric with the pre-registered test on it. Everything
else explains it.

**Where elasticity comes in — deliberately kept small.** Elasticity is the *translation layer*,
not the test. It does three jobs, each of which takes a paragraph, not a workstream:

1. **It sets the MDE before we ever look at variance.** For a pure price change, revenue is
   unchanged exactly when the midpoint own-price elasticity is −1. That is provable, not a rule
   of thumb (two lines of algebra, §11). So "how big a conversion lift do we need?" has a
   closed-form answer on day one: a 20.2% cut needs +25.3% units to break even.
2. **It is the sanity bridge.** The revenue test and the elasticity read must agree. If the
   revenue CI excludes zero but the implied elasticity sits at −0.9, something is wrong with the
   accounting — probably the take-rate mix or the ad offset.
3. **It generalizes the result off the tested point.** Two cells give you *one point* on the
   demand curve, not the curve. That limit is worth stating out loud, because the PM's next
   question is always "so what's the optimal price?" and the honest answer is "this design
   can't tell you — that needs 3–4 price cells, and here's the power cost."

That is the whole economic layer. It earns its place by making the design sharper up front and
the readout more useful at the end, without turning the notebook into a demand-estimation project.

---

## 2. Why this experiment is worth building

Three properties make it the right practice vehicle, and each maps to something a Twitch
interviewer will actually probe:

| Property | Why it's forced | What it teaches |
|---|---|---|
| **Randomization must be at the channel level** | Chat is public. Two viewers in the same stream seeing R$9.90 and R$7.90 will screenshot it within minutes. It's a fairness problem, a PR problem, and it destroys the counterfactual. | Cluster randomization, ICC, design effect, power recovery |
| **The outcome is revenue = price × quantity** | Conversion going up is guaranteed and uninformative | Revenue as the OEC; elasticity as the translation layer that sets the MDE |
| **Subscribers get ad-free viewing on that channel** | Winning a sub *destroys ad inventory*. Commerce's win is partly Ads' loss. | Cross-product cannibalization, net-platform P&L |

The third one is the reason this fits the *Commerce, Ads & Sponsorships* scope specifically: a
Commerce-only readout of this experiment is **wrong**, not just incomplete.

---

## 3. Hypotheses

- **H1 (primary).** Cutting Tier 1 from R$9.90 to R$7.90 increases **net platform revenue per
  active viewer per week** in treated channels.
- **H0 (null).** The cut does not increase net platform revenue per active viewer.
  One-sided test at α = 0.05. Equivalent statement in economic terms, used as a cross-check:
  midpoint own-price elasticity ε ≥ −1.
- **H2 (mechanism).** New-subscriber conversion rate rises; ARPPU falls by construction (−20.2%).
- **H3 (cannibalization).** Ad impressions per viewer-hour fall in treatment, because new
  subscribers stop seeing pre-roll and mid-roll on that channel.

---

## 4. Metrics

### 4.1 Primary (the OEC)

**Net platform revenue per active viewer per week (R$).** Defined as, per viewer-week:

```
net_rev = twitch_share × sub_revenue          # take rate is 50% standard / 30% Partner Plus
        + bits_margin  × bits_revenue
        + ad_share     × (impressions/1000 × CPM)
```

Two deliberate design choices baked in:

- **Net, not gross.** The take rate varies by channel (50/50 vs. Partner Plus 70/30). A price cut
  that lands disproportionately on 70/30 channels is worth less to Twitch than the same cut on
  50/50 channels. Gross revenue hides this. Take rate is a channel attribute in the DGP and a
  stratification variable in the randomization.
- **Per active viewer, not per channel.** Denominators are a design decision. Per-channel totals
  are dominated by three mega-channels; per-viewer is the ratio the business actually reasons about.
  (The consequence — that the analysis unit is nested inside the randomization unit — is the whole
  statistical problem, handled in §7.)

### 4.2 Secondary (mechanism / decomposition)

New-sub conversion rate per active viewer · subs per 1k viewer-hours · ARPPU · gift-sub rate ·
Bits spend per viewer · ad impressions per viewer-hour · Tier 2/3 mix (trade-down check).

Secondaries **explain** the primary. They do not override it. Benjamini–Hochberg across the family.

### 4.3 Guardrails

Watch time per viewer · returning-viewer rate · streamer-side complaints / opt-outs · refund and
chargeback rate · support contacts · Tier 2→Tier 1 trade-down.

Guardrails get **non-inferiority tests against a pre-declared margin**, not "p > 0.05."
"We failed to detect harm" is not "we detected no harm," and an interviewer will ask.

### 4.4 Long-run

**30-day renewal rate of the treated acquisition cohort.** A subscription price change is not
resolved until the first renewal. If cheaper subscribers churn faster, the acquisition win is a
mirage. This is why the experiment runs ≥ 5 weeks, not 2.

---

## 5. Design

| Parameter | Choice | Reasoning |
|---|---|---|
| Randomization unit | **Channel (streamer)** | Price visibility leaks within a chat |
| Analysis unit | **Viewer-week** | Business denominator; forces clustered inference |
| Assignment | **Stratified** on channel-size decile × take-rate tier × content category | Channel size is power-law; simple randomization hands you a whale imbalance ~1 run in 5 |
| Allocation | 50/50 | No reason for unequal allocation; cost of treatment is symmetric |
| Exposure population | Viewers who render the sub button in an assigned channel | Everyone else is untreatable dilution |
| Eligibility | New/lapsed subscribers only | **Existing subs are not repriced mid-flight** — see §6.1 |
| Duration | 5 weeks (1 burn-in + 4 measured), covering one renewal cycle | Novelty decay + renewal |
| Analysis date | Pre-registered, no peeking; sequential boundaries if we must look early | |

---

## 6. The three traps I want to walk into on purpose

These are the parts most candidates miss, so the notebook stages each one, lets it bite, then fixes it.

### 6.1 The experiment answers a narrower question than the decision requires

We can only test the price on **new** subscribers. Repricing the existing base mid-experiment is a
customer-experience and legal landmine, so nobody does it. But if we *ship*, the existing base
eventually pays R$7.90 too — a mechanical −20.2% on revenue we already have, with zero volume
upside attached.

**That term is unmeasurable by this experiment and must be added analytically to the P&L.**
An experiment can be clean, significant, and positive, and the ship decision still negative. This
is the single most important idea in the whole build.

### 6.2 The naive power calculation is off by an order of magnitude

Viewers are nested in channels and correlated within them. The variance inflation is the design
effect, and with unequal cluster sizes it is not the textbook formula:

```
DEFF = 1 + ((1 + CV²)·m̄ − 1)·ρ        # CV = coefficient of variation of cluster size
```

On a power-law channel-size distribution CV is large, so DEFF is brutal. The notebook computes the
naive number, the analytic-DEFF number, and the simulation-based number, and shows how far apart
they are. Then it recovers the power (§7).

### 6.3 A viewer-level t-test on cluster-randomized data is not a little wrong

The A/A section runs the full pipeline on a world with **zero** true effect, several hundred times,
and reports the empirical false-positive rate of each estimator. The naive viewer-level t-test
should land far above 5%. Seeing that number, on your own simulated data, is worth more than
reading about it.

---

## 7. Power, and how we get it back

Stage 1 is the plan someone would write in a hurry: 300 channels, 3 weeks. Simulation says that is
badly underpowered. Then we add levers one at a time and plot the marginal contribution of each:

1. **Stratified assignment** on size × take rate — removes between-cluster variance the design can't
2. **CUPED** on pre-period spend — the largest single lever here, because pre-period spend is the
   best predictor of post-period spend
3. **Winsorization / capping** of whale spend — heavy tails; declare the rule *before* seeing data
4. **Capping mega-channel weight** or excluding the top-k from the randomization pool
5. **Longer duration** (more viewer-weeks per cluster — note this has diminishing returns under
   clustering, which is itself the point)
6. **More channels** — the only lever that actually beats the design effect

The output is a defensible `n_channels` and duration, plus the honest statement of what MDE we can
and cannot detect. Being able to say *"we could not have detected the effect you're asking about"*
is a senior answer.

---

## 8. Analysis plan (frozen before data)

**Primary estimator:** cluster-robust OLS on viewer-week outcomes with channel-clustered SEs,
CUPED-adjusted, strata fixed effects. One-sided test against zero on net revenue per active
viewer. The implied elasticity is reported next to it as a consistency check, not as a second test
— one pre-registered decision rule, not two.

**Reported alongside, as a robustness panel** — if these disagree, that is the finding:

| Estimator | Why include it |
|---|---|
| Aggregate-then-t-test (channel means) | Impossible to get wrong; the sanity floor |
| Cluster-robust OLS (CR2 / small-sample correction) | Efficient, but CR1 is anti-conservative with few clusters |
| Mixed effects (random intercept per channel) | Efficient under correct spec; sensitive to misspec |
| Cluster bootstrap (wild bootstrap-t) | Best small-cluster coverage |

**Pre-declared:** trimming rule, exclusion rules, handling of channels that go dark mid-flight,
the exact analysis date, the BH family for secondaries, the non-inferiority margins for guardrails,
and the two heterogeneity cuts we are allowed to call confirmatory (channel size, viewer tenure).
Everything else is exploratory and gets labeled as such, with shrinkage applied for winner's curse.

---

## 9. Health checks before any effect is read

SRM at cluster level and at viewer level (the second can fail even when the first passes — if
treatment changes who shows up, that's interference, not a bug) · exposure/trigger logging
symmetry · missingness by arm · day-of-week and ramp · novelty decay · pre-period placebo ·
balance table on covariates not used for stratification.

**If health checks fail, the experiment is not read.** Not "read with caveats."

---

## 10. Notebook structure

One notebook, executed with outputs committed so it renders on GitHub:
`twitch_pricing_experiment.ipynb`

| § | Section | Core idea |
|---|---|---|
| 1 | The business question | Objective, decision, scope boundary |
| 2 | Unit of randomization | Leakage structure sets the unit |
| 3 | Network and Bayesian angle | Interference as a network problem; where hierarchical models earn their place |
| 4 | Metrics and decision rule | Pre-registered, five conditions |
| 5 | The simulated world | Sealed generating parameters |
| 6 | Simulator validation | Does it look like the product |
| 7 | Power three ways | Naive, design effect, simulation |
| 8 | Buying the power back | Pair matching, CUPED, analyse as you randomise |
| 9 | Randomization and balance | Standardised differences, not p values |
| 10 | A/A test | False positive rate by estimator |
| 11 | Running the experiment | One draw, one read |
| 12 | Health checks | SRM, placebo, instrumentation, dilution |
| 13 | Primary analysis | Five estimators, two estimands |
| 14 | Elasticity read | Break-even at -1, and what two cells cannot say |
| 15 | Secondaries and guardrails | BH family, non-inferiority margins |
| 16 | Heterogeneity | Partial pooling, winner's curse |
| 17 | Cross-channel interference | ITT against GTE, exposure dose-response |
| 18 | The ship decision | Existing-base repricing, threshold analysis |
| 19 | Opening the sealed envelope | Did the machinery recover the truth |
| 20 | Decision memo | Verdict first |
| 21 | Interview drill | Likely questions, short answers |

### The sealed envelope

The DGP's true parameters — the real elasticity, the real cross-effects — are set in §2 but
**not stated in prose** until §16. We analyze the data the way we would if we didn't know, then
check whether the machinery recovered the truth. That is simulation validation, and it is the only
honest way to run a teaching experiment on synthetic data.

### Teaching mechanic

Each section runs: **Your call** (one question, before the answer) → **The standard answer**
(what a strong candidate says in 60 seconds) → **The code** → **What's really being tested**
(the interviewer's actual intent).

The 60-second answer comes *first*, before the sophisticated version, in every section. That
ordering is deliberate — it is the discipline of establishing the simple defensible answer before
reaching for the advanced one.

---

## 11. Known threats to validity

| Threat | Direction | Mitigation |
|---|---|---|
| Viewers watch multiple channels and see both prices | Dilutes toward null; may cause price confusion | ITT on primary-channel attribution; single-channel-viewer subgroup as sensitivity |
| Streamers discover the test and discuss it on social | Contaminates control, adds novelty | Short duration; monitor; pre-plan an abort rule |
| Novelty / pull-forward of subs that would have happened anyway | Inflates early effect | Burn-in week excluded; renewal cohort read |
| Heavy-tailed spend, few whales | Inflates variance, unstable estimates | Pre-declared winsorization; bootstrap; quantile TEs |
| Power-law channel sizes | Imbalance risk, huge DEFF | Stratification; cap or exclude top-k |
| Seasonality, esports events, platform incidents | Common shock, mostly differenced out | Balanced strata, calendar-aware window |
| Existing base cannot be repriced in-flight | Experiment overstates ship value | Analytic P&L term (§6.1) |
| Ad revenue loss from ad-free subs | Offsets Commerce's win | Measured directly as a secondary |
| Only one market tested | External validity | State the limit; propose staged geo rollout |

---

## 12. Honest framing of this artifact

This is a **simulation study I designed and built**, not a shipped experiment at a company. In an
interview it should be described that way, without hedging and without inflation. What it
demonstrates is design judgment, knowledge of the failure modes, and the ability to reason from a
statistical result to a revenue decision — which is what the question "have you run experiments?"
is actually probing.

Presenting synthetic work as production work is the fastest way to lose a loop. Presenting it
accurately, with a sharp point of view on the tradeoffs, is a strong answer.

---

### Sources for the real-world structure

Local Tier 1 pricing and regional variation · 50/50 vs. Partner Plus 70/30 revenue splits ·
Bits economics · subscribers receiving ad-free viewing on the subscribed channel.
See links in the chat thread; all figures are public and used only to keep orders of magnitude
plausible.

---

## 13. Outcome

The experiment was run. Summary, for the record, against what this document committed to in advance:

| Pre-registered condition | Result |
|---|---|
| Health checks pass | Pass. SRM clean at both levels, pre-period placebo null. |
| Primary effect positive, one-sided at 5% | Pass. Net revenue per eligible viewer +1.38% (CI +0.54% to +2.22%), p = 0.0007. |
| Both guardrails clear non-inferiority at 2% | **Fail.** Bits revenue per viewer -3.1%, interval reaching -4.8%. |
| Effect corrected for cross-channel interference | Corrected estimate +0.30%, an interference haircut of about 78%. |
| Full ship P&L positive after existing-base repricing | **Fail.** Repricing the base costs roughly 34x the corrected gain. |

Recommendation: do not ship the flat cut. Test a discounted first month instead, which captures the acquisition elasticity without repricing anyone already paying.

The full readout is in `twitch_pricing_experiment.ipynb`, section 20.

Two conditions failed independently. Writing all five down before seeing data is what made that a finding rather than a negotiation.
