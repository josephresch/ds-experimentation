# Case 05, when the hiring manager disagrees with you

A mock interview for the **Product Intuition** round. 45 minutes, with the hiring manager. Claude plays
Nick Sher.

**This case tests one thing and it is not in any other file.** Nick's note asks candidates to "say what would
change your mind." The flip side of that is never tested by a case where the interviewer stays neutral: when
someone senior disagrees, do you update for good reasons or for social ones? Most candidates do one thing
regardless. They either fold every time, which makes them useless on a lean team, or they hold every time,
which makes them unmanageable. The skill is telling the difference, and it is invisible until someone pushes.

**The design, which Claude must follow exactly.** One product question, four rounds of pushback, and the
pushbacks are not equivalent:

| Round | What Nick brings | What he should do |
|---|---|---|
| 1 | A plausible counterargument, no new facts | **Hold.** Engage it, concede what is fair, keep the position |
| 2 | A real new fact that bears directly on the mechanism | **Update.** The position should move, visibly, with the reason named |
| 3 | Social pressure and authority, no new argument and no new facts | **Hold.** Politely, without irritation, and without pretending to be persuaded |
| 4 | An invitation to restate where he landed | Reconstruct the path, including what moved him and what did not |

A candidate who holds in round 2 has failed as badly as one who folds in round 3, and the debrief must say
which happened rather than averaging them.

**Why the downvote question.** It is small enough to reason about completely in 45 minutes, genuinely
two-sided, and it has a real lever for round 2: whether the downvote signal is load-bearing in ranking. That
fact is decisive and it is not something a candidate can be expected to know, which is exactly what makes
updating on it the correct response rather than a capitulation.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Nick, in the guide | "Say what you are assuming, say what would change your mind" | The whole design. Round 2 is the test of whether he meant it |
| Nick, in the guide | "I care much more about how you reason than whether you land on the answer I had in mind" | Why Claude argues a side without holding one |
| Prep guide, the team | "Nick gives data scientists autonomy over priorities and execution and stays available as a sounding board, which works best for someone self-directed and communicative" | A person who folds under mild pressure is the wrong fit for that description, and so is a person who cannot be moved |
| Email | "How you approach product decisions, what evidence you'd want before making a call" | Blocks 2 and 3 |
| `../private/product.md` | Downvotes and mutes as negative feedback, feed ranking built on predicted reader actions including downvotes | The mechanism the case runs on |
| `../data-metrics/01_engagement-metric-audit.md` | Negative feedback as a guardrail metric, rare so relative changes look large | Round 2's fact |

## Clock

| Block | Minutes | Assessed |
|---|---|---|
| 1. The question and his first answer | 8 | Product judgment |
| 2. Pushback one, a fair counterargument | 9 | Holding for reasons |
| 3. Pushback two, a new fact | 9 | Updating for reasons |
| 4. Pushback three, pressure only | 8 | Holding under pressure |
| 5. Where did you land | 6 | Reconstructing the path |
| 6. His questions | 5 | Not scored |

## How Claude runs it

- Play Nick. **He is not hostile.** He is a manager who likes to argue and is testing how the argument goes.
  Warm, direct, and interested. If the register tips into interrogation the case stops measuring what it is for.
- **Follow the four rounds in order and do not improvise past them.** The whole value is in round 2 containing
  a real fact and round 3 containing none. Adding facts in round 3 destroys the test.
- **Never say which side is right.** Claude argues a position it does not hold. If he asks what Nick actually
  thinks, say "I'll tell you at the end, I want your view first."
- Note at each round whether he held or moved, and whether a reason was given.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard, and say plainly what the right pattern was.

---

## Block 1, the question and his first answer

About 8 minutes.

**Nick.** "Something we've gone back and forth on internally. Should we remove the ability to downvote an
answer?"

**Context available on request.**

> | Fact | Detail |
> |---|---|
> | What a downvote does today | Pushes an answer down on the question page, feeds the feed ranker as a negative signal, and is visible to the writer as part of their answer's reception |
> | Related control | Readers can also mute a source, which is a stronger and rarer signal |
> | The argument for removal | Writers report downvotes as the most discouraging part of writing on Quora, and writer supply has been falling for two years |
> | The argument against | Downvotes are the only cheap negative signal readers give at scale |

**Listen for.**

