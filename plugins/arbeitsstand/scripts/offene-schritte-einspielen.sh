#!/bin/sh
# offene-schritte-einspielen.sh - part of the Claude Code plugin "arbeitsstand".
#
# Hook mode (SessionStart, matcher startup|resume|clear|compact):
#   Prints only the OPEN items ("- [ ]") of the open-steps list, grouped by "## " section,
#   at most MAX_ZEILEN lines of at most MAX_BREITE bytes. The section "## Erledigt" /
#   "## Done" and fenced code blocks (CommonMark: 3+ backticks or tildes) are skipped,
#   CRLF line endings are tolerated.
#   The last line is always "Datei: <path>", also when there is no list yet, so the skill
#   can take the path from the context without a Bash call (no permission prompt).
#   The path is also handed to later Bash commands of the session through
#   $CLAUDE_ENV_FILE (variable OFFENE_SCHRITTE_DATEI).
# Path mode ("--pfad"): prints the absolute path of the list (the skill's fallback).
#
# Location: offene-schritte.md in Claude Code's auto-memory folder of the project,
#   computed the way Claude Code 2.1.x does it (see speicher_ordner):
#   ~/.claude/projects/<main checkout path, every non-alphanumeric -> "-">/memory/
#   All worktrees of one repository share that folder. It lies outside the repository
#   (never committed, no .gitignore entry, not synced by iCloud), and unlike .git/ and
#   .claude/ Claude may write there without a permission prompt.
# Override: OFFENE_SCHRITTE_DATEI=/absolute/path.md or ~/path.md (e.g. "env" in
#   ~/.claude/settings.json); any other (relative) value is ignored, because the session's
#   working directory differs between worktrees.
#
# POSIX sh (macOS /bin/sh = bash 3.2, dash, busybox ash). No network, git is not needed,
# always exits 0.

MAX_ZEILEN=20
MAX_BREITE=240

# Byte semantics everywhere (awk length/substr, character ranges), independent of the
# user's locale; UTF-8 text passes through unchanged.
LC_ALL=C
export LC_ALL
# An exported CDPATH can redirect a relative cd and make it print to stdout.
unset CDPATH

# Strip leading and trailing whitespace (like JavaScript's String.prototype.trim).
trim() {
  t=$1
  t=${t#"${t%%[![:space:]]*}"}
  t=${t%"${t##*[![:space:]]}"}
  printf '%s' "$t"
}

# Resolve $2 against directory $1 lexically, like node's path.resolve: "." and ".."
# segments and duplicate slashes are removed, symlinks are NOT followed.
abs_pfad() {
  case "$2" in
    /*) p=$2 ;;
    *) p=$1/$2 ;;
  esac
  printf '%s\n' "$p" | awk '
    {
      n = split($0, teil, "/")
      k = 0
      for (i = 1; i <= n; i++) {
        s = teil[i]
        if (s == "" || s == ".") continue
        if (s == "..") { if (k > 0) k--; continue }
        aus[++k] = s
      }
      r = ""
      for (i = 1; i <= k; i++) r = r "/" aus[i]
      print (r == "" ? "/" : r)
    }'
}

# Physical (symlink-free) form of a file path; falls back to the lexical form.
physisch() {
  ordner=${1%/*}
  [ -n "$ordner" ] || ordner=/
  if p=$(cd "$ordner" 2>/dev/null && pwd -P); then
    abs_pfad / "$p/${1##*/}"
  else
    printf '%s\n' "$1"
  fi
}

