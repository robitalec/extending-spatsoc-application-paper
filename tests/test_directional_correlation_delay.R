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

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
calc_az(DT_test, coords = c('x', 'y'), projection = 4326)
edge_test <- edge_az(DT_test, NULL, id = 'id', coords = c('x', 'y'),
                     timegroup = 'timegroup', returnDist = TRUE)
calc_dir_corr_delay_from_DT(edge_test, window = 3) |> print()


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
group_times(DT_fogo, 'datetime', '5 minutes')
calc_az(DT_fogo, coords = c('x_long', 'y_lat'), projection = 4326)
edges <- edge_az(DT_fogo, threshold = NULL, id = 'id', coords = c('x_proj', 'y_proj'),
                 timegroup = 'timegroup', fillNA = FALSE, returnDist = TRUE)
calc_dir_corr_delay(edges[distance < 50], 2)

# TODO: test ID1, ID2 are never empty


# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
print(g)



