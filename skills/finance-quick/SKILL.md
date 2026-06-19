---
name: finance-quick
description: 60-Second Financial Snapshot — fast assessment of financial health based on six core inputs (income, expenses, savings, debt, age, retirement goal). No subagents. Produces a compact terminal scorecard with savings rate, Schuldendienstquote, emergency fund coverage, retirement on-track status, and top 3 priority actions in under 40 lines.
---

# /finance quick — 60-Second Financial Snapshot

**DISCLAIMER: For educational/informational purposes only. Not financial advice.**

Before analysis, read `.claude/skills/shared/german-context.md` for 2026 German financial constants.

## Purpose

Deliver a high-signal financial health scorecard in under 60 seconds without launching the full 5-agent analysis. Use this when the user wants a quick read on where they stand before committing to a deeper audit.

## When To Trigger

- User types `/finance quick`
- User asks "how am I doing financially?", "what's my financial health?", "quick check on my finances", "wie steht es um meine Finanzen?"
- User wants a baseline before deciding to run `/finance analyze`

## DO NOT Launch Subagents

This skill must complete in a single response after collecting inputs. No parallel agents. No external API calls. All math is done inline by Claude.

## Required Inputs

Ask the user for these six numbers in a single prompt. Accept rough estimates — precision is not required for a snapshot.

1. **Monatliches Nettoeinkommen** (after-tax Euro landing in their account — for Angestellte this is after GKV, Rentenversicherung, Lohnsteuer)
2. **Monatliche Ausgaben** (Miete/Hypothek + Nebenkosten + Lebensmittel + Transport + alles andere)
3. **Liquide Ersparnisse gesamt** (Girokonto + Tagesgeld + Depot-Cash, NICHT bAV/Riester/Rentenversicherung)
4. **Schulden gesamt** (Kreditkarten + Ratenkredite + KFZ-Kredit + Hypothekensaldo)
5. **Aktuelles Alter**
6. **Angestrebtes Rentenalter**

If the user only provides partial data, compute what you can and flag missing fields in the output.

## Calculations

### 1. Sparquote (Savings Rate)
```
sparquote = (nettoeinkommen - ausgaben) / nettoeinkommen * 100
```
**Benchmarks (% of Nettoeinkommen):**
- ≥ 20% → Ausgezeichnet
- 15-19% → Gut
- 10-14% → Ausreichend
- 5-9% → Schwach
- < 5% → Kritisch

### 2. Schuldendienstquote (Debt Service Ratio)
In Germany, the relevant metric is Schuldendienstquote — monthly debt payments relative to Nettoeinkommen (not gross income).
```
monatliche_schuldenrate = ca. 2% der Gesamtschulden (grobe Schätzung)
schuldendienstquote = monatliche_schuldenrate / nettoeinkommen * 100
```
**Benchmarks (Schuldendienstquote, % of Nettoeinkommen):**
- < 15% → Ausgezeichnet
- 15-20% → Gesund
- 20-30% → Akzeptabel (Grenzwert)
- > 30% → Belastet — Schuldenabbau priorisieren
- > 40% → Kritisch

**Hinweis:** Deutsche Empfehlung: Schuldendienstquote < 30% Nettoeinkommen (aus german-context.md). Dieser Grenzwert gilt als wichtige Orientierung bei Baufinanzierungen und Konsumentenkrediten.

### 3. Notgroschen-Abdeckung
```
abgedeckte_monate = liquide_ersparnisse / monatliche_ausgaben
```
**Benchmarks:**
- ≥ 6 Monate → Ausgezeichnet
- 3-5.9 Monate → Gut
- 1-2.9 Monate → Schwach
- < 1 Monat → Kritisch

### 4. Altersvorsorge — Planmäßiger Stand

Aspirational Milestones für Deutschland (Jahresbruttolohn als Multiplikator; GRV bietet einen Boden, der den Kapitalbedarf gegenüber Ländern ohne gesetzliche Rente reduziert):

- Alter 30 → 0.5× Jahresbruttolohn in investierbarem Vermögen
- Alter 35 → 1× Jahresbruttolohn
- Alter 40 → 2× Jahresbruttolohn
- Alter 45 → 3× Jahresbruttolohn
- Alter 50 → 5× Jahresbruttolohn
- Alter 55 → 6.5× Jahresbruttolohn
- Alter 60 → 8× Jahresbruttolohn
- Alter 67 → 10× Jahresbruttolohn (Rentenalter regulär)

