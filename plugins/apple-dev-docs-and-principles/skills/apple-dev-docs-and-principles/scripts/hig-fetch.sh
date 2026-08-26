#!/usr/bin/env bash
# Fetch a live Human Interface Guidelines page from Apple's DocC JSON API
# and render it as readable Markdown.
#
#   hig-fetch.sh typography          # one section
#   hig-fetch.sh --list              # all available section slugs
#
# Source: https://developer.apple.com/tutorials/data/design/human-interface-guidelines/<slug>.json
# Nothing is cached — every call hits Apple.

set -euo pipefail

BASE="https://developer.apple.com/tutorials/data/design/human-interface-guidelines"

if ! command -v jq >/dev/null 2>&1; then
  echo "hig-fetch: jq is required but not installed" >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "usage: hig-fetch.sh <slug> | --list" >&2
  exit 1
fi

slugs_of() {
  # Print the slug of every HIG page referenced by the given page.
  # Anchors (…/buttons#visionos) point at a section of a real page, so they are
  # trimmed back to the page slug.
  curl -fsS -m 30 "$BASE/${1}.json" 2>/dev/null \
    | jq -r '.references | keys[]
             | select(contains("com.apple.HIG"))
             | split("/") | last | split("#") | first | ascii_downcase' \
    || true
}

if [ "$1" = "--list" ]; then
  # The HIG tree is flat in URL terms, but the index only names its top level.
  # Walk one level deeper to surface slugs like motion, sf-symbols, dark-mode.
  ROOT=$(curl -fsS -m 30 "$BASE.json" \
         | jq -r '.references | keys[] | select(contains("com.apple.HIG")) | split("/") | last | split("#") | first | ascii_downcase' \
         | sort -u)
  { printf '%s\n' "$ROOT" | xargs -P 8 -I{} bash "$0" --slugs-of {}
    printf '%s\n' "$ROOT"
  } | sort -u | grep -v '^human-interface-guidelines$'
  exit 0
fi

if [ "$1" = "--slugs-of" ]; then
  slugs_of "$2"
  exit 0
fi

SLUG="$1"

RAW=$(curl -fsS -m 30 "$BASE/$SLUG.json" 2>/dev/null) || {
  echo "hig-fetch: no HIG page for '$SLUG'. Run 'hig-fetch.sh --list' for valid slugs." >&2
  exit 1
}

printf '%s' "$RAW" | jq -r '
. as $root
| def title($id): ($root.references[$id]?.title // "");
  def txt:
    if type=="array" then map(txt)|join("")
    elif type=="object" then
      if .type=="text" then .text
      elif .type=="codeVoice" then "`"+(.code//"")+"`"
      elif .type=="reference" then title(.identifier)
      elif has("inlineContent") then (.inlineContent|txt)
      elif has("content") then (.content|txt)
      else "" end
    else "" end;
  def block:
    if .type=="heading" then "\n## "+(.text//"")
    elif .type=="paragraph" then (.inlineContent|txt)
    elif .type=="aside" then "> "+((.style//"note")|ascii_upcase)+": "+([.content[]?|block]|join(" "))
    elif .type=="unorderedList" or .type=="orderedList" then ([.items[]?|"- "+([.content[]?|block]|join(" "))]|join("\n"))
    else empty end;
  "# " + (.metadata.title // "") + "\n"
  + ([(.abstract|txt)] + [.primaryContentSections[]?.content[]?|block] | join("\n"))
'
