# === Test distance_to_leader, direction_to_leader ------------------------



# Packages ----------------------------------------------------------------
source('R/packages.R')



# Functions ---------------------------------------------------------------
# distance_to_leader released in {spatsoc} v0.2.7
# direction_to_leader released in {spatsoc} v0.2.7



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

# Calculate direction to leader
direction_to_leader(DT, coords = c('X', 'Y'))

# Calculate distance to leader
distance_to_leader(DT, coords = c('X', 'Y'))


# Test --------------------------------------------------------------------
coords <- c('x', 'y')
group_centroid(DT_test, coords = coords)
group_bearing(DT_test, bearing = 'bearing', group = 'group')
group_leader(DT_test, coords = coords, return_rank = TRUE)
distance_to_leader(DT_test, coords = coords, group = 'group')
bearing_to_leader(DT_test, coords = coords, group = 'group')[]


threshold <- 50
id <- 'id'
coords <- c('x_proj', 'y_proj')
DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]

group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = threshold, id = id,
          coords = coords, timegroup = 'timegroup')
group_centroid(DT_fogo, coords = coords)
bearing_sequential(DT_fogo, id = id, coords = c('x_long', 'y_lat'), projection = 4326)
group_bearing(DT_fogo)
group_leader(DT_fogo, coords = coords, return_rank = TRUE)
distance_to_leader(DT_fogo, coords = coords, group = 'group')
bearing_to_leader(DT_fogo, coords = coords, group = 'group')
print(DT_fogo[group == DT_fogo[, .N, group][N > 3, sample(group, 1)],
              .(id, timegroup, group, x_proj, y_proj, group_mean_x_proj,
                group_bearing, dist_along_group_bearing, rank_dist_along_group_bearing,
                dist_leader, bearing_leader)])



# Plot --------------------------------------------------------------------
slope <- DT_test[1, tan(group_bearing)]
intercept <- DT_test[1, group_mean_y - slope * group_mean_x]
intercept_inv <-  DT_test[1, group_mean_y - (-1/slope) * group_mean_x]
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_abline(slope = slope, intercept = intercept) +
  geom_abline(slope = -1/slope, intercept = intercept_inv, linewidth = 0.3) +
  geom_point() +
  geom_text(aes(label = rank_dist_along_group_bearing), nudge_y = 0.5) +
  geom_text(aes(label = paste0(format(dist_leader, digits = 2),
                               ', ',
                               format(bearing_leader, digits = 2),
                               ' rad')), nudge_y = -0.5) +
  geom_point(color = 'black', aes(group_mean_x, group_mean_y)) +
  theme_bw() +
  coord_fixed() +
  guides(color = 'none')

print(g)


sel_group <- DT_fogo[N_by_group > 6, sample(group, 1)]
sub_fogo <- DT_fogo[group == sel_group]
slope_fogo <- sub_fogo[1, tan(group_bearing)]
intercept_fogo <- sub_fogo[1, group_mean_y_proj - slope_fogo * group_mean_x_proj]
intercept_inv_fogo <- sub_fogo[1, group_mean_y_proj - (-1/slope_fogo * group_mean_x_proj)]

g_fogo <- ggplot(sub_fogo, aes(x_proj, y_proj, color = id)) +
  geom_point(size = 0.8) +
  geom_text(aes(label = rank_dist_along_group_bearing), nudge_y = 1.5) +
  geom_text(aes(label = paste0(format(dist_leader, digits = 2),
                               ', ',
                               format(bearing_leader, digits = 2),
                               ' rad')), nudge_y = -1.5) +
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

g_dist <- ggplot(DT_fogo, aes(dist_leader, factor(rank_dist_along_group_bearing))) +
  stat_halfeye() +
  labs(x = 'Direction to leader', y = 'Rank along group az') +
  theme_bw()

g_dir <- ggplot(DT_fogo, aes(bearing_leader, factor(rank_dist_along_group_bearing))) +
  stat_halfeye() +
  labs(x = 'Distance to leader', y = 'Rank along group az') +
  theme_bw()

print(g_fogo / (g_dist + g_dir))

