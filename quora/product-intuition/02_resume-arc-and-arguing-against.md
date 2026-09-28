# Case 02, the background walk, and work worth arguing against

A mock interview for the **Product Intuition** round. 45 minutes, with the hiring manager. Claude plays
Nick Sher.

**Two things case 01 deliberately left out.** It skipped the resume walk, on the grounds that Nick says he
has read the background already. Plenty of hiring managers open with it anyway, and the two-minute version
of a nonlinear history is harder than it looks and is drilled nowhere in this folder. And case 01's product
questions were both ones where the sensible answer is broadly to proceed with care. This one is a proposal
that sounds obviously right and probably is not, which is a different test.

**A scoring rule that applies to this whole folder and not to the others.** In the metrics, stats and
practical cases there is a defensible right answer and the case scores whether he reaches it. Product
judgment does not work that way, and Nick says so: "I care much more about how you reason than whether you
land on the answer I had in mind." So in Block 3 a well-argued yes and a well-argued no both score at the
top, and an undefended position of either kind scores at the bottom. **Claude must not signal a preferred
conclusion.** What is scored is whether the position is built on a mechanism, whether the evidence he wants
would actually discriminate, and whether he can say what would change his mind.

## What this case is built from

| Source | What it says | Where it shows up |
|---|---|---|
| Prep guide | "Questions about your past experience and interests" | Blocks 1 and 2 |
| Prep guide | "Come with examples from past work or school that you think would be relevant here" | Block 4 |
| Email | "How you approach product decisions, what evidence you'd want before making a call, and how you weigh user impact and our values as part of that" | Block 3, all three clauses |
| Nick, in the guide | "Tell me when a method is more than the question deserves" and "say what would change your mind" | Block 3's scoring |
| Prep guide, what we look for | "A decision on the other end" | Block 4 is a story about a decision that went the other way |
| `../private/product.md` | Writers are about 2% of users a month, the top 1% write about half of answers, monetization programs were cut in 2024 | Block 3's premise and its history |
| `../data-metrics/02_asker-success-metric.md` | 41% of person-asked questions get no answer within 7 days | Block 3's stated problem |

## Clock

| Block | Minutes | Assessed |
|---|---|---|
| 1. Walk me through your background | 8 | The arc, and self-editing |
| 2. Why product, why now | 5 | Motivation, values |
| 3. A proposal worth arguing about | 14 | Product judgment, evidence |
| 4. A time you argued against work | 8 | Values, a decision on the other end |
| 5. What would success look like | 6 | The data science big picture |
| 6. His questions | 4 | Not scored |

## How Claude runs it

- Play Nick. Coaching-oriented, unhurried, interested in reasoning rather than conclusions.
- **In Block 1, interrupt once at about 90 seconds** with "keep going" if he is still in chronological order,
  and note that it happened. The walk should have a shape by then.
- **In Block 3, argue whichever side he does not take.** Argue it properly, not as a token objection. The
  point is to see whether he holds for reasons or folds for comfort.
- Ask "what would change your mind" at least once, and note whether he had already said it.
- Let silence sit.
- Record the time with `date` at each block.
- At the end, debrief with the scorecard.

---

## Block 1, walk me through your background

About 8 minutes, of which his answer should be about two.

**Nick.** "I know we said I'd read your background, but humor me. Take a couple of minutes and walk me
through it. I'm interested in how you tell it."

**The thing being tested.** A career with four distinct phases told chronologically takes six minutes and
leaves the listener assembling the point themselves. Told as an arc it takes two and the listener finishes
knowing what he is for. The phases are economics and sports analytics, the statistics PhD, three years as a
research data scientist on a randomized program evaluation, and Farmers. Four is too many to narrate. It
needs a thesis that makes them one thing.

**The arc that is available to him.** Some version of: the same question from four directions, which is how
you know whether something actually worked when the measurement is noisy and a real decision is waiting.
Economics gave him the causal framing and the habit of asking what the counterfactual is. The PhD gave him
the machinery and a tolerance for problems where the answer is not identified. The program evaluation was
that question with an actual randomized treatment and an actual program decision at the end of it. Farmers
was the same question with money attached and a production constraint. Product is the same question again
with a much faster loop and a person sitting next to him who has to act on it.

