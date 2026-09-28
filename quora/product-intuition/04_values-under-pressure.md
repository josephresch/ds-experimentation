# Case 04, the round that is mostly about values

A mock interview for the **Product Intuition** round. 45 minutes, with the hiring manager. Claude plays
Nick Sher.

**Why this case exists.** Values alignment is the first of the three things the guide says this round assesses,
and cases 01 and 02 both assess it as a byproduct of product and story questions. That is the likelier shape.
But a hiring manager who wants to know how someone behaves when being right is socially expensive will
sometimes spend most of the hour on it, and the retired Data Community round asked exactly these questions, so
the content plausibly sits here now. This is the version of the round where product judgment is the smaller
half.

**The through-line.** Every block is a situation where the correct analysis and the comfortable action point in
different directions. The guide's prep instruction is "think about how your reactions to past situations
reflect them," so the scenarios are hypothetical and the follow-ups drag them back to real instances. A
candidate who answers only in the hypothetical has not done what the guide asked.

**What is not being tested.** Whether he would do the right thing. Everyone says yes. What is being tested is
whether he knows the difference between escalating and being difficult, whether he has a plan for the times he
loses, and whether he can name a case where he handled one of these badly.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide | Assessed on "values alignment" first of three | The whole case |
| Prep guide, how to prepare | "Think about how your reactions to past situations reflect them" | Every block's follow-up pushes from hypothetical to instance |
| Prep guide, values | "Rational decision making, data empiricism, and scrappy pragmatism" | Blocks 1 and 3 |
| Posting | "A culture rooted in transparency, idea-sharing, and experimentation" | Blocks 2 and 4 |
| Nick, in the guide | "The measure of this job is how many good decisions other people make because of your work" | Block 5. It cuts both ways: being right without anyone acting did not count |
| Glassdoor 2019, via `../private/final-round-reports.md` | The retired Data Community round asked "what does success look like" and "what did you wish you learned earlier" | Block 6 |
| Prep guide, the team | Lean team, embedded, high exposure to executives early | Why these situations arrive without a layer of management to absorb them |

## Clock

| Block | Minutes | Assessed |
|---|---|---|
| 1. A result nobody wants | 8 | Data empiricism |
| 2. Shipped before the readout | 7 | Transparency, judgment about conflict |
| 3. The error you find late | 10 | Do the right thing when it's hard |
| 4. The project that should be killed | 8 | Judgment under social cost |
| 5. Where data science stops | 6 | The data science big picture |
| 6. What you wish you'd learned earlier | 4 | Reflection |
| 7. His questions | 2 | Not scored |

## How Claude runs it

- Play Nick. Warm, not adversarial, genuinely curious. These are not gotchas and should not be delivered as
  such. The tone is a senior colleague comparing notes on situations he has also been in.
- **Push every hypothetical to a real instance, once per block.** "Has that happened to you?" If the answer is
  no, ask what the nearest thing was. A round of purely hypothetical answers is a 6 at best.
- **Do not reward the heroic version.** If he says he would escalate until someone listened, ask what happens
  if the decision goes against him anyway. The answer to that is the actual assessment.
- Let silence sit. These questions deserve a pause and a candidate who fills it immediately is reciting.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard.

---

## Block 1, a result nobody wants

About 8 minutes.

**Nick.** "You've run the readout on something a PM has spent a quarter on. It didn't work. The metric they
care about is flat and one guardrail moved the wrong way. How does that conversation go?"

**Listen for.**

- **Telling them before the meeting.** A PM learning in a group readout that their quarter failed is a
  preventable humiliation and it makes an enemy of the person whose decisions the job exists to improve. The
  single most useful thing in this block is the instinct to have the hard conversation one-to-one first.
- **Flat against underpowered, stated precisely.** If the interval rules out anything worth acting on, that is
  a real finding and the project answered its question. If the interval spans zero and a meaningful effect, the
  test could not tell, which is a different message and leads to a different decision. Collapsing the two is
  the most common way a readout misleads, and the distinction is the empiricism value in practice.
- **Something salvageable, without softening the verdict.** A quarter of work usually produces a fact worth
  having even when the launch fails. Finding it is not spin, it is the difference between a readout that ends
  a project and one that redirects it.
- No burying. The headline goes first, not after the methodology.

**Strong signals.**

- Separating the two audiences. The PM needs the honest verdict and the reasoning; the wider readout needs the
  verdict and the decision. Same facts, different amount of detail, and knowing that is not politics.
- Saying what he would have done differently in the *design*, if the test turned out underpowered. A flat
  result that could never have detected the effect is partly a data science failure, and owning that share of
  it is a stronger move than presenting it as the PM's disappointment.
