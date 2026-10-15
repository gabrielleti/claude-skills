# gabrielleti / claude-skills

Gebündelter Claude-Code-Marketplace — alle Skills von Gabriel Danilet unter einem Dach.

## Installation

Einmal den Marketplace registrieren:

```
/plugin marketplace add gabrielleti/claude-skills
```

Danach beliebige Plugins installieren:

```
/plugin install austrian-tax-deductions@gabrielleti
/plugin install apple-dev-docs-and-principles@gabrielleti
/plugin install arbeitsstand@gabrielleti
/plugin install merge-ampel@gabrielleti
```

## Enthaltene Plugins

| Plugin | Zweck |
|---|---|
| [`austrian-tax-deductions`](./plugins/austrian-tax-deductions) | Österreichische Steuerabsetzungen — L1, E1/E1a, E1b, E1kv; FinanzOnline-Walkthroughs |
| [`apple-dev-docs-and-principles`](./plugins/apple-dev-docs-and-principles) | Apple-Plattform-Arbeit: keine API aus dem Gedächtnis, live `developer.apple.com` via MCP, strikte HIG/Accessibility/App-Store-Review-Compliance |
| [`arbeitsstand`](./plugins/arbeitsstand) | Offene Schritte (wer ist dran) über `/compact`, `/clear` und neue Sitzungen hinweg + Git-Stand beim Start (Branch, Uncommittetes, Worktrees nach Herkunft) |
| [`merge-ampel`](./plugins/merge-ampel) | Mod: Ampel je offenem eigenen PR über dem Prompt, `/merge-ampel` zeigt, was bis zum Merge fehlt |

## Neuen Skill hinzufügen

1. `plugins/<skill-name>/skills/<skill-name>/SKILL.md` anlegen (+ `references/`, `assets/` falls nötig).
2. Eintrag in `.claude-plugin/marketplace.json` ergänzen (unter `plugins: [...]`).
3. Committen & pushen.

Fertig — Skill ist sofort via `/plugin install <skill-name>@gabrielleti` installierbar.

## Aufbau

```
.claude-plugin/marketplace.json      # Marketplace-Manifest, listet alle Plugins
plugins/
  <plugin-a>/
    skills/<plugin-a>/SKILL.md
    skills/<plugin-a>/references/…
    hooks/hooks.json                 # optional: Hooks, werden automatisch geladen
  <plugin-b>/…
```

## Lizenz

MIT — siehe [LICENSE](LICENSE).
