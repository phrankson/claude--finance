# AI Personal Finance Advisor — Junior Advisor Guide
## How to Use This System with German Clients

> This guide is for financial advisors and assistants using the AI Personal Finance Advisor
> skill system (installed in Claude Code). No technical background required.
>
> ⚠️ All outputs are educational/informational only. Not financial advice (keine Finanzberatung
> im Sinne des WpHG). Always have a qualified advisor review before client delivery.

---

## Contents
1. [What This System Does](#1-what-this-system-does)
2. [Setup Checklist](#2-setup-checklist)
3. [Client Intake — What Data to Collect](#3-client-intake--what-data-to-collect)
4. [Core Workflow — New Client](#4-core-workflow--new-client)
5. [Skill Reference with Prompts](#5-skill-reference-with-prompts)
6. [Common Client Scenarios](#6-common-client-scenarios)
7. [Reading the Output Files](#7-reading-the-output-files)
8. [Limitations and Escalation Rules](#8-limitations-and-escalation-rules)
9. [Quick Reference Card](#9-quick-reference-card)

---

## 1. What This System Does

This system is a set of AI-powered financial analysis tools (called "skills") that run inside
Claude Code. Each skill analyzes a specific area of a client's finances and produces a
structured Markdown report that you can review, edit, and share.

### What it produces

| Skill | What it analyzes | Output file |
|-------|-----------------|-------------|
| `/finance analyze` | Complete financial health (5 areas in parallel) | FINANCE-ANALYSIS.md |
| `/finance insurance` | GKV vs PKV decision + BU/Haftpflicht gaps | FINANCE-INSURANCE.md |
| `/finance taxes` | Tax optimization (bAV, Rürup, Abgeltungsteuer, etc.) | FINANCE-TAXES.md |
| `/finance retirement` | GRV + bAV + private pension projection | FINANCE-RETIREMENT.md |
| `/finance budget` | Spending analysis and 12-month budget plan | FINANCE-BUDGET.md |
| `/finance debt` | Debt payoff strategy (avalanche vs snowball) | FINANCE-DEBT.md |
| `/finance fire` | Financial independence number and timeline | FINANCE-FIRE.md |
| `/finance portfolio` | Investment allocation review (UCITS ETFs) | FINANCE-PORTFOLIO.md |
| `/finance goals` | Goal-based savings plans | FINANCE-GOALS.md |
| `/finance emergency` | Notgroschen target and vehicle recommendation | FINANCE-EMERGENCY.md |
| `/finance networth` | Net worth snapshot and milestone tracker | FINANCE-NETWORTH.md |
| `/finance compare` | Side-by-side scenario comparison (buy vs rent, etc.) | FINANCE-COMPARE.md |
| `/finance screen` | Investment screener (UCITS ETFs for German investors) | FINANCE-SCREEN.md |
| `/finance quick` | 60-second snapshot — no detailed data needed | Terminal output |
| `/finance report-pdf` | Combines all reports into a client-ready PDF | FINANCE-PLAN.pdf |

### What it does NOT do

- Does NOT execute trades or move money
- Does NOT access client bank accounts
- Does NOT replace a licensed financial advisor (Finanzberater), tax advisor (Steuerberater),
  or insurance broker (Versicherungsmakler) for regulated advice
- Does NOT know about changes in German law after its knowledge cutoff — verify limits
  (JAEG, BBG, Beitragssätze) annually at bmas.de and gesetzliche-krankenkassen.de

### Who should use this

- Financial advisors preparing client meetings
- Assistants helping gather and organize client financial data
- Anyone creating educational analysis for German clients (Angestellte and Selbstständige)

---

## 2. Setup Checklist

Complete this once before using the system with any client.

### Prerequisites

- [ ] Claude Code installed on your computer
      Install: https://claude.ai/download (choose "Claude Code" desktop app)
- [ ] Claude account with active subscription (Pro or Team recommended)
- [ ] This skill set installed. Run in your terminal:
      ```bash
      cd /path/where/you/cloned/ai-finance-claude
      # e.g.: cd ~/projects/ai-finance-claude
      ./install.sh
      ```
      You should see "INSTALLATION COMPLETE" and a list of installed skills.
- [ ] Python 3.8+ installed (for PDF report generation)
      Check: `python3 --version`
- [ ] ReportLab installed. Run once:
      ```bash
      python3 -m venv ~/.claude/skills/finance/venv
      ~/.claude/skills/finance/venv/bin/pip install reportlab
      ```
      (macOS Homebrew Python blocks system-wide pip — venv is the fix)

### Creating a Client Workspace

Each client should have their own folder. Create one before starting:

```bash
mkdir ~/clients/CLIENTNAME_YYYYMMDD
cd ~/clients/CLIENTNAME_YYYYMMDD
```

**Always open Claude Code from inside the client folder.** This ensures all output files
(FINANCE-ANALYSIS.md, FINANCE-DEBT.md, etc.) save to the correct client directory and
not mixed with other clients' files.

```bash
# From inside the client folder:
claude   # opens Claude Code in this directory
```

### Verify Installation Works

In Claude Code, type:
```text
/finance quick
```
If it asks for your monthly income, expenses, savings, debt, age, and retirement age — installation is working.

---

## 3. Client Intake — What Data to Collect

Gather this information before the first Claude session. A phone call or intake form works
well. You do NOT need everything — the more you have, the more accurate the analysis.

### Block A — Basic Profile (always collect)

| Item | Example | Notes |
|------|---------|-------|
| Age | 38 | Date of birth preferred |
| Employment type | Angestellter / Selbstständiger | GmbH-GF counts as Angestellter for GKV if hired |
| Gross annual income (Bruttojahreseinkommen) | €72,000 | Before all deductions |
| Net monthly take-home (Nettolohn) | €3,850 | What hits bank account |
| Marital status | verheiratet | Plus partner's employment + income |
| Children | 2 (ages 4, 7) | Affects emergency fund, insurance, tax |
| State (Bundesland) | Bayern | Affects Grunderwerbsteuer, Kirchensteuer |
| Kirchenmitglied? | ja / nein | Affects Kirchensteuer calculation |

### Block B — Assets (collect for analyze, networth, portfolio)

| Item | Example |
|------|---------|
| Girokonto + Tagesgeldkonto balance | €4,200 + €12,000 |
| ETF/Depot value (which broker?) | €45,000 bei Trade Republic |
| bAV (betriebliche Altersvorsorge) balance | €18,500 |
| Rürup-Rente value | €0 |
| Immobilienwert (estimate) | €380,000 |
| Restschuld Baufinanzierung | €195,000 |
| Fahrzeugwert (KBB-equivalent) | €12,000 |

### Block C — Liabilities (collect for debt, analyze)

| Item | Example |
|------|---------|
| Baufinanzierung — balance, rate, monthly rate | €195k, 2.3%, €980/mo |
| Autokredit | €8,500, 5.9%, €220/mo |
| Dispositionskredit (Dispo) drawn? | €0 drawn (limit €3,500) |
| Ratenkredite / personal loans | — |
| Kreditkartenschulden | €0 |

### Block D — Monthly Expenses (collect for budget, quick)

| Category | Amount |
|----------|--------|
| Warmmiete or Baufi + Nebenkosten | €1,400 |
| Lebensmittel (groceries) | €600 |
| Transport (Auto, ÖPNV, Tanken) | €350 |
| Restaurantbesuche / Lieferdienst | €200 |
| Versicherungen (alle zusammen) | €280 |
| Strom, Gas, Internet, Telefon | €210 |
| Freizeit, Sport, Hobbys | €150 |
| Kleidung, Haushalt, Shopping | €200 |
| Sonstiges | €100 |

### Block E — Retirement (collect for retirement, fire)

| Item | Example |
|------|---------|
| Target retirement age | 62 |
| Expected Jahresrente (from Renteninformation DRV) | €1,850/month at 67 |
| bAV projected benefit | €420/month at 65 |
| Expected annual spending in retirement | €40,000 today's € |

### Block F — Insurance (collect for insurance skill)

| Item | Answer |
|------|--------|
| GKV oder PKV? Welche Kasse? Monatsbeitrag? | GKV, TK, €380 (AN-Anteil) |
| Berufsunfähigkeitsversicherung vorhanden? Rente? | ja, €2,000/mo |
| Risikolebensversicherung? Versicherungssumme? | ja, €300,000 |
| Haftpflichtversicherung? | ja |
| Hausratversicherung? | ja |
| Testament / Vollmacht vorhanden? | nein |

### Block G — Goals (collect for goals, fire)

| Item | Example |
|------|---------|
| Top 3 financial goals | 1. Hauskauf 2030, 2. Kinder-Ausbildung, 3. Frühverrentung 62 |
| Already saved toward goal? | €5,000 für Hauskauf |

### Tips for Intake

- **Renteninformation**: Client should have their annual DRV letter. If not, they can request
  one at rentenbescheid.de or their DRV regional office.
- **Rough estimates are fine**: The system can work with approximations. Don't let missing
  data block a session — note what's missing and proceed.
- **Nettolohn vs Brutto**: For most calculations the system needs BOTH. Nettolohn = after
  all taxes AND Sozialversicherungsbeiträge (not just income tax).
- **bAV details**: Ask for the most recent bAV Standmitteilung (annual statement from insurer).

---

## 4. Core Workflow — New Client

### The Standard New Client Sequence

Follow this order for every new client engagement. Each step builds on the last.

```
Step 1: /finance quick          ← 5 minutes, builds rapport, identifies urgent gaps
Step 2: /finance insurance      ← Always second — BU gap often most critical action
Step 3: /finance analyze        ← Full picture, 5 parallel agents, 15-20 minutes
Step 4: Deep-dives as needed    ← /finance retirement, /finance taxes, etc.
Step 5: /finance report-pdf     ← Generates client-ready PDF from all outputs
```

---

### Step 1: Quick Snapshot (`/finance quick`)

**Purpose:** Fast 60-second health check. Great ice-breaker. No deep data required.

**Prompt to use:**

```text
/finance quick
```

Claude will ask for 6 numbers. Have Block A and Block D from your intake form ready.
It asks for: monthly income, monthly expenses, total savings, total debt, age, retirement age.

**What you get:** A scored health card (A–F) with top 3 priority actions. Shows immediately
if there are urgent issues (Dispo debt, no emergency fund, critical retirement gap).

**Time:** 3–5 minutes.

---

### Step 2: Insurance Analysis (`/finance insurance`)

**Purpose:** In Germany, BU (Berufsunfähigkeit) and Haftpflicht gaps are the highest-impact
unaddressed risk for most working adults. Run this early to identify critical gaps.

**Prompt to use:**

```text
/finance insurance
```

Claude will ask about employment type, income, age, family, GKV/PKV, and existing coverage.
Have Block A and Block F from intake ready.

**Key outputs to watch:**

- **BU gap** — if >€500/month gap: flag as urgent action item
- **Haftpflicht missing** — if yes: immediate action (€50–130/year, takes 10 minutes online)
- **GKV Kassenwahl** — if Zusatzbeitrag >0.5% above cheapest comparable: switching saves money

**Time:** 10–15 minutes.

---

### Step 3: Full Analysis (`/finance analyze`)

**Purpose:** Produces the comprehensive Financial Health Score (0–100) across 5 categories.
This is the main deliverable for most client engagements.

**Prompt to use:**

```text
/finance analyze
```

Claude will ask ~30 questions across all Blocks (A–G). Collect all blocks before this session.

**5 parallel agents analyze:**

1. Cash Flow & Budget (Spar- und Ausgabenanalyse)
2. Debt Strategy (Schuldenabbau)
3. Investment Allocation (Depot-Analyse mit UCITS ETFs)
4. Retirement Readiness (GRV + bAV + Rürup + privates Depot)
5. Protection (BU, GKV/PKV, Haftpflicht, Testament)

**Output:** FINANCE-ANALYSIS.md with score dashboard, detailed findings, and a 90-day action plan.

**Time:** 15–25 minutes (runs 5 agents in parallel).

---

### Step 4: Deep-Dives (as needed)

Run these after `/finance analyze` when a category score is low or the client has a specific need:

| If the score or situation shows... | Run this skill |
|------------------------------------|----------------|
| Retirement score < 60 | `/finance retirement` |
| High tax burden, Selbstständiger, or above 60k income | `/finance taxes` |
| Client asking about buying a home | `/finance compare Kauf Miete` |
| Wants FIRE / early retirement | `/finance fire` |
| Multiple debts, Dispo drawn | `/finance debt` |
| No investment portfolio yet | `/finance screen` or `/finance portfolio` |
| Specific savings goals (Hauskauf, Ausbildung) | `/finance goals` |
| Net worth check with milestones | `/finance networth` |

---

### Step 5: Generate PDF Report (`/finance report-pdf`)

**Purpose:** Compile all FINANCE-*.md files from the session into a single client-ready PDF.

**Prerequisite:** At minimum, `/finance analyze` must have been run first.

**Prompt to use:**

```text
/finance report-pdf
```

**Output:** FINANCE-PLAN.pdf in the current client folder. ~9 pages.

**Before delivering to client:** Always review the PDF yourself. Add a cover page note
stating this is for educational purposes and refer them to their licensed advisor for
execution. Do NOT deliver AI-generated financial analysis as professional financial advice.

---

### Recommended Session Structure

**Session 1 — Intake & Quick Wins (45–60 min)**

1. Run `/finance quick` → get initial score
2. Run `/finance insurance` → identify urgent protection gaps
3. Identify and communicate top 3 immediate actions to client
4. Book follow-up session

**Session 2 — Full Analysis (60–90 min)**

1. Run `/finance analyze` → full Financial Health Score
2. Discuss findings with client
3. Run 1–2 deep-dives based on weakest areas
4. Run `/finance report-pdf`
5. Deliver PDF, walk through action plan

**Ongoing — Quarterly Review (30 min)**

1. Update numbers in a new client folder
2. Re-run `/finance analyze`
3. Compare new score to previous → show progress
4. Re-run any skill where action was taken

---

## 5. Skill Reference with Prompts

For each skill: the trigger prompt, what data to have ready, and what to watch for in the output.

---

### `/finance quick` — 60-Second Snapshot

**Trigger:**

```text
/finance quick
```

**Data needed:** Monthly Nettolohn, monthly total expenses (rough), total liquid savings,
total debt balance, age, target retirement age.

**Sample answer session:**

```
Claude: What's your monthly take-home income?
You: €3,850

Claude: Monthly expenses?
You: €3,200

Claude: Total liquid savings (not retirement)?
You: €16,000

Claude: Total debt?
You: €204,000 (Baufinanzierung + Autokredit)

Claude: Age?
You: 38

Claude: Target retirement age?
You: 62
```

**Watch for in output:**

- Grade and score — anything below B warrants a follow-up session
- Emergency fund status — below 3 months: immediate action
- Retirement track status — "Critically Behind" means run `/finance retirement` urgently

---

### `/finance insurance` — Versicherungsanalyse

**Trigger:**

```text
/finance insurance
```

**Data needed:** Block A + Block F from intake form.

**Key prompts Claude will ask:**

- "Angestellter oder Selbstständiger?"
- "Bruttogehalt pro Jahr?"
- "GKV oder PKV? Welche Kasse? Monatlicher Beitrag (Arbeitnehmeranteil)?"
- "BU-Versicherung vorhanden? Wenn ja: monatliche Rente und Karenzzeit?"
- "Haftpflichtversicherung vorhanden?"

**Watch for in output:**

- BU gap > €500/month → flag, refer to unabhängiger Versicherungsmakler
- Haftpflicht missing → tell client to go to check.de or Huk-Coburg.de TODAY
- GKV Kassenwahl suboptimal → calculate annual savings and show client
- GKV vs PKV recommendation → for clients near or above JAEG (€73,800 gross, 2025)

**Important:** For BU and PKV decisions, always recommend consulting an unabhängiger
Versicherungsmakler (not a tied agent). Resources: BdV.de, Verbraucherzentrale.de.

---

### `/finance analyze` — Full Financial Health

**Trigger:**

```text
/finance analyze
```

**Data needed:** All Blocks A–G ideally. Minimum: A, B, C, D to get meaningful results.

**What Claude will ask (30 questions, grouped):**

- Demographics, goals, risk tolerance
- Gross + net income, income stability
- Monthly fixed + variable expenses
- All assets (Depot, bAV, Tagesgeld, Immobilie)
- All liabilities (Baufi, Autokredit, Dispo, Ratenkredite)
- Insurance (GKV/PKV, BU, Haftpflicht)
- Retirement contributions (bAV Entgeltumwandlung, ETF-Sparplan, Rürup)

**Tip:** Have the client's intake form printed. Answer Claude's questions directly from it.
If a number is missing, say "ca. €X" or "unknown" — Claude will flag it in the report.

**Score interpretation:**

| Score | Grade | What to tell the client |
|-------|-------|------------------------|
| 85–100 | A+ | "Strong foundation. Minor tweaks only." |
| 70–84 | A | "Good overall. 2–3 areas to improve." |
| 55–69 | B | "Average. Clear action plan will help significantly." |
| 40–54 | C | "Below average. Multiple gaps — let's prioritize." |
| <40 | D/F | "Urgent attention needed. Start with top 3 actions immediately." |

---

### `/finance taxes` — Steueroptimierung

**Trigger:**

```text
/finance taxes
```

**Best for:** Clients earning above €60,000 gross, Selbstständige, clients with investment income,
clients asking about bAV maximization.

**Data needed:** Income, filing status, current bAV contribution, Rürup if Selbstständig,
investment accounts with approximate gains/dividends.

**Key opportunities the skill surfaces:**

- **bAV Entgeltumwandlung**: up to €3,624/year (2025) tax + SV-free (saves ~€1,000–1,800/year
  in taxes AND social contributions for average earner)
- **Rürup-Rente** (Selbstständige): up to €27,566/year deductible
- **Sparerpauschbetrag**: first €1,000 of investment income tax-free — check Freistellungsauftrag set
- **Verlustverrechnungstopf**: year-end review — offset gains with losses before Dec 31
- **Kirchensteuer**: if high capital income, note Kirchensteuer impact

**Important:** All tax strategies need CPA (Steuerberater) review before implementation.
This skill identifies opportunities; the Steuerberater executes.

---

### `/finance retirement` — Rentenplanung

**Trigger:**

```text
/finance retirement
```

**Data needed:** Block A + Block E. Critical: DRV Renteninformation (annual letter).

**Key things Claude calculates:**

- GRV projected pension (Rentenpunkte × current pension value)
- bAV projected benefit
- Private depot projected value at retirement
- Gap between needed income and total projected income
- Probability of success at current savings rate

**Watch for:**

- "3-Säulen-Lücke" (gap across all 3 pillars) — if large, prioritize bAV + Depot contributions
- Retirement before 67 → check Abzüge (0.3%/month penalty for each month before FRA)
- GKV KVdR eligibility — important for clients with FIRE ambitions

---

### `/finance fire` — Finanzielle Freiheit / FIRE

**Trigger:**

```text
/finance fire
```

**Note for German clients:**

- FI number is ~33× annual spending (not 25×) due to Abgeltungsteuer (26.375% flat on all gains)
- GKV in early retirement: full contribution applies (min ~€240–360/month as freiwillig Versicherter)
- PKV in early retirement: full premium alone, no employer subsidy — expensive

**Sample prompt follow-up:**

```
My client wants to retire at 55. Current age 38, portfolio €180,000, savings rate 35%.
Please include GKV healthcare costs in retirement and the German Abgeltungsteuer in the
SWR calculation.
```

---

### `/finance compare` — Szenarien-Vergleich

**Trigger:**

```text
/finance compare [Szenario A] [Szenario B]
```

**Most common German comparisons:**

Kauf vs Miete:

```text
/finance compare Eigentumswohnung kaufen Miete weiterzahlen
```

GKV vs PKV (as a standalone comparison):

```text
/finance compare GKV PKV
```

bAV vs ETF-Sparplan:

```text
/finance compare bAV-Entgeltumwandlung ETF-Sparplan
```

Job offer comparison:

```text
/finance compare neuer Job aktueller Job
```

**Critical for Kauf vs Miete:** Claude will ask for purchase price. Remind client that
transaction costs in Germany are 7–12% (Grunderwerbsteuer 3.5–6.5% + Notar ~1.5% +
Grundbuch ~0.5% + Makler ~3.57%). This dramatically changes the break-even timeline.

---

### `/finance debt` — Schuldenabbau

**Trigger:**

```text
/finance debt
```

**Data needed:** Block C — each debt with balance, APR, monthly payment.

**Priority order Claude follows:**

1. **Dispo first** — typically 8–15% APR, must be eliminated before investing
2. **Ratenkredite** — APR-based priority
3. **Autokredit** — usually 4–8%
4. **Baufinanzierung** — usually lowest APR (2–5%)

**Important German nuance:** There are no federal student loan protections in Germany
(unlike US). Bildungskredite (KfW) are treated like any other debt.

---

### `/finance portfolio` — Depot-Analyse

**Trigger:**

```text
/finance portfolio
```

**Critical note for German clients:** US-listed ETFs (VTI, VOO, BND, etc.) **cannot be
purchased** by German retail investors (PRIIPs/MiFID II regulation). The skill recommends
UCITS-compliant equivalents:

- VTI → iShares Core MSCI World (EUNL)
- VOO → iShares Core S&P 500 (SXR8)
- BND → iShares Core € Govt Bond (EUN4)
- VWO → iShares Core MSCI EM (EIMI)

**Brokers to recommend:**

- Trade Republic (no custody fee, €1/trade, free Sparplan)
- Scalable Capital (Prime or free plan)
- ING DiBa (established, strong Sparplan selection)
- DKB (good Tagesgeld + depot combination)

---

### `/finance screen` — ETF-Auswahl

**Trigger:**

```text
/finance screen [strategy]
```

**Strategies:**

```text
/finance screen three-fund-portfolio
/finance screen dividend-income
/finance screen bonds
/finance screen ESG
```

**For beginner clients:**

```text
/finance screen three-fund-portfolio
```

This produces the simplest, lowest-cost allocation:

- iShares MSCI World (EUNL) — world developed markets
- iShares MSCI EM (EIMI) — emerging markets
- iShares € Govt Bond (EUN4) — bonds

---

### `/finance goals` — Ziel-Sparplan

**Trigger:**

```text
/finance goals
```

**Common German goal scenarios:**

Hauskauf:

```
I want to save for a house down payment of €80,000 plus transaction costs
(estimate 10% of €400,000 = €40,000) = €120,000 total, in 5 years.
Currently saved: €8,000.
```

Kinderausbildung (note: no 529 equivalent in Germany):

```
I want to save for my child's living costs during university study.
Child is 3 years old. German university tuition is free but living costs
are €800-1,200/month for 4 years. Target: €50,000 in today's euros in 15 years.
```

---

### `/finance report-pdf` — PDF-Report

**Trigger:**

```text
/finance report-pdf
```

**Prerequisite:** Must be run AFTER at least `/finance analyze` in the same client folder.

**Output:** FINANCE-PLAN.pdf — 9 pages, color-coded, with charts and action table.

**Before sharing:** Add a manual cover page or email note stating:

> "Dieser Report wurde von einem KI-System erstellt und dient ausschließlich
> Informationszwecken. Er ersetzt keine Finanz- oder Steuerberatung."

---

## 6. Common Client Scenarios

### Scenario A: Angestellter, 35, considering GKV→PKV switch

**Client says:** "I just got a raise to €80,000. My colleague says I should switch to PKV."

**Your response workflow:**

1. Run `/finance insurance`
2. Supply: age 35, Angestellter, €80,000 gross, GKV, family status (critical!)
3. If married with children: PKV almost certainly not worth it (Familienversicherung benefit lost)
4. If single, healthy, no dependents: PKV may save money short-term but check retirement impact
5. Always refer to unabhängiger Versicherungsmakler for actual switch decision

**Key prompt:**

```
/finance insurance

I'm a 35-year-old Angestellter earning €82,000 gross per year. I'm currently in GKV
(TK), paying €380/month (Arbeitnehmeranteil). I'm married, my wife works part-time
(€12,000/year), and we have one child (age 2). No pre-existing conditions. I'm
considering PKV. Please analyze whether PKV makes sense.
```

---

### Scenario B: Selbstständige, 42, no pension savings

**Client says:** "I've been self-employed for 8 years and haven't saved for retirement."

**Your response workflow:**

1. Run `/finance quick` to get baseline
2. Run `/finance retirement` to calculate the gap
3. Run `/finance taxes` to show Rürup benefit (up to €27,566 deductible)
4. The urgency: at 42, they have ~25 years to retirement. Compound growth still works.

**Key prompt:**

```
/finance retirement

I'm a 42-year-old Selbstständige with no bAV and no Rürup. I'm not in the
statutory pension (GRV). My annual income is €95,000 gross, net approximately
€58,000. I have €40,000 in an ETF depot. I want to retire at 65. My estimated
retirement spending is €48,000/year (today's euros). No other pension income expected.
Please calculate my gap and what I need to contribute monthly.
```

Follow up with:

```
/finance taxes

Same client as above. Show me the Rürup-Rente tax benefit at their income level
and how much they should contribute annually to maximize the deduction.
```

---

### Scenario C: Junges Paar, Hauskauf in 3–5 Jahren

**Client says:** "We want to buy a house in 4 years. How much do we need to save?"

**Your response workflow:**

1. Run `/finance goals` for the savings plan
2. Run `/finance compare Kauf Miete` if they're unsure buy vs rent is right
3. Key German fact to communicate: 7–12% transaction costs on top of purchase price

**Key prompt:**

```
/finance goals

My clients are a couple, both Angestellte. Combined net income €5,800/month.
They want to buy a house in 4 years priced around €450,000 in Bayern
(Grunderwerbsteuer 3.5%). They need:
- 20% down payment: €90,000
- Grunderwerbsteuer: €15,750 (3.5%)
- Notar + Grundbuch: ~€9,000 (2%)
- Makler: ~€16,000 (3.57%)
- Total needed: approximately €131,000

Currently saved for this: €22,000 (in Tagesgeldkonto)
Monthly available to save: €1,200

Please build a 4-year savings plan and recommend the right vehicle.
```

---

### Scenario D: Client with high Dispo debt

**Client says:** "I have €4,500 on my Dispo, €12,000 car loan, and €180,000 mortgage."

**Key insight to share:** Dispo (overdraft) in Germany typically charges 8–15% APR.
This is the highest-cost debt and must be eliminated first — even before starting
an ETF-Sparplan.

**Key prompt:**

```
/finance debt

My client has the following debts:
1. Dispo (overdraft): €4,500 at 12.5% APR (minimum: full balance on demand)
2. Autokredit: €12,000 at 5.9% APR, €280/month
3. Baufinanzierung: €180,000 at 2.1% APR (10-year fixed), €850/month

Monthly surplus after expenses: €600
What's the optimal payoff strategy? Include total interest cost comparison.
```

---

### Scenario E: Client wants FIRE, age 38, income €110,000

**Client says:** "I want to retire at 52. Is that possible?"

**Key German-specific factors to communicate:**

- FI number is 33× annual spending (not 25×) due to Abgeltungsteuer
- GKV in early retirement: ~€240–480/month as freiwillig Versicherter (income-based)
- DRV pension will be reduced for years not worked (but can buy Rentenpunkte)

**Key prompt:**

```
/finance fire

My client is 38 years old, Angestellter, earning €110,000 gross (net ~€68,000/year).
Current investment portfolio: €220,000 (all UCITS ETFs in taxable depot).
Monthly savings: €3,200.
Expected retirement spending: €5,000/month in today's euros.
Retirement target age: 52.
Currently in GKV. No PKV.

Please calculate:
1. FI number (adjusted for German Abgeltungsteuer at 26.375%)
2. Years to FIRE at current savings rate
3. GKV cost in early retirement before KVdR eligibility
4. Coast FIRE status
```

---

### Scenario F: Client asking "should I invest or pay off mortgage?"

**Client says:** "I have €500/month extra. Should I overpay my mortgage or invest in ETFs?"

**Key prompt:**

```
/finance compare Sondertilgung ETF-Sparplan

My client has a mortgage at 3.2% APR (10-year fixed, 8 years remaining).
€500/month available for either mortgage overpayment or ETF investing.
They are 45 years old, in the 42% income tax bracket.
10-year time horizon.
Please compare total wealth impact of both strategies.
```

**Context to provide:** In Germany, mortgage interest is NOT tax-deductible for personal
residences (unlike US). This changes the after-tax comparison.

---

## 7. Reading the Output Files

All FINANCE-*.md files are saved in the client's folder. Open them in any text editor,
VS Code, or use `cat FINANCE-ANALYSIS.md` in the terminal to read them.

### FINANCE-ANALYSIS.md — The Master Report

**Score Dashboard** (top of report):

- Five category scores (0–100) and composite score
- Grade A+/A/B/C/D/F
- Weakest category = highest priority for client action

**Cash Flow section:**

- Check savings rate — target ≥15% of Nettolohn
- Flag if housing cost >30% of Bruttolohn (German benchmark)

**Debt section:**

- DTI ratio — target back-end DTI <36%
- Payoff timeline — show client visually

**Retirement section:**

- Gap in € — show "what you're projected to have vs what you need"
- Years of portfolio longevity — if <25 years, recommend contribution increase

**90-Day Action Plan:**

- Use this directly in the client meeting
- Tasks are ordered by impact — start from the top

### FINANCE-INSURANCE.md

**BU gap** — shown in € per month. If gap >€500/month: refer to Versicherungsmakler.
**GKV optimization** — monthly savings from switching Kasse. High-leverage action.
**Haftpflicht missing** — always an immediate action if shown.

### FINANCE-TAXES.md

**Tier 1 actions** — "Do this quarter" — highest ROI tax strategies
**Annual savings** — each strategy shows estimated € savings
**Year-end checklist** — use this in Q4 client meetings

### FINANCE-RETIREMENT.md

**Gap table** — three scenarios (conservative 5%, moderate 6%, aggressive 7%)
**"Needed monthly contribution to close gap"** — the key number to communicate
**GRV section** — shows claiming age recommendation

### FINANCE-PLAN.pdf

**Page 1:** Cover + Financial Health Score gauge
**Page 8:** Top 10 Action Items — use this as the meeting agenda
**Page 9:** 90-Day Plan — hand this to the client

### File Management

After each session, all FINANCE-*.md files are in the client folder. To start fresh
for a new session (don't mix old data):

```bash
mkdir ~/clients/CLIENTNAME_YYYYMMDD_v2
cd ~/clients/CLIENTNAME_YYYYMMDD_v2
claude
```

---

## 8. Limitations and Escalation Rules

### What This System Cannot Do

| Limitation | What to do instead |
|------------|-------------------|
| Cannot give personalized investment advice (Anlageberatung) | Licensed advisor with WpHG authorization |
| Cannot give tax advice (Steuerberatung) | Steuerberater (tax advisor) |
| Cannot give insurance advice (Versicherungsberatung im Sinne VVG) | Unabhängiger Versicherungsmakler |
| Cannot give legal advice (estate, contracts) | Notar or Anwalt |
| Cannot know current Beitragssätze, JAEG, BBG for current year | Verify annually at bmas.de, gkv-spitzenverband.de |
| Cannot access real client accounts or data | Client must supply all numbers |
| Cannot execute trades, set up accounts, or file documents | Client or advisor does this |

### When to Escalate (Always)

**Immediately escalate to licensed professionals when:**

1. **BU gap >€500/month** → Unabhängiger Versicherungsmakler (use BdV.de or Verbraucherzentrale)
2. **Client considering GKV→PKV switch** → Unabhängiger Versicherungsmakler (this is a lifelong decision)
3. **Steuernachzahlung >€5,000 or complex self-employed tax situation** → Steuerberater
4. **Estate planning (Testament, Erbvertrag, Schenkung)** → Notar
5. **Investment amounts >€100,000** → Consider regulated investment advisor (§ 32 KWG)
6. **Client in financial distress** (Insolvenz, Schuldnerberatung) → Schuldnerberatung (often free via Caritas, AWO)
7. **Mental health overlap with financial stress** → Appropriate referral

### Data Caveats to Always Communicate

When delivering any report to a client:

1. "These figures are based on data you provided on [date]. Update when circumstances change."
2. "Contribution limits, tax rates, and thresholds are based on [year] figures. Verify current values."
3. "Investment projections assume historical average returns. Actual returns will vary."
4. "This is educational analysis, not regulated financial advice."

### German Legal Note

This system produces **educational information** (Informationsmaterial). It is NOT:

- Anlageberatung (§ 2 WpHG) — requires BaFin authorization
- Versicherungsberatung (§ 34d GewO) — requires license
- Steuerberatung (StBerG) — requires Steuerberater license
- Rechtsberatung (RDG) — requires Anwalt

Ensure your disclaimer footer is on all client-facing documents.

---

## 9. Quick Reference Card

### Skill Decision Tree

```
New client?
  │
  ├─ Run: /finance quick           (always first)
  ├─ Run: /finance insurance       (always second)
  └─ Run: /finance analyze         (full picture)

Specific need?
  ├─ Insurance check only    → /finance insurance
  ├─ Tax optimization        → /finance taxes
  ├─ Retirement gap          → /finance retirement
  ├─ FIRE / early retirement → /finance fire
  ├─ Buy vs rent             → /finance compare Kauf Miete
  ├─ Debt payoff             → /finance debt
  ├─ ETF allocation          → /finance portfolio
  ├─ ETF selection           → /finance screen
  ├─ Savings goals           → /finance goals
  ├─ Net worth snapshot      → /finance networth
  └─ PDF report              → /finance report-pdf (after analyze)
```

### Key German Numbers to Know (2025 — verify annually at bmas.de)

| Figure | 2025 Value | Used in |
|--------|-----------|---------|
| JAEG (PKV threshold for Angestellte) | €73,800/year gross | /finance insurance |
| BBG KV (GKV contribution ceiling) | €5,512.50/month | /finance insurance |
| GKV avg total rate | ~16.3% (14.6% + ~1.7% Zusatzbeitrag) | /finance insurance |
| bAV deferred max (SV-free) | €3,624/year (4% of BBG RV) | /finance taxes |
| Rürup max deductible (single) | €27,566/year | /finance taxes |
| Sparerpauschbetrag | €1,000/person; €2,000 married | /finance taxes, portfolio |
| Abgeltungsteuer rate | 25% + 5.5% Soli = 26.375% | /finance portfolio, fire |
| GRV retirement age (standard) | 67 | /finance retirement |
| GRV early retirement (45 Beitragsjahre) | 63 | /finance retirement |
| Einlagensicherung (deposit insurance) | €100,000 per bank | /finance emergency |

### Common German Acronyms

| Acronym | Full term | Meaning |
|---------|-----------|---------|
| GKV | Gesetzliche Krankenversicherung | Statutory health insurance |
| PKV | Private Krankenversicherung | Private health insurance |
| KVdR | Krankenversicherung der Rentner | Health insurance in retirement |
| GRV | Gesetzliche Rentenversicherung | State pension |
| DRV | Deutsche Rentenversicherung | German pension authority |
| bAV | Betriebliche Altersvorsorge | Occupational pension |
| BU | Berufsunfähigkeitsversicherung | Occupational disability insurance |
| JAEG | Jahresarbeitsentgeltgrenze | Annual income threshold for GKV |
| BBG | Beitragsbemessungsgrenze | Contribution ceiling |
| ETF | Exchange-Traded Fund | Index fund (use UCITS type for Germany) |
| UCITS | Undertakings for Collective Investment in Transferable Securities | EU-regulated fund structure required for German investors |
| Dispo | Dispositionskredit | Bank overdraft (typically 8–15% APR) |
| DTI | Debt-to-Income Ratio | Schulden-zu-Einkommens-Verhältnis |
| SWR | Safe Withdrawal Rate | Sicherer Entnahmebetrag (use 3% net for Germany due to Abgeltungsteuer) |

---

**Version:** German market adaptation, 2025 data
**Maintained by:** [Your practice name]
**Last verified:** 2026-06-13
**Verify annually:** bmas.de, gesetzliche-krankenkassen.de, bundesfinanzministerium.de
