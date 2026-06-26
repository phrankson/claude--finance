---
title: "refactor: Translate finance skills from German to English UI"
date: 2026-06-26
origin: docs/brainstorms/2026-06-26-english-language-rewrite-requirements.md
status: ready
---

# refactor: Translate Finance Skills from German to English UI

## Summary

Rewrite all 15 finance skill files to use English for data collection questions, output section headers, table column headers, and behavioral instructions. The German market financial framework (constants, product names, institutional names) is unchanged. German financial terms appear as "English (German)" in output prose on first use per section.

---

## Problem Frame

The finance advisor suite targets English-speaking users operating under the German financial system. Currently, every skill prompts in German and produces German-language output headers. A user who reads no German cannot follow the prompts or interpret the output sections. The fix is a language swap of UI text only — the financial accuracy of the underlying German market data stays intact.

---

## Requirements

All requirements from origin doc (see origin: `docs/brainstorms/2026-06-26-english-language-rewrite-requirements.md`):

- **R1** — Data collection questions in English (German field term in parens where user will encounter it on documents)
- **R2** — Output template section headers in English
- **R3** — German financial terms follow "English (German)" pattern, first use per section; subsequent uses English only; German-only terms (Vorabpauschale, Teilfreistellung, etc.) keep German as primary with English gloss
- **R4** — Behavioral instructions in English throughout
- **R5** — Table column headers in English; data cells follow R3
- **R6** — Trigger phrases unchanged (already English or mixed; do not alter)
- **R7** — DISCLAIMER lines unchanged (already English)
- **R8** — Month names in 12-month plan tables in English (Jan–Dec); "Notizen" → "Notes"

**Out of scope (R9, implicit):** `skills/shared/german-context.md`, all financial constants/rates, German institutional proper nouns (Check24, SCHUFA, Trade Republic, DKB, ELSTER), German regulatory product names as proper nouns (Riester-Rente, Rürup-Rente, bAV, GKV, PKV).

**Translation reference:** Use the "English Explanation" column in `skills/shared/german-context.md` glossary for consistent term mapping. Do not invent alternative translations.

---

## Key Technical Decisions

**KTD1 — finance-budget translated first as the reference implementation.** Its data collection section is the most complete example of the German prompt pattern. Translating it first establishes the "English (German)" term-handling pattern, output template shape, and R1–R8 application before all other files are touched.

**KTD2 — Files grouped by complexity for execution batching.** Files within each batch are independent and can be executed in parallel. U1 (reference) must complete before batches start; batches U2–U5 can run concurrently.

**KTD3 — Trigger phrase sections are left unchanged.** "When to Run" sections contain German trigger phrases (e.g., "Brauche ich PKV?") because German-speaking users may trigger these skills using German phrases. Changing them would break natural-language routing.

---

## Scope Boundaries

