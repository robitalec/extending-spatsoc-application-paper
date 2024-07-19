# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)
library(testthat)
library(scico)
library(patchwork)



# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')



# Data --------------------------------------------------------------------
DT_A <- data.table(
  x = c(-5, -5, 0, 14, 10, 0),
  y = c(5, 3, 1, 1, 11, 11),
  id =  'A'
)[, timegroup := seq.int(.N)]

DT_B <- data.table(
  x = c(-1, -1, 15, 9, 1),
  y = c(-10, -3, 0, 10,  10),
  id =  'B'
)[, timegroup := seq.int(.N)]

DT_C <- DT_A[, .(x = rev(x) - 40, y = rev(y), id = 'C', timegroup)]
DT_D <- DT_B[, .(x = rev(x) - 40, y = rev(y), id = 'D', timegroup)]

DT_test  <- rbindlist(list(
  DT_A, DT_B, DT_C, DT_D
))

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')



# Test --------------------------------------------------------------------
setorder(DT_test, timegroup)

threshold <- 20
coords <- c('x', 'y')
id <- 'id'
edges_test <- edge_dist(DT_test, threshold = threshold, id = id,
                        timegroup = 'timegroup', coords = coords,
                        returnDist = TRUE, fillNA = FALSE)
dyad_id(edges_test, 'ID1', 'ID2')
fission_fusion(edges_test, threshold = threshold, n_min_length = 1, n_max_missing = 1)[]

print(edges_test[dyadID == 'A-B'])
print(edges_test[dyadID == 'C-D'])

bearing_sequential(DT_test, id = id, coords = coords, projection = 4326)[]
dir_delay_test <- edge_delay(DT_test, id = id, edges_test, window = 1)


# Test where exaggerated window size
expect_equal(
  edge_delay(DT_test, id, edges_test, window = 3),
  edge_delay(DT_test, id, edges_test, window = 10)
)

# Even more exaggerated
expect_equal(
  edge_delay(DT_test, id, edges_test, window = 3),
  edge_delay(DT_test, id, edges_test, window = 100)
)

# Test with Fogo
threshold <- 50
coords <- c('x_proj', 'y_proj')
id <- 'id'
group_times(DT_fogo, 'datetime', '5 minutes')

edges <- edge_dist(DT_fogo, threshold = threshold,
                   id = id, coords = coords,
                   timegroup = 'timegroup', fillNA = FALSE, returnDist = TRUE)
dyad_id(edges, 'ID1', 'ID2')
fission_fusion(edges, threshold = threshold, n_min_length = 1, n_max_missing = 1)[]

bearing_sequential(DT_fogo, id = id, coords = c('x_long', 'y_lat'), projection = 4326)
dir_delay_fogo <- edge_delay(DT_fogo, id, edges, window = 2)



# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw()

g_delay <- ggplot(dir_delay_test) +
  geom_point(aes(timegroup, interaction(ID1, ID2), color = dir_corr_delay), size = 5) +
  scale_color_scico(midpoint = 0, palette = 'vik', begin = 0.8, end = 0.2) +
  theme_bw()
print(g / g_delay)


sub_fogo <- DT_fogo[id %in% c('FO2016008', 'FO2017007') & timegroup < 50]
g <- ggplot(sub_fogo,
            aes(x_proj, y_proj, color = id)) +
  geom_path() +
  geom_label(aes(label = timegroup),
             data = sub_fogo[timegroup %in% c(min(timegroup), max(timegroup))]) +
  theme_bw()
g2 <- ggplot(dir_delay_fogo[dyadID == 'FO2016008-FO2017007' & timegroup < 50]) +
  geom_point(aes(timegroup, interaction(ID1, ID2), color = dir_corr_delay), size = 5) +
  scale_color_scico(midpoint = 0, palette = 'vik', begin = 0.8, end = 0.2) +
  theme_bw()

print(g / g2)
