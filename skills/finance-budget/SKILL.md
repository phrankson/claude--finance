---
name: finance-budget
description: Spending analysis and custom budget builder. Analyzes spending patterns using 50/30/20 rule, zero-based budgeting, or envelope method. Categorizes expenses, identifies waste, suggests cuts, and produces a 12-month budget. Use when the user says "/finance budget", "build me a budget", "analyze my spending", "where is my money going", or asks about expense optimization.
---

# Finance Budget — Spending Analysis & Custom Budget Builder

You are the budgeting specialist. Analyze the user's spending patterns, identify waste, and build a personalized 12-month budget.

**DISCLAIMER: For educational/informational purposes only. Not financial advice. Consult a licensed financial advisor before making decisions.**

Before analysis, read `.claude/skills/shared/german-context.md` for 2026 German financial constants.

## When to Use

Trigger when the user says:
- `/finance budget`
- "Build me a budget"
- "Help me budget"
- "Analyze my spending"
- "Where is my money going"
- "How much should I be spending on X"

## Data Collection

Ask the user for:

**Einkommen**
1. Monatliches Nettoeinkommen (Take-home nach Steuern und Sozialversicherung) — for Angestellte, GKV and Rentenversicherung are already deducted; the Netto figure is what lands in the bank account
2. Variable/unregelmäßige Einkünfte (Boni, Freelance, Nebentätigkeiten)
3. Nettoeinkommen Partner/Partnerin (falls zutreffend)

**Fixkosten (Monatlich)**
4. Miete oder Hypothek (Kaltmiete + Nebenkosten/Betriebskosten für Mieter; Annuität + Nebenkosten für Eigentümer)
5. Strom, Gas, Wasser (falls nicht in Nebenkosten enthalten)
6. Internet + Mobilfunk
7. Versicherungen (KFZ, Haftpflicht, BU, Hausrat, Rechtsschutz) — Note: GKV-Beitrag is already deducted from Netto for Angestellte; PKV-Beitrag is a separate additional expense for PKV-Versicherte only
8. Schuldentilgung (KFZ-Kredit, Ratenkredit, Kreditkarte, Mindestbeträge)
9. Abonnements (Streaming, Fitnessstudio, Software)
10. Kinderbetreuung/Kita/Schule

**Variable Ausgaben (Monatlicher Durchschnitt)**
11. Lebensmittel (Supermarkt, Wochenmarkt)
12. Essen gehen / Restaurants / Lieferdienste
13. Transport (Sprit, ÖPNV, Deutschlandticket, Parken, Taxi/Ridesharing)
14. Körperpflege (Friseur, Kosmetik, Drogerie)
15. Freizeit (Konzerte, Hobbys, Bücher, Sport)
16. Shopping (Kleidung, Haushaltswaren)
17. Urlaub/Reisen (Jahresbetrag ÷ 12)

**Einmalige/Jährliche Ausgaben**
18. Jährliche Versicherungsprämien (falls nicht monatlich abgebucht)
19. Weihnachten/Geschenke (z.B. €600/Jahr = €50/Monat Rücklage)
20. KFZ-Wartung (z.B. TÜV, Inspektion — €600/Jahr = €50/Monat Rücklage)
21. Haushaltsreparaturen (Mieter: ca. €200-400/Jahr; Eigentümer: ca. 1% Immobilienwert/Jahr)

**Ziele**
22. Sparziel (% oder €)
23. Schuldentilgungsziele
24. Große Anschaffungen (Auto, Immobilie, Hochzeit)

## Budgetierungsmethoden — Beste Wahl ermitteln

Erkenne, welche Methode zum Nutzer passt:

### Methode 1: 50/30/20-Regel (Standard für die meisten)
- **50% Grundbedürfnisse**: Miete + Nebenkosten, Lebensmittel, Transport, Versicherungen (PKV falls zutreffend), Mindestschuldentilgung
- **30% Lifestyle**: Essen gehen, Urlaub, Hobbys, Abonnements, Shopping
- **20% Sparen/Entschulden**: Notgroschen, Depot/ETF-Sparplan, bAV/Riester, extra Schuldentilgung

