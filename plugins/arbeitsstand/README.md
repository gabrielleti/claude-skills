# arbeitsstand

Hält den Arbeitsstand über `/compact`, `/clear` und neue Sitzungen hinweg fest, in jedem Repo und jedem Worktree:

- **Skill `offene-schritte`** führt pro Feature, Issue oder PR die Liste „wer ist dran“ (Gabriel / Claude / n8n / Firebase-Konsole).
- **Hooks** spielen beim Sitzungsstart automatisch die offenen Punkte und den lokalen Git-Stand ein.

## Installation

Ein Befehl im Terminal (Claude Code ab 2.1.275; registriert den Marketplace bei Bedarf, frischt einen veralteten auf, ist wiederholbar):

```bash
claude plugin install arbeitsstand --marketplace gabrielleti/claude-skills
```

Wirkt ab der nächsten Sitzung, im User-Scope für alle Projekte.

**Nur falls der Befehl mit „not found“ oder „source doesn't match“ abbricht** (die lokale Kopie des Marketplace `gabrielleti` ist veraltet oder stammt aus einem lokalen Ordner):

1. `claude plugin marketplace list` ausführen. Steht bei `gabrielleti` die Zeile `Source: Folder (<Ordner>)`, zuerst diesen Ordner aktualisieren: `git -C "<Ordner>" pull --ff-only`
2. Dann:

```bash
claude plugin marketplace update gabrielleti && claude plugin install arbeitsstand@gabrielleti
```

## Was beim Start eingespielt wird

| Wann | Was |
|---|---|
| Start, Resume, `/clear`, `/compact` | **Offene Schritte**: nur die `- [ ]`-Punkte der Liste, nach Abschnitt gruppiert, höchstens 20 Zeilen, plus Pfad der Datei. Ohne Liste: nur „noch keine Liste“ und der Pfad. |
| Start, Resume, `/clear` | **Git-Stand** (lokal, ohne fetch, ohne Locks): Branch und vor/hinter Upstream, laufender Merge/Rebase, uncommittete Dateien, Worktrees nach Herkunft (Codex, Claude, Superpowers, Temp), andere Branches mit ungepushten Commits. Ohne Git-Repo: nichts. |
| Vor `/compact` | Anweisung an die Zusammenfassung, offene Schritte wörtlich zu übernehmen. |

## Wo die Liste liegt

`offene-schritte.md` im Auto-Memory-Ordner des Projekts (`~/.claude/projects/<Repo-Pfad>/memory/`). Das Skript berechnet ihn genau wie Claude Code. Alle Worktrees eines Repos teilen ihn, er liegt nicht im Repo und nicht im iCloud-Ordner, und Claude darf dort ohne Rückfrage schreiben. Den genauen Pfad nennt die letzte Zeile der eingespielten Liste („Datei: …“); daraus nimmt ihn der Skill, ohne Bash-Befehl und damit ohne Rückfrage.

## Optional

In `~/.claude/settings.json` unter `"env"`:

- `GIT_STAND_BEKANNT`: Pfade (relativ zum Repo, durch Leerzeichen getrennt), die absichtlich lokal geändert bleiben (z. B. eine eingecheckte Konfigurationsdatei mit lokalen Anpassungen). Sie werden nur gezählt.
- `OFFENE_SCHRITTE_DATEI`: absoluter Pfad (oder `~/…`) der Liste statt des Auto-Memory-Ordners; ein relativer Pfad wird ignoriert. Außerhalb des Auto-Memory-Ordners fragt Claude vor jedem Schreiben nach – das ist dann erwartet.
