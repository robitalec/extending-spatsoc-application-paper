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
theta <- CircStats::rad(45)
origin <- c(2, 1)
xy <- c(4, 7)
mat <- matrix(c(cos(theta), -sin(theta), sin(theta), cos(theta)),
              byrow = TRUE, ncol = 2)

print(mat %*% (xy - origin))

print(position_within_group(DT_test, coords = c('x', 'y')))
