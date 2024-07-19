# === Test position within group ------------------------------------------



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
theta <- CircStats::rad(45)
origin <- c(2, 1)
xy <- c(4, 7)
mat <- matrix(c(cos(theta), sin(theta), -sin(theta), cos(theta)),
              byrow = TRUE, ncol = 2)
# matrix(c('cos(theta)',  'sin(theta)', '-sin(theta)', 'cos(theta)'),
#        byrow = TRUE, ncol = 2)
print(mat %*% (xy - origin))
print((mat %*% (xy - origin))[1,1])

coords <- c('x', 'y')
group_centroid(DT_test, coords)
calc_dist_group_az(DT_test, coords = coords, return_rank = TRUE)
print(DT_test)


threshold <- 50
coords <- c('x_proj', 'y_proj')
id <- 'id'

DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]
group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = threshold, id = id,
          coords = coords, timegroup = 'timegroup')
group_centroid(DT_fogo, coords)
bearing_sequential(DT_fogo, id, coords, 4326)

calc_dist_group_az(DT_fogo, coords = coords, return_rank = TRUE)
print(DT_fogo[group == DT_fogo[, .N, group][N > 3, sample(group, 1)],
              .(id, timegroup, group, x_proj, y_proj, group_mean_x_proj,
                group_az, dist_along_group_az, rank_dist_along_group_az)])


# Plot --------------------------------------------------------------------
slope <- DT_test[1, tan(group_az)]
intercept <- DT_test[1, group_mean_y - slope * group_mean_x]
intercept_inv <-  DT_test[1, group_mean_y - (-1/slope) * group_mean_x]
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_abline(slope = slope, intercept = intercept) +
  geom_abline(slope = -1/slope, intercept = intercept_inv, linewidth = 0.3) +
  geom_point() +
  geom_text(aes(label = paste0(format(dist_along_group_az, digits = 1),
                              ' (', rank_dist_along_group_az, ')')),
            nudge_y = 0.4) +
  geom_point(color = 'black', aes(group_mean_x, group_mean_y)) +
  theme_bw() +
  lims(x = c(-10, 10), y = c(-10, 10)) +
  coord_fixed()

print(g)


sel_group <- DT_fogo[, .N, group][N > 6, sample(group, 1)]
sub_fogo <- DT_fogo[group == sel_group]
slope_fogo <- sub_fogo[1, tan(group_az)]
intercept_fogo <- sub_fogo[1, group_mean_y_proj - slope_fogo * group_mean_x_proj]
intercept_inv_fogo <- sub_fogo[1, group_mean_y_proj - (-1/slope_fogo * group_mean_x_proj)]

g_fogo <- ggplot(sub_fogo, aes(x_proj, y_proj, color = id)) +
  geom_point(size = 0.8) +
  geom_text(aes(label = paste0(format(dist_along_group_az, digits = 1),
                               ' (', rank_dist_along_group_az, ')')),
                nudge_y = 2) +
  geom_point(color = 'black', aes(group_mean_x_proj, group_mean_y_proj)) +
  geom_abline(slope = slope_fogo, intercept = intercept_fogo) +
  geom_abline(slope = -1/slope_fogo, intercept = intercept_inv_fogo,
              linewidth = 0.2) +
  theme_bw() +
  labs(x = '', y = '') +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed() +
  guides(color = 'none') +
  scale_x_continuous(expand = expansion(add = 10))

DT_fogo[, N_by_group := .N, group]
g_fogo_hist <- ggplot(DT_fogo[N_by_group > 1]) +
  geom_histogram(aes(dist_along_group_az), binwidth = 1) +
  labs(x = 'Distance along group az', y = '') +
  theme_bw()

g_fogo_hist2 <- ggplot(DT_fogo[N_by_group > 1]) +
  geom_histogram(aes(rank_dist_along_group_az), binwidth = 1) +
  labs(x = 'Rank distance along group az', y = '') +
  theme_bw()

g_fogo_dist <- ggplot(DT_fogo[N_by_group > 1]) +
  stat_halfeye(aes(dist_along_group_az, factor(rank_dist_along_group_az))) +
  labs(x = 'Distance along group az', y = 'Rank distance along group az') +
  theme_bw()

print(g_fogo_dist + ((g_fogo_hist / g_fogo_hist2) / g_fogo))
