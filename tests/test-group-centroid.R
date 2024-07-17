# === Test group centroid -------------------------------------------------



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(spatsoc)
library(testthat)
library(patchwork)
library(ggdist)


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

calc_dist_group_centroid(DT_sub_solo, xcol, ycol)
expect_equal(DT_sub_solo$dist_to_group_centroid, rep(0, nrow(DT_sub_solo)))

calc_az_group_centroid(DT_sub_solo, xcol, ycol)
expect_equal(DT_sub_solo$dir_to_group_centroid, rep(NaN, nrow(DT_sub_solo)))



DT_sub <- DT[group %in% DT[, .N, group][N > 1, group]]

xcol <- 'X'
ycol <- 'Y'
group_centroid(DT_sub, xcol, ycol)

calc_dist_group_centroid(DT_sub, xcol, ycol)
calc_dist_group_centroid(DT_sub, xcol, ycol, return_rank = TRUE)
calc_az_group_centroid(DT_sub, xcol, ycol)





# Plot --------------------------------------------------------------------
theme_set(theme_bw())
g1 <- ggplot(DT_sub) +
  geom_histogram(aes(dist_to_group_centroid), binwidth = 1) +
  labs(x = 'Distance to group centroid', y = '')
g2 <- ggplot(DT_sub) +
  geom_histogram(aes(rank_dist_to_group_centroid), binwidth = 1) +
  labs(x = 'Rank distance to group centroid', y = '')
g3 <- ggplot(DT_sub) +
  geom_histogram(aes(dir_to_group_centroid), bins = 30) +
  labs(x = 'Direction to group centroid', y = '')
g4 <- ggplot(DT_sub) +
  stat_halfeye(aes(dist_to_group_centroid, factor(rank_dist_to_group_centroid))) +
  labs(x = 'Distance to group centroid', y = 'Rank distance to group centroid')
print(g1 + g2 + g3 + g4)