**He has to supply facts this file cannot.** Whether the three research years ran concurrently with the PhD
or after it. What the educational program was and who decided its fate. Whether the evaluation was his to
scope. Those determine how the arc is told and only he knows them. Leaving Nick to infer a timeline is worse
than stating it in one clause.

**Listen for.**

- **A thesis in the first fifteen seconds.** Not "I did my undergrad in economics." Something that tells
  Nick what the four phases have in common, so the rest is evidence rather than narration.
- **Two minutes, not six.** Self-editing is the skill on display. A candidate who cannot compress his own
  history will not compress an analysis.
- **The transitions explained, briefly.** Why leave economics for statistics, why research to industry and
  back, why product now. One clause each. The gaps are where an interviewer's attention goes.
- **Landing on the role.** The walk should end pointed at this job, not at the present day.

**Strong signals.**

- Leading with the program evaluation rather than the PhD, and treating the PhD as the thing that made the
  evaluation possible rather than as the headline. In a room where everyone has a doctorate, the doctorate is
  not the interesting fact.
- Naming the thing he is deliberately not covering. "There's a whole thread about Bayesian network models I'm
  skipping because it isn't what this job is" is a self-editing signal and it preempts the question.
- Ending with a question or a hook rather than trailing off.

**Follow-ups.**

| Follow-up | What it tests |
|---|---|
| "Which of those four would you say you're best at?" | Whether he has a view on himself, and whether it matches the job |
| "What did the research years give you that the PhD didn't?" | Whether the phases are actually distinct in his head or just sequential |
| "Anything in there you'd rather not do again?" | Honesty, and whether he can name a preference without disparaging past work |

**Traps.**

- Chronology. The single most common failure and it is entirely avoidable.
- Six minutes. If Claude has to interrupt, that is the finding.
- Leading with the dissertation topic. Bayesian inference for exponential-family random graph models is not
  a sentence that helps here, and the instinct to lead with it is the same instinct that leads with method
  before answer.
- Apologizing for the nonlinearity. It is a strength told as an arc and a liability told as an excuse.

**Score.** 4 is chronological, or runs past four minutes. 6 covers the phases with clear transitions and
lands on the role. 8 opens with a thesis, spends two minutes, treats the PhD as enabling rather than
headline, and names what he is skipping.

---

## Block 2, why product, why now

About 5 minutes.

**Nick.** "You've spent most of your career on questions that take months to answer. This job answers
questions in weeks and sometimes days. Why do you want that?"

**Listen for.**

- A real preference with a reason, rather than a repositioning of the same answer he gave about the role in
  general. The honest version is available: research answers a question thoroughly and then the answer sits
  there, and the appeal of product is that somebody acts on it and you find out whether you were right.
- **Naming what he will miss, or find hard.** The pace cuts against a habit of exhaustiveness, and saying so
  is both true and the exact thing this team says it screens for. A candidate who claims the transition costs
  him nothing is either not self-aware or not being straight.
- A view on what transfers and what does not. The causal reasoning transfers. The tolerance for a two-year
  loop does not, and has to be actively unlearned.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "What's the hardest part of that adjustment for you?" | Stopping early. In research, stopping early is a defect. Here it's the job, and I've had it pointed out to me more than once that I reach for the thorough version when the decision didn't need it. I know it about myself, which isn't the same as having fixed it |
| "Some people miss the depth and leave within a year. Why won't you?" | Because the part I actually like isn't the depth, it's the part where the answer decides something, and research gives you less of that rather than more. If I'd wanted depth for its own sake I'd have stayed |
| "Would you go back?" | Not to research as a career. I'd want to keep publishing on the side if that's compatible, and I'd rather say that now than pretend it isn't there |

**Traps.**

- Claiming the transition is costless.
- Framing product as a step up from research, which reads as either disloyal or naive depending on the
  listener.
- Any version of "I want faster impact" with no mechanism behind it.