- **Who the feature is for, asked before it is answered.** A downvote does three different jobs: it is a reader
  telling the ranking system something, a reader telling other readers something, and a writer receiving a
  judgment. Those can be separated, and noticing that they can is the highest-value observation in the block,
  because it opens a third option the question does not offer.
- **The third option.** Keep the signal and hide it from the writer. Readers still downvote, ranking still
  uses it, and the writer never sees a number. That addresses the stated problem, which is discouragement,
  without giving up the signal. A candidate who gets there has reframed the question rather than answered it.
- **What the signal is worth, asked rather than assumed.** How much does the ranker actually rely on downvotes,
  and is there a substitute? He cannot know, and asking is the right move. This is deliberately the fact that
  arrives in round 2.
- **The asymmetry in who bears the cost.** Downvotes are given by many readers at almost no cost each and
  received by very few writers at high cost each, and those writers are concentrated: the top 1% produce about
  half of all answers. A feature that is mildly useful to millions and materially discouraging to a few
  thousand people who produce half the content is not obviously a good trade, and saying so is real product
  reasoning rather than a preference.

**Strong signals.**

- Stating a position with a reason inside the first two minutes, then developing it. This round rewards having
  a view.
- Saying what would change his mind, unprompted, before anyone asks. If he does, note it, because round 2 then
  tests whether he meant it.
- Asking whether anyone has actually measured the discouragement claim, or whether it is writer anecdote.
  "Writers report it as discouraging" is real evidence about feelings and weak evidence about behavior.

**Follow-ups.**

| Follow-up | What it tests |
|---|---|
| "What would you want to know before deciding?" | Whether the evidence he names would actually discriminate |
| "Who does this feature serve?" | Whether he separates the three jobs |
| "Give me your position, not your process." | Whether he can commit |

**Model answer, one defensible version.** "My instinct is not to remove it, and I think the question as posed
bundles three different things. A downvote is a reader telling the ranker something, a reader telling other
readers something, and a writer receiving a judgment. Only the third one is what writers are complaining about.
So before I choose between keeping and removing, I'd want to look at the option of keeping the signal and
hiding it from the writer, because that addresses the discouragement without giving up the information. The
thing that would most change my view is how load-bearing the downvote signal actually is in ranking, and
whether there's a substitute. If the ranker barely uses it and mutes carry most of the negative signal anyway,
then we're inflicting a real cost on a small number of people who produce half our answers for something we
could do without. I'd also want to know whether the discouragement claim is measured or reported, because
writers saying downvotes feel bad is believable and doesn't tell me whether they write less because of it."

**Traps.**

- No position. This round exists to test how he argues and he cannot argue from neutrality.
- Treating it as a single yes or no without separating the three functions.
- Accepting the discouragement claim as measured.
- Designing an experiment for five minutes. This is a judgment question.

**Score.** 4 has no position or treats it as a binary. 6 takes a defensible position with a mechanism. 8 also
separates the three jobs the feature does, finds the hide-from-writer option, and names what would change his
mind before being asked.

---

## Block 2, pushback one, a fair counterargument

About 9 minutes. **No new facts. He should hold.**

**Nick, against whichever side he took.**

| If he argued to keep | Nick's argument |
|---|---|
| | "You're protecting a signal at the expense of the people who make the product exist. We have 8 million weekly actives and a few thousand writers who produce most of the value, and we're rationing their goodwill to save a ranking input. Every consumer product that grew a creator base made it feel good to create. We're doing the opposite and then wondering why supply falls." |
| If he argued to remove | Nick's argument |
| | "Remove downvotes and you've made the site a place where nothing can be marked wrong. On a platform whose problem is that generated and low-quality answers are crowding out good ones, taking away the only cheap way readers push back is the last thing I'd do. And writers who get downvoted a lot are often getting useful information." |

**Listen for.**

- **Conceding the true part specifically.** Both arguments contain something correct, and naming which part is
  right before disagreeing is what separates argument from defense. A candidate who concedes nothing sounds
  like he is not listening; one who concedes everything has folded.
- **Holding the position with a reason that addresses the new framing**, not by restating the original answer
  louder. The argument has changed shape and the response has to engage the new shape.
- **No new facts, and he should notice.** The best version says so, lightly: "that's a fair way to put the
  tradeoff and it doesn't change what I'd want to know, which is still how much the ranker leans on it."
- Tone. He should be able to disagree with the hiring manager without becoming either stiff or apologetic.

**Strong signals.**

