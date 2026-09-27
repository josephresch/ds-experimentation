# Case 01, product judgment and values, with Nick Sher

A mock interview for the **Product Intuition** round of the Quora final round loop. 45 minutes, with the
hiring manager. Claude plays Nick Sher.

**This file is built differently from the other three, and it has to be.** The metrics, stats and
practical cases are self-contained: synthetic data, planted problems, a verdict the data supports. This
round has no dataset. Three of the five things it assesses are about Joseph rather than about a scenario,
so a mock that hands him a problem and scores the answer would miss most of what is being measured. So
this file is two parts:

- **Part A, the worksheet.** Material to write out before running the mock. Running the mock without it
  wastes the mock, because the failure mode in this round is having no concrete example ready, not
  reasoning badly.
- **Part B, the mock.** 45 minutes, seven blocks, with what Nick is listening for.

## What this round is, on the evidence

| Source | What it says | What it means here |
|---|---|---|
| Prep guide | "Questions about how you would think about product decisions at Quora, and about your past experience and interests" | Blocks 3 and 4 are product decisions. Blocks 1, 2 and 5 are him |
| Prep guide | "Conversation about situations you've faced as a data scientist and your thinking around them" | Block 2. Situations, and the thinking, not the achievement |
| Prep guide | "Possibly a question or two about an area specific to this role, such as experimentation" | Block 6. An opinion question, not a design exercise |
| Prep guide | Assessed on "values alignment, product judgment, and the data science big picture: how you reflect on the situations you've been in" | Three dimensions, and the third one is self-awareness |
| Prep guide, how to prepare | "Read the short description of each of our values, and think about how your reactions to past situations reflect them" | **Values are assessed through the situation questions, not asked directly.** Nick will not say "tell me about a time you showed data empiricism." He will ask about a situation and listen |
| Email | "How you approach product decisions, what evidence you'd want before making a call, and how you weigh user impact and our values as part of that" | "What evidence you'd want" is the scored phrase in Block 3 |
| Glassdoor 2019, via `../private/final-round-reports.md` | The old "Data Community" round asked "what does success look like" and "what did you wish you learned earlier in your career about data analysis" | That round is gone and its content most likely sits here. Block 5 |

### Nick's own words are the rubric

The guide contains his note to candidates. It is unusually specific about what he wants, so it is quoted
here as the scoring standard rather than paraphrased.

> "In interviews I care much more about how you reason than whether you land on the answer I had in mind.
> Say what you are assuming, say what would change your mind, and tell me when a method is more than the
> question deserves. Scrappy and rigorous are not opposites here. If you get stuck, say so; I would rather
> see you think out loud than watch you perform."

> "The measure of this job is how many good decisions other people make because of your work."

Four scoring lines come straight out of that, and they apply in every block:

1. State the assumption before the answer.
2. Say what would change your mind.
3. Say when a method is more than the question deserves. Block 4 exists to test exactly this.
4. Every story ends with what somebody else did differently. That is his definition of the job.

### On Quora's values, honestly

The guide says to read the short description of each value at quora.com/careers. **That page cannot be
fetched programmatically** (quora.com/careers is disallowed by robots.txt, careers.quora.com returns 403),
so the formal list is not reproduced here and nothing below invents one. **Open it in a browser yourself
before the loop.** It is a two-minute job and it is the one piece of preparation this file cannot do.

What is attributable, and is enough to prepare against:

| Value language | Source |
|---|---|
| "Rational decision making, data empiricism, and scrappy pragmatism" | The prep guide Quora sent, "values we run on" |
| "Balance rigor and pragmatism, searching for scrappy solutions" | The job posting |
| "A culture of rational decision making," strategy guided by "empirics" | The job posting |
| "A culture rooted in transparency, idea-sharing, and experimentation" | The job posting |
| "Rigor that knows when to stop," "a decision on the other end," "product intuition with the numbers" | The prep guide, "what we look for" |

Treat the last row as the operative version. It is the most concrete and it is what the loop is scored on.

### One correction to earlier prep

`../private/prep-plan.md` was written for the first round and says the honest read is that there is no
industry data science job on the resume. **For this role that framing is now wrong and worth dropping.**
The posting's minimum is 2+ years analytical or quantitative work experience with 1+ as a data scientist.
Between three years as a research data scientist on a randomized program evaluation, the Farmers work, and
the PhD, he is over the stated bar rather than under it. Walking into Nick's round apologizing for
experience he has is a self-inflicted wound. This is not Upstart, where the posting asked for 6+ years.

