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
  x = c(0, 10, 10, 0, 0),
  y = c(0, 0, 10, 10, 0),
  timegroup = seq.int(5),
  id =  'A'
)

DT_test <- rbindlist(list(
  DT_template,
  DT_template[, .(x = x - 1, y = y - 1, timegroup = timegroup + 1, id = 'B')],
  DT_template[, .(x = x - 3, y = y - 3, timegroup = timegroup + 2, id = 'C')],
  data.table(x = c(20, 20, -20), y = c(-20, -20, -20), timegroup = c(1, 2, 1),
             id = c('C', 'C', 'B'))
))[timegroup > 0]
setorder(DT_test, 'timegroup')

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
edges <- edge_dist(DT_test, threshold = 50, id = 'id', timegroup = 'timegroup',
                   coords = c('x', 'y'), returnDist = TRUE, fillNA = FALSE)
calc_az(DT_test, coords = c('x', 'y'), projection = 4326)
dyad_id(edges, 'ID1', 'ID2')
fiss_fus <- fission_fusion(edges, threshold = 20,
                           min_run_len = 1, n_max_missing = 0)

calc_dir_corr_delay(DT_test, fiss_fus, window = 2)


edge_test <- edge_az(DT_test, NULL, id = 'id', coords = c('x', 'y'),
                     timegroup = 'timegroup', returnDist = TRUE)
calc_dir_corr_delay(edge_test, window = 3) |> print()


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

# Test with Fogo
# group_times(DT_fogo, 'datetime', '5 minutes')
# calc_az(DT_fogo, coords = c('x_long', 'y_lat'), projection = 4326)
# edges <- edge_az(DT_fogo, threshold = NULL, id = 'id', coords = c('x_proj', 'y_proj'),
#                  timegroup = 'timegroup', fillNA = FALSE, returnDist = TRUE)
# calc_dir_corr_delay(edges[distance < 50], 2)

# TODO: test ID1, ID2 are never empty


# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
print(g)