# Nearest directory at or above $1 that contains .git (directory or file).
git_wurzel() {
  d=$1
  while :; do
    if [ -d "$d/.git" ] || [ -f "$d/.git" ]; then
      printf '%s\n' "$d"
      return 0
    fi
    [ "$d" = / ] && return 1
    d=${d%/*}
    [ -n "$d" ] || d=/
  done
}

# Map a git root to the main checkout the way Claude Code does: a linked worktree
# (.git file -> <common dir>/worktrees/<name>) belongs to the checkout that owns the
# common dir. Anything unusual (missing back-reference, moved worktree, submodule)
# keeps the root itself - exactly where Claude Code keeps it, too.
haupt_checkout() {
  r=$1
  if [ ! -f "$r/.git" ]; then printf '%s\n' "$r"; return 0; fi
  inhalt=$(trim "$(cat "$r/.git" 2>/dev/null)")
  case "$inhalt" in
    gitdir:*) ;;
    *) printf '%s\n' "$r"; return 0 ;;
  esac
  o=$(abs_pfad "$r" "$(trim "${inhalt#gitdir:}")")
  for f in commondir gitdir; do
    if [ ! -f "$o/$f" ] || [ -h "$o/$f" ]; then printf '%s\n' "$r"; return 0; fi
  done
  u=$(abs_pfad "$o" "$(trim "$(cat "$o/commondir" 2>/dev/null)")")
  if [ "$(abs_pfad / "${o%/*}")" != "$(abs_pfad / "$u/worktrees")" ]; then
    printf '%s\n' "$r"; return 0
  fi
  zurueck=$(abs_pfad "$o" "$(trim "$(cat "$o/gitdir" 2>/dev/null)")")
  if [ "$(physisch "$zurueck")" != "$(physisch "$r/.git")" ]; then
    printf '%s\n' "$r"; return 0
  fi
  case "$u" in
    */.git)
      h=${u%/.git}
      printf '%s\n' "${h:-/}"
      ;;
    *)
      if [ -e "$u/.git" ]; then printf '%s\n' "$r"; else printf '%s\n' "$u"; fi
      ;;
  esac
}

# Claude Code's project folder name for a path: every UTF-16 code unit that is not
# [A-Za-z0-9] becomes "-"; names longer than 200 are cut to 200 and get "-" plus the
# base-36 Java-style string hash of the original path appended.
ordner_name() {
  printf '%s\n' "$1" | awk '
    BEGIN {
      for (i = 1; i < 256; i++) ord[sprintf("%c", i)] = i
      M = 4294967296
      ziffern = "0123456789abcdefghijklmnopqrstuvwxyz"
    }
    function einheit(u) {
      h = (h * 31 + u) % M
      if ((u >= 48 && u <= 57) || (u >= 65 && u <= 90) || (u >= 97 && u <= 122))
        name = name sprintf("%c", u)
      else
        name = name "-"
      laenge++
    }
    {
      if (NR > 1) einheit(10)
      s = $0; n = length(s); i = 1
      while (i <= n) {
        c = ord[substr(s, i, 1)]
        if (c < 128) { einheit(c); i++; continue }
        k = 0
        if (c >= 194 && c <= 223) { k = 2; cp = c - 192 }
        else if (c >= 224 && c <= 239) { k = 3; cp = c - 224 }
        else if (c >= 240 && c <= 244) { k = 4; cp = c - 240 }
        ok = (k > 0 && i + k - 1 <= n)
        for (j = 1; ok && j < k; j++) {
          b = ord[substr(s, i + j, 1)]
          if (b < 128 || b > 191) ok = 0
          else cp = cp * 64 + b - 128
        }
        if (!ok) { einheit(65533); i++; continue }
        if (cp >= 65536) {
          cp -= 65536
          einheit(55296 + int(cp / 1024))
          einheit(56320 + cp % 1024)
        } else einheit(cp)
        i += k
      }
    }
    END {
      if (laenge <= 200) { print name; exit }
      v = h
      if (v >= 2147483648) v = M - v
      t = ""
      do { t = substr(ziffern, v % 36 + 1, 1) t; v = int(v / 36) } while (v > 0)
      print substr(name, 1, 200) "-" t
    }'
}

# Value of "autoMemoryDirectory" in settings file $1, prefixed with "=" when the key is
# set to a string. Plain sed, so the result is the same with or without jq installed.
einstellung() {
  [ -f "$1" ] || return 1
  w=$(sed -n 's/.*"autoMemoryDirectory"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/=\1/p' "$1" 2>/dev/null | sed -n 1p)
  [ -n "$w" ] || return 1
  printf '%s\n' "$w"
}

