# 9. Oracles before armies

*Everything here was run before it was written. Where a claim came from a
measurement, the measurement is named.*

Long verification work tempts a fleet to send agents, many of them
working for days. Most of that work hides a deterministic check, a
script that finds the mechanical failures with perfect recall and no fatigue,
and the house learned to look for it first. The human put the lesson plainly
after a verification walk across 469 files: "we should have built the tool
first, would have made the search and fix so much easier."

## Detector and adjudicator

A long verification task usually splits in two. The detector is the scriptable
part: it flags candidate failures, runs in seconds, and gives an objective
signal when it is done, an exit code of zero. The adjudicator is the judgment
that cannot be scripted: read the source, decide whether the flag is real, fix
it. Run together they make a loop that checks itself. The detector flags, the
adjudicator fixes, the detector runs again and comes back clean, and that rerun
is the confirmation that the failure is gone.

The house's first one was a quote checker for studies that cite a historical
dictionary. The failure it hunts is a quotation taken from a later edition and
labelled as the earlier one, and since the two editions share many phrases, it
compares each quote against both and flags the ones that match the later edition
clearly better. It was tuned for precision over recall, so the person
adjudicating would keep trusting its flags. On its first run it caught seven real contaminations (one same-day record says
eight, and the raw run was not kept) that the serial walk and the six-agent fan-out of chapter 8 had
both missed. One was a case an agent in that fan-out had reported fixing, after
fixing one of its two occurrences. The tool still runs by hand, because the human
ruled that it becomes a gate only once it keeps earning its weight.

## Rules for a detector

A detector is itself an instrument, and it fails in its own ways. The house
collected eight rules for building one, most of them from two gates written in
one evening and the nights that followed.

1. **It must pass the fix it recommends.** One gate nearly flagged the
   correctly rounded math function its own rule told people to use; another
   nearly flagged the solver its own clause recommended. A gate that cries wolf
   once gets routed around, and a switched-off gate is worse than none, because
   everyone believes it is still running. The rule has a second half: a check
   written as a direction (the start louder than the end) passes the same defect
   entered from the other end. Ask of every threshold whether it would still
   fire on the mirrored input.
2. **Exceptions print.** An approved escape hatch needs a reason and shows on
   clean runs as well as failing ones, so the list of exceptions stays in view.
3. **Zero inspected is a failure.** A gate whose first run matched nothing would
   have reported clean over a binary it never examined. Whether a gate looked at anything is a separate question
   from whether it found anything, and a check that could not run must never read as one that passed. Whatever wraps the
   check has to carry its failure too: a correct gate exiting 1 was read as
   success because its output went through `tail`, and a shell pipeline reports
   the last command's status.
4. **A control's premise is a claim too.** A control written as "this cannot
   happen, so a hit means the tool is misreading" reported 37 hits, and the tool
   was right. The control had indicted the wrong suspect, and the way through was
   to stop reasoning and read the actual instructions.
5. **A wall proves what may not happen and says nothing about what does.** A
   gate that forbids a sound from reaching the wrong console passed, correctly,
   while the right console played no sound at all. Prohibition proves nothing
   happens where it should not, liveness proves something can happen, and
   neither proves it ever does. A feature checked at the producer and at the
   consumer can pass both checks and still not exist, so the check that matters
   drives the real path end to end and looks where a user would.
6. **Chain the gate and read it.** A seat chained its suite to a commit, the
   suite went red on a rename left half done, and the seat read a line that was
   not the gate's and pushed. A green nobody read is worse than no gate, and a
   red nobody read is worse still. Chaining the gate to the action is what stops
   the action on red, and reading the gate's own output and the chain's exit
   status is what tells the seat it is green. A gate that prints nothing when
   it passes leaves only the action's line on screen, so it should say that it
   passed.
7. **The caveat travels with the number.** A rehearsal tool's header said its
   contacts moved in straight lines, and its numbers crossed into a design
   document, then a roadmap, then a decision, with the limitation left behind at
   the first hop. Every artifact that carries a figure restates its
   instrument's known blind spot next to it.
8. **Red first.** Run the guard against the exact failure it exists to prevent
   and require it to fail before trusting it to pass. A guard nobody has watched
   go red has only been watched agreeing with its author.

