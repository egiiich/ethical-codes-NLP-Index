# Results

## 1. Sample and variable structure

The empirical dataset contains 210 corporate documents included in `registry/principle_index_matrix.csv`. Each observation represents one company-level code document with country, industry, and year metadata, plus 11 numeric principle indices. The observed years range from 2004 to 2026. Country coverage includes China (45 documents), Korea (45), Japan (44), Indonesia (40), and Russia (36). 

For the purposes of this Results section, the dependent aggregate quality measure is defined as:

\[
\text{Total Ethics Quality Index}_i = \sum_{k=1}^{11} \text{PrincipleIndex}_{ik}
\]

where the 11 component indices are: competitor relations, hotline principles, company-to-supplier, worker-to-company, company-to-investors, company-to-people, company-to-buyer, worker-to-worker, manager-to-worker, company-to-worker, and worker-to-manager.

Across all 210 observations, the Total Ethics Quality Index has:

- Mean = **55.64**
- Standard deviation = **22.91**
- Minimum = **11**
- Maximum = **128**

This indicates substantial dispersion in measured code comprehensiveness across firms and sectors.

## 2. Descriptive distribution of component indices

Table-like summary of component means (descending order):

1. **worker_to_company**: mean 10.65, SD 3.78  
2. **hotline_principles**: mean 8.10, SD 5.22  
3. **company_to_buyer**: mean 6.93, SD 4.87  
4. **company_to_worker**: mean 6.09, SD 3.60  
5. **company_to_supplier**: mean 4.80, SD 3.47  
6. **company_to_people**: mean 4.47, SD 3.41  
7. **company_to_investors**: mean 4.29, SD 2.98  
8. **worker_to_worker**: mean 3.61, SD 2.59  
9. **competitor_relations**: mean 3.32, SD 2.83  
10. **manager_to_worker**: mean 2.36, SD 2.63  
11. **worker_to_manager**: mean 1.02, SD 1.52

Expressed as shares of the aggregate mean index (55.64), the largest contributors are worker_to_company (19.1%), hotline_principles (14.5%), company_to_buyer (12.5%), and company_to_worker (10.9%). The smallest share is worker_to_manager (1.8%).

Two planned paired mean-difference checks were estimated:

- Difference (worker_to_company − hotline_principles) = **+2.55**, t ≈ 7.17, p < 0.001.
- Difference (worker_to_manager − manager_to_worker) = **−1.34**, t ≈ −9.23, p < 0.001.

Both differences are statistically significant at conventional thresholds.

## 3. Principle-level coverage results using the wide matrix

To complement index-level results, `registry/principle_presence_matrix_wide.csv` was used to summarize coding prevalence at the individual principle-item level.

- Documents: 210
- Principle items per document: 94
- Total coded cells: 19,740

Global coding frequencies:

- **absent**: 14,900 cells (75.48%)
- **explicit_section**: 3,398 cells (17.21%)
- **brief_mention**: 1,442 cells (7.30%)

Thus, explicit or brief inclusion combined equals 24.52% of all potential principle cells.

By principle family (using item prefixes):

- **WtoC** (worker-to-company items): explicit 33.2%, brief 6.7%, absent 60.1%.
- **HOT** (hotline items): explicit 27.3%, brief 7.4%, absent 65.3%.
- **CtoB** (company-to-buyer): explicit 23.1%, brief 7.4%, absent 69.5%.
- **CtoS** (company-to-supplier): explicit 18.8%, brief 11.9%, absent 69.3%.
- **CtoW** (company-to-worker): explicit 18.2%, brief 6.2%, absent 75.6%.
- **CtoI** (company-to-investors): explicit 16.3%, brief 4.7%, absent 79.0%.
- **CtoP** (company-to-people): explicit 12.1%, brief 8.1%, absent 79.8%.
- **WtoW** (worker-to-worker): explicit 12.3%, brief 8.0%, absent 79.7%.
- **COMP** (competitor relations): explicit 9.4%, brief 4.9%, absent 85.8%.
- **MtoW** (manager-to-worker): explicit 10.3%, brief 8.1%, absent 81.6%.
- **WtoM** (worker-to-manager): explicit 2.2%, brief 10.2%, absent 87.5%.

