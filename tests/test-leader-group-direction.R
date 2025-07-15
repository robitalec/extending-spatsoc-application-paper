# === Test leader_direction_group -----------------------------------------



# Packages ----------------------------------------------------------------
source('R/packages.R')



# Functions ---------------------------------------------------------------
# leader_direction_group released in {spatsoc} v0.2.7



# Data --------------------------------------------------------------------
# {spatsoc} example data
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

# Cast the character column to POSIXct
DT[, datetime := as.POSIXct(datetime, tz = 'UTC')]



# Test --------------------------------------------------------------------
# Set order using data.table::setorder
setorder(DT, datetime)

# Group times
group_times(DT, 'datetime', '1 minute')

# Spatial grouping with timegroup
group_pts(DT, threshold = 50, id = 'ID',
          coords = c('X', 'Y'), timegroup = 'timegroup')

# Calculate direction for package data
direction_step(
  DT = DT,
  id = 'ID',
  coords = c('X', 'Y'),
  projection = 32736
)

# Calculate group centroid
centroid_group(DT, coords = c('X', 'Y'), group = 'group', na.rm = TRUE)

# Calculate group direction
direction_group(DT)

# Calculate leader in terms of position along group direction
leader_direction_group(DT, coords = c('X', 'Y'), return_rank = TRUE)

print(DT[group == DT[, .N, group][N > 3, sample(group, 1)],
         .(ID, timegroup, group, X, Y,
           group_direction, position_group_direction, rank_position_group_direction)])


# Plot --------------------------------------------------------------------
slope <- DT_test[1, tan(group_mean_bearing)]
intercept <- DT_test[1, group_mean_y - slope * group_mean_x]
intercept_inv <-  DT_test[1, group_mean_y - (-1/slope) * group_mean_x]
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_abline(slope = slope, intercept = intercept) +
  geom_abline(slope = -1/slope, intercept = intercept_inv, linewidth = 0.3) +
  geom_point() +
  geom_text(aes(label = rank_dist_along_group_bearing), nudge_y = 0.5) +
  geom_point(color = 'black', aes(group_mean_x, group_mean_y)) +
  theme_bw() +
  lims(x = c(-10, 10), y = c(-10, 10)) +
  coord_fixed() +
  guides(color = 'none')

print(g)


sel_group <- DT_fogo[N_by_group > 6, sample(group, 1)]
sub_fogo <- DT_fogo[group == sel_group]
slope_fogo <- sub_fogo[1, tan(group_mean_bearing)]
intercept_fogo <- sub_fogo[1, group_mean_y_proj - slope_fogo * group_mean_x_proj]
intercept_inv_fogo <- sub_fogo[1, group_mean_y_proj - (-1/slope_fogo * group_mean_x_proj)]

g_fogo <- ggplot(sub_fogo, aes(x_proj, y_proj, color = id)) +
  geom_point(size = 0.8) +
  geom_text(aes(label = rank_dist_along_group_bearing), nudge_y = 2) +
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
            time_spent_leading = sum(rank_dist_along_group_bearing == 1) / .N),
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
            mean_rank = mean(rank_dist_along_group_bearing)),
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