# Validate a configured memory folder like Claude Code: optional "~/" expansion ($2=ja),
# result must be absolute, at least 3 characters and must not escape the home folder.
gueltiger_ordner() {
  w=$1
  if [ "$2" = ja ]; then
    # shellcheck disable=SC2088 # a literal "~/" prefix is what is matched here
    case "$w" in
      "~/"*)
        rest=${w#"~/"}
        probe=$(abs_pfad /@ "./$rest")
        case "$probe" in /@/?*) ;; *) return 1 ;; esac
        w=$HOME/$rest
        ;;
    esac
  fi
  case "$w" in /*) ;; *) return 1 ;; esac
  w=$(abs_pfad / "$w")
  [ "${#w}" -ge 3 ] || return 1
  printf '%s\n' "$w"
}

# Claude Code's auto-memory folder for project folder $1 (without trailing slash).
speicher_ordner() {
  projekt=$1
  # without HOME and CLAUDE_CONFIG_DIR there is no reliable answer: stay silent
  [ -n "${CLAUDE_CONFIG_DIR:-}" ] || [ -n "${HOME:-}" ] || return 1
  konfig=${CLAUDE_CONFIG_DIR:-$HOME/.claude}

  # 1) Cowork override (absolute path, no "~" expansion)
  if [ -n "${CLAUDE_COWORK_MEMORY_PATH_OVERRIDE:-}" ] &&
    v=$(gueltiger_ordner "$CLAUDE_COWORK_MEMORY_PATH_OVERRIDE" nein); then
    printf '%s\n' "$v"
    return 0
  fi

  # 2) setting "autoMemoryDirectory": the first file that sets it decides
  #    (managed > local project > shared project > user); an invalid value means default.
  case "$(uname -s 2>/dev/null)" in
    Darwin) verwaltet="/Library/Application Support/ClaudeCode/managed-settings.json" ;;
    *) verwaltet=/etc/claude-code/managed-settings.json ;;
  esac
  for s in "$verwaltet" "$projekt/.claude/settings.local.json" \
    "$projekt/.claude/settings.json" "$konfig/settings.json"; do
    if w=$(einstellung "$s"); then
      if v=$(gueltiger_ordner "${w#=}" ja); then
        printf '%s\n' "$v"
        return 0
      fi
      break
    fi
  done

  # 3) default: <base>/projects/<name>/memory
  basis=${CLAUDE_CODE_REMOTE_MEMORY_DIR:-$konfig}
  name=""
  if [ -n "${CLAUDE_CONFIG_DIR:-}" ] && [ "$basis" = "$konfig" ]; then
    name=${CLAUDE_CODE_PROJECT_DIR_NAME:-}
    case "$name" in
      "" | *[!A-Za-z0-9_-]*) name="" ;;
    esac
    [ "${#name}" -le 64 ] || name=""
    case "$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')" in
      con | prn | aux | nul | com[0-9] | lpt[0-9]) name="" ;;
    esac
  fi
  if [ -z "$name" ]; then
    wurzel=$(git_wurzel "$projekt") && wurzel=$(haupt_checkout "$wurzel") || wurzel=$projekt
    name=$(ordner_name "$wurzel")
  fi
  abs_pfad "$PWD" "$basis/projects/$name/memory"
}

offen_datei() {
  # shellcheck disable=SC2088 # a literal "~/" prefix is what is matched here
  case "${OFFENE_SCHRITTE_DATEI:-}" in
    /*)
      printf '%s\n' "$OFFENE_SCHRITTE_DATEI"
      return 0
      ;;
    "~/"?*)
      if [ -n "${HOME:-}" ]; then
        printf '%s/%s\n' "${HOME%/}" "${OFFENE_SCHRITTE_DATEI#"~/"}"
        return 0
      fi
      ;;
  esac
  projekt=$(abs_pfad "$PWD" "${CLAUDE_PROJECT_DIR:-$PWD}")
  ordner=$(speicher_ordner "$projekt") || return 1
  printf '%s/offene-schritte.md\n' "$ordner"
}

# Hand the path to later Bash commands of this session (SessionStart env file), unless
# the environment already holds exactly this path.
pfad_merken() {
  [ -n "${CLAUDE_ENV_FILE:-}" ] || return 0
  [ "$1" = "${OFFENE_SCHRITTE_DATEI:-}" ] && return 0
  q=$(printf '%s' "$1" | sed "s/'/'\\\\''/g")
  zeile="export OFFENE_SCHRITTE_DATEI='$q'"
  grep -qxF "$zeile" "$CLAUDE_ENV_FILE" 2>/dev/null && return 0
  printf '%s\n' "$zeile" >>"$CLAUDE_ENV_FILE"
}

einspielen() {
  f=$(offen_datei) || return 0
  [ -n "$f" ] || return 0
  pfad_merken "$f" 2>/dev/null
  if [ ! -f "$f" ]; then
    printf '## Offene Schritte: noch keine Liste\nDatei: %s\n' "$f"
    return 0
  fi
  if [ ! -r "$f" ]; then
    printf '## Offene Schritte: Liste nicht lesbar\nDatei: %s\n' "$f"
    return 0
  fi
  hinweis=""
  if [ -n "$(find "$f" -mtime +6 2>/dev/null)" ]; then
    hinweis="ACHTUNG: Liste seit mindestens 7 Tagen nicht geändert – vor Verwendung gegen gh/git prüfen."
  fi
  awk -v max="$MAX_ZEILEN" -v breite="$MAX_BREITE" -v hinweis="$hinweis" '
    function kurz(s) {
      if (length(s) <= breite) return s
      s = substr(s, 1, breite - 3)
      sub(/[^ -~]+$/, "", s)
      return s "..."
    }
    # length of the run of character c at the start of s
    function lauf(s, c,   k) {
      k = 0
      while (substr(s, k + 1, 1) == c) k++
      return k
    }
    { sub(/\r+$/, "") }
    # CommonMark: a fence closes only with a run of the same character that is at least
    # as long as the opening run and is followed by nothing but blanks
    zaun != "" {
      t = $0
      sub(/^[ \t]*/, "", t)
      k = lauf(t, zaun)
      if (k >= zlaenge && substr(t, k + 1) ~ /^[ \t]*$/) zaun = ""
      next
    }
    # a fence opens with 3+ backticks or tildes (indented by up to 3 spaces); a backtick
    # run that is followed by another backtick on the same line is inline code
    /^ ? ? ?(```|~~~)/ {
      t = $0
      sub(/^ */, "", t)
      c = substr(t, 1, 1)
      k = lauf(t, c)
      if (c == "~" || index(substr(t, k + 1), "`") == 0) {
        zaun = c
        zlaenge = k
        next
      }
    }
    /^## / {
      abschnitt = $0
      t = tolower($0)
      erledigt = (t ~ /^##[ \t]*(erledigt|done)/)
      gezeigt = 0
      next
    }
    erledigt { next }
    /^[ \t]*[-*+] \[ \]/ {
      n++
      kopf = (abschnitt != "" && !gezeigt)
      # a section heading is only printed together with at least one of its items
      if (z + kopf >= max) { rest++; next }
      if (kopf) { aus = aus kurz(abschnitt) "\n"; z++; gezeigt = 1 }
      aus = aus kurz($0) "\n"
      z++
    }
    END {
      if (n == 0) { print "## Offene Schritte: keine offenen Punkte"; exit }
      print "## Offene Schritte – " n " offen (Liste pflegt der Skill arbeitsstand:offene-schritte)"
      if (hinweis != "") print hinweis
      printf "%s", aus
      if (rest > 0) print "... +" rest " weitere offene Punkte – ganze Datei lesen."
    }' "$f"
  printf 'Datei: %s\n' "$f"
}

if [ "${1:-}" = "--pfad" ]; then
  offen_datei 2>/dev/null
  exit 0
fi
einspielen 2>/dev/null
exit 0
