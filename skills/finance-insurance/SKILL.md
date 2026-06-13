---
name: finance-insurance
description: German insurance coverage analyzer. Runs GKV vs PKV decision framework for Angestellte (above JAEG) and Selbstständige, calculates Berufsunfähigkeitsversicherung (BU) gap, audits Risikolebensversicherung need, and checks all essential coverage (Haftpflicht, Hausrat, Pflegezusatz). Produces FINANCE-INSURANCE.md with prioritized recommendations and cost estimates. Triggered by /finance insurance, "GKV oder PKV", "Krankenversicherung Vergleich", "Berufsunfähigkeit", or any insurance coverage question.
---

# /finance insurance — Versicherungsanalyse für Deutschland

**DISCLAIMER:** Für Informations- und Bildungszwecke. Keine Beratung im Sinne des VVG. Keine Haftung für Entscheidungen. Konsultieren Sie für GKV/PKV-Wechsel und BU-Abschluss einen unabhängigen Versicherungsmakler (§ 34d GewO).

**IMPORTANT NOTE ON DATA:** All contribution rates, thresholds, and limits below are based on 2025 figures as published by the Bundesgesundheitsministerium and Bundesministerium für Arbeit und Soziales. Verify current-year values at **gesetzliche-krankenkassen.de** or **bmas.de** before advising clients. Figures update annually (typically announced October–November for the following year).

---

## When to Run

Trigger when user says:
- `/finance insurance`
- "GKV oder PKV?"
- "Soll ich in die PKV wechseln?"
- "Brauche ich eine BU?"
- "Krankenversicherung Vergleich"
- "Berufsunfähigkeitsversicherung"
- Any question about Versicherungsschutz

---

## Data Collection

Ask in this order. For Angestellte below JAEG, skip GKV/PKV comparison — they have no choice.

