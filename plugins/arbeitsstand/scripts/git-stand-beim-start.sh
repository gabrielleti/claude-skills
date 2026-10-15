#!/bin/sh
# git-stand-beim-start.sh - part of the Claude Code plugin "arbeitsstand".
#
# SessionStart hook (matcher startup|resume|clear): prints a short, purely local git
# overview into Claude's context - branch, ahead/behind upstream, an unfinished
# merge/rebase, uncommitted files, worktrees with their origin (Codex, Claude,
# Superpowers, temp) and other branches with unpushed commits.
#
# Rules: no network (never fetches), takes no locks (GIT_OPTIONAL_LOCKS=0, so parallel
# agents never hit index.lock), bounded output (MAX_* below), always exits 0.
# POSIX sh: macOS /bin/sh (bash 3.2), dash, busybox ash.
#
# Which checkout: the session's current directory when it belongs to the same
# repository (same git common dir) as $CLAUDE_PROJECT_DIR - e.g. after EnterWorktree or
# in a Superpowers worktree -, otherwise $CLAUDE_PROJECT_DIR.
#
# Optional: GIT_STAND_BEKANNT="path1 path2" (repo-relative, space separated, set via
# "env" in ~/.claude/settings.json): files that stay modified on purpose are only counted.

MAX_DATEIEN=4
MAX_WORKTREES=4
MAX_KAPUTT=2
MAX_BRANCHES=3
MAX_AUSGABE=25
MAX_BREITE=240

LC_ALL=C
export LC_ALL
GIT_OPTIONAL_LOCKS=0
export GIT_OPTIONAL_LOCKS
GIT_TERMINAL_PROMPT=0
export GIT_TERMINAL_PROMPT
# A session started from inside a git hook inherits these; the repository is always
# determined from the directory here.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_COMMON_DIR GIT_OBJECT_DIRECTORY GIT_PREFIX
# macOS /bin/sh (bash 3.2, POSIX mode) does not fall back to "." for a relative cd when
# an exported CDPATH lacks it, so "cd .git" would fail; other shells may print the path.
unset CDPATH
# Output goes through printf '%s\n' only: macOS /bin/sh's echo expands backslashes
# (xpg_echo), dash's echo always does, and paths may contain them.

# git with raw (unescaped) UTF-8 path names
g() {
  git -c core.quotePath=false "$@"
}

