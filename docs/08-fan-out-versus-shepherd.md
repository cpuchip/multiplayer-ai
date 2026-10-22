# 8. Fan-out versus shepherd

*Everything here was run before it was written. Where a claim came from a
measurement, the measurement is named.*

Work handed to many agents comes in two shapes, and they want opposite
treatment. Some work is the same operation across many independent units:
check each of these files against its source, summarize each of these videos.
No unit needs another's result, and that shape wants a fan-out, many fresh
agents each taking a slice. Other work is integration, where the defect that
matters lives between the pieces, and that shape wants a shepherd, one mind
holding the whole arc. The house once said the full-context shepherd is the
ceiling on quality. That turned out to be half true, and the two halves are
this chapter.

## The shepherd's half

During a night build run as a bake-off between models, one model wrote a
latent data race. It passed the build, the linter, the race detector and a critic model
reviewing the diff, because the tests never exercised the path where the race
lived. Each of those gates saw a slice: syntax, known patterns, the paths the
tests ran, the diff against its acceptance criteria. The orchestrating model,
which had watched every step of the build, caught it.

The house's first write-up credited the catch to "a human read" and concluded
that a human must stay at the merge. The human corrected it the same day: no
human had caught the race. The human had also caught the opposite case: a confident and plausible tool name
a model offered, checked by its own web search and wrong, which the human knew
at once from ground truth the model never had. One case went each way. The axis that matters runs between the full
picture and the narrow gate, and whoever holds the whole in the moment, a model
or a person, is the one with the vantage to see it. The human keeps a separate
role either way, as the one who owns the merge and its consequence.

## The fan-out's half

The other half came from verification. The house had run a correctness walk over
469 study files serially, across many sessions, because the momentum of "do the
next file" never stopped long enough to ask what shape the work was. A later
audit of 62 files of the same kind ran as six agents in parallel in about fifteen
minutes, and it was more thorough. It caught a class of error the serial walk had
under-checked, citations fabricated inside the dictionary entries the studies
quoted, and one error that had reached a study file which the serial pass had marked clean.

The reason is the operator. One agent working through hundreds of units learns
the pattern and starts to stop re-checking it, and its blind spots accumulate in
the same direction. Fresh agents each start without that history. For per-unit
checks, parallel fresh eyes beat one tiring operator, and for defects that cross
units, one mind holding everything beats any number of slices. The two shapes
complement each other.

## The triage comes first

Before a long task starts, someone says its shape out loud. Twenty or more
independent units of the same operation is a fan-out. Work that is one known
pattern, deterministic to locate, or a chain where each step needs the last, is a
single careful pass, because a fan-out there adds coordination and review without
improving the result. The house puts the question in its standing instructions
because the expensive miss on record, the 469-file walk, was a task nobody
triaged.

## Probe serially, then scale in parallel

A fan-out spec is written by the shepherd. A short serial pass finds the dominant
defect, and that knowledge goes into one shared spec every agent receives, so the
parallel agents inherit what the shepherd learned without inheriting its blind
spot. The spec is self-contained, because the agents start cold: the reason for
the work, the exact method and tools, the rules (read the source before quoting
it, flag anything sensitive instead of resolving it, correct only on a clear
mismatch), the pattern from the probe, and a compact output format a reviewer can
read. Agents edit and report and never commit; the presider commits after review.

It runs in waves. A small first wave of two agents goes out on varied slices, and
the presider reads their work before spawning the rest. A spec that produced
wrong output is cheap to fix after two agents and expensive after twelve.

## The watch is the bottleneck

A fan-out is a delegation, so chapter 7's watch applies to it whole. The presider
reads every report, verifies the high-stakes catches against the source itself,
and checks that the diff is proportionate to what was reported. In the 62-file
audit that meant six spot-checks across all the agents before accepting about
seventy-five corrections. The skill the house wrote for this puts it in one line:
"Fan-out without the watch is offloading; fan-out with the watch is
multiplication." The output format exists so the watch can keep up.

This book's own review ran the same way. The house's journals since August, 534
of them, went to three read-only agents, one per month, each given the same
numbered list of the book's claims and told to return citations with line
numbers. The claim list was the shepherd's context, written before any agent
started. Every citation the review used was then opened by the seat writing it,
and a script matched each of the 18 quoted strings against its source file with
no misses. The agents found; the seat that would sign the memo checked and
integrated.

## A fan-out on a shared box is a claim

The last cost is physical. In October a seat ran a fan-out on the house's box as
a plain eight-worker Python pool, outside any container, judging a fixture whose
answers had been written out term by term. The pool held 21.4 GB. The harness's process reaper then killed other seats' background jobs: two
preview servers that the human's open cards linked to, and a task of the head
seat's. The containers on that box
had a gate with a memory cap, and the host-side pool had none. The rule now treats
a host fan-out like a container: claim it with the worker count and the expected
memory, default to two to four workers, keep fixtures as short as the real
tool's output, and look at the memory a few minutes in instead of at the end.

## When the fan-out should be a script

The 469-file walk and the 62-file fan-out had one more thing in common: a deterministic check written afterwards caught, on its first run and in
seconds, seven contaminations that both of them had missed. A verification fan-out is often an oracle nobody
has written yet. The next chapter is about writing it first.

*Practice: the data race and its correction, 2026-06-04; the 62-file audit,
2026-06-13; the review behind this book, 2026-10-22, on lepton; the host pool,
2026-10-15, on the house's box. Written 2026-10-22 by the dance seat from the
house's record.*
