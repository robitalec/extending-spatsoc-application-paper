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

# Calculate group direction
direction_group(DT, direction = 'direction', group = 'group')



# Plot --------------------------------------------------------------------
# Centroid for figure
centroid_group(DT, coords = c('X', 'Y'))
sub_DT <- DT[group == DT[, .N, group][N > 4][, sample(group, 1)]]

# Drop units due to bug below
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





# Bug ---------------------------------------------------------------------
# library(ggplot2)
# library(units)
#
# df <- expand.grid(x = 1:10, y=1:10)
#
# set.seed(1)
# df$angle <- runif(100, 0, 2*pi)
# # df$angle <- as_units(runif(100, 0, 2*pi), 'rad')
# df$speed <- runif(100, 0, sqrt(0.1 * df$x))
# # df$speed <- as_units(runif(100, 0, sqrt(0.1 * df$x)), 'cm')
# # df$x <- as_units(df$x, 'cm')
# # df$y <- as_units(df$y, 'cm')
#
# ggplot(df, aes(x, y)) +
#   geom_point() +
#   geom_spoke(aes(angle = angle), radius = 0.5)