---

# Part A, the worksheet

Write these out properly, in full sentences, before running Part B. Say each one aloud once and time it.
Anything over two minutes gets cut, not compressed.

## A1, the lead story

**The recommendation: lead with the psychometrics program evaluation, not Farmers.**

The reason is in the guide's own FAQ: "Would I be building models? No. This is an analytics and
experimentation role, not a modeling role. You'd evaluate systems, including recommenders, rather than
train and ship them." Farmers is a model-building story. Three years using causal machine learning to
evaluate a randomized educational program is an evaluation story about a real randomized treatment with a
real decision attached, which is the job as written. Leading with the gradient boosting work invites Nick
to place him as a modeler applying to an analytics role, and then the rest of the conversation is spent
climbing out of that.

Farmers still belongs in the loop. It is the better answer to "tell me about making a business decision
with a model" and it is genuinely strong. It is the second story, not the first.

Write out, for the program evaluation:

| Element | What to write |
|---|---|
| The decision on the other end | Who acted on the evaluation, and what they did differently. If the honest answer is that a program continued or stopped, say that plainly. If nobody acted, say that too and say why, because that is a real and common outcome and pretending otherwise is worse |
| The framing | Who set the question. If it was handed down, what he changed about it |
| The hardest judgment call | The one place where two defensible approaches existed and he picked. This is the email's "more than one reasonable path" in story form |
| What he would do differently | Required. Block 5 asks for it and a story with no regret in it reads as unexamined |
| Length | 90 seconds spoken |

**Open question for him, which this file cannot answer.** Whether those three years ran concurrently with
the PhD matters for how Nick reads the timeline, and whether the evaluation was his to scope or handed to
him matters for the ownership claim. Both should be stated plainly rather than left for Nick to infer.

## A2, four more situations

One paragraph each, each ending in what changed for someone else.

1. **A result nobody wanted to hear.** Values: data empiricism and rational decision making. If the
   PLOS ONE revision is the material, the honest version is the strong one: reviewers pushed for the
   Stepping algorithm initialization comparison and were right, and the paper was wrong without it.
2. **Something shipped deliberately rough.** Values: scrappy pragmatism and rigor that knows when to stop.
   Needs a named quality tradeoff he accepted on purpose, not a story about being rushed.
3. **A disagreement with someone more senior.** Transparency and idea-sharing. Needs an outcome, including
   the version where he lost and was right, or lost and was wrong.
4. **Explaining something quantitative to someone who did not want the detail.** The guide says translating
   the result back into plain language is most of the job. TA-ing Stats 102B is usable here and is stronger
   if the example is a specific student misconception he changed how he taught.

## A3, product familiarity

The guide is explicit that product familiarity is not graded and that context will be provided for any
feature. It is also explicit that "what we can't hand you is a point of view about how people use it."
So the goal is one point of view, not coverage.

Thirty minutes logged in, and write down:

- One thing about the home feed that seems wrong, and a guess at why it is that way. The guess matters
  more than the complaint.
- One question type Quora is genuinely irreplaceable for, with an example question. This is the same
  insight the stats case runs on and it is the most useful single thing to have ready in this round.
- One place where Quora's incentives and a reader's interests come apart.
- Whether AI answers show up, how they are labeled, and what he thinks of the labeling.

## A4, three questions for Nick

Not scored, but this is the hiring manager and the last impression. Each has to be one only someone at
Quora could answer. Candidates are in Block 7.

---

# Part B, the mock

## Clock

| Block | Minutes | Assessed |
|---|---|---|
| 1. Why this, why now | 4 | Motivation, values |
| 2. A situation you've been in | 12 | Reflection, values |
| 3. Product judgment, the strategic question | 10 | Product judgment, evidence |
| 4. Product judgment, the small question | 5 | Calibration |
| 5. The reflective questions | 7 | The data science big picture |
| 6. Experimentation | 4 | Role fit |
| 7. His questions | 3 | Not scored |

## How Claude runs it

- Play Nick. Coaching-oriented, unhurried, genuinely more interested in reasoning than in answers. Not
  adversarial. The guide describes him as a sounding board rather than a source of tickets, so the register
  is a senior colleague thinking out loud with him, not an examiner.
- **Follow up on the thinking, not the facts.** "What were you assuming there?" "What would have changed
  your mind?" "Who acted on that?" Those three, repeatedly, are most of what Nick does.
