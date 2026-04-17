# Dienstnehmer / ArbeitnehmerInnenveranlagung (ANV)

Für Angestellte (lohnsteuerpflichtig), die eine Einkommensteuererklärung in Form der **ArbeitnehmerInnenveranlagung (ANV)** abgeben — freiwillig (Antragsveranlagung) oder pflichtig. Hauptformular: **L1**, ergänzt durch **L1k** (Kinder), **L1i** (Auslandseinkünfte), **L1ab** (außergewöhnliche Belastungen nach Behinderung).

## Arten der ANV

| Art | Wann | Frist |
|---|---|---|
| **Antragsveranlagung** (freiwillig) | zu viel Lohnsteuer gezahlt, Werbungskosten geltend machen wollen | 5 Jahre rückwirkend (§ 41 Abs. 2 EStG) |
| **Pflichtveranlagung** | mehrere Dienstverhältnisse gleichzeitig, Nebeneinkünfte > 730 EUR, Freibetragsbescheid ausgestellt, etc. | bis 30. April / 30. Juni FinanzOnline (§ 41 Abs. 1 EStG) |
| **Antraglose Veranlagung** | BMF macht sie automatisch, wenn Steuergutschrift erkennbar und keine Sonderausgaben/Werbungskosten zu erwarten | automatisch ab Sommer des Folgejahrs |

Wenn antraglose Veranlagung ausgelöst wurde und du **mehr** absetzen kannst, kann die normale Antragsveranlagung trotzdem nachgereicht werden.

## Werbungskosten (§ 16 EStG)

> **Grundidee:** Ausgaben, die du machst, um deinen Job überhaupt ausüben zu können.
> **Pauschbetrag:** 132 EUR/Jahr automatisch ohne Nachweis. Einzelnachweise lohnen erst ab höherem Gesamtbetrag.

