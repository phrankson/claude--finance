---
title: "refactor: Migrate all finance skills to German market"
date: 2026-06-19
origin: docs/brainstorms/2026-06-19-german-localization-requirements.md
type: refactor
depth: standard
---

# refactor: Migrate all finance skills to German market

## Summary

Replace all US-specific financial content across 15 finance skills with German-market equivalents. Create a shared German context file as a single source of truth for annually-changing constants. Target clients are German Angestellte; output stays in English with German financial terminology.

---

## Problem Frame

All 15 skills were built for US personal finance. They reference 401k, IRA, Social Security, ACA, USD, US brokerages, and US tax law. Some skills contain partial German content from an earlier incomplete attempt. Running any skill for a German client produces materially incorrect guidance.

See origin: `docs/brainstorms/2026-06-19-german-localization-requirements.md`

---

## Requirements

- Zero US-specific financial products, account types, or tax constructs remain after migration
- All annually-changing German constants (BBG, Grundfreibetrag, bAV limits, JAEG, etc.) sourced from `skills/shared/german-context.md`; no hardcoded EUR amounts in individual skill bodies
- Each skill references `.claude/skills/shared/german-context.md` at runtime via an explicit load instruction
- `finance-taxes`, `finance-retirement`, `finance-portfolio`, `finance-fire`, `finance-screen`, `finance-networth` pass a spot-check against 2026 German law
- A sample Angestellte profile (€60k gross, Steuerklasse I, GKV, bAV via employer) produces accurate, actionable guidance from `/finance analyze`
- `finance-insurance` fully restructured — solid German content (GKV/PKV, BU, JAEG) preserved and extended with Haftpflicht/Rechtsschutz/Hausrat

---

## Key Technical Decisions

**KTD1 — Shared context file is a runtime read, not a build-time injection.**
Skills include an explicit instruction: "Before analysis, read `.claude/skills/shared/german-context.md` for 2026 German financial constants." Claude reads the file when executing the skill. Path `.claude/skills/shared/german-context.md` is the installed path — correct for end users. Source is `skills/shared/german-context.md`; install.sh's existing wildcard loop (`for dir in "${src}"/*/`) deploys it to `.claude/skills/shared/` without modification.
_Rationale:_ No build step, no templating system, no install.sh changes required.

**KTD2 — All 15 skills get a structural rewrite, including finance-insurance.**
Even finance-insurance (already 554 lines of solid German content) is rebuilt to conform to the new shared context reference convention, the updated annual limits, and a consistent skill structure. The existing GKV/PKV/BU content is preserved and carried forward; structure and integration with the shared file are the change.
_Rationale:_ User confirmed structural rewrite; consistent structure across all skills reduces maintenance burden.

**KTD3 — US→German mapping follows requirements doc.**
Key substitutions: 401k/IRA/Roth → bAV/Riester/Rürup; Social Security → Rentenversicherung; ACA/Medicare → GKV/PKV; USD → EUR; Vanguard/Fidelity/Schwab → Trade Republic/DKB/ING/Scalable Capital; VTI/VXUS/BND → EU-domiciled UCITS ETFs (iShares MSCI World, Xtrackers); FICO → SCHUFA; Federal Reserve net worth benchmarks → Bundesbank/DIW/HFCS data; 4% Trinity Study → retained as starting point but contextualized with Rentenversicherung bridge and GKV impact.
See: `docs/brainstorms/2026-06-19-german-localization-requirements.md` (German Financial Concepts section)

**KTD4 — Skill structure follows established pattern.**
Frontmatter: `name` + `description` only. Sections: shared context load instruction → title + disclaimer → when to use → data collection → methodology → output template → quality standards + handoff. Cross-skill references via `/finance <id>` command inline text.

---

## Scope Boundaries

**In scope:** All 15 skill SKILL.md files + `skills/shared/german-context.md` creation. Germany only. Angestellte focus.

**Out of scope:** install.sh changes; self-employed profiles; German-language output; `finance/SKILL.md` orchestrator (unchanged); non-German EU markets; agents directory.

### Deferred to Follow-Up Work
- Freiberufler/Selbständige variant skills
- Annual limit update automation (cron job to update german-context.md)
- ELSTER integration or form-filling guidance
- DACH expansion (Austria/Switzerland)

---

## Implementation Units

### U1. Create shared German context file