**Score.** 4 is generic enthusiasm for impact. 6 gives a real preference with a reason. 8 also names what the
adjustment costs him specifically, in terms that match a known habit rather than a generic one.

---

## Block 3, a proposal worth arguing about

About 14 minutes. The block the case is built around.

**Nick.** "Here's something on the table right now. Answer volume has been drifting down for two years, and
about 41% of the questions real people ask get no answer at all within a week. A PM wants to pay writers a
flat rate per answer, above a quality bar, targeted at topics where questions are going unanswered. Funded
out of ads revenue. What do you think?"

**Context available on request.**

> | Fact | Value |
> |---|---|
> | Share of logged-in users who write an answer in a month | About 2% |
> | Share of all answers written by the top 1% of writers | About half |
> | Person-asked questions with no answer within 7 days | 41% |
> | Questions created per month, person-asked | 1.8M |
> | Questions created per month, generated by Quora accounts | 2.4M |
> | Quora's history here | Writer monetization programs existed and were cut in 2024 |

**This block has no right answer and Claude must not imply one.** What is scored is below.

**Listen for.**

- **Interrogating the premise before the proposal.** 41% unanswered is presented as a supply shortage and it
  is not obviously one. Three other explanations fit the same number: the right writer never saw the question,
  which is a routing problem; the question is not worth answering, which matters enormously given 2.4M of the
  4.2M questions a month are machine-generated; or the question is a duplicate of one already answered well,
  which is a merging problem and a success rather than a failure. Paying for answers to questions nobody
  should answer spends money to make the corpus worse. A candidate who does not separate these is agreeing to
  fix a problem that may not exist.
- **The motivation argument, and its asymmetry.** People write on Quora for audience, status and being asked.
  Introducing a per-answer rate can convert that into a transaction, and the risk is not only that the rate
  fails to attract new writers but that it changes how the existing ones feel about writing for nothing. The
  asymmetry is what makes it serious: a payment introduced can be reduced, and reducing it is a takeaway,
  which is a worse position than never having started. That is a reason to be slow here that has nothing to do
  with whether the economics work.
- **Selection into the incentive.** Whoever responds to a per-answer rate is, by construction, someone for
  whom the rate is the motivation. That is a different population from the one producing the answers Quora is
  known for, and a quality bar filters the worst of it rather than selecting the best.
- **Asking what happened in 2024.** Quora ran writer monetization and cut it. Whatever was learned is the most
  relevant evidence in the room and it is free. A candidate who does not ask is not using the history.
- **What evidence would decide it.** The email names this explicitly. The discriminating question is whether
  the unanswered questions are ones a willing writer would have answered if they had seen them. That is
  answerable: look at whether unanswered questions were ever routed to anyone, and whether questions that did
  get answered were routed differently.

**Strong signals.**

- Naming the reversible alternative. If the diagnosis turns out to be routing, the fix is routing. If it is
  recognition, the fix is recognition, which is cheap and reversible. Paying cash per unit of output is the
  least reversible option on the list and it is being proposed first.
- Distinguishing the two things the proposal bundles: spending money on supply, and spending it *per answer*.
  Paying per answer is a specific mechanism with specific failure modes, and the case for spending on supply
  survives even if that mechanism does not.
- Saying which users bear the cost. Ads revenue funds it, so readers pay in ad load for answers that may be
  worse than the ones they get now. The email asks how he weighs user impact, and this is where.
- Taking a position when pushed rather than staying in analysis.

**Nick's counterarguments.** Argue whichever side he did not take, and argue them properly.

| If he argued against | Nick pushes |
|---|---|
| | "Every marketplace pays for supply when supply is short. Why is Quora special?" |
| | "Motivation crowding out is a nice theory. Do you have any reason to think it applies to the people who write forty answers a quarter?" |
| | "You want a diagnosis first. That's another quarter and answer volume keeps falling. What's the cost of waiting?" |
| If he argued for | Nick pushes |
| | "We tried paying writers and killed it in 2024. What makes this different?" |
| | "Two thirds of the questions we create are generated by us. Are you proposing we pay people to answer our own robots?" |
| | "If this works, we're committed to it forever. What's your exit if it doesn't?" |

