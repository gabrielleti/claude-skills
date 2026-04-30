# Cowork-Workflow für Casa de Padel Dokumente

Diese Reference gilt, wenn Claude in **Cowork** (Anthropics cloud-basierte Sandbox-Umgebung) statt lokal auf macOS/Windows/Linux läuft. Sie überschreibt bzw. ergänzt Sektion 7–8 von `SKILL.md`.

---

## 0. Cowork-Mode erkennen

Heuristik (in dieser Reihenfolge prüfen):

1. Liegt das aktuelle Arbeitsverzeichnis (`pwd`) unter `/Users/...` (macOS) oder `/home/<echter-username>/...` (Linux-Desktop)? → **lokal**, Reference nicht anwenden.
2. Liegt es unter einem generischen Container-Pfad wie `/workspace`, `/app`, `/tmp/...`, oder ist die Hostname-Umgebung eine Sandbox-Kennung? → **Cowork**, Reference anwenden.
3. Im Zweifel: User explizit fragen "Bist du in Cowork oder lokal?"

Wenn Cowork erkannt → zusätzlich `config.cowork.json` als Overlay laden (siehe `SKILL.md` §0).

---

## 1. Output-Verzeichnis — Regel: cwd, immer

**Pflicht**: Erzeugte Dateien (`.docx`, `.pptx`) immer ins aktuelle Arbeitsverzeichnis ablegen.

| Erlaubt | Verboten |
|---|---|
| `./Casa_de_Padel_Bankdossier_2026-04.docx` | `/Users/.../Downloads/...docx` |
| `Casa_de_Padel_Pitchdeck.pptx` (relativ) | `~/output/...pptx` |
| Unterordner im cwd: `./out/dossier.docx` | `/tmp/...docx` |

**Dateinamen-Schema** (aus `config.cowork.json`):
```
{company_short}_{document_type}_{YYYY-MM}.{ext}
```
Beispiel: `Casa_de_Padel_Kreditantrag_2026-04.docx`

**Nach Erstellung** dem User den relativen Pfad nennen und kurz hinweisen:
> "Datei liegt unter `./Casa_de_Padel_Kreditantrag_2026-04.docx`. Du kannst sie aus dem Cowork-Workspace herunterladen."

---

## 2. PDF-Export — verboten

**Regel**: In Cowork niemals direkt zu PDF exportieren (LibreOffice, weasyprint, pandoc-pdf, reportlab etc.).

**Begründung**: Cowork-Sandboxes haben kein Arial installiert. Headless-Render ersetzt es durch DejaVu Sans/Liberation Sans — die Schrift wird im PDF eingebettet und das Dokument sieht falsch aus (andere Laufweite, Kerning, Glyphen-Form).

**Wenn der User ein PDF braucht**:
- Erzeuge nur die `.docx`/`.pptx` in Cowork.
- Hinweise an den User: "Für PDF: öffne die Datei lokal in Word/PowerPoint und exportiere als PDF/A. Cowork-Schriftarten würden Arial ersetzen."

**Wenn der User trotzdem explizit PDF in Cowork anfordert**: Warne einmal klar ("Schrift wird abweichen, nicht banktauglich"), führe es nur nach expliziter Bestätigung aus, und benenne die Datei eindeutig als Vorschau: `..._PREVIEW_only.pdf`.

---

## 3. Schriftart-Handling im DOCX/PPTX

**Regel**: Im Datei-Tag immer `font-family: "Arial"` setzen, auch wenn die Cowork-Sandbox die Schrift nicht hat.

**Warum das funktioniert**: `.docx` und `.pptx` speichern nur den Schriftnamen, nicht die Glyphen-Daten. Beim Öffnen lokal (Word, Pages, PowerPoint) wird die lokal installierte Arial-Schrift verwendet.

**Verboten**: `font-family` auf `DejaVu Sans` oder `Liberation Sans` setzen, "weil Cowork das hat". Das würde die Datei lokal falsch rendern.

**Spezialfall PowerPoint Themes**: Bei `python-pptx` immer den Master-Slide auf Arial setzen, nicht nur die Body-Placeholder. Sonst erbt der Theme-Default sandbox-spezifische Schriften.

---

## 4. Logo-Pfad-Resolution in Cowork

**Strategie: In-Memory-Embed.** Logo wird als Bytes in den Speicher geladen und direkt an `python-docx`/`python-pptx` übergeben. Im erzeugten DOCX/PPTX ist das Bild embedded, NICHT als externer Pfad referenziert. Kein Datei-Kopieren ins cwd.

### 4.1 Plugin-Asset-Pfad finden

Resolution-Reihenfolge (in dieser Reihenfolge prüfen):

1. **Env-Variable**: Wenn `$CLAUDE_PLUGIN_ROOT` gesetzt → `${CLAUDE_PLUGIN_ROOT}/skills/casa-de-padel-doc/assets/logo.png`
2. **Plugin-Cache**: `find ~/.claude/plugins -name 'logo.png' -path '*casa-de-padel-doc*' 2>/dev/null | head -1`
3. **User fragen**: "Wo liegt `logo.png` in dieser Sandbox? (z.B. via Upload bereitgestellt)"

Pfad in Variable `logo_path` halten. Datei nur **einmal** lesen, Bytes wiederverwenden, falls mehrere Slides/Seiten das Logo brauchen.

### 4.2 In-Memory-Embed (python-docx)

