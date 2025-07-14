# === Test direction_polarization -----------------------------------------



# Packages ----------------------------------------------------------------
source('R/packages.R')



# Functions ---------------------------------------------------------------
# direction_polarization released in {spatsoc} v0.2.6



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

# Calculate direction_polarization
direction_polarization(DT, direction = 'direction', group = 'group')



# Plot --------------------------------------------------------------------
# For figure
DT[, N_by_group := .N, by = group]
direction_group(DT, direction = 'direction', group = 'group')

# See bug below
DT[, direction := drop_units(direction)]

sub_DT <- DT[N_by_group > 4][group == sample(group, 1)]
g <- ggplot(sub_DT) +
  geom_spoke(arrow = arrow(),
             aes(x = X, y = Y, angle = direction, radius = 10,
                 color = ID)) +
  guides(color = 'none') +
  coord_fixed() +
  labs(x = '', y = '')  +
  theme_bw() +
  theme(axis.text = element_blank(), axis.ticks = element_blank())

g2 <- ggplot(sub_DT, aes(x = direction)) +
  stat_dots(binwidth = 0.3, overflow = 'compress') +
  theme_bw() +
  xlim(-pi, pi) +
  labs(title = paste0('Polarization = ', format(sub_DT[, polarization], digits = 2)),
       x = 'direction', y = '') +
  theme_bw() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

print(g + g2)