**Goal:** Single source of truth for all annually-changing German financial constants. Installed to `.claude/skills/shared/german-context.md` via existing install mechanism.

**Requirements:** All annual limits must come from here; no hardcoded amounts in individual skills.

**Dependencies:** None.

**Files:**
- `skills/shared/german-context.md` _(create)_

**Approach:** Plain markdown document (no YAML frontmatter — not a skill, just a reference file). Organized into sections: Tax Constants, Social Insurance, Retirement Accounts, Investment Context, Credit & Debt, Benchmarks. Each constant includes its German name, value, and a one-line note on what triggers it. Data for 2026 from requirements doc; include a comment noting the update-by date (January each year).

**Test scenarios:**
- All 2026 constants from requirements doc present: Grundfreibetrag €12,096, Sparerpauschbetrag €1,000/€2,000, BBG West €96,600, bAV 8% BBG = €7,728, Riester max €2,100, JAEG €73,800, Kapitalertragsteuer 26.375%, Regelrentenalter 67, Rentenversicherung 18.6%
- File parseable by Claude without frontmatter confusion (no YAML block that would be mistaken for a skill)
- Install: after running install.sh locally, verify `.claude/skills/shared/german-context.md` exists with correct content

**Verification:** File exists at `skills/shared/` in source and deploys correctly. Constants match 2026 values. No US references.

---

### U2. Rewrite finance-taxes

**Goal:** Replace all US tax strategy content with German Steueroptimierung for Angestellte.

**Requirements:** No 401k/IRA/HSA/backdoor Roth/SALT/wash sale; covers Steuerklassen, Kapitalertragsteuer, Sparerpauschbetrag, Günstigerprüfung, Riester/Rürup as Sonderausgaben, bAV tax-freeness, Freistellungsauftrag, Kirchensteuer.

**Dependencies:** U1

**Files:**
- `skills/finance-taxes/SKILL.md` _(rewrite)_

**Approach:** Data collection gathers Steuerklasse, Bruttogehalt, Kirchenzugehörigkeit, Kapitalerträge (last year), Riester/bAV status, Freistellungsauftrag allocation. Strategy framework covers: Steuerklassenwahl (III/V vs IV/IV), Riester als Sonderausgabe (€2,100 cap, Zulagen reduce Eigenbeitrag), bAV (up to 8% BBG tax-free), Sparerpauschbetrag optimization across multiple Depots, Günstigerprüfung (only when marginal rate < 25%), Kirchensteuer reduction strategies, year-end Verlustverrechnung within Kapitalertragsteuer rules, ELSTER Steuererklärung via Anlage KAP + Anlage Vorsorgeaufwand.

**Patterns to follow:** `skills/finance-insurance/SKILL.md` structure (section-based methodology, output template at end)

**Test scenarios:**
- Sample profile (€60k gross, Steuerklasse I, GKV, bAV €200/month, no Riester): skill identifies Riester gap, Freistellungsauftrag status, bAV optimization as top 3 actions
- Skill output references ELSTER, not TurboTax or H&R Block
- No mention of 401k, IRA, HSA, backdoor Roth, SALT, federal/state tax brackets
- Kirchensteuerpflichtiger profile: Kirchensteuer appears as a line item in strategy
- Günstigerprüfung scenario: low capital income (€300) with marginal rate 20% → skill recommends triggering Günstigerprüfung

**Verification:** Output file FINANCE-TAXES.md contains no US tax references; all strategy items are legally valid in Germany 2026.

---

### U3. Rewrite finance-retirement

**Goal:** Replace US retirement planning (401k/Social Security/Medicare) with German Rentenplanung (Rentenversicherung/bAV/Riester/Rürup/GKV in Rente).

**Requirements:** Cover Rentenversicherung Entgeltpunkte system, Regelrentenalter 67, early retirement at 63 (45 Beitragsjahre), bAV payout options, Riester Auszahlungsphase (30% Einmalauszahlung rule), Rürup lifelong annuity, GKV Pflichtversicherung der Rentner (KVdR), Rentenbesteuerung trajectory to 100% by 2058.

**Dependencies:** U1

**Files:**
- `skills/finance-retirement/SKILL.md` _(rewrite)_

