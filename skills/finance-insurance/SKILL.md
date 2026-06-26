---
name: finance-insurance
description: Insurance coverage advisor for German clients. Analyzes GKV vs PKV decision, Berufsunfähigkeitsversicherung (BU), Risikolebensversicherung, Haftpflichtversicherung, Rechtsschutzversicherung, and Hausratversicherung. Triggered by: /finance insurance, "Brauche ich PKV?", "BU Versicherung", "Versicherungscheck", "welche Versicherungen brauche ich?"
---

# Finance Insurance — Insurance Review for Angestellte

**DISCLAIMER: For educational/informational purposes only. Not insurance advice. Consult a licensed independent insurance broker (unabhängiger Versicherungsmakler) (not a tied agent (Ausschließlichkeitsvertreter)) before purchasing any insurance product.**

---

## When to Run

Trigger when user says:
- `/finance insurance`
- "GKV oder PKV?"
- "Soll ich in die PKV wechseln?"
- "Brauche ich eine BU?"
- "BU Versicherung"
- "Versicherungscheck"
- "Welche Versicherungen brauche ich?"
- "Brauche ich PKV?"
- "Krankenversicherung Vergleich"
- "Berufsunfähigkeitsversicherung"
- Any question about Versicherungsschutz

---

## Data Collection

Ask in this order. For Angestellte below the income threshold for PKV eligibility (JAEG), skip GKV/PKV comparison — they have no choice.