- **Do not rescue a story with no decision in it.** If he finishes and nobody acted on the work, ask "and
  what happened as a result?" once, then let the silence sit.
- **Let silence sit.** He is allowed to think. Do not fill it.
- Stay out of statistics. This round is not the stats round and dragging it there is a failure of the mock,
  not a feature.
- At the end, debrief with the scorecard and quote back two things he said verbatim, one strong and one weak.

---

## Block 1, why this, why now

About 4 minutes.

**Nick.** "Thanks for making the time. I've read your background, so rather than walk me through it, tell
me what made you want this particular job."

**Listen for.**

- Something only true of this role. The lean team, owning a problem space rather than a queue, the short
  distance between an analysis and a decision. The guide's own framing is available and using it is fine.
- A real interest in the product's situation. AI-driven search changing how people arrive is the most
  interesting thing happening to Quora and having a view on it is the differentiator here.
- Honesty about the move from research to product. He is making the transition Nick's note describes and
  pretending otherwise reads worse than naming it.

**Strong signals.**

- Naming the part of the job he is least sure about, unprompted. The guide says Nick would rather see
  someone think out loud than perform, and volunteering an uncertainty in the first four minutes sets the
  register for the whole conversation.
- Saying something about Quora that is not in the prep guide.

**Follow-ups.** "What would make this a bad fit for you?" "What are you hoping to learn that you haven't?"

**Traps.**

- Leading with the PhD. All the interviewers are likely to have one, so it buys nothing here and spends
  the opening.
- Signaling that analytics is a step toward a modeling role. The FAQ says plainly this is not a modeling
  role. Any hint that he is waiting for that to change is disqualifying in a hiring manager round.
- Reciting the job description back.

**Score.** 4 is generic enthusiasm or a resume walk. 6 names specifics of this role and team. 8 also shows
a view on the product's current situation and names his own uncertainty.

---

## Block 2, a situation you've been in

About 12 minutes. The longest block and the one the guide describes most directly.

**Nick.** "Tell me about a piece of work you owned end to end. I'm less interested in the result than in
how you got to the question and what happened after."

**Listen for.** The four lines from his note, in this order.

| What Nick wants | What it sounds like |
|---|---|
| The question, and who framed it | "The question I was handed was X. I changed it to Y, because X would have been answered by..." |
| The assumption | Stated before the method, not defended after |
| What would have changed his mind | Named as part of the design, not as a caveat |
| The decision on the other end | A named person or team did something different. This is Nick's stated measure of the job |

**Strong signals.**

- **Reframing the question he was given.** The guide describes the job as owning problem spaces rather than
  tickets, and the clearest evidence of that is having changed a question rather than answered it.
- **A method he deliberately did not use.** "I considered X and it was more than the decision needed" is
  the single most on-target sentence available in this round, because it is Nick's own words handed back
  with evidence attached.
- **Naming a cost.** Every real project traded something away. A story with no cost in it reads as
  polished rather than true.
- **The decision holding up, or not.** Saying "we shipped it and six months later the effect had decayed"
  is stronger than a clean win, because it shows he went back and looked.

**Follow-ups, use three or four.**

| Follow-up | What it tests |
|---|---|
| "What were you assuming when you set it up that way?" | Whether assumptions are live in his head or retrofitted |
| "What would have changed your mind?" | Whether he designed a way to be wrong |
| "Who acted on it, and what did they do differently?" | Nick's stated measure of the job |
| "Was there a simpler version that would have been good enough?" | Rigor that knows when to stop |
| "What would you do differently?" | Reflection. If there is no answer, that is the finding |
| "Did anyone disagree with you?" | Transparency, and whether he can lose an argument well |

**Traps, specific to him.**

- **Starting with the method.** The documented failure mode, and in a hiring manager round it costs more
  than in a technical one, because Nick is not there to evaluate the technique.
- **A story with no named person at the other end.** Research work is especially prone to this and the
  honest fix is to say who the audience was and what it changed for them, even if the answer is a program
  decision or a field's understanding rather than a product launch.
- **Running long.** Twelve minutes is one story with follow-ups, not three stories.
- **Farmers as the lead story.** See A1. Modeling story, analytics role.

**Score.** 4 narrates a project chronologically with no decision at the end. 6 has a clear question, a
method, and someone who acted. 8 reframed the question, names the assumption and what would have changed
his mind unprompted, names a simpler version he considered, and names a cost.

