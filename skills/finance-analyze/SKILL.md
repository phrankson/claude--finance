---
name: finance-analyze
description: Vollständige Finanzanalyse für deutsche Angestellte — erstellt einen 6-Kategorien-Finanzbericht mit RAG-Status und Top-3-Maßnahmen. Aktivieren bei "/finance analyze", "Finanzanalyse", "finanzielle Gesundheitsprüfung", "Analysiere meine Finanzen", "Wie stehe ich finanziell da?", "full financial analysis", "financial health check", or any request for a complete financial picture for a German Angestellter.
---

# Finance Analyze — Complete Financial Analysis for Angestellte

**DISCLAIMER: For educational and informational purposes only. Not investment advice, tax advice, or insurance advice under VVG. All recommendations are general in nature. Consult a licensed financial advisor, tax advisor, or independent insurance broker before making any decisions.**

## When to Run

Trigger this skill when the user says:
- `/finance analyze`
- "Finanzanalyse" / "Analysiere meine Finanzen"
- "Finanzielle Gesundheitsprüfung" / "Wie stehe ich finanziell da?"
- "Full financial analysis" / "Financial health check"
- Any request for a complete financial picture from a German Angestellter

## Data Collection

Before analysis, collect the user's complete financial profile. Ask in structured blocks. If data is incomplete, use reasonable defaults and flag them clearly in the output.

**Block 1 — Income Profile**
1. Annual gross salary (€) — including special payments (13th salary, bonus)?
2. Estimated monthly net income (Nettoeinkommen) (€) — or should it be estimated based on tax class and social insurance contributions?
3. Tax class (Steuerklasse I, II, III, IV, IV+Faktor, V, or VI)
4. Additional income sources (rental income, side job, investment income)?

**Block 2 — Health Insurance & Social Insurance**
5. GKV or PKV?
   - GKV: Which provider? Monthly employee share (€)?
   - PKV: Monthly premium (€)? Is Krankentagegeld (sick pay insurance) included?

**Block 3 — Retirement Provisions**
6. bAV (betriebliche Altersvorsorge): do you have one? (yes/no)
   - If yes: monthly employee contribution via Entgeltumwandlung (€)? Employer Zuschuss (%)?
7. Riester-Rente: do you have one? (yes/no)
   - If yes: annual own contribution (€)? Entitled to Kinderzulage? (number of children)
8. ETF investment account (Depot): do you have one? (yes/no)
   - If yes: current investment account (Depot) value (€)? Monthly Sparplan (€)?

**Block 4 — Liquidity & Assets**
9. Instant-access savings (Tagesgeld) / fixed-term deposit (Festgeld) balance (€)
10. Current account balance (€)
11. Other liquid assets (€)
12. Property ownership: yes/no? If yes: estimated value (€)?

**Block 5 — Debt**
13. Dispositionskredit (Dispo overdraft): currently used? Outstanding balance (€)? Interest rate (%)?
14. Consumer loan(s) (Ratenkredit): outstanding balance (€)? Monthly payment (€)? Effective interest rate (%)?
15. Mortgage (Baufinanzierung): outstanding balance (€)? Monthly payment (€)? Nominal rate (Sollzins) (%)? Fixed-rate end date (year)?

**Block 6 — Monthly Expenses**
16. Total monthly fixed expenses (€): rent/Hausgeld, insurance, subscriptions, loan repayments
17. Monthly variable expenses (€): groceries, transport, leisure, other
18. Total monthly savings rate (€): everything except consumption (bAV, Riester, Sparplan, instant-access savings deposits)

**Block 7 — Insurance Coverage**
19. Personal liability insurance (Haftpflichtversicherung): do you have one? (yes/no)
20. Occupational disability insurance (Berufsunfähigkeitsversicherung / BU): do you have one? (yes/no)
    - If yes: monthly BU benefit (€)? Waiting period? Term until?
21. Term life insurance (Risikolebensversicherung): do you have one? (yes/no)
    - If yes: insured sum (€)? Term until?
22. Household contents insurance (Hausratversicherung): do you have one? (yes/no)

**Block 8 — Goals**
23. Short-term goals (< 2 years): e.g., holiday, purchase
24. Medium-term goals (2–10 years): e.g., property purchase, parental leave, further education
25. Long-term goals (> 10 years): target retirement date, desired monthly retirement income (€)?

## Analysis Framework

> **Before analysis, read `.claude/skills/shared/german-context.md` for 2026 German financial constants.**

Use the six sections below. For each, assign a RAG status:
- 🔴 Critical — immediate action required
- 🟡 Needs optimization — action advisable
- 🟢 Well positioned — no urgent need

---

### 1. Liquidity & Emergency Fund

**Target emergency fund:** 3–6 months of expenses in instant-access savings (Tagesgeld) (current reference rate: ~3–3.5% p.a. at DKB, ING, Trade Republic).

**Assessment:**
- Calculate total monthly expenses (fixed + variable)
- Calculate current emergency fund in months: instant-access savings (Tagesgeld) (€) ÷ monthly expenses
- Compare against target:
  - Angestellter, stable income, no dependants → 3 months sufficient
  - Angestellter with dependants / variable pay → 4–5 months
  - Beamte → 2–3 months sufficient
