# === Test edge az --------------------------------------------------------



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
  id =  'A'
)

DT_test <- rbindlist(list(
  DT_template,
  DT_template[, .(x, y = y * -1, timegroup, id = 'B')],
  DT_template[, .(x, y = y - 5, timegroup, id = 'C')]
))[!(id == 'C' & timegroup %in% c(3, 5, 6))]


DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
setorder(DT_test, timegroup)

calc_az(DT_test, projection = 4326)
edges_test <- edge_az(DT_test, threshold = NULL, id = 'id', timegroup = 'timegroup',
                        coords = c('x', 'y'), returnDist = TRUE, fillNA = TRUE)
dyad_id(edges_test, 'ID1', 'ID2')
# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup))

g2 <- ggplot(edges_test,  aes(timegroup, dyadID, color = diff_az)) +
  geom_point(size = 5) +
  scale_color_viridis_c()

print(g / g2 & theme_bw())
