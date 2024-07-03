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
  x = seq(10, 80, by = 10),
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

edges_test <- edge_dist(DT_test, threshold = 50, id = 'id', timegroup = 'timegroup',
                   coords = c('x', 'y'), returnDist = TRUE)
dyad_id(edges_test, 'ID1', 'ID2')
f_min0_miss0_splitF <- fission_fusion(
  copy(edges_test), threshold = 10, n_min_length = 0, n_max_missing = 0, allow_split = FALSE)
f_min1_miss1_splitT <- fission_fusion(
  copy(edges_test), threshold = 10, n_min_length = 1, n_max_missing = 1, allow_split = TRUE)
f_min0_miss_1_splitF <- fission_fusion(
  copy(edges_test), threshold = 10, n_min_length = 0, n_max_missing = 1, allow_split = FALSE)

print(f_min0_miss0_splitF[dyadID == 'A-B'])


group_times(DT_fogo, 'datetime', '10 minutes')
setorder(DT_fogo, timegroup)
edges_fogo <- edge_dist(DT_fogo, threshold = 50, id = 'id', timegroup = 'timegroup',
                   coords = c('x_proj', 'y_proj'), returnDist = TRUE, fillNA = FALSE)
dyad_id(edges_fogo, 'ID1', 'ID2')
fission_fusion(edges_fogo, threshold = 50, n_min_length = 1, n_max_missing = 1)

print(edges_fogo[dyadID == 'FO2016008-FO2017007'])



# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup))

g2.1 <- ggplot(f_min0_miss0_splitF[!is.na(fusionID)],
               aes(timegroup,  dyadID, shape = factor(fusionID), group = fusionID)) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = 'Minimum obs: 0, maximum missing: 0, allow split: FALSE')
g2.2 <- ggplot(f_min1_miss1_splitT[!is.na(fusionID)],
             aes(timegroup,  dyadID, shape = factor(fusionID), group = fusionID)) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = 'Minimum obs: 1, maximum missing: 1, allow split: TRUE')
g2.3 <- ggplot(f_min0_miss_1_splitF[!is.na(fusionID)],
               aes(timegroup,  dyadID, shape = factor(fusionID), group = fusionID)) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = 'Minimum obs: 0, maximum missing: 1, allow split: FALSE')

g / (g2.1 / g2.2 / g2.3 *
       xlim(edges_test[, min(timegroup)], edges_test[, max(timegroup)]) *
       guides(shape = 'none')) &
       labs(shape = 'fusionID') &
        theme_bw()

max_tg <- 50
sub_fogo <- DT_fogo[id %in% c('FO2016008', 'FO2017007') & timegroup < max_tg]
g <- ggplot(sub_fogo,
            aes(x_proj, y_proj, color = id)) +
  geom_path() +
  geom_label(aes(label = timegroup),
            data = sub_fogo[timegroup %in% c(min(timegroup), max(timegroup))]) +
  theme_bw()
sub_edges <- edges_fogo[ID1 %in% c('FO2016008', 'FO2017007') &
                     ID2 %in% c('FO2016008', 'FO2017007') &
                     timegroup < max_tg]
g2 <- ggplot(sub_edges,
             aes(timegroup,  dyadID, shape = factor(fusionID), group = fusionID)) +
  geom_line() +
  geom_point(size = 3) +
  labs(shape = 'fusionID') +
  theme_bw() +
  xlim(sub_edges[, min(timegroup)], max_tg)

print(g / g2)
