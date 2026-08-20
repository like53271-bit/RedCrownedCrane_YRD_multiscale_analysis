# 01_multiscale_environment_analysis.R
# Active nest vs background comparison using multiscale environmental variables

library(tidyverse)

input_file <- "data/nest_background_environment.csv"
output_dir <- "results"

dir.create(output_dir, showWarnings = FALSE)

dat <- read_csv(input_file)

# Required grouping variable:
# group = nest / background

variables <- setdiff(names(dat), c("sample_id", "group"))

mw_results <- map_dfr(variables, function(v){
  x <- dat %>% select(group, all_of(v)) %>% drop_na()

  test <- wilcox.test(
    x[[v]] ~ x$group,
    exact = FALSE
  )

  tibble(
    variable = v,
    p_value = test$p.value
  )
})

mw_results <- mw_results %>%
  mutate(q_value = p.adjust(p_value, method="BH"))

write_csv(
  mw_results,
  file.path(output_dir, "Sentinel2_environment_statistics.csv")
)
