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

**Income**
1. Monthly net income (Nettoeinkommen) — take-home after taxes and social insurance; for employees (Angestellte), GKV and pension insurance (Rentenversicherung) are already deducted; the Netto figure is what lands in the bank account
2. Variable/irregular income (Boni, freelance, side income/Nebentätigkeiten)
3. Partner's net income (Nettoeinkommen), if applicable

**Fixed Costs (Monthly)**
4. Rent or mortgage (Kaltmiete + Nebenkosten/operating costs for renters; monthly payment + Nebenkosten for owners)
5. Electricity, gas, water (if not included in Nebenkosten)
6. Internet + mobile
7. Insurance (car/KFZ, personal liability/Haftpflicht, disability/BU, contents/Hausrat, legal/Rechtsschutz) — Note: statutory health insurance (GKV) is already deducted from net pay for employees; private health insurance (PKV) premium is a separate additional expense for PKV members only
8. Debt repayment (car loan/KFZ-Kredit, consumer loan/Ratenkredit, credit card minimums)
9. Subscriptions (streaming, gym, software)
10. Childcare/daycare (Kita)/school

**Variable Expenses (Monthly Average)**
11. Groceries (supermarket, weekly market)
12. Dining out / restaurants / delivery
13. Transport (fuel, public transit/ÖPNV, Deutschlandticket, parking, taxi/ridesharing)
14. Personal care (haircuts, cosmetics, pharmacy/Drogerie)
15. Leisure (concerts, hobbies, books, sport)
16. Shopping (clothing, household goods)
17. Holidays/travel (annual amount ÷ 12)

**One-Off/Annual Expenses**
18. Annual insurance premiums (if not billed monthly)
19. Christmas/gifts (e.g. €600/year = €50/month reserve)
20. Car maintenance (e.g. TÜV inspection, service — €600/year = €50/month reserve)
21. Household repairs (renters: ~€200–400/year; owners: ~1% of property value/year)

**Goals**
22. Savings goal (% or €)
23. Debt payoff goals
24. Major purchases (car, property, wedding)

## Budgeting Methods — Choosing the Best Fit

Identify which method fits the user:

### Method 1: 50/30/20 Rule (default for most)
- **50% Essential needs**: rent + Nebenkosten, groceries, transport, insurance (PKV if applicable), minimum debt repayment
- **30% Lifestyle**: dining out, holidays, hobbies, subscriptions, shopping
- **20% Saving/Debt payoff**: emergency fund (Notgroschen), investment account (Depot)/ETF savings plan, occupational pension (bAV)/Riester, extra debt repayment

All percentages refer to **net income (Nettoeinkommen)** — the German convention, as taxes and social contributions are already deducted.

Use when: stable income, simple framework desired, no debt crisis.

### Method 2: Zero-Based Budgeting (household ledger/Haushaltsbuch)
Every euro has a job. Income − Expenses − Savings = €0.
Category-based tracking with monthly reset.

Use when: variable income, paying off debt, maximum control desired.

### Method 3: Envelope Method (Umschlagmethode) — digital or cash
Pre-allocate fixed amounts per category. When a category is empty, stop spending until the next period.

Use when: chronic overspending in specific categories — a behavior problem, not a math problem.

### Method 4: Pay-Yourself-First (savings rate first)
Auto-debit savings before any other expenses. Spend the rest freely.

Use when: good income, high savings rate desired, no tracking overhead.

### Method 5: 60/20/20 (Aggressive Savers)
- 60% Essential needs + lifestyle
- 20% Retirement savings (Altersvorsorge)
- 20% Other reserves/debt paydown

Use when: FIRE target, high income, retirement savings behind.

## Analysis Framework

### Step 1: Categorize every euro
Sort all spending into:
- **Essential needs (Grundbedürfnisse)** (rent + Nebenkosten, electricity/gas, basic utilities, core transport, insurance, minimum debt repayment)
- **Lifestyle** (restaurants, entertainment, shopping, hobbies, subscriptions)
- **Goals** (retirement savings, emergency fund, extra debt paydown, reserves)
- **Waste** (forgotten subscriptions, fees, impulse purchases, lifestyle inflation)

