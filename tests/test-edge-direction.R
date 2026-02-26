# === Test edge direction --------------------------------------------------

# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)
library(testthat)
library(patchwork)


# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')


# Data --------------------------------------------------------------------
DT_template <- data.table(
  x = seq(10, 80, by = 10),
  y = c(20, 1, 1, 15, 1, 15, 15, 15),
  timegroup = seq.int(8),
  id = 'A'
)

DT_test <- rbindlist(list(
  DT_template,
  DT_template[, .(x, y = y * -1, timegroup, id = 'B')],
  DT_template[, .(x, y = y - 5, timegroup, id = 'C')]
))[!(id == 'C' & timegroup %in% c(3, 5, 6))]


DT_fogo <- fread(
  '../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv'
)


# Test --------------------------------------------------------------------
setorder(DT_test, timegroup)
coords <- c('x', 'y')
id <- 'id'
direction_step(DT_test, id = id, coords = coords, projection = 4326)
edges_test <- edge_direction(
  DT_test,
  threshold = NULL,
  id = id,
  timegroup = 'timegroup',
  coords = coords,
  returnDist = TRUE,
  fillNA = TRUE
)
dyad_id(edges_test, 'ID1', 'ID2')


coords <- c('x_proj', 'y_proj')
id <- 'id'

group_times(DT_fogo, 'datetime', '10 minutes')
setorder(DT_fogo, timegroup)
direction_step(
  DT_fogo,
  id = id,
  coords = c('x_long', 'y_lat'),
  projection = 4326
)
edges_fogo <- edge_direction(
  DT_fogo,
  threshold = NULL,
  id = id,
  timegroup = 'timegroup',
  coords = coords,
  returnDist = TRUE,
  fillNA = TRUE
)
dyad_id(edges_fogo, 'ID1', 'ID2')


# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(
    aes(label = timegroup),
    data = DT_test[timegroup == min(timegroup)]
  )

g2 <- ggplot(edges_test, aes(timegroup, dyadID, color = diff_bearing)) +
  geom_point(size = 5) +
  scale_color_viridis_c()

print(g / g2 & theme_bw())


group_pts(
  DT_fogo,
  threshold = 50,
  id = 'id',
  coords = c('x_proj', 'y_proj'),
  timegroup = 'timegroup'
)
DT_fogo[, N_by_group := .N, group]
sel_group <- DT_fogo[N_by_group == 4, sample(group, 1)]
sub_fogo <- DT_fogo[
  id %in%
    DT_fogo[group == sel_group, id] &
    between(
      timegroup,
      DT_fogo[group == sel_group, first(timegroup) - 1],
      DT_fogo[group == sel_group, first(timegroup) + 2]
    )
]
g_fogo <- ggplot(sub_fogo, aes(x_proj, y_proj, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(
    aes(label = timegroup),
    data = sub_fogo[timegroup == min(timegroup)]
  ) +
  guides(color = 'none') +
  labs(x = 'x', y = '')

sub_edges <- edges_fogo[
  (ID1 %in%
    DT_fogo[group == sel_group, id] &
    ID2 %in% DT_fogo[group == sel_group, id]) &
    between(
      timegroup,
      DT_fogo[group == sel_group, first(timegroup) - 1],
      DT_fogo[group == sel_group, first(timegroup) + 2]
    )
]
g2_fogo <- ggplot(
  sub_edges,
  aes(factor(timegroup), dyadID, color = diff_bearing)
) +
  geom_point(size = 5) +
  scale_color_viridis_c() +
  labs(x = 'Timegroup', y = '')

print(g_fogo / g2_fogo & theme_bw())