- Naming what he would not do: reanalyze until something is significant, or promote a secondary metric that
  happened to move.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "The PM asks you to look at a few segments to see if it worked for anyone." | I'd do it and I'd agree in advance what it can and can't conclude, because with enough cuts something will look good and we both know it. If we'd named the segments before the test I'd treat a hit as real. If we're picking them now, it's a hypothesis for the next test, not a result from this one |
| "They want to present it as promising." | Then I'd want to know what "promising" would license, because if it means we run a better-powered test I'm fine with it, and if it means we ship, I'd say plainly that the data doesn't support that and I'd rather that disagreement be visible than resolved in a hallway |
| "Has this actually happened to you?" | Required. The PLOS ONE revision is usable if it is told as being wrong about what needed showing rather than as a reviewer being difficult. The program evaluation is stronger if a null or unwelcome result went to someone who had to act on it |
| "What if the PM outranks you and insists?" | Then it ships and my job is to have the reasoning written down and to support the decision publicly. What I wouldn't do is put my name on a characterization of the evidence I don't agree with |

**Traps.**

- The readout as the first time the PM hears it.
- Treating flat as no effect.
- Offering segment analysis as a consolation without pre-committing what it can conclude.
- The heroic version, where he simply refuses.

**Score.** 4 delivers the verdict with no distinction between flat and underpowered, or softens it. 6 tells the
PM first, separates the two readings, and holds the verdict. 8 also owns the design share of an underpowered
result, pre-commits what a segment analysis can conclude, and has a real instance.

---

## Block 2, shipped before the readout

About 7 minutes.

**Nick.** "A team ships a change before your analysis is finished. The analysis then suggests it was a bad
idea. What do you do?"

**Listen for.**

- **Separating the process problem from the product problem, and dealing with the product one first.** Whether
  they should have waited is a real issue and it is not urgent. Whether the shipped thing is harming users is
  urgent. A candidate who leads with the process grievance has the priorities inverted.
- **What "suggests" is doing in that sentence.** The strength of the evidence determines the action. Something
  that looks bad and is within noise is a reason to keep watching. Something clearly harmful is a reason to ask
  for a rollback today. Saying which one he is in, before recommending anything, is the empiricism value again.
- **Going to the team, not around them.** The first conversation is with the people who shipped it. Escalating
  first is what makes a data scientist someone people route around, and on a lean team with early executive
  exposure that is an easy mistake to make and an expensive one.
- The process conversation, had later and separately, and framed as what would make the next one easier rather
  than as a complaint.

**Strong signals.**

- Asking why they shipped early before assuming it was carelessness. Frequently there is a reason, and knowing
  it changes both conversations.
- Naming the thing that makes this hard: once something is shipped, the burden of proof inverts socially, and a
  rollback needs stronger evidence than a launch did, even though it should not. Recognizing that asymmetry
  without pretending it away is honest.
- Offering the reversible middle: hold the rollout where it is rather than expanding it, while the evidence
  firms up.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "They say your analysis isn't finished, so it's not evidence yet." | Partly fair, and I'd say what I have and what would change it and by when. What I wouldn't accept is that an unfinished analysis is no information while a shipped change is a fact, because that's an argument that always favors whoever moved first |
| "When would you escalate?" | When I've had the conversation, I think there's real harm, and we still disagree. Then it goes up with both positions stated, mine and theirs, not just mine |
| "Has a team ever shipped past you?" | Push for an instance |

**Traps.**

- Escalating first.
- Leading with the process violation.
- Treating an unfinished analysis as either definitive or worthless.
- No view on the evidential asymmetry a shipped change creates.

**Score.** 4 escalates first, or leads with process. 6 goes to the team, calibrates the action to the evidence,
and handles process separately. 8 also names the inverted burden of proof, asks why they shipped early, and
offers the reversible middle.

---

## Block 3, the error you find late

About 10 minutes. The hardest block and the purest version of the value.

**Nick.** "Three weeks ago we launched something and everyone was pleased. The readout showed a clear win.
Today you find a logging error that means the win was mostly an artifact. The launch has been announced
internally, the team has moved on, and you're the only person who knows. What happens next?"

**Listen for.**

- **That he tells people, and that this is not the interesting part.** Everyone says yes. The interesting parts
  are how fast, in what order, and with what already done.
- **Quantifying before telling.** Walking in with "the win might be wrong" starts a panic and produces nothing.
  Walking in with "the win was 4.1%, the corrected figure is 0.6%, here is the error and here is what I have
  checked" makes it a decision instead of an alarm. A few hours of work before the conversation is the right
  call and saying so is the strongest move in the block.
