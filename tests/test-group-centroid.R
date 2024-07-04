# === Test group centroid -------------------------------------------------



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(spatsoc)
library(testthat)
library(patchwork)



# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')



# Data --------------------------------------------------------------------
# from ?group_pts
# Read example data
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

# Cast the character column to POSIXct
DT[, datetime := as.POSIXct(datetime, tz = 'UTC')]

# Temporal grouping
group_times(DT, datetime = 'datetime', threshold = '20 minutes')

# Spatial grouping with timegroup
group_pts(DT, threshold = 50, id = 'ID',
          coords = c('X', 'Y'), timegroup = 'timegroup')



# Test --------------------------------------------------------------------
DT_sub_solo <- DT[group %in% DT[, .N, group][N == 1, group]]

xcol <- 'X'
ycol <- 'Y'
group_centroid(DT_sub_solo, xcol, ycol)

calc_dist_to_group_centroid(DT_sub_solo, xcol, ycol)
expect_equal(DT_sub_solo$dist_to_group_centroid, rep(0, nrow(DT_sub_solo)))

calc_dir_to_group_centroid(DT_sub_solo, xcol, ycol)
expect_equal(DT_sub_solo$dir_to_group_centroid, rep(0, nrow(DT_sub_solo)))



DT_sub <- DT[group %in% DT[, .N, group][N > 1, group]]

xcol <- 'X'
ycol <- 'Y'
group_centroid(DT_sub, xcol, ycol)

calc_dist_to_group_centroid(DT_sub, xcol, ycol)

print(hist(DT_sub$dist_to_group_centroid))

calc_dir_to_group_centroid(DT_sub, xcol, ycol)

print(hist(DT_sub$dir_to_group_centroid))




# Plot --------------------------------------------------------------------
