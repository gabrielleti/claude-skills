---
name: casa-de-padel-doc
description: Document template and visual style standard for ALL Casa de Padel deliverables. Use when creating, drafting, or updating any DOCX, PPTX, or PDF for Casa de Padel — Bankdossiers, Kreditanträge, Investorenpräsentationen, AWS-Förderanträge, Verträge, Businesspläne, Reports, Analysen, Memos. NOT for quick scratch notes, single-line to-dos, or temporary internal sketches. Triggers on "Casa de Padel" + "Dokument", "Bankdossier", "Kreditantrag", "Investoren", "Förderantrag", "Businessplan", "Report", "Analyse", "Vertrag", "Pitchdeck", "Präsentation".
---

# Casa de Padel — Dokument-Skill (Parametrisiert)

Dieser Skill regelt **Aussehen und Aufbau** aller Casa de Padel Dokumente. Er ist über `config.json` (im selben Ordner) parametrisiert — kann also leicht an andere Marken angepasst werden, ohne die Skill-Logik zu ändern.

**Source of truth**: Werte und Layout basieren auf dem produzierten Referenzdokument `Casa_de_Padel_Kreditantrag_Kauf.docx` (März 2026), erprobt für Druck und Bank-Versand.

---

## 0. Konfiguration laden

**Vor jedem Einsatz** lies die Werte aus `config.json` im selben Verzeichnis. Beispiel-Schema (siehe `config.example.json` für leere Vorlage):

```json
{
  "brand": {
    "company_name": "Casa de Padel",
    "wordmark_text": "CASA DE PADEL",
    "tagline_separator": "━━━━━━━━━━",
    "logo_path": "./assets/logo.png"
  },
  "entity": {
    "shareholders": "Gabriel Danilet & Matthias Danilet",
    "legal_form": "GmbH (in Gründung)",
    "confidentiality_notice": "VERTRAULICH — NUR FÜR DEN INTERNEN GEBRAUCH",
    "confidentiality_disclaimer": "Dieses Dokument enthält geschäftsvertrauliche Informationen und darf ohne ausdrückliche Zustimmung der Gesellschafter nicht an Dritte weitergegeben werden."
  },
  "colors": {
    "primary_red": "#C62828",
    "heading_red": "#CC0000",
    "secondary_blue": "#2244CC",
    "tertiary_dark": "#2D2D2D",
    "wordmark_color": "#1B1B1B",
    "body_black": "#000000",
    "mid_grey": "#555555",
    "soft_grey": "#777777",
    "disclaimer_grey": "#999999",
    "table_wash": "#FBE9E7",
    "accent_cell_dark": "#37474F",
    "positive_green": "#2E7D32",
    "white": "#FFFFFF"
  },
  "typography": {
    "primary_font": "Arial",
    "fallback_fonts": ["Helvetica", "sans-serif"],
    "body_pt": 10,
    "wordmark_pt": 28,
    "h1_pt": 16,
    "h2_pt": 13,
    "h3_pt": 12
  },
  "language": {
    "primary": "de-AT",
    "currency_format": "EUR {amount}",
    "thousands_separator": ".",
    "decimal_separator": ","
  }
}
```

Wenn `config.json` fehlt → lade `config.casa-de-padel.json` als Fallback-Preset und informiere den User, dass er für seine eigene Marke einen lokalen `config.json` anlegen soll (Kopie von `config.casa-de-padel.json` editieren). Wenn einzelne Felder leer sind, **frage den User** statt zu raten.

In den folgenden Sektionen werden Werte als `{config.X.Y}` referenziert. Beim Anwenden mit den tatsächlichen Werten aus `config.json` ersetzen.

---

## Weiterführende Referenzen

- `references/cover-page-reference.md` — detaillierte Cover-Layout-Spec inkl. EMU-Werten und DOCX-XML-Pattern
- `references/document-types.md` — Subtitles, Tone und Inhaltsstruktur pro Dokumenttyp

---

## 1. Wann den Skill anwenden

### Pflicht — voller Cover-Style + Body-Regeln

Wende **alles** in diesem Skill an, wenn das Dokument:

- länger als ~1 Seite ist, ODER
- formellen Inhalt hat (Bankdossier, Kreditantrag, Vertrag, AWS-Antrag, Businessplan, Investorenmaterial, offizielle Korrespondenz, Pitchdeck, Investitionsanalyse, Bewertung, Report, Präsentation), ODER
- nach außen geht (Banken, Behörden, Investoren, Partner, Vermieter, Berater, Kunden in formaler Funktion).