---

## Block 3, product judgment, the strategic question

About 10 minutes.

**Nick.** "Here's something we actually argue about. AI Overviews are taking a real bite out of our search
traffic. Someone senior proposes we stop letting Google index question pages at all and put the content
behind a login. What do you think, and what would you want to know before deciding?"

**Listen for.**

- **Refusing the yes or no, and saying what the decision actually trades.** A known, measured, immediate
  loss of search-referred readers against a speculative gain in signups and in denying Google material.
  Framing before answering is the whole of what is being scored here.
- **The evidence he would want, named specifically.** What share of visits are search-referred. What share
  of signups originate there. How a search-originated signup retains compared with one from any other
  source. What share of writers found Quora through search in the first place, which is the part people
  forget, because walling the front door also stops new writers arriving.
- **The irreversibility argument.** This is close to a one-way door. Search ranking took years to build and
  Google does not hand it back on request. So the evidence bar should be far higher than for a reversible
  change, and saying that is the strongest single move in the block.
- **The user-impact dimension the email names.** Most people who read Quora never sign in and get something
  for free. Walling that off is a real cost to a large number of people, and saying so plainly is a values
  signal, not a soft one.
- **The version that is actually testable.** You do not have to do it all at once. De-index a random
  sample of pages or a topic cluster and measure. Partial credit for proposing it, full credit for also
  noticing that Quora's pages compete with each other in search, so a de-indexed sample changes the
  ranking of the pages left behind and the comparison is not clean.

**Strong signals.**

- Separating the two things the proposal bundles. Refusing Google as a *crawler* and refusing readers
  without an account are different decisions with different costs, and only one of them is about AI.
- Noticing the proposal mistakes the mechanism. If Overviews are built partly from Quora's content, then
  de-indexing addresses the training and answer-material grievance. It does not bring back the readers,
  because those readers were lost to the Overview answering their question, not to Quora being findable.
- Being willing to say the senior person is probably wrong, with a reason, and then saying what evidence
  would change that.
- Saying which part of this is not his call. The strategic decision belongs to leadership; the evidence
  framing is his. Knowing the difference is a seniority signal.

**Follow-ups.**

| Follow-up | What a strong answer sounds like |
|---|---|
| "Say search is 60% of visits. Does that settle it?" | It sizes the loss, it doesn't settle anything, because the question is what share of that 60% is worth something to us. A search visitor who reads one answer and leaves forever is worth roughly an ad impression. One who signs up is worth a great deal more. I'd want the split before I'd weigh the loss |
| "What if signups from search are almost all of our signups?" | Then the proposal is close to unarguable against, because it removes the top of the funnel to protect content, and we'd be trading the company's growth for a grievance against Google |
| "You keep saying you'd want data. We need a view this week." | Then my view is no, on the irreversibility alone. I can get back a reversible mistake and I can't get back the ranking. If the argument is that the content is being taken, there are narrower ways to fight that than closing the front door |
| "Isn't 'we need more data' just a way of not having an opinion?" | It can be, so here's the opinion: no, and the thing that would move me is evidence that search-arriving readers essentially never convert and never come back, because then we'd be protecting something valuable with something worthless |

**Traps.**

- Answering yes or no in the first sentence.
- Designing an experiment. This is a strategy question and the round is not the stats round. Naming the
  testable version briefly is good; spending six minutes on its design is a misread of the room.
- Listing every metric he can think of instead of the three that would change the answer.
- Refusing to have a view. Nick's stated measure is decisions other people make, and a data scientist who
  cannot be pushed to a position is not useful to a lean team.
- Missing the writers. Search brings in the people who write the answers too.

**Score.** 4 answers yes or no, or lists metrics with no decision. 6 frames the tradeoff and names the
evidence that matters. 8 also separates the bundled decisions, makes the irreversibility argument, says
what would change his mind, and takes a position when pushed.

---

## Block 4, product judgment, the small question

About 5 minutes. **This block exists to test one thing: whether he scales his method down.**

**Nick.** "Different kind of question. A PM wants to show, on each question page, how many people are
reading it right now. Small feature. How would you approach it?"

**Listen for.**

- **A cheap check before any test plan.** The distribution of concurrent readers per question. Quora's
  traffic is long-tail organic search across an enormous number of question pages, so the modal page has
  zero or one person on it at any moment. A live counter would display "1 person reading" almost
  everywhere and make the site look empty, which is the opposite of the social proof the feature is for.
  That is a single query, and it either kills the feature or unblocks it.
