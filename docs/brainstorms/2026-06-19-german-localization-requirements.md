# German Market Localization — Requirements

**Date:** 2026-06-19  
**Status:** Approved for planning  
**Scope:** Standard

---

## Problem

All 15 finance skills were written for the US market. They reference USD, US tax law (401k/IRA/HSA/Social Security/ACA), US brokerages (Vanguard/Fidelity/Schwab), US ETF tickers (VTI/VXUS/BND), and US benchmarks (Federal Reserve net worth percentiles, Trinity Study 4% rule assumptions). Some skills contain partial German content (insurance, emergency fund, analyze) from a prior incomplete attempt. The skills cannot be used as-is for German clients without producing incorrect or misleading guidance.

---

## Primary Outcome

All 15 skills produce financially accurate guidance for German employed clients (Angestellte), using EUR, German tax law, German financial products, and German benchmarks. Skills output in English with German financial context and terminology.

---

## Target Client Profile

- **Market:** Germany only
- **Primary client:** Angestellte (employed, not self-employed)
- **Language:** English output, German financial context
- **Currency:** EUR

Self-employed (Freiberufler/Gewerbetreibender) is out of scope for this migration. Where self-employment topics arise naturally (e.g., Rürup as a product option), they may be mentioned but not deeply covered.

---

## Architecture Decision

Create `skills/shared/german-context.md` as a single source of truth for all volatile German financial constants. Each skill loads this file before analysis. Stable German concepts and decision logic live inline in each skill; only annually-changing numbers live in the shared file.

**Why shared file:** German limits change reliably every January (BBG, Grundfreibetrag, Beitragssätze, bAV limits). Without a shared file, annual updates touch 15 files and drift is guaranteed.

---

## Shared Context File — Contents

`skills/shared/german-context.md` must include (2026 values, updated annually):

| Constant | Value |
|---|---|
| Grundfreibetrag | €12,096 (single), €24,192 (married) |
| Sparerpauschbetrag | €1,000 (single), €2,000 (married) |
| Beitragsbemessungsgrenze (BBG) West | €96,600/year |
| bAV steuerfreier Anteil | 8% of BBG = €7,728/year |
| Riester max Eigenbeitrag | €2,100/year (incl. state Zulagen) |
| Riester Grundzulage | €175/year |
| Riester Kinderzulage | €185/child (€300 post-2008 birth) |
| Rürup max Abzug (2026) | 100% of Höchstbetrag = €29,344 (single) |
| JAEG (GKV/PKV threshold) | €73,800/year |
| GKV Beitragssatz | 14.6% + Zusatzbeitrag ~1.7% ≈ 16.3% total, split 50/50 |
| Kapitalertragsteuer | 25% flat + 5.5% Soli = ~26.375% effective |
| Regelrentenalter | 67 |
| Früheste Rente (langjährig Versicherte) | 63 (45 Beitragsjahre) |
| Pflegepflichtversicherung | 3.4% (no children), 3.05% (with children), split 50/50 |
| Rentenversicherung Beitragssatz | 18.6%, split 50/50 |

---

## Skill-by-Skill Replacement Map

### High-impact rewrites (content fundamentally changes)

**finance-taxes**
- Remove: 401k limits, IRA, HSA, backdoor Roth, wash sale rule, SALT cap, US state taxes, estate tax $13.99M, Roth conversion ladder
- Add: Steuerklassen (I–VI) and their effect on Lohnsteuer, Kapitalertragsteuer 25% + Soli, Sparerpauschbetrag optimization, Günstigerprüfung, Kirchensteuer, Steuererstattung via ELSTER, Anlage KAP, Anlage Vorsorgeaufwand, Riester/Rürup as Sonderausgaben, bAV Steuerfreiheit, year-end loss harvesting within Kapitalertragsteuer rules

