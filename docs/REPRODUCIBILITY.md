# Reproducing the revised chikungunya analysis

**Documentation status: October 2026.** This guide describes the code now committed to the repository. It is **not a claim that a clean clone runs end-to-end without additional inputs**. The main model and several downstream analyses rely on fitted objects produced on Cornell Seneca HPC or saved in a local R session.

The common configuration `00_setup.R` is at the top of [`analysis/`](../analysis/), and 01–21 have been placed in five thematic subfolders. **The scripts' model formulas and analytic logic are unchanged; only input paths in 00, 01 and 18 were aligned with the checked-in raw and population files.** Keep `analysis/` as your working directory and use `knit_root_dir` when rendering nested R Markdown files; see the [folder index](../analysis/README.md).

The primary modeling window is **January 2016 through December 2025** (120 months across 5,570 municipalities). The separate 2026 assessment uses held-out, provisional surveillance records.

## 1. Obtain the code

```bash
git clone https://github.com/hemaanizg/Chikungunya-Spatiotemporal-Analysis.git
cd Chikungunya-Spatiotemporal-Analysis
cd analysis   # Required for source("00_setup.R") and relative saved-object paths
```

These R/Rmd modules live in thematic subfolders of `analysis/`. The superseded original exploratory notebook was removed from `main` and is recoverable in the [historical backup branch](https://github.com/hemaanizg/Chikungunya-Spatiotemporal-Analysis/tree/backup/pre-code-replacement-2026-10-20); it does **not** replace these modules.

### Running an R Markdown notebook in a subfolder

```r
# From the analysis/ working directory
rmarkdown::render(
  "03_spatiotemporal_models/06_inla_spacetime_model_2016_2025.Rmd",
  knit_root_dir = normalizePath(".")
)
```

Without the explicit root, RStudio's direct Knit action may switch the working directory to the subfolder and make `source("00_setup.R")` fail. `02_population_panel.R` can be run via `source("01_data_and_population/02_population_panel.R")` from the common working directory.

## 2. Set up the R environment

The shared `00_setup.R` loads packages used throughout the original and revised workflow, including `read.dbc`, `dplyr`, `tidyr`, `readr`, `readxl`, `stringr`, `lubridate`, `sf`, `geobr`, `spdep`, `INLA`, `WaveletComp`, `survival`, `survminer`, `ggsurvfit`, `gtsummary`, `UpSetR`, `patchwork`, and visualization helpers.

The primary production fit was run with **R 4.6.0** and **INLA 26.8.7** on Cornell Seneca HPC, as documented in `06_inla_spacetime_model_2016_2025.Rmd`. This is provenance information, not proof of compatibility with every operating system or package version. A frozen `renv.lock` is **not currently included**.

INLA uses its own repository:

```r
install.packages(
  "INLA",
  repos = c(getOption("repos"), INLA = "https://inla.r-inla-download.org/R/stable"),
  dependencies = TRUE
)
```

Install other dependencies as needed, then run `source("00_setup.R")` to identify any missing packages.

## 3. Raw input files and paths

The original CHIK and annual cleaned IBGE files have now been committed into the repository. The updated `analysis/00_setup.R` resolves source locations **relative to the repository root**, with the shared working directory set to `analysis/`:

```r
PROJECT_ROOT <- normalizePath('..', winslash = '/', mustWork = TRUE)
RAW_DBC_DIR <- file.path(PROJECT_ROOT, 'data')
CHIK_DATA_DIR <- file.path(RAW_DBC_DIR, 'chikungunya')
IBGE_DOWNLOADS_DIR <- file.path(RAW_DBC_DIR, 'population')
```

- **CHIK raw data:** `data/chikungunya/CHIKBR15.dbc` through `CHIKBR26.dbc`. File 01 reads 2016–2025 into `Chik_total` and retains `CHIKBR26.dbc` as a separate object for held-out assessment; File 18 uses 2026 separately.
- **Population:** `data/population/ibge_pop_age_2015_clean.csv` through `ibge_pop_age_2025_clean.csv`. File 02 reads **2016–2025 only**, checks coverage/reconciliation, and saves the derived `pop_panel_total.rds` and `pop_panel_age.rds` to the current working directory (normally `analysis/`).
- **2015 data:** Both CHIK 2015 and IBGE 2015 remain in the repository for historical provenance, not as main 2016–2025 model inputs.
- **Data provenance still needed:** cleaned IBGE CSV transformation details, original source tables, and 2026 SINAN extraction/cut-off date must be documented. The presence of source files does not establish full reproducibility or representativeness.

The 2022 race/ethnicity module (`21_...`) includes its Census denominators in the code. Read its source notes and quality-control checks before interpreting rates.

**Important:** Saved model results and forecast outputs remain in external folders such as `~/Downloads/inla_results/`, so the full analysis does not yet run end-to-end from a fresh clone.

## 4. Execution order and expected intermediate objects

| Step | Module(s) | Required state or saved inputs | Purpose |
|---|---|---|---|
| Setup | `00_setup.R` | R packages and user-specific paths | Shared configuration |
| Import | `01_data_import_cleaning.Rmd` | Raw CHIK `.dbc` files (including separately loaded 2026 file) | Creates `Chik_total`, `combined_all` |
| Population | `02_population_panel.R` | Annual cleaned IBGE age files | Saves `pop_panel_total.rds`, `pop_panel_age.rds` |
| Descriptive | `03_...`, `04_...`, `05_...`, `08_...`, `09_...`, `10_...`, `16_...` | Upstream objects in the R session | Epidemiology, geographic/demographic summaries, clinical outcomes, eligibility and definition audit |
| Spatial model | `06_inla_spacetime_model_2016_2025.Rmd` | `Chik_total`, `pop_panel_total`, municipality geometry, saved HPC fit(s) | NB BYM2 + RW2 + Type I interaction; fitted surfaces and diagnostics |
| First priority map | `07_priority_metric_2016_2025.Rmd` | Model-based incidence-rate output | Earlier classification and mapping |
| Health-region analyses | `11_shared_component_model.Rmd`, `12_severity_surface_2016_2025.Rmd` | Case, population and spatial inputs | Case–death shared component and severe-outcome surfaces |
| Continuous burden metrics | `13_expected_burden_metric_2016_2025.Rmd` | `Chik_total`, age/total population panels, saved `st_rate_chik_region_2016_2025.rds` | Transmission-only, severity and age-specific burden scores |
| Rolling-origin refits | `14_rolling_origin_forecast_2016_2025.Rmd` | `Chik_total.rds`, `pop_panel_total.rds`, `muni_sf_2020.rds`, `brazil_muni_2020.adj` | Nine past-only fits for 2017–2025 |
| Forecast scoring | `15_rolling_origin_scoring_2017_2025.Rmd` | Nine prediction CSVs, age panel, observed cases | Next-year capture and baseline comparisons |
| Longer-horizon assessment | `17_secondary_forecast_2016_2022_to_2024_2025.Rmd` | Pre-computed HPC forecast/scoring files | 2016–2022 fit evaluated against 2024–2025 |
| External and scenario analyses | `18_...` to `21_...` | Saved ranking/surface outputs, separate 2026 DBC when relevant | 2026 assessment, completeness sensitivity, assumed-effectiveness scenarios, race denominators |

The numbered files are **analysis stages**, not a command-line pipeline. Some run from independently saved RDS/CSV files; others assume R objects such as `Chik_total` already exist in the **same interactive session**. Rendering each Rmd in a clean session will not automatically transfer those objects to the next notebook.

If File 01 and population assembly were successfully run interactively, you can save an input expected by File 14, for example:

```r
saveRDS(Chik_total, "Chik_total.rds")
```

Only save a correctly constructed, checked analytic object. File 14 also needs the municipality geometry RDS and matching INLA adjacency graph, neither of which is part of the published root-file inventory.

## 5. HPC outputs and result directories

Several notebooks explicitly use:

```text
~/Downloads/inla_results/
```

This is a **local output folder**, not the GitHub `data/` directory. Examples of expected saved products include:

```text
fit_chik_nb_2016_2025.rds
fit_chik_poisson_2016_2025.rds
st_rate_chik_region_2016_2025.rds
priority_rule_evaluation_municipality_2024_2025.csv
rolling_origin/predictions/forecast_annual_predict_2017.csv ... 2025.csv
secondary_forecast_2016_2022/predictions/forecast_secondary_2024_2025.csv
```

See the exact checks at the beginning of Files 06, 13–20 for the authoritative, module-specific list. **Saved fits and prediction tables needed for full reproduction have not all been committed to this repository; the external 2026 DBC input is now versioned under `data/chikungunya/`.**

**File 06:** `params$run_heavy_models` defaults to `false`, and the primary `inla()` call is presently commented out. This notebook is in **saved-fit recovery mode**, not an automated refitting entrypoint. Do not assume that setting `run_heavy_models: true` is sufficient to refit the full model.

**File 17:** This is a *post-HPC scoring and visualization notebook*. Its own header explicitly says it does **not** rerun the longer-horizon INLA fit.

## 6. Interpretation guardrails

- A municipality-month with zero *reported confirmed cases* in the constructed panel is not evidence of zero infections. The code does **not exclude all zero-case municipalities** from the 5,570-municipality panel.
- The revised confirmed case definition uses `CLASSI_FIN %in% c(1, 13)`; it is **not restricted to laboratory-confirmed notifications**.
- The principal spatiotemporal model is negative-binomial, with `log(POP)` estimated rather than imposed as a unit-coefficient offset.
- File 13 defines `Metric_A` (18–59) and `Metric_B` (60+) as **relative ranking scores**, not calibrated death counts.
- File 20 contains **illustrative scenarios** under assumed vaccine effectiveness/coverage/dose constraints. It is not an estimate of observed outcomes prevented.
- File 18 uses **provisional partial-year 2026 surveillance** separately from 2016–2025 modeling. Do not equate an association between rankings and 2026 outcomes with causal vaccine impact.
- The historical Zika notebook remains in this repository; the revised primary INLA model does **not** carry forward the previous national-level Zika covariate.

## 7. What remains before a reproducible release

- [ ] Eliminate machine-specific paths or provide a single configurable project-root setup for all modules.
- [ ] Document/download the ten cleaned IBGE annual population files and the separate 2026 data cut-off date.
- [ ] Version the municipality geometry, INLA graph, and necessary non-sensitive intermediate objects.
- [ ] Release or archive model-fit and scoring outputs where redistribution is permitted; otherwise document regeneration.
- [ ] Record a reproducible R/INLA/package environment (e.g. `renv.lock` and HPC specifications).
- [ ] Perform an independent clean-clone test and reconcile manuscript figures/tables with specific output files.
- [ ] Create a stable release and archive it with a DOI once the code, provenance and analyses are finalized.

For a file-by-file inventory with upload priorities, see [DATA_INVENTORY.md](DATA_INVENTORY.md). For the scientific overview, see the [README](../README.md).
