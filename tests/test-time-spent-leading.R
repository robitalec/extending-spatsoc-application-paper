# === Test time spent leading ---------------------------------------------



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

DT_test[, leader := rank_dist_along_group_az == 1, .(timegroup, id)]
DT_test[, time_spent_leading := sum(leader), by = id]
print(DT_test)


threshold <- 50
DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]
group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = threshold, id = 'id',
          coords = c('x_proj', 'y_proj'), timegroup = 'timegroup')
group_centroid(DT_fogo, 'x_proj', 'y_proj')
calc_az(DT_fogo, c('x_long', 'y_lat'), 4326)

position_within_group(DT_fogo, coords = c('x_proj', 'y_proj'),
                      return_rank = TRUE)
print(DT_fogo[group == DT_fogo[, .N, group][N > 3, sample(group, 1)],
              .(id, timegroup, group, x_proj, y_proj, group_mean_x_proj,
                group_az, dist_along_group_az, rank_dist_along_group_az)])
DT_fogo[, N_by_group := .N, group]



# Plot --------------------------------------------------------------------
slope <- DT_test[1, tan(group_az)]
intercept <- DT_test[1, group_mean_y - slope * group_mean_x]
intercept_inv <-  DT_test[1, group_mean_y - (-1/slope) * group_mean_x]
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_abline(slope = slope, intercept = intercept) +
  geom_abline(slope = -1/slope, intercept = intercept_inv, linewidth = 0.3) +
  geom_point() +
  geom_text(aes(label = rank_dist_along_group_az), nudge_y = 0.5) +
  geom_point(color = 'black', aes(group_mean_x, group_mean_y)) +
  theme_bw() +
  lims(x = c(-10, 10), y = c(-10, 10)) +
  coord_fixed() +
  guides(color = 'none')

print(g)


sel_group <- DT_fogo[N_by_group > 6, sample(group, 1)]
sub_fogo <- DT_fogo[group == sel_group]
slope_fogo <- sub_fogo[1, tan(group_az)]
intercept_fogo <- sub_fogo[1, group_mean_y_proj - slope_fogo * group_mean_x_proj]
intercept_inv_fogo <- sub_fogo[1, group_mean_y_proj - (-1/slope_fogo * group_mean_x_proj)]

g_fogo <- ggplot(sub_fogo, aes(x_proj, y_proj, color = id)) +
  geom_point(size = 0.8) +
  geom_text(aes(label = rank_dist_along_group_az), nudge_y = 2) +
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


min_group_sizes <- c(2, 3, 4)
DT_time_leading <- rbindlist(lapply(min_group_sizes, function(min_size) {
  DT_fogo[N_by_group > min_size,
          .(min_group_size = min_size,
            time_spent_leading = sum(rank_dist_along_group_az == 1) / .N),
          by = id]
}))

g_fogo_t_lead <- ggplot(DT_time_leading) +
  geom_point(aes(time_spent_leading, id, color = factor(min_group_size))) +
  labs(x = 'Time spent leading group', y = '',
       color = 'Min group size') +
  xlim(0, 1) +
  theme_bw() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

min_group_sizes <- c(2, 3, 4)
DT_mean_rank <- rbindlist(lapply(min_group_sizes, function(min_size) {
  DT_fogo[N_by_group > min_size,
          .(min_group_size = min_size,
            mean_rank = mean(rank_dist_along_group_az)),
          by = id]
}))

g_fogo_mean_rank <- ggplot(DT_mean_rank) +
  geom_point(aes(mean_rank, id, color = factor(min_group_size))) +
  labs(x = 'Mean rank dist along group axis', y = '',
       color = 'Min group size') +
  scale_x_reverse(limits = c(10, 1)) +
  theme_bw() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())


print(g_fogo + g_fogo_t_lead / g_fogo_mean_rank + plot_layout(guides = 'collect'))
