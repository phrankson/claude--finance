![AI Personal Finance Advisor](.github/banner.svg)

# AI Personal Finance Advisor — German Edition

> **AI-Powered Financial Planning for German Clients — 15 skills, 5 parallel agents, professional PDF reports.**
>
> Optimized for Angestellte and Selbstständige. GKV/PKV · bAV · GRV · UCITS ETFs · Abgeltungsteuer.

> ⚠️ **Kein Ersatz für Finanz-, Steuer- oder Versicherungsberatung.** Dieses Tool dient ausschließlich Informations- und Bildungszwecken. Consult a licensed financial advisor (Finanzberater), tax advisor (Steuerberater), or insurance broker (Versicherungsmakler) before making any financial decisions.

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Skills](https://img.shields.io/badge/Skills-15-brightgreen.svg)
![Agents](https://img.shields.io/badge/Agents-5-orange.svg)
![PDF Reports](https://img.shields.io/badge/PDF%20Reports-YES-success.svg)
![Claude Code](https://img.shields.io/badge/Built%20for-Claude%20Code-7c5cff.svg)
![Market](https://img.shields.io/badge/Market-Germany-black.svg)

---

## Why This Exists

Most financial planning tools are built for US markets — 401(k), IRA, HYSA, Social Security. None of that applies to German clients.

This system is purpose-built for **German Angestellte and Selbstständige**:

- GKV vs PKV decision with 2025 JAEG (€73,800) and BBG figures
- bAV Entgeltumwandlung (€3,624/year SV-free, employer 15% mandatory top-up)
- Rürup-Rente for Selbstständige (€27,566/year deductible, 2025)
- UCITS ETFs only — US-listed ETFs (VTI, VOO, BND) are **legally unavailable** to German retail investors (PRIIPs/MiFID II)
- Abgeltungsteuer (26.375% flat) in all investment projections
- FIRE number at **33× spending** (not 25×) to account for Abgeltungsteuer
- KVdR 9/10 rule for healthcare in early retirement
- Dispo-first debt strategy, Schufa context

It produces the same multi-dimensional analysis — cash flow, debt strategy, investment allocation, retirement projections, tax optimization, insurance audit, FIRE planning — **as a professional PDF report**, generated in minutes, inside Claude Code.

---

## What It Does

- 📊 **Financial Health Score (0–100)** — composite score across 5 dimensions with letter grade
- 🏥 **GKV vs PKV Analysis** — full cost comparison, decision matrix, retirement healthcare risk
- 💛 **BU Gap Calculation** — Berufsunfähigkeit coverage vs Erwerbsminderungsrente gap
- 🏦 **Cash Flow Analysis** — Nettolohn breakdown, savings rate, expense benchmarks
- 💳 **Debt Payoff Strategy** — Dispo first, avalanche method, payoff timeline
- 📈 **Investment Allocation Review** — UCITS ETF recommendations, Sparerpauschbetrag, Verlustverrechnungstopf
- 🎯 **Retirement Projections** — GRV (Rentenpunkte) + bAV + private depot, 3-pillar gap
- 🔥 **FIRE Calculator** — 33× rule, Abgeltungsteuer-adjusted SWR, GKV in early retirement
- 🧾 **Tax Optimization** — bAV, Rürup, Sparerpauschbetrag, Kirchensteuer, year-end checklist
- 🛡️ **Protection Audit** — BU, Haftpflicht, GKV/PKV, Risikolebens, estate documents
- 📋 **Top 10 Action Items** — prioritized by impact, ready to execute
- 🗓️ **90-Day Plan** — month-by-month tasks
- 📄 **Professional PDF Report** — 9-page client-ready deliverable

---

## Installation

**One-command install (recommended):**

```bash
curl -fsSL https://raw.githubusercontent.com/phrankson/claude--finance/main/install.sh | bash
```

**Local install:**

```bash
git clone https://github.com/phrankson/claude--finance.git
cd claude--finance
./install.sh
```

**Uninstall:**

```bash
# Interactive (prompts for confirmation)
./uninstall.sh

# Non-interactive / scripted
./uninstall.sh --yes

# Remote uninstall (interactive terminal)
curl -fsSL https://raw.githubusercontent.com/phrankson/claude--finance/main/uninstall.sh | bash

# Remote uninstall (non-interactive / CI)
curl -fsSL https://raw.githubusercontent.com/phrankson/claude--finance/main/uninstall.sh | bash -s -- --yes
```

The installer:
- Checks Python 3.8+
- Creates a Python venv at `~/.claude/skills/finance/venv/` and installs ReportLab into it (compatible with macOS Homebrew Python / PEP 668)
- Copies the orchestrator to `~/.claude/skills/finance/`
- Copies all 15 sub-skills to `~/.claude/skills/finance-*/`
- Copies the PDF generator to `~/.claude/skills/finance/scripts/`

---

## Command Reference

| Command | What It Does |
|---------|-------------|
| `/finance` | **Main orchestrator** — routing hub for all skills |
| `/finance quick` | 60-second snapshot — score, signal, top 3 actions |
| `/finance analyze` | Full multi-agent analysis (5 parallel agents) |
| `/finance insurance` | GKV vs PKV decision · BU gap · Haftpflicht · Risikolebens |
| `/finance budget` | Cash flow & monthly budget analysis |
| `/finance debt` | Debt payoff — Dispo first, avalanche vs snowball |
| `/finance emergency` | Notgroschen target & build plan |
| `/finance portfolio` | UCITS ETF allocation review |
| `/finance retirement` | GRV + bAV + Depot projections, 3-pillar gap |
| `/finance fire` | FIRE calculator (33× rule, Abgeltungsteuer-adjusted SWR) |
| `/finance taxes` | bAV · Rürup · Sparerpauschbetrag · Verlustverrechnungstopf |
| `/finance networth` | Net worth tracker with milestones |
| `/finance goals` | Goal-based savings plans (Hauskauf, Ausbildung, etc.) |
| `/finance compare` | Kauf vs Miete · bAV vs ETF · job offers · scenarios |
| `/finance screen` | ETF screener (UCITS only, German-eligible) |
| `/finance report-pdf` | Generate client-ready PDF from saved analysis |

---

## How It Works

When you run `/finance analyze`, the orchestrator launches **5 parallel sub-agents**:

1. **Cash Flow Agent** — Nettolohn breakdown, savings rate, expense-to-income ratios
2. **Debt Agent** — Dispo-first strategy, payoff timeline, total interest cost
3. **Investment Agent** — UCITS ETF allocation, Abgeltungsteuer impact, Verlustverrechnungstopf
4. **Retirement Agent** — GRV Rentenpunkte projection + bAV + private depot gap analysis
5. **Protection Agent** — BU gap, GKV/PKV adequacy, Haftpflicht, estate documents

Each agent scores 0–100. The orchestrator synthesizes them into a composite **Financial Health Score** (letter grade A+ to F).

```
┌─────────────────────┐
│ /finance analyze    │  ← user types in Claude Code
└──────────┬──────────┘
           │
     ┌─────▼──────┐
     │Orchestrator │
     └─────┬──────┘
           │  launches 5 in parallel
   ┌───────┼───────┬───────┬────────┐
   ▼       ▼       ▼       ▼        ▼
 Cash    Debt   Invest  Retire  Protect
   │       │       │       │        │
   └───────┴───────┼───────┴────────┘
                   ▼
            Composite Score
                   ▼
               PDF Report
```

---

## Recommended Workflow

**New client session (60–90 min total):**

```
1. /finance quick          → 5 min — ice-breaker, identifies urgent gaps
2. /finance insurance      → 10–15 min — BU + GKV/PKV often most critical
3. /finance analyze        → 15–25 min — full picture, 5 parallel agents
4. /finance [deep-dive]    → as needed, based on weakest category score
5. /finance report-pdf     → generates client-ready PDF
```

See `docs/DE-BERATER-GUIDE.md` for the full junior advisor manual — intake form, copy-paste prompts for all skills, 6 German client scenarios, escalation rules, and the 2025 key numbers reference card.

---

## Key German Numbers (2025)

| Figure | Value | Used in |
|--------|-------|---------|
| JAEG (GKV threshold) | €73,800/year gross | `/finance insurance` |
| BBG KV (GKV ceiling) | €5,512.50/month | `/finance insurance` |
| GKV avg rate | ~16.3% (14.6% + ~1.7% Zusatzbeitrag) | `/finance insurance` |
| bAV deferred max (SV-free) | €3,624/year | `/finance taxes` |
| Rürup max deductible (single) | €27,566/year | `/finance taxes` |
| Sparerpauschbetrag | €1,000/person; €2,000 married | `/finance taxes` |
| Abgeltungsteuer | 25% + 5.5% Soli = 26.375% | `/finance portfolio`, `/finance fire` |
| GRV standard retirement age | 67 | `/finance retirement` |
| FIRE FI multiplier | 33× (not 25×) | `/finance fire` |
| Einlagensicherung | €100,000 per bank | `/finance emergency` |

Verify annually at [bmas.de](https://www.bmas.de) and [gkv-spitzenverband.de](https://www.gkv-spitzenverband.de).

---

## Project Structure

```
claude--finance/
├── README.md
├── LICENSE
├── install.sh                        # venv-aware installer (PEP 668 compatible)
├── uninstall.sh                      # supports --yes flag for non-interactive removal
├── requirements.txt
├── .gitignore
├── .github/
│   └── banner.svg
├── finance/                          # main orchestrator skill
│   └── SKILL.md
├── skills/                           # 15 sub-skills
│   ├── finance-quick/
│   ├── finance-analyze/
│   ├── finance-insurance/            # GKV/PKV · BU · Haftpflicht (new)
│   ├── finance-budget/
│   ├── finance-debt/
│   ├── finance-emergency/
│   ├── finance-portfolio/
│   ├── finance-retirement/
│   ├── finance-fire/
│   ├── finance-taxes/
│   ├── finance-networth/
│   ├── finance-goals/
│   ├── finance-compare/
│   ├── finance-screen/
│   └── finance-report-pdf/
├── scripts/
│   └── generate_finance_pdf.py       # ReportLab PDF generator
└── docs/
    ├── DE-BERATER-GUIDE.md           # junior advisor manual (German)
    └── superpowers/plans/
        └── 2026-06-13-junior-advisor-guide.md
```

---

## PDF Report (9 pages)

| Page | Content |
|------|---------|
| 1 | **Cover** — Financial Health Score gauge, grade, executive summary |
| 2 | **Score Dashboard** — bar charts for 5 categories |
| 3 | **Cash Flow** — Nettolohn breakdown, savings rate, expense benchmarks |
| 4 | **Debt** — accounts table, Dispo priority, payoff timeline |
| 5 | **Investments** — UCITS ETF allocation, current vs target |
| 6 | **Retirement** — GRV + bAV + Depot gap, 3-pillar projection |
| 7 | **Protection** — BU gap, GKV/PKV status, Haftpflicht, estate checklist |
| 8 | **Top 10 Actions** — prioritized by € impact |
| 9 | **90-Day Plan** — Foundation → Acceleration → Optimization |

**Demo:**

```bash
~/.claude/skills/finance/venv/bin/python3 ~/.claude/skills/finance/scripts/generate_finance_pdf.py --demo
# → FINANCE-PLAN-sample.pdf
```

---

## Use Cases

- 🏥 **GKV vs PKV decision** — clients above JAEG threshold or becoming Selbstständige
- 🏖️ **Früh in Rente** — FIRE planning with Abgeltungsteuer and GKV in early retirement
- 🏠 **Hauskauf** — affordability with German transaction costs (7–12%), Kauf vs Miete
- 💛 **BU gap audit** — Erwerbsminderungsrente averages ~€960/month; most clients are underinsured
- 💼 **Selbstständige onboarding** — no GRV, no bAV, Rürup-Rente as only tax-deductible pension
- 📈 **bAV optimization** — Entgeltumwandlung saves both taxes AND Sozialversicherungsbeiträge
- 💳 **Dispo elimination** — 8–15% APR; highest-priority debt before any investing
- 🎯 **Quarterly review** — track score progress and rerun after life changes

---

## Advisor Guide

`docs/DE-BERATER-GUIDE.md` is a complete instruction manual for junior advisors:

- **Section 3** — Client intake form (7 blocks: profile, assets, liabilities, expenses, retirement, insurance, goals)
- **Section 4** — Core workflow with session structures (intake, full analysis, quarterly review)
- **Section 5** — Copy-paste prompts for every skill with what to watch for in output
- **Section 6** — 6 German client scenarios with full prompts (GKV→PKV, Selbstständige, Hauskauf, Dispo, FIRE, mortgage vs ETF)
- **Section 8** — Escalation rules with legal thresholds (WpHG, VVG §34d, StBerG, RDG)
- **Section 9** — Quick reference card: 2025 figures + German acronym glossary

---

## License

[MIT License](LICENSE) — Free to use, modify, and build services on top of.

---

## Disclaimer

**This software does NOT constitute financial advice (Finanzberatung im Sinne des WpHG), insurance advice (Versicherungsberatung im Sinne des VVG §34d GewO), tax advice (Steuerberatung im Sinne des StBerG), or legal advice (Rechtsberatung im Sinne des RDG).**

All outputs are educational and informational. They are based on user-provided inputs and general financial principles. Always consult:

- A **licensed financial advisor (Finanzberater)** for investment decisions
- A **Steuerberater** for tax matters
- An **unabhängiger Versicherungsmakler** for insurance decisions (BdV.de, Verbraucherzentrale.de)
- A **Notar or Anwalt** for estate and legal matters

Investment projections assume historical average returns. Actual returns will vary. Contribution limits, tax thresholds, and insurance figures are based on 2025 values — verify current figures annually at bmas.de, bundesfinanzministerium.de, and gkv-spitzenverband.de.

**If a client is in financial distress, facing Insolvenz or Privatinsolvenz, or making decisions involving significant sums, refer them to a Schuldnerberatung (free via Caritas, AWO, or VbZ) before using this tool.**

---

*Built with [Claude Code](https://claude.com/claude-code) — Anthropic's official CLI for Claude.*
