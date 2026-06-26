---
name: finance-fire
description: FIRE (Finanzielle Unabhängigkeit / frühzeitig in Rente) calculator for German Angestellte and Frugalisten. Calculates FIRE-Zahl, years-to-FIRE, GKV costs in early retirement, Rentenversicherung bridge strategy, tax-efficient Entnahmestrategie, and geographic arbitrage options within Germany and Europe. Use when the user says "/finance fire", "finanzielle Unabhängigkeit", "frühzeitig in Rente", "FIRE-Zahl", "Frugalist", "Entnahmeportfolio", "Lean FIRE", "Fat FIRE", "Coast FIRE", "früher Ruhestand", "Rente mit 40/45/50/55", or any early retirement question in a German financial context.
---

# Finance FIRE — Financial Independence for German Investors

**DISCLAIMER: For educational/informational purposes only. Not investment or tax advice. Consult a licensed financial advisor and tax advisor before making decisions.**

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
| 3 | Entgeltpunkte (pension credit points) from statutory pension insurance (Rentenversicherung) | DRV Entgeltpunkte (aus Rentenauskunft) | Find on DRV Kontoauszug (rentenversicherung.de); estimate if not available |
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

### 1. Calculating Your FIRE Number (FIRE-Zahl)

**Base formula (Trinity Study / 4% rule):**
```
FIRE number = Annual spending requirement × 25
```

**German-adjusted formula (recommended — accounts for statutory pension floor):**
```
Monthly statutory pension (GRV) = Entgeltpunkte × €39.32  (current pension value West 2026)
Annual statutory pension (GRV) = Monthly GRV × 12

Net drawdown requirement = Annual spending requirement − Annual GRV pension
FIRE number (GRV-adjusted) = Net drawdown requirement × 25
```

**Why this matters:** German statutory pension insurance (Rentenversicherung) provides a baseline income from age 67 (standard retirement age (Regelrentenalter)) or 63 (with 45 contribution years (Beitragsjahre)). This floor reduces the portfolio you must accumulate vs. a FIRE calc that ignores public pension income.

**Example:**
- Monthly target spending: €2,500 → €30,000/year
- Projected GRV at 67: 32 Entgeltpunkte × €39.32 = €1,258/month → €15,100/year
- Net portfolio need: €30,000 − €15,100 = €14,900/year
- **FIRE number: €14,900 × 25 = €372,500** (vs. €750,000 without GRV offset)

**FIRE variants in EUR context:**

| Variant | Description | Typical spending range |
|---|---|---|
| Lean FIRE | Minimalist lifestyle, no luxury spending | €1,000–€1,800/month |
| Standard FIRE | Comfortable middle-class lifestyle | €1,800–€3,500/month |
| Fat FIRE | Upscale lifestyle, travel, hobbies | €3,500–€7,000+/month |
| Coast FIRE | Portfolio large enough to grow to FIRE target by 67 without further contributions | — |
| Barista FIRE / Semi-FIRE | Part-time work covers current expenses; portfolio grows or supplements | — |

**Coast FIRE number:**
```
Coast FIRE number = FIRE number / (1 + r)^(67 − current_age)
```
Use r = 5–7% real return. If your current Depot already exceeds this number, you can stop investing and still reach FIRE by 67.

**Conservative withdrawal rate for long retirements (40+ years):**
- 4% rule (× 25 multiplier): ~85–90% success rate historically over 50 years
- 3.5% rule (× 28.5 multiplier): ~95%+ success rate; recommended for early retirees under 45
- Dynamic approach: withdraw 3.5–4% but flex down in bad market years

---

### 2. GKV in Early Retirement (Critical Germany-Specific Section)

This is the most important cost that non-German FIRE calculations ignore entirely. Budget this carefully.

**Scenario A — GKV member (voluntarily insured before standard retirement age):**

Before reaching statutory pension age, early retirees on GKV are classified as **freiwillig versichert** (not KVdR — statutory health insurance in retirement (KVdR)). KVdR only applies after Rentenalter and requires meeting the 9/10 rule (90% of the second half of working life in GKV).

Key rules for voluntarily insured members:
- **Minimum assessment base 2026:** €1,178/month → **Minimum GKV contribution: ~€193/month** even with zero income (16.3% × €1,178)
- If your withdrawal income exceeds €1,178/month: full 16.3% applies to ALL income types:
  - Capital gains (dividends, ETF Vorabpauschale distributions)
  - Rental income
  - bAV distributions
  - Riester/Rürup payouts (counted as Versorgungsbezüge — at 14.6% + Zusatzbeitrag)