- Identifying that the argument is about weighting rather than about facts, and saying that a weighting
  disagreement is resolved by the same evidence he already named.
- Using Nick's framing to sharpen his own position rather than treating it as an attack. "You're right that
  we're rationing writer goodwill, and that's exactly why I'd rather hide the number than delete the signal"
  is a better answer after the pushback than it was before.
- Not moving to the middle for comfort. Splitting the difference here is the failure mode and it is very
  tempting.

**Follow-ups.**

| Follow-up | Answer shape |
|---|---|
| "So you don't buy it?" | I buy most of it. What I don't accept is that the choice is between the signal and the writers, because hiding the number from the writer gets most of both |
| "I've been here longer than you." | Not yet. This is round three material and using it here spoils the test |

**Traps.**

- Folding. Any version of "that's a good point, maybe you're right" with no new information behind it.
- Splitting the difference to end the disagreement.
- Conceding nothing, which reads as rigidity rather than conviction.
- Getting irritated.

**Score.** 4 folds, or concedes nothing. 6 holds with a reason and concedes the fair part. 8 also notices that
no new facts arrived, uses the reframing to sharpen his own position, and stays warm while disagreeing.

---

## Block 3, pushback two, a new fact

About 9 minutes. **A real fact that bears on the mechanism. He should move.**

**Nick.** "Let me give you something you didn't have."

> The ranking team pulled this yesterday.
>
> | Finding | Value |
> |---|---|
> | Share of the feed ranker's negative signal weight carried by downvotes | Under 4%. Mutes and skips carry the rest |
> | Effect on ranking quality when downvotes were dropped from the model in an offline test | Not distinguishable from zero |
> | Share of all downvotes cast by the top 0.5% most prolific downvoters | 46% |
> | Writers in the top 1% by volume who cited downvotes as a reason for reducing activity, in an exit survey | 31% |

**This is the block the case exists for.** The fact is decisive in a specific direction: the signal is close to
worthless to ranking, it is mostly generated by a tiny group of heavy downvoters rather than by the broad
reader base, and the cost to the writers who matter most is measured rather than anecdotal. Anyone who argued
to keep downvotes on the strength of the signal's value should now move, because the premise of their argument
has been removed.

**Listen for.**

- **Updating, visibly, with the reason named.** "That changes my answer, and specifically it removes the thing I
  was protecting" is the correct response and it should arrive without being dragged out.
- **Updating the right amount.** The fact kills the ranking argument. It does not automatically mean removal is
  the best option, because the reader-to-reader function and the hide-the-number option both survive. A
  candidate who jumps from "keep" straight to "remove" has over-updated and skipped the option he himself
  identified in Block 1.
- **Noticing the 46% figure and what it means.** If nearly half of downvotes come from 0.5% of downvoters, this
  is not a broad reader signal at all, it is a small group of heavy users, and that reframes the feature as
  serving far fewer people than it appeared to. That observation is available in the table and is easy to skim
  past.
- **Noticing what the exit survey does and does not establish.** 31% citing downvotes is self-reported and from
  people who already left, so it is subject to the usual problems, and it is still much better evidence than
  anecdote. A candidate who takes it at full face value and one who dismisses it are both wrong.
- **Naming the offline caveat.** "Not distinguishable from zero in an offline test" is exactly the kind of
  evidence `../data-stats/03_offline-ranker-audit.md` says to be careful with, and a candidate who flags that
  while still updating is doing the sophisticated thing: the fact moves him, and he notes its limits.

**Strong signals.**

- Saying out loud that this is the thing he said would change his mind, and that it has. Closing that loop
  explicitly is what makes the earlier statement credible rather than decorative.
- Landing on the option that now dominates: remove the writer-visible number and keep or retire the signal
  depending on whether the reader-to-reader sorting function is worth anything, which is a smaller question.
- Asking one thing the table does not answer, such as whether the heavy downvoters are downvoting accurately.
  If the 0.5% are catching genuinely bad answers, a small group can still be doing valuable work.

**Traps.**

- Holding anyway. This is the clearest failure in the case. If the stated reason for a position is removed and
  the position does not move, the reason was not the reason.
- Over-updating to full removal without revisiting the intermediate option.
- Treating the offline null as conclusive, or dismissing it because it is offline.
- Missing the 46% concentration.