**Approach:** Data collection: birth year, Rentenversicherungsverlauf (Entgeltpunkte known/estimated), current employer bAV contract, Riester contract (provider, Zulage history), Rürup if applicable, GKV/PKV status, target retirement age. Methodology: project Rentenversicherung monthly payout (Entgeltpunkte × aktueller Rentenwert; 2026 West: €39.32), model bAV payout, calculate Rentenbesteuerungsanteil by year, model GKV contributions in retirement (KVdR: 14.6% of Renteneinkünfte, halved if KVdR-pflichtversichert). Surface gap to Rentenlücke. Recommend action steps by age (under 45 / 45-55 / 55+).

**Patterns to follow:** U2 structure

**Test scenarios:**
- Profile (35yo, 10 Entgeltpunkte so far, bAV, no Riester): skill surfaces Rentenlücke calculation, recommends Riester Zulagen-check, flags Rentenbesteuerungsanteil rising to 100% by 2058
- No mention of Social Security, 401k, Medicare, ACA, RMD age 73
- Early retirement scenario (target age 63): skill confirms 45 Beitragsjahre requirement and flags Abzüge (0.3% per month early)
- PKV retiree: skill flags that KVdR does not apply; PKV Beitrag continues from own income

**Verification:** All payout calculations use 2026 Rentenwert. No US references. Output file FINANCE-RETIREMENT.md is structurally complete.

---

### U4. Rewrite finance-portfolio

**Goal:** Replace US-centric portfolio (VTI/VXUS/BND, Vanguard/Fidelity, 401k/IRA tax buckets) with EU-compliant German investor portfolio.

**Requirements:** EU-domiciled UCITS ETFs only; German brokerages; tax account types (Depot, bAV, Riester, Rürup); Vorabpauschale and Teilfreistellung explained; Freistellungsauftrag setup; no US tickers or US-only fund families.

**Dependencies:** U1

**Files:**
- `skills/finance-portfolio/SKILL.md` _(rewrite)_

**Approach:** Data collection: current Depot(s) with broker names, bAV/Riester/Rürup holdings, monthly savings rate, Freistellungsauftrag status across brokers, risk tolerance, investment horizon. Core framework: three-account structure (Tagesgeld emergency fund, steuerbegünstigte Rentenkonten [bAV/Riester], taxable Depot for UCITS ETFs). Recommended ETF building blocks: iShares Core MSCI World (SWDA/IE00B4L5Y983), iShares Core MSCI EM IMI (EIMI), iShares Core Euro Corp Bond for bond allocation. Brokers: Trade Republic (0€ per trade, Sparplan), Scalable Capital (PRIME), DKB, ING. Tax section: Vorabpauschale = Rücknahmepreis Jan 1 × Basiszins × 0.7 × Teilfreistellung 70%; Freistellungsauftrag allocation strategy across brokers. Note: Vorabpauschale calculation explained conceptually — broker handles it automatically.

**Test scenarios:**
- Profile (€500/month savings, existing €10k Depot at Comdirect, GKV, bAV via employer): skill recommends completing bAV first, then Depot with MSCI World Sparplan
- No mention of VTI, VXUS, BND, Vanguard, Fidelity, Schwab, HSA, Roth
- Vorabpauschale question: skill explains it exists, broker calculates it, and Freistellungsauftrag offsets it
- Multi-broker Freistellungsauftrag: profile with 3 brokers receives advice on €1,000 allocation

**Verification:** All fund ISINs are EU-domiciled (IE or LU prefix). All brokers are German-licensed. Tax mechanics match 2026 Abgeltungsteuer rules.

---

### U5. Rewrite finance-fire

**Goal:** Replace US FIRE planning (Social Security bridge, ACA, Roth conversion ladder, US cities) with German Frugalisten/FIRE context.

**Requirements:** Rentenversicherung bridge (freiwillige Beiträge), GKV freiwillige Mitgliedschaft in early retirement (income-tested, ~€220/month floor), EU geographic arbitrage destinations, Kapitalertragsteuer on withdrawals at low income (Günstigerprüfung), Entnahmerechner in EUR.

**Dependencies:** U1

**Files:**
- `skills/finance-fire/SKILL.md` _(rewrite)_

