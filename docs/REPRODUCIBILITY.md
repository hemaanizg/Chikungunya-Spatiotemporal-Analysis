# Reproducing the revised chikungunya analysis

**Documentation status: October 2026.** This guide describes the code now committed to the repository. It is **not a claim that a clean clone runs end-to-end without additional inputs**. The main model and several downstream analyses rely on fitted objects produced on Cornell Seneca HPC or saved in a local R session.

The numbered source files are now together in [`analysis/`](../analysis/). They have **not been split into independent subfolders** because many use `source("00_setup.R")` and exchange objects or relative-path outputs. Work in `analysis/` for interactive runs or R Markdown rendering. Moving the files has not changed the statistical models.

The primary modeling window is **January 2016 through December 2025** (120 months across 5,570 municipalities). The separate 2026 assessment uses held-out, provisional surveillance records.

## 1. Obtain the code

```bash
git clone https://github.com/hemaanizg/Chikungunya-Spatiotemporal-Analysis.git
cd Chikungunya-Spatiotemporal-Analysis
cd analysis   # Required for source("00_setup.R") and relative saved-object paths
```

These R/Rmd modules live in `analysis/`. The older notebook has been moved to [`archive/`](../archive/) for historical reference and **does not replace** the revised modules.

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

**The current scripts have local absolute paths that must be adapted on another machine. After moving the modules, put newly generated `pop_panel_total.rds` and `pop_panel_age.rds` in the `analysis/` working directory, or adjust relevant relative paths. Existing local RDS files outside that directory are **not** automatically moved.** In `00_setup.R`, set:

```r
RAW_DBC_DIR        <- "/your/local/raw-inputs"
IBGE_DOWNLOADS_DIR <- "/your/local/ibge-inputs"
```

The file `01_data_import_cleaning.Rmd` expects `CHIKBR16.dbc` through `CHIKBR25.dbc` inside `file.path(RAW_DBC_DIR, "CHIKdata")`. It also currently loads `CHIKBR26.dbc` in its import chunk to create a **separate** `Chik_2026` object; the 2026 data are *not* appended to `Chik_total`. **The public repository does not currently include `CHIKBR26.dbc`, so running File 01 unchanged will fail unless that file is supplied.**

For reference, historical `CHIKBR15.dbc` through `CHIKBR25.dbc` are already checked into `data/chikungunya/`. The revised File 01 **does not automatically use this location**: either provide the input layout it expects or adapt the paths. The repository layout is unchanged for raw `data/`; it is **not** the same as the default `RAW_DBC_DIR/CHIKdata` specified in the script. Sources: [DATASUS](https://datasus.saude.gov.br/transferencia-de-arquivos/).

`02_population_panel.R` expects ten cleaned IBGE municipality-by-age files named `ibge_pop_age_2016_clean.csv` through `ibge_pop_age_2025_clean.csv` in `IBGE_DOWNLOADS_DIR`. These cleaned inputs are **not included** in this repository. File 02 verifies all 5,570 municipalities for every year and saves `pop_panel_total.rds` and `pop_panel_age.rds` in the current working directory. Source: [IBGE population data](https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html).

The 2022 race/ethnicity module (`21_...`) includes its Census denominators in the code. Read its source notes and quality-control checks before interpreting its rates.

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

See the exact checks at the beginning of Files 06, 13–20 for the authoritative, module-specific list. **Saved fits, prediction tables, and external 2026 data needed for full reproduction have not been committed to this repository.**

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
