# FinanzOnline-Walkthroughs

Schritt-für-Schritt-Anleitungen für die häufigsten Eingaben in FinanzOnline (https://finanzonline.bmf.gv.at).

> **Hinweis an Claude:** Das Skill kann sich **nicht** bei FinanzOnline einloggen oder automatisch Daten eintragen. Gib dem Nutzer Menüpfade und Kennzahlen, damit er es selbst machen kann.

## Grundorientierung

### Einstieg
1. Öffne https://finanzonline.bmf.gv.at
2. Login:
   - **ID Austria** (ehemals Handy-Signatur) — empfohlen
   - **Teilnehmer-, Benutzer-, PIN-Identifikation**
3. Nach Login auf Startseite: Kacheln zeigen offene ToDos, Bescheide, Mitteilungen.

### Erklärung starten
Menüpfad: **"Eingaben" → "Erklärungen"** → Jahr wählen → passendes Formular (L1, E1, …).

### Vorausgefüllte Daten
Vor dem Start der Erklärung: **"Eingaben" → "Vorausgefüllte Erklärung"** öffnen. Dort siehst du, was das Finanzamt schon weiß:
- Lohnzettel (L16) deines Arbeitgebers
- Gemeldete Sonderausgaben (Kirchenbeitrag, Spenden)
- Pendlerpauschale, falls vom Arbeitgeber berücksichtigt

**Wichtig:** Was vorausgefüllt ist, **nicht** nochmal in L1 eintragen, sonst Doppelerfassung.

---

## Guide 1 — ArbeitnehmerInnenveranlagung (L1) grundlegend

**Ziel:** Lohnsteuer-Rückerstattung beantragen, Werbungskosten & Sonderausgaben angeben.

**Voraussetzungen:**
- Lohnzettel liegt vor (vom Arbeitgeber, Kennzahlen am Jahreslohnzettel L16).
- Belege für alle Absetzungen gesammelt (7 Jahre aufbewahren).

**Schritte:**
1. **"Eingaben" → "Erklärungen" → Jahr wählen → "Erklärung zur ArbeitnehmerInnenveranlagung L1"**
2. **Persönliche Daten** prüfen: Anschrift, Bankverbindung (für Erstattung wichtig!), Familienstand.
3. **Bezugs- / Pensionsauszahlende Stelle(n)**: wird aus Lohnzettel vorausgefüllt. Wenn mehrere Arbeitgeber → alle müssen aufscheinen.
4. **Werbungskosten** (Seite "Werbungskosten"):
   - Pendlerpauschale → Kennzahl **718**, Pendlereuro → Kennzahl **916**
   - Gewerkschaftsbeitrag → **717** (falls nicht schon vom AG abgezogen)
   - Arbeitsmittel → **719**
   - Fachliteratur → **720**
   - Reisekosten → **721**
   - Aus- und Fortbildung, Umschulung → **722**
   - Sonstige Werbungskosten → **724**
   - Homeoffice-Differenzbetrag → **158**
5. **Sonderausgaben** (Seite "Sonderausgaben"):
   - Kirchenbeitrag → **458** (Achtung: meist vorausgefüllt!)
   - Steuerberatungskosten → **460**
   - Spenden → **465** (meist vorausgefüllt)
   - Nachkauf Versicherungszeiten → **450**
6. **Außergewöhnliche Belastungen**: getrennter Punkt, bei Krankheit, Behinderung etc.
7. **Kinder**: separates Formular **L1k** für jedes Kind → dort Familienbonus Plus eintragen, ggf. AVAB/AEAB.
8. **Erklärung abschicken**: "Daten absenden" → Bestätigung mit Eingangsnummer aufheben.
9. **Bescheid** kommt meist nach 4-8 Wochen per FinanzOnline-Nachricht (Papier nur auf Antrag).

**Häufige Fehler:**
- Bankverbindung falsch → Erstattung bleibt liegen.
- Lohnzettel noch nicht gemeldet → Erklärung nicht möglich, warten bis Februar/März des Folgejahrs.
- Beträge aus Vorjahr kopiert → Finanzamt korrigiert.

**Quelle:** https://www.bmf.gv.at/themen/steuern/arbeitnehmerveranlagung.html

---

## Guide 2 — Pendlerpauschale beantragen

**Ziel:** Kleines oder großes Pendlerpauschale + Pendlereuro geltend machen.

**Voraussetzungen:**
- **Ergebnis des Pendlerrechners** (https://pendlerrechner.bmf.gv.at/) als PDF — muss 7 Jahre aufbewahrt werden!
- Arbeitsverhältnis, bei dem du mindestens 11 Tage/Monat zur Arbeit fährst.

**Schritte:**
1. Pendlerrechner füllen:
   - Wohnadresse und Arbeitsadresse eingeben
   - Durchschnittliche Arbeitstage pro Monat
   - Arbeitsbeginn und -ende (für Zumutbarkeit öffentlicher Verkehr)
   - Rechner generiert Formular **L 34 EDV** mit Ergebnis.
2. L 34 EDV-Ergebnis an Arbeitgeber geben, **wenn** er das PP bereits via Lohnverrechnung berücksichtigen soll. Alternative: erst bei ANV geltend machen.
3. In FinanzOnline (wenn via ANV): **L1 → Werbungskosten → Kennzahl 718** → Jahresbetrag eintragen (siehe `betraege-2026.md`) → Haken bei "großes PP" setzen, wenn zutreffend.
4. **Pendlereuro**: wird vom Finanzamt automatisch berechnet (6 EUR pro km einfacher Entfernung × 2 Fahrten/Tag × Arbeitstage), aber Kennzahl **916** prüfen.

**Häufige Fehler:**
- PP trotz Dienst-KfZ / Werkbus / Jobticket mit 100 % Kostenübernahme beantragen → nicht möglich.
- Arbeitgeber hat PP bereits berücksichtigt, du trägst es trotzdem in L1 ein → Doppelerfassung, Finanzamt kürzt.
- Teilzeit mit < 11 Tagen/Monat zur Arbeit → aliquote Kürzung (2/3 ab 8 Tagen, 1/3 ab 4 Tagen — live prüfen).

**Quellen:**
- Pendlerrechner: https://pendlerrechner.bmf.gv.at/
- AK-Anleitung: https://www.arbeiterkammer.at/beratung/steuerundeinkommen/pendler/Pendlerpauschale.html

---

## Guide 3 — Homeoffice-Pauschale geltend machen

**Ziel:** Differenz zwischen tatsächlichem Homeoffice-Zuschuss des Arbeitgebers und 3 EUR/Tag absetzen.

**Voraussetzungen:**
- Arbeitgeber hat Homeoffice-Tage am Lohnzettel (L16, Kennzahl 225) gemeldet. Wenn nicht: Arbeitgeber um Korrektur bitten — du kannst das nicht einfach selbst schätzen.

**Schritte:**
1. Lohnzettel L16 prüfen: Kennzahl **225** (Anzahl Homeoffice-Tage), Kennzahl **226** (vom Arbeitgeber steuerfrei ausgezahlter Homeoffice-Zuschuss).
2. Rechnen: Anspruch = Homeoffice-Tage × 3 EUR (max. 100 Tage/Jahr × 3 = 300 EUR).
3. Differenz = Anspruch − vom Arbeitgeber bezahlter Betrag.
4. **L1 → Werbungskosten → Kennzahl 158** → Differenz eintragen.
5. Zusätzlich: Digitale Arbeitsmittel (Laptop, Monitor, Internet — anteilig Homeoffice) bis 300 EUR **ohne** Privatanteil-Abzug ansetzen.

**Häufige Fehler:**
- Homeoffice-Tage vom Arbeitgeber nicht gemeldet → Pauschale kann nicht geltend gemacht werden. Betriebsvereinbarung prüfen.
- Homeoffice-Pauschale und Arbeitszimmer-Kosten **gleichzeitig** absetzen wollen → geht nicht (ausgenommen wenn beide Kriterien sauber getrennt nachgewiesen).

**Quelle:** https://www.bmf.gv.at/themen/steuern/arbeitnehmerveranlagung.html (Suche "Homeoffice")

---

## Guide 4 — Familienbonus Plus aufteilen (L1k)

**Ziel:** Familienbonus Plus für jedes Kind geltend machen und Aufteilung mit Partner korrekt festlegen.

**Voraussetzungen:**
- Anspruch auf Familienbeihilfe (nicht verwechseln mit Kinderbetreuungsgeld).
- Wenn beide Elternteile arbeiten: Absprache, wer welchen Anteil nimmt.

**Schritte:**
1. In L1 am Anfang angeben: Anzahl Kinder, für die Familienbonus beantragt wird.
2. Pro Kind ein **L1k** ausfüllen (separates Formular aufrufen).
3. Im L1k:
   - Name, Geburtsdatum, Sozialversicherungsnummer des Kindes
   - Bezugsmonate (wie viele Monate des Jahres hat das Kind die Familienbeihilfe erhalten)
   - Aufteilung Familienbonus: **100 %** (selber alles nehmen) oder **50 %** (teilen).
4. **Partner muss exakt den Rest** in seinem L1/L1k ankreuzen.

**Häufige Fehler:**
- Beide nehmen 100 % → Finanzamt korrigiert, einer muss nachbessern.
- Kind ab 18: nur wenn weiter Familienbeihilfe bezogen wird (Studium, Berufsausbildung).
- Kind im Ausland: Aufteilungsprozentsatz nach Familienbeihilfe-Anspruch — kompliziert, bei Steuerberater nachfragen.

**Quelle:** https://www.bmf.gv.at/themen/steuern/arbeitnehmerveranlagung.html (Familienbonus Plus-FAQ)

---

## Guide 5 — Freibetragsbescheid nutzen

**Ziel:** Werbungskosten/Sonderausgaben bereits während des Jahres bei der Lohnsteuer berücksichtigen lassen, statt erst im Nachhinein zu beantragen.

**So funktioniert's:**
1. Beim Finanzamt Freibetragsbescheid beantragen (entweder nach ANV des Vorjahres automatisch erstellt, oder via Formular **L 1 F**).
2. Freibetragsbescheid kommt als PDF via FinanzOnline.
3. An Arbeitgeber übergeben — er zieht den Freibetrag bei der monatlichen Lohnverrechnung ab.

**Vorteil:** Mehr Netto während des Jahres statt einmaliger Steuerrückzahlung.
**Nachteil:** Pflichtveranlagung zwingend, weil Freibetrag vorher abgezogen wurde.

**Schritte in FinanzOnline:**
- **"Eingaben" → "Anträge" → "Freibetragsbescheid"**
- Werbungskosten, Sonderausgaben, außergewöhnliche Belastungen angeben (wie in L1).
- Absenden → Bescheid kommt in ~ 2 Wochen.

---

## Guide 6 — Beschwerde gegen Bescheid

**Ziel:** Einem Bescheid widersprechen (§ 243 BAO), z. B. wenn eine Absetzung gestrichen wurde.

**Frist:** **1 Monat ab Zustellung** des Bescheids.

**Schritte:**
1. **"Eingaben" → "Anträge" → "Bescheidbeschwerde"**
2. Bescheid-Datum und Aktenzeichen auswählen (wird meist vorausgefüllt).
3. **Begründung** schreiben: was strittig, warum deine Position richtig ist, welche Belege du beilegst.
4. Belege als PDF hochladen.
5. **Antrag auf Aussetzung der Einhebung** (§ 212a BAO) stellen, wenn strittiger Steuerbetrag bereits fällig wäre.
6. Absenden → Finanzamt entscheidet erneut (Berufungsvorentscheidung) oder leitet an BFG weiter.

**Fallstrick:** Frist läuft ab Zustellung der FinanzOnline-Nachricht (nicht ab Lesen!). Benachrichtigungs-E-Mails aktivieren, damit du keine Frist versäumst.

---

## Guide 7 — Einkommensteuererklärung E1 (Selbständige)

Siehe `selbstaendig.md` für inhaltliche Details. In FinanzOnline:
- **"Eingaben" → "Erklärungen" → "Einkommensteuererklärung E1"**
- Bei Einnahmen-Ausgaben-Rechnung zusätzlich Beilage **E1a**.
- Bei Einkünften aus V&V: Beilage **E1b**.
- Bei Kapitaleinkünften: Beilage **E1kv**.
- Frist: 30. April / 30. Juni via FinanzOnline. Mit Vertretung durch Steuerberater: 30. April 2 Jahre später (Quotenvereinbarung).

---

## Guide 8 — Selbstanzeige (§ 29 FinStrG)

**Wenn du bemerkst, dass du etwas falsch oder nicht angegeben hast:**

1. **Sofort** Selbstanzeige via FinanzOnline: **"Eingaben" → "Anträge" → "Sonstige Anbringen" → "Selbstanzeige"**.
2. Sachverhalt offenlegen: was, wann, wie viel.
3. **Nachzahlung** innerhalb Monatsfrist leisten.

Vorteil: Strafbefreiung, wenn **freiwillig** und **rechtzeitig** (vor Entdeckung durch Behörde). Bei größeren Beträgen oder Unsicherheit: **Steuerberater einschalten**, bevor du einreichst.

---

## Wann Claude *nicht* selbst antwortet, sondern weiterleitet

Wenn der Nutzer fragt nach:

- **Konkretem Login-Problem** (Zertifikat abgelaufen, Passwort vergessen) → verweise auf FinanzOnline-Support oder Finanzamt-Hotline.
- **Persönlicher Steuerberechnung mit echten Beträgen** → erkläre die Methodik, lass den Nutzer mit dem AK-Brutto-Netto-Rechner oder einem Steuerberater durchrechnen.
- **Rechtsauslegung in Streitfall** → Beschwerde-Muster erklären, aber auf Steuerberatung verweisen.