- **Pflegeversicherung:** Additional ~3.4% (or 3.05% with children) on the same base — minimum adds ~€40/month

**Strategy: Keep taxable income below €1,178/month → pay only minimum ~€193 GKV + ~€40 Pflege = ~€233/month total.**

This is achievable with accumulating ETFs (e.g., iShares MSCI World SWDA, ISIN IE00B4L5Y983) that do not distribute dividends — only the annual Vorabpauschale is assessed, often minimal.

**Scenario B — PKV member:**
- PKV premiums continue regardless of income — typically €400–€900/month in early retirement depending on age and tariff
- PKV premiums rise significantly with age (especially 50–70)
- No minimum-base advantage; no income-dependent contribution
- Budget PKV as a fixed and rising cost — stress-test your FIRE number at PKV + 50% for age-related increases

**GKV cost planning table:**

| Income level (voluntarily insured GKV) | GKV + Pflege monthly cost (est.) |
|---|---|
| €0 – €1,178/month (minimum base) | ~€233/month |
| €1,500/month | ~€245/month (16.3% × 1,500) |
| €2,000/month | ~€326/month |
| €3,000/month | ~€489/month |

Include GKV/Pflege cost as a fixed line item in your FIRE budget.

---

### 3. Statutory Pension Bridge Strategy (Rentenversicherung-Brückenstrategie)

**The problem:** If you stop working at, say, age 48, you may accumulate fewer than 45 Beitragsjahre — meaning:
- No early retirement via early retirement for long-term contributors (Altersrente für besonders langjährig Versicherte) at 63 without deductions
- Potential reduction in eventual pension amount
- Possible loss of KVdR eligibility (which provides much cheaper GKV in full retirement)

**Option A: Voluntary contributions to statutory pension insurance (Freiwillige Beiträge zur Rentenversicherung)**

After leaving employment, you can voluntarily pay into GRV:
- 2026 range: **€100.07–€1,404.90/month**
- Each month at average earnings (ca. €506/month in 2026) adds approximately 0.08 Entgeltpunkte
- Purpose: (a) reach 45 Beitragsjahre for penalty-free early pension at 63, (b) increase monthly pension amount, (c) satisfy KVdR eligibility (9/10 rule)
- Worth calculating: cost of filling gap years vs. value of KVdR (saves ~€100–€300/month in GKV contributions from 63 onward)

**Early pension milestones:**

| Milestone | Age | Beitragsjahre required | Deductions |
|---|---|---|---|
| Early retirement for long-term contributors (Altersrente für besonders langjährig Versicherte) | 63 | 45 years | None |
| Altersrente für langjährig Versicherte | 65 | 35 years | None |
| Standard retirement (Regelrente) | 67 | Any | None |
| Early exit with deductions | Before standard retirement age | 35+ years | 0.3% per month early (max 14.4%) |

**Entgeltpunkte projection formula:**
```
Annual Entgeltpunkte ≈ Annual gross income / Durchschnittsentgelt
(Durchschnittsentgelt 2026 ≈ €45,358)

Projected GRV monthly income = Total Entgeltpunkte × €39.32
```

Calculate: current Entgeltpunkte + projected points if working until FIRE age → monthly GRV at 63 vs. 67.

---

### 4. Drawdown Plan (Entnahmestrategie) — Withdrawal Strategy

**Optimal withdrawal sequence for German FIRE-seekers:**

**Phase 1 — FIRE to ~60 (use taxable Depot first):**
- Draw from taxable Depot (Wertpapierdepot)
- Tax treatment: flat-rate withholding tax (Abgeltungsteuer) 26.375% on gains; Teilfreistellung reduces taxable base by 30% for equity ETFs
- Favorable-rate check (Günstigerprüfung) opportunity: if total income (including capital income) is below ~€25,000/year, filing Anlage KAP via ELSTER may result in capital income being taxed at marginal rate (14–25%) instead of flat 26.375%
- Use Sparerpauschbetrag (annual tax-free investment allowance) (€1,000 single / €2,000 married) annually — set Freistellungsauftrag at each broker