**Profile**
1. Employment type — Angestellter/Angestellte or Selbstständige/r?
2. Age (date of birth for precision)
3. Gross annual income (Bruttojahreseinkommen)
4. Family status — single / verheiratet (partner's income?) / Kinder (how many, ages)
5. Is spouse/partner employed and earning their own income?
6. Current health insurance — GKV or PKV? Which Krankenkasse / Versicherung? Monthly premium?
7. General health — no pre-existing conditions / some minor conditions / significant conditions?
8. Career outlook — plan to remain Angestellter long-term? Plan to become/remain Selbstständig?
9. Early retirement intent — plan to retire before 60? FIRE target?

**Existing insurance inventory (ask all at once)**
10. Berufsunfähigkeitsversicherung — vorhanden? Monthly Rente? Waiting period (Karenzzeit)?
11. Risikolebensversicherung — vorhanden? Sum insured? Term?
12. Haftpflichtversicherung — vorhanden?
13. Hausratversicherung — vorhanden?
14. Other: Rechtsschutz, Pflegezusatz, Zahnzusatz, KFZ?

---

## Section 1: GKV vs PKV — The Most Consequential Insurance Decision

### Who Has the Choice?

| Situation | Options |
|-----------|---------|
| Angestellter, Bruttolohn **below** JAEG (2025: €73,800/yr) | GKV mandatory — no choice |
| Angestellter, Bruttolohn **above** JAEG for current + prior year | Can choose GKV (freiwillig) or PKV |
| Selbstständige/r | Always free to choose GKV (freiwillig) or PKV |
| Beamte | Typically PKV + Beihilfe — not covered in this skill |

**JAEG 2025: €73,800 gross/year (€6,150/month)** — verify 2026 update at bmas.de.

If user is Angestellter below JAEG: skip to Section 1c (GKV Optimization), then Section 2 onwards.

---

### 1a. Cost Comparison — Angestellte Above JAEG

**GKV cost for Angestellter:**

```
Beitragsbemessungsgrenze (BBG) KV 2025: €5,512.50/month gross
GKV avg total rate 2025: ~16.3% (14.6% Basisbeitrag + ~1.7% avg Zusatzbeitrag)
Employee share: 8.15% of gross income (up to BBG)
Employer share (AG-Anteil): 8.15% of gross (up to BBG)

Monthly GKV employee cost:
  If gross ≤ €5,512.50/mo: gross × 8.15%
  If gross > €5,512.50/mo: €5,512.50 × 8.15% = €449.27/month (maximum)
```

**PKV cost for Angestellter:**

```
PKV premium: risk-rated at entry (age, sex, health status)
Employer contribution (AG-Zuschuss): min(50% of PKV premium, AG-Anteil GKV equivalent)
  AG-Anteil GKV equivalent 2025 max: ~€449/month
  Effectively: employer pays up to 50% of your PKV premium, or the GKV equivalent — whichever is lower.

Net PKV cost = PKV gross premium - AG-Zuschuss
```

**Rough PKV premium estimates (2025, Angestellter, good health, office profession, no pre-existing conditions):**

| Age | Monthly PKV premium | AG-Zuschuss (est.) | Net employee cost |
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
  [Note: gross above BBG; so: €5,512.50 × 8.15% = €449/month]
  → GKV employee cost: €449/month

PKV gross premium: ~€380/month (example)
AG-Zuschuss: min(€190, €449) = €190
PKV net employee cost: €190/month

Monthly savings with PKV: €449 - €190 = €259/month
Annual savings: ~€3,108
```

Compute this for user's actual income and estimated PKV range.

---

### 1b. The GKV/PKV Decision Matrix

**Do NOT recommend PKV if any of these apply:**

| Risk Factor | Weight | Explanation |
|-------------|--------|-------------|
| Non-working spouse / Familienversicherung beneficial | 🚨 Critical | PKV requires separate policy per family member. A family of 4 in PKV = 4× premium. GKV co-insures Ehepartner (not earning above Geringfügigkeitsgrenze: €556/month 2025) and all children FREE. |
| Pre-existing conditions | 🚨 Critical | PKV can exclude conditions, charge risk surcharges, or reject application. GKV cannot. |
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
- Office/academic profession (low BU risk class for PKV)
- No early retirement plan within GKV KVdR window
- Income firmly and sustainably above JAEG
- Self-employed where employer subsidy isn't a factor anyway

**PKV quality tier matters:** Not all PKV plans are equal. Key criteria:
- Beitragsrückerstattung (premium refund for claim-free years)
- Beitragsentwicklung (premium increase history — check with unabhängigem Makler or **pkv.de**)
- Chefarztbehandlung and Einbettzimmer: standard in most full tariffs
- Krankentagegeld: must be separately insured (see Section 2)

---

### 1c. GKV Optimization (For those staying in or required to use GKV)

**Kassenwahl — choice matters:**

All GKV funds provide the same statutory benefits (Pflichtleistungen per SGB V). They compete on:
- **Zusatzbeitrag**: varies from ~0.5% to ~2.5% in 2025 — difference on €4,000/month gross = €40–80/month
- **Zusatzleistungen**: dental bonus programmes, alternative medicine, sports courses (§20 SGB V), Bonusprogramme
- **Service quality**: app, response times, specialist referrals

**Well-rated GKV funds (check current Zusatzbeitrag at gesetzliche-krankenkassen.de):**
- **Techniker Krankenkasse (TK)**: consistently top-rated service, competitive Zusatzbeitrag
- **HKK**: often lowest Zusatzbeitrag, strong digital service
- **hkk / BKK Mobil Oil / Audi BKK**: check current rates — open Betriebskrankenkassen
- **Barmer / DAK / HEK**: large Ersatzkassen, broad nationwide coverage

**Action:** Compare current Krankenkasse Zusatzbeitrag vs cheapest alternative. Switching costs nothing and takes 2 months notice. On €5,000/month gross: 1% Zusatzbeitrag difference = €50/month = €600/year saved.

**Supplemental insurance within GKV (empfehlenswert):**
- **Zahnzusatzversicherung**: GKV covers only 60–70% of dental/prosthetics costs; gap can be thousands. Cost: ~€10–30/month. Worth it for most people.
- **Auslandskrankenversicherung**: GKV covers EU travel emergencies only. For travel outside EU or longer stays: ~€10–20/year (very cheap, very important).
- **Krankenhaustagegeld**: compensates income loss during hospital stay beyond Lohnfortzahlung.

---

### 1d. Selbstständige — Special Considerations

For Selbstständige, no employer contributes to GKV. Full rate falls on them:

**GKV as Selbstständige/r (freiwillig versichert):**
```
GKV total rate 2025: ~16.3%
Mindestbemessungsgrundlage 2025: €1,178.33/month
Minimum GKV monthly contribution: €1,178.33 × 16.3% = ~€192/month
  (This is the floor; actual income above this = higher contribution)

If monthly income €3,000: GKV = €3,000 × 16.3% = €489/month
If monthly income €5,000: GKV = €5,000 × 16.3% = €815/month (or BBG capped)
If monthly income €6,000+: capped at BBG = €5,512.50 × 16.3% = ~€899/month
```

*Verify Mindestbemessungsgrundlage annually at gkv-spitzenverband.de*

**PKV for Selbstständige:**
- No employer subsidy available
- Net cost = full PKV premium
- For young, healthy, solo Selbstständige: PKV frequently cheaper than full GKV rate
- Critical: plan for retirement healthcare from day one (see retirement impact above)

**Krankentagegeld for Selbstständige:** 
- GKV pays Krankengeld after 6 weeks — but Selbstständige need special opt-in Wahltarif (§ 53 SGB V) for Krankengeld, otherwise no income replacement
- PKV holders must separately buy Krankentagegeld tariff
- Recommendation: minimum €50–70/day Krankentagegeld coverage if self-employed
- This starts from Day 1, 8, 15, 29, or 43 depending on Karenzzeit chosen (longer wait = lower premium)

---

### 1e. Retirement Healthcare Impact — Critical for Long-Term Planning

**GKV → KVdR (Krankenversicherung der Rentner):**
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

**Verdict on retirement impact:** For anyone who is not firmly committed to staying in PKV throughout their entire career AND has a non-earning spouse or retirement lifestyle concerns: GKV provides substantial long-term security.

---

## Section 2: Berufsunfähigkeitsversicherung (BU)

**The most critical private insurance for working-age Germans.** No other single insurance has a higher impact-to-cost ratio for most Angestellte and Selbstständige.

### Why BU Is Critical

**Statutory protection is dangerously low:**

| Protection | What It Pays | Condition to Receive |
|------------|-------------|---------------------|
| Lohnfortzahlung (employer) | 100% gross | First 6 weeks of illness only |
| Krankengeld (GKV) | 70% of gross (max ~€120/day, 2025) | Weeks 7–78 of continuous illness |
| Erwerbsminderungsrente (GRV) | **Volle EMR: ~30–40% of last net income** | Cannot work >3h/day in ANY job |
| Erwerbsminderungsrente (GRV) | **Teilweise EMR: ~half of volle EMR** | Cannot work >6h/day in ANY job |

**Key problem with EMR:**
- It is NOT profession-specific — if you can work as a cashier for 3 hours/day, you may not qualify for volle EMR, even if you can no longer work as a surgeon or software engineer
- Requires at least 5 years of Pflichtbeiträge to GRV — recent graduates and early-career Selbstständige may not qualify at all
- Average volle EMR 2024: ~€960/month (new recipients). Varies widely by contribution history.
- Source: Deutsche Rentenversicherung Rentenversicherungsbericht

**BU insurance covers:** Inability to work in your **specific profession** at >50% capacity, regardless of whether you could theoretically do other work.

### BU Gap Calculation

```
Step 1: Monthly net income current = gross - taxes - Sozialabgaben
Step 2: Target income replacement = 75–80% of monthly net (minimum to maintain lifestyle)
Step 3: Expected EMR benefit = ~€900–1,100/month (estimate; use actual DRV projection if available)
         For those without 5 GRV years: EMR = €0
Step 4: BU monthly benefit needed = Target income - EMR
Step 5: BU monthly benefit minimum = Target income - EMR (should not be less than €1,500/month)
```

**Example:**
```
Gross: €5,000/month → Net ~€3,100/month (Angestellter, no church tax, GKV)
Target replacement: 75% of net = €2,325/month
Expected EMR: €1,000/month
BU needed: €1,325/month

Recommended BU: €1,500–2,000/month (round up; EMR estimate may not materialize)
```

### BU Premium Ranges (Rough Estimates, 2025)

Premium depends heavily on: age, profession risk class, sum, term, health history. Always get individual quotes.

**Profession risk classes (illustrative — varies by insurer):**
- **Klasse 1 (lowest risk)**: Software developer, analyst, teacher (Gymnasium), Bürokaufmann
- **Klasse 2**: Arzt, Anwalt, Ingenieur, Kaufmännische Berufe
- **Klasse 3**: Krankenpfleger, Erzieher, Einzelhandel
- **Klasse 4–5 (highest risk)**: Handwerker, Maurer, Elektriker, körperliche Berufe

**Rough monthly premiums, Klasse 1 profession, non-smoker, BU Rente €2,000/month, term to 67:**

| Age | Monthly premium |
|-----|----------------|
| 25 | ~€40–80 |
| 30 | ~€60–110 |
| 35 | ~€90–160 |
| 40 | ~€140–230 |
| 45 | ~€210–360 |

*For Klasse 3–4 professions: 2–4× these amounts. Source: BU market surveys from Morgen & Morgen, franke-bornberg.de*

### BU Quality Criteria (What to Check in a Policy)

- **§ 163 VVG (Verzicht auf abstrakte Verweisung)**: Insurer may NOT redirect you to a different profession you could theoretically do. Critical — verify explicitly.
- **Nachversicherungsgarantie**: Ability to increase BU benefit without new health check (marriage, children, income rise)
- **Rückwirkende Leistung**: Benefit paid retroactively if delay in determination
- **6-Monats-Prognose vs Dauerprognose**: 6-month prognosis preferred (begins paying sooner)
- **Weltweite Geltung**: Should apply globally
- **Rating**: Check Morgen & Morgen or franke-bornberg.de rating (aim for ★★★★★ providers: Allianz, MünchenerVerein, AXA, Zurich, LV1871, Condor for budget options)

**Combination products to AVOID:**
- BU + Kapitallebensversicherung: overpriced, inflexible
- BU + Altersvorsorge: keep insurance and investment separate

---

## Section 3: Risikolebensversicherung (Term Life)

**When needed:** Any person with financial dependents (spouse, children) who rely on their income.

### Coverage Calculation

```
Method 1 (Income replacement):
  Target: replace 10–15 years of net income
  Coverage = annual net income × 10-15

Method 2 (Needs-based):
  Coverage = remaining mortgage balance
           + (annual living costs - other household income) × years until independence
           + education costs for children
           + funeral + admin costs (~€15–25k)
```

**Risikolebensversicherung is cheap in Germany:**
- 35-year-old, non-smoker, good health, €300,000 sum, 20-year term
- Premium: ~€15–25/month
- **Ratschlag:** Always choose Risikolebensversicherung (term) NOT Kapitallebensversicherung (whole life) — Kapitallebens is an overpriced savings product with low returns (~2% historically).

**Annuitätisch fallende Versicherungssumme**: For mortgage coverage, declining sum matches remaining balance — cheaper premium.

**Verbundene Lebensversicherung für Paare**: Both partners insured in one policy; payout on first death. Cheaper than two separate policies but only pays once.

---

## Section 4: Essential Coverage Checklist

### 4a. Haftpflichtversicherung (Private Liability) — PRIORITY 1

**Status:** Nearly essential for everyone in Germany.

- Covers accidental damage caused to third parties (Personenschäden, Sachschäden, Vermögensschäden)
- Examples: drop borrowed laptop, accidentally injure someone on bicycle, child damages at school
- In Germany, personal liability is unlimited — one serious accident can destroy net worth
- **Cost: ~€50–100/year for single person; ~€80–130/year for family**
- Insurers: Huk-Coburg, Allianz, DEVK, Getsafe, Friday, Wertgarantie

If user doesn't have one: **open today**. Highest return per euro of any insurance.

### 4b. Hausratversicherung (Contents Insurance)

**For renters and homeowners:**
- Covers theft, fire, water damage to personal belongings
- Typical coverage: replacement value (Neuwert) not market value (Zeitwert)
- Cost: ~€3–6/€1,000 Versicherungssumme annually (use 650 €/sqm as estimate for contents value)
- 3-room apartment, 75sqm: estimate contents value €30,000 → ~€90–180/year
- Check: Fahrraddiebstahl usually needs explicit addon

**For Eigentümer:** Also need Wohngebäudeversicherung (building contents separate from structure).

### 4c. Pflegezusatzversicherung (Supplemental Long-Term Care)

**Statutory Pflegeversicherung gap:**
- Pflegegrade 1–5 system; statutory Pflegegeld (for home care) max: ~€1,995/month (Pflegegrad 5, 2025)
- Nursing home (Pflegeheim): average total cost ~€2,500–4,500/month
- Statutory covers Pflegesachleistungen; resident typically pays **Eigenanteil** averaging ~€2,100/month
- Source: AOK Institut für Gesundheitssystemforschung / vdek.com

**Recommendation:**
- Under 40: consider Pflegetagegeldversicherung while young and healthy — premiums very low
- Over 50: becoming important; premiums rise significantly with age
- Priority: lower than BU and Risikolebens for most under 45

### 4d. Rechtsschutzversicherung (Legal Expenses)

- Covers legal fees, lawyer costs, court costs
- Relevant areas: Arbeitsrecht (employment disputes), Mietrecht (tenant disputes), Verkehrsrecht (traffic)
- Wartezeit usually 3 months after policy start
- Cost: ~€180–350/year depending on coverage scope
- **Particularly useful for:** employment disputes (Kündigung, Abmahnung) and rental disputes — very common in Germany
- Caveat: does not cover family/divorce law, intentional acts

### 4e. Zahnzusatzversicherung (Supplemental Dental)

- GKV covers only 60–70% of dental/prosthetics (Festzuschuss system)
- Complex dentures, implants, orthodontics: remaining gap can be €1,000–8,000+
- Best time to take out: before dental issues arise (Wartezeit usually 3–8 months, no pre-existing coverage)
- Cost: ~€10–40/month depending on scope
- Worth evaluating if no existing dental issues and under 40

---

## Output: FINANCE-INSURANCE.md

Write to current working directory:

```markdown
# Versicherungsanalyse
**Erstellt:** [Datum]
**Profil:** [Angestellter/Selbstständiger], [Alter], [Familienstand]
**Krankenversicherung aktuell:** [GKV/PKV, Kasse/Versicherung, monatlich €X]

> **DISCLAIMER:** Informations- und Bildungszwecke. Keine Beratung im Sinne des VVG.
> Für GKV/PKV-Entscheidungen und BU-Abschluss: unabhängigen Versicherungsmakler konsultieren.

---

## 1. Krankenversicherung

### Situation
- Aktuell: [GKV/PKV] bei [Kasse/Versicherung], monatlich: €X (Arbeitnehmeranteil)
- JAEG 2025: €73,800 — Status: [Über/Unter Grenze / Nicht anwendbar Selbstständig]

### [If above JAEG or Selbstständig] GKV vs PKV Vergleich

| Kriterium | GKV | PKV |
|-----------|-----|-----|
| Monatlicher Beitrag (AN-Anteil / netto) | €X | €X |
| Jahreskosten | €X | €X |
| Familienversicherung (Ehepartner/Kind) | KOSTENLOS | €X extra/Person |
| Schutz bei Vorerkrankungen | Vollständig | [Ausschlüsse prüfen] |
| Leistungen | Gesetzl. Standard | [Tarif-abhängig] |
| Rückkehr zu GKV später | [Einfach/Schwierig] | — |
| Rentenphase | KVdR möglich (günstig) | Voller Beitrag allein |

**Empfehlung:** [GKV beibehalten / PKV prüfen / Wechsel nicht empfehlenswert]
**Begründung:** [Specific reasoning based on user profile — family, income stability, retirement plan]
**Priorität:** [Sofortiger Handlungsbedarf / Kein Handlungsbedarf]

### [If in GKV] Kassenwahl Optimierung
- Aktueller Zusatzbeitrag: X%
- Günstigere Alternativen: [list top 3 with current Zusatzbeitrag]
- Monatliche Ersparnis bei Wechsel: €X
- Empfohlene Zusatzversicherungen: [Zahnzusatz, Auslands-KV, etc.]

---

## 2. Berufsunfähigkeitsversicherung (BU)

| Kennzahl | Wert |
|----------|------|
| Monatliches Nettoeinkommen | €X |
| Ziel-Absicherung (75%) | €X/Monat |
| Erwartete Erwerbsminderungsrente (GRV) | ~€X/Monat |
| **BU-Bedarf (Gap)** | **€X/Monat** |
| Aktuelle BU-Rente | €X/Monat |
| **Absicherungslücke** | **€X/Monat** |

**Status:** [Gut abgesichert ✅ / Unterversichert ⚠️ / Keine BU — kritisch 🚨]

**Empfehlung:**
[If gap exists:]
- BU-Rente erhöhen auf €X/Monat (Nachversicherungsgarantie prüfen)
- Oder: Neue BU beantragen — geschätzte Prämie: €X–X/Monat
- Wichtige Qualitätskriterien beim Abschluss: [list relevant from policy criteria above]

**Einschätzung:** [Low/Medium/High urgency with specific reasoning]

---

## 3. Risikolebensversicherung

| Kennzahl | Wert |
|----------|------|
| Jährliches Nettoeinkommen | €X |
| Empfohlene Versicherungssumme | €X (10–15× Jahres-Netto) |
| Restliche Hypothek / Schulden der Familie | €X |
| Aktuell versicherte Summe | €X |
| **Deckungslücke** | **€X** |

**Status:** [Ausreichend ✅ / Lücke vorhanden ⚠️ / Keine Versicherung, Abhängige vorhanden 🚨]

[If no dependents: "Keine Risikolebensversicherung erforderlich."]

---

## 4. Pflichtcheck — Weitere Versicherungen

| Versicherung | Status | Priorität | Geschätzte Kosten/Jahr |
|--------------|--------|-----------|------------------------|
| Haftpflichtversicherung | ✅ / ❌ | [1-5] | €50–130 |
| Hausratversicherung | ✅ / ❌ | [1-5] | €90–200 |
| Zahnzusatzversicherung | ✅ / ❌ | [1-5] | €120–480 |
| Auslandskrankenversicherung | ✅ / ❌ | [1-5] | €10–30 |
| Rechtsschutzversicherung | ✅ / ❌ | [1-5] | €180–350 |
| Pflegezusatzversicherung | ✅ / ❌ | [1-5] | €200–600 (altersabhängig) |

---

## 5. Prioritized Action Plan

### Sofort (diese Woche)
1. [Most critical gap — e.g., Haftpflicht abschließen if missing]
2. [Second — e.g., Krankenkasse wechseln if Zusatzbeitrag high]

### Dieser Monat
1. [BU gap — unabhängigen Makler kontaktieren, Angebote vergleichen]
2. [Other urgent gap]

### Dieses Quartal
1. [Risikolebens if needed]
2. [Zahnzusatz before conditions arise]

### Mittel- bis Langfristig
1. [GKV/PKV strategic review if approaching JAEG]
2. [Pflegezusatz]

---

## 6. Empfohlene Anlaufstellen

- **Unabhängiger Versicherungsmakler** (§ 34d GewO) — für BU, PKV, Risikolebens
  - Check: Makler-Empfehlungen bei Verbraucherzentrale.de oder BdV (Bund der Versicherten)
  - NICHT: gebundene Vertreter von Allianz, AXA, etc. (nicht unabhängig)
- **Verbraucherzentrale.de** — unparteiische Versicherungsberatung (~€200/Stunde, fair)
- **Gesetzliche-Krankenkassen.de** — Kassenwahl und Zusatzbeitrag Vergleich
- **Morgen & Morgen / Franke-Bornberg** — BU-Rating Tabellen (neutral)
- **Bund der Versicherten (BdV)** — Beschwerdeanlaufstelle, Beratung

---

**DISCLAIMER:** Für Informations- und Bildungszwecke. Keine Beratung im Sinne des VVG (Versicherungsvertragsgesetz) oder WpHG. Keine Haftung für Entscheidungen, die auf dieser Analyse basieren. Prämienangaben sind Richtwerte und keine Angebote. Beiträge und Grenzen ändern sich jährlich. Konsultieren Sie für alle Versicherungsentscheidungen einen unabhängigen Versicherungsmakler (§ 34d GewO).
```

---

## Quality Standards

- GKV/PKV comparison always shows **net cost comparison** (after AG-Zuschuss for Angestellte)
- BU analysis always shows the **EMR gap** — not just "do you have a BU"
- Haftpflicht flagged as near-immediate action if missing — highest ROI per euro
- All figures cited with data source and year
- Never recommend specific insurer by name (conflict risk); recommend unabhängiger Makler
- PKV recommendation requires ALL favorable factors to be present; default to GKV when uncertain
- Risikolebens: always check for dependents first; never recommend without dependent need
- Always close with disclaimer and professional referrals

## Handoff

After writing FINANCE-INSURANCE.md:
1. State the single most critical gap (usually BU if missing, or Haftpflicht if missing)
2. State monthly cost to close it
3. Refer to unabhängigen Versicherungsmakler for BU and PKV decisions
4. Suggest `/finance retirement` to see how current insurance fits retirement planning
5. Suggest `/finance analyze` if full financial picture not yet assessed

**DISCLAIMER:** Für Informations- und Bildungszwecke. Keine Beratung im Sinne des VVG.