The item-level profile is consistent with the index-level ranking: worker-to-company and hotline-related coverage are highest, while worker-to-manager and competitor-related coverage are substantially lower.

## 4. Hypothesis testing results

The following hypotheses were tested ex ante.

### H1: Temporal trend

**H1 statement:** Newer documents have higher Total Ethics Quality Index values.

Two tests were run:

1. Bivariate Pearson correlation between year and total index:
   - r = **0.1689**
   - t ≈ 2.47
   - p = **0.0135**

2. Multivariate OLS (with country and industry fixed effects as dummies):
   - Year coefficient = **0.861**
   - Robust SE = 0.392
   - p = **0.0280**

**H1 decision:** **Confirmed** (significant positive association at 5% level in both bivariate and multivariate specifications).

### H2: Country-level differences

**H2 statement:** Mean total index differs across countries.

One-way ANOVA (country groups) with permutation-based p-value:

- F(4, 205) = **2.622**
- p = **0.0352**
- eta-squared = **0.049**

Country means:

- Korea: 62.40
- Japan: 58.95
- Indonesia: 56.20
- Russia: 50.56
- China: 49.22

In the multivariate OLS with controls, relative to China (reference):

- Japan: +12.16 (p = 0.0055)
- Korea: +13.64 (p = 0.0017)
- Indonesia: +2.90 (p = 0.498)
- Russia: +2.77 (p = 0.599)

**H2 decision:** **Confirmed** (overall country effect significant). In adjusted regression, only Japan and Korea differ significantly from the China reference category.

### H3: Industry-level differences

**H3 statement:** Mean total index differs across industries.

One-way ANOVA (20 industries) with permutation-based p-value:

- F(19, 190) = **3.998**
- p = **0.0002**
- eta-squared = **0.286**

Highest mean industries (unadjusted):

- Insurance: 83.00
- Manufacturing: 71.89
- Defense: 67.00
- Digital: 66.43
- Automotive: 61.40

Lowest mean industries (unadjusted):

- Telecom: 38.17
- Finance: 42.46
- Logistics: 47.10
- Mining: 47.62
- Tech: 51.44

In the fully adjusted OLS (country + year + industry dummies), none of the individual industry coefficients remained significant at p < 0.05.

**H3 decision:** **Confirmed** for unadjusted between-industry mean differences; **not confirmed at individual-coefficient level in the fully adjusted model**.

### H4: Company-centered orientation versus employee-protection orientation

**H4 statement:** Ethical codes revolve more around the interests of the company rather than protect the rights and needs of employees.

To test this, two composite scores were defined at the document level:

- **Company-interest orientation** = competitor_relations + company_to_supplier + company_to_investors + company_to_buyer + worker_to_company
- **Employee-protection orientation** = company_to_worker + manager_to_worker + worker_to_manager + worker_to_worker + hotline_principles

Descriptive comparison:

- Mean company-interest orientation = **30.00**
- Mean employee-protection orientation = **21.18**
- Mean paired difference = **+8.82** points

Paired mean-difference test across documents:

- t ≈ 11.31
- p < 0.001

**H4 decision:** **Confirmed**.

### H5: Institutionalization of compliance over time

**H5 statement:** The institutionalization of compliance is increasing over time.

A compliance institutionalization proxy index was constructed as:

- **Compliance institutionalization index** = hotline_principles + manager_to_worker + worker_to_manager + company_to_worker

This captures formal reporting architecture and vertical accountability/response channels in the coded matrix.

Two tests were estimated:

1. Bivariate correlation with year:
   - r = **0.1402**
   - p = **0.0411**

2. OLS with country and industry controls (HC3 robust SE):
   - Year coefficient = **0.423**
   - Robust SE = 0.165
   - p = **0.0101**
   - Adjusted R² = 0.190

**H5 decision:** **Confirmed**.

### H6: Composite index reliability is acceptable for model use

**H6 statement:** The 11-dimensional composite has acceptable internal consistency.

Cronbach’s alpha across the 11 components:

- α = **0.817**

A principal-component concentration check found first component eigenvalue ≈ 4.297, explaining about **39.1%** of standardized total variance.

**H6 decision:** **Confirmed** (alpha above common reliability threshold of 0.70; first latent component is substantial).