**Tax-efficient withdrawal target:**
```
Optimal annual withdrawal ≤ Grundfreibetrag (basic tax-free allowance) + Sparerpauschbetrag
                          = €12,096 + €1,000 = €13,096 (single, 2026)
→ effective income tax: near zero
```

For higher spending needs, structure withdrawals to stay in the 14–20% marginal rate bracket.

**Phase 2 — age 60–63 (bridge to early pension):**
- Consider voluntary statutory pension contributions to reach 45 Beitragsjahre
- Continue taxable Depot drawdown
- Evaluate bAV distributions if contractually accessible (most bAV not accessible before Rentenalter)

**Phase 3 — from age 63/67 (GRV kicks in):**
- GRV income supplements or replaces portfolio withdrawals
- bAV/Riester/Rürup distributions begin (taxed as Sonstige Einkünfte at marginal rate — not Abgeltungsteuer)
- Portfolio withdrawal rate can decrease substantially once GRV flows

**Vorabpauschale note:**
- Accumulating ETFs trigger annual Vorabpauschale (notional tax on unrealized gains)
- Broker deducts automatically from cash in account
- In FIRE with low income, favorable-rate check (Günstigerprüfung) may recover over-withheld tax via Steuererklärung
- Distributing ETFs (e.g., Vanguard FTSE All-World VWRL, ISIN IE00B3RBWM25) generate real dividend cash — useful for income but count toward GKV income assessment

**Withdrawal strategies:**

| Strategy | SWR | FIRE number multiplier | Recommendation |
|---|---|---|---|
| 4% rule (Trinity Study) | 4.0% | 25× | Standard; ~85–90% success rate over 50 years |
| 3.5% rule | 3.5% | 28.5× | Recommended for retirement under age 45 |
| Dynamic drawdown (% of current portfolio) | variable | — | Never depletes capital; income fluctuates |
| Guyton-Klinger Guard Rails | 5% start | — | Higher initial rate with adjustment mechanism |
| Bucket strategy | — | — | Tagesgeld (1–2 yrs) + bonds (3–7 yrs) + equity ETF (8+ yrs) |

**Sequence of Returns Risk (Renditefolgerisiko):**
- First 5 years post-FIRE are highest risk — a severe bear market early in retirement dramatically increases portfolio failure probability
- Mitigation:
  1. Tagesgeld buffer: 1–2 years spending in instant-access savings (DKB, ING, Trade Republic Tagesgeld ~3–3.5% p.a.)
  2. Bond allocation: Hold 3–5 years expenses in EU government bonds or bond ETFs
  3. Flexible withdrawal: Reduce discretionary spending in down years
  4. Semi-FIRE / Barista FIRE: Part-time income buffers early years

---

### 5. Geographic Arbitrage for German FIRE Investors

**Within Germany:**

| Region | Cost vs. Munich/Hamburg | Notes |
|---|---|---|
| Munich, Hamburg, Frankfurt, Stuttgart | Baseline | Highest cost; highest local infrastructure |
| Berlin, Düsseldorf, Cologne | −10–15% | Still high; but lower than top tier |
| Leipzig, Dresden, Erfurt, Magdeburg | −30–40% | East Germany; lower housing costs, same healthcare |
| Rural Sachsen, Thüringen, Sachsen-Anhalt, Mecklenburg-Vorpommern | −40–55% | Lowest cost within Germany; good infrastructure for online workers |

**EU destinations (maintaining EU mobility rights):**

| Country/Region | Cost of living vs. German average | Key notes |
|---|---|---|
| Portugal (Lissabon, Porto) | −20–30% | NHR tax regime phasing out for new applicants; check current status |
| Portugal (Madeira, Algarve) | −30–40% | Lower cost than Lisbon; warm climate |
| Spain (Canary Islands — Las Palmas, Tenerife) | −30–40% | EU, warm, lower housing cost; IGIC (lower than mainland VAT) |
| Croatia (Zadar, Split) | −40–55% | EU member since 2013; growing expat community; Schengen |
| Romania (Bukarest, Cluj) | −55–65% | Very low cost; EU; good internet infrastructure |
| Estonia (Tallinn) | −20–30% | EU, digital infrastructure, e-Residency |
| Hungary (Budapest) | −45–55% | EU; low cost; note political/institutional risk |

**Non-EU destinations (note German tax implications):**

| Destination | Cost reduction | Key German tax warning |
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

