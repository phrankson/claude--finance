---
name: finance-insurance
description: Insurance coverage advisor for German clients. Analyzes GKV vs PKV decision, Berufsunfähigkeitsversicherung (BU), Risikolebensversicherung, Haftpflichtversicherung, Rechtsschutzversicherung, and Hausratversicherung. Triggered by: /finance insurance, "Brauche ich PKV?", "BU Versicherung", "Versicherungscheck", "welche Versicherungen brauche ich?"
---

# Finance Insurance — Versicherungscheck für Angestellte

**DISCLAIMER: For educational/informational purposes only. Not insurance advice. Consult a licensed unabhängiger Versicherungsmakler (not a tied agent/Ausschließlichkeitsvertreter) before purchasing any insurance product.**

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

Ask in this order. For Angestellte below JAEG, skip GKV/PKV comparison — they have no choice.

**Profil**
1. Employment type — Angestellter/Angestellte oder Selbstständige/r?
2. Age (date of birth for precision)
3. Gross annual income (Bruttojahreseinkommen)
4. Family status — single / verheiratet (partner's income?) / Kinder (how many, ages)
5. Is spouse/partner employed and earning their own income?
6. Current health insurance — GKV or PKV? Which Krankenkasse / Versicherung? Monthly premium?
7. General health — no pre-existing conditions / some minor conditions / significant conditions?
8. Career outlook — plan to remain Angestellter long-term? Plan to become/remain Selbstständig?
9. Early retirement intent — plan to retire before 60? FIRE target?
10. Own or rent (Mieter oder Eigentümer)? City/region?

**Bestehende Versicherungen (ask all at once)**
11. Haftpflichtversicherung — vorhanden?
12. Berufsunfähigkeitsversicherung — vorhanden? Monthly Rente? Waiting period (Karenzzeit)?
13. Risikolebensversicherung — vorhanden? Sum insured? Term?
14. Hausratversicherung — vorhanden? Includes Elementarschaden?
15. Rechtsschutzversicherung — vorhanden? Which modules?
16. Other: Pflegezusatz, Zahnzusatz, KFZ?
17. Gewerkschaft membership? (relevant for Rechtsschutz)

---

## Insurance Framework

> Before analysis, read `.claude/skills/shared/german-context.md` for 2026 JAEG, GKV Beitragssatz, and other German financial constants.

### Insurance Priority Ranking for Standard Angestellte

1. 🔴 **Haftpflichtversicherung** — absolutely essential, lowest cost-to-risk ratio
2. 🔴 **BU (Berufsunfähigkeitsversicherung)** — most critical for income protection while working
3. 🟡 **Risikolebensversicherung** — essential only if dependents (children, partner relying on income)
4. 🟡 **Hausratversicherung** — recommended for renters
5. 🟡 **Rechtsschutzversicherung** — valuable for Angestellte and renters
6. 🟢 **Krankenversicherung (GKV/PKV)** — mandatory; analysis focuses on optimization

---

### Section 1: GKV vs PKV — The Most Consequential Insurance Decision

#### Who Has the Choice?

| Situation | Options |
|-----------|---------|
| Angestellter, Bruttolohn **below** JAEG (2026: €73,800/yr) | GKV mandatory — no choice |
| Angestellter, Bruttolohn **above** JAEG for current + prior year | Can choose GKV (freiwillig) or PKV |
| Selbstständige/r | Always free to choose GKV (freiwillig) or PKV |
| Beamte | Typically PKV + Beihilfe — not covered in this skill |

**JAEG 2026: €73,800 gross/year (€6,150/month)** — verify annual update at bmas.de.

If user is Angestellter below JAEG: skip to Section 1c (GKV Optimization), then Section 2 onwards.

---

#### 1a. Kostenvergleich — Angestellte Above JAEG

**GKV cost for Angestellter:**

```
Beitragsbemessungsgrenze (BBG) KV 2026: €8,050/month gross (€96,600/year)
GKV avg total rate 2026: ~16.3% (14.6% Basisbeitrag + ~1.7% avg Zusatzbeitrag)
Employee share: 8.15% of gross income (up to BBG)
Employer share (AG-Anteil): 8.15% of gross (up to BBG)

Monthly GKV employee cost:
  If gross <= €8,050/mo: gross × 8.15%
  If gross > €8,050/mo: €8,050 × 8.15% = €656.08/month (maximum)
```

**PKV cost for Angestellter:**

```
PKV premium: risk-rated at entry (age, sex, health status)
Employer contribution (AG-Zuschuss): min(50% of PKV premium, AG-Anteil GKV equivalent)
  Effectively: employer pays up to 50% of your PKV premium, or the GKV equivalent — whichever is lower.

Net PKV cost = PKV gross premium - AG-Zuschuss
```

**Rough PKV premium estimates (2026, Angestellter, good health, office profession, no pre-existing conditions):**

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

PKV gross premium: ~€380/month (example)
AG-Zuschuss: min(€190, €543) = €190
PKV net employee cost: €190/month

Monthly savings with PKV: €543 - €190 = €353/month
Annual savings: ~€4,236
```

Compute this for user's actual income and estimated PKV range.

---

#### 1b. GKV/PKV Entscheidungsmatrix

**Do NOT recommend PKV if any of these apply:**

| Risikofaktor | Gewichtung | Erläuterung |
|--------------|------------|-------------|
| Non-working spouse / Familienversicherung beneficial | 🚨 Critical | PKV requires separate policy per family member. A family of 4 in PKV = 4× premium. GKV co-insures Ehepartner (not earning above Geringfügigkeitsgrenze: €556/month) and all children FREE. |
| Pre-existing conditions | 🚨 Critical | PKV kann Vorerkrankungen ausschließen, Risikozuschläge erheben oder Antrag ablehnen. GKV cannot. |
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
- Krankentagegeld: must be separately insured

---

#### 1c. GKV Optimization (For those staying in or required to use GKV)

**Kassenwahl — choice matters:**

All GKV funds provide the same statutory benefits (Pflichtleistungen per SGB V). They compete on:
- **Zusatzbeitrag**: varies from ~0.5% to ~2.5% — difference on €4,000/month gross = €40–80/month
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

#### 1d. Selbstständige — Besonderheiten

For Selbstständige, no employer contributes to GKV. Full rate falls on them:

**GKV as Selbstständige/r (freiwillig versichert):**
```
GKV total rate 2026: ~16.3%
Mindestbemessungsgrundlage 2026: €1,178/month
Minimum GKV monthly contribution: €1,178 × 16.3% = ~€193/month
  (This is the floor; actual income above this = higher contribution)

If monthly income €3,000: GKV = €3,000 × 16.3% = €489/month
If monthly income €5,000: GKV = €5,000 × 16.3% = €815/month
If monthly income €8,050+: capped at BBG = €8,050 × 16.3% = ~€1,312/month
```

*Verify Mindestbemessungsgrundlage annually at gkv-spitzenverband.de*

**PKV for Selbstständige:**
- No employer subsidy available
- Net cost = full PKV premium
- For young, healthy, solo Selbstständige: PKV frequently cheaper than full GKV rate
- Critical: plan for retirement healthcare from day one (see retirement impact below)

**Krankentagegeld for Selbstständige:**
- GKV pays Krankengeld after 6 weeks — but Selbstständige need special opt-in Wahltarif (§ 53 SGB V) for Krankengeld, otherwise no income replacement
- PKV holders must separately buy Krankentagegeld tariff
- Recommendation: minimum €50–70/day Krankentagegeld coverage if self-employed
- This starts from Day 1, 8, 15, 29, or 43 depending on Karenzzeit chosen (longer wait = lower premium)

---

#### 1e. Retirement Healthcare Impact — Critical for Long-Term Planning

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

**Rückkehrrecht:** Once in PKV, returning to GKV as Angestellter above 55 is nearly impossible. Factor this permanently into the decision.

**Verdict on retirement impact:** For anyone who is not firmly committed to staying in PKV throughout their entire career AND has a non-earning spouse or retirement lifestyle concerns: GKV provides substantial long-term security.

---

### Section 2: Berufsunfähigkeitsversicherung (BU)

**The most critical private insurance for working-age Germans.** No other single insurance has a higher impact-to-cost ratio for most Angestellte and Selbstständige.

#### Why BU Is Critical

**Statutory protection is dangerously low:**

| Schutz | Zahlung | Voraussetzung |
|--------|---------|---------------|
| Lohnfortzahlung (Arbeitgeber) | 100% gross | First 6 weeks of illness only |
| Krankengeld (GKV) | 70% of gross (max ~€120/day) | Weeks 7–78 of continuous illness |
| Erwerbsminderungsrente volle (GRV) | **~30–40% of last net income** | Cannot work >3h/day in ANY job |
| Erwerbsminderungsrente teilweise (GRV) | **~half of volle EMR** | Cannot work >6h/day in ANY job |

**Key problem with EMR:**
- It is NOT profession-specific — if you can work as a cashier for 3 hours/day, you may not qualify for volle EMR, even if you can no longer work as a surgeon or software engineer
- Requires at least 5 years of Pflichtbeiträge to GRV — recent graduates and early-career Selbstständige may not qualify at all
- Average volle EMR: ~€960/month (new recipients). Varies widely by contribution history.
- Source: Deutsche Rentenversicherung Rentenversicherungsbericht

**BU insurance covers:** Inability to work in your **specific profession** at >50% capacity (Berufsunfähigkeitsgrad 50%), regardless of whether you could theoretically do other work. The Leistungsdefinition bedingungsgemäß ties the payout to your actual occupation — not a hypothetical alternative.

#### BU Gap Calculation

```
Step 1: Monthly net income current = gross - taxes - Sozialabgaben
Step 2: Target income replacement (Zielrente) = 70–80% of monthly net
Step 3: Expected EMR benefit = ~€900–1,100/month (estimate; use actual DRV projection if available)
         For those without 5 GRV years: EMR = €0
Step 4: BU monthly benefit needed = Target income - EMR
Step 5: BU monthly benefit minimum = should not be less than €1,500/month
```

**Wartezeit (Karenzzeit):** Standard BU policies begin paying after a 6-month continuous inability to work. Factor this into emergency fund planning — 6 months of expenses should be in reserve.

**Example:**
```
Gross: €5,000/month → Net ~€3,100/month (Angestellter, GKV, no church tax)
Zielrente (75% of net): €2,325/month
Expected EMR: €1,000/month
BU needed: €1,325/month

Recommended BU Rente: €1,500–2,000/month (round up; EMR estimate may not materialize)
```

#### BU Premium Ranges (Rough Estimates, 2026)

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

#### BU Quality Criteria (What to Check in a Policy)

- **Verzicht auf abstrakte Verweisung (§ 163 VVG)**: Insurer may NOT redirect you to a different profession you could theoretically do. **Critical** — verify explicitly. This is the single most important clause. Policies without this exclusion are substantially inferior.
- **Leistungsdefinition bedingungsgemäß**: Benefit triggered on your agreed occupation, not a theoretical one
- **Nachversicherungsgarantie**: Ability to increase BU benefit without new health check (marriage, children, income rise)
- **Rückwirkende Leistung**: Benefit paid retroactively if delay in determination
- **6-Monats-Prognose vs Dauerprognose**: 6-month prognosis preferred (begins paying sooner)
- **Weltweite Geltung**: Should apply globally
- **Nettobeitrag vs Tarifbeitrag**: Always compare **Nettobeitrag** (actual charged premium) not Tarifbeitrag (maximum insurer can charge). Ask insurer for 10-year Nettobeitrag history.
- **Rating**: Check Morgen & Morgen or franke-bornberg.de rating (aim for ★★★★★ providers: Allianz, MünchenerVerein, AXA, Zurich, LV1871, Condor for budget options)

**Combination products to AVOID:**
- BU + Kapitallebensversicherung: overpriced, inflexible
- BU + Altersvorsorge: keep insurance and investment separate

---

### Section 3: Risikolebensversicherung (Term Life)

**When needed:** Any person with financial dependents (spouse, children) who rely on their income.

**When NOT needed:** Single persons with no dependents. No need to insure a risk that no one else bears.

#### Coverage Calculation

```
Method 1 (Income replacement):
  Mindest-Deckungssumme: 10× annual net income
  Optimal: 10–15× annual net income

Method 2 (Needs-based):
  Coverage = remaining mortgage balance
           + (annual living costs - other household income) × years until independence
           + education costs for children
           + funeral + admin costs (~€15–25k)
```

**Risikolebensversicherung is cheap in Germany:**
- 35-year-old, non-smoker, good health, €300,000 sum, 20-year term
- Premium: ~€15–25/month

**Always choose Risikolebensversicherung (term) NOT Kapitallebensversicherung (whole life):** Kapitallebens is an overpriced savings product with historically low returns (~2%). Insurance and investment should be separate.

**Restschuldversicherung vs. standalone Risikolebensversicherung:**
- Restschuldversicherung: tied to the loan, sold by bank at point of mortgage — typically overpriced and restricted
- A standalone Risikolebensversicherung is almost always better value: more flexible, independent of bank, can cover more than just the mortgage balance
- Use annuitätisch fallende Versicherungssumme if covering mortgage only — cheaper premium as sum matches declining balance

**Verbundene Lebensversicherung für Paare**: Both partners insured in one policy; payout on first death. Cheaper than two separate policies but only pays once — evaluate carefully if both partners are primary earners.

---

### Section 4: Haftpflichtversicherung (Personal Liability Insurance) — CRITICAL

**Why essential:** In Germany, you are personally liable for all damages you cause (§ 823 BGB). There is no statutory cap. One serious accident — injuring someone as a cyclist, accidentally causing a fire, a child causing damage — can result in claims running into the millions. Without Haftpflichtversicherung, your entire net worth is at risk.

**If client has NO Haftpflichtversicherung → flag as critical gap requiring immediate action.**

#### Minimum Deckungssumme

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

### Section 5: Rechtsschutzversicherung (Legal Expenses Insurance) — Situational

**What it covers:** Legal costs (Anwalts-, Gerichts-, Sachverständigenkosten) for disputes across key modules.

#### Key Coverage Modules

| Modul | Inhalt | Relevanz für Angestellte |
|-------|--------|--------------------------|
| Arbeitsrecht | Employment disputes — Kündigung, Abmahnung, unfair dismissal | Sehr hoch |
| Verkehrsrecht | Traffic disputes, accidents, Bußgeld-Einspruch | Hoch (Autofahrer) |
| Mietrechtsschutz | Landlord-tenant disputes, Nebenkosten, Kündigung | Hoch (Mieter) |
| Vertragsrecht | Consumer disputes, online purchases | Mittel |
| Strafrecht (passiv) | Defense costs in criminal proceedings | Situational; check policy |

**Wartezeit:** Typically 3 months after policy start — you cannot buy after a dispute has arisen. Plan ahead.

#### Cost

- €150–400/year depending on scope and deductible (Selbstbeteiligung)
- Often €150–300 Selbstbeteiligung per claim — this keeps premiums lower

#### When it IS worth it

- Renting in Germany (Mietrechtsstreitigkeiten are very common)
- Employed in a large company (Arbeitsrechtschutz is highly valuable — labor disputes in Germany can be lengthy)
- Car owner (Verkehrsrecht module)
- Self-employed with frequent contracts (Vertragsrecht)

#### When to SKIP

- Already a **Gewerkschaft** member: trade union provides Rechtsschutz for Arbeitsrecht free of charge — no need to duplicate this module
- Emergency fund large enough to self-insure moderate legal costs (most single disputes: €1,000–5,000)
- If no car, no rental situation, and union covers employment: marginal value

---

### Section 6: Hausratversicherung (Contents Insurance) — Recommended for Renters

#### What it covers

- **Einbruchdiebstahl** (burglary and theft)
- **Feuer** (fire, lightning, explosion)
- **Leitungswasser** (burst pipes, water damage)
- **Sturm und Hagel** (storm and hail — typically from wind force 8 / Windstärke 8 or above)

#### What it does NOT cover (standard policy)

- **Flooding from outside** (Hochwasser, Überschwemmung) — requires Elementarschadenversicherung add-on
- Foundation water ingress
- Intentional damage
- Items outside the home (unless explicitly covered — check Fahrraddiebstahl clause)

#### Elementarschadenversicherung (Add-on)

Covers: flooding, earth movement, landslides, snow pressure, Rückstau (backflow from drains).

- Increasingly important — climate events have increased frequency of flood damage across Germany
- Especially relevant in flood-prone regions: Bavaria (Donau, Inn), Rhineland (Ahr, Rhine), Baden-Württemberg
- Cost add-on: typically €30–80/year additional, depending on location risk zone
- Check **Zürs** (Zonierungssystem Überschwemmung, Rückstau und Starkregen) for property risk zone

#### Versicherungssumme

- Insure at **Neuwert** (replacement cost), not Zeitwert (current market value)
- Estimate contents: use ~€650/sqm as a rule of thumb (e.g., 75sqm flat: ~€48,750 estimated contents value)
- **Always include Unterversicherungsverzicht clause**: insurer cannot invoke the proportional reduction rule (Unterversicherung) if you have declared in good faith. Without this clause, if your declared sum is 80% of actual value, the insurer pays only 80% of any claim.
- Fahrraddiebstahl: typically requires explicit clause and sometimes minimum lock specification

#### Cost

- Approximately **€60–150/year** depending on city, flat size, and coverage level
- Major cities (München, Hamburg, Frankfurt): toward upper range

#### Renters vs. Owners

- **Mieter (renters)**: Hausratversicherung is highly recommended. Building structure is covered by Wohngebäudeversicherung, which is the Vermieter's or WEG's responsibility — not the tenant's.
- **Eigentümer**: Need both Hausratversicherung (contents) and either contribute to WEG's Wohngebäudeversicherung (in a Wohnungseigentümergemeinschaft) or take their own Wohngebäudeversicherung (for a Haus).

---

## Output

Write FINANCE-INSURANCE.md to current working directory with the following structure:

```markdown
# Versicherungsanalyse
**Erstellt:** [Datum]
**Profil:** [Angestellter/Selbstständiger], [Alter], [Familienstand]
**Krankenversicherung aktuell:** [GKV/PKV, Kasse/Versicherung, monatlich €X]

> **DISCLAIMER:** Informations- und Bildungszwecke. Keine Beratung im Sinne des VVG.
> Für GKV/PKV-Entscheidungen und BU-Abschluss: unabhängigen Versicherungsmakler konsultieren.

---

## Prioritätsübersicht

| Priorität | Versicherung | Status | Handlungsbedarf |
|-----------|-------------|--------|-----------------|
| 🔴 1 | Haftpflichtversicherung | ✅ / ❌ | [Sofort / OK] |
| 🔴 2 | Berufsunfähigkeitsversicherung | ✅ / ❌ / ⚠️ | [Lücke €X/Mo / OK] |
| 🟡 3 | Risikolebensversicherung | ✅ / ❌ / N/A | [Lücke €X / OK / Keine Abhängigen] |
| 🟡 4 | Hausratversicherung | ✅ / ❌ | [Empfohlen / OK] |
| 🟡 5 | Rechtsschutzversicherung | ✅ / ❌ | [Prüfen / OK] |
| 🟢 6 | Krankenversicherung (GKV/PKV) | [GKV/PKV] | [Optimierung / OK] |

---

## 1. Haftpflichtversicherung

### Situation
- Status: [Vorhanden ✅ / Nicht vorhanden ❌ — KRITISCHE LÜCKE]
- Deckungssumme (falls vorhanden): €X

### Analyse
[If missing: flag as immediate action — highest ROI per euro of any insurance; personal liability under §823 BGB is unlimited]
[If present: confirm Deckungssumme ≥ €10M; check family coverage if applicable]

### Empfehlung
- **Aktion:** [Sofort abschließen / Prüfen ob Deckungssumme ausreicht / OK]
- Empfohlene Deckungssumme: €10 Mio. Personen-/Sach-/Vermögensschäden
- Geschätzte Kosten: €50–80/Jahr (Single) / €80–120/Jahr (Familie)
- Vergleich: Check24, Verivox; Anbieter: ARAG, HUK-Coburg, Allianz, Gothaer, Cosmos Direkt

---

## 2. Berufsunfähigkeitsversicherung (BU)

### BU-Lückenrechnung

| Kennzahl | Wert |
|----------|------|
| Monatliches Nettoeinkommen | €X |
| Zielrente (70–80% Netto) | €X/Monat |
| Erwartete Erwerbsminderungsrente (GRV) | ~€X/Monat |
| **BU-Bedarf (Lücke)** | **€X/Monat** |
| Aktuelle BU-Rente (falls vorhanden) | €X/Monat |
| **Verbleibende Absicherungslücke** | **€X/Monat** |

**Status:** [Gut abgesichert ✅ / Unterversichert ⚠️ / Keine BU — kritisch 🚨]

### Empfehlung
[If gap exists:]
- BU-Rente erhöhen auf €X/Monat (Nachversicherungsgarantie prüfen)
- Oder: Neue BU beantragen — geschätzte Nettobeitrag: €X–X/Monat
- Wichtige Qualitätskriterien: Verzicht auf abstrakte Verweisung, Nachversicherungsgarantie, Nettobeitrag prüfen (nicht Tarifbeitrag)
- Immer: unabhängigen Versicherungsmakler einschalten

---

## 3. Risikolebensversicherung

### Situation
[If no dependents: "Keine Abhängigen — Risikolebensversicherung derzeit nicht erforderlich."]

[If dependents:]

| Kennzahl | Wert |
|----------|------|
| Jährliches Nettoeinkommen | €X |
| Empfohlene Mindest-Deckungssumme (10× Netto) | €X |
| Restliche Hypothek / Familienschulden | €X |
| Aktuell versicherte Summe | €X |
| **Deckungslücke** | **€X** |

**Status:** [Ausreichend ✅ / Lücke vorhanden ⚠️ / Keine Versicherung, Abhängige vorhanden 🚨]

### Empfehlung
- Standalone Risikolebensversicherung (term) bevorzugen — keine Restschuldversicherung der Bank
- Keine Kapitallebensversicherung
- Geschätzte Kosten: ~€15–30/Monat (35J, €300k, 20 Jahre, Nichtraucher)

---

## 4. Hausratversicherung

### Situation
- Status: [Vorhanden ✅ / Nicht vorhanden ❌]
- Mieter oder Eigentümer: [X]
- Elementarschaden-Zusatz: [Vorhanden / Nicht vorhanden / Nicht geprüft]

### Analyse
[For renters without Hausrat: recommend immediately]
[Check: Unterversicherungsverzicht included? Fahrraddiebstahl covered?]
[If in flood-prone area: flag Elementarschadenversicherung add-on]

### Empfehlung
- Geschätzte Versicherungssumme: €X (auf Basis Wohnfläche × €650/sqm)
- Empfehlung Elementarschaden-Zusatz: [Ja — Region X / Prüfen]
- Geschätzte Kosten: €60–150/Jahr

---

## 5. Rechtsschutzversicherung

### Situation
- Status: [Vorhanden ✅ / Nicht vorhanden ❌]
- Module (falls vorhanden): [Arbeitsrecht / Verkehrsrecht / Mietrecht / Vertragsrecht]
- Gewerkschaftsmitglied: [Ja — Arbeitsrecht abgedeckt / Nein]

### Analyse
[Evaluate need per situation: renter + employee = high value; union member = Arbeitsrecht already covered]
[Flag Wartezeit: cannot buy after dispute arises]

### Empfehlung
- **Empfehlung:** [Sinnvoll für dieses Profil / Weniger relevant / Gewerkschaft deckt Hauptrisiken ab]
- Wenn sinnvoll: Module prüfen — Arbeitsrecht + Mietrecht als Minimum für Angestellte/Mieter
- Geschätzte Kosten: €150–400/Jahr

---

## 6. Krankenversicherung (GKV / PKV)

### Situation
- Aktuell: [GKV/PKV] bei [Kasse/Versicherung], monatlich: €X (Arbeitnehmeranteil)
- JAEG 2026: €73,800 — Status: [Über / Unter Grenze / Nicht anwendbar Selbstständig]

### [If above JAEG or Selbstständig] GKV vs PKV Vergleich

| Kriterium | GKV | PKV |
|-----------|-----|-----|
| Monatlicher Beitrag (AN-Anteil / netto) | €X | €X |
| Jahreskosten | €X | €X |
| Familienversicherung (Ehepartner/Kind) | KOSTENLOS | €X extra/Person |
| Schutz bei Vorerkrankungen | Vollständig | [Ausschlüsse prüfen] |
| Rückkehrrecht nach 55 | Möglich | Sehr schwierig |
| Rentenphase | KVdR möglich (günstig) | Voller Beitrag allein |

**Empfehlung:** [GKV beibehalten / PKV prüfen / Wechsel nicht empfehlenswert]
**Begründung:** [Specific reasoning based on user profile — family, income stability, retirement plan]

### [If in GKV] Kassenwahl Optimierung
- Aktueller Zusatzbeitrag: X%
- Günstigere Alternativen: [list top 3 with current Zusatzbeitrag from gesetzliche-krankenkassen.de]
- Monatliche Ersparnis bei Wechsel: €X
- Empfohlene Zusatzversicherungen: [Zahnzusatz, Auslands-KV falls relevant]

---

## 7. Priorisierter Aktionsplan

### Sofort (diese Woche)
1. [Most critical gap — typically: Haftpflicht abschließen if missing]
2. [Second priority — e.g., Krankenkasse wechseln if Zusatzbeitrag significantly above market]

### Dieser Monat
1. [BU gap — unabhängigen Versicherungsmakler kontaktieren, Nettobeiträge vergleichen]
2. [Hausrat abschließen if renter without coverage]

### Dieses Quartal
1. [Risikolebens if dependents and gap identified]
2. [Rechtsschutz — evaluate if Mieter and/or Angestellter without Gewerkschaft]
3. [Zahnzusatz before dental issues arise]

### Mittel- bis Langfristig
1. [GKV/PKV strategic review if approaching JAEG threshold]
2. [Elementarschaden add-on to Hausrat if flood-prone region]
3. [Pflegezusatz — consider under 40 while premiums are low]

---

## 8. Empfohlene Anlaufstellen

- **Unabhängiger Versicherungsmakler** (§ 34d GewO) — für BU, PKV, Risikolebens
  - NICHT: gebundene Vertreter von Allianz, AXA etc. (Ausschließlichkeitsvertreter — nicht unabhängig)
  - Empfehlungen: Verbraucherzentrale.de oder BdV (Bund der Versicherten)
- **Verbraucherzentrale.de** — unparteiische Versicherungsberatung (~€200/Stunde, unabhängig)
- **Gesetzliche-Krankenkassen.de** — Kassenwahl und Zusatzbeitrag Vergleich
- **Morgen & Morgen / Franke-Bornberg (franke-bornberg.de)** — BU-Rating-Tabellen (neutral)
- **Bund der Versicherten (BdV)** — Beschwerdeanlaufstelle, Beratung
- **Check24 / Verivox** — Haftpflicht, Hausrat, Rechtsschutz Preisvergleich

---

**DISCLAIMER:** Für Informations- und Bildungszwecke. Keine Beratung im Sinne des VVG (Versicherungsvertragsgesetz). Keine Haftung für Entscheidungen, die auf dieser Analyse basieren. Prämienangaben sind Richtwerte und keine Angebote. Beiträge und Grenzen ändern sich jährlich — Werte hier basieren auf 2026 Zahlen. Konsultieren Sie für alle Versicherungsentscheidungen einen unabhängigen Versicherungsmakler (§ 34d GewO).
```

---

## Quality Standards

- GKV/PKV comparison always shows **net cost comparison** (after AG-Zuschuss for Angestellte)
- BU analysis always shows the **EMR gap** — not just "do you have a BU"
- Always compare BU Nettobeitrag, not Tarifbeitrag
- Haftpflicht flagged as immediate action if missing — highest ROI per euro
- All figures cited with data source and year; JAEG and BBG values taken from shared german-context.md
- Never recommend specific insurer by name for BU or PKV (conflict risk); recommend unabhängiger Makler
- PKV recommendation requires ALL favorable factors to be present; default to GKV when uncertain
- Risikolebens: always check for dependents first; never recommend without dependent need
- Rechtsschutz: always check Gewerkschaft membership before recommending (Arbeitsrecht may be covered)
- Hausrat: always check for Unterversicherungsverzicht and Elementarschaden relevance
- Always close with disclaimer and professional referrals
- No US insurance terminology, no dollar amounts, no ACA/COBRA/Medicare references

---

## Handoff

After writing FINANCE-INSURANCE.md:

1. State the single most critical gap (Haftpflicht if missing is always first; BU gap if present)
2. State the monthly or annual cost to close the most critical gap
3. Refer to unabhängigen Versicherungsmakler (§ 34d GewO) for BU and PKV decisions — not tied agents
4. Suggest `/finance analyze` if full financial picture not yet assessed
5. Suggest `/finance retirement` to see how current insurance fits retirement planning

**DISCLAIMER:** Für Informations- und Bildungszwecke. Keine Beratung im Sinne des VVG.
