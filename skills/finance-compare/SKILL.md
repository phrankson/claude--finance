---
name: finance-compare
description: Side-by-side comparison of two financial decisions for German clients. Trigger phrases: "soll ich kaufen oder mieten", "rent vs buy Germany", "GKV oder PKV", "ETF vs Fonds", "leasing vs kaufen Auto", "should I lease or buy", "is it worth buying a home in [German city]", "Preis-Miet-Verhältnis", "lohnt sich kaufen", "compare financial options Germany". Collects German-specific inputs (Bundesland, Kaufpreis, JAEG threshold, TER, Leasingrate), runs cost and opportunity-cost modelling with German tax and cost assumptions, and saves a structured recommendation to FINANCE-COMPARE.md.
---

# Finance Compare — Financial Decision Comparison

**DISCLAIMER: For educational and informational purposes only. Not financial, tax, or legal advice. Consult a licensed Steuerberater, Finanzberater, or Rechtsanwalt before making major financial decisions. All projections rely on assumptions that may not hold.**

## When to Run

- User asks "soll ich kaufen oder mieten?" or any rent-vs-buy question in a German city
- User asks "GKV oder PKV — was lohnt sich für mich?"
- User wants to compare an ETF against an actively managed fund (Fonds)
- User asks whether to lease or buy (finance/bar) a car in Germany
- User asks "should I X or Y?" where both are financial choices with German context
- User types `/finance compare <scenario1> <scenario2>`

## Data Collection

Ask only what is needed for the chosen scenario. Identify the comparison type first, then collect the relevant inputs.

**Step 1 — What are they comparing?**

| Code | Comparison |
|------|-----------|
| RvB | Mieten vs Kaufen (rent vs buy) |
| GvP | GKV vs PKV |
| EvF | ETF vs aktiv gemanagter Fonds |
| LvK | Auto: Leasing vs Kauf (Finanzierung oder bar) |
| OTH | Other — describe both options |

**Step 2 — Scenario-specific inputs**

