# 03_RF_exploratory_analysis.R
# Exploratory Random Forest analysis

library(tidyverse)
library(ranger)
library(pROC)

set.seed(2026)

input_file <- "data/RF_predictor_matrix.csv"
output_dir <- "results"

dir.create(output_dir, showWarnings = FALSE)

dat <- read_csv(input_file)

# response: 1 active nest, 0 background

predictors <- setdiff(names(dat), c("sample_id", "response"))

model <- ranger(
  response ~ .,
  data = dat %>% select(response, all_of(predictors)),
  importance = "permutation",
  num.trees = 500
)

importance <- tibble(
  variable = names(model$variable.importance),
  importance = as.numeric(model$variable.importance)
)

write_csv(
  importance,
  file.path(output_dir, "RF_permutation_importance.csv")
)