### Pendlerpauschale & Pendlereuro (§ 16 Abs. 1 Z 6)
Siehe konkrete Beträge in `betraege-2026.md`. Entscheidet der **Pendlerrechner** des BMF (https://pendlerrechner.bmf.gv.at/) — Ausdruck aufheben.

Voraussetzungen:
- **Kleines PP:** Entfernung Wohnung-Arbeit ≥ 20 km, öffentlicher Verkehr zumutbar.
- **Großes PP:** Entfernung ≥ 2 km, öffentlicher Verkehr unzumutbar (Zeit, keine Verbindung, Gesundheit).
- Mindestens 11 Tage pro Monat zur Arbeit (Teilzeit → aliquot).

Eingabe in L1:
- Kleines PP: Kennzahl **718**
- Großes PP: Kennzahl **718** (mit Haken "großes PP")
- Pendlereuro: automatisch vom Finanzamt berechnet, aber Kennzahl prüfen

Fallstricke: Wenn Arbeitgeber schon via Lohnverrechnung berücksichtigt hat, nicht nochmal eintragen. Im Jahreslohnzettel (L16) unter "Sonstige Bezüge".

### Homeoffice-Pauschale (§ 16 Abs. 1 Z 7a)

- 3 EUR/Homeoffice-Tag, max. 100 Tage/Jahr → bis 300 EUR/Jahr (siehe `betraege-2026.md`).
- **Wichtig:** Wenn der Arbeitgeber weniger als 3 EUR zahlt, ist die Differenz als Werbungskosten absetzbar.
- Arbeitgeber meldet Homeoffice-Tage via Lohnzettel (L16, Kennzahl 225).
- **Nicht zu verwechseln mit Arbeitszimmer** (siehe unten).

Eingabe in L1: Kennzahl **158** (Differenz Homeoffice-Pauschale)

### Arbeitszimmer im Wohnungsverband

Sehr streng! Nur wenn:
- Arbeitszimmer **ausschließlich beruflich** genutzt,
- **Mittelpunkt** der gesamten beruflichen Tätigkeit,
- **eigener Raum**, kein Arbeitseck im Wohnzimmer.

Absetzbar: anteilige Miete/AfA, Strom, Heizung. Ohne diese drei Kriterien: **nicht** absetzbar.

Praktisch: Für die meisten Angestellten scheitert das am "Mittelpunkt"-Kriterium, weil sie auch ins Büro müssen. Dann bleibt Homeoffice-Pauschale + digitale Arbeitsmittel.

### Arbeitsmittel & digitale Geräte (§ 16 Abs. 1 Z 7)

- Laptop, Smartphone, Bildschirm, Tastatur, Headset, ergonomischer Stuhl → **anteilig** absetzbar (40 % Privatanteil üblich, außer bei dokumentiert reiner Berufsnutzung).
- Anschaffungen > 1.000 EUR netto (Stand 2024, live prüfen): über Nutzungsdauer verteilt (AfA, meist 3 Jahre für IT).
- Unter 1.000 EUR: Sofortabzug (geringwertige Wirtschaftsgüter, § 13 EStG).
- Digitale Arbeitsmittel (§ 16 Abs. 1 Z 7a): Computer, Drucker, Internet **zusätzlich** bis 300 EUR ohne Privatanteilsabzug, wenn im Homeoffice genutzt.

### Fortbildung, Ausbildung, Umschulung (§ 16 Abs. 1 Z 10)

- **Fortbildung:** verbessert aktuelle Tätigkeit → voll abzugsfähig (Kursgebühren, Bücher, Fahrtkosten, Nächtigung).
- **Ausbildung:** für neuen Beruf → nur abzugsfähig, wenn konkret darauf ausgerichtet.
- **Umschulung:** umfassende, auf Berufswechsel zielende Bildung → voll abzugsfähig.

Beispiele: Zertifikatskurs, Seminar, Weiterbildungs-MBA, Sprachkurs wenn beruflich notwendig.

### Fachliteratur (§ 16 Abs. 1 Z 7)

Nur wirklich berufsspezifische Werke. Keine allgemeine Tagespresse, keine Belletristik. Branchenzeitschriften, Fachbücher, O'Reilly-Lernplattform-Abos etc.

### Gewerkschaftsbeiträge, Betriebsratsumlage (§ 16 Abs. 1 Z 3)

Meist schon vom Arbeitgeber abgezogen. Falls nicht: absetzbar. Kennzahl **717**.

### Reisekosten (§ 16 Abs. 1 Z 9)

- Fahrtkosten (Km-Geld, Öffi-Tickets) nicht durch Arbeitgeber ersetzt → absetzbar.
- Tagesdiäten bis 26,40 EUR/Tag (Inland), wenn mehr als 25 km von Dienstort weg.
- Nächtigungsgeld 15 EUR pauschal oder tatsächliche Hotelkosten.

### Doppelte Haushaltsführung & Familienheimfahrten (§ 16 Abs. 1 Z 6)

Wenn Arbeitsort so weit vom Familienwohnsitz, dass tägliche Heimfahrt unzumutbar:
- Miete, Betriebskosten, Möblierung der Zweitwohnung (begrenzt).
- **Familienheimfahrten:** absetzbar bis zur Höhe des großen Pendlerpauschales maximal.

---

## Sonderausgaben (§ 18 EStG)

> **Grundidee:** Private Ausgaben, die der Staat aus sozialen Gründen begünstigt.

### Kirchenbeitrag (§ 18 Abs. 1 Z 5)

- Bis 600 EUR/Jahr absetzbar (`betraege-2026.md`).
- **Automatische Datenübermittlung:** Kirchen melden direkt ans Finanzamt. Du musst nichts eintragen.
- Prüfen in FinanzOnline → "Vorausgefüllte Daten".

### Spenden an begünstigte Einrichtungen (§ 18 Abs. 1 Z 7)

- Bis 10 % des Gesamtbetrags der Einkünfte absetzbar.
- Automatische Datenübermittlung — wenn Empfänger auf der BMF-Liste begünstigter Empfänger steht.
- Liste: https://www.bmf.gv.at → "Services" → "Begünstigte Empfänger / Spenden".

### Nachkauf von Versicherungszeiten (§ 18 Abs. 1 Z 1a)

- Schul- und Studienzeiten, die du pensionsrechtlich nachkaufst → voll absetzbar als Sonderausgabe.

### Steuerberatungskosten (§ 18 Abs. 1 Z 6)

- Honorar für Steuerberater voll absetzbar.
- Kennzahl **460**.

### Topf-Sonderausgaben (Altfälle)

Für Verträge **vor 2016** abgeschlossen (Versicherung, Wohnraumschaffung): noch einige Jahre begrenzt absetzbar, läuft aus.

---

## Absetzbeträge (§ 33 EStG)

> **Wichtig:** Absetzbeträge reduzieren die Steuer direkt (1 zu 1), Werbungskosten/Sonderausgaben nur das zu versteuernde Einkommen. Siehe konkrete Werte in `betraege-2026.md`.

### Familienbonus Plus (§ 33 Abs. 3a)

Für jedes Kind, für das Familienbeihilfe bezogen wird. Aufteilung:
- 100 % / 0 % (ein Elternteil voll), oder
- 50 % / 50 % (beide Elternteile je hälftig).

Eingabe in L1k, nicht L1.

### Alleinverdiener-/Alleinerzieherabsetzbetrag (§ 33 Abs. 4 Z 1, Z 2)

- Nur ein Elternteil kann den AVAB, nur ein Elternteil den AEAB.
- **Einkommensgrenze Partner:** 6.937 EUR (ohne Kinder-Berücksichtigung). Über Grenze → kein AVAB.
- Mindestens 1 Kind mit Familienbeihilfe.

### Kinderabsetzbetrag, Kindermehrbetrag, Mehrkindzuschlag

- **Kinderabsetzbetrag:** ausbezahlt mit Familienbeihilfe, nicht in L1 einzutragen.
- **Kindermehrbetrag** (§ 33 Abs. 7): für Niedrigverdiener mit Kindern, automatisch im Rahmen der Veranlagung.
- **Mehrkindzuschlag** (§ 9 FLAG): für Familien mit 3+ Kindern, separater Antrag.

### Unterhaltsabsetzbetrag (§ 33 Abs. 4 Z 3)

Wenn Kind nicht im Haushalt und gesetzlicher Unterhalt bezahlt wird. Siehe Werte in `betraege-2026.md`.

---

## Außergewöhnliche Belastungen

Siehe `aussergewoehnliche-belastungen.md` für Krankheit, Behinderung, Katastrophen, Berufsausbildung Kinder.

---

## SV-Rückerstattung / Negativsteuer (§ 33 Abs. 8)

Für Niedrigverdiener:
- Wenn Einkommensteuer = 0, werden **55 % der SV-Beiträge** als Negativsteuer ausbezahlt (max. ~500 EUR — **live prüfen**).
- Für Pendler zusätzlich Pendlerzuschlag.
- **Wird über die ANV ausgezahlt** — auch wenn keine Steuer zu zahlen ist, lohnt sich die Erklärung.

---

## Typische Fallstricke

1. **Vorausgefüllte Daten ignorieren:** FinanzOnline zeigt Kirchenbeitrag, Spenden, Pendlerpauschale oft schon vorausgefüllt. Doppelt eintragen → Finanzamt korrigiert und fragt nach.
2. **Pendlerrechner-Ergebnis nicht aufheben:** Bei Rückfrage vom Finanzamt gibt es keinen Nachweis → PP kann gestrichen werden.
3. **Homeoffice-Tage nicht vom Arbeitgeber gemeldet:** Lohnzettel prüfen (L16, Kennzahl 225). Bei Fehler: Arbeitgeber anschreiben, nicht selbst einfach eintragen.
4. **Kein Beleg = kein Abzug:** Jede Werbungskosten-Position braucht einen Beleg, den du 7 Jahre aufbewahren musst (§ 132 BAO). Digitale Kopien zählen.
5. **"Kurse" ohne Berufsbezug:** Yogalehrer-Ausbildung ist nur absetzbar, wenn du Yogalehrer*in wirst oder in deinem Beruf brauchst.
6. **Familienbonus-Fehler:** Aufteilung zwischen Partnern muss übereinstimmen — wenn ein Elternteil 100 % nimmt, darf der andere 0 % eintragen. Falsch: beide je 50 % und zusätzlich 50 %.

---

## Antwort-Muster für typische Fragen

### "Welches Pendlerpauschale steht mir zu?"
1. Frage: Wie weit (km) ist die einfache Strecke? Ist öffentlicher Verkehr zumutbar (Fahrzeit, Umstiege)?
2. Verweise auf `betraege-2026.md` (mit Live-Verifikation) und den Pendlerrechner.
3. Nenne Kennzahl 718 in L1.
4. Hinweis: Arbeitgeber-Berücksichtigung prüfen, damit nicht doppelt eingetragen wird.

### "Kann ich mein neues Handy absetzen?"
1. Beruflich genutzt? Wie hoch ist der berufliche Anteil?
2. Unter 1.000 EUR netto → sofort absetzbar (geringwertiges WG, § 13 EStG).
3. Privatanteil abziehen (oft 40 %, individuell begründbar).
4. Wenn im Homeoffice genutzt: zusätzlich § 16 Abs. 1 Z 7a beachten.

### "Ich hab einen Kurs gemacht, kann ich den absetzen?"
1. Ist der Kurs für aktuellen Beruf (Fortbildung) oder Berufswechsel (Umschulung)?
2. Bei Fortbildung: voll absetzbar inkl. Fahrt, Nächtigung, Material.
3. Bei Hobbykurs ohne Berufsbezug: nicht absetzbar.
4. Rechnung + Teilnahmebestätigung aufheben.
