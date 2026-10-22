#!/usr/bin/env bash
# wall-check: the gate between a private practice and a public repository.
#
#   wall-check.sh <dir>                  scan every file under a directory
#   wall-check.sh --tracked <git-repo>   scan only the files git tracks (run this before a push)
#   wall-check.sh --history <git-repo>   scan every commit on every ref: diffs and messages
#   wall-check.sh --selftest             plant one case per class and require each one to trip
#
# Exit 0 = clean. Exit 1 = hits, printed as where:line:text. Exit 2 = the check could not run.
# A gate that cannot run must never read as clean, so every failure to run is a 2.
#
# Run it as a gate in the same chain as the push:
#   tools/wall-check/wall-check.sh --tracked . && git push
# A check written beside the push (`check; push`) pushes whatever the check says.
#
# Patterns: patterns.txt beside this script holds the public classes (addresses, local paths,
# session links, key material). Your own names (family, employer, clients, your hostnames and
# domains) go in a LOCAL file that never enters a repo: $WALL_LOCAL, default
# ~/.config/wall-check/patterns.local.txt. Every run says how many local patterns it loaded;
# WALL_REQUIRE_LOCAL=1 turns a missing local file into exit 2.
#
# Allowances: allow.txt beside this script, one per line, `<path glob><TAB><line regex>`. A hit
# is dropped only when both match. The count applied is printed on every run. The oracle finds;
# a person judges, and the judgment is written down where the next reader can see it.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELF="$DIR/$(basename "${BASH_SOURCE[0]}")"
PUBLIC="$DIR/patterns.txt"
ALLOW="$DIR/allow.txt"
LOCAL="${WALL_LOCAL:-$HOME/.config/wall-check/patterns.local.txt}"

die() { echo "WALL: cannot run: $*" >&2; exit 2; }
count_patterns() { grep -cvE '^[[:space:]]*(#|$)' "$1" 2>/dev/null || true; }

build_regex() {
  [ -r "$PUBLIC" ] || die "no public patterns at $PUBLIC"
  NPUB=$(count_patterns "$PUBLIC")
  NLOC=0
  local files=("$PUBLIC")
  if [ -r "$LOCAL" ]; then
    NLOC=$(count_patterns "$LOCAL")
    files+=("$LOCAL")
  elif [ "${WALL_REQUIRE_LOCAL:-0}" = 1 ]; then
    die "WALL_REQUIRE_LOCAL=1 and no local patterns at $LOCAL"
  fi
  # Blank and comment lines are dropped first: an empty alternative matches every line.
  REGEX=$(grep -hvE '^[[:space:]]*(#|$)' "${files[@]}" | paste -sd'|' -)
  [ -n "$REGEX" ] || die "the pattern files hold no patterns"
}

# Drop allowed hits; print the rest; echo the counts. Input: where:line:text on stdin.
adjudicate() {
  local hits=0 allowed=0 line where text glob rx ok
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    where="${line%%:*}"; text="${line#*:}"; text="${text#*:}"
    ok=0
    if [ -r "$ALLOW" ]; then
      while IFS=$'\t' read -r glob rx; do
        case "$glob" in ''|\#*) continue ;; esac
        # shellcheck disable=SC2254
        case "$where" in $glob) printf '%s' "$text" | grep -qE -- "$rx" && ok=1 ;; esac
        [ "$ok" = 1 ] && break
      done < "$ALLOW"
    fi
    if [ "$ok" = 1 ]; then allowed=$((allowed + 1)); else hits=$((hits + 1)); echo "HIT $line"; fi
  done
  echo "COUNTS $hits $allowed"
}

report() { # $1 = file of raw hits
  local out counts hits allowed
  out=$(adjudicate < "$1")
  counts=$(printf '%s\n' "$out" | grep '^COUNTS ' | tail -1)
  hits=$(echo "$counts" | cut -d' ' -f2); allowed=$(echo "$counts" | cut -d' ' -f3)
  printf '%s\n' "$out" | grep '^HIT ' | sed 's/^HIT //'
  local note="public patterns $NPUB, local patterns $NLOC, allowances applied $allowed"
  [ "$NLOC" = 0 ] && echo "WALL: warning: no local patterns at $LOCAL, so personal names are NOT being checked" >&2
  if [ "$hits" -gt 0 ]; then echo "WALL: $hits hit(s) ($note)"; exit 1; fi
  echo "WALL: clean ($note)"; exit 0
}

# The tool's own pattern and allowance files describe what to catch; they are not scanned.
not_self() { grep -vE "^($(basename "$PUBLIC")|$(basename "$ALLOW")):" ; }

scan_tracked() {
  local repo="$1" raw rel st
  git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "$repo is not a git work tree"
  raw=$(mktemp) || die "mktemp failed"
  rel=$(cd "$DIR" && git -C "$repo" ls-files --full-name -- "$PUBLIC" "$ALLOW" 2>/dev/null)
  git -C "$repo" grep -n -I -i -E -e "$REGEX" > "$raw"; st=$?
  [ "$st" -le 1 ] || { rm -f "$raw"; die "git grep exited $st"; }
  if [ -n "$rel" ]; then
    grep -vF -f <(printf '%s:\n' $rel) "$raw" > "$raw.f" || true; mv "$raw.f" "$raw"
  fi
  report "$raw"
}

