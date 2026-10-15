# merge-ampel

Mod für Claude Code: zeigt je offenem eigenen PR eine Ampel, was bis zum Merge noch fehlt.

- **Band über dem Prompt:** eine Ampel pro PR, alle 5 Minuten neu.
- **`/merge-ampel`:** sofort aktualisieren und Details im Seitenbereich zeigen.

| Ampel | Bedeutung |
|---|---|
| rot | CI rot, Merge-Konflikt oder Änderungen angefordert |
| gelb | CI läuft, Entwurf, offene Review-Threads oder unerledigte Punkte unter „Vor dem Merge …“ |
| grün | merge-bereit |

Gelesen werden die PRs des aktuellen Repos und von `gabrielleti/n8n` (`EXTRA_REPOS` in `hooks/merge-ampel.mjs`), nur die eigenen.

Manuelle Vorbedingungen stehen im PR-Text als Listenpunkte unter einer Überschrift, die „Vor dem Merge“ enthält. Als erledigt gelten `[x]`, `~~durchgestrichen~~` und ✅.

## Voraussetzungen

- Mods sind Early Access. Ohne `CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1` lädt Claude Code das Modul nicht. Am einfachsten in `~/.claude/settings.json`:

  ```json
  { "env": { "CLAUDE_CODE_ENABLE_FUNCTION_HOOKS": "1" } }
  ```

- `gh` installiert und angemeldet.

## Installation

```bash
claude plugin install merge-ampel --marketplace gabrielleti/claude-skills
```

Liegt der Mod zusätzlich als Handkopie unter `~/.claude/skills/merge-ampel`, lädt er doppelt. Die Handkopie dann entfernen.

## Prüfen nach Änderungen

Im Ordner `plugins/merge-ampel`, mit gesetzter Env-Variable:

```bash
CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1 claude plugin validate . && CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1 claude plugin test .
```