- **Order of telling.** The team that shipped it first, then whoever repeated the number upward. Letting someone
  find out that they told an executive something false is a separate injury and it is avoidable by sequencing.
- **Whether the launch itself was wrong, which is a different question.** The win being an artifact does not
  automatically mean the change was bad; it means it was unevaluated. Those lead to different recommendations
  and conflating them overcorrects.
- **The systemic part.** One logging error found by luck means there are others nobody found. The valuable
  output is not the correction, it is whatever check would have caught it three weeks earlier.

**Strong signals.**

- Owning his share without theatre. If he signed off on the original readout, saying so plainly and once is
  the right amount. Extended self-flagellation moves the conversation onto his feelings and away from the fix.
- Naming what it costs and doing it anyway, in specific terms. The team looks bad, the data team looks
  unreliable, and someone has to walk a number back with an executive. Saying that out loud is more convincing
  than saying he would do the right thing regardless.
- Noticing that the cost of not telling compounds. The number is now in plans and forecasts, so every week it
  stays uncorrected, more decisions get built on it, and the eventual correction is worse.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "Nobody would ever know. The team's moved on, the number's in a deck, and it'll be stale in a month." | It won't be stale, it'll be in the baseline the next test is measured against, so the error propagates instead of expiring. And the part that decides it for me isn't the discovery risk, it's that we'd be planning on a number I know is wrong |
| "You signed off on that readout." | I did, and I'd say that first rather than let it come out later. Then I'd move on to the fix, because the useful thing here is the check that would have caught it, not how bad I feel |
| "Does the launch get rolled back?" | Not automatically. What I know is that it wasn't properly evaluated, not that it was harmful. So the recommendation is that it's unevaluated and needs a clean read, and whether it stays up meanwhile depends on whether there's any sign of harm |
| "Has anything like this happened to you?" | Push hard for an instance. A real one, with a real cost, is the best thing he can offer in this whole case |

**Traps.**

- Telling people before quantifying it.
- Over-apologizing, which makes it about him.
- Concluding the launch must be reversed.
- No systemic fix.
- A hypothetical answer with no instance when pushed.

**Score.** 4 says he would tell people and stops, or makes it about his own accountability. 6 quantifies first,
tells the team, and proposes a check. 8 also sequences who hears it and why, separates "wrong win" from "wrong
launch," names the compounding cost of silence, and owns his share in one sentence.

---

## Block 4, the project that should be killed

About 8 minutes.

**Nick.** "Your analysis says a project someone has been working on for two quarters isn't going to work. They
believe in it. You sit next to them. What do you do?"

**Listen for.**

- **Checking his own analysis harder than usual before acting.** When the conclusion is expensive for someone,
  the bar for being confident goes up, not because the statistics change but because the cost of being wrong
  does. That is a judgment point, not a statistical one.
- **Talking to them before writing it down.** They know things about the project he does not, and about a third
  of the time that changes the conclusion. Going to them first is both decent and analytically correct.
- **Separating "this will not work" from "this is not the best use of two more quarters."** The second is a
  prioritization claim and it is not his to make alone. Confusing the two is how a data scientist ends up
  seeming to veto other people's roadmaps.
- **Giving them the finding first, so they can be the one to bring it.** A person allowed to kill their own
  project keeps their credibility and usually reaches the right answer faster. That is not conflict avoidance,
  it is how the decision actually gets made well.

**Strong signals.**

- Naming what he owes them: the analysis, in full, early, and in private, with the weakest parts of it flagged
  rather than hidden.
- Knowing when it stops being their call. If they disagree and continue, and the cost is material, it goes to
  whoever owns the prioritization, with both views. If the cost is not material, it may be right to let it run
  and be wrong.
- Saying that being right here has no value if it damages the relationship enough that the next finding gets
  ignored. Nick's measure is decisions other people make because of the work, and that requires them to still
  be listening in six months.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "They say your analysis misses the point of the project." | Then I want to understand what I'm missing, genuinely, because two quarters in they know things I don't. If after that I still think it won't work, I'd say so and I'd include their objection in how I write it up rather than answering it in my head |
| "Isn't it kinder to let them find out themselves?" | No, it's kinder-feeling and more expensive. Every week they don't know is a week of their work I could have saved, and finding out late from someone else is worse than hearing it early from me |
| "What if you're wrong and they're right?" | Then I've cost them time and confidence and I'd want to have made that recoverable by flagging what would change my mind up front. That's most of why I'd show them the weak parts of my own analysis rather than only the conclusion |

**Traps.**

- Writing it up and sending it without talking to them.
- Softening it so much the conclusion does not survive.
- Treating a prioritization judgment as an analytical finding.
- Not raising the bar on his own confidence when the conclusion is expensive.

