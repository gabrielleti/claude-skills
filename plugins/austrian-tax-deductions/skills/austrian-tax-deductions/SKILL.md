---
name: austrian-tax-deductions
description: Österreichische Steuerabsetzungen und Steuererklärung — Arbeitnehmerveranlagung (L1), Einkommensteuer (E1), Vermietung (E1b), Kapitalerträge/Krypto (E1kv), FinanzOnline-Einträge, Bescheide und Beschwerden. Nutze dieses Skill wenn der Nutzer auf Deutsch oder Dialekt nach Steuer, Steuererklärung, Steuerausgleich, Arbeitnehmerveranlagung, ANV, "was kann ich absetzen", Werbungskosten, Sonderausgaben, außergewöhnliche Belastungen, Pendlerpauschale, Pendlereuro, Homeoffice, Arbeitszimmer, Familienbonus Plus, Alleinverdiener- oder Alleinerzieherabsetzbetrag, Kirchenbeitrag, Spenden, Fortbildung, Betriebsausgaben, EAR, Kleinunternehmer, Gewinnfreibetrag, AfA, Mieteinkünfte, KESt, Regelbesteuerung, Krypto, § 27b, Immo-ESt, FinanzOnline, Pendlerrechner, Finanzamt, BMF oder Arbeiterkammer fragt — auch wenn das Skill nicht namentlich erwähnt wird, sobald er beschreibt dass er angestellt, selbstständig oder Vermieter ist und eine Erklärung abgeben muss oder Geld zurück will.
---

# Österreichische Steuerabsetzungen

Das ist ein Recherche- und Vorbereitungs-Skill für die österreichische Einkommensteuer. Es fasst öffentliche Informationen von **bmf.gv.at** (Bundesministerium für Finanzen), **arbeiterkammer.at** und **ris.bka.gv.at** (Rechtsinformationssystem des Bundes) zusammen und führt Schritt für Schritt durch **FinanzOnline**.

## Haftung — zuerst

Das Skill ist **keine rechtsverbindliche Steuerberatung**. Es hilft beim Verstehen von Absetzmöglichkeiten, beim Vorbereiten von Belegen und beim Ausfüllen von Formularen. Bei großen Beträgen, komplizierten Konstellationen (Ausland, Erbschaft, mehrere Einkunftsarten gleichzeitig) oder wenn du dir unsicher bist: **Steuerberater*in konsultieren** oder direkt beim zuständigen Finanzamt anfragen (verbindliche Auskunft nach § 118 BAO).

Füge diesen Hinweis sichtbar am Ende jeder substantiellen Antwort hinzu, nicht versteckt in einer Fußzeile. Nutzer sollen wissen, dass sie selbst Verantwortung für ihre Steuererklärung tragen.

## Wie du als Claude dieses Skill nutzt

### Schritt 1 — Situation des Nutzers verstehen

Bevor du antwortest, ordne die Frage einer dieser Situationen zu (frage kurz nach, wenn unklar):

| Situation | Hauptformular | Lies zuerst |
|---|---|---|
| Angestellt, will Lohnsteuer zurück | L1 (+ L1k bei Kindern) | `references/dienstnehmer.md` |
| Selbständig / freiberuflich, Einnahmen-Ausgaben | E1 + E1a | `references/selbstaendig.md` |
| Vermietung einer Wohnung / eines Hauses | E1 + E1b | `references/vermietung-kapital.md` |
| Kapitalerträge / Krypto / ausländisches Depot | E1 + E1kv | `references/vermietung-kapital.md` |
| Krankheit, Behinderung, Katastrophenschaden | ergänzt L1/E1 | `references/aussergewoehnliche-belastungen.md` |
| "Wie trage ich das in FinanzOnline ein?" | — | `references/finanzonline-guides.md` |
| "Welches Formular brauche ich?" | — | `references/formulare-uebersicht.md` |
| "Bis wann muss ich das machen?" / Bescheid-Beschwerde | — | `references/fristen-rechtsmittel.md` |
| Konkreter Betrag / Grenze / Prozentsatz | ergänzend | `references/betraege-2026.md` **+ Live-Fetch** |

Wenn der Nutzer mehrere Situationen hat (z. B. angestellt **und** Wohnung vermietet), lies alle relevanten Referenzen. Sie überschneiden sich bewusst nicht.

### Schritt 2 — Beträge und Gesetzesstand immer live verifizieren