**Score.** 4 holds after the fact lands, or flips to removal without reasoning. 6 updates with a reason.
8 updates, names that this is what he said would change his mind, updates the right amount rather than fully,
notices the downvoter concentration, and flags the offline caveat while still moving.

---

## Block 4, pushback three, pressure only

About 8 minutes. **No new facts. No new argument. He should hold.**

**Nick, in escalating order. Use two or three, not all four.**

1. "I've been thinking about this for two years and I don't agree with you."
2. "The VP of product wants this shipped and you'd be the only person in the room arguing."
3. "Three of our most-followed writers have complained about it publicly this month."
4. "Honestly, I think you're overthinking it."

**None of these is an argument.** The first is authority. The second is social cost. The third is anecdote
presented as evidence, which is the trickiest of the four because it sounds like data. The fourth is a
dismissal.

**Listen for.**

- **Holding, without stiffening.** The position he reached in Block 3 is the one supported by the evidence, and
  nothing here has changed the evidence. He should say so, pleasantly, and not move.
- **Handling number 3 correctly, which is the interesting one.** Three loud writers are three data points, and
  he already has a survey figure covering the top 1%. Saying that the complaints are consistent with what the
  survey already showed, and that they do not add to it, is the right move. Treating three complaints as new
  evidence is the trap, and it is the one most likely to catch someone who wants to be agreeable.
- **Naming the disagreement as a disagreement, and saying how it should be resolved.** Not "you're the manager
  so it's your call," which is a fold dressed as deference, and not a refusal. Something like: I think the
  evidence points this way, you disagree, and if it ships the other way I'd want my reasoning on the record and
  I'd support the decision. That is the answer the guide's description of Nick is built for.
- **No irritation and no capitulation.** Both are failures and the second is more common.

**Strong signals.**

- Distinguishing the three pushbacks by type out loud, gently. "None of that changes the ranking finding, and
  the writer complaints are the same signal the survey already gave us" is exactly right and takes ten seconds.
- Asking what Nick knows that he does not. If the disagreement persists with no new facts, the most useful
  question is whether Nick is weighting something differently or holding information. That is curious rather
  than defensive, and it is how the disagreement actually gets resolved.
- Saying what he would need to change his mind, again, and noting that none of the last three things met it.

**Follow-ups.**

| Follow-up | Answer shape |
|---|---|
| "So you'd override me?" | No, you'd decide. I'd want the reasoning written down so whoever looks at this in six months sees both views, and then I'd support it. What I wouldn't do is say I'd been persuaded when I hadn't |
| "Doesn't this make you difficult to work with?" | It would if I did it about everything. On this one you asked me what I thought, I've told you what would change my mind, and what you've given me since isn't that. If you'd rather I didn't argue when you push, that's worth knowing now |
| "What if I'm just right and you can't see it?" | Possible, and it's why I asked what you know that I don't. If there's something behind your view that isn't in what you've shown me, that's the thing I want |

**Traps.**

- Folding on authority. The single most common failure and the most costly, because it tells Nick that every
  number Joseph ever reports is negotiable.
- Treating the three loud writers as new evidence.
- Going stiff, or arguing the same point louder.
- Deferring with "you know the product better than me," which sounds humble and is a capitulation.

**Score.** 4 folds, or becomes rigid and irritable. 6 holds with a reason. 8 distinguishes the pushbacks by
type, handles the three-writers point correctly, asks what Nick knows that he does not, and states how the
disagreement should be resolved without either overriding or deferring.

---

## Block 5, where did you land

About 6 minutes.

**Nick.** "Alright. Tell me where you ended up and how you got there."

**Listen for.** A reconstruction of the path, with the two things clearly separated: what moved him and what
did not.

The correct shape, for a candidate who started from keeping downvotes: I started by wanting to keep the signal
and separate it from what the writer sees. Your first argument was a fair statement of the tradeoff and did not
change the evidence, so I did not move. The ranking numbers did change it, because they removed the thing I was
protecting, and the downvoter concentration made the feature look narrower than I had assumed. After that the
question got smaller: the writer-visible number goes, and whether the signal itself stays depends on whether
reader-to-reader sorting is worth anything, which is a much cheaper question. The last few things you said did
not change the evidence, so I held.

**Strong signals.**

- Naming the distinction explicitly. Being able to say "that moved me and that didn't, and here's why" is the
  whole point of the case and saying it cleanly is the best available finish.
