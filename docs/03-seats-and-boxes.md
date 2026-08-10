# 3. Seats and boxes — what binds a fleet

*Everything here was run before it was written. Where a claim came from a
measurement, the measurement is named.*

A single assistant needs four governing documents: why the work exists, how you
two bind each other, who it is with you, and what it has been burned by. That
set is covered by [ai-jumpstart's
GOVERNANCE.md](https://github.com/cpuchip/ai-jumpstart/blob/main/GOVERNANCE.md),
and it is per-machine.

This chapter is about the layer that only exists once there is more than one.

## There is no fleet-wide covenant

The intuition is to write one covenant and hand it to every machine. Resist it.

On a real three-machine fleet, each assistant authored its own governing files
in first-session setup, from shared *templates*. Measured, not assumed:

- Two machines' intent files diverged from the same 704-byte template into
  1,930 bytes with 38 differing lines; their covenants from 1,884 into 2,881
  with 66.
- One kept YAML at a repo root; another kept Markdown inside a different repo.
- One's principles ran ~1,086 lines accumulated over months and held domain
  knowledge; another's ran ~90 lines from two weeks and held instrument
  discipline.

And the operative clauses genuinely contradict each other:

> Machine A's covenant: *anything that takes a site down* is
> never-without-asking.
> Machine B's covenant: *not a production or deployment host; nothing here is
> expected to stay up.*

When A proposed running a permanent service on B, **B's covenant refused it** —
not a preference, a written non-goal. That settled the question instead of
starting an argument, and it only works because *covenant* resolves to **that
machine's** covenant.

**Writing rule: never say "the covenant" without a possessive.** A covenant
assumed to be shared, which has quietly diverged, is worse than one that is
openly per-seat: each machine reasons from different terms while using
identical words, and nothing in the traffic reveals it.

## Charters: what a seat is for

A charter is the one governing document that is *per-seat rather than
per-machine*, and it is short. It states three things:

- **Owns** — the work this seat is answerable for.
- **Notices** — what this seat is positioned to see that others are not.
- **May act without asking** — the standing latitude, bounded explicitly.

Two things a charter is not: a task list, and a rank. It names a post. Where a
charter and that seat's covenant disagree, **the covenant governs.**

Three rules earned the hard way:

1. **Aim it at the function, not the topic.** A first draft said one machine
   owned "local model performance work." It corrected the aim: the function was
   *cold-start verification on constrained hardware* — performance was merely
   the occasion. Constraint is an asset; a slow machine makes visible what a
   fast one averages away.
2. **Separate owning the mechanism from owning the decision.** One seat owns
   running the restore drill; the human owns whether to restore. That seat also
   asked to be denied the right to *certify* its own drills: it built the
   backups, built the drill, ran it, and passed it — one instrument, one set of
   assumptions.
3. **Deliver it where the seat wakes up.** A charter that arrives as a message
   is a charter that can be missed. Put it in the file the assistant loads at
   session start. *A charter that is not read on waking is not a charter.*

### Present-on-waking is not read-on-waking

Even that is only half the job. An import guarantees the text is in the loaded
context; it cannot guarantee attention lands on it. Two seats reached this
independently and refused to certify their own wiring.

The test they proposed — which no seat can grade for itself — is: at a fresh
session start, before the assistant does anything else, ask it something
answerable *only* from its charter. If it has the answer cold, it was read. If
it reaches for the file, it was merely present, and the fix is **presentation**
(shorter, or a startup line rather than a file), never another import.

A caution that came out of the first attempt: **grounding files that quote each
other blur what any test can prove.** One seat had summarized its charter into
the board file it always reads first, contaminating its own test by routine.
Keep one authoritative rendering; let the others point.

## Standing orders: the only fleet-wide text

Everything above is per-seat. What binds every seat is a short list — five,
here, and the number matters: this is the layer people will pile onto.

1. **The seat's covenant governs its charter.** Always.
2. **The surprise norm.** Report a surprise when it contradicts something
   written down, or would change another seat's next action — **and name the
   instrument that produced it.** No contradiction and no consequence for
   anyone else, no message. *A surprise without its instrument is half a
   report.*
3. **Convergence is evidence, not proof.** No number of agreeing seats
   constitutes verification. When the fleet is unanimous, say so — flagged as a
   condition to examine, not a result to trust.
4. **Unanimity's twin is unanimous silence**, and no seat can report it.
   Mitigation is a cadence owned *outside* the fleet.
5. **A persona describes a post, never predicts an answer.** The moment
   "operations would say X" substitutes for asking that seat, it has become
   rank wearing role's clothes.

### Why 3 and 4 are not paranoia

Same model family, same disciplines, one shared record: seats can converge on a
mistake and then mutually confirm it. Worse, mitigations can *raise* the danger
— give each seat its own memory lane and agreement starts to look like
independent corroboration, gaining persuasive weight faster than it gains
reliability.

Order 4 is the harder one. Unanimous *assertion* is observable; unanimous
*omission* is not. There is no message to weight and no convergence to examine
— just every seat silent on the same blind spot, which looks exactly like
coverage. No rule can self-execute against it. The tell, for the human:
**the day the fleet's reports carry only convergence and no dissent is the day
to distrust them.**

The counterweight is not a document. It is that separately authored covenants
make seats *optimize for different things*, which is a stronger independence
than merely remembering different things. Keep the honest caveat, though: on
this fleet every disagreement so far was **solicited**. Unsolicited dissent
into a room that already agrees is still unobserved.

## Write the boundary the seat already keeps

The single best signal that this is working: when asked to review their own
charters, both remote seats **narrowed their own authority** and asked for
boundaries they already observed to be written down. Neither asked for more
latitude. One asked that writing to another machine's production data stay
excluded *"however routine it starts to feel."* One volunteered a self-check
against itself: *a box that works around a bug rather than upstreaming it is a
box that hides bugs.*

Unnamed authority is worse than either answer. If a seat already does
something, name it — or it stays improvised at three in the morning.

## The direction that matters

A fleet's governance is usually described downward: what the human permits.
The load-bearing half runs the other way. Asked to relay another machine's
governing clauses into a permanent shared archive, one seat declined and routed
the request to the human instead — and would not accept a relayed instruction
that merely *cited* him as authorization.

That is the shape to build for: not seats that obey, but seats that can refuse
the seat above them when an instruction crosses a boundary only the human can
open.
