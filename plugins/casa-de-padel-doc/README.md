# casa-de-padel-doc

Plugin für Claude Code: Document Template & Visual Style Standard für alle Casa-de-Padel-Deliverables (Bankdossiers, Kreditanträge, Investorenpräsentationen, AWS-Förderanträge, Verträge, Reports). Parametrisiert via `config.json` — leicht für eigene Marken adaptierbar.

## Was es macht

Wenn du Claude bittest, ein "Casa de Padel" Dokument zu erstellen (DOCX, PPTX oder PDF), erzwingt dieser Skill:

- Cover Page mit Logo, Wortmarke, Vertraulich-Notice, Gesellschafter & Rechtsform
- Markenkonforme Heading-Hierarchie (Casa Red `#CC0000`, Court Blue `#2244CC`, Padel Dark `#2D2D2D`)
- Arial-Typografie durchgängig (10pt Body, 16pt H1)
- Tabellen-Styling mit Soft-Red-Wash-Header und Akzent-Zellen
- Korrekte Zahlen-/Währungs-Formatierung (`EUR 500.000`, `1.200 m²`)
- Du/Sie-Anrede passend zum Dokumenttyp

Quick Notes (To-Dos, kurze interne Memos) sind ausgenommen.

## Installation

Über den `gabrielleti` Marketplace:

```bash
# In Claude Code
/plugin add gabrielleti/claude-skills
/plugin install casa-de-padel-doc
```

## Konfiguration

Default-Werte (Casa de Padel) sind in `skills/casa-de-padel-doc/config.json`. Für eigene Marke:

1. `config.example.json` → `config.json` kopieren
2. Werte ersetzen: `company_name`, `wordmark_text`, `shareholders`, `legal_form`, `logo_path`, ggf. Farben
3. Logo-Datei in `skills/casa-de-padel-doc/assets/logo.png` ablegen

## Trigger-Begriffe

Der Skill aktiviert sich automatisch bei: "Casa de Padel" + "Dokument", "Bankdossier", "Kreditantrag", "Investoren", "Förderantrag", "Businessplan", "Report", "Analyse", "Vertrag", "Pitchdeck", "Präsentation".

## Dateien

```
plugins/casa-de-padel-doc/
├── README.md                            ← diese Datei
├── evals/                               ← (optional) Test-Cases
└── skills/casa-de-padel-doc/
    ├── SKILL.md                         ← Haupt-Skill (parametrisiert)
    ├── config.json                      ← aktive Konfiguration (Casa de Padel)
    ├── config.example.json              ← leeres Template für Forks
    ├── references/
    │   ├── cover-page-reference.md      ← detaillierte Layout-Spec
    │   └── document-types.md            ← Subtitles & Voice pro Typ
    └── assets/
        └── (logo.png)                   ← User-Asset, nicht committed
```

## Referenzdokument (Gold-Standard)

Layout und Werte basieren auf `Casa_de_Padel_Kreditantrag_Kauf.docx` (März 2026), erprobt für Druck und Bank-Versand.

## Lizenz

Siehe Repository-LICENSE.

## Version

1.0.0 — April 2026
