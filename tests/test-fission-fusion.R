# === Test fission fusion -------------------------------------------------



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
  x = c(0, 10, 20, 30, 40, 50, 60, 70),
  y = c(20, 1, 1, 15, 1, 15, 15, 15),
  timegroup = seq.int(8),
  id =  'A'
)

DT_test <- rbindlist(list(
  DT_template,
  DT_template[, .(x, y = y * -1, timegroup, id = 'B')],
  DT_template[, .(x, y = y - 5, timegroup, id = 'C')]
))[!(id == 'C' & timegroup == 4)][!(id == 'C' & timegroup %in% c(6, 7))]


DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
setorder(DT_test, timegroup)
group_pts(DT_test, threshold = 5, timegroup = 'timegroup',
          coords = c('x', 'y'), id = 'id')

edges <- edge_dist(DT_test, threshold = 50, id = 'id', timegroup = 'timegroup',
                   coords = c('x', 'y'), returnDist = TRUE)
dyad_id(edges, 'ID1', 'ID2')
fiss_fus <- fission_fusion(edges, threshold = 10,
                           min_run_len = 1, n_max_missing = 1)
print(fiss_fus[dyadID == 'A-C'])

fiss_fus[order(timegroup)]


# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw()
g2 <- ggplot(fiss_fus[!is.na(runID)],
             aes(timegroup,  dyadID, shape = factor(runID), group = runID)) +
  geom_line() +
  geom_point() +
  labs(shape = 'runID') +
  theme_bw()

print(g / g2)



