---
name: finance-fire
description: FIRE (Finanzielle Unabhängigkeit / frühzeitig in Rente) calculator for German Angestellte and Frugalisten. Calculates FIRE-Zahl, years-to-FIRE, GKV costs in early retirement, Rentenversicherung bridge strategy, tax-efficient Entnahmestrategie, and geographic arbitrage options within Germany and Europe. Use when the user says "/finance fire", "finanzielle Unabhängigkeit", "frühzeitig in Rente", "FIRE-Zahl", "Frugalist", "Entnahmeportfolio", "Lean FIRE", "Fat FIRE", "Coast FIRE", "früher Ruhestand", "Rente mit 40/45/50/55", or any early retirement question in a German financial context.
---

# Finance FIRE — Finanzielle Unabhängigkeit für deutsche Anleger

**DISCLAIMER: Nur zu Informations- und Bildungszwecken. Keine Anlage- oder Steuerberatung. Konsultieren Sie einen zugelassenen Finanzberater und Steuerberater, bevor Sie Entscheidungen treffen.**

## When to Run

Trigger when the user says:
- `/finance fire`
- "Finanzielle Unabhängigkeit" / "Financial Independence"
- "Frühzeitig in Rente" / "Retire early"
- "FIRE-Zahl" / "FI number"
- "Frugalist" / "Frugalismus"
- "Lean FIRE", "Fat FIRE", "Coast FIRE", "Barista FIRE"
- "Entnahmeportfolio" / "Entnahmestrategie"
- "4%-Regel" / "Trinity Study"
- "Rente mit [Alter]" (e.g., "Rente mit 45")
- "Rentenlücke berechnen"
- "Früher Ruhestand"

## Data Collection

Ask the user for the following. Mark optional items clearly; proceed with estimates if not provided.

| # | Data point | German label | Notes |
|---|---|---|---|
| 1 | Target FIRE age | FIRE-Alter / Zielrente-Alter | When do you want to stop working? |
| 2 | Current age | Aktuelles Alter | — |
| 3 | Rentenversicherung Entgeltpunkte | DRV Entgeltpunkte (aus Rentenauskunft) | Find on DRV Kontoauszug (rentenversicherung.de); estimate if not available |
| 4 | Monthly spending target in retirement | Monatlicher Entnahmebedarf (€/Monat) | How much do you want to spend in retirement? |
| 5 | Current invested assets | Investiertes Vermögen (€) | Sum of: Depot + bAV + Riester + Rürup + Tagesgeld/Festgeld earmarked for FIRE |
| 6 | Monthly savings | Monatliche Sparrate (€) | Amount invested per month toward FIRE |
| 7 | Current annual gross income | Jahresbruttoeinkommen (€) | Used for GRV Entgeltpunkt projection |
| 8 | GKV or PKV | Krankenversicherung | Which health insurance type? |
| 9 | Relocation interest | Umzugsbereitschaft | Open to moving within Germany or abroad for lower cost of living? |

If data is missing, estimate conservatively and flag the assumption.

## FIRE Framework

Before analysis, read `.claude/skills/shared/german-context.md` for 2026 German financial constants.

---

### 1. FIRE-Zahl berechnen

**Base formula (Trinity Study / 4%-Regel):**
```
FIRE-Zahl = Jährlicher Ausgabenbedarf × 25
```

**German-adjusted formula (recommended — accounts for GRV floor):**
```
GRV-Monatsrente = Entgeltpunkte × €39.32  (aktueller Rentenwert West 2026)
GRV-Jahresrente = GRV-Monatsrente × 12

Netto-Entnahmebedarf = Jährlicher Ausgabenbedarf − GRV-Jahresrente
FIRE-Zahl (GRV-adjustiert) = Netto-Entnahmebedarf × 25
```

**Why this matters:** German Rentenversicherung (GRV) provides a baseline income from age 67 (Regelrente) or 63 (with 45 Beitragsjahre). This floor reduces the portfolio you must accumulate vs. a FIRE calc that ignores public pension income.

