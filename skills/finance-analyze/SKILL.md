---
name: finance-analyze
description: Vollständige Finanzanalyse für deutsche Angestellte — erstellt einen 6-Kategorien-Finanzbericht mit RAG-Status und Top-3-Maßnahmen. Aktivieren bei "/finance analyze", "Finanzanalyse", "finanzielle Gesundheitsprüfung", "Analysiere meine Finanzen", "Wie stehe ich finanziell da?", "full financial analysis", "financial health check", or any request for a complete financial picture for a German Angestellter.
---

# Finance Analyze — Vollständige Finanzanalyse für Angestellte

**DISCLAIMER: Nur zu Informations- und Bildungszwecken. Keine Anlageberatung, keine Steuerberatung, keine Versicherungsberatung im Sinne des VVG. Alle Empfehlungen sind allgemeiner Natur. Konsultiere einen zugelassenen Finanzberater, Steuerberater oder unabhängigen Versicherungsmakler, bevor du Entscheidungen triffst.**

## When to Run

Trigger this skill when the user says:
- `/finance analyze`
- "Finanzanalyse" / "Analysiere meine Finanzen"
- "Finanzielle Gesundheitsprüfung" / "Wie stehe ich finanziell da?"
- "Full financial analysis" / "Financial health check"
- Any request for a complete financial picture from a German Angestellter

## Data Collection

Before analysis, collect the user's complete financial profile. Ask in structured blocks. If data is incomplete, use reasonable defaults and flag them clearly in the output.

**Block 1 — Einkommensprofil**
1. Jahresbruttolohn (€) — inklusive Sonderzahlungen (13. Gehalt, Bonus)?
2. Geschätztes monatliches Nettoeinkommen (€) — oder soll es anhand Steuerklasse und SV-Beiträgen geschätzt werden?
3. Steuerklasse (I, II, III, IV, IV+Faktor, V oder VI)
4. Weitere Einkommensquellen (Mieteinnahmen, Nebenjob, Kapitalerträge)?

**Block 2 — Krankenversicherung & Sozialversicherung**
5. GKV oder PKV?
   - GKV: Welche Kasse? Monatlicher AN-Anteil (€)?
   - PKV: Monatlicher Beitrag (€)? Krankentagegeld versichert?

**Block 3 — Altersvorsorge**
6. bAV (betriebliche Altersvorsorge): vorhanden? (ja/nein)
   - Falls ja: monatlicher Eigenbeitrag via Entgeltumwandlung (€)? Arbeitgeberzuschuss (%)?
7. Riester-Rente: vorhanden? (ja/nein)
   - Falls ja: Jahreseigenbeitrag (€)? Kinderzulage-berechtigt? (Anzahl Kinder)
8. ETF-Depot / Investmentdepot: vorhanden? (ja/nein)
   - Falls ja: aktueller Depotwert (€)? Monatlicher Sparplan (€)?

**Block 4 — Liquidität & Vermögen**
9. Tagesgeld-/Festgeldguthaben (€)
10. Girokonto-Guthaben (€)
11. Sonstige liquide Vermögenswerte (€)
12. Immobilieneigentum: ja/nein? Falls ja: Schätzwert (€)?

**Block 5 — Schulden**
13. Dispositionskredit: in Anspruch genommen? Restbetrag (€)? Zinssatz (%)?
14. Ratenkredit(e): Restschuld (€)? Monatliche Rate (€)? Zinssatz (Effektivzins %)?
15. Baufinanzierung: Restschuld (€)? Monatliche Rate (€)? Sollzins (%)? Zinsbindungsende (Jahr)?

**Block 6 — Monatliche Ausgaben**
16. Monatliche feste Ausgaben gesamt (€): Miete/Hausgeld, Versicherungen, Abonnements, Darlehensraten
17. Monatliche variable Ausgaben (€): Lebensmittel, Transport, Freizeit, Sonstiges
18. Monatliche Sparrate gesamt (€): alles außer Konsum (bAV, Riester, Sparplan, Tagesgeld-Einzahlungen)

