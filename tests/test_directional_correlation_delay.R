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

DT_fogo <- fread('../prepare-locs/output/2023-10-12_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
calc_az(DT_test, coords = c('x', 'y'), projection = 4326)
calc_dir_corr_delay(DT_test, window = 3) |> print()


# Test where exaggerated window size
expect_equal(
  calc_dir_corr_delay(DT_test, window = 3),
  calc_dir_corr_delay(DT_test, window = 10)
)

# Even more exaggerated
expect_equal(
  calc_dir_corr_delay(DT_test, window = 3),
  calc_dir_corr_delay(DT_test, window = 100)
)


group_times(DT_fogo, 'datetime', '5 minutes')
calc_az(DT_fogo, coords = c('x_long', 'y_lat'), projection = 4326)
calc_dir_corr_delay(DT_fogo, 2)
# TODO: precursor to this function should be group_pts
# TODO: then !! figure out a run of group function or something
#       it cant be/shouldnt be all data
# TODO: profile

# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
print(g)



