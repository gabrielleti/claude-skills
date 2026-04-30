# Cover Page — Layout-Referenz

Detaillierte Spec für die Cover Page des Casa-de-Padel-Doc-Skills, basierend auf dem produzierten Referenzdokument `Casa_de_Padel_Kreditantrag_Kauf.docx`.

## Element-Reihenfolge (von oben nach unten)

| # | Element | Vertikaler Anteil | Stil |
|---|---|---|---|
| 1 | Logo zentriert | ~35% Seite | 1.828.800 × 2.743.200 EMU (5,1 × 7,6 cm) |
| 2 | Spacer | 5 leere Absätze | Spacing 200 nach |
| 3 | Wortmarke | "CASA DE PADEL" | Arial Bold 28pt `#1B1B1B`, zentriert, Spacing 100 nach |
| 4 | Trenner | "━━━━━━━━━━" | Arial Bold 14pt `#C62828`, zentriert, Spacing 60 nach |
| 5 | Subtitle | z.B. "Bankdossier & Detailanalysen" | Arial 18pt `#C62828`, zentriert, Spacing 400 nach |
| 6 | Beschreibung | ein Satz, präzise | Arial 12pt `#555555`, zentriert, Spacing 100 nach |
| 7 | Spacer | 4 leere Absätze | |
| 8 | Datum | "Erstellt: März 2026" | Arial 11pt `#777777`, zentriert, Spacing 80 nach |
| 9 | Gesellschafter | "Gesellschafter: ..." | Arial 11pt `#777777`, zentriert, Spacing 80 nach |
| 10 | Rechtsform | "Rechtsform: GmbH (in Gründung)" | Arial 11pt `#777777`, zentriert |
| 11 | Spacer | 2 leere Absätze | |
| 12 | Vertraulich-Notice | "VERTRAULICH — NUR FÜR DEN INTERNEN GEBRAUCH" | Arial Bold 9pt `#C62828`, zentriert |
| 13 | Disclaimer | langer Italic-Satz | Arial Italic 8pt `#999999`, zentriert |
| 14 | Page Break | | |

## DOCX-XML-Pattern (zur Orientierung)

```xml
<!-- Logo -->
<w:p>
  <w:pPr><w:spacing w:before="200" w:after="200"/><w:jc w:val="center"/></w:pPr>
  <w:r><w:drawing><wp:inline ...><wp:extent cx="1828800" cy="2743200"/>...</wp:inline></w:drawing></w:r>
</w:p>

<!-- Wortmarke -->
<w:p>
  <w:pPr><w:spacing w:after="100"/><w:jc w:val="center"/></w:pPr>
  <w:r>
    <w:rPr><w:rFonts w:ascii="Arial"/><w:b/><w:color w:val="1B1B1B"/><w:sz w:val="56"/></w:rPr>
    <w:t>CASA DE PADEL</w:t>
  </w:r>
</w:p>

<!-- Trenner -->
<w:p>
  <w:pPr><w:spacing w:after="60"/><w:jc w:val="center"/></w:pPr>
  <w:r>
    <w:rPr><w:rFonts w:ascii="Arial"/><w:b/><w:color w:val="C62828"/><w:sz w:val="28"/></w:rPr>
    <w:t>━━━━━━━━━━</w:t>
  </w:r>
</w:p>

<!-- Page Break am Ende -->
<w:p><w:r><w:br w:type="page"/></w:r></w:p>
```

## Anti-Pattern (was NICHT geht)

- ❌ Logo auf farbigem Hintergrund ohne ausreichend Kontrast
- ❌ Wortmarke und Subtitle in derselben Farbe (visuell flach)
- ❌ Ohne Page Break — Inhalt überlagert Cover
- ❌ Vertraulich-Notice in normaler Body-Größe (überdeckt visuelle Hierarchie)
- ❌ Datum als ISO-Format auf Cover (zu technisch — formelle Bankdokumente erwarten "März 2026")