- RAG logic:
  - 🔴 < 2 months covered
  - 🟡 2 months covered, but below target
  - 🟢 Target met or exceeded
- Flag: fixed-term deposit (Festgeld) above the emergency fund amount → positive (higher yield); current account surplus > 2 months expenses → opportunity cost (recommend shifting to instant-access savings)

---

### 2. Debt Analysis

**Debt-service ratio (Schuldendienstquote):** (sum of monthly debt payments) ÷ net income; target: < 30%.

**Priority order:**
1. Dispositionskredit (Dispo): highest interest rate (8–14% p.a.) → immediate repayment is top priority
2. Consumer loan (Ratenkredit): depending on effective rate (3–8% p.a.) → repay after Dispo
3. Mortgage (Baufinanzierung): typically lowest rate → maintain minimum payments, use Sondertilgungsrecht (5–10% p.a.) if rate > instant-access savings yield

**Assessment:**
- Calculate debt-service ratio
- Flag Dispo usage > 1 month → 🔴 urgent (rate often 10–12% p.a.)
- RAG logic:
  - 🔴 Debt-service ratio ≥ 40% or Dispo permanently used
  - 🟡 Debt-service ratio 30–40% or Dispo used occasionally
  - 🟢 Debt-service ratio < 30%, no Dispo balance

---

### 3. Retirement Gap (Rentenlücke)

**Step 1 — Estimated statutory pension (GRV):**
- Entgeltpunkte (EP) per year = annual gross salary ÷ average earnings (2026 reference value from german-context.md)
- Assumption: retirement at 67; estimate years of contributions based on age and career start
- Estimated monthly GRV pension = accumulated EP × €39.32 (current pension value West 2026)

**Step 2 — Supplementary components:**
- bAV present: estimated additional monthly pension from contributions (user can derive from pension statement)
- Riester present: estimated additional monthly pension
- ETF investment account (Depot): expected assets at retirement (7% nominal p.a. assumption) → sustainable withdrawal amount (3.5% rule)

**Step 3 — Retirement gap:**
- Retirement gap (Rentenlücke) = desired monthly retirement income − (GRV + bAV + Riester + investment account withdrawal)
- If gap > 0 → 🔴 or 🟡 depending on size
- Flag: no bAV despite employer Zuschuss offer → "foregone free money" (employer Zuschuss = direct compensation component)
- Flag: no Riester despite Kinderzulage eligibility → Grundzulage €175 + Kinderzulage €185–€300 per child p.a. being forfeited

**RAG logic:**
- 🔴 Retirement gap > 50% of target income or no supplementary pension provision beyond GRV
- 🟡 Retirement gap 20–50% or bAV/Riester present but gap remains
- 🟢 Retirement gap < 20% or investment account assets expected to close the gap

---

### 4. Investment Structure

**Savings rate:** monthly savings rate ÷ net income; target: ≥ 20%.

**Assessment:**
- Check whether an investment account (Depot) exists
- If investment account exists: are investments in UCITS ETFs (TER < 0.30%) or actively managed funds with high costs?
- Is a Freistellungsauftrag (tax exemption order) in place? (Sparerpauschbetrag (annual tax-free investment allowance): €1,000 single / €2,000 married p.a.)
- Is the Vorabpauschale (annual notional ETF tax) understood and budgeted for?
- Flag: current account balance > 2 months expenses → opportunity cost (recommend shifting to instant-access savings or Sparplan)
- Flag: no investment account, no supplementary investing beyond instant-access savings → wealth accumulation missing

**Investment account allocation check (if investment account exists):**
- Is allocation age-appropriate? (rule of thumb: equity share = 100 − age, adjusted for risk tolerance)
- Concentration risk: single positions > 10% of investment account value?
- Home-market bias (Germany/Europe only)? → recommend global diversification

**RAG logic:**
- 🔴 Savings rate < 5% or no investment account, no Sparplan
- 🟡 Savings rate 5–20% or investment account exists but high cost ratios / no Freistellungsauftrag
- 🟢 Savings rate ≥ 20%, UCITS ETFs with TER < 0.30%, Freistellungsauftrag in place

---

### 5. Insurance Coverage Overview

Assess completeness and urgency of coverage:

| Insurance | Status | RAG | Comment |
|---|---|---|---|
| Personal liability (Haftpflichtversicherung) | present / missing | 🔴 if missing | Cost ~€50–130/year; unlimited personal liability without it |
| Occupational disability (BU) | present / missing | 🔴 if missing and employed | State Erwerbsminderungsrente ~€960/month on average — significant gap |
| Health insurance (GKV/PKV) | present | depending on optimization need | Provider switch / PKV premium adjustment check |
| Term life (Risikolebensversicherung) | present / missing | 🔴 if dependants present and no coverage | Not required without dependants |
| Household contents (Hausratversicherung) | present / missing | 🟡 if missing | Recommended but not critical |

