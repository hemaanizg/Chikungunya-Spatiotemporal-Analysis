# Shared configuration and packages

# External raw-data locations. Edit these paths for the local machine.
RAW_DBC_DIR        <- "/Users/wuchangpengyuyan/Desktop"
IBGE_DOWNLOADS_DIR <- "/Users/wuchangpengyuyan/Downloads"

# Data import / wrangling
library(read.dbc)
library(dplyr)
library(tidyr)
library(readr)
library(readxl)
library(stringr)
library(lubridate)
library(tibble)

# Plotting
library(ggplot2)
library(scales)
library(viridis)
library(RColorBrewer)
library(patchwork)
library(gridGraphics)
library(cowplot)
library(ggrepel)

# Spatial analysis
library(sf)
library(geobr)
library(spdep)

# Modelling
library(INLA)
library(WaveletComp)
library(survival)
library(survminer)
library(ggsurvfit)
library(broom)
library(gtsummary)

# Other utilities
library(UpSetR)
library(purrr)

# Brazilian macro-region lookup by state code
state_region_lookup <- tibble(
  code_state = sprintf(
    "%02d",
    c(
      11, 12, 13, 14, 15, 16, 17,
      21, 22, 23, 24, 25, 26, 27, 28, 29,
      31, 32, 33, 35,
      41, 42, 43,
      50, 51, 52, 53
    )
  ),
  region = c(
    rep("North", 7),
    rep("Northeast", 9),
    rep("Southeast", 4),
    rep("South", 3),
    rep("Center-West", 4)
  )
)
