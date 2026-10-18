# Chikungunya in Brazil: Spatiotemporal Risk, Disease Severity, and Vaccination Prioritization

**A nationwide Bayesian epidemiological analysis | Primary study period: 2016–2025 | 5,570 Brazilian municipalities**

![R](https://img.shields.io/badge/analysis-R-276DC3?logo=r&logoColor=white) ![INLA](https://img.shields.io/badge/Bayesian%20inference-INLA-475569) ![Status](https://img.shields.io/badge/status-manuscript%20revision-informational) ![Data](https://img.shields.io/badge/data-SINAN%20%2B%20IBGE-64748b)

> **Repository status (October 2026):** This public repository currently contains the **original exploratory analysis** and historical input files. The substantially revised **2016–2025 modular analysis pipeline is being prepared for release and is not yet committed here**. The updated scientific overview below describes the revision workflow, **not** code that is already available in this checkout. See [Code availability and reproducibility](#code-availability-and-reproducibility).

## Project overview

Chikungunya has produced large, geographically heterogeneous epidemics across Brazil. This project brings together national SINAN/DATASUS surveillance records, IBGE population estimates, spatial Bayesian models, and clinical-outcome analyses to examine how **reported chikungunya burden, geographic risk, and severe disease differ across populations and over time**.

The revised work asks three connected questions:

1. **Geographic dynamics:** How have municipal patterns of reported chikungunya burden changed between 2016 and 2025, including the expansion from the Northeast toward the Central-West?
2. **Severity and demography:** How closely do geographic patterns of reported disease correspond to hospitalization and mortality, given strong differences in risk by age and other characteristics?
3. **Decision support:** How do alternative municipality-prioritization rules perform when compared with subsequent observed burden, and what do age-specific vaccine eligibility constraints imply for their interpretation?

This is an observational and modeling study of **reported, confirmed cases**. Surveillance incidence should not be read as the true infection rate: reporting, access to care, diagnostic practices, and ascertainment vary across settings.

## Study design at a glance

| Component | Revised analysis |
|---|---|
| Geographic coverage | All **5,570** Brazilian municipalities |
| Main observation window | **January 2016–December 2025** |
| Monthly model panel | **120 months × 5,570 municipalities = 668,400 municipality-months** |
| Case definition | SINAN chikungunya notifications with `CLASSI_FIN %in% c(1, 13)` within the specified date window; not restricted to laboratory confirmation |
| Demographic denominators | Municipality-year population and age structure, prepared from IBGE inputs |
| Primary spatial model | Negative-binomial Bayesian model fitted with **R-INLA** |
| External assessment | Nine one-year-ahead rolling-origin folds (2017–2025); separate, provisional **2026** surveillance validation |

Municipality-months without a confirmed notification are represented as **zero *reported* cases** in the complete model panel. This is a surveillance-data convention, **not evidence of zero infections**.

## Analytical framework

### 1. Descriptive and geographic epidemiology

Annual and weekly incidence summaries, demographic distributions, municipality-level maps, spatial clustering, and regional epidemic timing characterize the observed epidemic history. Wavelet analysis is retained as a supplementary characterization rather than evidence for a long-term multi-year cycle.

### 2. Bayesian spatiotemporal modeling

The revised primary model uses a **negative-binomial likelihood**, a **BYM2 structured/unstructured municipality effect**, a **monthly RW2 temporal component**, and an **unstructured (Type I) municipality-by-month interaction**. Log population enters with an **estimated regression coefficient**, rather than being forced to have an offset coefficient of one.

Sensitivity and diagnostic work includes comparison with Poisson models, pandemic-period exclusions, structured interaction assessments, prior/posterior summaries, and checks for remaining spatial autocorrelation. The full 2016–2025 fit was developed using Cornell's Seneca HPC environment; computational requirements can be substantial.

### 3. Clinical severity and spatial concordance

Kaplan–Meier and Cox analyses assess clinical progression across symptom-onset-to-hospitalization, hospitalization-to-death, and symptom-onset-to-death intervals. Separate analyses estimate population-standardized severe-outcome patterns and examine case–death spatial concordance at the **SUS health-region level**, where mortality counts are more stable.

### 4. Municipality prioritization and vaccine scenarios

The revision compares continuous, municipality-level prioritization approaches based on recent relative incidence and age-weighted severity. Product-specific scenarios distinguish the **18–59-year age group** from **adults aged 60 years and older**, with rankings and communication zones assessed against observed outcomes.

**Important:** The 18–59 and 60+ metrics are **relative burden-prioritization scores**, not calibrated predictions of deaths. Illustrative outcomes-averted-per-dose calculations use explicit assumed vaccine efficacy, coverage, and dose-supply scenarios; they are **not** estimates of causal vaccine effectiveness or observed campaign impact.

### 5. Temporal and external validation

The rolling-origin design trains on data available through each year and evaluates the following year, yielding nine target years (**2017–2025**). Comparisons include simple past-case and demographic baselines. A secondary evaluation considers a longer lead time from a 2016–2022 training period to 2024–2025 outcomes.

Separately, **2026 surveillance is held out of the primary 2016–2025 model** and used for an external assessment of pre-2026 rankings, with explicit attention to the provisional and incomplete nature of the 2026 data. This is validation of ranking concordance with reported outcomes, not a causal evaluation of vaccination.

## Data sources

| Source | Use | Link |
|---|---|---|
| SINAN / DATASUS | Confirmed chikungunya notification records and clinical variables | [DATASUS file transfer](https://datasus.saude.gov.br/transferencia-de-arquivos/) |
| Instituto Brasileiro de Geografia e Estatística (IBGE) | Population estimates and demographic denominators | [IBGE population estimates](https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html) |
| IBGE / `geobr` | Municipality boundaries and health-region geography | [`geobr` project](https://github.com/ipeaGIT/geobr) |
| IBGE 2022 Census | Age and race/ethnicity population composition for relevant analyses | [IBGE Census](https://censo2022.ibge.gov.br/) |

Raw historical chikungunya `.dbc` inputs are present under [`data/chikungunya/`](data/chikungunya/); the archived Zika dataset is under [`data/zika/`](data/zika/). **The revised primary model does not use the old nationally aggregated Zika covariate.** A separate 2026 source, required by the revision validation workflow, is not currently part of this public repository.

## Code availability and reproducibility

### What is publicly available now

```text
Chikungunya-Spatiotemporal-Analysis/
├── README.md
├── Chikungunya Spatioltemporal Analysis.Rmd   # Original exploratory notebook
└── data/
    ├── chikungunya/                          # Historical CHIK .dbc inputs
    └── zika/                                 # Archived Zika input
```

Start with the [historical R Markdown analysis](Chikungunya%20Spatioltemporal%20Analysis.Rmd) if you want to inspect the original workflow. **It is not the final analysis behind the revised methods described above**. This historical notebook contains machine-specific absolute file paths and earlier model and case-definition choices; it should not be treated as a clean-clone, end-to-end reproduction of the current manuscript.

### Revised modular workflow (release in preparation)

The revised analysis has been reorganized into numbered R/R Markdown modules. **The following modules are not yet in the public repository**:

| Stage | Modules | Main purpose |
|---|---|---|
| Data foundation | `00_setup.R`–`02_population_panel.R` | SINAN cleaning, analytic case definition, and annual IBGE population/age denominators |
| Epidemiologic description | `03_descriptive_epi.Rmd`–`05_wavelet_analysis.Rmd` | Burden summaries, geographic-demographic patterns, and epidemic timing |
| Spatiotemporal model | `06_inla_spacetime_model_2016_2025.Rmd` | Full municipal INLA panel, primary fit, diagnostics, sensitivity analyses |
| Clinical and priority analyses | `07_priority_metric_2016_2025.Rmd`–`13_expected_burden_metric_2016_2025.Rmd` | Clinical progression, eligibility, shared spatial components, severity surfaces, and prioritization scores |
| Forecast evaluation | `14_rolling_origin_forecast_2016_2025.Rmd`–`17_secondary_forecast_2016_2022_to_2024_2025.Rmd` | Rolling-origin fitting/scoring, case-definition audit, and longer-horizon evaluation |
| External checks and scenarios | `18_external_validation_2026.Rmd`–`21_race_ethnicity_denominators_IBGE2022.Rmd` | Partial-year 2026 assessment, reporting-completeness sensitivity, dose scenarios, and race-specific denominators |

Most revised modules depend on saved intermediate objects (`.rds`/`.csv`) and several currently reference local input/output directories or HPC-produced model fits. **Those artifacts, an environment lockfile, and independent clean-clone verification have not yet been published here.** Instructions for fully reproducing the revised workflow will be added when the code and required provenance information are deposited.

### Software

The revised analysis is written in **R**, using packages including `INLA`, `sf`, `spdep`, `geobr`, `dplyr`, `ggplot2`, `survival`, `survminer`, `read.dbc`, and `WaveletComp`. The production primary fit was performed using **R 4.6.0** with **INLA 26.8.7** on Seneca HPC, as recorded in the revision notebook. These are reported for provenance, **not** as a claim that the historical notebook has been tested under that environment.

To install INLA from its own package repository:

```r
install.packages(
  "INLA",
  repos = c(getOption("repos"), INLA = "https://inla.r-inla-download.org/R/stable"),
  dependencies = TRUE
)
```

## Interpretation and limitations

- National notification systems capture **reported and classified disease**, not all CHIKV infections; geographic comparisons may reflect heterogeneous ascertainment.
- Temporal validation evaluates **future reported-case burden and ranking performance**, not forecast certainty under all epidemic conditions.
- The **2026 validation is based on partial, provisional surveillance data**, subject to later revision.
- Age-specific prioritization scores and assumed-efficacy dose scenarios must **not** be presented as observed deaths prevented.
- Explicit immunity dynamics, representative serology, mosquito indices, and causal vaccine-impact evaluation are outside the present analyses.

## Manuscript and citation

**Working manuscript:** Zhang Q *et al.* **“Spatial structure and demographic decoupling of chikungunya transmission and severity in Brazil, 2015 to 2025.”** Manuscript in revision. The updated analytical workflow uses **2016–2025** as its primary modeling period; the manuscript title and numerical results are being reconciled as part of that revision.

**Please do not cite a journal publication or DOI until one has been assigned.** For now, reference this GitHub repository and the specific commit or release used. A versioned archive and formal citation information will be added with the finalized manuscript.

## Research team and contact

This project is associated with the **Bento Lab at Cornell University**, with Brazilian research collaborators. For questions, open a [GitHub issue](https://github.com/hemaanizg/Chikungunya-Spatiotemporal-Analysis/issues) or contact the corresponding investigators listed in the manuscript.

---

*Updated October 2026. Documentation reflects a manuscript revision in progress; public code release status is stated separately to avoid implying that uncommitted analyses are available.*
