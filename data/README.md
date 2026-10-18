# Historical raw surveillance inputs

- `chikungunya/CHIKBR15.dbc` through `CHIKBR25.dbc` are currently included in this public repository.
- `zika/zikadata.zip` is a retained historical archive; the revised primary INLA analysis does **not** include national Zika as a covariate.
- A `CHIKBR26.dbc` file is **not** currently included. It is referenced only as held-out/provisional 2026 surveillance in the revised pipeline.

**Important path note:** the analysis currently reads raw CHIK files from `file.path(RAW_DBC_DIR, "CHIKdata", ...)`, not directly from this folder. To run on a new machine, change the path configuration or provide the directory layout the scripts expect.

The provenance of cleaned annual IBGE municipality-age CSVs has not yet been deposited. See [DATA_INVENTORY.md](../docs/DATA_INVENTORY.md).