scan_tree() {
  local dir="$1" raw st
  [ -d "$dir" ] || die "$dir is not a directory"
  raw=$(mktemp) || die "mktemp failed"
  (cd "$dir" && grep -rnI -i -E --exclude-dir=.git -e "$REGEX" . ) > "$raw"; st=$?
  [ "$st" -le 1 ] || { rm -f "$raw"; die "grep exited $st"; }
  sed -i 's#^\./##' "$raw"
  if [ "$(cd "$dir" && pwd)" = "$DIR" ]; then not_self < "$raw" > "$raw.f" || true; mv "$raw.f" "$raw"; fi
  report "$raw"
}

scan_history() {
  local repo="$1" dump raw st
  git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || die "$repo is not a git repository"
  dump=$(mktemp) && raw=$(mktemp) || die "mktemp failed"
  # Written to a file first so a failing git log cannot hide behind grep's exit status.
  git -C "$repo" log --all -p --no-color --format='commit %H%n%B' > "$dump" || die "git log failed"
  awk '/^commit [0-9a-f]+$/ && length($2) >= 40 { c = substr($2, 1, 12); next } { print c ":" NR ":" $0 }' "$dump" \
    | grep -i -E -e "$REGEX" > "$raw"; st=${PIPESTATUS[1]}
  [ "$st" -le 1 ] || die "grep exited $st"
  report "$raw"
}

selftest() {
  local d fail=0 out st
  d=$(mktemp -d) || die "mktemp failed"
  # Every planted value is assembled at run time, so this file itself holds none of them.
  mkdir -p "$d/dirty" "$d/clean" "$d/hist"
  git -C "$d/dirty" init -q
  local n=0 v
  for v in \
    "lan host 10.2""0.30.40 answers" \
    "router 192.16""8.1.50" \
    "docker 172.2""0.4.9" \
    "mesh peer 100.6""4.12.7" \
    "see /ho""me/alice/notes.txt" \
    'see C:\Us''ers\alice\notes.txt' \
    "link claude.a""i/code/session_0123abc" \
    "Claude-Sess""ion: abc" \
    "token gh""p_AAAAAAAAAAAAAAAAAAAAAAAAAAAA" \
    "key sk-an""t-api03-AAAA" \
    "-----BEGIN OPENSSH PRIV""ATE KEY-----" \
    "aws AKI""AABCDEFGHIJKLMNOP" \
    "card GPU-1a2b""3c4d-0000-1111" \
    "nic 34:12:7""8:56:00:01" \
    "slack xox""b-12345"; do
    n=$((n + 1)); printf '%s\n' "$v" > "$d/dirty/case$n.txt"
  done
  printf 'Zebu''lonia was here\n' > "$d/dirty/local.txt"
  printf 'Zebulonia\n' > "$d/local-patterns.txt"
  git -C "$d/dirty" add -A && git -C "$d/dirty" -c user.name=t -c user.email=t@example.invalid commit -qm plant

  out=$(WALL_LOCAL="$d/local-patterns.txt" "$SELF" --tracked "$d/dirty" 2>/dev/null); st=$?
  [ "$st" = 1 ] || { echo "selftest: planted repo exited $st, want 1"; fail=1; }
  local i
  for i in $(seq 1 "$n") local; do
    f="case$i.txt"; [ "$i" = local ] && f=local.txt
    printf '%s\n' "$out" | grep -q "^$f:" || { echo "selftest: $f did not trip"; fail=1; }
  done

  printf 'version 10.2 of the tool; 3 seats on 2 boxes; ratio 1:4\n' > "$d/clean/ok.txt"
  "$SELF" "$d/clean" >/dev/null 2>&1; st=$?
  [ "$st" = 0 ] || { echo "selftest: clean control exited $st, want 0"; fail=1; }

  git -C "$d/hist" init -q
  printf 'peer 100.6''4.12.7\n' > "$d/hist/a.txt"
  git -C "$d/hist" add a.txt && git -C "$d/hist" -c user.name=t -c user.email=t@example.invalid commit -qm one
  printf 'redacted\n' > "$d/hist/a.txt"
  git -C "$d/hist" -c user.name=t -c user.email=t@example.invalid commit -qam two
  "$SELF" --tracked "$d/hist" >/dev/null 2>&1; st=$?
  [ "$st" = 0 ] || { echo "selftest: redacted tree exited $st, want 0"; fail=1; }
  "$SELF" --history "$d/hist" >/dev/null 2>&1; st=$?
  [ "$st" = 1 ] || { echo "selftest: history of a redacted secret exited $st, want 1"; fail=1; }

  "$SELF" --tracked "$d/does-not-exist" >/dev/null 2>&1; st=$?
  [ "$st" = 2 ] || { echo "selftest: missing target exited $st, want 2"; fail=1; }
  WALL_REQUIRE_LOCAL=1 WALL_LOCAL="$d/none.txt" "$SELF" "$d/clean" >/dev/null 2>&1; st=$?
  [ "$st" = 2 ] || { echo "selftest: required local file missing exited $st, want 2"; fail=1; }

  rm -rf "$d"
  if [ "$fail" = 0 ]; then echo "selftest: PASS ($n public classes, 1 local, clean control, history, two cannot-run cases)"; exit 0; fi
  echo "selftest: FAIL"; exit 1
}

MODE=tree
case "${1:-}" in
  --selftest) selftest ;;
  --tracked) MODE=tracked; shift ;;
  --history) MODE=history; shift ;;
  -h|--help|'') sed -n '2,24p' "$SELF"; exit 2 ;;
esac
TARGET="${1:-}"; [ -n "$TARGET" ] || die "no target given"
build_regex
case "$MODE" in
  tracked) scan_tracked "$TARGET" ;;
  history) scan_history "$TARGET" ;;
  tree) scan_tree "$TARGET" ;;
esac