**finance-retirement**
- Remove: 401k/IRA/Roth/HSA/Social Security age milestones (62/67/70), Medicare A/B/D/Medigap, RMD age 73, ACA
- Add: Rentenversicherung (18.6%, Entgeltpunkte system, Regelrentenalter 67, early at 63 with 45 Beitragsjahre), bAV (Direktversicherung, Pensionskasse, Pensionsfonds), Riester-Rente (Zulagen, Eigenanteil, Wohn-Riester), Rürup-Rente (for higher earners, Sonderausgabenabzug), GKV/PKV in retirement (Pflichtversicherung der Rentner), ELSTER Rentenbesteuerung (gradually increasing to 100% by 2058)

**finance-portfolio**
- Remove: VTI, VXUS, BND tickers; Vanguard/Fidelity/Schwab; 401k/IRA/Roth/HSA tax buckets; foreign tax credit; US/International split as primary framework
- Add: EU-domiciled UCITS ETFs (iShares Core MSCI World IE00B4L5Y983, Xtrackers MSCI World IE00BJ0KDQ92, iShares Core MSCI EM), German brokerages (Trade Republic, Scalable Capital, DKB, ING, Comdirect, Consorsbank), tax-account types (Depot, bAV, Riester, Rürup), Vorabpauschale (annual ETF notional tax), Teilfreistellung (30% equity ETF exemption), Freistellungsauftrag setup

**finance-fire**
- Remove: Social Security integration (62/67/70), ACA healthcare bridge, Roth conversion ladder, US geographic arbitrage cities, US state tax considerations
- Add: Rentenversicherung bridge (freiwillige Beiträge to fill gaps), GKV in early retirement (freiwillig versichert, income-tested contributions), EU/Portugal/Croatia/Canary Islands geographic arbitrage for German earners, German Kapitalertragsteuer on withdrawals, Günstigerprüfung at low income levels

**finance-screen**
- Remove: US Dividend Aristocrats (JNJ/PG/KO/PEP/MMM), US-only tickers
- Add: European dividend stocks, DAX/MDAX dividend payers, STOXX Europe 600, EU-domiciled ETFs with distributing share classes, note on Quellensteuer for non-German dividends and Anrechnungsverfahren

**finance-networth**
- Remove: Federal Reserve benchmarks, US age-based multipliers ($10k at 25, $625k at 65)
- Add: Bundesbank/DIW German wealth distribution data, German median net worth context (Germany has notably low median wealth vs. EU peers due to low homeownership rates), German Immobilienquote context

### Medium rewrites (significant sections change)

**finance-analyze** — Replace W-2/1099/FICA with Bruttolohn/Nettolohn/Lohnsteuer/SV-Abgaben. Replace 401k/IRA with bAV/Riester. Already has partial German insurance questions — keep and clean up.

**finance-goals** — Replace 529 plan with Bildungssparen/Juniorsdepot/Ausbildungsversicherung. Replace US college cost assumptions with German/EU Studiengebühren (mostly free in Germany, ~€150-350 Semesterbeitrag). Replace HYSA with Tagesgeld/Festgeld rates.

**finance-insurance** — Already most complete German content (GKV/PKV, JAEG, Krankenversicherung, Berufsunfähigkeitsversicherung). Clean up any remaining US references. Add: Haftpflichtversicherung, Rechtsschutzversicherung, Hausratversicherung as standard recommendations.

**finance-debt** — Replace US revolving credit / credit card model dominance with German context: Dispo (overdraft), Ratenkredite, Baufinanzierung. Replace FICO with SCHUFA. Replace DTI front/back-end (US lending standard) with German Haushaltsrechnung / Bonitätsprüfung model.

**finance-compare** — Replace US mortgage APR assumptions, US property tax 1.1%, US maintenance 1% with German Grunderwerbsteuer (3.5–6.5% by Bundesland), Notarkosten (~1.5%), Maklergebühr (~3.57%), German Grundsteuer (highly variable, post-reform 2025), Instandhaltungsrücklage.

### Lighter updates (mostly numbers and product names)

