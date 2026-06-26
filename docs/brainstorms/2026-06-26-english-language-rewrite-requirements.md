---
title: English Language Rewrite — Finance Skills
date: 2026-06-26
status: ready-for-planning
---

# English Language Rewrite — Finance Skills

## Overview

All 15 finance skill files currently prompt users in German and produce German-language outputs. This rewrite converts all user-facing text to English while preserving the German market financial framework intact. The target user is an English-speaker living in or operating under the German financial system.

## Goals

- All data collection questions, output section headers, and behavioral instructions appear in English
- German financial product names and regulatory terms appear as "English (German)" — e.g., "Emergency fund (Notgroschen)", "occupational pension (bAV)"
- No changes to financial constants, benchmark values, market-specific products, or institutional names

## Scope

### In scope — 15 skill files

| File | Lines |
|---|---|
| `skills/finance-budget/SKILL.md` | 270 |
| `skills/finance-analyze/SKILL.md` | 304 |
| `skills/finance-compare/SKILL.md` | 392 |
| `skills/finance-debt/SKILL.md` | 328 |
| `skills/finance-emergency/SKILL.md` | 279 |
| `skills/finance-fire/SKILL.md` | 484 |
| `skills/finance-goals/SKILL.md` | 300 |
| `skills/finance-insurance/SKILL.md` | 717 |
| `skills/finance-networth/SKILL.md` | 320 |
| `skills/finance-portfolio/SKILL.md` | 361 |
| `skills/finance-quick/SKILL.md` | 219 |
| `skills/finance-report-pdf/SKILL.md` | 224 |
| `skills/finance-retirement/SKILL.md` | 471 |
| `skills/finance-screen/SKILL.md` | 246 |
| `skills/finance-taxes/SKILL.md` | 439 |

### Out of scope

- `skills/shared/german-context.md` — financial constants file; already uses English column headers and English explanations for German terms; no rewrite needed
- Financial constants, tax rates, contribution limits, benchmark values
- German institutional proper nouns: Check24, Verivox, SCHUFA, Trade Republic, DKB, ING, ELSTER, etc.
- German regulatory product names used as proper nouns: Riester-Rente, Rürup-Rente, bAV, GKV, PKV — these get the "English (German)" treatment in output prose, but their German name is always preserved
- Output file names (FINANCE-BUDGET.md etc. — already English)
- Skill frontmatter `description:` and `name:` fields — already English

## Requirements

### R1 — Data collection questions in English

All numbered questions asking users for their financial data must be in English. The field label (e.g. "Monthly net income") appears in English first; the German term follows in parentheses where it's a document users will encounter (e.g., payslip label, bank term).

**Example — before:**
> Monatliches Nettoeinkommen (Take-home nach Steuern und Sozialversicherung)

**Example — after:**
> Monthly net income (Nettoeinkommen) — take-home after taxes and social insurance deductions

### R2 — Output template section headers in English

All section headings in the output markdown templates switch to English.

**Example — before:**
> ## Zusammenfassung
> ## Empfohlenes Budget (12 Monate)
> ## Identifizierte Verschwendung — Streichliste

**Example — after:**
> ## Summary
> ## Recommended Budget (12 Months)
> ## Identified Waste — Cut List

### R3 — German financial terms follow "English (German)" pattern

In output prose, table labels, and explanatory text: English term first, German in parentheses on first use per section. Subsequent uses within the same section: English only.

**Pattern:** `Emergency fund (Notgroschen)`, `occupational pension (bAV)`, `statutory health insurance (GKV)`, `capital gains tax (Kapitalertragsteuer)`

German-only product names with no clean English equivalent (Vorabpauschale, Sparerpauschbetrag, Teilfreistellung, Freistellungsauftrag) keep the German name as primary with a brief English gloss in parentheses on first use.

### R4 — Behavioral instructions in English

All prose instructions to Claude within the skill file (analysis frameworks, section descriptions, handoff instructions) must be in English. These were already partially in English in some files; make them consistent throughout.

### R5 — Table column headers in English

Table column headers in output templates switch to English. Data cells that contain German terms follow R3.

**Example — before:**
> | Kategorie | Aktuell € | Aktuell % | Benchmark % Netto | Bewertung |

**Example — after:**
> | Category | Current € | Current % | Benchmark % Net | Rating |

### R6 — Trigger phrases unchanged

The `When to Use` section trigger phrases (e.g. `/finance budget`, "Build me a budget") are already in English — leave unchanged.

### R7 — Disclaimers remain English

DISCLAIMER lines are already in English — leave unchanged.

### R8 — Month names in 12-month plan tables

Month names in output tables switch to English abbreviations (Jan, Feb, Mar ... Dec). The `Notizen` (Notes) column header switches to "Notes"; cell content examples translate to English.

## Handoff note for German terms

The `skills/shared/german-context.md` glossary is the reference for consistent English equivalents. When translating a German term, check the "English Explanation" column of that table first. Do not invent alternative translations; use the established equivalents.

## Success criteria

- A user who reads no German can follow every prompt and understand every output section header
- Every German financial term that appears in output prose is accompanied by an English label on first use
- Running any skill on a German user's financial data produces the same financially-correct output as before — only the language of the UI and headings changes
- `skills/shared/german-context.md` requires no changes

## Outstanding questions

None — requirements are fully resolved.
