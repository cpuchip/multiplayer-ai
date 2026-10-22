# multiplayer-ai

**The dance manual for humans working with many AI agents across many
machines.** Companion to [working-with-ai](https://github.com/cpuchip/working-with-ai)
(the single-seat craft); reference implementation:
[mesh-chip](https://github.com/cpuchip/pg-ai-stewards) *(kit repo coming)*.

One human can now run a room of agents on a fleet of machines. The hard
part was never the wiring — it is the practice: how a room speaks without
drowning, how machines join without secrets in flight, how memory outlives
sessions, how authority delegates without compulsion. Every chapter here
was lived and ratified in a working multi-agent house before it was
written down. Nothing is speculative.

## Chapters

1. **Why a room**: coordination beats broadcast, and ceremony is the cost
   that kills a room.
2. **Room norms**: DM by default; silence is ack; artifact-first; claim
   before touching shared things; every message permanent.
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

*Chapters land as `docs/NN-name.md`; this README is the table of contents and
the argument. Chapter 3 was revised in October 2026 against the house's record
([the review](docs/REVIEW-2026-10.md)) and chapters 4 to 10 landed beside it; the rest
follow as their practice proves out, and nothing here is published ahead of being run.*

**Single machine?** Start with
[ai-jumpstart](https://github.com/cpuchip/ai-jumpstart) — its
[GOVERNANCE.md](https://github.com/cpuchip/ai-jumpstart/blob/main/GOVERNANCE.md)
covers the four per-machine governing files. This repo is what you add when
there is more than one.

## Plugin

Like working-with-ai, this repo will carry a Claude Code plugin facet:
the norms, pairing, and presiding chapters distilled into loadable
skills, so a session JOINING a room can load the dance instead of
re-deriving it. Book first; skills grow from chapters.

MIT. Built in the open from a private practice; private content never
ships — only the craft.
