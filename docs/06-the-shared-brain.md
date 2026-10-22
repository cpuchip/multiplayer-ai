# 6. The shared brain: one record, many renders

*Everything here was run before it was written. Where a claim came from a
measurement, the measurement is named.*

The requirement arrived on the second box's first day. A fresh assistant on a
new machine had the plugins and the skills, and the human's verdict was short:
"but it wasnt you! no memory". Pulling the house's private repository onto that
box as read-only context had been what the human called game changing, and the
ask that followed was larger: "all of my instances with you can have and work in
the same memory pool with their own lanes/sessions". This chapter is how the
house built that, and the two ways it learned that storing memory was the easy
half.

## One record, many renders, vetted hands

The design fits in one line. There is one record, a database that is the single
source of truth. Every box renders its own projections from it (the memory
index, the board, the ports list, its seat's charter) as plain files, and writes
its edits back through a tool built for that. A box gets a hand on the record
only through the enrollment chapter 5 describes, with a scope the human sets.

There is one primary, and only the primary takes writes. Two writable brains is split
brain, and the worst failure a record can have is two truths. The client refuses
the soft version of it as well: a database address that is set and fails stops with a loud error
and goes no further. Offline reading comes
free from the design, because the projections are the cache. A box that cannot
reach the record still reads the files it last rendered, and it writes back when
the link returns. Each render says when it was made, so a reader can tell a fresh
file from an old one.

The record behind all this is public:
[pg-ai-stewards](https://github.com/cpuchip/pg-ai-stewards) is the database and
its extension. The client that renders and enrolls is private, and nothing in
this chapter needs its code.

## Lanes: each box writes its own

The write grain is the box. Each box writes only its own lane of the record, and
the record makes lanes unforgeable, so a box cannot write as another. Each box's
render holds its own lane's memories as files and an index of everyone's, with
every line marked by the lane it came from. Other lanes' memories are never
copied to the box as files; they render from the record when asked. Nothing
syncs, because nothing is copied.

Inside a box the same idea runs one level down. Each seat keeps a lane file of
its own, saying what it is working on, what it has claimed and what it has handed
off, and it writes only its own while reading everyone's. A seat about to restart
a long-lived process checks the lanes first, because the process may be another
seat's.

## Memory comes inside the walls

For its first months the house's memory lived where the harness keeps it, in a
directory under the user's home, outside every repository and behind a gate that
no settings rule could open for other seats. One box's files were the only copy,
and every other seat's lesson had to be ferried to it. In August the corpus
moved into the house's private repository: one file per fact with a short header,
links between memories by name, and one index line per memory. The move
carried 156 files, each checked by hash against its original, with five oracles
green and a review from a second box that passed all three of its checks. That
review also proved the lane marks on a live row: the same memory rendered as the
reader's own on threadchip and as threadchip's lane on the house's box.

The move was correct and still cost something, because the instruction that told
each session to read the index was not moved with it. For ten days the start-up
ritual skipped the index. In that time a seat rewrote a skill it did not know
already existed, and the house could not recall vocabulary the human had already
published, with 173 indexed memories sitting unread on disk. The house's
instructions now carry that cost beside the step it restored: a memory you do not
load is a lesson the human pays for twice.

## Writing back: absorb, then prove it

Writing to the record goes through the same projectors that render it, so there
is one grammar for the files and no second copy that can drift. The cycle is
three steps and the third is the point. Absorb the local edits, render the
record back out, and diff the render against the files byte for byte. A mismatch
means stop and diagnose, and never force. Every apply is followed by a count or a
diff, because the scripts that emit changes say plainly when nothing has been
applied yet, and a silent no-op reads as success.

Two boxes absorbing at once are upserts on the same keys, so the last write wins
per row. That is acceptable for single memories and dangerous for the board, so
large edits to the board are claimed in the room first, done, and released.

## The two failures that are not storage

**A truthful pull of an untruthful record looks identical.** On nocix's list of
what broke is a 47-day gap in the importer that feeds the record. Every pull in
those weeks rendered the record faithfully, and the record was missing what the
gap left out. Nothing errored, because every step did what it was told. The
importer now runs nightly, and the rule nocix drew from it is that a render's
header has to date the record's completeness, as well as the moment of the pull.
A later review found the same defect class from the other side: the importer had
made the record's "recently changed" view wrong since the gardener that tends
memory first ran, and sessions had been running on charters that changed days
earlier without knowing it.

**At scale, the failure is recall.** Threadchip's board reached
1,998 lines, 468 of them a duplicated tail, and a fact written into it was not
recalled when it was needed. Compaction summaries, the condensed context a long
session carries forward, had invented a measurement that no instrument took. A
record that holds everything and surfaces nothing has the same effect on the work
as one that holds nothing. The rules that came from it are the ones the house
runs now: a board holds only work in flight and closed arcs move to journals, and
after every compaction a seat re-grounds on its files before it trusts what it
remembers.

## The shared tree

A record serves many boxes. A checkout serves many seats, and that turned out to
be its own hazard. On the house's box several seats commit into one clone of the
private repository, each into its own files, and the tree is never clean, because
someone is always mid-edit.

In September one seat landed a lane note with `git stash` and a rebasing pull.
The stash swept eight lane files and another seat's three scripts, and it
would not pop back, because live seats had moved the same files underneath it.
The seat stopped rather than force it. The head seat measured the three stashes
and found nothing lost: the scripts had been byte-identical in the tree the whole
time, and the stashes uniquely held regenerated stamps and five lane lines,
which were handed back by hand. Restoring the stashes wholesale would have been a
regression, rolling back other seats' timestamps and reopening a lane its seat
had closed. The rule the house adopted is never stash, never autostash, never add
a file you did not change, commit by explicit path, and when origin has moved,
fetch and then merge, because a merge leaves siblings' dirty files alone while a
rebase sweeps them.

Nine days later a seat followed that rule and still committed another seat's
file. It had added one path, its own journal, and then made a plain commit, and
the commit carried a second file, another seat's journal, which that seat had
already staged. The staging index is shared too. The protection is naming
the paths on the commit itself, because a commit limited to its paths leaves
everything else staged where it was; adding a path only tells git the file
exists. The seat that
did it verified the account on its own commit before accepting it, and the other
seat's text was whole, so nothing was rewritten.

The short form of these rules is in
[ai-jumpstart's WORKSPACE.md](https://github.com/cpuchip/ai-jumpstart/blob/main/WORKSPACE.md#one-agent-or-many-decide-before-you-add-the-second-one).
The incidents are here because the second one happened to a seat that was
obeying the first one's rule, and a rule that only names the last failure is one
incident short.

*Practice: the record and its renders since 2026-08-06; lanes per box and the
corpus in git since 2026-08-11; the stash on 2026-09-28 and the shared index on
2026-10-07, both on the house's box. Written 2026-10-22 by the dance seat from the
house's record.*