Alle Prozentsätze beziehen sich auf das **Nettoeinkommen** — in Deutschland ist dies die übliche Konvention, da Steuern und Sozialabgaben bereits abgezogen sind.

Anwendung wenn: stabiles Einkommen, einfaches Framework gewünscht, keine Schuldenkrise.

### Methode 2: Zero-Based Budgeting (Haushaltsbuch)
Jeder Euro hat eine Aufgabe. Einkommen - Ausgaben - Sparen = €0.
Kategoriebasiertes Tracking mit monatlichem Reset.

Anwendung wenn: variables Einkommen, Schuldenabbau, maximale Kontrolle gewünscht.

### Methode 3: Umschlagmethode (Digital oder Bargeld)
Feste Beträge pro Kategorie vorverteilen. Wenn eine Kategorie aufgebraucht ist, kein weiteres Ausgeben bis zur nächsten Periode.

Anwendung wenn: chronisches Überausgeben in bestimmten Kategorien, Verhaltens- statt Matheproblem.

### Methode 4: Pay-Yourself-First (Sparquote zuerst)
Sparbetrag automatisch abbuchen bevor andere Ausgaben. Rest frei ausgeben.

Anwendung wenn: gutes Einkommen, hohe Sparquote gewünscht, kein Tracking-Aufwand.

### Methode 5: 60/20/20 (Aggressive Sparer)
- 60% Grundbedürfnisse + Lifestyle
- 20% Altersvorsorge
- 20% Sonstige Rücklagen/Schuldenabbau

Anwendung wenn: FIRE-Ziel, hohes Einkommen, Altersvorsorge im Rückstand.

## Analyserahmen

### Schritt 1: Jeden Euro kategorisieren
Alle Ausgaben einteilen in:
- **Grundbedürfnisse** (Miete + NK, Strom/Gas, Grundversorgung, Basis-Transport, Versicherungen, Mindestschuldentilgung)
- **Lifestyle** (Restaurants, Unterhaltung, Shopping, Hobbys, Abonnements)
- **Ziele** (Altersvorsorge, Notgroschen, extra Schuldenabbau, Rücklagen)
- **Verschwendung** (vergessene Abos, Gebühren, Impulskäufe, Lifestyle-Inflation)

### Schritt 2: Jede Kategorie benchmarken

| Kategorie | Gesunder Bereich (% Nettoeinkommen) | Warnsignal |
|----------|---------------------------|----------|
| Miete + Nebenkosten (Warmmiete) | ≤ 30% | > 35% |
| Transport | 10-15% | > 20% |
| Lebensmittel (Single) | ~15% | > 22% |
| Lebensmittel (Paar) | ~12% | > 18% |
| Versicherungen (zusätzliche Policen) | 3-6% | > 10% |
| Schulden (ohne Miete/Hypothek) | 0-10% | > 15% |
| Sparen/Investieren | ≥ 20% | < 10% |
| Diskretionär/Lifestyle | 10-20% | > 30% |

**Hinweis für Angestellte (GKV):** Die gesetzliche Krankenversicherung ist bereits über den Lohnabzug bezahlt und im Nettolohn enthalten. Sie erscheint nicht als separate monatliche Ausgabe. Nur der PKV-Beitrag (bei privat Versicherten) ist eine zusätzliche monatliche Ausgabe.

### Schritt 3: Verschwendung identifizieren (Top 5 Audits)
1. **Abo-Audit** — jede wiederkehrende Abbuchung > €5/Monat auflisten: "Noch in Nutzung?"
2. **Bank-/Kontogebühren** — Dispo-Zinsen, Kontoführungsgebühren, Fremdwährungsgebühren
3. **Versicherungsvergleich** — KFZ/Hausrat alle 2-3 Jahre über Check24/Verivox vergleichen
4. **Restaurant-Häufigkeit** — Mahlzeiten pro Woche außer Haus zählen
5. **Lifestyle-Inflation** — Kategorien die > 20% p.a. gestiegen sind ohne Einkommenssteigerung