**Example:**
- Monthly target spending: €2,500 → €30,000/year
- Projected GRV at 67: 32 Entgeltpunkte × €39.32 = €1,258/month → €15,100/year
- Net portfolio need: €30,000 − €15,100 = €14,900/year
- **FIRE-Zahl: €14,900 × 25 = €372,500** (vs. €750,000 without GRV offset)

**FIRE variants in EUR context:**

| Variant | Beschreibung | Typischer Ausgaberahmen |
|---|---|---|
| Lean FIRE | Minimalistischer Lebensstil, keine Luxusausgaben | €1,000–€1,800/Monat |
| Standard FIRE | Komfortabler Mittelklasse-Lebensstil | €1,800–€3,500/Monat |
| Fat FIRE | Gehobener Lebensstil, Reisen, Hobbys | €3,500–€7,000+/Monat |
| Coast FIRE | Portfolio groß genug, um ohne weitere Einzahlungen bis 67 zu wachsen | — |
| Barista FIRE / Semi-FIRE | Teilzeit-Arbeit deckt laufende Kosten; Portfolio wächst oder ergänzt | — |

**Coast FIRE-Zahl:**
```
Coast FIRE-Zahl = FIRE-Zahl / (1 + r)^(67 − aktuelles_Alter)
```
Use r = 5–7% real return. If your current Depot already exceeds this number, you can stop investing and still reach FIRE by 67.

**Conservative withdrawal rate for long retirements (40+ years):**
- 4% rule (× 25 multiplier): ~85–90% success rate historically over 50 years
- 3.5% rule (× 28.5 multiplier): ~95%+ success rate; recommended for early retirees under 45
- Dynamic approach: withdraw 3.5–4% but flex down in bad market years

---

### 2. GKV in der frühen Rente (kritischer Deutschland-spezifischer Abschnitt)

This is the most important cost that non-German FIRE calculations ignore entirely. Budget this carefully.

**Scenario A — GKV-Versicherter (freiwillig versichert vor Regelrente):**

Before reaching statutory pension age, early retirees on GKV are classified as **freiwillig versichert** (not KVdR — Krankenversicherung der Rentner). KVdR only applies after Rentenalter and requires meeting the 9/10 rule (90% of the second half of working life in GKV).

Key rules for freiwillig Versicherte:
- **Mindestbemessungsgrundlage 2026:** €1,178/month → **Minimum GKV contribution: ~€193/month** even with zero income (16.3% × €1,178)
- If your withdrawal income exceeds €1,178/month: full 16.3% applies to ALL income types:
  - Capital gains (dividends, ETF Vorabpauschale distributions)
  - Rental income
  - bAV distributions
  - Riester/Rürup payouts (counted as Versorgungsbezüge — at 14.6% + Zusatzbeitrag)
- **Pflegeversicherung:** Additional ~3.4% (or 3.05% with children) on the same base — minimum adds ~€40/month

**Strategy: Keep taxable income below €1,178/month → pay only minimum ~€193 GKV + ~€40 Pflege = ~€233/month total.**

This is achievable with accumulating ETFs (e.g., iShares MSCI World SWDA, ISIN IE00B4L5Y983) that do not distribute dividends — only the annual Vorabpauschale is assessed, often minimal.

**Scenario B — PKV-Versicherter:**
- PKV premiums continue regardless of income — typically €400–€900/month in early retirement depending on age and tariff
- PKV premiums rise significantly with age (especially 50–70)
- No minimum-base advantage; no income-dependent contribution
- Budget PKV as a fixed and rising cost — stress-test your FIRE number at PKV + 50% for age-related increases

**GKV cost planning table:**

| Income level (freiwillig GKV) | GKV + Pflege monthly cost (est.) |
|---|---|
| €0 – €1,178/month (minimum base) | ~€233/month |
| €1,500/month | ~€245/month (16.3% × 1,500) |
| €2,000/month | ~€326/month |
| €3,000/month | ~€489/month |

Include GKV/Pflege cost as a fixed line item in your FIRE budget.