**Approach:** Data collection: target FIRE age, current Rentenversicherung Entgeltpunkte, monthly Entnahmebedarf (EUR), current portfolio size, tax situation (Steuerklasse, expected income in FIRE). FIRE number: 25× annual spending (4% rule, Trinity Study retained as baseline), adjusted for Rentenversicherung income starting at 63/67. GKV in early retirement: freiwillige Mitgliedschaft, minimum beitragspflichtige Einnahmen = €1,178/month floor (2026) → minimum GKV €193/month (16.3% × floor), actual scales with income up to BBG. Geographic arbitrage: Portugal (NHR regime, Madeira), Kroatien, Kanarische Inseln, Spanien — all EU, no Sozialversicherungspflicht considerations for passive income. Rentenversicherung: freiwillige Beiträge €100.07–€1,404.90/month to fill gap years and secure KVdR eligibility later (9/10 zweite Hälfte des Erwerbslebens rule).

**Test scenarios:**
- FIRE at 45, €3,000/month need, €900k portfolio: skill calculates GKV minimum at ~€220/month, deducts from safe withdrawal, identifies Rentenversicherung gap until 67, recommends freiwillige Beiträge
- No mention of Social Security, ACA, Roth conversion ladder, US state tax, US cities
- Geographic arbitrage section mentions EU destinations, not Mexico/Thailand as primary
- Günstigerprüfung: low Entnahme (€15k/year) triggers recommendation to file Anlage KAP and claim Günstigerprüfung

**Verification:** All monetary figures in EUR. Rentenversicherung mechanics match 2026 rules. No US-specific tax strategies.

---

### U6. Rewrite finance-screen

**Goal:** Replace US Dividend Aristocrats and US tickers with European dividend investing for German clients.

**Requirements:** EU-domiciled distributing ETFs; European dividend stocks; German/EU dividend taxation (Kapitalertragsteuer + Quellensteuer on foreign dividends); no US-listed tickers.

**Dependencies:** U1

**Files:**
- `skills/finance-screen/SKILL.md` _(rewrite)_

**Approach:** Screen framework: EU-domiciled distributing UCITS ETFs (iShares STOXX Europe 600 UCITS ETF Dist, Vanguard FTSE All-World High Div Yield UCITS ETF Dist) as core; individual European dividend stocks (DAX/MDAX Dividendenaristrokraten: Allianz, Munich Re, BASF, Deutsche Post) as satellite. Quellensteuer section: non-German dividends subject to foreign withholding tax (e.g., 15% US, 15% Swiss after treaty); German broker applies Anrechnungsverfahren (offsetting against Kapitalertragsteuer, max 15% credited). Freistellungsauftrag priority: distributing ETFs generate more taxable events than accumulating → allocate Freistellungsauftrag to distributing holdings first.

**Test scenarios:**
- Profile requests dividend portfolio: output lists EU-domiciled ETFs with ISINs, no US tickers
- Quellensteuer scenario (Swiss stock): skill explains 35% Swiss withholding, 15% reclaimable via Anrechnungsverfahren, 20% lost
- No mention of JNJ, PG, KO, PEP, MMM or Dividend Aristocrats (US definition)

**Verification:** All referenced fund ISINs EU-domiciled. Tax mechanics match German Abgeltungsteuer + DBA rules.

---

### U7. Rewrite finance-networth

**Goal:** Replace US Federal Reserve benchmarks and dollar-denominated targets with German wealth data and EUR targets.

**Requirements:** Use Bundesbank/DIW/ECB HFCS German wealth distribution; acknowledge German context (lower homeownership rate, wealth concentrated in Immobilien among owners); EUR throughout.

**Dependencies:** U1

**Files:**
- `skills/finance-networth/SKILL.md` _(rewrite)_

**Approach:** Net worth calculation unchanged (assets − liabilities). Benchmarks: ECB HFCS 2021 for Germany — median net worth €103k (all), mean €232k; P25 ~€14k, P75 ~€393k, P90 ~€739k. Note: Germany has notably low median vs EU peers (low Wohneigentumsquote ~45% vs EU ~70%). Age-based rules of thumb: retain "Nx income" framework but use German income context and EUR (e.g., 0.5× Jahresbrutto by 30, 3× by 45, 6× by 55, 10× by 65 — these are aspirational targets, not benchmarks). Add Immobilien context: primary residence excluded from investierbares Vermögen for FIRE calculation.

**Test scenarios:**
- Profile (€80k gross, age 35, €40k Depot + €10k Tagesgeld, no Immobilien): skill reports percentile using HFCS data and identifies gap to 0.5× target
- No mention of Federal Reserve, US wealth percentiles, dollar amounts
- Immobilien owner: skill explains whether to include in net worth (yes for total wealth) vs exclude for liquid wealth

**Verification:** All benchmark figures sourced from HFCS 2021 or Bundesbank. No USD.

