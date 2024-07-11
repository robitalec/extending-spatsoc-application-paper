# === Test dist dir leader ------------------------------------------------



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)
library(testthat)
library(patchwork)
library(ggdist)


# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')



# Data --------------------------------------------------------------------
n <- 10
DT_test <- data.table(
  x = runif(n, -10, 10),
  y = runif(n, -10, 10),
  id = LETTERS[seq.int(n)],
  az = runif(n, CircStats::rad(0), CircStats::rad(360)),
  timegroup = 1,
  group = 1
)

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
group_centroid(DT_test, 'x', 'y')
position_within_group(DT_test, coords = c('x', 'y'), return_rank = TRUE)
calc_dist_to_leader(DT_test, coords = c('x', 'y'), group = 'group')[]


threshold <- 50
coords <- c('x_proj', 'y_proj')
DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]
group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = threshold, id = 'id',
          coords = coords, timegroup = 'timegroup')
group_centroid(DT_fogo, first(coords), last(coords))
calc_az(DT_fogo, c('x_long', 'y_lat'), 4326)

position_within_group(DT_fogo, coords = coords, return_rank = TRUE)
calc_dist_to_leader(DT_fogo, coords = coords, group = 'group')
print(DT_fogo[group == DT_fogo[, .N, group][N > 3, sample(group, 1)],
              .(id, timegroup, group, x_proj, y_proj, group_mean_x_proj,
                group_az, dist_along_group_az, rank_dist_along_group_az,
                dist_to_leader)])