**BU gap calculation (if no BU or insufficient coverage):**
- Target coverage: 75% of monthly net income
- Expected state Erwerbsminderungsrente: ~€900–1,100/month (€0 if < 5 years of GRV contributions)
- Required BU benefit = target − Erwerbsminderungsrente
- If no BU or gap > €500/month → 🔴 critical

**GKV optimization:**
- Is the current provider's Zusatzbeitrag competitive? (> 0.5% above cheapest comparable provider → consider switching)
- Contribution via bAV Entgeltumwandlung: reduces contribution-relevant income → lowers GKV contribution

*For detailed GKV vs. PKV analysis and in-depth BU review: run /finance insurance*

---

### 6. Tax Optimization

**Tax class check:**
- Steuerklasse I (single, no partner): standard
- Steuerklasse III/V (married, primary/secondary earner): only useful with a large income gap; otherwise check Klasse IV/IV+Faktor → optimizes payroll tax advance payments
- Steuerklasse II (single parent): Entlastungsbetrag → check whether claimed
- Flag: married in III/V with similar incomes → potential tax underpayment on annual return; consider switching to IV/IV+Faktor

**bAV optimization:**
- Is the employer Zuschuss (mandatory minimum: 15% on Entgeltumwandlung from social insurance savings) being fully captured?
- Tax-free bAV limit 2026: €7,728/year (8% BBG West)
- Double benefit: income tax savings + GKV contribution reduction (up to BBG)

**Freistellungsauftrag:**
- Is the Sparerpauschbetrag (annual tax-free investment allowance) (€1,000 single / €2,000 married) correctly allocated across all investment accounts and accounts?
- Too much at one broker → redistribute

**Riester:**
- Is the subsidy rate optimized? (4% of prior-year gross salary minus Zulagen required as own contribution)
- Günstigerprüfung: tax office automatically checks whether Sonderausgabenabzug is more favorable than Zulagen

*For detailed tax optimization strategies: run /finance taxes*

---

## Output

Create the file `FINANCE-ANALYSIS.md` in the current working directory with the following structure:

```markdown
# Financial Analysis
**Prepared for:** [Name or "Client"]
**Date:** [Today]
**Profile:** Angestellte(r), Steuerklasse [X], [GKV/PKV]

---

## Overview

| Category | Status | Priority |
|---|---|---|
| 1. Liquidity & Emergency Fund | 🔴/🟡/🟢 | High/Medium/Low |
| 2. Debt Analysis | 🔴/🟡/🟢 | High/Medium/Low |
| 3. Retirement Gap | 🔴/🟡/🟢 | High/Medium/Low |
| 4. Investment Structure | 🔴/🟡/🟢 | High/Medium/Low |
| 5. Insurance Coverage | 🔴/🟡/🟢 | High/Medium/Low |
| 6. Tax Optimization | 🔴/🟡/🟢 | High/Medium/Low |

---

## 1. Liquidity & Emergency Fund
[Detailed analysis with concrete € amounts and months of coverage]

## 2. Debt Analysis
[Debt-service ratio, priority order, repayment strategy]

## 3. Retirement Gap (Rentenlücke)
[GRV estimate, bAV, Riester, investment account projection, gap in €/month]

## 4. Investment Structure
[Savings rate, investment account allocation, cost analysis, Freistellungsauftrag status]

## 5. Insurance Coverage Overview
[Gap table with € amounts, BU gap calculation]

## 6. Tax Optimization
[Tax class, bAV utilization, Freistellungsauftrag, Riester subsidy rate]

---

## Top 3 Actions (by urgency and leverage)

| # | Action | Category | Estimated leverage | Time required | Urgency |
|---|---|---|---|---|---|
| 1 | ... | ... | €X/month or one-off | X hrs | 🔴/🟡/🟢 |
| 2 | ... | ... | ... | ... | ... |
| 3 | ... | ... | ... | ... | ... |

---

## Further Analysis
- `/finance insurance` — full GKV vs. PKV analysis and in-depth BU review
- `/finance retirement` — full retirement analysis with projection tables
- `/finance taxes` — tax optimization strategies in detail

---

**DISCLAIMER: For educational and informational purposes only. Not investment, tax, or insurance advice. All values are estimates based on general assumptions. Consult a licensed financial advisor, tax advisor, or independent insurance broker before making any decisions.**
```

## Quality Standards

- All € amounts are concrete and derived from the data entered (no placeholder values)
- Every RAG rating is supported by a calculation or justification
- Missing data is clearly flagged as assumptions
- No US-specific terms, structures, or benchmarks
- Recommendations reference 2026 values from `german-context.md`
- Report always ends with the disclaimer

## Handoff

After creating `FINANCE-ANALYSIS.md`, inform the user of:
1. The three most urgent actions from the report
2. References to follow-up skills for deeper analysis:
   - "For full GKV vs. PKV analysis and in-depth BU review: run `/finance insurance`."
   - "For full retirement analysis with projection tables: run `/finance retirement`."
   - "For tax optimization strategies in detail: run `/finance taxes`."
3. Suggest `/finance report-pdf` for a print-ready PDF version.

**DISCLAIMER: For educational and informational purposes only. Not investment, tax, or insurance advice. Consult a licensed financial advisor, tax advisor, or independent insurance broker before making any decisions.**