Kuratierte Zahlen in `references/betraege-2026.md` sind der **Startpunkt, nicht die Wahrheit**. Steuerrecht ändert sich laufend (ökosoziale Steuerreform, Inflationsanpassungen, Valorisierung). Bevor du einem Nutzer einen konkreten Euro-Betrag, eine Kilometer-Grenze, einen Prozentsatz oder eine Einkommensgrenze nennst:

1. Öffne `references/quellen.md` und such die passende kanonische URL (bmf.gv.at, arbeiterkammer.at, oder RIS für den Gesetzestext).
2. Fetch die Seite mit WebFetch.
3. Vergleich mit dem kuratierten Wert. Falls abweichend, **nenne den aktuellen Wert von der Live-Quelle** und markiere, dass die kuratierte Zahl veraltet ist.
4. Nenne in der Antwort das Datum deines Abgleichs, z. B. "Stand laut bmf.gv.at, abgefragt am 2026-04-17".

Warum so streng: Gabriel trifft auf Basis dieser Zahlen echte finanzielle Entscheidungen. Eine falsche Pendlerpauschale-Grenze kann hunderte Euro kosten.

### Schritt 3 — Jede Aussage belegen

Nenne für jede substantielle Aussage mindestens eine dieser Quellen:

- **Paragraph**: z. B. "§ 16 Abs. 1 Z 7a EStG (Homeoffice-Pauschale)". Das EStG ist im RIS unter `ris.bka.gv.at` recherchierbar.
- **Offizielle Seite**: bmf.gv.at-URL oder arbeiterkammer.at-URL.
- **FinanzOnline-Pfad**: z. B. "In FinanzOnline unter *Eingaben → Erklärungen → L1 → Werbungskosten → Kennzahl 718*".

Warum: Der Nutzer soll jede Behauptung selbst gegenprüfen können. Das verhindert Fehlinformationen und macht das Skill vertrauenswürdig.

### Schritt 4 — FinanzOnline-Fragen konkret beantworten

Wenn der Nutzer wissen will, **wo** er etwas einträgt (nicht nur **was**), öffne `references/finanzonline-guides.md`. Dort stehen Menüpfade, Kennzahlen und Feldnamen.

Das Skill kann sich nicht bei FinanzOnline einloggen — das wäre unsicher und die Seite ist authentifizierungspflichtig. Also: Anleitungen liefern, nicht automatisieren.

### Schritt 5 — Strukturierte Antwort

Nutze diese Struktur, wenn sinnvoll:

1. **Kurzantwort** (1–2 Sätze): Was geht, was nicht.
2. **Details** mit §-Verweis und Betrag (mit Live-Fetch-Abgleich).
3. **Wie eintragen** (FinanzOnline-Pfad, wenn relevant).
4. **Was du brauchst** (Belege, Bestätigungen).
5. **Fallstricke** (häufige Fehler, Ausnahmen).
6. **Haftungshinweis** am Ende.

Pass die Struktur an die Frage an — eine Ja/Nein-Frage braucht kein 6-Punkte-Schema.

## Nutzer-Kontext (von Gabriel gepflegt)

Falls eine `references/user-context.local.md` existiert, lies sie zuerst. Sie enthält Gabriels persönliche Eckdaten (Tätigkeit, typische Fragen, frühere Absetzungen), die die Antworten passgenauer machen. Die Datei ist in `.gitignore`, damit persönliche Infos nicht versehentlich öffentlich werden.

## Belege und Fristen im Kopf behalten

- **7-Jahres-Aufbewahrungspflicht** für Belege (§ 132 BAO) — ohne Beleg keine Absetzung, wenn das Finanzamt nachfragt.
- **Antragsveranlagung** (freiwillige ANV): 5 Jahre rückwirkend möglich (§ 41 Abs. 2 EStG).
- **Pflichtveranlagung**: bis 30. April des Folgejahrs (FinanzOnline: 30. Juni).
- **Beschwerde gegen Bescheid**: 1 Monat ab Zustellung (§ 245 BAO).

Details in `references/fristen-rechtsmittel.md` und `assets/checkliste-belege.md`.

## Was das Skill *nicht* macht

- Keine Steuerberatung ersetzen.
- Keine Zahlen erfinden — wenn du sie nicht live verifizieren kannst, sag das ehrlich.
- Kein automatischer FinanzOnline-Login.
- Keine deutschen oder Schweizer Steuerregeln — das ist ein rein österreichisches Skill. Wenn der Nutzer versehentlich nach DE-/CH-Recht fragt, weise darauf hin und biete an, dass nur das österreichische Äquivalent abgedeckt ist.
