---
name: finance-quick
description: 60-Second Financial Snapshot — fast assessment of financial health based on six core inputs (income, expenses, savings, debt, age, retirement goal). No subagents. Produces a compact terminal scorecard with savings rate, debt service ratio (Schuldendienstquote), emergency fund coverage, retirement on-track status, and top 3 priority actions in under 40 lines.
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

1. **Monthly net income (Monatliches Nettoeinkommen)** (after-tax euros landing in their account — for Angestellte this is after GKV, Rentenversicherung, Lohnsteuer)
2. **Monthly expenses (Monatliche Ausgaben)** (rent/mortgage + utilities + groceries + transport + everything else)
3. **Total liquid savings (Liquide Ersparnisse gesamt)** (current account + instant-access savings (Tagesgeld) + brokerage cash, NOT bAV/Riester/pension)
4. **Total debt (Schulden gesamt)** (credit cards + consumer loans (Ratenkredite) + car loan + mortgage balance)
5. **Current age (Aktuelles Alter)**
6. **Target retirement age (Angestrebtes Rentenalter)**

If the user only provides partial data, compute what you can and flag missing fields in the output.

## Calculations

### 1. Savings rate (Sparquote)
```
sparquote = (nettoeinkommen - ausgaben) / nettoeinkommen * 100
```
**Benchmarks (% of net income):**
- ≥ 20% → Excellent
- 15-19% → Good
- 10-14% → Adequate
- 5-9% → Weak
- < 5% → Critical

### 2. Debt service ratio (Schuldendienstquote)
In Germany, the relevant metric is the debt service ratio (Schuldendienstquote) — monthly debt payments relative to net income (not gross income).
```
monthly_debt_payment = approx. 2% of total debt (rough estimate)
schuldendienstquote = monthly_debt_payment / nettoeinkommen * 100
```
**Benchmarks (debt service ratio, % of net income):**
- < 15% → Excellent
- 15-20% → Healthy
- 20-30% → Acceptable (borderline)
- > 30% → Strained — prioritize debt reduction
- > 40% → Critical

**Note:** German recommendation: debt service ratio (Schuldendienstquote) < 30% of net income (from german-context.md). This threshold is the key reference point for mortgage lending and consumer credit assessment.

### 3. Emergency fund (Notgroschen) coverage
```
months_covered = liquid_savings / monthly_expenses
```
**Benchmarks:**
- ≥ 6 months → Excellent
- 3–5.9 months → Good
- 1–2.9 months → Weak
- < 1 month → Critical

### 4. Retirement — On-Track Status

Aspirational milestones for Germany (annual gross salary as multiplier; the statutory pension (GRV) provides a floor that reduces the capital requirement compared to countries without mandatory state pensions):

- Age 30 → 0.5× annual gross salary in investable assets
- Age 35 → 1× annual gross salary
- Age 40 → 2× annual gross salary
- Age 45 → 3× annual gross salary
- Age 50 → 5× annual gross salary
- Age 55 → 6.5× annual gross salary
- Age 60 → 8× annual gross salary
- Age 67 → 10× annual gross salary (standard retirement age)

These figures are aspirational — the statutory pension insurance (GRV) provides a floor. If the user has a GRV pension statement (Renteninformation), incorporate it into the analysis.

Compare actual retirement savings (bAV, investment account (Depot), Riester-Rente) against the age benchmark. Calculate years to retirement = target retirement age − current age.

### 5. Composite Quick Score (0-100)
```
quick_score = (sparquote_score + schuldendienstquote_score + notgroschen_score + altersvorsorge_score) / 4
```
Each sub-score is 0-100 based on the benchmarks above.

**Grade scale:**
- 85-100 → A
- 70-84 → B
- 55-69 → C
- 40-54 → D
- < 40 → F

## Quick Checklist (7 Points)

Check these items before or after calculating the score and flag them in the output:

| Item | Question | Status |
|-------|-------|--------|
| Emergency fund (Notgroschen) | ≥ 3 months of expenses in instant-access savings (Tagesgeld)? | ✅ / ❌ |
| Savings rate (Sparquote) | ≥ 20% of net income saved/invested? | ✅ / ❌ |
| Personal liability insurance (Haftpflichtversicherung) | Personal liability policy in place? (€50–130/year — essential) | ✅ / ❌ |
| Disability insurance (BU-Versicherung) | Occupational disability insurance (Berufsunfähigkeitsversicherung) in place? (Critical during working years) | ✅ / ❌ |
| Employer pension match (bAV) | Employer contribution to occupational pension (bAV) fully utilized? (Free money) | ✅ / ❌ |
| Tax-free allowance order (Freistellungsauftrag) | Freistellungsauftrag set at every broker/savings account? (€1,000 p.a. tax-free) | ✅ / ❌ |
| Debt service ratio (Schuldendienstquote) | Monthly debt payments < 30% of net income? | ✅ / ❌ |

## Output Format

Keep output under 40 lines total. Use plain ASCII (no markdown tables for the terminal version, but include a compact table format).