**Model answer, arguing against.** "My instinct is no to this version, and the reason isn't the economics,
it's that I don't believe the premise has been tested. 41% unanswered is being read as a shortage of willing
writers and it's consistent with at least three other things. The question might never have reached anybody
who could answer it, which is routing. It might not be worth answering, which matters a lot when two thirds
of the questions we create are generated by us rather than asked by a person. Or it's a duplicate of
something already answered, in which case an unanswered question is the system working. Those have different
fixes and only one of them is money. The thing that makes me want to be slow rather than just careful is
that this is close to irreversible in a specific way: people currently write for audience and status, and
once there's a rate, writing for nothing becomes a choice they're making rather than the only option. If it
doesn't work we can't quietly stop, because stopping is a pay cut. And the population that responds to a
per-answer rate is by definition the one for whom the rate is the motivation, which isn't the population
writing the answers Quora is known for. A quality bar screens out the worst of that, not in favor of the
best. What I'd want before deciding: whether unanswered questions were ever routed to anyone who could have
answered them. That's a query, not a study, and it separates routing from supply. And I'd want to know what
we learned in 2024, because we've run a version of this and killed it, and that's the most relevant evidence
anyone has. If it does turn out to be supply, I'd argue for the reversible version first, which is paying for
routing and recognition rather than per unit of output."

**Model answer, arguing for.** A well-argued yes exists and should score as highly. Its shape: supply is the
binding constraint on a marketplace and Quora has been losing it for two years, the reversible interventions
have had years to work and volume kept falling, motivation crowding out is real but is an argument about the
existing top writers rather than about the thousands of capable people writing nothing, and the mechanism can
be made reversible by running it as a time-boxed program in a limited topic set with an announced end date.
The evidence he would want is the same routing query, plus what 2024 actually taught, and the design he would
propose is a randomized pilot on a topic slice rather than a platform-wide rate. A candidate who gets there
has done the same work as the candidate who says no.

**Traps.**

- Accepting 41% as a supply shortage.
- Arguing only the motivation point. It is the most quotable argument and on its own it is thin, because it is
  mostly about the writers who are already writing.
- Not asking about 2024.
- Refusing to take a position. Nick's stated measure of the job is decisions other people make, and a data
  scientist who cannot be pushed to a view is not useful on a lean team.
- Designing an experiment for six minutes. Naming the pilot briefly is good; this is a judgment question.

**Score.** 4 accepts or rejects the proposal with no mechanism, or stays in analysis when pushed. 6 identifies
the motivation risk and asks for evidence. 8 separates the four explanations for the 41%, names the
irreversibility asymmetry, asks what 2024 taught, says what evidence would discriminate, and holds a position
under a properly argued counterattack.

---

## Block 4, a time you argued against work

About 8 minutes.

**Nick.** "Tell me about a time you thought a piece of work shouldn't happen, and what you did about it."

**Listen for.**

- A real instance with a real cost. Arguing against work is socially expensive and a story with no cost in it
  is either not this story or not true.
- **How he argued, not just that he did.** The difference between a useful data scientist and a difficult one
  is entirely in the how. Bringing a specific piece of evidence, offering an alternative, and giving the other
  person a way to change their mind without losing face are the skills.
- **The outcome, including the version where he lost.** Losing an argument and then supporting the decision is
  a better story than winning, because it is the one that tells Nick what happens on the days Joseph is
  overruled, which will be many of them.
- A named person at the other end. Nick's stated measure.

**Strong signals.**

- Having written the disagreement down. On a lean team with a coaching manager, a documented dissent that
  later turns out right is worth more than a loud one that was right at the time and unrecorded.
- Distinguishing between work that was wrong and work that was merely not his preference. A candidate who
  cannot tell those apart will argue against everything.
- Naming a time he argued against something and was wrong.

**Follow-ups.**

