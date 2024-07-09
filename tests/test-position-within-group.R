# === Test position within group ------------------------------------------



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)
library(testthat)
library(patchwork)



# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')



# Data --------------------------------------------------------------------
DT_test <- CJ(
  x = 4,
  y = 7,
  group_mean_x = 2,
  group_mean_y = 1,
  az = CircStats::rad(45),
  group_az = CircStats::rad(45),
  group = c(1, 2)
)[, x := c(4, 5)]

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
theta <- CircStats::rad(45)
origin <- c(2, 1)
xy <- c(4, 7)
mat <- matrix(c(cos(theta), -sin(theta), sin(theta), cos(theta)),
              byrow = TRUE, ncol = 2)

print(mat %*% (xy - origin))
print((mat %*% (xy - origin))[2,1])

print(position_within_group(DT_test, coords = c('x', 'y')))


DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]
group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = 50, id = 'id',
          coords = c('x_proj', 'y_proj'), timegroup = 'timegroup')
group_centroid(DT_fogo, 'x_proj', 'y_proj')
calc_az(DT_fogo, c('x_proj', 'y_proj'), DT_fogo[1, epsg_proj])

position_within_group(DT_fogo, coords = c('x_proj', 'y_proj'))