```
================================================
  60-SECOND FINANCIAL SNAPSHOT
================================================

Financial Health: [Grade] ([Score]/100)
Life Stage: [Early Career / Building Phase / Mid-Career / Pre-Retirement]

KEY METRICS
- Savings rate (Sparquote):           [X]%   [Excellent/Good/Adequate/Weak/Critical]
- Debt service ratio (Schuldendienstquote): [X]%   [Status]  (Target: < 30% net)
- Emergency fund (Notgroschen):       [X.X] months   [Status]
- Retirement track:                   [On Track / Behind / Critically Behind]

QUICK CHECK
- Emergency fund ≥ 3 months:         [✅ / ❌]
- Savings rate ≥ 20%:                [✅ / ❌]
- Personal liability insurance:      [✅ / ❌]
- Disability insurance (BU):         [✅ / ❌]
- Employer pension match (bAV):      [✅ / ❌]
- Tax-free allowance order set:      [✅ / ❌]
- Debt service ratio < 30%:          [✅ / ❌]

TOP 3 PRIORITIES
1. [Highest impact — specific euro amount + this week]
2. [Second priority — specific action]
3. [Third priority — specific action]

KEY NUMBER TO IMPROVE
[The one metric that moves the score the most]

================================================
For full analysis: `/finance analyze`
DISCLAIMER: For educational/informational purposes only.
Not financial advice.
================================================
```

## Priority Action Logic

Rank actions by weakest metric:

- **If emergency fund (Notgroschen) < 1 month** → Top action: "Build emergency fund to €X (1-month minimum) before other steps — in instant-access savings (Tagesgeld, ~3–3.5% p.a.) at DKB/ING/Trade Republic"
- **If debt service ratio (Schuldendienstquote) > 30%** → Top action: "Aggressive debt reduction — prioritize highest interest rate (overdraft (Dispo) first), direct €X extra/month"
- **If savings rate (Sparquote) < 5%** → Top action: "Audit top 3 spending categories — find €X in savings potential this month"
- **If retirement critically behind** → Top action: "Increase occupational pension (bAV) contribution (use employer match first), then set up ETF savings plan — target 15–20% of net income"
- **If high-interest debt present (Dispo > 8–14%)** → "Pay off overdraft (Dispo) before making further investments"

If all four metrics are healthy, suggest optimization actions:
- "Increase bAV contribution to capture full employer match"
- "Move emergency fund to instant-access savings (Tagesgeld, ~3–3.5% p.a.) — compare DKB, ING, Trade Republic"
- "Review Freistellungsauftrag — €1,000/year (single) tax-free, split across all brokers"
- "Set up a savings plan in MSCI World UCITS ETF (SWDA/XDWD), automate monthly investing"

## Example Walkthrough

**User inputs:**
- Net income: €4,800/month
- Expenses: €3,900/month
- Liquid savings: €7,200
- Debt: €18,000 (consumer loan / Ratenkredit)
- Age: 31
- Target retirement age: 67

**Calculated:**
- Savings rate (Sparquote): 18.75% → Good
- Debt service ratio (Schuldendienstquote): ~7.5% → Excellent
- Emergency fund (Notgroschen): 1.85 months → Weak
- Retirement: 36 years to retirement, €7,200 savings, benchmark at 31 is ~0.5× annual gross (assumed €55,000 gross → target ~€27,500) → Behind

**Score:** (75 + 95 + 30 + 40) / 4 = 60 → C

**Top 3 priorities:**
1. Build emergency fund from €7,200 to €11,700 (3 months) — redirect €500/month for 9 months; hold in instant-access savings (Tagesgeld) at DKB or ING (~3.5% p.a.)
2. Set up ETF savings plan — after emergency fund is funded, invest €300/month in MSCI World UCITS ETF (SWDA/XDWD) via Trade Republic or Scalable
3. Set Freistellungsauftrag at every broker/savings account — €1,000/year in investment income tax-free

## Edge Cases

- **User reports no debt** → Skip debt service scoring, reweight remaining factors
- **User is retired** → Replace retirement track with withdrawal sustainability (4% rule check; include GRV pension income)
- **User under 25** → Lower retirement benchmarks (0.25× at 25); emphasize early start advantage; illustrate compound interest effect
- **User with very high income (> €150,000 gross)** → Note: bAV and Riester-Rente have contribution caps; discuss Rürup-Rente (Basisrente) and investment account (Depot) investing; recommend `/finance taxes`
- **User refuses to provide numbers** → Offer 3 scenarios (financially stretched / average / strong position) and let them self-identify

## Handoff

End every snapshot with this line:
> `/finance analyze` for the full analysis, or `/finance debt` / `/finance retirement` for targeted topics.

## Tone

Direct. Quantitative. No hedging language like "you might consider." Instead: "Do X this week" with specific euro amounts. Acknowledge strengths first ("18% savings rate is above the German average") before identifying gaps.

**DISCLAIMER: For educational/informational purposes only. Not financial advice. Consult a licensed financial advisor, Steuerberater, or financial planner before making major financial decisions.**