### Ausgenommen — Quick Notes

Skill **nicht** anwenden bei:

- Einzeiligen To-Dos / Checklisten
- Internen Scratch-Notizen unter ~1 Seite
- Temporären Arbeitsdokumenten ohne Versand-Absicht
- Casual Slack-/Chat-Antworten

Im Zweifel: Frag den User. Default ist "anwenden".

---

## 2. Visual Identity — Werte aus config.json

### 2.1 Markenfarben

| Rolle | Token | Default-Wert |
|---|---|---|
| Primärakzent | `{config.colors.primary_red}` | `#C62828` |
| Heading-Rot (H1) | `{config.colors.heading_red}` | `#CC0000` |
| Sekundärakzent (H2, Links) | `{config.colors.secondary_blue}` | `#2244CC` |
| Tertiärakzent (H3) | `{config.colors.tertiary_dark}` | `#2D2D2D` |
| Wortmarke | `{config.colors.wordmark_color}` | `#1B1B1B` |
| Body | `{config.colors.body_black}` | `#000000` |
| Subtext primär | `{config.colors.mid_grey}` | `#555555` |
| Subtext sekundär | `{config.colors.soft_grey}` | `#777777` |
| Disclaimer | `{config.colors.disclaimer_grey}` | `#999999` |
| Tabellen-Wash | `{config.colors.table_wash}` | `#FBE9E7` |
| Akzent-Cell | `{config.colors.accent_cell_dark}` | `#37474F` |
| Positiv-Highlight | `{config.colors.positive_green}` | `#2E7D32` |

### 2.2 Schrift

- **Primär**: `{config.typography.primary_font}` (Default Arial) — durchgängig in DOCX, PPTX und PDF
- **Fallback**: `{config.typography.fallback_fonts}` (Helvetica, sans-serif)
- Keine Mischung mit anderen Schriften

### 2.3 Logo

- **Datei**: `{config.brand.logo_path}`
- **Position auf Cover**: zentriert oben
- **Cover-Größe**: ca. 5,1 cm × 7,6 cm (1.828.800 × 2.743.200 EMU in DOCX)
- **Mindestabstand**: 50% der Logo-Höhe zu allen Elementen
- **Verboten**: Verzerren, Farben ändern, auf unruhigem Hintergrund

---

## 3. Cover Page — Pflicht-Aufbau

**Jedes** Dokument (außer Quick Notes) startet mit dieser Cover Page in genau dieser Reihenfolge:

```
┌─────────────────────────────────────┐
│                                     │
│        [{config.brand.logo_path}]   │   ← zentriert, ~5cm breit
│                                     │
│                                     │
│     {config.brand.wordmark_text}    │   ← Arial Bold {config.typography.wordmark_pt}pt {wordmark_color}
│     {config.brand.tagline_sep}      │   ← Casa Red, 14pt
│         {Subtitle}                  │   ← Arial 18pt {primary_red}
│                                     │
│         {Beschreibungssatz}         │   ← Arial 12pt {mid_grey}
│                                     │
│         Erstellt: {Monat Jahr}      │   ← Arial 11pt {soft_grey}
│         Gesellschafter:             │
│         {config.entity.shareholders}│
│         Rechtsform:                 │
│         {config.entity.legal_form}  │
│                                     │
│  {config.entity.confidentiality_    │   ← Arial Bold 9pt {primary_red}
│   notice}                           │
│  {config.entity.confidentiality_    │   ← Arial Italic 8pt {disclaimer_grey}
│   disclaimer}                       │
│                                     │
└─────────────────────────────────────┘
                                          ← Page Break vor Inhalt
```

### Pflichtelemente (alle vier)

1. **Logo** — `{config.brand.logo_path}` zentriert
2. **Wortmarke + Trenner** — `{config.brand.wordmark_text}` 28pt Bold + `{config.brand.tagline_separator}` in `{config.colors.primary_red}`
3. **Vertraulich-Notice** — `{config.entity.confidentiality_notice}` in Bold + `{config.entity.confidentiality_disclaimer}` in Italic
4. **Gesellschafter + Rechtsform** — `Gesellschafter: {config.entity.shareholders}` und `Rechtsform: {config.entity.legal_form}`

### Variable Elemente (pro Dokument)

