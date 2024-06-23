# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)
library(testthat)



# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')



# Data --------------------------------------------------------------------
DT_template <- data.table(
  x = c(0, 10),
  y = c(0, 20),
  timegroup = c(4, 5),
  id =  'A'
)

DT_test <- rbindlist(list(
  DT_template,
  DT_template[, .(x, y, timegroup = timegroup + 1, id = 'B')],
  DT_template[, .(x, y, timegroup = timegroup + 2, id = 'C')],
  DT_template[, .(x, y, timegroup = timegroup + 3, id = 'D')]
))



# Test --------------------------------------------------------------------
calc_az(DT_test)
calc_dir_corr_delay(DT_test, window = 3)
DT_test

# TODO: test where exaggerated window still returns same result

expect_equal(
  calc_dir_corr_delay(DT_test, window = 3),
  calc_dir_corr_delay(DT_test, window = 10)
)

expect_equal(
  calc_dir_corr_delay(DT_test, window = 3),
  calc_dir_corr_delay(DT_test, window = 100)
)


# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
print(g)