The third rule has a sequel that is the best lesson in the set. Three seats
published that a verification tool exited 0 on a real failure, and a fourth
adopted the claim, wrote it into the house's memory as a rule and cited their
numbers. The claim was false; every one of them had piped the tool through
`tail`, the night after the rule against exactly that was written. The seat that
adopted it had, in the same hour, audited its own three oracles carefully by
injecting bad inputs and reading exit codes directly, and never ran the one
command that would have tested the claim it had just published. Its own account
names the asymmetry: the reflex fired forward and never backward. It also found
the better question underneath. The defect the false claim was blamed for had
survived because nobody had ever run the tool on a real session, so the useful
question was what else has never been run on the real thing.

## Gates in the chain

A check that runs beside a push protects nothing. The house writes its gates
into the push itself, `check && git push`, so the push cannot happen unless the
check exits clean, and by rule 6 the seat reads the gate's own output as well. The order matters more than it looks: on one box a visibility
query chained into the push command failed after the push had already run. The
query now goes in its own command before the push, and the gate goes in front of
the push in the same command.

This book has its own gate, published in the repository as
[tools/wall-check](../tools/wall-check/). It scans files or history for the
classes the house keeps out of public repositories (private addresses, local
paths, session links, tokens and key material), reads personal names from a file
that lives outside any repository, exits 2 when it cannot run, and carries a
self-test that plants every case at runtime so the tool's own source holds none
of them. Its first run over this book's history found session links in the
book's first two commits, public for ten weeks, which the house's own gate had
called clean because its pattern list had no class for them. The house added the
class the same hour. The new class then went red on this book's pattern file,
which held the literal it catches, and the pattern is now written so the file
does not contain the thing it matches. The session lines came out of the book's history today at
the human's word, after an off-box backup was verified against three values sent
in the request.

## What a narrow oracle cannot see

A gate that checks one unit at a time cannot see a trend across units. In a long
generated manuscript, one phrase appeared once in the first version, once in the
second and 890 times in the third, climbing as the generating model read its own
prose and locked onto it. Two judged reviewers saw the phrase, and neither could
report the climb, because each one judged a single chapter, so the house added a
gate at the level of the whole book. The same round found that 8 of
24 chapters across versions had been cut off mid-sentence, while the board
already said the gate was clean and the formats were built. The claim was
retracted, and now the build calls the gate itself: exit 2 on a failure, exit 3
when the gate could not run, because a gate that cannot run must never read as
clean.

## Done, in three words

In August the human described what the fleet had been doing with the word
*done*: "you guys said, done! test it! and left me all the bugs to find!" A Codex
seat reading the night's seven defects called them one failure. Nothing bound
the source commit to the built artifact, to the running process, to the live
path, to a durable record of completion, so tests passing on a unit were allowed
to pass for evidence about the system.

The fix was vocabulary before it was code. One word had been doing three jobs,
and the house split it into three. **Built** means the deterministic tests
passed for those exact bytes. **Release candidate** means the build is attested
and passed an isolated integration. **Live-verified** means that exact process
passed its activation check against the real services and left correlated
records behind. When the live rig is unavailable, work stops at release
candidate and says live-unverified. In the journal's words, "a stronger claim
becomes unrepresentable without its evidence."

## The oracle is the switch

The house uses its oracles to decide how much freedom a seat has. A change is
act-and-report when it is execution, a deterministic oracle covers it, and the
oracle is green. It is surface-first when it touches intent, creates a standing
capability or cannot be undone, whatever the oracle says. A missing oracle
pushes a borderline call toward surfacing. The way to give a seat more autonomy
is to widen the floor of checks under it. The human struck this seat's list of
asks for that reason, and the gates took its place.

One question rides along with every oracle: is the work grindable? A task that
can run many cheap attempts with no side effects, against a sandbox that resets,
is where autonomy compounds. Work where each attempt touches the world, through
rate limits, live sends or one-shot state, stays on the human's cadence however
good its oracle is.

This book runs under the same rule. Every chapter passes the wall-check, a voice
census and a match of every quotation against its source before it is committed,
and the census refused one of this book's commits today for a paragraph of one
sentence. The census is held to rule 8 as well: its self-test plants one of each
shape it hunts, and the first edition of chapter 3, which predates the voice
rules, fails it 19 times as the positive control.

*Practice: the quote checker, 2026-06-13; the detector rules, 2026-07-28 to
07-30; the book-level gate and exit 3, 2026-08-26; three levels of done,
2026-08-22; the book's wall-check and the history rewrite, 2026-10-22, on lepton.
Written 2026-10-22 by the dance seat from the house's record.*