| Element | Beispiel | Wer entscheidet |
|---|---|---|
| Subtitle | "Bankdossier & Detailanalysen" / "Investitionsanalyse" / "Pitchdeck" | aus Dokumenttyp ableiten |
| Beschreibung | "Kreditantrag für den Kauf und Umbau einer Indoor-Padel-Anlage in Rotenturm an der Pinka" | aus Dokumentinhalt ableiten — ein Satz, präzise |
| Datum | "Erstellt: März 2026" — Monat ausgeschrieben + Jahr | aktuelles Datum |

### Page Break

Nach Cover **immer** Page Break — Inhalt beginnt auf Seite 2 mit Inhaltsverzeichnis (>5 Seiten) oder direkt mit Heading 1.

---

## 4. Heading-Styles

| Level | Stil | Beispiel-Verwendung |
|---|---|---|
| **Heading 1** | `{config.typography.primary_font}` `{config.typography.h1_pt}`pt, `{config.colors.heading_red}` | Hauptkapitel: "Executive Summary", "Standort & Investition" |
| **Heading 2** | `{config.typography.primary_font}` `{config.typography.h2_pt}`pt, `{config.colors.secondary_blue}` | Unterabschnitte: "Marktanalyse", "Renditeprognose" |
| **Heading 3** | `{config.typography.primary_font}` `{config.typography.h3_pt}`pt, `{config.colors.tertiary_dark}` | Detail-Untergruppen: "Annahmen" |
| **Inhaltsverzeichnis** | wie Heading 1, aber Einträge in `{config.colors.wordmark_color}` Bold 11pt mit Einrückung pro Level | nach Cover, vor Kapiteln |

---

## 5. Body-Text-Regeln

### 5.1 Fließtext

- **Schrift**: `{config.typography.primary_font}` `{config.typography.body_pt}`pt
- **Farbe**: `{config.colors.body_black}`
- **Zeilenabstand**: einzeilig (1.0), Absatzabstand 6pt nach
- **Ausrichtung**: linksbündig (NIE Blocksatz mit erzwungenem Abstand)
- **Hervorhebungen**: Bold für Schlüsselbegriffe, kein Underline, Italic nur für Disclaimer/Quellen

### 5.2 Listen

- Bullet-Style: schlichter Punkt `•`, kein farbiger oder dekorativer Bullet
- Einrückung: 0,63 cm (default), eine Ebene maximal in formellen Dokumenten
- Nummerierte Listen: arabische Ziffern mit Punkt: `1.`, `2.`, `3.`

### 5.3 Zahlen, Währungen, Einheiten

- **Währung**: Format aus `{config.language.currency_format}` (Default: `EUR 500.000`)
- **Tausendertrennung**: `{config.language.thousands_separator}` (Default Punkt: `1.200`)
- **Dezimaltrennung**: `{config.language.decimal_separator}` (Default Komma: `2,5%`)
- **Flächen**: `1.200 m²` (mit Leerzeichen, hochgestelltes ²)
- **Prozent**: ohne Leerzeichen vor `%`: `15%`, `8,5%`
- **Zeiträume**: `2026–2030` (Halbgeviertstrich, kein Bindestrich)

### 5.4 Sprache (Du / Sie)

| Dokumenttyp | Anrede |
|---|---|
| Bankdossier, Kreditantrag, Behörden, AWS-Antrag, Verträge, Investorenmaterial | **Sie** |
| Social Media, Website, Newsletter, Kunden-E-Mail, Community-Kommunikation | **Du** |
| Interne Dokumente an Team / Gesellschafter | **Du** |

### 5.5 Pflichtbegriffe (branchen-/markenspezifisch)

Casa de Padel:
- Immer **"Padel"** — nie "Paddle" / "Paddel"
- Immer **"Court"** für Spielfeld — nie "Platz" / "Feld"
- Immer **"{config.brand.company_name}"** zusammenhängend mit "de" — nie "CDP" / "CasaDePadel"

Bei Fork für andere Marke: Pflichtbegriffe in `config.json` unter `terminology` ergänzen (siehe `config.example.json`).

---

## 6. Tabellen-Styling

### 6.1 Standard-Tabelle

- **Header**: BG `{config.colors.table_wash}`, Text Bold 10pt `{config.colors.wordmark_color}`
- **Body-Zeilen**: weiß, 10pt `{config.colors.body_black}`
- **Zebra-Streifen (optional)**: `#F5F5F5`
- **Border**: keine harten Ränder — nur Header-Bottom 1pt `{config.colors.primary_red}`
- **Padding**: 0,15 cm horizontal, 0,1 cm vertikal