**For Mieten vs Kaufen (RvB):**
- Purchase price (Kaufpreis) (€)
- Equivalent Kaltmiete for the same property (€/month)
- Bundesland (required for Grunderwerbsteuer)
- Available down payment / Eigenkapital (€)
- Planned tenure / Wohndauer (years)
- Current mortgage rate offer if known (otherwise use 3.5–4.5% range from shared context)
- Is a Makler involved? (affects buyer's Maklercourtage)

**For GKV vs PKV:**
- Annual gross income / Jahresbruttolohn (€) — must exceed JAEG €73,800 to be PKV-eligible
- Age (Alter)
- Health status (gut, Vorerkrankungen?)
- Family situation: Kinder? Ehepartner berufstätig oder nicht?
- Employment type: Angestellte/r or Selbstständige/r?
- PKV offer already received? (monthly premium, Leistungsniveau)

**For ETF vs aktiv gemanagter Fonds (EvF):**
- Current fund name and ISIN
- Current fund TER (%)
- Current fund Ausgabeaufschlag (%)
- Fund performance gross over 5–10 years (if available)
- Comparison ETF (or use iShares MSCI World SWDA as default)
- Investment amount and horizon (€, years)

**For Auto: Leasing vs Kauf (LvK):**
- Vehicle value / Listenpreis (€)
- Monthly Leasingrate (€) and upfront Sonderzahlung (€)
- Term (Laufzeit) in months and Restwert at end (€)
- Annual mileage limit (Kilometergrenze) and penalty per excess km (€/km)
- Alternative: cash purchase available? Or financing (Effektivzins, Laufzeit)?
- Usage: private only, or partly business (>50% business triggers 1%-Methode / Fahrtenbuch)

## Comparison Framework

Before analysis, read `.claude/skills/shared/german-context.md` for German real estate costs, tax rates, and benchmarks.

---

### 1. Mieten vs Kaufen (Rent vs Buy)

This is the most consequential comparison for most German clients. Germany has one of the lowest homeownership rates in the EU (~45%); renting long-term is a legitimate and often financially rational choice.

#### Key metric: Preis-Miet-Verhältnis (P/M ratio)

```
P/M ratio = Kaufpreis ÷ (Kaltmiete × 12)
```

This is the price-to-rent ratio expressed in years of rent. It is the primary filter before detailed modelling.

**German city benchmarks (2026, approximate):**

| City | Typical P/M range | Interpretation |
|------|------------------|----------------|
| München | 38–50× | Almost always better to rent financially |
| Hamburg | 30–38× | Renting favoured; buying needs long horizon |
| Berlin | 28–38× | Renting favoured in most districts |
| Frankfurt | 28–35× | Renting favoured |
| Köln | 25–32× | Borderline; depends on horizon and rate |
| Düsseldorf | 24–30× | Borderline |
| Smaller cities, rural | 15–25× | Buying often makes sense |

**Rule of thumb:**
- P/M > 30 and planned tenure < 10 years → renting almost always financially superior
- P/M < 20 and planned tenure > 10 years → buying often makes financial sense
- P/M 20–30 → detailed break-even modelling required

#### Buy-side costs

**One-off purchase transaction costs (Kaufnebenkosten) — non-recoverable at purchase:**

| Cost | Rate | Notes |
|------|------|-------|
| Grunderwerbsteuer | BY 3.5% / HH 4.5% / BE, HB, NI, SN 5.0% / BW, HE, SL, ST 5.0% / BB, MV, NW, RP, SA, SH, TH 6.5% | Applied to Kaufpreis |
| Notar + Grundbucheintrag | ~1.5–2% of Kaufpreis | Mandatory |
| Maklercourtage (buyer share) | ~1.785% incl. MwSt | Only if Makler involved; 50/50 split since Dec 2020 |
| **Total transaction costs** | **~7–12%** | Varies by Bundesland and Makler involvement |

These costs are sunk immediately and must be recouped through appreciation or rent savings before the purchase breaks even.

**Ongoing monthly buy costs:**

| Cost | Estimate | Notes |
|------|----------|-------|
| Annuität (Zins + Tilgung) | From mortgage offer | Sollzins 3–4.5% range; use shared context |
| Grundsteuer | ~€100–300/month for typical apartment | Highly variable; reform values in effect 2025 |
| Hausgeld / WEG-Rücklage | ~€2–4/m² monthly | For Eigentumswohnung in WEG |
| Maintenance reserve (self-managed house) | ~€10–15/m²/year | Spread monthly |

**Tax note for primary residence:** Mortgage interest is NOT tax-deductible for a primary residence (Eigennutzung). No equivalent to a mortgage interest deduction exists in Germany. Do not include this in any calculation.

#### Rent-side costs

| Cost | Estimate |
|------|----------|
| Kaltmiete | User-provided |
| Betriebskosten / Nebenkosten | ~€2–3/m² monthly (heating, water, Müll, Hausmeister) |

**Opportunity cost of capital:** The down payment and Kaufnebenkosten not spent on buying can be invested. Use 7% real return (MSCI World ETF long-run assumption) as the opportunity cost rate. This is the most important variable that favours renting in high-P/M cities.

#### Break-even analysis

Model year-by-year:
1. Cumulative cost of buying (Kaufnebenkosten + monthly buy costs − equity buildup from Tilgung)
2. Cumulative cost of renting + opportunity cost of invested capital foregone
3. Estimate German property appreciation (conservative: 2–3% real in most cities; do not assume higher without local data)
4. Break-even year = year when net-worth position of buyer equals or exceeds that of renter

Present as: "At current assumptions, buying breaks even at year N. If you plan to stay fewer than N years, renting is financially superior."

#### Sensitivity table for Mieten vs Kaufen

| Assumption change | Effect on break-even |
|-------------------|---------------------|
| Mortgage rate rises 1% | Break-even shifts ~2–3 years later |
| Property appreciates 0% real | Break-even shifts 5–8 years later |
| Rent inflation 3%/yr | Favours buying (rent costs grow faster) |
| Investment return drops to 4% | Favours buying (opportunity cost falls) |
| Tenure < 7 years | Almost always favours renting given Kaufnebenkosten |

---

### 2. GKV vs PKV

**Eligibility gate:** PKV is only available to Angestellte earning above the JAEG (€73,800/year gross in 2026). Confirm this first. Beamte and Selbstständige have different rules.

**GKV cost:**
- Rate: 14.6% base + ~1.7% Zusatzbeitrag = ~16.3% total (employee share ~8.15%)
- Capped at BBG West: €96,600/year → max employee GKV contribution ~€7,870/year (~€656/month)
- Non-working spouse and children covered for free under Familienversicherung
- Minimum GKV contribution base for voluntarily insured: €1,178/month

**PKV cost:**
- Depends on age, health, and chosen Tarif
- Young, healthy, single: ~€300–600/month = €3,600–7,200/year — often cheaper than GKV contribution at high income
- Each family member requires own policy (no Familienversicherung)
- Premiums increase significantly with age and claims history
- Beitragsrückerstattung available in some Tarife for claim-free years

**Key structural differences:**

| Factor | GKV | PKV |
|--------|-----|-----|
| Premium basis | Income-linked (capped at BBG) | Risk-based (age, health, Tarif) |
| Family coverage | Free for non-working spouse and children | Separate policy per person |
| Leistungsumfang | Standardised, lower | Customisable, typically better |
| Return to GKV | Possible before 55 if income drops below JAEG | Extremely difficult after 55 |
| Altersrückstellungen | None | Built into PKV premium; partially portable |
| Premium adjustments | Follows political decisions | Can rise substantially with age/inflation |

**Verdict framework:**
- Young, healthy, single, high income, no plans for children → PKV may be cheaper short-term; model premium trajectory to age 67
- Family, children, or non-working partner → GKV almost always wins due to Familienversicherung savings
- Over 40 or with Vorerkrankungen → GKV usually superior; PKV premiums accelerate
- Approaching 55 without clear GKV re-entry path → factor in lock-in risk explicitly

**Always model:** total lifetime premium trajectory to Rentenalter (67), including projected premium increases of ~4–6%/year in PKV.

---

### 3. ETF vs aktiv gemanagter Fonds

**Cost comparison:**

| Cost item | Active fund (typical) | UCITS ETF (typical) |
|-----------|----------------------|---------------------|
| TER | 1.5–2.5%/year | 0.05–0.30%/year |
| Ausgabeaufschlag | 3–5% upfront | 0% (via broker) |
| Transaction cost | Included in spread | Broker fee or Sparplan rate |

**Compounding effect of TER difference (illustrative):**

€10,000 invested at 7% gross annual return over 20 years:
- ETF at 0.20% TER → net return ~6.80% → ~€36,200
- Active fund at 1.80% TER → net return ~5.20% → ~€27,700
- Difference: ~€8,500 (~24% less wealth from the active fund)

Scale this to the user's actual investment amount and horizon.

**Performance evidence:** Per SPIVA Europe Reports, 80–90% of actively managed equity funds underperform their benchmark index after fees over 10-year periods. This is a structural headwind for active funds.

**German tax treatment is identical** for both: Abgeltungsteuer 25% + Soli (effective ~26.375%), with Teilfreistellung (30% partial exemption on equity ETF gains) on equity funds and equity ETFs. Vorabpauschale (annual notional ETF tax) applies to accumulating funds; broker handles automatically.

**Verdict:** For long-term wealth building (horizon ≥ 10 years), low-cost UCITS ETFs (Ireland or Luxembourg domicile) outperform most active funds after costs for most investors. The burden of proof is on the active fund to demonstrate consistent alpha net of fees.

**Reference ETFs from shared context:** iShares MSCI World SWDA (TER 0.20%), Xtrackers MSCI World XDWD (TER 0.13%), Vanguard FTSE All-World VWRL distributing (TER 0.22%).

---

### 4. Auto: Leasing vs Finanzierung vs Barkauf

**Leasing total cost:**
```
Total Leasing Cost = (Leasingrate × Laufzeit) + Sonderzahlung
```
At end: nothing owned. Car returned. Additional charges for excess mileage (Kilometerüberschreitung) (typically €0.10–0.20/km over limit) and wear damage (Verschleißschäden).

**Financing (Ratenkredit) total cost:**
```
Total Financing Cost = Kaufpreis + Total Interest (Effektivzins × Laufzeit)
```
At end: car owned, has residual value.

**Cash purchase total cost:**
```
Total Cash Purchase Cost = Kaufpreis − Opportunity Cost of Capital
Opportunity Cost = Kaufpreis × (investment return rate) × years
```
Cheapest in nominal terms if capital is available and not needed for higher-return uses.

**Key comparison metric:** total-cost-of-ownership over Laufzeit, then divide by months for monthly equivalent.

**German tax consideration (business use only):**
- If car used >50% for business: can apply 1%-Methode (1% of Listenpreis/month as taxable benefit) or Fahrtenbuch
- For purely private use: no tax deduction; this variable is irrelevant
- Elektroauto: 0.25%-Methode if Listenpreis ≤ €70,000 (check current BMF guidance)

**Verdict framework:**
- Private use, capital available: cash purchase or low-Effektivzins financing almost always cheapest
- Leasing is rational when: new car every 3 years is a preference, business deduction applies, or working capital must be preserved
- Never compare Leasingrate alone to loan payment — this ignores that leasing builds zero equity

---

## Output

Save to `FINANCE-COMPARE.md` in the current working directory.

```markdown
# Financial Decision: [Scenario A] vs [Scenario B]

**Comparison:** [One-sentence framing in English]
**Time horizon:** [X] years
**Created:** [Date]
**Bundesland / Location:** [if applicable]

> **DISCLAIMER:** For educational and informational purposes only. Not financial, tax, or legal advice.

---

## Executive Summary

**Recommendation:** [Option A or B] — [one-sentence reason]
**Confidence:** [High / Medium / Low]
**Deciding factor:** [The single metric that tips the decision]

---

## Option A: [Name]

**Assumptions:**
- [List each assumption with value and source]

**Cost overview:**
| Item | One-off (€) | Monthly (€) | Over [X] years (€) |
|--------|-------------|--------------|-------------------|
| [Item] | | | |

**Net worth after [X] years:** €[X]
**Total costs after [X] years:** €[X]
**Net position:** €[X]

---

## Option B: [Name]

[Same structure as Option A]

---

## Direct Comparison

| Metric | Option A | Option B | Better |
|----------|----------|----------|--------|
| Total costs ([X] years) | €X | €X | A/B |
| Net worth / residual value | €X | €X | A/B |
| Net position | €X | €X | A/B |
| Monthly outlay | €X | €X | A/B |
| Opportunity cost | €X | €X | A/B |
| Tax burden | €X | €X | A/B |
| Liquidity (1–10) | X | X | A/B |
| Concentration risk | X | X | A/B |
| Reversibility | X | X | A/B |

---

## Opportunity Cost Analysis

[If Option A costs €X more per month than Option B, investing that difference at 7% real return over N years compounds to €Y. That is the true cost of choosing Option A.]

---

## Break-Even Analysis

[Option A becomes cheaper than Option B at year N, assuming [key assumption]. Break-even shifts to year M if [sensitivity condition].]

---

## Sensitivity Analysis

| If this changes | Recommendation shifts to |
|-----------------------|--------------------------|
| [Assumption change] | [Option] |
| [Assumption change] | [Option] |
| [Assumption change] | [Option] |

---

## Recommendation

**Choose [Option A or B].**

**Rationale:**
1. [Primary reason with number]
2. [Secondary reason]
3. [Tie-breaker or non-financial factor]

**Caveats:**
- [What would change this recommendation]
- [Non-financial factors the model cannot capture: lifestyle, Lebensplanung, job security, family plans]
- [Model limitations and assumptions that may not hold]

---

## Next Steps

1. [Specific, concrete action — e.g., "Request personalised mortgage offer from Interhyp or Dr. Klein"]
2. [Specific, concrete action]
3. [Specific, concrete action]

---

**DISCLAIMER:** For educational and informational purposes only. Not financial, tax, or legal advice. Consult a licensed Steuerberater, unabhängiger Finanzberater (with Honorarberatung), or Rechtsanwalt before making major financial decisions. All projections rely on assumptions that may not hold.
```

## Quality Standards

- All monetary amounts in € (euros). No dollar amounts.
- All cost rates sourced from `.claude/skills/shared/german-context.md` or labelled as estimates.
- Grunderwerbsteuer must use the correct Bundesland rate — never a generic figure.
- P/M ratio must be computed and stated explicitly for any Mieten vs Kaufen comparison.
- Opportunity cost of down payment must be shown separately, not omitted.
- For GKV vs PKV: confirm JAEG eligibility before modelling. Flag Familienversicherung implications clearly.
- For ETF vs Fonds: show the compounding TER difference table at the user's actual investment amount.
- Do not assume mortgage interest is tax-deductible for primary residence (it is not in Germany).
- Do not reference HOA fees (no German equivalent; use Hausgeld / WEG-Rücklage instead).
- State which assumptions are most uncertain and how sensitive the recommendation is to them.
- Label the confidence level (High / Medium / Low) based on data quality and scenario reversibility.

## Handoff

After saving FINANCE-COMPARE.md, summarise in 3–5 bullet points:
- The recommended option and the single most important reason
- The break-even year (for RvB) or primary cost difference
- The biggest assumption the recommendation depends on
- One non-financial factor the model cannot capture
- Suggested next concrete action (e.g., get mortgage pre-approval at Interhyp, request PKV offer from independent Makler, switch fund at broker)
