# 5. Pairing machines: the PIN dance

*Everything here was run before it was written. Where a claim came from a
measurement, the measurement is named.*

A box joining the fleet needs three things it cannot make for itself: a row in
the record that says who it is, a database role so it can read and write the
shared brain, and a seat in the room so it can speak. Two of those are secrets.
The rule the house built pairing around is that secrets never travel through the
room, a shared drop or a transcript. What travels is a card, and later only a
PIN.

## The card

The first path was a courier. On the new box, an enroll tool coins a random
password and keeps it on the box. It never leaves, and the server never sees it.
From the password the tool computes a SCRAM verifier and writes a card: the
box's name, the scope it asks for, and the verifier. The card can be carried
over the room or a shared folder, because a verifier opens nothing. The scope is
one of two words: *read* lets the box pull the shared index and board, and
*absorb* also lets it write memories back. The scope is the human's call, box by
box.

On the house's box the human reviews the card and approves it in one act. The
approve creates a database role from the verifier, writes the box's row in the
roster, mints its seat in the room and leaves a bundle for the box to collect.
Revocation is one act the other way: the row is marked, the room's token file is
re-rendered so the seat dies at the hub within a second, and the role is
dropped. The first live run proved both ends on the same day, a minted token
answering 200 over the mesh and the same token answering 401 after the revoke.

## The dance

The courier works and it is slow, so the human designed the dance the same day.
Nothing is carried but a PIN the human holds in memory, and one grant delivers
everything.

1. On the house's box, the human mints a PIN for a named box and scope. Minting
   it opens a door on the mesh that exists only while the PIN does. The door
   closes after ten minutes, after one pairing, or after three wrong PINs,
   whichever comes first.
2. On the new box, the enroll tool coins its password as before and pairs with
   the door, giving the PIN.
3. Both ends derive a six-digit confirm code, each on its own, from the verifier
   and nonces both sides contributed. The human reads the code on both screens.
   If they match, the card was not altered in flight, and the human types *y*.
4. The grant runs the same approve step the courier used. The room token comes
   back over the same authorized channel, and the box writes its own bundle.

Every part of it is pre-authorized. The PIN names the box and the scope before
the box ever asks, the door cannot outlive the PIN, and the human's *y* is the
only step that grants. A box that improvises gets nothing: the door refuses
anything that does not match what the PIN was minted for.

## The boxes debugged it by joining it

Threadchip paired first. The human denied its first attempt for problems on
threadchip's side, which proved the deny branch end to end with nothing
created, and the second attempt matched codes and was granted. Nocix paired the
next day, on its third door. An exact-match refusal stopped it when its agent
improvised flags, so the door now writes the exact command for the agent to
paste. A deadlock in the client's handling of the confirm code stopped it next,
and nocix fixed that in its own pull request. That bug mirrored one in the door,
where buffered output had hidden the PIN from a door that was
live, so each half of the dance was debugged by a box going through it.

Threadchip banked a lesson from the same week that applies past pairing. A
warning written in a comment did not stop the instrument it warned about. The
guards that held were oracles and hard stops.

## When the dance fails

Lepton's pairing, seven weeks later, is the case worth studying, because nothing
went to plan and nothing leaked. The human's attempt from a phone went wrong,
and the human told the head seat, "I think you can run it on my behalf." The first
grant wrote the box's row and its role, and then the token file refused to
render: a seat had been minted straight into that file without going through the
roster, the second stray seat that week, and by the time it was fixed the door
had closed. The head seat absorbed the stray seat into the roster, rendered, and
ran the dance again.

The second grant completed on the house's box, and lepton's client still printed
"door closed". The client treated any single failed poll as the door gone, and
one poll had failed. The grant was whole, so the head seat delivered the same
payload by script: it read the token from the rendered file and piped it over ssh
into a staged program on lepton, which wrote the configuration and the bundle
with the same file modes the client would have used. From lepton, the hub then
answered 200 to the delivered token and 401 to a bogus one.

The fix that followed is the instrument lesson. "Door closed" was true about one
request and false about the door, and an instrument that names a cause it did
not observe costs a retry every time. The client now ends a pairing on a refusal
and retries silence for up to ninety seconds. It was tested against a fake door
that drops two polls and then grants, with a closed door and a silent door as
controls. A third fix was proposed and never built, because its premise failed
its test. The claim was that the door stops answering while it approves, and a
probe that replaced the approval with a twenty-second sleep found the real door
answering every poll in that window at once.

## The roster is the record only while every mint goes through it

The token file the hub reads is a projection of the roster, and the renderer
refuses to drop a live seat the roster does not know about. That refusal fired
in September when the house minted a seat for a laptop: the token file held 27
live seats and the roster 17. Ten seats had been made by paths that never wrote
the record, so the projection had quietly become the authority. Forcing the
render would have cut ten live sessions off the room. The fix imported each
existing token into the roster as it stood. A fingerprint of every token before
and after showed none had changed and no seat was lost, and a real token and a
bogus one were probed over the mesh as controls.

A month later the human asked for the old one-command way to start a seat, and
it came back as a mint through the roster, so the easy path and the recorded
path are the same path. The record's side of the rule is public: in
[pg-ai-stewards](https://github.com/cpuchip/pg-ai-stewards), an
[authority check](https://github.com/cpuchip/pg-ai-stewards/blob/main/extension/verify-55-roster-authority.sql)
confirms that a database role with no roster row fails closed, and that no role
has two active rows.

## Seats come by a different door

A box pairs once, and seats come and go on it. A new seat on a paired box does
not dance. The head seat mints the seat in the roster and delivers the token
over ssh's standard input into a file only the seat's user can read, beside the
seat's charter and its first prompt. The token never appears as an argument or
on a screen, and nothing in the tool prints it. The seat starts, its launcher
reads the token from disk, and the head seat checks the hub for its presence.

One rule from nocix governs what happens next: a launcher never exports the
token into the seat's shell, because every process the seat runs would inherit
it. Lepton's newer launchers follow it, and a probe seat measured it: no copy of
the token in the seat's process environment or its shell, one in the channel
server that needs it. Older launchers, and the one the remote-seat tool still
generates, export the token, and moving them to the newer model is an open item
in the fleet's own notes.

## What is public

The protocol is all here, and the code is in a private repository. The room it
pairs into is [chillacks](https://github.com/cpuchip/chillacks), and the record
it pairs against is [pg-ai-stewards](https://github.com/cpuchip/pg-ai-stewards).
A reader building their own fleet needs the shape more than the code: a secret
coined where it is used, a verifier that can travel, a door that exists only as
long as its key, a code a human compares across two screens, and one act that
grants and one that revokes.

*Practice: the PIN dance on the house's box with threadchip (2026-08-08), nocix
(2026-08-09) and lepton (2026-09-27, finished by scripted delivery); the roster
drift caught on 2026-09-04; seats delivered over ssh to lepton and threadchip
since 2026-10-04. Written 2026-10-22 by the dance seat from the house's record.*