- **Saying the method is more than the question deserves.** If the distribution turns out fine, this is a
  cheap reversible change with an obvious metric, and the answer is to ship it behind a flag and look,
  not to design a study.
- **A scoping instinct.** If it only works on the top slice of pages by traffic, that is a different and
  smaller feature, and worth saying.

**Strong signals.**

- Getting to the distribution point unprompted. It is a product-shape insight, not a statistical one, and
  it is exactly what the guide means by product intuition with the numbers.
- Explicitly contrasting this with Block 3. "That one deserved a week of framing. This one deserves one
  query and a flag." Nick's note asks for precisely that judgment and naming it out loud is not too on
  the nose here.

**Follow-ups.**

| Follow-up | Answer |
|---|---|
| "The PM already thinks it's a good idea. Do you need to check anything?" | One thing, and it takes an afternoon. If most pages would show a 1, the feature makes us look dead and he'd rather know now than after launch |
| "What would you measure?" | Whatever the PM thinks it does, which is probably engagement on the page and onward clicks. But I wouldn't build a measurement plan before checking whether the feature can function at all on our traffic shape |

**Traps.**

- **Bringing the Block 3 apparatus.** A full metric tree, guardrails, and a power calculation for a live
  reader count is the failure this block is designed to catch, and it is his documented reflex.
- Saying "I'd A/B test it" with no check first.
- Dismissing it as too small to think about. It is small, and the thinking is a five-minute version, not zero.

**Score.** 4 designs a full experiment, or waves it off. 6 proposes a light test with a sensible metric.
8 does the distribution check first, names why it might kill the feature, and says out loud that this
question deserves less method than the last one.

---

## Block 5, the reflective questions

About 7 minutes. Content most likely absorbed from the retired Data Community round. Ask two.

**Q1.** "What do you wish you'd learned earlier about doing data analysis?"

- The honest answer available to him is the documented one: that he reached for the sophisticated method
  before establishing the simple answer, and that a defensible answer delivered early is worth more than
  an elegant one delivered late.
- **That answer is so well aligned with this team's stated values that it will sound rehearsed unless a
  specific instance is attached.** The instance is what makes it true rather than flattering. A version
  with a named project, what the sophisticated approach cost in time, and what the simple version would
  have shown, is strong. The same claim without an instance is worse than a duller honest answer.
- Alternative material, if that one feels too tailored: that the hard part of analysis is agreeing what
  the question is, and that he used to treat that as preamble.

**Q2.** "Six months in, what would tell you this was going well?"

- Listen for his own version of Nick's measure. Decisions other people made differently. Not volume of
  analyses, not dashboards, not tooling shipped.
- The guide's FAQ gives the house answer, "reliable analysis and experiment review in your area, a
  demonstrable contribution to team KRs or a product KPI you own, and increasing independence." Landing
  near it is good. Landing on it word for word reads as recital.
- Strong version names something specific to Quora: that a PM on his surface has started bringing him
  questions before deciding rather than after.

**Q3, if time.** "Tell me about an analysis you got wrong."

- Wants a real error, its mechanism, what would have caught it earlier, and what he changed. Not a story
  where he was right and someone else was wrong.
- A process change he made afterward is the tell that the reflection was real.

**Traps.**

- A humblebrag dressed as a weakness.
- "I work too hard" in any of its forms.
- An error with no mechanism and no fix.
- Naming a failure mode without an instance, especially on Q1, where the aligned answer is obvious.

**Score.** 4 gives a non-answer or a disguised strength. 6 names a real limitation with an example.
8 names the limitation, an instance, what it cost, and what he changed, and does it without performing
humility.

---

## Block 6, experimentation

About 4 minutes. The guide says to expect "a question or two about an area specific to this role, such as
experimentation." An opinion question, not a design exercise.

**Nick.** "You'll do a lot of experiment review here. How do you decide an experiment isn't worth running?"

**Listen for.**

- Power against the effect worth caring about. If the smallest effect the design can resolve is larger
  than the smallest effect that would change the decision, the test cannot do its job and running it
  produces a number people will over-read.
- The decision test. If both outcomes lead to the same action, there is nothing to learn.
- Cost against reversibility. A cheap reversible change can just ship and be watched.
- The honest version of the awkward case: sometimes a test gets run for organizational reasons rather than
  informational ones, and saying that out loud is a transparency signal.

