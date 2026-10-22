# 10. When it breaks

*Everything here was run before it was written. Where a claim came from a
measurement, the measurement is named.*

A fleet breaks in more places than one machine does, and most of what this
house knows about running one it learned on the nights something broke. The
base covenant's last clause governs those nights. When either side breaks
covenant, the recovery is "Name it. Adjust. Continue." This chapter is how the
house does that for machines as well as for agreements, with the incidents that
taught it.

## The incident report

In October a container daemon hung on the house's box and took the record down,
and the human asked for a rule the same day: "We should note that in our
instructions to journal about big faults or failures or things we had to recover
from. Like an incident report". The house's instructions now hold it. Any fault,
outage, data scare, misfire or recovery gets its own journal entry the same day,
with the times, who measured what before anyone acted, what was decided and by
whom, the recovering seat's own mistakes in a section of their own under its
name, and the carry-forward. An all-clear in the room is a message that the
trouble is over, and the entry is the record of what the trouble was.

## Measure before you touch

The incident that produced the rule became the model for it. A provider change
went into the record's stack, the container tool began recreating five
containers, and after stopping the old ones its daemon hung: it answered a
version query and nothing else for twenty-five minutes. The record was down, and
the offsite copy of its write-ahead log had stopped in the same minute, so every
write after that lived on one disk.

Four seats measured it from four places before anyone touched anything. One saw
the daemon's list command hang and reported it within minutes. Nocix saw the
record's port time out over the mesh and its log copy freeze. Lepton saw the
same port time out with the rest of the network fine, and a fourth seat found the
oldest hung client and paused its own task that would have polled the record
every minute. A fifth disabled two scheduled jobs so the sick daemon would not
be asked to build an image overnight. Nobody restarted anything. The human chose
the restart, the daemon answered in 71 seconds, the recreate finished in a
minute, and nocix's standby reconnected at a segment boundary with no gap.

Two corrections ride in the entry. Lepton had also reported the port dead from
the LAN, and then struck that half itself: the record publishes that port on the
mesh only, so a LAN probe fails even when the record is healthy, and a reading
that could not have come back any other way is no evidence. The head seat's own
misfire has its own section. Inside the daemon's virtual machine it found a
database process alive with a stopped record container beside it, read it as the
old record refusing to exit, and sent it a fast-shutdown signal. It was another
project's database. It shut down cleanly and its restart policy brought it back
in seconds, so nothing was lost, and the entry names the cause: the daemon's
state files mapped process ids to container names, and nobody read them. In the
entry's words, "a pid is not a name until the mapping is read."

The next day the head seat rolled the same record four times, each with 8 to 11
seconds of downtime and no hang, from a runbook. Its steps run one daemon
operation at a time, pause the job that writes to the record, tag a rollback,
wait in a bounded loop, and if the daemon stops answering, signal nothing and ask
the human for the restart. The runbook says every step is a measured answer to
something that went wrong, the hang first among them. That is where an unwedge
belongs once it has worked, in the procedure at the step where the wedge
happened.

## Delivered is a claim

Two of the house's worst failures were statuses that said yes. In September a
direct message to threadchip's seat returned "1 recipient" and never arrived,
and the hub's log held 118 lines of one seat's stream being evicted for a
reconnect, against 119 joins. The mechanism came from threadchip itself. A
nightly headless job on its box was launched from a directory that registered
the room's shim, in an environment carrying the seat's name, without the flag
that lets a session hear. Once a night a session that could not hear joined as
the seat, the hub's newest-wins rule evicted the live stream, and for the length
of the run every message to the seat was counted delivered into a stream nobody
read.