### Step 2: Benchmark each category

| Category | Healthy range (% net income) | Warning signal |
|----------|------------------------------|----------------|
| Rent + Nebenkosten (Warmmiete, all-in) | ≤ 30% | > 35% |
| Transport | 10–15% | > 20% |
| Groceries (single) | ~15% | > 22% |
| Groceries (couple) | ~12% | > 18% |
| Insurance (additional policies) | 3–6% | > 10% |
| Debt (excluding rent/mortgage) | 0–10% | > 15% |
| Saving/investing | ≥ 20% | < 10% |
| Discretionary/lifestyle | 10–20% | > 30% |

**Note for employees (GKV):** Statutory health insurance is already paid via payroll deduction and is included in net pay. It does not appear as a separate monthly expense. Only the private health insurance (PKV) premium (for PKV members) is an additional monthly outgoing.

### Step 3: Identify waste (top 5 audits)
1. **Subscription audit** — list every recurring charge > €5/month: "still in use?"
2. **Bank/account fees** — overdraft interest (Dispo-Zinsen), account fees, foreign transaction fees
3. **Insurance comparison** — compare car/contents insurance every 2–3 years via Check24/Verivox
4. **Restaurant frequency** — count meals eaten out per week
5. **Lifestyle inflation** — categories that have grown >20% p.a. without a matching income increase

### Step 4: Find the €300 quick win
Look for savings opportunities. Typical sources in Germany:
- Cancel unused subscriptions (€30–80)
- Fewer restaurant visits/delivery orders (€80–200)
- Switch mobile plan: good SIM-only rates from ~€20–30/month (Aldi Talk, Tchibo Mobil, Freenet, WinSIM) — check whether current plan can be beaten
- Insurance comparison via Check24/Verivox (€50–150/year)
- Grocery shopping with a plan (€50–100)
- Consolidate streaming services (€15–30)

## Output: FINANCE-BUDGET.md

Write to the current working directory:

```markdown
# Personal Budget Plan
**Created:** [date]
**Method:** [50/30/20 / Zero-Based / Envelope / Pay-Yourself-First / Custom]
**Monthly net income (Nettoeinkommen):** €X,XXX

## Summary
- Current savings rate: X% of net income
- Target savings rate: ≥ 20% of net income
- Identified monthly waste: €XXX
- Top 3 categories to optimize: ...

## Current Spending Overview

| Category | Current € | Current % | Benchmark % net | Rating |
|----------|-----------|-----------|-----------------|--------|
| Rent + Nebenkosten (Warmmiete, all-in) | €X | X% | ≤ 30% | ✅ / ⚠️ / 🚨 |
| Groceries | €X | X% | ~15% single / ~12% couple | |
| Transport | €X | X% | 10–15% | |
| Insurance (additional, excl. GKV) | €X | X% | 3–6% | |
| Subscriptions | €X | X% | | |
| ... | | | | |
| **Total expenses** | €X | XX% | | |
| **Saving/investing** | €X | XX% | ≥ 20% | |

## Recommended Budget (12 Months)

### Monthly Allocation by 50/30/20 (% of net income)
| Area | Category | New Budget | Change | Rationale |
|------|----------|------------|--------|-----------|
| **Essential needs (50%)** | Rent + Nebenkosten | €X | €0 | Fixed cost |
| | Groceries | €X | −€X | Shopping with a plan |
| | Transport | €X | −€X | Public transit + bike |
| | Insurance | €X | €0 | Existing policies |
| **Lifestyle (30%)** | Dining out | €X | −€X | 8×/mo → 4×/mo |
| | Subscriptions | €X | −€X | Cancelled: [list] |
| | Holidays | €X | +€X | Monthly reserve |
| **Saving/Debt payoff (20%)** | Emergency fund (Notgroschen) | €X | +€X | Build to 3–6 months of expenses |
| | ETF savings plan / investment account (Depot) | €X | +€X | Monthly savings plan |
| | bAV/Riester | €X | +€X | Use employer contribution |

### Reserves — Sinking Funds (annual expenses ÷ 12)
| Reserve | Monthly | Annual need |
|---------|---------|-------------|
| Christmas/gifts | €50 | €600 |
| Car maintenance/TÜV | €75 | €900 |
| Holidays | €X | €X |
| Household repairs | €X | €X |

## Identified Waste — Cut List

| # | Item | Monthly € | Annual € | Action |
|---|------|-----------|----------|--------|
| 1 | ... | €X | €X | Cancel today |
| 2 | ... | €X | €X | Switch provider |
| 3 | ... | €X | €X | Negotiate |
| 4 | ... | €X | €X | Reduce frequency |
| 5 | ... | €X | €X | Eliminate |
| **TOTAL** | | €XXX | €X,XXX | |

## Quick-Win Plan (Week 1)
1. [Specific action with URL or step]
2. [Specific action]
3. [Specific action]
4. [Specific action]
5. [Specific action]

## 12-Month Spending Plan

| Month | Income | Fixed costs | Variable | Savings | Reserves | Notes |
|-------|--------|-------------|----------|---------|----------|-------|
| Jan | €X | €X | €X | €X | €X | Prepare tax return (Steuererklärung) |
| Feb | €X | €X | €X | €X | €X | |
| Mar | €X | €X | €X | €X | €X | Q1 review |
| Apr | €X | €X | €X | €X | €X | |
| May | €X | €X | €X | €X | €X | |
| Jun | €X | €X | €X | €X | €X | Mid-year review |
| Jul | €X | €X | €X | €X | €X | Main holiday season |
| Aug | €X | €X | €X | €X | €X | |
| Sep | €X | €X | €X | €X | €X | Q3 review |
| Oct | €X | €X | €X | €X | €X | |
| Nov | €X | €X | €X | €X | €X | Black Friday — stick to budget |
| Dec | €X | €X | €X | €X | €X | Christmas, year-end review |

## Behavioral Tips (Sustainability)
- **Automate**: Set up standing orders (Daueraufträge) for savings plan and reserves right after pay arrives
- **Add friction**: Delete saved card details from impulse-buy sites
- **Visibility**: Weekly 10-minute budget check (add a recurring calendar event)
- **Reward**: Plan a "fun money (Freiheitsgeld)" category — the budget must be sustainable, not punishing

## Recommended Tools
- Budgeting app (Haushaltsbuch): Finanzfluss Budget-Template (free), YNAB (available in Germany), Outspoken (DE app), or Google Sheets / Excel
- Subscription overview: Finanzguru (DE app), or your own list of all standing orders in online banking
- Instant-access savings (Tagesgeld) for reserves (~3–3.5% p.a.): DKB Tagesgeld, ING Extra-Konto, Trade Republic, Consorsbank
- Insurance comparison: Check24, Verivox, Finanztip

## Monthly Review Checklist
- [ ] Update income (has variable income arrived?)
- [ ] Compare actual vs. planned per category
- [ ] Flag any category overrun > 10% and analyse why
- [ ] Top up reserves
- [ ] Check savings plan transfer to investment account (Depot)/instant-access savings (Tagesgeld)
- [ ] Note net worth briefly

## Next Steps
1. Set up standing orders for savings plans this week
2. Cancel unnecessary subscriptions today
3. Schedule a monthly 30-minute budget review in your calendar
4. Run `/finance budget` again in 90 days to recalibrate

---
**DISCLAIMER: For educational/informational purposes only. Not financial advice. Consult a licensed financial advisor before making decisions.**
```

## Output Standards
- Every recommendation in concrete euro amounts, not just percentages
- Every saving with a concrete action (compare at Check24, cancel at URL, etc.)
- Budget is sustainable, not punishing — "fun money (Freiheitsgeld)" must be included
- Irregular and annual expenses covered via monthly reserves (sinking funds)
- Sustainable savings rate > theoretically maximum savings rate
- All percentages refer to net income (Nettoeinkommen) — the German convention

## Handoff
After writing FINANCE-BUDGET.md, tell the user:
1. Total identified monthly savings (€XXX)
2. Top 3 immediate actions
3. Suggest follow-up skills: `/finance debt` if debt is present, `/finance retirement` if savings rate is low

**DISCLAIMER: For educational/informational purposes only. Not financial advice. Consult a licensed financial advisor before making decisions.**