### 6. FIRE Timeline Calculation

**Years to FIRE formula (with existing portfolio):**
```
n = ln((FIRE number − PV × (1+r) / PMT + PMT/r) / (PMT/r)) / ln(1+r)

Where:
  FIRE number = target portfolio (GRV-adjusted)
  PV = current portfolio value
  PMT = annual savings
  r = assumed real return rate (net of inflation)
```

**Savings rate → years to FIRE reference table** (assumes 5% real return, starting from €0):

| Savings rate | Years to FIRE |
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
# FIRE Plan — Financial Independence
**Created:** [Date]
**Current Age:** XX | **Target FIRE Age:** XX | **Monthly spending target:** €X,XXX | **Savings rate:** XX%

## Summary (Executive Summary)
- **FIRE Variant:** [Lean / Standard / Fat / Coast / Barista]
- **FIRE Number (unadjusted, 4% rule):** €X
- **FIRE Number (GRV-adjusted, recommended):** €X
- **Current Depot:** €X (X% of FIRE number)
- **Years to FIRE at current savings rate:** X years (FIRE age: XX)
- **Coast FIRE number today:** €X — [reached ✅ / €X still needed ❌]
- **Assessment:** [On track / Savings rate increase needed / Already FIRE]

## Your Key Figures

### Inputs
| Metric | Value |
|---|---|
| Current Age | XX |
| Target FIRE Age | XX |
| Monthly spending target | €X,XXX |
| Current invested assets | €X |
| Monthly savings | €X |
| Savings rate (net) | XX% |
| Expected real return | X% |
| DRV Entgeltpunkte (to date) | XX |
| Health insurance | GKV / PKV |

### FIRE Number — All Variants

| Variant | Annual spending | FIRE Number | Years to FIRE |
|---|---|---|---|
| Lean FIRE | €X (minimum) | €X | X years |
| Standard FIRE | €X (current) | €X | X years |
| Fat FIRE | €X (comfortable) | €X | X years |
| Coast FIRE | — | €X (today) | — |
| Barista FIRE (50% portfolio drawdown) | €X | €X | X years |

## GKV Costs in Early Retirement

| Scenario | Monthly GKV + Pflege |
|---|---|
| GKV voluntary, minimum contribution (income ≤ €1,178/month) | ~€233/month |
| GKV voluntary, income €1,500/month | ~€245/month |
| GKV voluntary, income €2,500/month | ~€408/month |
| PKV (estimate at your age) | €X/month (rising) |

**Recommendation:** [Target GKV minimum via accumulating ETFs / Budget PKV costs]

## Statutory Pension Analysis (Rentenversicherung)

| Metric | Value |
|---|---|
| Current Entgeltpunkte | XX |
| Projected Entgeltpunkte at FIRE age XX | XX |
| Expected GRV pension at 63 (45 contribution years) | €X/month |
| Expected GRV pension at 67 (standard retirement) | €X/month |
| Years missing for 45 contribution years (pension at 63) | X years |
| Voluntary contributions to fill gap (estimate) | €X/month × X years |
| Is voluntary contribution worthwhile? | [Yes — KVdR advantage outweighs / Calculate further] |

## Drawdown Plan (Entnahmestrategie)

**Recommended withdrawal sequence:**
1. Taxable Depot (Wertpapierdepot) — until approximately age 60–63
2. Voluntary GRV contributions if needed — to bridge to 63/67
3. bAV / Riester / Rürup — from contractual payout start date
4. GRV pension from 63 or 67 — permanently reduces portfolio drawdown

**Tax optimization:**
- Annual withdrawal ≤ €13,096 (Grundfreibetrag + Sparerpauschbetrag) → effectively 0% tax
- Check favorable-rate check (Günstigerprüfung) via Anlage KAP when total income < ~€25,000/year
- Set Freistellungsauftrag at all brokers

**Sequence of returns risk buffer:**
- Tagesgeld buffer: X months expenses (€X at [DKB/ING/Trade Republic] ~3–3.5% p.a.)
- Bond allocation in first 5 FIRE years: X% of portfolio

## Annual Portfolio Projection

| Age | Year | Contribution | Portfolio (5%) | Portfolio (7%) | % of FIRE Number |
|---|---|---|---|---|---|
| XX | YYYY | €X | €X | €X | X% |
| ... | | | | | |
| FIRE age | YYYY | €0 | €X | €X | 100% |

