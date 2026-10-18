# Revised analysis modules (2016–2025)

This folder holds the **22 numbered R and R Markdown source files**, 00–21, for the revised chikungunya analysis. The statistical code has been **moved without editing model specifications, formulas, filters or calculations**.

### Working directory matters

Most modules use `source("00_setup.R")`; some read or write files via relative paths such as `pop_panel_total.rds`. **Set the R working directory to this folder** before interactive execution, or open and knit an Rmd in place:

```r
setwd("/path/to/Chikungunya-Spatiotemporal-Analysis/analysis")
source("00_setup.R")
```

Configure `RAW_DBC_DIR` and `IBGE_DOWNLOADS_DIR` in `00_setup.R` for your machine. Raw historic CHIK files are in `../data/chikungunya/`, **not** automatically under the `RAW_DBC_DIR/CHIKdata` location used by File 01. Running notebooks individually in isolated R sessions will not preserve required in-memory objects.

Some notebooks need saved INLA objects at `~/Downloads/inla_results/`, and File 20 currently expects `~/pop_panel_age.rds`. A directory move **does not change** these external paths; if your existing RDS inputs live elsewhere, copy them to the expected location or deliberately reconfigure the code.

Read [full reproduction requirements](../docs/REPRODUCIBILITY.md) and [the missing-file checklist](../docs/DATA_INVENTORY.md). The original single-file exploratory notebook is under [archive](../archive/).