---

### U8. Rewrite finance-insurance (structural)

**Goal:** Restructure the existing 554-line German skill to conform to the shared context convention, integrate Haftpflicht/Rechtsschutz/Hausrat, and align with 2026 JAEG and GKV constants.

**Requirements:** Preserve GKV/PKV/BU depth; add Haftpflicht, Rechtsschutzversicherung, Hausratversicherung; load from shared context file; update JAEG to 2026 value (€73,800).

**Dependencies:** U1

**Files:**
- `skills/finance-insurance/SKILL.md` _(structural rewrite)_

**Approach:** Rebuild using standard skill structure (KTD4). Carry forward: GKV vs PKV decision tree (JAEG, Kostenvergleich, Familienversicherung, Rückkehrrecht); BU (Berufsunfähigkeitsversicherung — Leistungsdefinition, Wartezeit, Abstrakte Verweisung exclusion); Risikolebensversicherung (for dependents, Restschulden). Add new sections: Haftpflichtversicherung (essential, €10M Deckungssumme minimum, ~€60-80/year), Rechtsschutzversicherung (optional but common for employment law, traffic), Hausratversicherung (Unterversicherungsverzicht clause). Shared context load for JAEG €73,800. GKV Beitragssatz 14.6% + Zusatzbeitrag ~1.7% from shared context.

**Test scenarios:**
- GKV/PKV question with income €75k (above JAEG): skill confirms PKV eligibility, walks through Vor-/Nachteile
- GKV/PKV question with income €65k (below JAEG): skill confirms pflichtversichert, no PKV option
- BU section: skill asks for Beruf (Risikogruppe matters for Beiträge) and recommends 75% of Nettoeinkommen as Zielrente
- Haftpflicht check: profile with no Haftpflichtversicherung → flagged as critical gap
- No mention of ACA, COBRA, Medigap, Medicare, US deductibles

**Verification:** JAEG value matches shared context file. All four insurance categories covered. Cross-skill reference to `/finance retirement` and `/finance analyze` preserved.

---

### U9. Rewrite finance-analyze

**Goal:** Replace W-2/FICA/401k/IRA data collection with German Bruttolohn/Nettolohn/SV-Abgaben framework; clean up the existing partial German content.

**Requirements:** Data collection uses Bruttolohn, Steuerklasse, GKV/PKV, bAV, Riester; output references German financial health metrics; no US income types.

**Dependencies:** U1

**Files:**
- `skills/finance-analyze/SKILL.md` _(rewrite)_

**Approach:** Collect: Jahresbruttolohn, Steuerklasse, GKV/PKV status, bAV (ja/nein, Arbeitgeberzuschuss), Riester (ja/nein), current Tagesgeld/Depot balances, debts (Dispositionskredit, Ratenkredit, Baufinanzierung), monthly Sparrate. Output sections: Liquidität (Notgroschen in Monatsausgaben), Altersvorsorge (bAV/Riester/Rentenversicherung coverage vs Rentenlücke), Versicherungsschutz summary (refer to `/finance insurance`), Schulden (Zinsbelastung, Tilgungsplan), Investiertes Vermögen (Depot, ETF allocation). Cross-skill handoffs: `/finance insurance` for full insurance analysis, `/finance retirement` for Altersvorsorge deep-dive.

**Test scenarios:**
- Profile (€55k gross, Steuerklasse I, GKV, no bAV, no Riester, €5k Tagesgeld): skill flags fehlende bAV, fehlende Riester Zulage, Notgroschen slightly low
- No W-2, 1099, FICA, 401k, IRA references
- DTI-like check: uses Schuldendienstquote (monthly debt payments / Nettoeinkommen) not US DTI formula

**Verification:** Output file FINANCE-ANALYSIS.md contains German financial health framework. No US terms.

---

### U10. Rewrite finance-goals

**Goal:** Replace 529 plans and US college cost assumptions with German Sparziele framework (Studium in Germany is mostly free, emergency fund, Immobilienkauf, Weltreise, etc.).

**Requirements:** No 529 plans, no US college inflation; Studium in Germany covered (Semesterbeitrag €150-350, BAföG context); Tagesgeld/Festgeld for short goals; Depot for long goals.

**Dependencies:** U1

**Files:**
- `skills/finance-goals/SKILL.md` _(rewrite)_