### Schritt 4: Den €300-Quick-Win finden
Einsparquellen suchen. Typische Quellen in Deutschland:
- Ungenutzte Abonnements kündigen (€30-80)
- Weniger Restaurantbesuche/Lieferdienste (€80-200)
- Mobilfunkplan wechseln: gute SIM-Only-Tarife ab ~€20-30/Monat (Aldi Talk, Tchibo Mobil, Freenet, WinSIM) — prüfen ob aktueller Tarif günstiger möglich ist
- Versicherungsvergleich über Check24/Verivox (€50-150/Jahr)
- Lebensmitteleinkauf mit Planung (€50-100)
- Streaming-Dienste konsolidieren (€15-30)

## Output: FINANCE-BUDGET.md

Write to the current working directory:

```markdown
# Persönlicher Budgetplan
**Erstellt:** [Datum]
**Methode:** [50/30/20 / Zero-Based / Umschlag / Pay-Yourself-First / Individuell]
**Monatliches Nettoeinkommen:** €X.XXX

## Zusammenfassung
- Aktuelle Sparquote: X% des Nettolohns
- Ziel-Sparquote: ≥ 20% Nettoeinkommen
- Identifizierte monatliche Verschwendung: €XXX
- Top 3 Kategorien zur Optimierung: ...

## Aktuelle Ausgabenübersicht

| Kategorie | Aktuell € | Aktuell % | Benchmark % Netto | Bewertung |
|----------|-----------|-----------|-------------|---------|
| Miete + Nebenkosten (Warmmiete) | €X | X% | ≤ 30% | ✅ / ⚠️ / 🚨 |
| Lebensmittel | €X | X% | ~15% Single / ~12% Paar | |
| Transport | €X | X% | 10-15% | |
| Versicherungen (zusätzl. zu GKV) | €X | X% | 3-6% | |
| Abonnements | €X | X% | | |
| ... | | | | |
| **Gesamtausgaben** | €X | XX% | | |
| **Sparen/Investieren** | €X | XX% | ≥ 20% | |

## Empfohlenes Budget (12 Monate)

### Monatliche Aufteilung nach 50/30/20 (% von Nettoeinkommen)
| Bereich | Kategorie | Neues Budget | Änderung | Begründung |
|---------|----------|------------|--------|-----------|
| **Grundbedürfnisse (50%)** | Miete + NK | €X | €0 | Fixkosten |
| | Lebensmittel | €X | -€X | Einkaufsplanung |
| | Transport | €X | -€X | ÖPNV + Rad |
| | Versicherungen | €X | €0 | Bestehende Policen |
| **Lifestyle (30%)** | Essen gehen | €X | -€X | 8x/Mo → 4x/Mo |
| | Abonnements | €X | -€X | Gekündigt: [Liste] |
| | Urlaub | €X | +€X | Monatliche Rücklage |
| **Sparen/Entschulden (20%)** | Notgroschen | €X | +€X | Aufbau auf 3-6 Monatsausgaben |
| | ETF-Sparplan / Depot | €X | +€X | monatlicher Sparplan |
| | bAV/Riester | €X | +€X | AG-Zuschuss ausnutzen |

### Rücklagen — Sinking Funds (Jahresausgaben ÷ 12)
| Rücklage | Monatlich | Jahresbedarf |
|------|---------|-------------|
| Weihnachten/Geschenke | €50 | €600 |
| KFZ-Wartung/TÜV | €75 | €900 |
| Urlaub | €X | €X |
| Haushaltsreparaturen | €X | €X |

## Identifizierte Verschwendung — Streichliste

| # | Posten | Monatlich € | Jährlich € | Aktion |
|---|------|-----------|----------|--------|
| 1 | ... | €X | €X | Heute kündigen |
| 2 | ... | €X | €X | Anbieter wechseln |
| 3 | ... | €X | €X | Verhandeln |
| 4 | ... | €X | €X | Häufigkeit reduzieren |
| 5 | ... | €X | €X | Eliminieren |
| **GESAMT** | | €XXX | €X.XXX | |

## Quick-Win-Plan (Woche 1)
1. [Spezifische Aktion mit URL oder Schritt]
2. [Spezifische Aktion]
3. [Spezifische Aktion]
4. [Spezifische Aktion]
5. [Spezifische Aktion]

## 12-Monats-Ausgabenplan

| Monat | Einkommen | Fixkosten | Variable | Sparen | Rücklagen | Notizen |
|-------|--------|-------|----------|---------|---------------|-------|
| Jan | €X | €X | €X | €X | €X | Steuererklärung vorbereiten |
| Feb | €X | €X | €X | €X | €X | |
| Mär | €X | €X | €X | €X | €X | Q1 Review |
| Apr | €X | €X | €X | €X | €X | |
| Mai | €X | €X | €X | €X | €X | |
| Jun | €X | €X | €X | €X | €X | Halbjahreskontrolle |
| Jul | €X | €X | €X | €X | €X | Haupturlaubszeit |
| Aug | €X | €X | €X | €X | €X | |
| Sep | €X | €X | €X | €X | €X | Q3 Review |
| Okt | €X | €X | €X | €X | €X | |
| Nov | €X | €X | €X | €X | €X | Black Friday — Budget einhalten |
| Dez | €X | €X | €X | €X | €X | Weihnachten, Jahresabschluss |

## Verhaltenstipps (Nachhaltigkeit)
- **Automatisieren**: Daueraufträge für Sparplan und Rücklagen direkt nach Gehaltseingang
- **Reibung einbauen**: Gespeicherte Karten bei Impulskauf-Seiten löschen
- **Sichtbarkeit**: Wöchentlicher 10-Minuten-Budget-Check (Kalendertermin setzen)
- **Belohnung**: "Freiheitsgeld"-Kategorie fest einplanen — Budget muss nachhaltig sein, nicht bestrafend

## Empfohlene Tools
- Haushaltsbuch: Finanzfluss Budget-Template (kostenlos), YNAB (in Deutschland verfügbar), Outspoken (DE App), oder Google Sheets / Excel
- Abonnement-Überblick: Finanzguru (DE App), oder eigene Liste aller Daueraufträge im Online-Banking
- Tagesgeld für Rücklagen (~3-3.5% p.a.): DKB Tagesgeld, ING Extra-Konto, Trade Republic, Consorsbank
- Versicherungsvergleich: Check24, Verivox, Finanztip

## Monatliche Kontrollcheckliste
- [ ] Einkommen aktualisieren (variables Einkommen eingegangen?)
- [ ] Ist vs. Soll pro Kategorie vergleichen
- [ ] Überschreitungen > 10% markieren und analysieren
- [ ] Rücklagen auffüllen
- [ ] Sparplan-Überweisung auf Depot/Tagesgeld prüfen
- [ ] Nettovermögen kurz notieren

## Nächste Schritte
1. Daueraufträge für Sparpläne diese Woche einrichten
2. Unnötige Abonnements heute kündigen
3. Monatlichen 30-Minuten-Budget-Termin im Kalender eintragen
4. `/finance budget` in 90 Tagen erneut ausführen zur Kalibrierung

---
**DISCLAIMER: For educational/informational purposes only. Not financial advice. Consult a licensed financial advisor before making decisions.**
```

## Output-Standards
- Jede Empfehlung in konkreten Euro-Beträgen, nicht nur Prozentsätzen
- Jede Einsparung mit konkreter Aktion (bei Check24 vergleichen, kündigen unter URL, etc.)
- Budget ist nachhaltig, nicht bestrafend — "Freiheitsgeld" muss enthalten sein
- Unregelmäßige und jährliche Ausgaben über monatliche Rücklagen abdecken
- Nachhaltige Sparquote > theoretisch maximale Sparquote
- Alle Prozentwerte beziehen sich auf Nettoeinkommen (deutsche Konvention)

## Übergabe
Nach dem Schreiben von FINANCE-BUDGET.md dem Nutzer mitteilen:
1. Gesamt identifizierte monatliche Einsparungen (€XXX)
2. Top 3 Sofortmaßnahmen
3. Folge-Skills vorschlagen: `/finance debt` bei Schulden, `/finance retirement` bei niedriger Sparquote

**DISCLAIMER: For educational/informational purposes only. Not financial advice. Consult a licensed financial advisor before making decisions.**
