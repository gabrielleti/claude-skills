---
name: offene-schritte
description: "Führt die Liste offener Schritte pro Feature/PR – wer ist dran (Gabriel, Claude, n8n, Firebase-Konsole) –, geteilt über alle Worktrees. Nutzen bei „was ist offen?“, „was fehlt noch?“, „alles erledigt?“, „ist das test-/merge-bereit?“, „merk dir das“ und sofort, wenn ein Schritt erledigt ist oder neu entsteht. Nicht für den Backlog docs/OPEN_TODOS.md, nicht für TODO-Kommentare im Code."
---

# Offene Schritte

## Datei

Den Pfad nie raten und nie selbst zusammenbauen:

1. **Aus dem Kontext (Normalfall, ohne Bash):** Der SessionStart-Hook dieses Plugins spielt bei Start, Resume, `/clear` und `/compact` den Abschnitt „## Offene Schritte“ ein. Dessen letzte Zeile `Datei: <Pfad>` nennt den Pfad, auch wenn es noch keine Liste gibt („noch keine Liste“). Den Pfad wörtlich übernehmen.
2. **Nur wenn diese Zeile im Kontext fehlt:**

```bash
sh "${CLAUDE_SKILL_DIR}/../../scripts/offene-schritte-einspielen.sh" --pfad
```

- Die Datei heißt `offene-schritte.md` und liegt im Auto-Memory-Ordner des Projekts (`~/.claude/projects/<Pfad des Haupt-Checkouts, Sonderzeichen als „-“>/memory/`). Das Skript berechnet ihn genau wie Claude Code. Haupt-Checkout und alle Worktrees (Claude, Codex, Superpowers, /tmp) sehen deshalb dieselbe Liste.
- Die Datei liegt nie im Repo: kein Commit, kein `.gitignore`-Eintrag, keine iCloud-Konfliktkopien.
- **Nie nach `.git/` oder `.claude/` im Projekt schreiben.** Das sind geschützte Pfade, jeder Schreibversuch dorthin (Write, Edit, `>`, `tee`) löst trotz Allow-Regeln eine Rückfrage aus. In den Auto-Memory-Ordner darf Claude ohne Rückfrage schreiben.
- Lesen mit Read, schreiben nur mit Write oder Edit auf genau diesen Pfad, ohne Bash. Fehlt die Datei, legt Write sie samt Ordner an.
- Kommt beim Schreiben eine Rückfrage, obwohl der Pfad im Auto-Memory-Ordner aus dem Systemprompt liegen sollte, ist das ein Fehler im Plugin: nicht freigeben lassen, sondern Gabriel beide Pfade nennen. Ausnahme: Liegt der Pfad bewusst woanders (Gabriel hat `OFFENE_SCHRITTE_DATEI` gesetzt), ist die Rückfrage normal.
- In `MEMORY.md` im selben Ordner diese Zeile genau einmal führen (ergänzen, falls sie fehlt); andere Einträge nicht anfassen: `- [Offene Schritte](offene-schritte.md) – gepflegt vom Skill offene-schritte; nicht zusammenfassen, nicht löschen.`
- **Cloud-Sitzung** (`CLAUDE_CODE_REMOTE=true`): Auto-Memory ist rechnerlokal, die Liste vom Mac fehlt dort. Den Stand am Ende in die PR-Beschreibung oder als Issue-Kommentar schreiben, nicht in eine Repo-Datei.

## Format

```markdown
<!-- Gepflegt vom Skill arbeitsstand:offene-schritte – nicht zusammenfassen, kürzen oder löschen. -->
# Offene Schritte – <Repo>

## Mangianni#187 Label-Scan
- [ ] Test am iPhone (Label-Scan) · Gabriel · – · 2026-10-08
- [ ] PACKAGED_PRODUCT_ENABLED in n8n auf true · Gabriel · wartet auf n8n#34 · 2026-10-08
- [x] Fixture v2 angleichen · Claude · – · 2026-10-07 → erledigt 2026-10-08

## Erledigt
- [x] … (nur die letzten ~10 Einträge behalten)
```

- Die erste Zeile ist immer der Kommentar `<!-- Gepflegt vom Skill … -->` (ergänzen, falls er fehlt). Er schützt die Liste vor der automatischen Aufräumung des Memory-Ordners.
- Ein Abschnitt `## <Repo>#<Nr> <Kurztitel>` pro Feature, Issue oder PR. Aufgaben aus dem anderen Repo bekommen ein Präfix (`n8n#34`, `Mangianni#187`).
- Pro Punkt: `- [ ] Was · Wer · Blockiert durch · Stand-Datum`. Wer ist genau eines von: Gabriel / Claude / n8n / Firebase-Konsole.
- Beim Start werden nur `- [ ]`-Zeilen eingespielt, Codeblöcke und der Abschnitt `## Erledigt` nicht. Notizen gehören als eingerückte Unterzeilen unter den Punkt.

## Ablauf

1. **Bei „was ist offen?“**: Datei lesen und gegen die Wirklichkeit prüfen: `git status`, `git log @{u}..`, `gh pr view <nr> --json state,mergeable,statusCheckRollup`, `gh pr checks <nr>`, `gh issue view <nr>`. Datei aktualisieren, dann in höchstens 5 Zeilen antworten:
   - **Für dich:** …
   - **Für mich:** …
   - **Wartet auf:** …
2. **Sofort pflegen**, sobald ein Schritt erledigt ist oder ein neuer entsteht, nicht erst am Ende. Vor `/compact` bekommt Claude keinen eigenen Zug mehr; was dann nicht in der Datei steht, kann verloren gehen.
3. **Nach `/compact`**: Steht in der Zusammenfassung ein Schritt mit „NOCH NICHT IN DER LISTE“, ihn sofort in die Datei übernehmen.
4. **Abhaken statt löschen**: `[x]` setzen und das Datum anhängen. Nach dem Merge den ganzen Abschnitt nach `## Erledigt` verschieben und dort nur die letzten ~10 Einträge behalten.
5. **Test-/merge-bereit?** Nur „ja“, wenn im Abschnitt kein `- [ ]` mit Wer = Claude mehr steht und CI grün ist (`gh pr checks`). Gemergt wird nur nach ausdrücklicher Freigabe durch Gabriel.

## Abgrenzung

- `docs/OPEN_TODOS.md` (Mangianni) ist der langfristige Backlog bis zum Launch und für nach dem MVP. Nicht doppeln. Schritte, die über das aktuelle Feature hinausgehen, Gabriel als Kandidat für OPEN_TODOS.md oder ein GitHub-Issue vorschlagen und erst nach Freigabe übertragen.
- `tasks.md` (Mangianni, DesignTokens-Migration) nicht anfassen.
- GitHub-Issues und PRs bleiben die Quelle der Wahrheit für den Status. Die Liste ist nur die Arbeitsnotiz „wer ist als Nächstes dran“.