**Profile**
1. Employment type — Angestellter/Angestellte or Selbstständige/r?
2. Age (date of birth for precision)
3. Gross annual income (Bruttojahreseinkommen)
4. Family status — single / married (partner's income?) / children (how many, ages)
5. Is spouse/partner employed and earning their own income?
6. Current health insurance — GKV or PKV? Which Krankenkasse / Versicherung? Monthly premium?
7. General health — no pre-existing conditions / some minor conditions / significant conditions?
8. Career outlook — plan to remain Angestellter long-term? Plan to become/remain Selbstständig?
9. Early retirement intent — plan to retire before 60? FIRE target?
10. Own or rent (Mieter oder Eigentümer)? City/region?

**Existing Insurance (ask all at once)**
11. Personal liability insurance (Haftpflichtversicherung) — in place?
12. Occupational disability insurance (BU/Berufsunfähigkeitsversicherung) — in place? Monthly benefit? Waiting period (Karenzzeit)?
13. Term life insurance (Risikolebensversicherung) — in place? Sum insured? Term?
14. Contents insurance (Hausratversicherung) — in place? Includes Elementarschaden?
15. Legal expenses insurance (Rechtsschutzversicherung) — in place? Which modules?
16. Other: Pflegezusatz, Zahnzusatz, KFZ?
17. Trade union (Gewerkschaft) membership? (relevant for Rechtsschutz)

---

## Insurance Framework

> Before analysis, read `.claude/skills/shared/german-context.md` for 2026 JAEG, GKV Beitragssatz, and other German financial constants.

### Insurance Priority Ranking for Standard Angestellte

1. 🔴 **Personal liability insurance (Haftpflichtversicherung)** — absolutely essential, lowest cost-to-risk ratio
2. 🔴 **Occupational disability insurance (BU/Berufsunfähigkeitsversicherung)** — most critical for income protection while working
3. 🟡 **Term life insurance (Risikolebensversicherung)** — essential only if dependents (children, partner relying on income)
4. 🟡 **Contents insurance (Hausratversicherung)** — recommended for renters
5. 🟡 **Legal expenses insurance (Rechtsschutzversicherung)** — valuable for Angestellte and renters
6. 🟢 **Health insurance (GKV/PKV)** — mandatory; analysis focuses on optimization

---

### Section 1: GKV vs PKV — The Most Consequential Insurance Decision

#### Who Has the Choice?

| Situation | Options |
|-----------|---------|
| Angestellter, gross income **below** income threshold for PKV eligibility (JAEG) (2026: €73,800/yr) | GKV mandatory — no choice |
| Angestellter, gross income **above** JAEG for current + prior year | Can choose GKV (voluntarily) or PKV |
| Selbstständige/r | Always free to choose GKV (voluntarily) or PKV |
| Beamte | Typically PKV + Beihilfe — not covered in this skill |

**JAEG 2026: €73,800 gross/year (€6,150/month)** — verify annual update at bmas.de.

If user is Angestellter below JAEG: skip to Section 1c (GKV Optimization), then Section 2 onwards.

---

#### 1a. Cost Comparison — Angestellte Above JAEG

**GKV cost for Angestellter:**

```
Beitragsbemessungsgrenze (BBG) KV 2026: €8,050/month gross (€96,600/year)
GKV avg total rate 2026: ~16.3% (14.6% Basisbeitrag + ~1.7% avg Zusatzbeitrag)
Employee share: 8.15% of gross income (up to BBG)
Employer share: 8.15% of gross (up to BBG)

Monthly GKV employee cost:
  If gross <= €8,050/mo: gross × 8.15%
  If gross > €8,050/mo: €8,050 × 8.15% = €656.08/month (maximum)
```

**PKV cost for Angestellter:**

```
PKV premium: risk-rated at entry (age, sex, health status)
Employer contribution: min(50% of PKV premium, employer GKV equivalent)
  Effectively: employer pays up to 50% of your PKV premium, or the GKV equivalent — whichever is lower.

Net PKV cost = PKV gross premium - employer contribution
```

**Rough PKV premium estimates (2026, Angestellter, good health, office profession, no pre-existing conditions):**

| Age | Monthly PKV premium | Employer contribution (est.) | Net employee cost |
|-----|--------------------|--------------------|-------------------|
| 25 | ~€280–380 | ~€140–190 | ~€140–190 |
| 30 | ~€320–440 | ~€160–220 | ~€160–220 |
| 35 | ~€380–520 | ~€190–260 | ~€190–260 |
| 40 | ~€480–660 | ~€240–330 | ~€240–330 |
| 45 | ~€600–820 | ~€300–410 | ~€300–410 |

*Source: Range from major PKV providers (AXA, Debeka, DKV, Signal Iduna). Always get individual quotes — these are indicative only. Smokers, pre-existing conditions, manual professions: significantly higher.*

**Example calculation (Age 30, €80,000 gross/year):**

```
GKV employee cost: €6,667/mo × 8.15% = €543/month

PKV gross premium: ~€380/month (example)
Employer contribution: min(€190, €543) = €190
PKV net employee cost: €190/month

Monthly savings with PKV: €543 - €190 = €353/month
Annual savings: ~€4,236
```

Compute this for user's actual income and estimated PKV range.

---

#### 1b. GKV/PKV Decision Matrix

**Do NOT recommend PKV if any of these apply:**

| Risk factor | Weight | Explanation |
|--------------|------------|-------------|
| Non-working spouse / Familienversicherung beneficial | 🚨 Critical | PKV requires separate policy per family member. A family of 4 in PKV = 4× premium. GKV co-insures spouse (not earning above Geringfügigkeitsgrenze: €556/month) and all children FREE. |
| Pre-existing conditions | 🚨 Critical | PKV can exclude pre-existing conditions, apply risk surcharges, or reject application. GKV cannot. |
| Income stability uncertain (may drop below JAEG) | 🔴 High | Returning to GKV as Angestellter after PKV exit is very difficult once above 55. |
| Early retirement / FIRE intent | 🔴 High | No employer subsidy in retirement. Full PKV premium alone can be €600–1,200+/month. GKV → KVdR very favorable if 9/10 of working life in GKV. |
| Profession with high physical risk | 🟠 Medium | PKV premiums for Handwerker, nurses, physical professions much higher. |
| Age > 40 at time of considering switch | 🟠 Medium | Premiums locked in at entry age; delay raises lifetime cost significantly. |
| Plans to have children (non-working partner) | 🟠 Medium | Future Familienversicherung benefit lost if already in PKV. |

**PKV may be appropriate when ALL of these are true:**
- Single, no dependents, non-working partner unlikely
- Young (under 35 ideally; under 40 acceptable)
- Excellent health, no significant pre-existing conditions
- Stable high income, no intention to reduce hours
- Office/academic profession (low disability risk class for PKV)
- No early retirement plan within GKV KVdR window
- Income firmly and sustainably above JAEG
- Self-employed where employer subsidy isn't a factor anyway

**PKV quality tier matters:** Not all PKV plans are equal. Key criteria:
- Beitragsrückerstattung (premium refund for claim-free years)
- Beitragsentwicklung (premium increase history — check with independent insurance broker or **pkv.de**)
- Chefarztbehandlung and Einbettzimmer: standard in most full tariffs
- Krankentagegeld: must be separately insured

---

#### 1c. GKV Optimization (For those staying in or required to use GKV)

**Kassenwahl — choice matters:**

All GKV funds provide the same statutory benefits (Pflichtleistungen per SGB V). They compete on:
- **Zusatzbeitrag**: varies from ~0.5% to ~2.5% — difference on €4,000/month gross = €40–80/month
- **Additional benefits**: dental bonus programmes, alternative medicine, sports courses (§20 SGB V), Bonusprogramme
- **Service quality**: app, response times, specialist referrals

**Well-rated GKV funds (check current Zusatzbeitrag at gesetzliche-krankenkassen.de):**
- **Techniker Krankenkasse (TK)**: consistently top-rated service, competitive Zusatzbeitrag
- **HKK**: often lowest Zusatzbeitrag, strong digital service
- **hkk / BKK Mobil Oil / Audi BKK**: check current rates — open Betriebskrankenkassen
- **Barmer / DAK / HEK**: large Ersatzkassen, broad nationwide coverage

**Action:** Compare current Krankenkasse Zusatzbeitrag vs cheapest alternative. Switching costs nothing and takes 2 months notice. On €5,000/month gross: 1% Zusatzbeitrag difference = €50/month = €600/year saved.

**Supplemental insurance within GKV (recommended):**
- **Zahnzusatzversicherung**: GKV covers only 60–70% of dental/prosthetics costs; gap can be thousands. Cost: ~€10–30/month. Worth it for most people.
- **Auslandskrankenversicherung**: GKV covers EU travel emergencies only. For travel outside EU or longer stays: ~€10–20/year (very cheap, very important).
- **Krankenhaustagegeld**: compensates income loss during hospital stay beyond Lohnfortzahlung.

---

#### 1d. Selbstständige — Special Considerations

For Selbstständige, no employer contributes to GKV. Full rate falls on them:

**GKV as Selbstständige/r (voluntarily insured):**
```
GKV total rate 2026: ~16.3%
Minimum assessment base 2026: €1,178/month
Minimum GKV monthly contribution: €1,178 × 16.3% = ~€193/month
  (This is the floor; actual income above this = higher contribution)

If monthly income €3,000: GKV = €3,000 × 16.3% = €489/month
If monthly income €5,000: GKV = €5,000 × 16.3% = €815/month
If monthly income €8,050+: capped at BBG = €8,050 × 16.3% = ~€1,312/month
```

*Verify minimum assessment base annually at gkv-spitzenverband.de*

**PKV for Selbstständige:**
- No employer subsidy available
- Net cost = full PKV premium
- For young, healthy, solo Selbstständige: PKV frequently cheaper than full GKV rate
- Critical: plan for retirement healthcare from day one (see retirement impact below)

**Krankentagegeld for Selbstständige:**
- GKV pays Krankengeld after 6 weeks — but Selbstständige need special opt-in Wahltarif (§ 53 SGB V) for Krankengeld, otherwise no income replacement
- PKV holders must separately buy Krankentagegeld tariff
- Recommendation: minimum €50–70/day Krankentagegeld coverage if self-employed
- This starts from Day 1, 8, 15, 29, or 43 depending on waiting period chosen (longer wait = lower premium)

---

#### 1e. Retirement Healthcare Impact — Critical for Long-Term Planning

**GKV → statutory health insurance in retirement (KVdR):**
- Requirement: 9/10 of the second half of working life in GKV (Vorversicherungszeit)
- For someone working from age 25 to 67: second half = ages 46–67 = 21 years. Must have 19 of those in GKV.
- KVdR rates: contribution on GRV pension only (not capital income) — very favorable
- Effectively: employer-equivalent subsidy continues via Deutsche Rentenversicherung contribution
- This is a **massive benefit** for early career GKV members — do not underestimate it

**PKV in retirement:**
- No employer subsidy after employment ends
- Full premium alone: €600–1,400+/month for couple in standard PKV tariffs
- Premium continues to rise with age
- No exit to GKV after age 55 in most circumstances
- Exception: Standardtarif / Basistarif (legal fallback options) — much reduced benefits

**Return right:** Once in PKV, returning to GKV as Angestellter above 55 is nearly impossible. Factor this permanently into the decision.

**Verdict on retirement impact:** For anyone who is not firmly committed to staying in PKV throughout their entire career AND has a non-earning spouse or retirement lifestyle concerns: GKV provides substantial long-term security.

---

### Section 2: Occupational Disability Insurance (BU/Berufsunfähigkeitsversicherung)

**The most critical private insurance for working-age Germans.** No other single insurance has a higher impact-to-cost ratio for most Angestellte and Selbstständige.

#### Why Disability Insurance (BU) Is Critical

**Statutory protection is dangerously low:**

| Protection | Payment | Requirement |
|--------|---------|---------------|
| Lohnfortzahlung (employer) | 100% gross | First 6 weeks of illness only |
| Krankengeld (GKV) | 70% of gross (max ~€120/day) | Weeks 7–78 of continuous illness |
| Full reduced earnings capacity pension (GRV) | **~30–40% of last net income** | Cannot work >3h/day in ANY job |
| Partial reduced earnings capacity pension (GRV) | **~half of full pension** | Cannot work >6h/day in ANY job |

**Key problem with reduced earnings capacity pension:**
- It is NOT profession-specific — if you can work as a cashier for 3 hours/day, you may not qualify for the full pension, even if you can no longer work as a surgeon or software engineer
- Requires at least 5 years of Pflichtbeiträge to GRV — recent graduates and early-career Selbstständige may not qualify at all
- Average full reduced earnings capacity pension: ~€960/month (new recipients). Varies widely by contribution history.
- Source: Deutsche Rentenversicherung Rentenversicherungsbericht

**Disability insurance (BU) covers:** Inability to work in your **specific profession** at >50% capacity (Berufsunfähigkeitsgrad 50%), regardless of whether you could theoretically do other work. The benefit definition ties the payout to your actual occupation — not a hypothetical alternative.

#### Disability Gap Calculation

```
Step 1: Monthly net income current = gross - taxes - Sozialabgaben
Step 2: Target income replacement = 70–80% of monthly net
Step 3: Expected reduced earnings capacity pension = ~€900–1,100/month (estimate; use actual DRV projection if available)
         For those without 5 GRV years: pension = €0
Step 4: Monthly BU benefit needed = Target income - expected pension
Step 5: Monthly BU benefit minimum = should not be less than €1,500/month
```

**Waiting period (Karenzzeit):** Standard disability (BU) policies begin paying after a 6-month continuous inability to work. Factor this into emergency fund planning — 6 months of expenses should be in reserve.

**Example:**
```
Gross: €5,000/month → Net ~€3,100/month (Angestellter, GKV, no church tax)
Target replacement (75% of net): €2,325/month
Expected reduced earnings capacity pension: €1,000/month
BU benefit needed: €1,325/month

Recommended BU monthly benefit: €1,500–2,000/month (round up; pension estimate may not materialize)
```

#### Disability Insurance (BU) Premium Ranges (Rough Estimates, 2026)

Premium depends heavily on: age, profession risk class, sum, term, health history. Always get individual quotes.

**Profession risk classes (illustrative — varies by insurer):**
- **Class 1 (lowest risk)**: Software developer, analyst, teacher (Gymnasium), Bürokaufmann
- **Class 2**: Arzt, Anwalt, Ingenieur, Kaufmännische Berufe
- **Class 3**: Krankenpfleger, Erzieher, Einzelhandel
- **Class 4–5 (highest risk)**: Handwerker, Maurer, Elektriker, physical occupations

**Rough monthly premiums, Class 1 profession, non-smoker, BU monthly benefit €2,000, term to 67:**

| Age | Monthly premium |
|-----|----------------|
| 25 | ~€40–80 |
| 30 | ~€60–110 |
| 35 | ~€90–160 |
| 40 | ~€140–230 |
| 45 | ~€210–360 |

*For Class 3–4 professions: 2–4× these amounts. Source: BU market surveys from Morgen & Morgen, franke-bornberg.de*

#### Disability Insurance (BU) Quality Criteria (What to Check in a Policy)

- **Verzicht auf abstrakte Verweisung (§ 163 VVG)**: Insurer may NOT redirect you to a different profession you could theoretically do. **Critical** — verify explicitly. This is the single most important clause. Policies without this exclusion are substantially inferior.
- **Benefit definition**: Benefit triggered on your agreed occupation, not a theoretical one
- **Nachversicherungsgarantie**: Ability to increase BU benefit without new health check (marriage, children, income rise)
- **Rückwirkende Leistung**: Benefit paid retroactively if delay in determination
- **6-month prognosis vs. permanent prognosis**: 6-month prognosis preferred (begins paying sooner)
- **Worldwide coverage**: Should apply globally
- **Net premium vs. tariff premium**: Always compare **net premium (Nettobeitrag)** (actual charged premium) not tariff premium (Tarifbeitrag) (maximum insurer can charge). Ask insurer for 10-year net premium history.
- **Rating**: Check Morgen & Morgen or franke-bornberg.de rating (aim for ★★★★★ providers: Allianz, MünchenerVerein, AXA, Zurich, LV1871, Condor for budget options)

**Combination products to AVOID:**
- Disability insurance (BU) + Kapitallebensversicherung: overpriced, inflexible
- Disability insurance (BU) + retirement savings: keep insurance and investment separate

---

### Section 3: Term Life Insurance (Risikolebensversicherung)

**When needed:** Any person with financial dependents (spouse, children) who rely on their income.

**When NOT needed:** Single persons with no dependents. No need to insure a risk that no one else bears.

#### Coverage Calculation

```
Method 1 (Income replacement):
  Minimum coverage: 10× annual net income
  Optimal: 10–15× annual net income

Method 2 (Needs-based):
  Coverage = remaining mortgage balance
           + (annual living costs - other household income) × years until independence
           + education costs for children
           + funeral + admin costs (~€15–25k)
```

**Term life insurance (Risikolebensversicherung) is cheap in Germany:**
- 35-year-old, non-smoker, good health, €300,000 sum, 20-year term
- Premium: ~€15–25/month

**Always choose term life insurance (Risikolebensversicherung) NOT whole life (Kapitallebensversicherung):** Kapitallebens is an overpriced savings product with historically low returns (~2%). Insurance and investment should be separate.

**Restschuldversicherung vs. standalone term life insurance:**
- Restschuldversicherung: tied to the loan, sold by bank at point of mortgage — typically overpriced and restricted
- A standalone term life insurance is almost always better value: more flexible, independent of bank, can cover more than just the mortgage balance
- Use annuitätisch fallende Versicherungssumme if covering mortgage only — cheaper premium as sum matches declining balance

**Verbundene Lebensversicherung für Paare**: Both partners insured in one policy; payout on first death. Cheaper than two separate policies but only pays once — evaluate carefully if both partners are primary earners.

---

### Section 4: Personal Liability Insurance (Haftpflichtversicherung) — CRITICAL

**Why essential:** In Germany, you are personally liable for all damages you cause (§ 823 BGB). There is no statutory cap. One serious accident — injuring someone as a cyclist, accidentally causing a fire, a child causing damage — can result in claims running into the millions. Without personal liability insurance (Haftpflichtversicherung), your entire net worth is at risk.

**If client has NO personal liability insurance → flag as critical gap requiring immediate action.**

#### Minimum Coverage Sum

- **€10 million** for Personenschäden (bodily injury), Sachschäden (property damage), and Vermögensschäden (financial loss)
- Do not accept policies below €5 million; €10 million is the current market standard for good policies

#### Cost

- Single person: approximately **€50–80/year** for a good policy
- Family (Familientarif): approximately **€80–120/year**
- This is the highest return-per-euro of any insurance product

#### What it covers

- Accidentally breaking something at a friend's house
- Injuring someone while cycling
- Your child damaging property at school or a friend's home
- Accidental water damage (e.g., leaving a tap running and flooding the apartment below)

#### What it does NOT cover

- Intentional damage (Vorsatz)
- Own property damage
- Damage to items borrowed or rented (check policy — some cover this)
- Professional/business liability — requires separate Berufshaftpflicht
- Dog bites — requires separate Hundehalterhaftpflicht in most Bundesländer (mandatory in some)
- Drone damages — increasingly common; check for Drohnenhaftpflicht clause or take separate policy

#### Providers to compare

ARAG, Allianz, HUK-Coburg, Gothaer, Cosmos Direkt — compare via Check24 or Verivox for current market rates.

---

### Section 5: Legal Expenses Insurance (Rechtsschutzversicherung) — Situational

**What it covers:** Legal costs (attorney, court, expert witness fees) for disputes across key modules.

#### Key Coverage Modules

| Module | Content | Relevance for Angestellte |
|-------|--------|--------------------------|
| Employment law (Arbeitsrecht) | Employment disputes — Kündigung, Abmahnung, unfair dismissal | Very high |
| Traffic law (Verkehrsrecht) | Traffic disputes, accidents, Bußgeld-Einspruch | High (car drivers) |
| Tenancy law (Mietrechtsschutz) | Landlord-tenant disputes, utility costs, Kündigung | High (renters) |
| Contract law (Vertragsrecht) | Consumer disputes, online purchases | Medium |
| Criminal law — passive (Strafrecht) | Defense costs in criminal proceedings | Situational; check policy |

**Waiting period:** Typically 3 months after policy start — you cannot buy after a dispute has arisen. Plan ahead.

#### Cost

- €150–400/year depending on scope and deductible (Selbstbeteiligung)
- Often €150–300 Selbstbeteiligung per claim — this keeps premiums lower

#### When it IS worth it

- Renting in Germany (tenancy disputes are very common)
- Employed in a large company (employment law coverage is highly valuable — labor disputes in Germany can be lengthy)
- Car owner (traffic law module)
- Self-employed with frequent contracts (contract law)

#### When to SKIP

- Already a **Gewerkschaft** member: trade union provides legal expenses coverage for employment law free of charge — no need to duplicate this module
- Emergency fund large enough to self-insure moderate legal costs (most single disputes: €1,000–5,000)
- If no car, no rental situation, and union covers employment: marginal value

---

### Section 6: Contents Insurance (Hausratversicherung) — Recommended for Renters

#### What it covers

- **Burglary and theft (Einbruchdiebstahl)**
- **Fire (Feuer)** (fire, lightning, explosion)
- **Burst pipes and water damage (Leitungswasser)**
- **Storm and hail (Sturm und Hagel)** (typically from wind force 8 / Windstärke 8 or above)

#### What it does NOT cover (standard policy)

- **Flooding from outside** (Hochwasser, Überschwemmung) — requires Elementarschadenversicherung add-on
- Foundation water ingress
- Intentional damage
- Items outside the home (unless explicitly covered — check bicycle theft clause)

#### Elementarschadenversicherung (Add-on)

Covers: flooding, earth movement, landslides, snow pressure, Rückstau (backflow from drains).

- Increasingly important — climate events have increased frequency of flood damage across Germany
- Especially relevant in flood-prone regions: Bavaria (Donau, Inn), Rhineland (Ahr, Rhine), Baden-Württemberg
- Cost add-on: typically €30–80/year additional, depending on location risk zone
- Check **Zürs** (Zonierungssystem Überschwemmung, Rückstau und Starkregen) for property risk zone

#### Coverage Sum

- Insure at **replacement cost (Neuwert)**, not current market value (Zeitwert)
- Estimate contents: use ~€650/sqm as a rule of thumb (e.g., 75sqm flat: ~€48,750 estimated contents value)
- **Always include Unterversicherungsverzicht clause**: insurer cannot invoke the proportional reduction rule (Unterversicherung) if you have declared in good faith. Without this clause, if your declared sum is 80% of actual value, the insurer pays only 80% of any claim.
- Bicycle theft: typically requires explicit clause and sometimes minimum lock specification

#### Cost

- Approximately **€60–150/year** depending on city, flat size, and coverage level
- Major cities (München, Hamburg, Frankfurt): toward upper range

#### Renters vs. Owners

- **Renters (Mieter)**: Contents insurance is highly recommended. Building structure is covered by Wohngebäudeversicherung, which is the landlord's or WEG's responsibility — not the tenant's.
- **Owners (Eigentümer)**: Need both contents insurance (Hausratversicherung) and either contribute to WEG's Wohngebäudeversicherung (in a Wohnungseigentümergemeinschaft) or take their own Wohngebäudeversicherung (for a house).

---

## Output

Write FINANCE-INSURANCE.md to current working directory with the following structure:

```markdown
# Insurance Analysis
**Created:** [Date]
**Profile:** [Angestellter/Selbstständiger], [Age], [Marital status]
**Current health insurance:** [GKV/PKV, Kasse/Versicherung, monthly €X]

> **DISCLAIMER:** For educational/informational purposes only. Not advice under VVG.
> For GKV/PKV decisions and disability insurance (BU): consult an independent insurance broker (unabhängiger Versicherungsmakler).

---

## Priority Overview

| Priority | Insurance | Status | Action needed |
|-----------|-------------|--------|-----------------|
| 🔴 1 | Personal liability insurance (Haftpflichtversicherung) | ✅ / ❌ | [Immediate / OK] |
| 🔴 2 | Occupational disability insurance (BU/Berufsunfähigkeitsversicherung) | ✅ / ❌ / ⚠️ | [Gap €X/mo / OK] |
| 🟡 3 | Term life insurance (Risikolebensversicherung) | ✅ / ❌ / N/A | [Gap €X / OK / No dependents] |
| 🟡 4 | Contents insurance (Hausratversicherung) | ✅ / ❌ | [Recommended / OK] |
| 🟡 5 | Legal expenses insurance (Rechtsschutzversicherung) | ✅ / ❌ | [Review / OK] |
| 🟢 6 | Health insurance (GKV/PKV) | [GKV/PKV] | [Optimization / OK] |

---

## 1. Personal Liability Insurance (Haftpflichtversicherung)

### Situation
- Status: [In place ✅ / Not in place ❌ — CRITICAL GAP]
- Coverage sum (if in place): €X

### Analysis
[If missing: flag as immediate action — highest ROI per euro of any insurance; personal liability under §823 BGB is unlimited]
[If present: confirm coverage sum ≥ €10M; check family coverage if applicable]

### Recommendation
- **Action:** [Take out immediately / Check whether coverage sum is sufficient / OK]
- Recommended coverage sum: €10 million — bodily injury, property damage, financial loss
- Estimated cost: €50–80/year (single) / €80–120/year (family)
- Compare: Check24, Verivox; providers: ARAG, HUK-Coburg, Allianz, Gothaer, Cosmos Direkt

---

## 2. Occupational Disability Insurance (BU/Berufsunfähigkeitsversicherung)

### Disability Gap Calculation

| Metric | Value |
|----------|------|
| Monthly net income | €X |
| Target replacement (70–80% net) | €X/month |
| Expected reduced earnings capacity pension (GRV) | ~€X/month |
| **Disability benefit needed (gap)** | **€X/month** |
| Current BU monthly benefit (if in place) | €X/month |
| **Remaining coverage gap** | **€X/month** |

**Status:** [Well covered ✅ / Underinsured ⚠️ / No disability insurance — critical 🚨]

### Recommendation
[If gap exists:]
- Increase BU monthly benefit to €X/month (check Nachversicherungsgarantie)
- Or: Apply for new disability insurance — estimated net premium: €X–X/month
- Key quality criteria: Verzicht auf abstrakte Verweisung, Nachversicherungsgarantie, check net premium (not tariff premium)
- Always: engage an independent insurance broker (unabhängiger Versicherungsmakler)

---

## 3. Term Life Insurance (Risikolebensversicherung)

### Situation
[If no dependents: "No dependents — term life insurance not currently required."]

[If dependents:]

| Metric | Value |
|----------|------|
| Annual net income | €X |
| Recommended minimum coverage (10× net) | €X |
| Remaining mortgage / family debt | €X |
| Currently insured sum | €X |
| **Coverage gap** | **€X** |

**Status:** [Adequate ✅ / Gap identified ⚠️ / No insurance with dependents 🚨]

### Recommendation
- Standalone term life insurance preferred — no Restschuldversicherung from bank
- No Kapitallebensversicherung
- Estimated cost: ~€15–30/month (age 35, €300k, 20 years, non-smoker)

---

## 4. Contents Insurance (Hausratversicherung)

### Situation
- Status: [In place ✅ / Not in place ❌]
- Renter or owner: [X]
- Elementarschaden add-on: [In place / Not in place / Not checked]

### Analysis
[For renters without contents insurance: recommend immediately]
[Check: Unterversicherungsverzicht included? Bicycle theft covered?]
[If in flood-prone area: flag Elementarschadenversicherung add-on]

### Recommendation
- Estimated coverage sum: €X (based on floor area × €650/sqm)
- Recommendation for Elementarschaden add-on: [Yes — Region X / Review]
- Estimated cost: €60–150/year

---

## 5. Legal Expenses Insurance (Rechtsschutzversicherung)

### Situation
- Status: [In place ✅ / Not in place ❌]
- Modules (if in place): [Employment law / Traffic law / Tenancy law / Contract law]
- Trade union member: [Yes — employment law covered / No]

### Analysis
[Evaluate need per situation: renter + employee = high value; union member = employment law already covered]
[Flag waiting period: cannot buy after dispute arises]

### Recommendation
- **Recommendation:** [Worthwhile for this profile / Less relevant / Union covers main risks]
- If worthwhile: review modules — employment law + tenancy law as minimum for Angestellte/renters
- Estimated cost: €150–400/year

---

## 6. Health Insurance (GKV / PKV)

### Situation
- Current: [GKV/PKV] at [Kasse/Versicherung], monthly: €X (employee share)
- JAEG 2026: €73,800 — Status: [Above / Below threshold / Not applicable — Selbstständig]

### [If above JAEG or Selbstständig] GKV vs PKV Comparison

| Criterion | GKV | PKV |
|-----------|-----|-----|
| Monthly contribution (employee share / net) | €X | €X |
| Annual cost | €X | €X |
| Family insurance (spouse/child) | FREE | €X extra/person |
| Protection with pre-existing conditions | Full | [Check exclusions] |
| Return right after 55 | Possible | Very difficult |
| Retirement phase | KVdR possible (favorable) | Full premium alone |

**Recommendation:** [Stay in GKV / Evaluate PKV / Switch not advisable]
**Rationale:** [Specific reasoning based on user profile — family, income stability, retirement plan]

### [If in GKV] Kassenwahl Optimization
- Current Zusatzbeitrag: X%
- Cheaper alternatives: [list top 3 with current Zusatzbeitrag from gesetzliche-krankenkassen.de]
- Monthly saving on switch: €X
- Recommended supplemental insurance: [Zahnzusatz, Auslands-KV if relevant]

---

## 7. Prioritized Action Plan

### Immediate (this week)
1. [Most critical gap — typically: take out personal liability insurance if missing]
2. [Second priority — e.g., switch Krankenkasse if Zusatzbeitrag significantly above market]

### This month
1. [Disability insurance (BU) gap — contact independent insurance broker (unabhängiger Versicherungsmakler), compare net premiums]
2. [Take out contents insurance if renter without coverage]

### This quarter
1. [Term life if dependents and gap identified]
2. [Legal expenses — evaluate if renter and/or Angestellter without trade union]
3. [Zahnzusatz before dental issues arise]

### Medium- to Long-Term
1. [GKV/PKV strategic review if approaching JAEG threshold]
2. [Elementarschaden add-on to contents insurance if flood-prone region]
3. [Pflegezusatz — consider under 40 while premiums are low]

---

## 8. Recommended Resources

- **Independent insurance broker (unabhängiger Versicherungsmakler)** (§ 34d GewO) — for disability insurance (BU), PKV, term life
  - NOT: tied agents (Ausschließlichkeitsvertreter) from Allianz, AXA etc. — not independent
  - Recommendations: Verbraucherzentrale.de or BdV (Bund der Versicherten)
- **Verbraucherzentrale.de** — impartial insurance consultation (~€200/hour, independent)
- **Gesetzliche-Krankenkassen.de** — Kassenwahl and Zusatzbeitrag comparison
- **Morgen & Morgen / Franke-Bornberg (franke-bornberg.de)** — disability insurance (BU) rating tables (neutral)
- **Bund der Versicherten (BdV)** — complaints contact, consultation
- **Check24 / Verivox** — personal liability, contents insurance, legal expenses price comparison

---

**DISCLAIMER:** For educational/informational purposes only. Not advice under VVG (Versicherungsvertragsgesetz). No liability for decisions based on this analysis. Premium figures are indicative and not offers. Contributions and thresholds change annually — values here are based on 2026 figures. For all insurance decisions, consult an independent insurance broker (unabhängiger Versicherungsmakler) (§ 34d GewO).
```

---

## Quality Standards

- GKV/PKV comparison always shows **net cost comparison** (after employer contribution for Angestellte)
- Disability insurance (BU) analysis always shows the **gap** — not just "do you have a BU"
- Always compare disability insurance net premium (Nettobeitrag), not tariff premium
- Personal liability insurance flagged as immediate action if missing — highest ROI per euro
- All figures cited with data source and year; JAEG and BBG values taken from shared german-context.md
- Never recommend specific insurer by name for disability insurance (BU) or PKV (conflict risk); recommend independent insurance broker (unabhängiger Versicherungsmakler)
- PKV recommendation requires ALL favorable factors to be present; default to GKV when uncertain
- Term life: always check for dependents first; never recommend without dependent need
- Legal expenses: always check trade union membership before recommending (employment law may be covered)
- Contents insurance: always check for Unterversicherungsverzicht and Elementarschaden relevance
- Always close with disclaimer and professional referrals
- No US insurance terminology, no dollar amounts, no ACA/COBRA/Medicare references

---

## Handoff

After writing FINANCE-INSURANCE.md:

1. State the single most critical gap (personal liability insurance if missing is always first; disability insurance gap if present)
2. State the monthly or annual cost to close the most critical gap
3. Refer to independent insurance broker (unabhängiger Versicherungsmakler) (§ 34d GewO) for disability insurance (BU) and PKV decisions — not tied agents (Ausschließlichkeitsvertreter)
4. Suggest `/finance analyze` if full financial picture not yet assessed
5. Suggest `/finance retirement` to see how current insurance fits retirement planning

**DISCLAIMER:** For educational/informational purposes only. Not advice under VVG.