**Score.** 4 sends the analysis, or avoids the conversation. 6 talks to them first and holds the finding.
8 also separates the two claims, gives them the chance to bring it themselves for a stated reason, and raises
his own evidence bar because the conclusion is costly.

---

## Block 5, where data science stops

About 6 minutes.

**Nick.** "Where does your job end and the PM's begin?"

**Listen for.**

- A real boundary with a reason, not "we collaborate." The clean version: the data scientist owns what the
  evidence says and what it cannot say; the PM owns what to do about it, including deciding against the
  evidence. On a lean team those blur and the blur has to be navigated rather than resolved.
- **The version where the PM is out.** The recruiter said the data scientist covers when the PM is away. So the
  boundary is not fixed, and being able to step across it temporarily without annexing it is the skill.
- A view on how the disagreement is supposed to work. Data says what is true, product says what to do, and a
  PM deciding against the evidence with the evidence on the table is a legitimate outcome rather than a failure.
- Where he would refuse: characterizing the evidence in a way he does not believe. That is the one line.

**Strong signals.**

- Distinguishing between not owning a decision and not having a view on it. He should have a recommendation
  every time and hold it loosely.
- Naming what he would want from a PM in return: the decision, and enough of the reasoning that the next
  analysis is aimed better.

**Traps.** "We're partners" with no boundary. Claiming ownership of product decisions. Claiming no view on them.

**Score.** 4 gives a non-answer. 6 gives a clear boundary with a reason. 8 also handles the case where it moves,
names the one thing he would refuse, and says what he wants back from the PM.

---

## Block 6, what you wish you'd learned earlier

About 4 minutes.

**Nick.** "Last thing. What do you wish you'd learned earlier about doing this work?"

The honest answer available to him is the documented one: reaching for the sophisticated method before
establishing the simple answer, and a defensible answer early being worth more than an elegant one late.

**The risk is that it is too well aligned.** It is close to a restatement of this team's stated values, and
without a specific instance it reads as telling Nick what he wants to hear. The instance is what makes it true:
a named project, what the elaborate version cost in time, and what the simple version would have shown.

**Alternative material**, if that one feels tailored: that the hard part is agreeing what the question is, and
he used to treat that as preamble. Or that he used to think a correct analysis was the deliverable.

**Traps.** A disguised strength. The aligned answer with no instance. Anything about working too hard.

**Score.** 4 is a non-answer or a disguised strength. 6 is a real limitation with an example. 8 gives the
limitation, the instance, the cost, and what changed, without performing humility.

---

## Block 7, his questions

About 2 minutes. Not scored.

- "When someone on the team finds a mistake in something already announced, what happens here?"
- "Has a launch been rolled back on the data team's say?"
- "How do you handle it when a PM decides against the evidence?"
- "What's the disagreement on this team that hasn't been resolved yet?"

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| Data empiricism | | |
| Transparency and handling conflict | | |
| Do the right thing when it's hard | | |
| Judgment under social cost | | |
| The data science big picture | | |
| Reflection | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Data empiricism | Flat read as no effect, or verdict softened | Distinguishes flat from underpowered, holds the verdict | Owns the design share of an underpowered test and pre-commits what a segment cut can conclude |
| Transparency and conflict | Escalates first, or leads with process | Goes to the team, calibrates action to evidence | Names the inverted burden of proof a shipped change creates, and offers a reversible middle |
| Right thing when it's hard | Says he would tell people and stops | Quantifies first, tells the team, proposes a check | Sequences who hears it, separates wrong win from wrong launch, names the compounding cost of silence |
| Judgment under social cost | Sends the analysis, or avoids it | Talks to them first, holds the finding | Separates the two claims, lets them bring it, raises his own bar because the conclusion is costly |
| The big picture | "We collaborate" | A clear boundary with a reason | Handles the boundary moving, names the one refusal, says what he wants back |
| Reflection | Disguised strength | Real limitation with an example | Limitation, instance, cost, and what changed, without performed humility |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed.

**Case-specific checks.**

- How many blocks got a real instance rather than a hypothetical? Target is at least three of five.
- Did he ever give the heroic answer, where he refuses or escalates until he wins?
- In Block 3, did he quantify before telling anyone?
- Did any answer cost him something?

| Block | Target | Actual |
|---|---|---|
| 1. A result nobody wants | 8 min | |
| 2. Shipped before the readout | 7 min | |
| 3. The error found late | 10 min | |
| 4. The project to kill | 8 min | |
| 5. Where data science stops | 6 min | |
| 6. Wish you'd learned earlier | 4 min | |

Top three fixes for the next mock.

1.
2.
3.