**Strong signals.**

- Saying that "underpowered" is a statement about the decision, not about the data, because it depends
  entirely on what effect size would matter.
- Naming what he would do instead: ship with a holdout, run a qualitative read, or accept the change
  unmeasured and say so explicitly rather than pretending it was validated.

**Follow-up.** "A PM insists on running one you think is underpowered. What do you do?"

- Wants: agree to run it and agree in writing beforehand what will and will not be concluded from it.
  Pre-committing the interpretation is the move that costs nothing and prevents the real damage, which is
  a null result being read as evidence of safety.

**Score.** 4 gives textbook power mechanics. 6 ties the decision to the effect size worth detecting.
8 also names the alternative to testing and handles the PM case by pre-committing the interpretation.

---

## Block 7, his questions

About 3 minutes. Not scored, and it is the hiring manager. Two or three, each answerable only by Nick.

- "You said the measure of the job is how many good decisions other people make because of the work. Where
  does that break down here? Whose decisions are hardest to reach?"
- "What's the analysis someone on the team did in the last six months that changed your mind about something?"
- "AI-driven search is changing how people arrive. Is the data team's job right now to size that, or to
  find what replaces it?"
- "Where does a new person here most often go wrong in the first three months?"

Avoid: anything answered in the prep guide, which is unusually thorough, so asking about the process or
the loop wastes the slot and signals he did not read it.

---

## Scorecard

| Criterion | Source | Score | Evidence |
|---|---|---|---|
| Values alignment | Guide, "values alignment" | | |
| Product judgment | Guide, "how you think about Quora's product and what goes into product decisions" | | |
| The data science big picture | Guide, "how you reflect on the situations you've been in" | | |
| Evidence and assumptions | Email, "what evidence you'd want before making a call"; Nick, "say what you are assuming" | | |
| Calibration | Nick, "tell me when a method is more than the question deserves" | | |
| A decision on the other end | Nick, "how many good decisions other people make because of your work" | | |
| Hire signal | | | |

| Criterion | 4 | 6 | 8 |
|---|---|---|---|
| Values alignment | Values named but not visible in any story | Stories that show pragmatism and empiricism without labeling them | A story where a value cost him something, told without reaching for the label |
| Product judgment | Generic product reasoning, or answers the strategic question yes or no | Frames the tradeoff and names the evidence | Separates bundled decisions, argues irreversibility, takes a position when pushed |
| The big picture | A disguised strength, or a limitation with no instance | A real limitation with an example | Limitation, instance, what it cost, what he changed, no performed humility |
| Evidence and assumptions | Assumptions surfaced only when challenged | States them when asked | States them unprompted and names what would change his mind |
| Calibration | Same apparatus for Block 3 and Block 4 | Lighter touch on the small question | Does the cheap check first and says out loud that the small question deserves less method |
| A decision on the other end | No named person acted | Someone acted, described vaguely | A named person did something specific differently, and he went back to see if it held |

Hire signal follows the average. Any single criterion at 4 or below caps it at mixed. This is the hiring
manager, so unlike the other three rounds a weak showing here is not recoverable elsewhere in the loop.

**Case-specific checks.**

- Did he lead with the program evaluation or with Farmers?
- Did he mention the PhD in Block 1? If so, why?
- Did he bring a full metric framework to Block 4? This is the clearest read in the file on the
  over-engineering reflex, because the question is transparently small.
- Did every story end with a named person doing something differently? Count how many did.
- Did he take a position in Block 3 when pushed, or retreat to wanting more data?

| Block | Target | Actual |
|---|---|---|
| 1. Why this, why now | 4 min | |
| 2. A situation | 12 min | |
| 3. Strategic question | 10 min | |
| 4. Small question | 5 min | |
| 5. Reflective | 7 min | |
| 6. Experimentation | 4 min | |

Top three fixes for the next mock.

1.
2.
3.

---

## Next cases for this folder

| Rank | Premise | What it would stress |
|---|---|---|
| 1 | The same round with a Poe question instead of a Quora one, if the recruiter confirms Poe is in scope | Reasoning about a product he does not use, and saying so |
| 2 | A product question where the right answer is that Quora should not build it | Willingness to argue against work, and the values read on it |
| 3 | A round that opens with "walk me through your resume," which this file deliberately skips | The two-minute version of his own history, which is harder than it sounds and is not drilled anywhere |