## 5. Empirical framework and core model output

The main empirical model estimated was:

\[
\text{TotalIndex}_i = \beta_0 + \beta_1\text{Year}_i + \sum_c \gamma_c\text{Country}_{ic} + \sum_s \delta_s\text{Industry}_{is} + \varepsilon_i
\]

Estimation details:

- Method: OLS with HC3 heteroskedasticity-robust standard errors.
- Sample size: n = 210.
- Number of parameters (including intercept): k = 25.
- Reference groups: Country = China; Industry = Agriculture.

Model fit:

- R² = **0.358**
- Adjusted R² = **0.275**

Significant coefficients (p < 0.05):

- Year: +0.861 (SE 0.392, p = 0.028)
- Country: Japan +12.16 (SE 4.39, p = 0.0055)
- Country: Korea +13.64 (SE 4.34, p = 0.0017)

No individual industry dummy was significant in the controlled model at the 5% threshold.

## 6. Model validity and robustness checks

To justify model validity, multiple robustness checks were conducted. The objective here is to evaluate result stability across alternative samples and specifications.

### 6.1 Robustness check A: Winsorized dependent variable

The total index was winsorized at the 5th and 95th percentiles (cut points: 18 and 91), then the same OLS specification was re-estimated.

- Year coefficient = **0.799**
- p = **0.0302**
- Adjusted R² = **0.256**

The year effect remains positive and statistically significant.

### 6.2 Robustness check B: Outlier-trimmed sample

Observations with total index outside ±3 standard deviations from the mean were removed (n reduced from 210 to 208), and the model was re-estimated.

- Year coefficient = **0.779**
- p = **0.0434**
- Adjusted R² = **0.244**

The sign and significance status of the year effect remains unchanged.

### 6.3 Robustness check C: Post-2015 subsample

The model was estimated on observations from 2015 onward (n = 203):

- Year coefficient = **1.038**
- p = 0.103
- Adjusted R² = 0.280

In this reduced time-window subsample, the year coefficient remains positive but is not significant at 5%.

### 6.4 Robustness check D: Median-split linear probability model

A binary outcome (1 if total index ≥ sample median; 0 otherwise) was modeled with the same predictors.

- Year coefficient = **0.0168**
- p = 0.0729
- Adjusted R² = 0.158

The direction remains positive, with marginal significance at 10% and not at 5%.

### 6.5 Robustness check E: Bootstrap confidence interval for year effect

Bootstrap resampling (296 valid draws in the implemented run) produced:

- Median year coefficient: 0.837
- 95% bootstrap interval: [0.074, 1.659]

The interval is fully above zero.

### 6.6 Summary of robustness evidence

Across winsorized, outlier-trimmed, and bootstrap checks, the year effect remains positive and generally significant. In more restrictive or transformed-outcome specifications (post-2015 subsample, median-split LPM), statistical significance weakens while coefficient sign remains positive.

## 7. Consolidated hypothesis decision table

- **H1 (positive time trend): Confirmed** in baseline and most robustness tests; weakened significance in narrower subsamples/specifications.
- **H2 (country differences): Confirmed** by global country ANOVA; Japan and Korea significantly above China in adjusted model.
- **H3 (industry differences): Partially confirmed** — significant unadjusted cross-industry variation, but no single industry coefficient significant after full controls.
- **H4 (company-interest orientation exceeds employee-protection orientation): Confirmed**.
- **H5 (compliance institutionalization increases over time): Confirmed**.
- **H6 (composite reliability acceptable): Confirmed**.

## 8. Objective synthesis of observed patterns

The results indicate that measured ethics-code quality is heterogeneous across firms (range 11 to 128), with moderate explanatory power from observable temporal and structural covariates (adjusted R² near 0.275 in baseline). The strongest consistently measured dimensions are worker-to-company and hotline principles, while worker-to-manager representation is systematically limited. Country-level differences are statistically detectable, with higher adjusted outcomes for Japan and Korea relative to China in this sample. Industry means differ substantially in unadjusted comparisons, but those contrasts are attenuated after controlling for country and publication year. Reliability diagnostics support use of the 11-index composite for inferential modeling.

No interpretive claims beyond statistical description are introduced in this section.
