# === Test centroid fusion -------------------------------------------------



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(spatsoc)
library(testthat)
library(patchwork)
library(ggdist)
library(units)



# Functions ---------------------------------------------------------------
# centroid_fusion released in {spatsoc} v0.2.5
# direction_to_centroid released in {spatsoc} v0.2.6
# distance_to_centroid released in {spatsoc} v0.2.6



# Data --------------------------------------------------------------------
# Read example data
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

# Cast the character column to POSIXct
DT[, datetime := as.POSIXct(datetime, tz = 'UTC')]

# Temporal fusioning
group_times(DT, datetime = 'datetime', threshold = '20 minutes')

# Edge list generation
edges <- edge_dist(
  DT,
  threshold = 100,
  id = 'ID',
  coords = c('X', 'Y'),
  timegroup = 'timegroup',
  returnDist = TRUE,
  fillNA = FALSE
)

# Generate dyad id
dyad_id(edges, id1 = 'ID1', id2 = 'ID2')

# Generate fusion id
fusion_id(edges, threshold = 100)



# Test --------------------------------------------------------------------
centroids <- centroid_fusion(
  edges,
  DT,
  id = 'ID',
  coords = c('X', 'Y'),
  timegroup = 'timegroup', na.rm = TRUE
)



# Plot --------------------------------------------------------------------
theme_set(theme_bw())

sub_fusionID <- centroids[, .N, fusionID][N > 9, sample(fusionID, 1)]
sub_centroid <- centroids[fusionID == sub_fusionID]
sub_DT <- DT[timegroup %in% sub_centroid[, timegroup] &
               ID %in% sub_centroid[, c(ID1, ID2)]]
g_DT <- ggplot() +
  geom_path(data = sub_centroid, aes(centroid_X, centroid_Y),
            linewidth = 0.3) +
  geom_point(data = sub_DT, aes(X, Y, color = ID), size = 2) +
  geom_point(data = sub_centroid, aes(centroid_X, centroid_Y),
             color = 'black', size = 2) +
  theme_bw() +
  labs(x = '', y = '') +
  theme(axis.text = element_blank(), axis.ticks = element_blank()) +
  coord_fixed() +
  guides(color = 'none') +
  scale_x_continuous(expand = expansion(add = 10))

print(g_DT)
