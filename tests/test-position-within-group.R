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
n <- 10
DT_test <- data.table(
  x = runif(n, -10, 10),
  y = runif(n, -10, 10),
  id = LETTERS[seq.int(n)],
  az = runif(n, CircStats::rad(0), CircStats::rad(360)),
  group = 1
)

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
theta <- CircStats::rad(45)
origin <- c(2, 1)
xy <- c(4, 7)
mat <- matrix(c(cos(theta), -sin(theta), sin(theta), cos(theta)),
              byrow = TRUE, ncol = 2)

print(mat %*% (xy - origin))
print((mat %*% (xy - origin))[2,1])

group_centroid(DT_test, 'x', 'y')
position_within_group(DT_test, coords = c('x', 'y'))
print(DT_test)



DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]
group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = 50, id = 'id',
          coords = c('x_proj', 'y_proj'), timegroup = 'timegroup')
group_centroid(DT_fogo, 'x_proj', 'y_proj')
calc_az(DT_fogo, c('x_proj', 'y_proj'), DT_fogo[1, epsg_proj])

position_within_group(DT_fogo, coords = c('x_proj', 'y_proj'))