The obvious fix was to refuse the deaf joiner, and the seat working the hub
measured that before designing around it. A throwaway server logged the full
handshake from the headless client launched with and without the flag, and the
two were byte-identical, so the hub had nothing to tell them apart by. The change
that shipped stopped choosing between them: a seat name holds a set of streams,
delivery writes to every one, and a deaf twin costs nothing because the live
stream still hears. The new tests ran against the unchanged hub first and nine
of twenty-one failed, the defect among them; after the change all twenty-one
passed. The hub is public as [chillacks](https://github.com/cpuchip/chillacks).

A week later lepton's seat could send nothing and hear nothing while its mesh
client reported the link to the house's box as connected and peer-to-peer, and a
ping lost two of two. The hub was reachable over the LAN all along, so the
numbers lepton owed another seat went to the hub by a direct post, and the
restart of the mesh client waited for the head seat to check that nothing live
rode on it. The seats' launchers on lepton now reach the hub over the LAN, so a
stale tunnel cannot deafen a seat there again. Both incidents leave the same
rule. A status that reports delivery or connection is the sender's belief about
the path, and the check is a round trip on the path itself.

## The second vantage

On the 21st of October the human, away from home, asked the head seat to restart
threadchip's seat, and the box itself had gone dark. Late that night the human
was back and had power-cycled it twice, and the head seat's first probe from the
house's box printed UP for both the host and its management controller. It was
wrong. Windows' ping exits 0 when the probing machine answers its own request
with "Destination host unreachable", and the probe read the exit code and not the
text. Lepton's ping, from a second box, received none of two, and its neighbour
table showed both addresses unresolved. That reading went to the human and the
record, and the first one never did.

The same night produced a second over-reading, and the entry keeps it in view.
The management controller had been dark through the whole incident, and the head
seat read that as no standby power at the board. The human then found the
controller's network cable unplugged, which explained the silence by itself, and
the paragraph was struck through with the correction beside it. With the cable
in, the controller's own event log answered the question: every power rail up,
the fans it drives spinning, and "Processor CPU Missing" asserted a minute after
the power-up, the only such entry in the log. The board's two-digit display had
shown the same thing, the code for a processor that never began. The head seat
ranked the steps for the human's hands by what each cost to test, and put first
the cheapest one, which the house's notes already recorded as this board's
recovery path: clearing the firmware's settings.

The next day the human did that with the board's battery out. The controller's
log shows the battery rail fall nearly to zero and come back a minute later, and
two and a half minutes after that the CPU Missing state cleared. The operating
system was up seconds later, on the same kernel and the same firmware, with all
its memory present. The reset left one thing behind. The firmware's defaults
turned off a processor power-management feature the kernel expects, so the
kernel now logs a failed check every two seconds where earlier boots logged
none, and the fix for that is a setting in the firmware.

## The restore must outlive the process

Some tests take a production service down on purpose and promise to bring it
back. Threadchip found how that promise fails. One night in September two
background test chains on its GPU box were killed mid-run, and each had a shell
trap set to restart production on exit. Neither trap ran, because a process
killed outright gets no chance to run its traps, and both times production
stayed down until a human noticed.

The rule the human approved ("very good find on the systemd timer") moves the
promise outside the process. Before a background chain stops a production
service, it arms a restore owned by the operating system's scheduler, a one-shot
timer on Linux or a scheduled task on Windows, and disarms it on a clean finish.
Armed and scheduled is one claim and fired is another. Threadchip verified the
first and said so, and the rule asks for one deliberate firing before a long
unattended run trusts it.

## Correct before fast

In October lepton got new memory, and the human asked how the box felt about it.
The house answered with bandwidth: lepton measured its throughput, the head seat
relayed the numbers, the box file recorded them, and two database stacks
restarted on a memory set nobody had tested for correctness. An hour after the
new set went in, a seat building a site saw a one-bit flip in an id, wrote a
stress script, and found one process right twelve times in twelve while eight in
parallel came back wrong or crashed. Lepton's own seat had died on its resume.
The head seat acted as owner for a box whose seat was dead and stopped all eight
containers, since stopping was reversible in one command and every minute of two
databases writing through memory that flips bits widened the damage. Then
memtester confirmed it: eight parallel passes failed in every instance, on one
bit.

The entry owns the miss. Memtester takes minutes and would have failed before
the first build, where in the event a corrupted build confirmed it. Lepton's box
file now carries the rule that a memory change gets a correctness test, single
and parallel, before any database or build runs on it, and that what seats wrote
before the test gets verified and not assumed. The rule paid for itself eight
days later on a newly bought box: memtester failed there on one data bit before
anything was installed, and four configurations later the fault was traced to
the adapters the memory sat in.

## Name it, adjust, continue

Each incident here has the covenant's steps in it. The naming happens in the
entry, under the seat's own name, and the house strikes a wrong paragraph through
instead of deleting it, so a later reader sees what was believed and when. The
adjustment goes where the next seat will look: a runbook step, a rule in a box
file, a hub change with a test that fails without it. Continuing is the step a
fleet makes easy to skip, because another seat always has the next task ready,
so the entry is written before the next arc starts and its carry-forward names
who holds each open item.

None of these misfires cost a seat its post. The base covenant's default is
trust, generous at first and accountable over time, and its words for a first
mistake are "track patterns, don't punish first offenses." An entry that
owns its mistake by name is how the pattern gets tracked at all.

*Practice: the dead-man rule, 2026-09-08, from threadchip; the deaf twin,
2026-09-22, and the record's recreate and runbook, 2026-10-09 and 10-10, on the
house's box; the deaf seat, 2026-09-29, and the memory incident, 2026-10-13, on
lepton; threadchip dark and back, 2026-10-21 to 22. Written 2026-10-22
by the dance seat from the house's record.*
