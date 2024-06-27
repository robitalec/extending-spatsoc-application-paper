# === Test fission fusion -------------------------------------------------



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)
library(testthat)



# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')



# Data --------------------------------------------------------------------
DT_template <- data.table(
  x = c(0, 10, 20, 30, 40, 50),
  y = c(20, 1, 1, 15, 1, 15),
  timegroup = seq.int(6),
  id =  'A'
)

DT_test <- rbindlist(list(
  DT_template,
  DT_template[, .(x, y = y * -1, timegroup, id = 'B')],
  DT_template[, .(x, y = y - 5, timegroup, id = 'C')]
))[!(id == 'C' & timegroup == 4)]


DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------


# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw()
print(g)



