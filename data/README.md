# Data inventory

| Directory | Files | Role |
|---|---|---|
| [`chikungunya/`](chikungunya/) | `CHIKBR15.dbc` – `CHIKBR26.dbc` (12 files) | SINAN/DATASUS raw CHIK notifications |
| [`population/`](population/) | `ibge_pop_age_2015_clean.csv` – `ibge_pop_age_2025_clean.csv` (11 files) | Cleaned municipality-by-age IBGE population data |
| [`zika/`](zika/) | `zikadata.zip` | Historical Zika archive; not a covariate in the revised primary INLA model |

**Analysis windows:** CHIK 2016–2025 and IBGE population 2016–2025 are inputs to the revised primary model. 2015 files are archived for provenance. `CHIKBR26.dbc` is **separate, provisional 2026 surveillance used only for held-out external validation**, not in the 2016–2025 primary analytic dataset.

**Current code paths (restored after author-confirmed upload):** `analysis/00_setup.R` sets `CHIK_DATA_DIR` to the repository's `data/chikungunya/` and `IBGE_DOWNLOADS_DIR` to `data/population/`. Run scripts with `analysis/` as the R working directory. Files 01, 02 and 18 now use these locations directly. Some separate fitted models and scoring results still load from `~/Downloads/inla_results/`.

**Data provenance:** The original raw data sources are [DATASUS](https://datasus.saude.gov.br/transferencia-de-arquivos/) and [IBGE](https://www.ibge.gov.br/estatisticas/sociais/populacao/9103-estimativas-de-populacao.html). Dates of extraction, detailed population processing provenance, and the **exact 2026 surveillance cut-off date** should still be recorded before archival/publication. No claim of independently verified data consistency is made here.

See the [missing outputs inventory](../docs/DATA_INVENTORY.md) and [reproducibility guide](../docs/REPRODUCIBILITY.md).