---

### 3. Rentenversicherung-Brückenstrategie

**The problem:** If you stop working at, say, age 48, you may accumulate fewer than 45 Beitragsjahre — meaning:
- No early retirement (Altersrente für besonders langjährig Versicherte) at 63 without Abzüge
- Potential reduction in eventual pension amount
- Possible loss of KVdR eligibility (which provides much cheaper GKV in full retirement)

**Option A: Freiwillige Beiträge zur Rentenversicherung**

After leaving employment, you can voluntarily pay into GRV:
- 2026 range: **€100.07–€1,404.90/month**
- Each month at average earnings (ca. €506/month in 2026) adds approximately 0.08 Entgeltpunkte
- Purpose: (a) reach 45 Beitragsjahre for penalty-free early pension at 63, (b) increase monthly pension amount, (c) satisfy KVdR eligibility (9/10 rule)
- Worth calculating: cost of filling gap years vs. value of KVdR (saves ~€100–€300/month in GKV contributions from 63 onward)

**Early pension milestones:**

| Milestone | Age | Beitragsjahre required | Abzüge |
|---|---|---|---|
| Altersrente für besonders langjährig Versicherte | 63 | 45 Jahre | None |
| Altersrente für langjährig Versicherte | 65 | 35 Jahre | None |
| Regelrente | 67 | Any | None |
| Early exit with Abzüge | Before Regelrente | 35+ Jahre | 0.3% per month early (max 14.4%) |

**Entgeltpunkte projection formula:**
```
Annual Entgeltpunkte ≈ Jahresbruttolohn / Durchschnittsentgelt
(Durchschnittsentgelt 2026 ≈ €45,358)

Projected GRV monthly income = Total Entgeltpunkte × €39.32
```

Calculate: current Entgeltpunkte + projected points if working until FIRE-Alter → monthly GRV at 63 vs. 67.

---

### 4. Entnahmestrategie (Withdrawal Strategy)

**Optimal withdrawal sequence for German FIRE-seekers:**

**Phase 1 — FIRE to ~60 (use taxable Depot first):**
- Draw from taxable Depot (Wertpapierdepot)
- Tax treatment: Abgeltungsteuer 26.375% on gains; Teilfreistellung reduces taxable base by 30% for equity ETFs
- Günstigerprüfung opportunity: if total income (including capital income) is below ~€25,000/year, filing Anlage KAP via ELSTER may result in capital income being taxed at marginal rate (14–25%) instead of flat 26.375%
- Use Sparerpauschbetrag (€1,000 single / €2,000 married) annually — set Freistellungsauftrag at each broker

**Tax-efficient withdrawal target:**
```
Optimal annual withdrawal ≤ Grundfreibetrag + Sparerpauschbetrag
                          = €12,096 + €1,000 = €13,096 (single, 2026)
→ effective Einkommensteuer: near zero
```

For higher spending needs, structure withdrawals to stay in the 14–20% marginal rate bracket.

**Phase 2 — age 60–63 (bridge to early pension):**
- Consider freiwillige Rentenversicherungsbeiträge to reach 45 Beitragsjahre
- Continue taxable Depot drawdown
- Evaluate bAV distributions if contractually accessible (most bAV not accessible before Rentenalter)

**Phase 3 — from age 63/67 (GRV kicks in):**
- GRV income supplements or replaces portfolio withdrawals
- bAV/Riester/Rürup distributions begin (taxed as Sonstige Einkünfte at marginal rate — not Abgeltungsteuer)
- Portfolio withdrawal rate can decrease substantially once GRV flows

**Vorabpauschale note:**
- Accumulating ETFs trigger annual Vorabpauschale (notional tax on unrealized gains)
- Broker deducts automatically from cash in account
- In FIRE with low income, Günstigerprüfung may recover over-withheld tax via Steuererklärung
- Distributing ETFs (e.g., Vanguard FTSE All-World VWRL, ISIN IE00B3RBWM25) generate real dividend cash — useful for income but count toward GKV income assessment