**finance-budget** — Replace US expense benchmarks with German equivalents. Replace cell plan cost assumptions. Currency to EUR throughout.

**finance-emergency** — Replace HYSA 4-5% with Tagesgeld rates (currently ~2.5–3.5% in EUR). Replace US insurance gap framing with GKV framing (healthcare always covered). Already has Notgroschen reference — keep.

**finance-quick** — Replace US DTI thresholds and age-based multipliers with German benchmarks. Currency to EUR.

---

## German Financial Concepts — Reference Glossary

Skills should use these German terms with English explanations on first mention per skill:

| German Term | English meaning (for in-skill usage) |
|---|---|
| Rentenversicherung | statutory pension insurance |
| Entgeltpunkte | pension credit points (1.0 = average earner) |
| Betriebliche Altersvorsorge (bAV) | employer-sponsored occupational pension |
| Riester-Rente | state-subsidized private pension (Angestellte) |
| Rürup-Rente | private pension for higher earners / self-employed |
| Krankenversicherung (GKV/PKV) | statutory / private health insurance |
| JAEG | annual income threshold above which PKV is eligible |
| Kapitalertragsteuer | flat 25% capital gains / investment income tax |
| Sparerpauschbetrag | annual tax-free investment income allowance |
| Grundfreibetrag | annual income tax-free allowance |
| Steuerklasse | tax bracket class (I–VI, affects withholding) |
| Freistellungsauftrag | standing order to broker to apply Sparerpauschbetrag |
| Vorabpauschale | annual notional ETF tax on unrealized gains |
| Teilfreistellung | 30% exemption on equity ETF gains |
| ELSTER | German online tax portal |
| SCHUFA | German credit bureau (equivalent to credit score) |
| Tagesgeld | instant-access savings account (like HYSA) |
| Festgeld | fixed-term deposit |
| Depot | investment brokerage account |

---

## Out of Scope

- Self-employed (Freiberufler / Gewerbetreibender) specific guidance
- Austrian or Swiss market
- Non-German EU markets
- German-language output (skills remain in English)
- Corporate / business tax advice
- Trust / foundation structures

---

## Success Criteria

1. Zero US-specific financial products, account types, or tax constructs remain in any skill after migration
2. All annual limits sourced from `skills/shared/german-context.md` — no hardcoded numbers in individual skills
3. `finance-taxes`, `finance-retirement`, `finance-portfolio`, `finance-fire`, `finance-screen`, `finance-networth` pass a spot-check against 2026 German law
4. `finance-insurance` remains the most complete German skill — no regression from current state
5. Any client running `/finance analyze` on a typical Angestellte profile (€60k gross, Steuerklasse I, GKV, bAV via employer) receives accurate, actionable German-market guidance

---

## Open Questions

1. **Vorabpauschale calculation complexity** — Should `finance-portfolio` explain Vorabpauschale mechanics in full, or just recommend setting a Freistellungsauftrag and leave the calculation to the broker? (Planning decision)
2. **Rentenauskunft integration** — Should `finance-retirement` prompt users to retrieve their Deutsche Rentenversicherung Kontoauszug/Rentenauskunft as a data input? Likely yes — confirms Entgeltpunkte — but needs a prompt template.
3. **FIRE Krankenversicherung in early retirement** — GKV freiwillige Mitgliedschaft has income-tested minimum contributions (~€220/month floor in 2026). Worth a dedicated section or just a callout?
4. **net worth benchmarks** — German wealth data from Bundesbank/DIW has lower granularity than Fed SCF. May need to rely on HFCS (ECB Household Finance and Consumption Survey) data instead.

---

## Handoff Notes for Planning

- Start with shared context file creation before touching individual skills
- Recommended skill update order: `finance-taxes` → `finance-retirement` → `finance-portfolio` → `finance-fire` → then remaining 11
- `finance-insurance` requires least change; good sanity-check baseline
- Each skill should include `<!-- Load skills/shared/german-context.md before analysis -->` or equivalent instruction convention (planning decides exact mechanism)