| Follow-up | What it tests |
|---|---|
| "Who did you have to convince, and what did they care about?" | Whether he modeled the other person or just presented facts |
| "What did it cost you?" | Whether the story is real |
| "What if they'd gone ahead anyway?" | Whether he can lose well |
| "Have you ever argued against something and been wrong?" | Self-awareness, and whether the first story was selected for flattery |

**Traps.**

- A story where he was right, everyone agreed, and nothing was at stake.
- Escalation as the whole answer. "I took it to my manager" with no attempt to persuade first reads as
  bypassing rather than convincing.
- No outcome.
- A story about arguing against bad statistics rather than against work. Nick is asking about judgment on what
  should be done, not about catching an error.

**Score.** 4 has no cost or no outcome. 6 is a real instance with a real disagreement and a result. 8 also
shows how he made it easy for the other person to change their mind, and includes either a loss he supported
afterwards or a time he was wrong.

---

## Block 5, what would success look like

About 6 minutes.

**Nick.** "Say you join. What would tell you, six months in, that this was working?"

**Listen for.** His own version of Nick's measure: decisions other people made differently. Not analyses
shipped, not dashboards built, not tooling delivered.

The guide's FAQ gives the house answer, which is reliable analysis and experiment review in his area, a
demonstrable contribution to a team KR or a product KPI he owns, and increasing independence. Landing near it
is good. Reciting it is not.

**Strong signals.**

- Something specific to a lean team: that a PM on his surface starts bringing him questions before deciding
  rather than after. That is the observable version of the abstract measure and it is the right answer.
- Naming a failure mode he would watch for in himself. Six months of careful analyses nobody used is a
  plausible bad outcome and saying so is a values signal.
- A view on what he would want to have learned rather than only delivered.

**Follow-up.** "And what would tell you it wasn't working?"

- Wants: work that gets read and not used, being asked for numbers rather than for views, and a metric he owns
  that nobody argues with, which usually means nobody is looking at it.

**Traps.** Volume of output. Reciting the FAQ. No failure condition.

**Score.** 4 describes output. 6 describes decisions and influence. 8 gives an observable specific to a lean
team, and names what failure would look like.

---

## Block 6, his questions

About 4 minutes. Not scored.

- "What was learned from the writer monetization programs that were cut in 2024? That seems like the most
  relevant history for anything on the supply side."
- "When someone on the team thinks a project shouldn't happen, where does that argument get made?"
- "What's the most recent thing the team talked someone out of?"
- "Six months from now, what would make you glad you hired for judgment over experience?"

---

## Scorecard

| Criterion | Score | Evidence |
|---|---|---|
| The arc, and self-editing | | |
| Product judgment | | |
| Evidence and assumptions | | |
| Values alignment | | |
| The data science big picture | | |
| A decision on the other end | | |
| Hire signal | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| The arc | Chronological, or over four minutes | Clear phases, transitions explained, lands on the role | Thesis first, two minutes, PhD as enabling, names what he is skipping |
| Product judgment | Accepts or rejects with no mechanism | Identifies the main risk and asks for evidence | Separates the competing explanations for the premise, names the irreversibility, holds under a real counterargument |
| Evidence | Wants more data generally | Names the metrics he would look at | Names the one query that discriminates between the explanations, and asks what the 2024 history taught |
| Values | States values | Stories that show them without labeling | A story where doing the right thing cost him, including a loss he supported afterwards |
| The big picture | Describes output | Describes decisions and influence | An observable specific to a lean team, plus a named failure condition |
| A decision on the other end | No named person acted | Someone acted | A named person changed course, and he made it easy for them to |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed. This is the hiring
manager, so a weak showing here is not recoverable elsewhere in the loop.

**Case-specific checks.**

- Did Claude have to interrupt the background walk? How long did it run?
- Did he lead with the dissertation?
- Did he ask what happened in 2024?
- Did he hold a position under the counterargument, or move to the middle?
- Did any story in Block 4 cost him something?

| Block | Target | Actual |
|---|---|---|
| 1. Background | 8 min | |
| 2. Why product | 5 min | |
| 3. The proposal | 14 min | |
| 4. Arguing against work | 8 min | |
| 5. Success | 6 min | |

Top three fixes for the next mock.

1.
2.
3.