### Deferred to Follow-Up Work
- Adding English trigger phrases to supplement existing German ones (additive, not this rewrite's scope)
- Updating `finance/SKILL.md` meta-skill if it contains German text (not a user-facing skill)
- Translating the `docs/DE-BERATER-GUIDE.md` advisor guide

### Not in Scope
- `skills/shared/german-context.md` — already English headers, German terms with English explanations
- Financial constants, benchmark values, and German regulatory amounts
- German institutional proper nouns and product names

---

## Implementation Units

### U1. Translate finance-budget (reference implementation)

**Goal:** Establish the definitive English translation of the budget skill. This file is the pattern reference all other units must match — term handling, output shape, table headers.

**Requirements:** R1, R2, R3, R4, R5, R8

**Dependencies:** None

**Files:**
- `skills/finance-budget/SKILL.md`

**Approach:**
- Translate all "Einkommen", "Fixkosten", "Variable Ausgaben" data collection question labels to English with German term in parens (e.g., "Monthly net income (Nettoeinkommen)")
- Translate all method names: "Umschlagmethode" → "Envelope method (Umschlagmethode)", "Haushaltsbuch" → "household ledger (Haushaltsbuch)"
- Translate analysis framework step labels: "Jeden Euro kategorisieren" → "Categorize every euro"
- Translate benchmark table headers: "Kategorie" → "Category", "Gesunder Bereich" → "Healthy range", "Warnsignal" → "Warning signal"
- Translate output section headers: "Zusammenfassung" → "Summary", "Empfohlenes Budget" → "Recommended Budget", "Identifizierte Verschwendung — Streichliste" → "Identified Waste — Cut List", "Verhaltenstipps" → "Behavioral Tips", "Nächste Schritte" → "Next Steps"
- Translate output table column headers following R5
- Translate 12-month plan month names + "Notizen" → "Notes" (R8)
- Keep behavioral note references to "german-context.md", DISCLAIMER, output filename (FINANCE-BUDGET.md), and all Euro amounts
- Translate handoff instructions at bottom of file

**Patterns to follow:** R3 worked examples in requirements doc: "Emergency fund (Notgroschen)", "occupational pension (bAV)", "statutory health insurance (GKV)"

**Test scenarios:**
- Opening prompt asks all 24 questions in English; German field terms appear in parens for user-facing document terms
- Output FINANCE-BUDGET.md has all section headers in English
- "Notgroschen" appears as "Emergency fund (Notgroschen)" on first use; subsequent uses in same section: "emergency fund"
- 12-month plan table uses Jan–Dec and "Notes" column header
- Trigger phrases ("/finance budget", "Build me a budget") still function correctly — R6 unchanged
- DISCLAIMER text unchanged — R7
- All benchmark tables use English column headers

**Verification:** Every data collection question is English-first; output FINANCE-BUDGET.md renders with English section headers; German market financial constants and product references (Check24, Tagesgeld, bAV) are intact.

---

### U2. Translate short skills — finance-quick, finance-screen, finance-report-pdf

**Goal:** Translate the three shortest skill files, applying the R1–R8 pattern established in U1.

**Requirements:** R1, R2, R3, R4, R5

**Dependencies:** U1 (pattern reference)

**Files:**
- `skills/finance-quick/SKILL.md`
- `skills/finance-screen/SKILL.md`
- `skills/finance-report-pdf/SKILL.md`

**Approach:**
- finance-quick: translate 6 required input labels (e.g., "Monatliches Nettoeinkommen" → "Monthly net income (Nettoeinkommen)"); translate benchmark label sections (Sparquote, Schuldendienstquote, Notgroschen-Abdeckung benchmarks); translate output scorecard section headers
- finance-screen: translate stock screening criteria labels and output section headers
- finance-report-pdf: translate report section labels and output template headers

**Patterns to follow:** U1 translation of finance-budget

**Test scenarios:**
- finance-quick: six input prompts are English; benchmark labels (Ausgezeichnet → Excellent, Gut → Good, Schwach → Weak, Kritisch → Critical) translated; scorecard output headers in English
- finance-screen: screening output section headers in English; German stock exchange names (XETRA, DAX) unchanged as proper nouns
- finance-report-pdf: report section headers in English; financial term references follow R3

**Verification:** All three files have English-first user-facing text; no German prose outside of parenthetical German terms or proper nouns.

---

### U3. Translate medium skills A — finance-emergency, finance-goals, finance-networth, finance-debt

**Goal:** Translate four mid-complexity skills covering emergency funds, financial goals, net worth, and debt management.

**Requirements:** R1, R2, R3, R4, R5

**Dependencies:** U1 (pattern reference)

**Files:**
- `skills/finance-emergency/SKILL.md`
- `skills/finance-goals/SKILL.md`
- `skills/finance-networth/SKILL.md`
- `skills/finance-debt/SKILL.md`

**Approach:**
- finance-emergency: translate data collection questions; "Notgroschen" handled per R3 ("emergency fund (Notgroschen)"); translate output section headers and action plan
- finance-goals: translate SMART goal framework section labels; translate timeline and output headers
- finance-networth: translate asset and liability category labels in data collection; translate net worth statement output headers; keep HFCS benchmark table values, translate column headers
- finance-debt: translate debt inventory questions (Schulden types → "consumer loan (Ratenkredit)", "overdraft (Dispo)"); translate debt snowball/avalanche method labels; translate output section headers

**Patterns to follow:** U1 translation pattern; R3 for debt terms (Ratenkredit, Dispo, Schuldendienstquote)

**Test scenarios:**
- finance-emergency: "Notgroschen" appears as "emergency fund (Notgroschen)" on first use
- finance-networth: HFCS benchmark table has English column headers; P25/P75/P90 values unchanged
- finance-debt: "Schuldendienstquote" → "debt service ratio (Schuldendienstquote)" on first use; SCHUFA unchanged as proper noun
- All four output files render with English section headers

**Verification:** All data collection questions English-first; output template headers English; benchmark values and German product names preserved.

---

### U4. Translate medium skills B — finance-analyze, finance-compare, finance-portfolio

**Goal:** Translate three mid-complexity skills covering portfolio analysis, product comparison, and investment portfolio management.

**Requirements:** R1, R2, R3, R4, R5

**Dependencies:** U1 (pattern reference)

**Files:**
- `skills/finance-analyze/SKILL.md`
- `skills/finance-compare/SKILL.md`
- `skills/finance-portfolio/SKILL.md`

**Approach:**
- finance-analyze: translate data collection questions and analysis framework section labels; translate output scorecard headers; keep ETF ISINs and broker names unchanged
- finance-compare: translate comparison framework labels; translate output comparison table column headers
- finance-portfolio: translate portfolio construction questions; translate allocation framework labels; keep ETF names (iShares MSCI World, Xtrackers) and ISIN codes unchanged; translate output section headers

**Patterns to follow:** U1; investment terms per german-context.md glossary (Depot → "investment account (Depot)", Tagesgeld → "instant-access savings (Tagesgeld)")

**Test scenarios:**
- finance-portfolio: ETF names and ISINs (IE00B4L5Y983) unchanged; "Depot" → "investment account (Depot)"; output allocation table column headers in English
- finance-compare: comparison output table column headers in English; product names (Riester, Rürup) unchanged as proper nouns
- finance-analyze: all analysis output section headers in English

**Verification:** Output files have English section headers; financial product proper nouns and ISINs unchanged.

---

### U5. Translate complex skills — finance-fire, finance-retirement, finance-taxes, finance-insurance

**Goal:** Translate the four largest/most complex skill files, which contain the most German financial terminology and the most detailed output templates.

**Requirements:** R1, R2, R3, R4, R5, R8

**Dependencies:** U1 (pattern reference)

**Files:**
- `skills/finance-fire/SKILL.md`
- `skills/finance-retirement/SKILL.md`
- `skills/finance-taxes/SKILL.md`
- `skills/finance-insurance/SKILL.md`

**Approach:**

**finance-fire:** Translate FIRE milestone labels and data collection questions; translate timeline output section headers; "Entnahmeplan" → "drawdown plan (Entnahmeplan)"; keep 4% rule and SWR references

**finance-retirement:** Translate all three-pillar data collection questions (GRV, bAV, Riester/Rürup); key term handling: "Entgeltpunkte" keeps German as primary ("Entgeltpunkte (pension credit points)"); "Rentenlücke" → "retirement income gap (Rentenlücke)"; "Handlungsplan" → "action plan (Handlungsplan)"; translate output section headers for three-pillar breakdown

**finance-taxes:** Translate all strategy category labels and data collection questions; key handling: "Steuerklasse" → "tax class (Steuerklasse)"; "Sparerpauschbetrag" keeps German as primary ("Sparerpauschbetrag (annual tax-free investment allowance)"); "Günstigerprüfung" → "favorable-rate check (Günstigerprüfung)"; translate output FINANCE-TAXES.md section headers; keep ELSTER as proper noun

**finance-insurance:** Translate insurance priority ranking labels; translate GKV vs PKV comparison table column headers; translate data collection questions; key handling: "Berufsunfähigkeitsversicherung" → "occupational disability insurance (BU/Berufsunfähigkeitsversicherung)"; "Haftpflichtversicherung" → "personal liability insurance (Haftpflichtversicherung)"; translate output section headers; trigger phrases in "When to Run" that are German (e.g., "Brauche ich PKV?") remain unchanged per R6/KTD3

**Patterns to follow:** U1; for terms with no English equivalent (Vorabpauschale, Teilfreistellung, Freistellungsauftrag), German name is primary with English gloss per R3

**Test scenarios:**
- finance-retirement: "Entgeltpunkte" appears with English gloss on first use; three-pillar output section headers in English; "KVdR" → "statutory health insurance in retirement (KVdR)"
- finance-taxes: "bAV" → "occupational pension (bAV)" on first use; Steuerklasse table has English column headers; ELSTER unchanged as proper noun
- finance-insurance: insurance priority table uses English labels (🔴 Essential, 🟡 Recommended, 🟢 Mandatory); "JAEG" → "income threshold for PKV eligibility (JAEG)"; German trigger phrases in When to Run unchanged
- finance-fire: FIRE milestone labels in English; output timeline headers in English

**Verification:** All four files have English-first data collection questions; output template headers in English; complex German-only terms carry English gloss on first use.

---

### U6. Cross-file consistency review

**Goal:** Verify that the "English (German)" pattern is applied consistently across all 15 files — same English equivalents for the same German terms, no one-off translations that diverge from the glossary.

**Requirements:** R1–R8 (consistency check)

**Dependencies:** U2, U3, U4, U5 (all files translated)

**Files:** All 15 skill files (read-only audit)

**Approach:**
- Check that high-frequency terms are translated identically across files: Nettoeinkommen, Notgroschen, Depot, Tagesgeld, Schuldendienstquote, Sparerpauschbetrag, bAV, GKV/PKV, Rentenlücke
- Verify no DISCLAIMER text was modified
- Verify trigger phrase sections contain no new German phrases added or removed
- Verify `skills/shared/german-context.md` was not modified
- Spot-check two or three output template headers per file for English

**Patterns to follow:** `skills/shared/german-context.md` "German Financial Glossary" table as the canonical translation reference

**Test scenarios:**
- "Notgroschen" translates to "emergency fund" in all files that use it (not "rainy day fund" in one and "emergency fund" in another)
- "Schuldendienstquote" translates to "debt service ratio" consistently
- "bAV" always appears as "occupational pension (bAV)" on first use in each file
- No DISCLAIMER text differs from the original wording

**Verification:** A one-pass scan across all 15 files shows no divergent term translations; review complete.

---

## Risks & Dependencies

| Risk | Mitigation |
|---|---|
| Inconsistent term translation across files | U6 cross-file review; use german-context.md glossary as reference throughout |
| German trigger phrases accidentally translated | R6/KTD3 explicit — When to Run sections are off-limits; check in U6 |
| Financial accuracy degraded by rewrite | R1–R8 scope German market content as unchanged; U6 verifies german-context.md untouched |
| Term with German primary loses gloss | R3 explicitly covers Vorabpauschale, Teilfreistellung, Sparerpauschbetrag — U5 handles most of these |

---

## Sources & Research

- Origin requirements doc: `docs/brainstorms/2026-06-26-english-language-rewrite-requirements.md`
- German term translation reference: `skills/shared/german-context.md` (German Financial Glossary section)
- Reference file read in full: `skills/finance-budget/SKILL.md`
- Sampled: `skills/finance-quick/SKILL.md`, `skills/finance-insurance/SKILL.md`, `skills/finance-taxes/SKILL.md`, `skills/finance-retirement/SKILL.md`