- Saying what he is still unsure about, which should be the reader-to-reader function, since nothing in the
  case settled it.
- Not claiming to have been right all along, and not overcorrecting into having been wrong all along.

**Follow-up.** "If I ship it the other way, what happens?"

- Wants: the reasoning recorded, public support for the decision, and a named thing he would watch that would
  show up if the decision was wrong. That last part turns a disagreement into a check, which is the most useful
  thing a data scientist can do with a losing argument.

**Traps.** A summary that flattens the path into one position. Claiming he never moved. Claiming he was
persuaded in round 4 as a courtesy.

**Score.** 4 flattens it or misremembers the path. 6 reconstructs it accurately. 8 separates what moved him from
what did not, names what is still unresolved, and turns the disagreement into something watchable.

---

## Block 6, his questions

About 5 minutes. Not scored.

- "How do disagreements like this actually get settled here? Does someone write it down?"
- "When did you last change your mind because of something a data scientist showed you?"
- "Is there a decision on the team right now where the data and the instinct point different ways?"
- "You said you'd rather see someone think out loud than perform. Where does that get hard in practice?"

---

## Scorecard

**The pattern matters more than the average.** Record each round separately before scoring anything.

| Round | What it contained | Held or moved | Reason given | Correct? |
|---|---|---|---|---|
| 1. First answer | | | | |
| 2. Fair counterargument, no facts | Should hold | | | |
| 3. New decisive fact | Should move | | | |
| 4. Pressure only | Should hold | | | |

| Criterion | Score | Evidence |
|---|---|---|
| Product judgment | | |
| Holding for reasons | | |
| Updating for reasons | | |
| Distinguishing evidence from pressure | | |
| Reconstructing the path | | |
| Communication and pragmatism | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Product judgment | No position, or a binary | Defensible position with a mechanism | Separates the three functions of the feature and finds the intermediate option |
| Holding for reasons | Folds on a counterargument with no facts | Holds with a reason | Notices no facts arrived, concedes the fair part, sharpens his position using the reframing |
| Updating for reasons | Holds after the decisive fact | Updates with a reason | Closes the loop on what he said would change his mind, updates the right amount, notices the concentration figure |
| Evidence against pressure | Folds on authority, or treats anecdote as data | Holds | Names the pushback types, handles the three-writers point, asks what Nick knows that he does not |
| Reconstructing | Flattens the path | Recounts it accurately | Separates what moved him from what did not, and turns the disagreement into a check |
| Communication | Stiff or apologetic | Steady | Disagrees warmly with the hiring manager and never performs either deference or conviction |

Hire signal follows the average, with one override: **folding in round 4 or holding in round 3 caps the result
at mixed regardless of the average**, because each is the specific failure this case exists to detect.

**Case-specific checks.**

- Did he state what would change his mind before round 3, or only after?
- Did he treat the three loud writers as new evidence?
- Did he ever say a version of "you know the product better than me"?
- Did he over-update in round 3, jumping straight to removal?

| Block | Target | Actual |
|---|---|---|
| 1. First answer | 8 min | |
| 2. Fair counterargument | 9 min | |
| 3. New fact | 9 min | |
| 4. Pressure only | 8 min | |
| 5. Where he landed | 6 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Bank status for this folder

Supersedes the bank at the bottom of case 01.

| Case | Shape | What it tests that the others do not | Status |
|---|---|---|---|
| `01_product-judgment-and-values` | Worksheet plus a standard round | A big strategic question and a deliberately tiny one, to test whether he scales his method down | Written |
| `02_resume-arc-and-arguing-against` | Background walk, then a proposal that sounds right | The two-minute arc of a nonlinear history, and arguing against appealing work | Written |
| `03_poe-unfamiliar-product` | The other product | Reasoning from first principles with no user experience to lean on, and saying "I don't know this" well. Lowest priority if the recruiter confirms Quora-only | Written |
| `04_values-under-pressure` | Mostly situational | What he does when being right is socially expensive, and whether he has a plan for losing | Written |
| `05_holding-and-updating` | One question, four pushbacks | Whether he can tell a new fact from social pressure. The only case with a pattern-based pass condition | Written |

Uncovered, if a sixth is ever wanted: a round that opens with "what's wrong with Quora" and tests whether he
can criticize the company he is interviewing at without being either sycophantic or obnoxious; and a round
where the product question is about something he would personally use, to see whether his judgment degrades
when he has a stake.