**Approach:** Goal framework: Notgroschen (3-6 Monatsausgaben), Immobilienkauf (Eigenkapital 20% + Kaufnebenkosten), Altersvorsorge (long-term FIRE/Rente), Ausbildung/Studium (Semesterbeitrag + Lebenshaltungskosten; German universities mostly free, note BAföG eligibility), sonstige Ziele (car, Weltreise, etc.). Product matching: < 2 years → Tagesgeld (current rate ~3-3.5% from shared context); 2-5 years → Festgeld; 5+ years → Depot (UCITS ETFs). No HYSA (US-specific); use Tagesgeld equivalent.

**Test scenarios:**
- Goal: fund child's university in 18 years → skill calculates Semesterbeitrag + living costs (not US $100-300k), recommends Juniorsdepot
- No mention of 529 plans, US college costs, HYSA
- Short-term goal (2 years, €10k car): Tagesgeld recommendation with current rate from shared context

**Verification:** All cost estimates in EUR and German context. No US education system references.

---

### U11. Rewrite finance-debt

**Goal:** Replace US credit card-dominant debt model and FICO/DTI with German Dispo/Ratenkredit/Baufinanzierung and SCHUFA.

**Requirements:** SCHUFA replaces FICO; Dispo (overdraft), Ratenkredite, Baufinanzierung as primary debt types; Schuldendienstquote replaces US DTI; no US revolving credit model.

**Dependencies:** U1

**Files:**
- `skills/finance-debt/SKILL.md` _(rewrite)_

**Approach:** Debt inventory: Dispositionskredit (Dispo-Zinsen typically 10-14% p.a. → top priority), Ratenkredite (Effektivzins), Baufinanzierung (Sollzins + Tilgungsplan + Restlaufzeit), sonstige. Prioritization: Zinsbereinigungsstrategie (highest-rate-first vs snowball). Schuldenfreiheits-timeline. SCHUFA: explain Bonitätsscore, Negativmerkmale (Inkasso, offene Forderungen), how debt reduction improves score. Baufinanzierung section: Sondertilgungsrecht (typically 5-10% of Darlehenssumme/year), Anschlussfinanzierung planning, Tilgungsrechner inputs.

**Test scenarios:**
- Profile (€5k Dispo at 12%, €15k Ratenkredit at 5.9%, €200k Baufinanzierung at 3.2%): skill prioritizes Dispo, then Ratenkredit, maintains Baufinanzierung minimum
- No mention of credit cards as primary debt vehicle (can mention Kreditkarte as one category)
- SCHUFA check: profile reports Negativmerkmal → skill explains how long it stays (3 years after settlement) and impact

**Verification:** No US DTI front/back-end calculation (28%/36%). No FICO. All interest rates in % p.a. consistent with German consumer market.

---

### U12. Rewrite finance-compare

**Goal:** Replace US homeownership cost assumptions (property tax 1.1%, 3.5% appreciation, US mortgage APR) with German Immobilienkauf cost structure.

**Requirements:** German Kaufnebenkosten (Grunderwerbsteuer by Bundesland, Notar, Makler), Grundsteuer (post-2025 reform), Instandhaltungsrücklage; EUR throughout; no US mortgage APR assumptions.

**Dependencies:** U1

**Files:**
- `skills/finance-compare/SKILL.md` _(rewrite)_

**Approach:** Rent vs. Buy comparison: Buy costs: Grunderwerbsteuer (3.5-6.5% by Bundesland), Notarkosten (~1.5%), Maklercourtage (typically 3.57% incl. MwSt, split equally since 2020), Grundbucheintrag (~0.5%); total Kaufnebenkosten ~8-12% on top of Kaufpreis. Ongoing: Grundsteuer (highly variable post-2025 reform; ~0.1-0.3% of Einheitswert × neue Steuermesszahl × Hebesatz — too complex to estimate; recommend querying Finanzamt), Instandhaltungsrücklage €10-15/m²/year (WEG recommendation), Hausverwaltung if Eigentumswohnung. Price-to-rent ratio in German cities (Hamburg 30-40×, München 40-50×, Berlin 25-35×). Break-even calculation including Kaufnebenkosten amortization.

**Test scenarios:**
- Compare profile (Munich, €600k apartment, €1,800/month equivalent rent): skill calculates ~10% Kaufnebenkosten (€60k), break-even horizon ~15-20 years at Munich P/E ratios
- No US property tax 1.1% assumption
- Bundesland-specific Grunderwerbsteuer: profile in Bayern → 3.5%; profile in Nordrhein-Westfalen → 6.5%

