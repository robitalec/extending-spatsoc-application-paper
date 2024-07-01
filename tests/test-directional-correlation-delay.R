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
DT_A <- data.table(
  x = c(-5, -5, 0, 10, 10, 0),
  y = c(5, 1, 1, 1, 11, 11),
  id =  'A'
)[, timegroup := seq.int(.N)]

DT_B <- data.table(
  x = c(-1, -1, 9, 9, 1),
  y = c(-10, 0, 0, 10,  10),
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

threshold <- 15
edges_test <- edge_dist(DT_test, threshold = threshold, id = 'id',
                        timegroup = 'timegroup', coords = c('x', 'y'),
                        returnDist = TRUE, fillNA = FALSE)
dyad_id(edges_test, 'ID1', 'ID2')
fission_fusion(edges_test, threshold = threshold, n_min_length = 1, n_max_missing = 1)[]

print(edges_test[dyadID == 'A-B'])

calc_az(DT_test, coords = c('x', 'y'), projection = 4326)[]
dir_delay_test <- calc_dir_corr_delay(DT_test, edges_test, window = 1)[]



# Test where exaggerated window size
expect_equal(
  calc_dir_corr_delay(DT_test, window = 3),
  calc_dir_corr_delay(DT_test, window = 10)
)

# Even more exaggerated
expect_equal(
  calc_dir_corr_delay(DT_test, window = 3),
  calc_dir_corr_delay(DT_test, window = 100)
)

# Test with Fogo
threshold <- 50
group_times(DT_fogo, 'datetime', '5 minutes')

edges <- edge_dist(DT_fogo, threshold = threshold,
                   id = 'id', coords = c('x_proj', 'y_proj'),
                   timegroup = 'timegroup', fillNA = FALSE, returnDist = TRUE)
dyad_id(edges, 'ID1', 'ID2')
fission_fusion(edges, threshold = threshold, n_min_length = 1, n_max_missing = 1)[]

calc_az(DT_fogo, coords = c('x_long', 'y_lat'), projection = 4326)
dir_corr_delay <- calc_dir_corr_delay(DT_fogo, edges, window = 2)



# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y, color = id)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw()
print(g)