Diese Zahlen sind aspirational — die gesetzliche Rentenversicherung (GRV) liefert einen Boden. Wenn GRV-Rentenauskunft (Renteninformation) vorhanden, in die Analyse einbeziehen.

Tatsächliche Altersvorsorgesparnisse (bAV, Depot, Riester) mit der Alters-Benchmark vergleichen. Jahre bis zur Rente berechnen = angestrebtes Rentenalter - aktuelles Alter.

### 5. Composite Quick Score (0-100)
```
quick_score = (sparquote_score + schuldendienstquote_score + notgroschen_score + altersvorsorge_score) / 4
```
Jeder Teilscore ist 0-100 basierend auf den obigen Benchmarks.

**Note:**
- 85-100 → A
- 70-84 → B
- 55-69 → C
- 40-54 → D
- < 40 → F

## Quick-Check-Liste (7 Punkte)

Vor oder nach der Score-Berechnung diese Punkte prüfen und im Output kennzeichnen:

| Punkt | Frage | Status |
|-------|-------|--------|
| Notgroschen | ≥ 3 Monatsausgaben auf Tagesgeld? | ✅ / ❌ |
| Sparquote | ≥ 20% Nettolohn gespart/investiert? | ✅ / ❌ |
| Haftpflichtversicherung | Privathaftpflicht vorhanden? (€50-130/Jahr — unverzichtbar) | ✅ / ❌ |
| BU-Versicherung | Berufsunfähigkeitsversicherung vorhanden? (Kritisch im Erwerbsalter) | ✅ / ❌ |
| bAV mit AG-Zuschuss | Arbeitgeberzuschuss zur bAV vollständig ausgenutzt? (Gratis-Geld) | ✅ / ❌ |
| Freistellungsauftrag | Bei jedem Depot/Tagesgeld-Anbieter Freistellungsauftrag gesetzt? (€1.000 p.a. steuerfrei) | ✅ / ❌ |
| Schuldendienstquote | Monatliche Schuldenrate < 30% Nettoeinkommen? | ✅ / ❌ |

## Output Format

Keep output under 40 lines total. Use plain ASCII (no markdown tables for the terminal version, but include a compact table format).

```
================================================
  60-SEKUNDEN FINANZ-SNAPSHOT
================================================

Finanzielle Gesundheit: [Note] ([Score]/100)
Lebensphase: [Berufsstart / Aufbauphase / Mid-Career / Vorruhestand]

KERNKENNZAHLEN
- Sparquote:              [X]%   [Ausgezeichnet/Gut/Ausreichend/Schwach/Kritisch]
- Schuldendienstquote:    [X]%   [Status]  (Ziel: < 30% Netto)
- Notgroschen:            [X.X] Monate   [Status]
- Altersvorsorge-Track:   [Planmäßig / Im Rückstand / Kritisch im Rückstand]

QUICK-CHECK
- Notgroschen ≥ 3 Monate:     [✅ / ❌]
- Sparquote ≥ 20%:             [✅ / ❌]
- Haftpflichtversicherung:     [✅ / ❌]
- BU vorhanden:                [✅ / ❌]
- bAV AG-Zuschuss genutzt:     [✅ / ❌]
- Freistellungsauftrag gesetzt:[✅ / ❌]
- Schuldendienstquote < 30%:   [✅ / ❌]

TOP 3 PRIORITÄTEN
1. [Höchste Wirkung — konkreter Euro-Betrag + diese Woche]
2. [Zweite Priorität — spezifische Aktion]
3. [Dritte Priorität — spezifische Aktion]

WICHTIGSTE ZAHL ZUM VERBESSERN
[Die eine Kennzahl die den Score am meisten bewegt]

================================================
Für vollständige Analyse: `/finance analyze`
DISCLAIMER: Nur zu Bildungs-/Informationszwecken.
Keine Finanzberatung.
================================================
```

## Prioritätsaktionen-Logik

Aktionen nach schwächster Kennzahl ranken:

- **Wenn Notgroschen < 1 Monat** → Top-Aktion: "Notgroschen auf €X (1 Monat Mindest) aufbauen bevor andere Schritte — auf Tagesgeld (~3-3.5% p.a.) bei DKB/ING/Trade Republic"
- **Wenn Schuldendienstquote > 30%** → Top-Aktion: "Aggressiver Schuldenabbau — höchsten Zinssatz (Dispo zuerst) priorisieren, €X extra/Monat ansetzen"
- **Wenn Sparquote < 5%** → Top-Aktion: "Top 3 Ausgabenkategorien auditieren — €X einsparbares Potenzial diesen Monat finden"
- **Wenn Altersvorsorge kritisch im Rückstand** → Top-Aktion: "bAV-Beitrag erhöhen (AG-Zuschuss zuerst ausnutzen), dann ETF-Sparplan aufsetzen — Ziel 15-20% des Nettoeinkommens"
- **Wenn Hochzinsschulden vorhanden (Dispo > 8-14%)** → "Dispo-Kredit abbezahlen bevor weitere Investitionen"

Wenn alle vier Kennzahlen gut sind, Optimierungsaktionen nennen:
- "bAV-Beitrag erhöhen um vollen Arbeitgeberzuschuss auszunutzen"
- "Notgroschen auf Tagesgeld mit ~3-3.5% p.a. verschieben — DKB, ING, Trade Republic vergleichen"
- "Freistellungsauftrag prüfen — €1.000/Jahr (Single) steuerfrei auf alle Broker aufteilen"
- "Sparplan auf MSCI World UCITS ETF (SWDA/XDWD) aufsetzen, monatliches Investing automatisieren"

## Beispiel-Walkthrough

**Nutzereingaben:**
- Nettoeinkommen: €4.800/Monat
- Ausgaben: €3.900/Monat
- Liquide Ersparnisse: €7.200
- Schulden: €18.000 (Ratenkredit)
- Alter: 31
- Rentenalter angestrebt: 67

**Berechnet:**
- Sparquote: 18.75% → Gut
- Schuldendienstquote: ~7.5% → Ausgezeichnet
- Notgroschen: 1.85 Monate → Schwach
- Altersvorsorge: 36 Jahre bis Rente, €7.200 Ersparnisse, Benchmark bei 31 ist ~0.5× Jahresbrutto (angenommen €55.000 Brutto → Ziel ~€27.500) → Im Rückstand

**Score:** (75 + 95 + 30 + 40) / 4 = 60 → C

**Top 3 Prioritäten:**
1. Notgroschen von €7.200 auf €11.700 (3 Monate) aufstocken — €500/Monat für 9 Monate umleiten; auf Tagesgeld bei DKB oder ING (~3.5% p.a.)
2. ETF-Sparplan einrichten — nach Notgroschen-Aufbau €300/Monat in MSCI World UCITS ETF (SWDA/XDWD) via Trade Republic oder Scalable
3. Freistellungsauftrag bei jedem Broker/Tagesgeld-Konto setzen — €1.000/Jahr Kapitalerträge steuerfrei

## Sonderfälle

- **Nutzer nennt keine Schulden** → DTI-Scoring überspringen, andere Faktoren gleichgewichten
- **Nutzer ist in Rente** → Altersvorsorge-Track ersetzen durch Entnahme-Nachhaltigkeit (4%-Regel-Check; GRV-Rente einbeziehen)
- **Nutzer unter 25** → Niedrigere Altersvorsorge-Benchmarks (0.25× bei 25); Frühzeitigkeit betonen; Zinseszinseffekt visualisieren
- **Nutzer mit sehr hohem Einkommen (> €150.000 Brutto)** → Hinweis: bAV und Riester haben Beitragsgrenzen; Rürup-Rente und Depot-Investitionen besprechen; `/finance taxes` empfehlen
- **Nutzer verweigert Zahlenangabe** → 3 Szenarien anbieten (finanziell angespannt / durchschnittlich / stark aufgestellt) und selbst einordnen lassen

## Übergabe

Jeden Snapshot mit dieser Zeile beenden:
> `/finance analyze` für die vollständige Analyse, oder `/finance debt` / `/finance retirement` für gezielte Themen.

## Ton

Direkt. Quantitativ. Keine unverbindliche Sprache wie "Sie könnten erwägen." Stattdessen: "Diese Woche X tun" mit konkreten Euro-Beträgen. Stärken zuerst anerkennen ("18% Sparquote liegt über dem deutschen Durchschnitt") bevor Lücken benannt werden.

**DISCLAIMER: For educational/informational purposes only. Not financial advice. Consult a licensed financial advisor, Steuerberater, or financial planner before making major financial decisions.**
