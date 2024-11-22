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

coords <- c('X', 'Y')
centroid_group(DT_sub_solo, coords)

distance_to_centroid(DT_sub_solo, coords)
expect_equal(DT_sub_solo$distance_centroid, rep(0, nrow(DT_sub_solo)))

direction_to_centroid(DT_sub_solo, coords)
expect_equal(DT_sub_solo$direction_centroid, rep(NaN, nrow(DT_sub_solo)))



DT_sub <- DT[group %in% DT[, .N, group][N > 1, group]]

centroid_group(DT_sub, coords)

distance_to_centroid(DT_sub, coords)
distance_to_centroid(DT_sub, coords, return_rank = TRUE)
direction_to_centroid(DT_sub, coords)



# Plot --------------------------------------------------------------------
theme_set(theme_bw())

# sub_fogo <- DT_sub[group == DT_sub[, .N, group][N > 4][, sample(group, 1)]]
sub_fogo <- DT_sub[group == 1027]
g_fogo <- ggplot(sub_fogo, aes(X, Y, color = ID)) +
  geom_point(size = 0.8) +
  geom_text(aes(label = paste0(format(distance_centroid, digits = 2),
                               ', ',
                               format(direction_centroid, digits = 2))),
            nudge_y = -1.5) +
  geom_point(color = 'black', aes(centroid_X, centroid_Y)) +
  theme_bw() +
  labs(x = '', y = '') +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed() +
  guides(color = 'none') +
  scale_x_continuous(expand = expansion(add = 10))

print(g_fogo)

g1 <- ggplot(DT_sub) +
  geom_histogram(aes(dist_group_centroid), binwidth = 1) +
  labs(x = 'Distance to group centroid', y = '')
g2 <- ggplot(DT_sub) +
  geom_histogram(aes(rank_dist_group_centroid), binwidth = 1) +
  labs(x = 'Rank distance to group centroid', y = '')
g3 <- ggplot(DT_sub) +
  geom_histogram(aes(bearing_centroid), bins = 30) +
  labs(x = 'Direction to group centroid', y = '')
g4 <- ggplot(DT_sub) +
  stat_halfeye(aes(dist_group_centroid, factor(rank_dist_group_centroid))) +
  labs(x = 'Distance to group centroid', y = 'Rank distance to group centroid')
print(g1 + g2 + g3 + g4)