**Verification:** Kaufnebenkosten percentages match 2026 German law. P/E ratios reflect current German major city market. No US mortgage/property assumptions.

---

### U13. Light updates — budget, emergency, quick

**Goal:** Update the three lighter skills to use EUR, German benchmarks, and Tagesgeld instead of HYSA.

**Requirements:** No USD, no HYSA, no US benchmark ratios; Tagesgeld rates from shared context; German expense benchmarks.

**Dependencies:** U1

**Files:**
- `skills/finance-budget/SKILL.md` _(update)_
- `skills/finance-emergency/SKILL.md` _(update)_
- `skills/finance-quick/SKILL.md` _(update)_

**Approach:**

_finance-budget:_ Currency to EUR. Replace HYSA with Tagesgeld. German expense benchmarks: Miete ≤ 30% Nettoeinkommen (not gross), Lebensmittel, GKV-Beitrag already deducted from Netto. Shared context load instruction added.

_finance-emergency:_ Replace HYSA 4-5% with Tagesgeld ~3-3.5% (from shared context, noted as market-dependent). GKV already provides healthcare coverage — no "healthcare gap" emergency framing. Note that Arbeitslosengeld I (up to 12 months, 60-67% of Nettogehalt) reduces bare-minimum emergency fund requirement for most Angestellte. Keep Notgroschen 3-6 months target. Shared context load instruction added.

_finance-quick:_ Replace US DTI thresholds and age-based multipliers with German equivalents from requirements doc (0.5× Jahresbrutto by 30, 3× by 45, etc.). Replace US benchmarks (Nuveen, etc.) with German equivalents. Currency to EUR. Shared context load instruction added.

**Test scenarios (combined):**
- Budget: sample income €3,500 Netto → Mietanteil check ≤ €1,050; no US cost categories
- Emergency: output recommends Tagesgeld, not HYSA; references Arbeitslosengeld I context
- Quick: age 35 with €100k Nettovermögen → skill compares to 0.5× rule (~€27.5k target at €55k gross); no US multipliers
- All three: no USD, no HYSA, no US-specific ratios

**Verification:** All three SKILL.md files pass grep for USD/$: zero results. Tagesgeld rate pulled from shared context, not hardcoded.

---

## Open Questions

1. **Vorabpauschale explanation depth** (deferred to implementation): Should `finance-portfolio` explain the full Vorabpauschale calculation or just note that brokers handle it automatically and clients should ensure sufficient Freistellungsauftrag headroom? Prefer the simpler framing unless the implementer finds German clients commonly misunderstand it.

2. **Rentenauskunft prompt** (deferred to implementation): Should `finance-retirement` include a specific prompt for the client to retrieve their Deutsche Rentenversicherung Kontoauszug? Likely yes — Entgeltpunkte are the foundation of the analysis. Implementation decision on exact phrasing.

3. **GKV minimum in early FIRE** (deferred to implementation): The 2026 GKV minimum Beitragsbemessungsgrundlage (€1,178/month) and resulting minimum GKV contribution (~€220/month) should be pulled from the shared context file. Implementer: add these to `skills/shared/german-context.md` before writing `finance-fire`.

4. **Bundesland selection for Grunderwerbsteuer** (deferred to implementation): `finance-compare` should ask the user's Bundesland and use the correct rate. Implementation decision on whether to list all 16 Bundesländer rates in the skill or just ask the user.

---

## System-Wide Impact

- All 15 SKILL.md files modified
- New file: `skills/shared/german-context.md`
- Install deploys `skills/shared/` to `.claude/skills/shared/` via existing mechanism
- No changes to: `finance/SKILL.md` orchestrator, `install.sh`, `uninstall.sh`, agents, scripts
- Output files (FINANCE-*.md) produced by skills change content but not filename convention

---

## Sources & Research

- Requirements doc: `docs/brainstorms/2026-06-19-german-localization-requirements.md`
- Skill structure confirmed from `skills/finance-insurance/SKILL.md` (554 lines, most complete German skill)
- Install mechanism confirmed from `install.sh` lines 164-179 (wildcard loop over `skills/*/`)
- German financial constants: requirements doc section "Shared Context File — Contents" (2026 values)
- External research not required: all German financial knowledge is encoded in requirements doc; no library/framework decisions