```python
from docx import Document
from docx.shared import Emu
from io import BytesIO

LOGO_WIDTH_EMU = 1828800   # 5,1 cm — siehe SKILL.md §2.3
LOGO_HEIGHT_EMU = 2743200  # 7,6 cm

with open(logo_path, "rb") as f:
    logo_bytes = f.read()

# Pro Einsatz frischer BytesIO-Stream (sonst Position-Pointer-Bug)
doc.add_picture(BytesIO(logo_bytes), width=Emu(LOGO_WIDTH_EMU), height=Emu(LOGO_HEIGHT_EMU))
```

### 4.3 In-Memory-Embed (python-pptx)

```python
from pptx.util import Cm
from io import BytesIO

with open(logo_path, "rb") as f:
    logo_bytes = f.read()

# Title-Slide: zentriert oben, ~3 cm hoch — siehe SKILL.md §7.2
title_slide.shapes.add_picture(
    BytesIO(logo_bytes),
    left=Cm(15.4), top=Cm(2),
    width=Cm(3), height=Cm(4.5)
)

# Footer-Slides: kleines Logo unten links
for slide in content_slides:
    slide.shapes.add_picture(
        BytesIO(logo_bytes),  # NEUER Stream pro Aufruf
        left=Cm(0.8), top=Cm(17.5),
        width=Cm(1.2), height=Cm(1.8)
    )
```

**Kritisch**: Pro `add_picture`-Aufruf einen frischen `BytesIO(logo_bytes)` übergeben — `python-pptx` liest den Stream bis EOF und ein zweiter Aufruf mit demselben Objekt schlägt mit "image is empty" fehl.

### 4.4 Verboten in Cowork

- `cp <plugin>/assets/logo.png ./logo.png` ins cwd kopieren
- Externe Pfad-Referenz im DOCX-XML: `<a:blip r:link="...">` (statt `r:embed`)
- Logo via URL/HTTP einbetten (Sandbox hat ggf. kein Outbound-Internet zur Render-Zeit)

### 4.5 Fallback bei Embed-Fehler

Wenn `BytesIO`-Embed scheitert (defekte PNG, OOM, Library-Bug):

1. Error explizit an User reporten — Stack-Trace zeigen
2. **NICHT** automatisch auf Strategie (b) "ins cwd kopieren" umfallen
3. User fragen: "Memory-Embed fehlgeschlagen mit `<error>`. Soll ich das Logo temporär ins cwd kopieren (`./logo.png`, danach automatisch löschen) oder die Generierung abbrechen?"
4. Erst nach expliziter User-Bestätigung Strategie wechseln

---

## 5. Python-Library-Setup

Cowork-Sessions starten ohne `python-docx`/`python-pptx`. Vor dem ersten Generieren installieren:

```bash
pip install python-docx python-pptx
```

**Bei Installations-Fehler** (kein Internet, restriktive Sandbox):
- Stoppen, nicht weitermachen.
- User informieren: "Library-Install in Cowork fehlgeschlagen — Output muss lokal generiert werden. Soll ich dir die Markdown-Vorlage geben, die du lokal in Word verwendest?"

**Library-Versionen** (Stand 2026): `python-docx>=1.1.0`, `python-pptx>=0.6.23`. Ältere Versionen unterstützen einige EMU-Layout-Properties nicht, die Cover Page (§3 SKILL.md) braucht.

---

## 6. Schwarz-weiß-Test — an User delegieren

**Regel**: Den Schwarz-weiß-Test (SKILL.md §7.3) nicht in Cowork versuchen. Begründung: kein lokaler Word-Render, keine Graustufen-Vorschau zuverlässig erzeugbar.

**Stattdessen**: Nach Erstellung der Datei dem User explizit sagen:

> "Vor Bank-/Behörden-Versand bitte den Schwarz-weiß-Test lokal machen: Datei in Word öffnen → Datei → Drucken → Druckereinstellungen → Graustufen → Vorschau. `{primary_red}` und `{secondary_blue}` müssen unterscheidbar bleiben."

---

## 7. Workflow-Checkliste für Cowork-Sessions

Beim Start einer Casa-de-Padel-Dokument-Session in Cowork:

1. ✅ `pwd` prüfen → Cowork-Mode bestätigen
2. ✅ `config.casa-de-padel.json` laden (Defaults)
3. ✅ `config.cowork.json` als Overlay laden (Cowork-Overrides)
4. ✅ `pip install python-docx python-pptx` ausführen
5. ✅ Logo-Pfad resolven (siehe §4)
6. ✅ Dokument generieren nach SKILL.md §3–7
7. ✅ Datei mit relativem cwd-Pfad ablegen
8. ✅ User informieren: Pfad + Download-Hinweis + Schwarz-weiß-Test-Hinweis
9. ⚠️ Falls PDF angefragt: Warnung nach §2 ausgeben

---

## 8. Was NICHT anders ist als lokal

Damit klar bleibt, was die Reference *nicht* überschreibt:

- **Visual Identity** (Farben, Schrift-Tags, Logo-Größe): identisch
- **Cover Page Layout** (SKILL.md §3): identisch
- **Heading-Styles** (SKILL.md §4): identisch
- **Body-Text-Regeln** (SKILL.md §5): identisch
- **Tabellen-Styling** (SKILL.md §6): identisch
- **Voice/Tone, Du/Sie-Regeln**: identisch
- **Pflichtbegriffe** (Padel/Court/Casa de Padel): identisch

Nur die *Ausführung* (Output-Pfad, PDF-Export, Asset-Resolution, Library-Setup) ist Cowork-spezifisch.
