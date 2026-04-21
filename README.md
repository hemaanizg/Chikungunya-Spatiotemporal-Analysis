# Spatiotemporal Dynamics and Demographic Determinants of Chikungunya in Brazil, 2015–2025

## Overview

This repository contains all data processing, analysis, and visualization code for the manuscript:

> Zhang Q, Chen S, Bento AI. *Spatiotemporal dynamics and demographic determinants of chikungunya in Brazil, 2015–2025: a nationwide Bayesian analysis.* [Under review]

We analyzed over 1.2 million laboratory-confirmed chikungunya cases from Brazil's national surveillance system (SINAN/DATASUS) to characterize temporal periodicity, spatial heterogeneity, and clinical progression across demographic groups.

---

## Data Sources

All data used in this study are publicly available:

| Dataset | Source | Access |
|---|---|---|
| Chikungunya case records (2015–2025) | SINAN via DATASUS | https://datasus.saude.gov.br/transferencia-de-arquivos/ |
| Zika case records (2016–2025) | SINAN via DATASUS | https://datasus.saude.gov.br/transferencia-de-arquivos/ |
| Municipality population estimates | IBGE | https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html |
| Municipality boundary shapefiles | IBGE via `geobr` R package | https://github.com/ipeaGIT/geobr |

Raw `.dbc` files can be downloaded from DATASUS using the links above. No registration is required.

---

## Repository Structure
├── Chikungunya_Spatiotemporal_Analysis.Rmd   # Main analysis file
├── fit_chik_interact_pop.rds                 # Saved Poisson INLA model object
├── fit_chik_nb.rds                           # Saved negative binomial INLA model object
├── moran_interaction_monthly.rds             # Monthly Moran's I results
├── README.md                                 # This file


---

## Analysis Pipeline

The main analysis file `Chikungunya_Spatiotemporal_Analysis.Rmd` runs in the following order:

1. **Data import and preprocessing** — Load raw `.dbc` files, filter confirmed cases, decode age, define variables
2. **Descriptive epidemiology** — Temporal trends, age/sex/ethnicity distributions, municipality-level sex differences
3. **Wavelet analysis** — Continuous wavelet transform of national monthly case counts
4. **Clinical symptom analysis** — UpSet plot of symptom co-occurrence, sex- and age-stratified symptom incidence
5. **Survival analysis** — Kaplan–Meier curves and Cox proportional hazards models for three clinical intervals
6. **Municipality-level delay analysis** — Choropleth maps of median delays
7. **Bayesian spatiotemporal model** — BYM2 + RW2 INLA model, IRR trajectories, spatial/temporal random effects
8. **Sensitivity analyses** — Negative binomial model comparison, Moran's I on space-time interaction term

---

## Computational Requirements

### R version
R ≥ 4.2.0

### Key packages

| Package | Version | Purpose |
|---|---|---|
| `INLA` | ≥ 23.0 | Bayesian spatiotemporal modeling |
| `spdep` | ≥ 1.2 | Spatial adjacency and Moran's I |
| `sf` | ≥ 1.0 | Spatial data handling |
| `geobr` | 1.9.1 | Brazilian municipality shapefiles |
| `survival` | ≥ 3.4 | Kaplan–Meier and Cox models |
| `ggsurvfit` | ≥ 0.3 | Survival curve visualization |
| `WaveletComp` | ≥ 1.1 | Wavelet analysis |
| `dplyr` | ≥ 1.1 | Data manipulation |
| `ggplot2` | ≥ 3.4 | Visualization |
| `read.dbc` | ≥ 1.0 | Reading DATASUS .dbc files |

Install INLA via:
```r
install.packages("INLA",
  repos = c(getOption("repos"),
  INLA = "https://inla.r-inla-download.org/R/stable"),
  dep = TRUE)
```

---

## Reproducing the Analysis

### Step 1: Download raw data
Download `.dbc` files from DATASUS for chikungunya (CHIK) and Zika (ZIKA) for years 2015–2025 and place them in a local directory. Update file paths at the top of the Rmd accordingly.

### Step 2: Run the analysis
Open `Chikungunya_Spatiotemporal_Analysis.Rmd` in RStudio and knit, or run chunks sequentially.

### Step 3: INLA model
The Bayesian spatiotemporal model is computationally intensive (~2–4 hours depending on hardware). Pre-fitted model objects are provided:

- `fit_chik_interact_pop.rds` — Primary Poisson model
- `fit_chik_nb.rds` — Negative binomial sensitivity model

To skip refitting, load directly:
```r
fit_chik_interact_pop <- readRDS("fit_chik_interact_pop.rds")
fit_chik_nb <- readRDS("fit_chik_nb.rds")
```

To refit from scratch, uncomment the `inla()` call and `saveRDS()` lines in the Rmd.

---

## Ethics Statement

This study used anonymized, publicly available surveillance data from Brazil's national notification system. Ethical approval was not required under Brazilian regulations governing the use of publicly available, de-identified data.

---

## Citation

If you use this code or data, please cite:

> Zhang Q, Chen S, Bento AI. Spatiotemporal dynamics and demographic determinants of chikungunya in Brazil, 2015–2025: a nationwide Bayesian analysis. [Under review, 2026]

---

## Contact

- Quanqi Zhang: qz396@cornell.edu
- Siyu Chen: sc3447@cornell.edu
- Ana I. Bento: arb24@cornell.edu