kurzpfad() {
  if [ -n "${HOME:-}" ] && [ "$HOME" != / ]; then
    case "$1" in
      "$HOME"/*)
        printf '~%s' "${1#"$HOME"}"
        return 0
        ;;
    esac
  fi
  printf '%s' "$1"
}

herkunft() {
  # $1 = worktree path; first match wins
  case "$1" in
    */.codex/worktrees/*) printf '%s\n' "Codex" ;;
    *-agent-workflow*) printf '%s\n' "Agent-Workflow" ;;
    */.claude/worktrees/*) printf '%s\n' "Claude-Worktree" ;;
    */.config/superpowers/worktrees/* | */.worktrees/* | */worktrees/*) printf '%s\n' "Superpowers/Worktree" ;;
    /tmp/* | /private/tmp/* | /var/folders/* | /private/var/folders/*) printf '%s\n' "Temp" ;;
    *) printf '%s\n' "anderer Ort" ;;
  esac
}

# Physical path of the git common dir of the repository that contains directory $1
# (works with every git version; --path-format needs git >= 2.31).
gemeinsam() {
  (
    cd "$1" 2>/dev/null || exit 1
    d=$(g rev-parse --git-common-dir 2>/dev/null) || exit 1
    [ -n "$d" ] || exit 1
    cd "$d" 2>/dev/null && pwd -P
  )
}

# True when $1/.git is a "gitdir:" file whose target no longer exists (orphaned
# worktree). Other git failures (e.g. "dubious ownership") are not reported as orphaned.
verwaist() {
  [ -f "$1/.git" ] || return 1
  ziel=$(sed -n 's/^gitdir:[[:space:]]*//p' "$1/.git" 2>/dev/null | tr -d '\r' | sed -n 1p)
  [ -n "$ziel" ] || return 1
  case "$ziel" in
    /*) ;;
    *) ziel=$1/$ziel ;;
  esac
  [ ! -d "$ziel" ]
}

# Directory to report on (see header).
sitzungs_ordner() {
  projekt=${CLAUDE_PROJECT_DIR:-}
  if [ -z "$projekt" ]; then
    printf '%s\n' "$PWD"
    return 0
  fi
  if [ "$PWD" != "$projekt" ]; then
    hier_gd=$(gemeinsam "$PWD")
    if [ -n "$hier_gd" ] && [ "$hier_gd" = "$(gemeinsam "$projekt")" ]; then
      printf '%s\n' "$PWD"
      return 0
    fi
    # an orphaned worktree as current directory deserves its warning
    if [ -z "$hier_gd" ] && verwaist "$PWD"; then
      printf '%s\n' "$PWD"
      return 0
    fi
  fi
  printf '%s\n' "$projekt"
}

git_stand() {
  command -v git >/dev/null 2>&1 || return 0
  dir=$(sitzungs_ordner)
  cd "$dir" 2>/dev/null || return 0
  if [ "$(g rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ]; then
    if verwaist "$dir"; then
      printf '%s\n' "## Git-Stand beim Start"
      printf '%s\n' "ACHTUNG: $(kurzpfad "$dir") ist ein verwaister Worktree (.git zeigt ins Leere, git-Befehle enden mit Exit 128). Nichts reparieren oder löschen ohne Rückfrage bei Gabriel."
    fi
    return 0
  fi

  hier=$(g rev-parse --show-toplevel 2>/dev/null) || return 0
  cd "$hier" 2>/dev/null || return 0
  hier_real=$(pwd -P)

  st=$(g status --porcelain=v2 --branch 2>/dev/null) || return 0

  kopf=$(printf '%s\n' "$st" | sed -n 's/^# branch\.head //p')
  oid=$(printf '%s\n' "$st" | sed -n 's/^# branch\.oid //p' | cut -c1-7)
  up=$(printf '%s\n' "$st" | sed -n 's/^# branch\.upstream //p')
  ab=$(printf '%s\n' "$st" | sed -n 's/^# branch\.ab //p')

  printf '%s\n' "## Git-Stand beim Start (lokal, ohne fetch)"

  # --- branch and ahead/behind ---
  if [ "$kopf" = "(detached)" ]; then
    zeile="Branch: (detached HEAD @ $oid)"
  else
    zeile="Branch: $kopf"
    if [ -z "$up" ]; then
      zeile="$zeile – kein Upstream (noch nie gepusht)"
    elif [ -z "$ab" ]; then
      zeile="$zeile – Upstream $up fehlt lokal (gelöscht oder nie gefetcht)"
    else
      vor=${ab%% *}
      vor=${vor#+}
      hinter=${ab##* }
      hinter=${hinter#-}
      if [ "$vor" = 0 ] && [ "$hinter" = 0 ]; then
        zeile="$zeile – gleich mit $up"
      else
        zeile="$zeile – $vor vor / $hinter hinter $up"
      fi
      # FETCH_HEAD lives per worktree; check the main checkout's (common dir) as well.
      # Missing everywhere (fresh clone): claim nothing.
      alt=""
      frisch=""
      for fh in "$(g rev-parse --git-path FETCH_HEAD 2>/dev/null)" "$(g rev-parse --git-common-dir 2>/dev/null)/FETCH_HEAD"; do
        [ -f "$fh" ] || continue
        if [ -n "$(find "$fh" -mtime +0 2>/dev/null)" ]; then alt=1; else frisch=1; fi
      done
      if [ -n "$alt" ] && [ -z "$frisch" ]; then
        zeile="$zeile (letzter fetch >24 h – Zahlen evtl. veraltet)"
      fi
    fi
  fi
  printf '%s\n' "$zeile"

  # --- unfinished operation ---
  for op in rebase-merge:Rebase rebase-apply:Rebase/am MERGE_HEAD:Merge CHERRY_PICK_HEAD:Cherry-pick REVERT_HEAD:Revert BISECT_LOG:Bisect; do
    p=$(g rev-parse --git-path "${op%%:*}" 2>/dev/null)
    if [ -n "$p" ] && [ -e "$p" ]; then
      printf '%s\n' "ACHTUNG: ${op#*:} läuft noch (nicht abgeschlossen)."
      break
    fi
  done

  # --- uncommitted files ---
  aend=$(printf '%s\n' "$st" | awk -v max="$MAX_DATEIEN" -v bekannt=" ${GIT_STAND_BEKANNT:-} " '
    /^#/ || /^$/ { next }
    {
      t = substr($0, 1, 1)
      if (t == "!") next
      if (t == "?") { xy = "??"; p = substr($0, 3) }
      else {
        xy = $2; gsub(/\./, " ", xy)
        n = 0
        if (t == "1") n = 8
        else if (t == "2") n = 9
        else if (t == "u") n = 10
        p = $0
        for (i = 0; i < n; i++) sub(/^[^ ]* /, "", p)
        if (t == "2") { k = index(p, "\t"); if (k > 0) p = substr(p, k + 1) " -> " substr(p, 1, k - 1) }
        if (t == "u") xy = "KONFLIKT " xy
      }
      if (index(bekannt, " " p " ") > 0) { b++; next }
      c++
      if (t == "?") u++
      if (c <= max) zeilen = zeilen "  " xy " " p "\n"
    }
    END {
      if (b > 0) printf "Bekannt lokal geändert (nie committen): %d Datei(en)\n", b
      if (c == 0) exit
      printf "Uncommittet: %d Datei(en), davon %d neu/ungetrackt\n", c, u
      printf "%s", zeilen
      if (c > max) printf "  ... +%d weitere (git status)\n", c - max
    }')
  [ -n "$aend" ] && printf '%s\n' "$aend"

  # --- worktrees ---
  wt=$(g worktree list --porcelain 2>/dev/null | awk '
    function flush() {
      if (pfad != "") printf "%s\t%s\t%s\n", pfad, (zweig == "" ? "-" : zweig), (flags == "" ? "-" : flags)
      pfad = ""; zweig = ""; flags = ""
    }
    /^worktree / { flush(); pfad = substr($0, 10); next }
    /^branch /   { zweig = substr($0, 8); sub(/^refs\/heads\//, "", zweig); next }
    /^detached/  { zweig = "detached"; next }
    /^bare/      { zweig = "bare"; next }
    /^locked/    { flags = flags "gesperrt,"; next }
    /^prunable/  { flags = flags "KAPUTT,"; next }
    END { flush() }')
  anzahl=$(printf '%s\n' "$wt" | grep -c .)
  kaputt=$(printf '%s\n' "$wt" | grep -c 'KAPUTT')
  if [ "${anzahl:-0}" -gt 1 ] || [ "${kaputt:-0}" -gt 0 ]; then
    if [ "${kaputt:-0}" -gt 0 ]; then
      printf '%s\n' "Worktrees: $anzahl (davon $kaputt kaputt)"
    else
      printf '%s\n' "Worktrees: $anzahl"
    fi
    tab=$(printf '\t')
    printf '%s\n' "$wt" | {
      i=0
      gezeigt=0
      kaputt_gezeigt=0
      rest=0
      restarten=""
      while IFS="$tab" read -r pfad zweig flags; do
        [ -n "$pfad" ] || continue
        i=$((i + 1))
        if [ "$i" -eq 1 ]; then
          art="Haupt-Checkout"
        else
          art=$(herkunft "$pfad")
        fi
        real=$( (cd "$pfad" 2>/dev/null && pwd -P))
        marke=""
        if [ "$pfad" = "$hier" ] || { [ -n "$real" ] && [ "$real" = "$hier_real" ]; }; then
          marke=" ← diese Sitzung"
        fi
        zusatz=""
        case "$flags" in *KAPUTT*) zusatz=" KAPUTT (Ordner fehlt; 'git worktree prune' nur nach Rückfrage)" ;; esac
        case "$flags" in *gesperrt*) zusatz="$zusatz gesperrt" ;; esac
        # this session's worktree always, up to MAX_KAPUTT broken ones, the others up to
        # MAX_WORKTREES; the rest is summarized by origin
        zeigen=""
        if [ -n "$marke" ]; then
          zeigen=1
        else
          case "$flags" in
            *KAPUTT*)
              if [ "$kaputt_gezeigt" -lt "$MAX_KAPUTT" ]; then
                zeigen=1
                kaputt_gezeigt=$((kaputt_gezeigt + 1))
              fi
              ;;
          esac
          if [ -z "$zeigen" ] && [ "$gezeigt" -lt "$MAX_WORKTREES" ]; then
            zeigen=1
            gezeigt=$((gezeigt + 1))
          fi
        fi
        if [ -n "$zeigen" ]; then
          printf '%s\n' "  - $art: $(kurzpfad "$pfad") [$zweig]$zusatz$marke"
        else
          rest=$((rest + 1))
          restarten="$restarten$art
"
        fi
      done
      if [ "$rest" -gt 0 ]; then
        arten=$(printf '%s' "$restarten" | sort | uniq -c | awk '{ n = $1; $1 = ""; sub(/^ /, ""); printf "%s%s %d", (c++ ? ", " : ""), $0, n }')
        printf '%s\n' "  ... +$rest weitere ($arten; git worktree list)"
      fi
    }
  fi

  # --- other local branches with unpushed commits ---
  # Tracked branches report "ahead N". A branch without an upstream was never pushed and
  # upstream:track is empty for it, so count its commits that are on no remote instead.
  # ":" cannot occur in ref names, so empty fields survive the split. Newest 60 branches only.
  ung=$(g for-each-ref --sort=-committerdate --count=60 \
    --format='%(refname:short):%(upstream):%(upstream:track)' refs/heads 2>/dev/null |
    while IFS=: read -r zweig oben spur; do
      [ -n "$zweig" ] && [ "$zweig" != "$kopf" ] || continue
      if [ -n "$oben" ]; then
        # leading "(" in the pattern: macOS bash 3.2 misparses "*ahead*)" inside $(...)
        case "$spur" in
          (*ahead*) n=${spur#*ahead }; n=${n%%[!0-9]*}; printf '1 %s (+%s)\n' "$zweig" "$n" ;;
        esac
      else
        n=$(g rev-list --count "refs/heads/$zweig" --not --remotes 2>/dev/null) || continue
        [ "${n:-0}" -gt 0 ] && printf '2 %s (+%s, ohne Upstream)\n' "$zweig" "$n"
      fi
    done |
    awk -v max="$MAX_BRANCHES" '
      # tracked branches that are ahead first, then never-pushed ones
      { e = substr($0, 3); if (substr($0, 1, 1) == "1") a[++na] = e; else b[++nb] = e }
      END {
        for (i = 1; i <= na; i++) z[++c] = a[i]
        for (i = 1; i <= nb; i++) z[++c] = b[i]
        for (i = 1; i <= c && i <= max; i++) liste = liste (i > 1 ? ", " : "") z[i]
        if (c > max) liste = liste ", ... +" (c - max)
        if (c > 0) print liste
      }')
  [ -n "$ung" ] && printf '%s\n' "Ungepushte Commits auch auf: $ung"

  # --- reminder ---
  case "$aend" in *Uncommittet:*) fremd=1 ;; *) fremd="" ;; esac
  if [ -n "$fremd" ] || [ "${anzahl:-0}" -gt 1 ]; then
    printf '%s\n' "Hinweis: Änderungen, die nicht aus dieser Sitzung stammen (andere Worktrees, Codex, Cloud-Agents), nicht anfassen – erst Gabriel fragen."
  fi
  return 0
}

# Hard cap on lines and bytes per line (cuts never split a UTF-8 character).
begrenzen() {
  awk -v max="$MAX_AUSGABE" -v breite="$MAX_BREITE" '
    NR > max { weg++; next }
    {
      s = $0
      if (length(s) > breite) {
        s = substr(s, 1, breite - 3)
        sub(/[^ -~]+$/, "", s)
        s = s "..."
      }
      print s
    }
    END { if (weg > 0) print "... (" weg " weitere Zeilen gekürzt)" }'
}

git_stand 2>/dev/null | begrenzen
exit 0
