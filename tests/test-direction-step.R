# === Test direction_step -------------------------------------------------

# Packages ----------------------------------------------------------------
source('R/packages.R')


# Functions ---------------------------------------------------------------
# direction_step released in {spatsoc} v0.2.6

# Data --------------------------------------------------------------------
# Example data for East, North, West, South steps
example <- data.table(
  X = c(0, 5, 5, 0, 0),
  Y = c(0, 0, 5, 5, 2.5),
  step = c('E', 'N', 'W', 'S', NA),
  ID = 'A'
)

# {spatsoc} example data
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

# Cast the character column to POSIXct
DT[, datetime := as.POSIXct(datetime, tz = 'UTC')]


# Test --------------------------------------------------------------------
# Set order using data.table::setorder
setorder(DT, datetime)

# Group times (for figure)
group_times(DT, 'datetime', '1 minute')

# Calculate direction for package data
direction_step(
  DT = DT,
  id = 'ID',
  coords = c('X', 'Y'),
  projection = 32736
)
DT[, .(direction, set_units(direction, 'degree'))]

# Calculate direction for ENWS
direction_step(example, 'ID', c('X', 'Y'), projection = 4326)
example[, .(direction, set_units(direction, 'degree'))]


# Plot --------------------------------------------------------------------
# Package data
DT[, diff_tg := timegroup - shift(timegroup, type = 'lag'), by = ID]
DT[, run_eq_1 := rleid(diff_tg == 1), by = ID]
DT[, run_grp := .GRP, .(ID, run_eq_1)]
sub_DT <- DT[
  run_grp == DT[diff_tg == 1][, .N, .(run_grp, ID)][N > 4, sample(run_grp, 1)]
]
g <- ggplot(sub_DT, aes(X, Y, label = round(set_units(direction, 'degree')))) +
  geom_path(arrow = arrow()) +
  geom_point() +
  geom_text(
    nudge_x = 10,
    nudge_y = 3,
    data = sub_DT[timegroup != max(timegroup)]
  ) +
  theme_bw() +
  labs(x = '', y = '') +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed() +
  guides(color = 'none') +
  scale_x_continuous(expand = expansion(add = 10))

print(g)

# Example ENWS
g <- ggplot(example, aes(X, Y, label = round(set_units(direction, 'degree')))) +
  geom_path(arrow = arrow()) +
  geom_point() +
  geom_text(nudge_x = 0.3, nudge_y = 0.3, data = example) +
  theme_bw() +
  labs(x = '', y = '') +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed() +
  guides(color = 'none')

print(g)
