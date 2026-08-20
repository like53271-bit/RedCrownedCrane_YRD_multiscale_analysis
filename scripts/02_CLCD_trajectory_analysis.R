# 02_CLCD_trajectory_analysis.R
# CLCD annual land-cover trajectory analysis

library(tidyverse)
library(broom)

input_file <- "data/CLCD_annual_metrics.csv"
output_dir <- "results"

dir.create(output_dir, showWarnings = FALSE)

dat <- read_csv(input_file)

# Expected columns:
# sample_id, group, year, variable, value

trajectory <- dat %>%
  group_by(sample_id, group, variable) %>%
  do({
    model <- lm(value ~ year, data = .)
    tidy(model)
  }) %>%
  filter(term == "year") %>%
  rename(slope = estimate)

write_csv(
  trajectory,
  file.path(output_dir, "CLCD_trajectory_metrics.csv")
)
