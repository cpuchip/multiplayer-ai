# wall-check

A gate between a private practice and a public repository. When a house of agents works in
private and publishes some of it, the public half picks up private facts in ordinary ways: a
log pasted into a doc, an address in a config example, a home path in a stack trace, a
session link in a commit trailer. This script finds those before they are pushed.

## Run it as a gate

```
tools/wall-check/wall-check.sh --tracked . && git push
```

The `&&` is the point. Written as `check; push`, the push runs whatever the check found, which
makes the check a report. Exit codes: 0 clean, 1 hits (printed as `where:line:text`), 2 the
check could not run. A check that cannot run exits 2, so a missing pattern file or a git error
stops the push the same way a hit does.

| Mode | Scans | When |
|---|---|---|
| `--tracked <repo>` | files git tracks | before every push |
| `--history <repo>` | every commit on every ref, diffs and messages | before a repo goes public, and now and then after |
| `<dir>` | every file under a directory | a draft folder before it is added |
| `--selftest` | fifteen planted cases, a clean control, a redacted history, two cannot-run cases | after any change to the script or its patterns |

## Two pattern files, one of them never public

`patterns.txt` beside the script holds the classes anyone can share: private network
addresses, the address range mesh VPNs use, local paths that carry a user name, links into an
agent session and the trailer that carries one, key material and tokens, and hardware
identifiers that name one machine.

Your own names belong in a second file that lives outside every repository:
`~/.config/wall-check/patterns.local.txt`, or wherever `WALL_LOCAL` points. That file holds
family names, the names of your employer and clients, and your own hostnames and domains. The house this book describes keeps
its list private for the same reason this one is split: the list of names to keep out of
public is itself a list of names. Every run prints how many local patterns it loaded, and
warns when it loaded none. `WALL_REQUIRE_LOCAL=1` turns that warning into exit 2.

## Hits need a person

A hit is a finding, and some findings are fine: a documentation example that shows an address
range, a test fixture. `allow.txt` beside the script takes one line per judgment, a path glob
and a line regex separated by a tab, and a hit is dropped only when both match. The count of
allowances applied is printed on every run, so a judgment never becomes invisible.

## What it does not do

It matches text. It cannot tell that a paragraph describes a private matter in plain words,
and it does not read binary files. A transcript of an agent session is private by construction
when the agent read any private file at the start of the session; publish the diffs and a
summary instead. It runs on GNU grep and git grep as found on Linux.

*Where this ran:* the house keeps its own private version, with its own name list, and has run
it before public pushes since 2026-07-12. It became a gate in the push chain on 2026-09-08,
after a public log carried a seat's private session-start reads past a hand-written grep. This
generic version was written for the book on 2026-10-22 by the dance seat on lepton, and the book's
own pushes run it beside the house's.