**Withdrawal strategies:**

| Strategy | SWR | FIRE-Zahl multiplier | Empfehlung |
|---|---|---|---|
| 4%-Regel (Trinity Study) | 4.0% | 25× | Standard; ~85–90% Erfolgsrate über 50 Jahre |
| 3.5%-Regel | 3.5% | 28.5× | Empfohlen für Ruhestand unter 45 Jahren |
| Dynamische Entnahme (% aktuelles Portfolio) | variabel | — | Niemals Kapitalverzehr; Einkommen schwankt |
| Guyton-Klinger Guard Rails | 5% Start | — | Höhere Anfangsrate mit Anpassungsmechanismus |
| Eimer-Strategie (Bucket) | — | — | Tagesgeld (1–2 J.) + Anleihen (3–7 J.) + Aktien-ETF (8+ J.) |

**Sequence of Returns Risk (Renditefolgerisiko):**
- First 5 years post-FIRE are highest risk — a severe bear market early in retirement dramatically increases portfolio failure probability
- Mitigation:
  1. Tagesgeld-Puffer: 1–2 years spending in instant-access savings (DKB, ING, Trade Republic Tagesgeld ~3–3.5% p.a.)
  2. Anleihen-Anteil: Hold 3–5 years expenses in EU government bonds or bond ETFs
  3. Flexible Entnahme: Reduce discretionary spending in down years
  4. Semi-FIRE / Barista FIRE: Part-time income buffers early years

---

### 5. Geographic Arbitrage für deutsche FIRE-Anleger

**Within Germany:**

| Region | Cost vs. Munich/Hamburg | Notes |
|---|---|---|
| Munich, Hamburg, Frankfurt, Stuttgart | Baseline | Highest cost; highest local infrastructure |
| Berlin, Düsseldorf, Cologne | −10–15% | Still high; but lower than top tier |
| Leipzig, Dresden, Erfurt, Magdeburg | −30–40% | East Germany; lower housing costs, same healthcare |
| Rural Sachsen, Thüringen, Sachsen-Anhalt, Mecklenburg-Vorpommern | −40–55% | Lowest cost within Germany; good infrastructure for online workers |

**EU destinations (maintaining EU mobility rights):**

| Country/Region | COL vs. German average | Key notes |
|---|---|---|
| Portugal (Lissabon, Porto) | −20–30% | NHR tax regime phasing out for new applicants; check current status |
| Portugal (Madeira, Algarve) | −30–40% | Lower cost than Lisbon; warm climate |
| Spain (Canary Islands — Las Palmas, Tenerife) | −30–40% | EU, warm, lower housing cost; IGIC (lower than mainland VAT) |
| Croatia (Zadar, Split) | −40–55% | EU member since 2013; growing expat community; Schengen |
| Romania (Bukarest, Cluj) | −55–65% | Very low cost; EU; good internet infrastructure |
| Estonia (Tallinn) | −20–30% | EU, digital infrastructure, e-Residency |
| Hungary (Budapest) | −45–55% | EU; low cost; note political/institutional risk |

**Non-EU destinations (note German tax implications):**

| Destination | COL reduction | Key German tax warning |
|---|---|---|
| Thailand | −55–70% | Germany–Thailand DBA: German-source income (GRV, bAV) remains taxable in Germany |
| Georgia (Tbilisi) | −60–75% | No DBA with Germany; risk of dual taxation on German-source income |
| Mexico (CDMX, Oaxaca, Mérida) | −50–65% | DBA exists; German-source pension taxed in Germany |

**Critical German expat tax rule:**

If you maintain a **Wohnsitz** (registered domicile) or **gewöhnlicher Aufenthalt** (habitual abode) in Germany, you remain **unbeschränkt steuerpflichtig** — fully liable to German income tax on worldwide income regardless of where you live.

To escape German tax liability:
1. Formally **deregister (Abmeldung)** at your Einwohnermeldeamt
2. Give up your German residence (Wohnsitz)
3. Establish domicile in a lower-tax country
4. Note: Germany has Doppelbesteuerungsabkommen (DBA) with most countries — check your destination's DBA for treatment of GRV pension, bAV, capital income