**Block 7 — Versicherungsschutz**
19. Haftpflichtversicherung: vorhanden? (ja/nein)
20. Berufsunfähigkeitsversicherung (BU): vorhanden? (ja/nein)
    - Falls ja: monatliche BU-Rente (€)? Karenzzeit? Laufzeit bis?
21. Risikolebensversicherung: vorhanden? (ja/nein)
    - Falls ja: Versicherungssumme (€)? Laufzeit bis?
22. Hausratversicherung: vorhanden? (ja/nein)

**Block 8 — Ziele**
23. Kurzfristige Ziele (< 2 Jahre): z.B. Urlaub, Anschaffung
24. Mittelfristige Ziele (2–10 Jahre): z.B. Immobilienkauf, Elternzeit, Weiterbildung
25. Langfristige Ziele (> 10 Jahre): Rentenzieldatum, gewünschtes monatliches Renteneinkommen (€)?

## Analysis Framework

> **Before analysis, read `.claude/skills/shared/german-context.md` for 2026 German financial constants.**

Use the six sections below. For each, assign a RAG status:
- 🔴 Kritisch — sofortiger Handlungsbedarf
- 🟡 Optimierungsbedarf — Maßnahmen sinnvoll
- 🟢 Gut aufgestellt — kein dringender Bedarf

---

### 1. Liquidität & Notgroschen

**Ziel-Notgroschen:** 3–6 Monatsausgaben in Tagesgeld (aktuelle Referenzrendite: ~3–3.5% p.a. bei DKB, ING, Trade Republic).

**Bewertung:**
- Berechne monatliche Gesamtausgaben (fest + variabel)
- Berechne aktuellen Notgroschen in Monaten: Tagesgeld (€) ÷ Monatsausgaben
- Vergleiche mit Ziel:
  - Angestellter, stabiles Einkommen, keine Unterhaltspflichten → 3 Monate ausreichend
  - Angestellter mit Unterhaltspflichten / variabler Vergütung → 4–5 Monate
  - Beamte → 2–3 Monate ausreichend
- RAG-Logik:
  - 🔴 < 2 Monate abgedeckt
  - 🟡 2 Monate abgedeckt, aber unter Ziel
  - 🟢 Ziel erreicht oder übertroffen
- Flag: Festgeld über dem Notgroschen-Betrag → positiv (höhere Rendite); Girokonto-Überschuss > 2 Monatsausgaben → Opportunitätskosten (Umschichten in Tagesgeld empfehlen)

---

### 2. Schuldenanalyse

**Schuldendienstquote:** (Summe monatlicher Schuldenraten) ÷ Nettoeinkommen; Ziel: < 30%.

**Prioritätsreihenfolge:**
1. Dispositionskredit (Dispo): höchster Zinssatz (8–14% p.a.) → sofortige Tilgung Priorität
2. Ratenkredit: je nach Effektivzins (3–8% p.a.) → nach Dispo tilgen
3. Baufinanzierung: in der Regel niedrigster Zinssatz → Mindestraten beibehalten, Sondertilgungsrecht (5–10% p.a.) nutzen sofern Zinssatz > Tagesgeldrendite

**Bewertung:**
- Berechne Schuldendienstquote
- Flag Dispo-Inanspruchnahme > 1 Monat → 🔴 dringend (Zinssatz entspricht oft 10–12% p.a.)
- RAG-Logik:
  - 🔴 Schuldendienstquote ≥ 40% oder Dispo dauerhaft in Anspruch genommen
  - 🟡 Schuldendienstquote 30–40% oder Dispo gelegentlich genutzt
  - 🟢 Schuldendienstquote < 30%, kein Dispo-Saldo

---

### 3. Altersvorsorge-Lücke (Rentenlücke)