### 6.2 Akzent-Zellen (Key Numbers)

Für Gesamtinvestition, ROI etc.:
- BG: `{config.colors.accent_cell_dark}`
- Text: `{config.colors.white}` Bold

### 6.3 Positiv-/Negativ-Markierung

- Positiv: Text in `{config.colors.positive_green}`
- Negativ: Text in `{config.colors.primary_red}`

---

## 7. Format-spezifische Regeln

### 7.1 DOCX (Word)

- Seitenformat: A4 hochkant
- Ränder: 2,5 cm rundum
- Cover ohne Seitenzahl/Header. Ab Seite 2 Footer mit Seitenzahl rechts (`Seite X von Y`) Arial 9pt `{config.colors.soft_grey}`
- Inhaltsverzeichnis: ab >5 Seiten Pflicht
- Logo: embedded image, NICHT als Link

### 7.2 PPTX (Slides)

- Seitenformat: 16:9 (33,87 × 19,05 cm)
- **Title Slide**: Logo zentriert oben (~3 cm), Wortmarke 44pt Bold `{wordmark_color}`, Trenner `{primary_red}`, Subtitle 28pt `{primary_red}`, Beschreibung 18pt `{mid_grey}`, Datum/Gesellschafter 14pt `{soft_grey}`, Vertraulich 10pt Bold `{primary_red}` + Disclaimer 9pt italic `{disclaimer_grey}`
- **Content Slides**: Titel oben links 28pt Bold `{heading_red}` mit 0,5pt Trenner-Linie `{primary_red}`; Body 18pt `{body_black}`; Footer Logo klein unten links + Seitenzahl unten rechts 10pt `{soft_grey}`
- **Section Divider**: Vollfläche `{wordmark_color}` BG, Titel 36pt Bold `{white}` zentriert, kleiner Trenner `{primary_red}`
- Charts: Primärserie `{primary_red}`, Sekundärserie `{secondary_blue}`

### 7.3 PDF

- Immer aus DOCX/PPTX exportiert (kein nativer PDF-Build)
- "PDF/A" wenn für Behörden/Banken-Archivierung
- Hyperlinks erhalten
- Embedded fonts: `{primary_font}` muss eingebettet werden
- **Schwarz-weiß-Test**: vor Bank-Versand in Graustufen prüfen — `{primary_red}` und `{secondary_blue}` müssen unterscheidbar bleiben

---

## 8. Workflow für neue Dokumente

1. **`config.json` laden** — wenn fehlt: stoppen und User fragen
2. **Klassifizieren** — Quick Note → Skill nicht anwenden. Substanzielles Dokument → weiter
3. **Dokumenttyp identifizieren** (Bankdossier / Kreditantrag / Pitchdeck / Vertrag / Report / etc.)
4. **Voice/Tone wählen** passend zum Typ (formell/Sie für Banken, energetisch für Pitchdecks)
5. **Cover Page bauen** mit allen vier Pflichtelementen (§3) — Subtitle/Beschreibung aus Dokumentinhalt ableiten
6. **Inhalt strukturieren** mit Heading-Hierarchie (§4) und Body-Regeln (§5)
7. **Tabellen** nach §6 stylen
8. **Format-spezifische Regeln** (§7) anwenden
9. **Schwarz-weiß-Test** mental durchgehen, wenn an Bank/Behörde

Bei fehlenden Werten: **fragen** — nicht raten.

---

## 9. Konfiguration für eigenes Unternehmen anpassen (Fork)

Dieser Skill ist für jede kleine GmbH adaptierbar:

1. Forke das Plugin
2. Kopiere `config.casa-de-padel.json` zu `config.json`
3. Editiere die Werte (`brand`, `typography`, `colors`, `entity`, `language`, …)
4. Fertig — `config.json` wird automatisch nicht committed (gitignored), deine Marken-Werte bleiben lokal

Alternativ: starte von `config.example.json` für komplett neue Marken ohne Casa-de-Padel-Defaults.

Default-Preset ist `config.casa-de-padel.json` (committed); aktive Konfiguration ist `config.json` (lokal, gitignored).

---

## 10. Versionierung

- **Version**: 1.0
- **Erstellt**: April 2026
- **Basiert auf**: `Casa_de_Padel_Kreditantrag_Kauf.docx` (Gold-Standard-Referenz)
- **Lizenz**: siehe Repository-LICENSE
