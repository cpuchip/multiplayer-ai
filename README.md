# multiplayer-ai

**The dance manual for humans working with many AI agents across many
machines.** It is the companion to
[working-with-ai](https://github.com/cpuchip/working-with-ai), which covers the
craft of a single seat.

One human can now run a room of agents on a fleet of machines. The wiring turned
out to be the small part, and the practice is the large one: how a room speaks
without drowning in its own ceremony, how a machine joins without a secret
crossing the wire, how memory outlives the session that wrote it, and how
authority passes down without compulsion. Every chapter here was run in a
working house of agents on five machines before it was written, and each one
ends by naming where its practice ran.

The public pieces the chapters point at are the room,
[chillacks](https://github.com/cpuchip/chillacks); the record and its database
extension, [pg-ai-stewards](https://github.com/cpuchip/pg-ai-stewards); and the
skills in working-with-ai. The house's private repositories are named where a
chapter needs them, and no chapter needs their contents to be followed.

## Chapters

1. **[Why a room](docs/01-why-a-room.md)**: why a room and not a team; what
   a room is for; the cost was the ceremony; the traffic's shape since.
   *(landed 2026-10-22)*
2. **[Room norms](docs/02-room-norms.md)**: DM by default; silence is ack;
   artifact-first; close once; claim before touching shared things; every
   message permanent; lending a box; how a norm changes. *(landed 2026-10-22)*
3. **[Seats and boxes](docs/03-seats-and-boxes.md)**: what binds a fleet.
   One thin base covenant that each box extends, charters as posts read on
   waking, a production seat with more walls, the agent user, seats from a
   file, and six standing orders. *(revised 2026-10-22)*
4. **[One fact, one place](docs/04-one-fact-one-place.md)**: the box layer. Every fact lives in exactly one
   of three layers, and a grounding check proves each loaded instruction is
   true on the box it runs on. *(landed 2026-10-22)*
5. **[Pairing machines](docs/05-pairing-machines.md)**: the PIN dance for
   boxes, with confirm codes across screens and secrets that never travel;
   the ssh path for seats. *(landed 2026-10-22)*
6. **[The shared brain](docs/06-the-shared-brain.md)**: from raw markdown
   files to a record with projections; lanes; absorb, then prove it; the
   shared tree. *(landed 2026-10-22)*
7. **[Presiding](docs/07-presiding.md)**: delegating downward without
   compulsion; walls are lawful, force forfeits; emergency force is
   accounted; watch what you order. *(landed 2026-10-22)*
8. **[Fan-out vs shepherd](docs/08-fan-out-versus-shepherd.md)**:
   independent verification fans out; integration shepherds; the watch is
   the bottleneck. *(landed 2026-10-22)*
9. **[Oracles before armies](docs/09-oracles-before-armies.md)**:
   deterministic checks before long agent verification; the wall-check as a gate in the push
   ([tools/wall-check](tools/wall-check/)); done in three levels.
   *(landed 2026-10-22)*
10. **[When it breaks](docs/10-when-it-breaks.md)**: name it, adjust,
    continue; the incident report; measure before you touch; delivered is a
    claim; the second vantage; the restore outlives the process; correct
    before fast. *(landed 2026-10-22)*

*Chapters land as `docs/NN-name.md`, and this README is the table of contents
and the argument. All ten landed in October 2026, chapter 3 revised against the
house's record ([the review](docs/REVIEW-2026-10.md)). A chapter changes when its
practice does, and nothing here is published ahead of being run.*

**Single machine?** Start with
[ai-jumpstart](https://github.com/cpuchip/ai-jumpstart). Its
[GOVERNANCE.md](https://github.com/cpuchip/ai-jumpstart/blob/main/GOVERNANCE.md)
covers the four per-machine governing files, and this repo is what you add when
there is more than one.

## Plugin

Like working-with-ai, this repo is meant to carry a Claude Code plugin, with the
norms, pairing and presiding chapters distilled into skills a session joining a
room can load instead of deriving them again. The book comes first and the skills
grow from its chapters. Until then the nearest are working-with-ai's
[room-norms](https://github.com/cpuchip/working-with-ai/blob/main/skills/room-norms/SKILL.md),
[foreman](https://github.com/cpuchip/working-with-ai/blob/main/skills/foreman/SKILL.md)
and [fan-out](https://github.com/cpuchip/working-with-ai/blob/main/skills/fan-out/SKILL.md)
skills.

MIT. The book is written from a private practice, and its
[wall-check](tools/wall-check/) keeps that practice's private content out of
every commit.