Even after Abmeldung, GRV pension income is typically still taxable in Germany (as Rentenbesteuerung applies to German-source income per §49 EStG).

---

### 6. FIRE-Timeline-Berechnung

**Years to FIRE formula (with existing portfolio):**
```
n = ln((FIRE-Zahl − PV × (1+r) / PMT + PMT/r) / (PMT/r)) / ln(1+r)

Where:
  FIRE-Zahl = target portfolio (GRV-adjusted)
  PV = current portfolio value
  PMT = annual savings (Jahressparrate)
  r = assumed real return rate (net of inflation)
```

**Savings rate → years to FIRE reference table** (assumes 5% real return, starting from €0):

| Sparquote | Jahre bis FIRE |
|---|---|
| 5% | 66 |
| 10% | 51 |
| 15% | 43 |
| 20% | 37 |
| 25% | 32 |
| 30% | 28 |
| 35% | 25 |
| 40% | 22 |
| 45% | 19 |
| 50% | 17 |
| 55% | 14.5 |
| 60% | 12.5 |
| 65% | 10.5 |
| 70% | 8.5 |
| 75% | 7 |
| 80% | 5.5 |

**The single biggest lever: savings rate.** Going from 10% → 50% cuts time from 51 → 17 years. Existing portfolio shortens timeline further.

**Sensitivity analysis:** calculate years to FIRE at:
- Return assumption 5% (conservative: MSCI World long-run minus inflation)
- Return assumption 7% (optimistic)
- Spending reduction of 10% vs. 20% (Lean FIRE path)

---

## Output

Write a file `FINANCE-FIRE.md` to the current working directory with the following structure:

```markdown
# FIRE-Plan — Finanzielle Unabhängigkeit
**Erstellt:** [Datum]
**Aktuelles Alter:** XX | **Ziel-FIRE-Alter:** XX | **Monatl. Entnahmebedarf:** €X,XXX | **Sparquote:** XX%

## Zusammenfassung (Executive Summary)
- **FIRE-Variante:** [Lean / Standard / Fat / Coast / Barista]
- **FIRE-Zahl (unadjustiert, 4%-Regel):** €X
- **FIRE-Zahl (GRV-adjustiert, empfohlen):** €X
- **Aktuelles Depot:** €X (X% der FIRE-Zahl)
- **Jahre bis FIRE bei aktueller Sparquote:** X Jahre (FIRE-Alter: XX)
- **Coast FIRE-Zahl heute:** €X — [erreicht ✅ / noch €X fehlend ❌]
- **Urteil:** [Auf Kurs / Sparquote erhöhen nötig / Bereits FIRE]

## Ihre Kennzahlen

### Eingaben
| Kennzahl | Wert |
|---|---|
| Aktuelles Alter | XX |
| Ziel-FIRE-Alter | XX |
| Monatlicher Entnahmebedarf | €X,XXX |
| Aktuelles investiertes Vermögen | €X |
| Monatliche Sparrate | €X |
| Sparquote (netto) | XX% |
| Erwartete Realrendite | X% |
| DRV Entgeltpunkte (bisher) | XX |
| Krankenversicherung | GKV / PKV |

### FIRE-Zahl — Alle Varianten

| Variante | Jahresausgaben | FIRE-Zahl | Jahre bis FIRE |
|---|---|---|---|
| Lean FIRE | €X (Minimum) | €X | X Jahre |
| Standard FIRE | €X (aktuell) | €X | X Jahre |
| Fat FIRE | €X (komfortabel) | €X | X Jahre |
| Coast FIRE | — | €X (heute) | — |
| Barista FIRE (50% Depot-Entnahme) | €X | €X | X Jahre |

## GKV-Kosten im frühen Ruhestand

| Szenario | Monatliche GKV + Pflege |
|---|---|
| GKV freiwillig, Mindestbeitrag (Einkommen ≤ €1,178/Monat) | ~€233/Monat |
| GKV freiwillig, Einkommen €1,500/Monat | ~€245/Monat |
| GKV freiwillig, Einkommen €2,500/Monat | ~€408/Monat |
| PKV (Schätzung bei Ihrem Alter) | €X/Monat (steigend) |

**Empfehlung:** [GKV-Mindestbeitrag durch akkumulierende ETFs anstreben / PKV-Kosten im Budget berücksichtigen]

## Rentenversicherung-Analyse

| Kennzahl | Wert |
|---|---|
| Aktuelle Entgeltpunkte | XX |
| Projizierte Entgeltpunkte bei FIRE-Alter XX | XX |
| Erwartete GRV-Rente mit 63 (45 Beitragsjahre) | €X/Monat |
| Erwartete GRV-Rente mit 67 (Regelrente) | €X/Monat |
| Fehlende Jahre für 45 Beitragsjahre (Rente mit 63) | X Jahre |
| Freiwillige Beiträge zum Lücken füllen (Schätzung) | €X/Monat × X Jahre |
| Lohnt freiwillige Einzahlung? | [Ja — KVdR-Vorteil überwiegt / Rechnen Sie nach] |

## Entnahmestrategie

**Empfohlene Entnahmereihenfolge:**
1. Taxable Depot (Wertpapierdepot) — bis ca. Alter 60–63
2. Freiwillige GRV-Beiträge falls nötig — zur Brücke bis 63/67
3. bAV / Riester / Rürup — ab vertragsgemäßem Auszahlungsbeginn
4. GRV-Rente ab 63 oder 67 — reduziert Portfolioentnahme dauerhaft

**Steueroptimierung:**
- Jahresentnahme ≤ €13,096 (Grundfreibetrag + Sparerpauschbetrag) → effektiv 0% Steuer
- Günstigerprüfung via Anlage KAP prüfen wenn Gesamteinkommen < ~€25,000/Jahr
- Freistellungsauftrag bei allen Depotbanken setzen

**Renditefolgerisiko-Puffer:**
- Tagesgeld-Puffer: X Monate Ausgaben (€X bei [DKB/ING/Trade Republic] ~3–3.5% p.a.)
- Anleihen-Anteil in den ersten 5 FIRE-Jahren: X% des Portfolios

## Jahres-Portfolio-Projektion

| Alter | Jahr | Einzahlung | Portfolio (5%) | Portfolio (7%) | % der FIRE-Zahl |
|---|---|---|---|---|---|
| XX | YYYY | €X | €X | €X | X% |
| ... | | | | | |
| FIRE-Alter | YYYY | €0 | €X | €X | 100% |

## Sparquote-Hebel

| Sparquote | Jahre bis FIRE | FIRE-Alter |
|---|---|---|
| Aktuell (XX%) | XX | XX |
| +5% (auf XX%) | XX | XX |
| +10% (auf XX%) | XX | XX |
| 50% | XX | XX |
| 70% | XX | XX |

**Kernbotschaft:** Sparquote von XX% auf XX% erhöhen (nur €X/Monat mehr) verkürzt den Weg um X Jahre.

## Geographic Arbitrage Optionen

| Ziel | Kostensenkung vs. Ihrem Wohnort | Neue Sparquote | Neue Jahre bis FIRE |
|---|---|---|---|
| Aktuell bleiben | 0% | XX% | XX Jahre |
| Ostdeutschland (ländlich) | −35–45% | XX% | XX Jahre |
| Portugal / Madeira | −25–35% | XX% | XX Jahre |
| Kanarische Inseln (Spanien) | −30–40% | XX% | XX Jahre |
| Kroatien / Rumänien | −45–60% | XX% | XX Jahre |

**Steuerwarnung Auswanderung:** Abmeldung erforderlich. GRV-Rente bleibt in Deutschland steuerpflichtig (§49 EStG). DBA des Ziellandes prüfen.

## Asset-Allokation nach FIRE-Phase

| Phase | Aktien-ETFs | Anleihen | Tagesgeld/Cash | Begründung |
|---|---|---|---|---|
| Anspar-Phase (jetzt bis FIRE −5 Jahre) | 85–90% | 5–10% | 5% | Wachstum maximieren |
| Vorruhestand (5 Jahre vor FIRE) | 70% | 20% | 10% | Anleihen-Puffer aufbauen |
| Früher Ruhestand (Jahre 1–5) | 60% | 25% | 15% | Renditefolgerisiko minimieren |
| Ruhestand (Jahre 6+) | 70–75% | 20% | 5–10% | Längerer Horizont |

## Pre-FIRE Checkliste

- [ ] 12–24 Monate Ausgaben in Tagesgeld (Renditefolgerisiko-Puffer)
- [ ] GKV-Strategie festgelegt (Mindestbeitrag oder PKV-Kosten budgetiert)
- [ ] Entnahmereihenfolge dokumentiert (Depot → bAV → GRV)
- [ ] DRV Rentenauskunft angefordert und Entgeltpunkte geprüft
- [ ] Freiwillige GRV-Beiträge geprüft (45 Beitragsjahre für Rente mit 63?)
- [ ] Freistellungsauftrag bei allen Depots gesetzt (max. €1,000 single / €2,000 verheiratet)
- [ ] Steuerstrategie für FIRE-Einkommen (Günstigerprüfung, Anlage KAP)
- [ ] Kein Konsumkredit / Dispo offen
- [ ] Berufsunfähigkeitsversicherung (BU) bis Rentenalter oder FIRE-Alter abgesichert
- [ ] Testamentarische Dokumente aktuell

## Risiken & Hinweise
- Renditefolgerisiko in den ersten 5 Jahren nach FIRE (größtes strukturelles Risiko)
- GKV-Beitragsanstieg wenn Kapital- oder Mieteinnahmen wachsen
- PKV-Prämienanstieg mit zunehmendem Alter
- Inflation über 3% p.a. dauerhaft — zehrt an realem Entnahmewert
- Rentenrechtsänderungen (Rentenalter, Entgeltpunkte-Bewertung)
- Steuerrechtsänderungen (Abgeltungsteuer, Sparerpauschbetrag)
- Lifestyle-Inflation kehrt FIRE-Mathematik um
- Soziale Identität — planen Sie "wofür" Sie in Rente gehen, nicht nur "wovon"

---
**DISCLAIMER: Nur zu Informations- und Bildungszwecken. Keine Anlage- oder Steuerberatung. Konsultieren Sie einen zugelassenen Finanzberater und Steuerberater, bevor Sie Entscheidungen treffen.**
```

