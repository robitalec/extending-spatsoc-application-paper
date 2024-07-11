# === Test polarization ---------------------------------------------------



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
  group = 1
)

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')


# Test --------------------------------------------------------------------
calc_polarization(DT_test)
print(DT_test)
print(paste0('swaRm::pol_order() = ', swaRm::pol_order(DT_test$az)))
print(paste0('CircStats::r.test() = ', CircStats::r.test(DT_test$az)$r.bar))

threshold <- 50
DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]
group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = threshold, id = 'id',
          coords = c('x_proj', 'y_proj'), timegroup = 'timegroup')
calc_az(DT_fogo, c('x_long', 'y_lat'), 4326)

calc_polarization(DT_fogo)

