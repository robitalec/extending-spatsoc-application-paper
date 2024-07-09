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
DT_test <- data.table(
  x = 4,
  y = 7,
  group_mean_x = 2,
  group_mean_y = 1,
  az = CircStats::rad(45),
  group_az = CircStats::rad(45),
  group = 1
)

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')




# Test --------------------------------------------------------------------
group_pts(DT_test, 5, 'id', c('x', 'y'), timegroup = 'timegroup')
calc_az(DT_test, coords = c('x', 'y'), projection = 4326)
group_centroid(DT_test, 'x', 'y', 'group')

DT_test[, group_az := mean(az), by = group]
theta <- DT_test[, first(group_az)]
origin <- c(DT_test[1, group_mean_x], DT_test[1, group_mean_y])
(matrix(c(cos(theta), -sin(theta), sin(theta), cos(theta)), byrow = TRUE, ncol = 2)
  %*% (c(2, 4) - origin)) #+
  # origin