## Quality Standards
- Always calculate FIRE-Zahl both unadjusted AND GRV-adjusted; show both
- Always quantify GKV costs in early retirement (freiwillig versichert vs. PKV)
- Always run Rentenversicherung gap analysis (current Entgeltpunkte → projected pension at 63 and 67)
- Always include savings rate sensitivity table
- Always include the withdrawal sequence (Depot first, then bAV/Riester/Rürup, then GRV)
- All amounts in EUR; no USD, no US account types, no US geographic arbitrage cities
- Reference 2026 values from german-context.md (€39.32 Rentenwert, €1,178 GKV Mindestbemessungsgrundlage, €12,096 Grundfreibetrag, €1,000 Sparerpauschbetrag)
- Flag any assumption made due to missing data

## Handoff
After writing FINANCE-FIRE.md:
1. State the user's FIRE-Zahl (both variants) and years to FIRE
2. Identify the #1 lever (Sparquote increase, geographic move, or GRV bridge strategy)
3. Suggest `/finance budget` if Sparquote needs to climb
4. Suggest `/finance retirement` for full statutory retirement comparison
5. Suggest `/finance networth` if Vermögen data was incomplete

**DISCLAIMER: Nur zu Informations- und Bildungszwecken. Keine Anlage- oder Steuerberatung. Konsultieren Sie einen zugelassenen Finanzberater und Steuerberater, bevor Sie Entscheidungen treffen.**
