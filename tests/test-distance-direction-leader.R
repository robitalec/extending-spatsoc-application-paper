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

# Print
print(DT[group == DT[, .N, group][N > 3, sample(group, 1)],
         .(ID, timegroup, group, X, Y,
           group_direction, position_group_direction,
           rank_position_group_direction,
           distance_leader, direction_leader)])



# Plot --------------------------------------------------------------------
DT[, N_by_group := .N, group]

sub_DT <- DT[group == DT[N_by_group > 6, sample(group, 1)]]

g_DT <- ggplot(sub_DT, aes(X, Y, color = ID)) +
  geom_spoke(aes(x = centroid_X, y = centroid_Y, angle = drop_units(group_direction),
                 radius = max(position_group_direction)), color = 'grey30',
             arrow = arrow()) +
  geom_spoke(aes(x = centroid_X, y = centroid_Y, angle = drop_units(group_direction),
                 radius = min(position_group_direction)), color = 'grey30') +
  geom_point(color = 'black', aes(centroid_X, centroid_Y)) +
  geom_point(size = 2) +
  geom_label(aes(label = rank_position_group_direction), nudge_y = 2, size = 6) +
  theme_bw() +
  labs(x = '', y = '') +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed() +
  guides(color = 'none') +
  scale_x_continuous(expand = expansion(add = 10))

g_dist <- ggplot(DT, aes(direction_leader, factor(rank_position_group_direction))) +
  stat_halfeye() +
  labs(x = 'Direction to leader', y = 'Rank along group direction') +
  theme_bw()

g_dir <- ggplot(DT, aes(distance_leader, factor(rank_position_group_direction))) +
  stat_halfeye() +
  labs(x = 'Distance to leader', y = 'Rank along group direction') +
  theme_bw()

print(g_DT + (g_dist / g_dir))