**Schritt 1 — Geschätzte GRV-Rente:**
- Entgeltpunkte (EP) pro Jahr = Jahresbruttolohn ÷ Durchschnittsentgelt (2026-Referenzwert aus german-context.md)
- Annahme: Renteneintritt mit 67; bisherige Beitragsjahre abschätzen anhand Alter und Berufseinstieg
- Geschätzte monatliche GRV-Rente = angesammelte EP × €39.32 (Aktueller Rentenwert West 2026)

**Schritt 2 — Ergänzende Bausteine:**
- bAV vorhanden: geschätzte monatliche Zusatzrente aus Einzahlungssumme (Faustregel: kann der Nutzer aus Renteninformation ableiten)
- Riester vorhanden: geschätzte monatliche Zusatzrente
- ETF-Depot: erwartetes Vermögen bei Renteneintritt (7% nominale p.a. Annahme) → nachhaltiger Entnahmebetrag (3.5% Regel)

**Schritt 3 — Rentenlücke:**
- Rentenlücke = gewünschtes monatliches Renteneinkommen − (GRV + bAV + Riester + Depot-Entnahme)
- Falls Lücke > 0 → 🔴 oder 🟡 je nach Größe
- Flag: kein bAV trotz Arbeitgeberzuschuss-Angebot → "entgangenes Geschenk" (Arbeitgeberzuschuss = direkter Gehaltsbestandteil)
- Flag: kein Riester trotz Kinderzulage-Berechtigung → Grundzulage €175 + Kinderzulage €185–€300 pro Kind p.a. wird verschenkt

**RAG-Logik:**
- 🔴 Rentenlücke > 50% des Zieleinkommens oder keine ergänzende Altersvorsorge außer GRV
- 🟡 Rentenlücke 20–50% oder bAV/Riester vorhanden aber Lücke bleibt
- 🟢 Rentenlücke < 20% oder Depot-Vermögen schließt Lücke voraussichtlich

---

### 4. Investitionsstruktur

**Sparquote:** monatliche Sparrate ÷ Nettoeinkommen; Ziel: ≥ 20%.

**Bewertung:**
- Prüfe Vorhandensein eines Depots
- Falls Depot vorhanden: sind Investments in UCITS ETFs (TER < 0.30%) oder in aktiv verwalteten Fonds mit hohen Kosten?
- Ist Freistellungsauftrag gestellt? (Sparerpauschbetrag: €1.000 Single / €2.000 Ehepaar p.a.)
- Ist Vorabpauschale bekannt und eingeplant?
- Flag: Girokonto-Guthaben > 2 Monatsausgaben → Opportunitätskosten (in Tagesgeld oder Sparplan umschichten)
- Flag: Kein Depot, keine ergänzende Geldanlage außer Tagesgeld → Kapitalaufbau fehlt

**Depot-Allokations-Check (falls Depot vorhanden):**
- Ist Allokation altersgerecht? (Faustregel: Aktienanteil = 100 − Alter, adjustiert nach Risikotoleranz)
- Klumpenrisiko: Einzeltitel > 10% des Depotwertes?
- Heimatmarkt-Bias (nur Deutschland/Europa)? → Diversifikation global empfehlen

**RAG-Logik:**
- 🔴 Sparquote < 5% oder kein Depot, kein Sparplan
- 🟡 Sparquote 5–20% oder Depot vorhanden aber hohe Kostenquoten / kein Freistellungsauftrag
- 🟢 Sparquote ≥ 20%, UCITS ETFs mit TER < 0.30%, Freistellungsauftrag gestellt

---

### 5. Versicherungsschutz-Übersicht

Bewerte Vollständigkeit und Dringlichkeit der Absicherung:

| Versicherung | Status | RAG | Kommentar |
|---|---|---|---|
| Haftpflichtversicherung | vorhanden / fehlt | 🔴 wenn fehlend | Kosten ~€50–130/Jahr; unbegrenzte Haftung ohne sie |
| BU (Berufsunfähigkeit) | vorhanden / fehlt | 🔴 wenn fehlend und erwerbstätig | Staatliche Erwerbsminderungsrente ~€960/Monat im Durchschnitt — massive Lücke |
| Krankenversicherung (GKV/PKV) | vorhanden | je nach Optimierungsbedarf | Kassenwechsel / PKV-Beitragsanpassung prüfen |
| Risikolebensversicherung | vorhanden / fehlt | 🔴 wenn Unterhaltspflichtige vorhanden und keine Versicherung | Nicht erforderlich ohne Dependents |
| Hausratversicherung | vorhanden / fehlt | 🟡 wenn fehlend | Empfehlenswert, nicht kritisch |

**BU-Lückenberechnung (falls keine BU oder unzureichende Deckung):**
- Ziel-Absicherung: 75% des monatlichen Nettoeinkommens
- Erwartete staatliche Erwerbsminderungsrente: ~€900–1.100/Monat (0 wenn < 5 GRV-Beitragsjahre)
- Benötigte BU-Rente = Ziel − EMR
- Falls keine BU oder Lücke > €500/Monat → 🔴 kritisch

**GKV-Optimierung:**
- Ist der Zusatzbeitrag der aktuellen Kasse wettbewerbsfähig? (> 0.5% über günstigster vergleichbarer Kasse → Kassenwechsel prüfen)
- Beitrag durch bAV-Entgeltumwandlung: reduziert beitragspflichtige Einnahmen → senkt GKV-Beitrag

*Für detaillierte GKV-vs.-PKV-Analyse und BU-Tiefenanalyse: /finance insurance aufrufen*

---

### 6. Steueroptimierung

**Steuerklassen-Check:**
- Steuerklasse I (ledig, kein Partner): Standard
- Steuerklasse III/V (verheiratet, Hauptverdiener/Geringverdiener): nur sinnvoll bei starkem Einkommensgefälle; sonst Klasse IV/IV+Faktor prüfen → optimiert Lohnsteuer-Vorauszahlung
- Steuerklasse II (alleinerziehend): Entlastungsbetrag → prüfen ob beantragt
- Flag: verheiratet in III/V mit ähnlichem Einkommen → mögliche Nachzahlung bei Steuererklärung; Wechsel zu IV/IV+Faktor erwägen

**bAV-Optimierung:**
- Wird der Arbeitgeberzuschuss (Pflicht: 15% auf Entgeltumwandlung aus SV-Ersparnis) vollständig genutzt?
- Steuerfreier bAV-Höchstbetrag 2026: €7.728/Jahr (8% BBG West)
- Doppelter Effekt: Einkommensteuereinsparung + GKV-Beitragsreduktion (bis BBG)

**Freistellungsauftrag:**
- Ist der Sparerpauschbetrag (€1.000 Single / €2.000 Ehepaar) über alle Depots und Konten korrekt aufgeteilt?
- Zu viel bei einem Broker → umverteilen

**Riester:**
- Ist Förderquote optimiert? (4% des Vorjahres-Bruttogehalts abzüglich Zulagen als Eigenbeitrag erforderlich)
- Günstigerprüfung: Finanzamt prüft automatisch, ob Sonderausgabenabzug günstiger ist als Zulagen

*Für detaillierte Steueroptimierungsstrategien: /finance taxes aufrufen*

---

## Output

Erstelle die Datei `FINANCE-ANALYSIS.md` im aktuellen Verzeichnis mit folgendem Aufbau:

```markdown
# Finanzanalyse
**Erstellt für:** [Name oder "Kunde"]
**Datum:** [Heute]
**Profil:** Angestellte(r), Steuerklasse [X], [GKV/PKV]

---

## Überblick

| Kategorie | Status | Priorität |
|---|---|---|
| 1. Liquidität & Notgroschen | 🔴/🟡/🟢 | Hoch/Mittel/Niedrig |
| 2. Schuldenanalyse | 🔴/🟡/🟢 | Hoch/Mittel/Niedrig |
| 3. Altersvorsorge-Lücke | 🔴/🟡/🟢 | Hoch/Mittel/Niedrig |
| 4. Investitionsstruktur | 🔴/🟡/🟢 | Hoch/Mittel/Niedrig |
| 5. Versicherungsschutz | 🔴/🟡/🟢 | Hoch/Mittel/Niedrig |
| 6. Steueroptimierung | 🔴/🟡/🟢 | Hoch/Mittel/Niedrig |

---

## 1. Liquidität & Notgroschen
[Detailanalyse mit konkreten €-Beträgen und Monatsabdeckung]

## 2. Schuldenanalyse
[Schuldendienstquote, Prioritätsreihenfolge, Tilgungsstrategie]

## 3. Altersvorsorge-Lücke (Rentenlücke)
[GRV-Schätzung, bAV, Riester, Depot-Projektion, Lücke in €/Monat]

## 4. Investitionsstruktur
[Sparquote, Depot-Allokation, Kostenanalyse, Freistellungsauftrag-Status]

## 5. Versicherungsschutz-Übersicht
[Lückentabelle mit €-Beträgen, BU-Lückenberechnung]

## 6. Steueroptimierung
[Steuerklasse, bAV-Nutzung, Freistellungsauftrag, Riester-Förderquote]

---

## Top-3-Maßnahmen (nach Dringlichkeit und Hebel)

| # | Maßnahme | Kategorie | Geschätzter Hebel | Zeitaufwand | Dringlichkeit |
|---|---|---|---|---|---|
| 1 | ... | ... | €X/Monat oder einmalig | X Std. | 🔴/🟡/🟢 |
| 2 | ... | ... | ... | ... | ... |
| 3 | ... | ... | ... | ... | ... |

---

## Weiterführende Analysen
- `/finance insurance` — vollständige GKV-vs.-PKV-Analyse und BU-Tiefenanalyse
- `/finance retirement` — vollständige Altersvorsorge-Analyse mit Projektionstabellen
- `/finance taxes` — Steueroptimierungsstrategien im Detail

---

**DISCLAIMER: Nur zu Informations- und Bildungszwecken. Keine Anlage-, Steuer- oder Versicherungsberatung. Alle Werte sind Schätzungen auf Basis allgemeiner Annahmen. Konsultiere einen zugelassenen Finanzberater, Steuerberater oder unabhängigen Versicherungsmakler vor jeder Entscheidung.**
```

## Quality Standards

- Alle €-Beträge sind konkret und aus den eingegebenen Daten abgeleitet (keine Platzhalterwerte)
- Jede RAG-Einstufung ist mit einer Berechnung oder Begründung unterlegt
- Fehlende Daten werden klar als Annahmen gekennzeichnet
- Keine US-spezifischen Begriffe, Strukturen oder Benchmarks
- Empfehlungen berücksichtigen die 2026-Werte aus `german-context.md`
- Bericht endet immer mit dem Disclaimer

## Handoff

Nach Erstellung der `FINANCE-ANALYSIS.md` teile dem Nutzer mit:
1. Die drei dringlichsten Maßnahmen aus dem Bericht
2. Verweise auf Folge-Skills für Tiefenanalysen:
   - "Für vollständige GKV-vs.-PKV-Analyse und BU-Tiefenanalyse: `/finance insurance` aufrufen."
   - "Für vollständige Altersvorsorge-Analyse mit Projektionstabellen: `/finance retirement` aufrufen."
   - "Für Steueroptimierungsstrategien im Detail: `/finance taxes` aufrufen."
3. Schlage `/finance report-pdf` für eine druckfertige PDF-Version vor.

**DISCLAIMER: Nur zu Informations- und Bildungszwecken. Keine Anlage-, Steuer- oder Versicherungsberatung. Konsultiere einen zugelassenen Finanzberater, Steuerberater oder unabhängigen Versicherungsmakler vor jeder Entscheidung.**
