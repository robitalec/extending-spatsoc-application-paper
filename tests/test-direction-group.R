# === Test direction_group ------------------------------------------------



# Packages ----------------------------------------------------------------
source('R/packages.R')



# Functions ---------------------------------------------------------------
# direction_group released in {spatsoc} v0.2.6



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
DT[, .(direction, set_units(direction, 'degree'))]

# Calculation group direction
direction_group(DT, direction = 'direction', group = 'group')



# Plot --------------------------------------------------------------------
# Package data
centroid_group(DT, coords = c('X', 'Y'))
sub_DT <- DT[group == DT[, .N, group][N > 4][, sample(group, 1)]]
sub_DT[, direction := drop_units(direction)]
sub_DT[, group_direction := drop_units(group_direction)]
g <- ggplot(sub_DT) +
  geom_spoke(arrow = arrow(),
             aes(x = X, y = Y, angle = direction, radius = 10,
                 color = ID)) +
  geom_spoke(aes(centroid_X, centroid_Y, angle = group_direction, radius = 15),
             arrow = arrow(), size = 2) +
  theme_bw() +
  labs(x = '', y = '') +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed() +
  guides(color = 'none') +
  scale_x_continuous(expand = expansion(add = 10))

print(g)