## Savings Rate Lever

| Savings rate | Years to FIRE | FIRE age |
|---|---|---|
| Current (XX%) | XX | XX |
| +5% (to XX%) | XX | XX |
| +10% (to XX%) | XX | XX |
| 50% | XX | XX |
| 70% | XX | XX |

**Key message:** Raising savings rate from XX% to XX% (only €X/month more) shortens the path by X years.

## Geographic Arbitrage Options

| Destination | Cost reduction vs. your location | New savings rate | New years to FIRE |
|---|---|---|---|
| Stay current | 0% | XX% | XX years |
| East Germany (rural) | −35–45% | XX% | XX years |
| Portugal / Madeira | −25–35% | XX% | XX years |
| Canary Islands (Spain) | −30–40% | XX% | XX years |
| Croatia / Romania | −45–60% | XX% | XX years |

**Expat tax warning:** Abmeldung required. GRV pension remains taxable in Germany (§49 EStG). Check DBA of destination country.

## Asset Allocation by FIRE Phase

| Phase | Equity ETFs | Bonds | Tagesgeld/Cash | Rationale |
|---|---|---|---|---|
| Accumulation phase (now to FIRE −5 years) | 85–90% | 5–10% | 5% | Maximize growth |
| Pre-retirement (5 years before FIRE) | 70% | 20% | 10% | Build bond buffer |
| Early retirement (years 1–5) | 60% | 25% | 15% | Minimize sequence of returns risk |
| Retirement (years 6+) | 70–75% | 20% | 5–10% | Longer horizon |

## Pre-FIRE Checklist

- [ ] 12–24 months expenses in Tagesgeld (sequence of returns risk buffer)
- [ ] GKV strategy confirmed (minimum contribution or PKV costs budgeted)
- [ ] Withdrawal sequence documented (Depot → bAV → GRV)
- [ ] DRV pension statement requested and Entgeltpunkte verified
- [ ] Voluntary GRV contributions evaluated (45 contribution years for pension at 63?)
- [ ] Freistellungsauftrag set at all brokers (max. €1,000 single / €2,000 married)
- [ ] Tax strategy for FIRE income (favorable-rate check, Anlage KAP)
- [ ] No consumer debt / overdraft outstanding
- [ ] Occupational disability insurance (BU) covered until retirement or FIRE age
- [ ] Estate documents up to date

## Risks & Notes
- Sequence of returns risk in the first 5 years after FIRE (largest structural risk)
- GKV contribution increase if capital or rental income grows
- PKV premium increases with advancing age
- Inflation above 3% p.a. sustained — erodes real drawdown value
- Pension law changes (retirement age, Entgeltpunkte valuation)
- Tax law changes (Abgeltungsteuer, Sparerpauschbetrag)
- Lifestyle inflation reverses FIRE math
- Social identity — plan "what for" you retire, not just "what from"

---
**DISCLAIMER: For educational/informational purposes only. Not investment or tax advice. Consult a licensed financial advisor and tax advisor before making decisions.**
```

## Quality Standards
- Always calculate FIRE number both unadjusted AND GRV-adjusted; show both
- Always quantify GKV costs in early retirement (voluntarily insured vs. PKV)
- Always run statutory pension gap analysis (current Entgeltpunkte → projected pension at 63 and 67)
- Always include savings rate sensitivity table
- Always include the withdrawal sequence (Depot first, then bAV/Riester/Rürup, then GRV)
- All amounts in EUR; no USD, no US account types, no US geographic arbitrage cities
- Reference 2026 values from german-context.md (€39.32 Rentenwert, €1,178 GKV Mindestbemessungsgrundlage, €12,096 Grundfreibetrag, €1,000 Sparerpauschbetrag)
- Flag any assumption made due to missing data

## Handoff
After writing FINANCE-FIRE.md:
1. State the user's FIRE number (both variants) and years to FIRE
2. Identify the #1 lever (savings rate increase, geographic move, or statutory pension bridge strategy)
3. Suggest `/finance budget` if savings rate needs to climb
4. Suggest `/finance retirement` for full statutory retirement comparison
5. Suggest `/finance networth` if asset data was incomplete

**DISCLAIMER: For educational/informational purposes only. Not investment or tax advice. Consult a licensed financial advisor and tax advisor before making decisions.**
