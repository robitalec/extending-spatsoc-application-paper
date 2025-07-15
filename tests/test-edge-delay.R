# === Test edge_delay -----------------------------------------------------



# Packages ----------------------------------------------------------------
source('R/packages.R')



# Functions ---------------------------------------------------------------
# edge_delay released in {spatsoc} v0.2.8



# Data --------------------------------------------------------------------
# {spatsoc} example data
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))

# Cast the character column to POSIXct
DT[, datetime := as.POSIXct(datetime, tz = 'UTC')]



# Test --------------------------------------------------------------------
# Test data
DT_A <- data.table(
  X = c(-5, -5, 0, 14, 10, 0),
  Y = c(5, 3, 1, 1, 11, 11),
  ID =  'A'
)[, timegroup := seq.int(.N)]

DT_B <- data.table(
  X = c(-1, -1, 15, 9, 1),
  Y = c(-10, -3, 0, 10,  10),
  ID =  'B'
)[, timegroup := seq.int(.N)]

DT_C <- DT_A[, .(X = rev(X) - 40, Y = rev(Y), ID = 'C', timegroup)]
DT_D <- DT_B[, .(X = rev(X) - 40, Y = rev(Y), ID = 'D', timegroup)]

DT_test  <- rbindlist(list(
  DT_A, DT_B, DT_C, DT_D
))

direction_step(
  DT = DT_test,
  id = 'ID',
  coords = c('X', 'Y'),
  projection = 32736
)

edges_test <- edge_dist(
  DT_test,
  threshold = 20,
  id = 'ID',
  coords = c('X', 'Y'),
  timegroup = 'timegroup',
  returnDist = TRUE,
  fillNA = FALSE
)

dyad_id(edges_test, id1 = 'ID1', id2 = 'ID2')

fusion_id(edges_test, threshold = 20)

delay_test <- edge_delay(
  edges = edges_test,
  DT = DT_test,
  window = 3,
  id = 'ID'
)


# {spatsoc} example data
# Temporal grouping
group_times(DT, datetime = 'datetime', threshold = '20 minutes')

# Calculate direction
direction_step(
  DT = DT,
  id = 'ID',
  coords = c('X', 'Y'),
  projection = 32736
)

# Distance based edge list generation
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

# Directional correlation delay
window <- 2
delay <- edge_delay(
  edges = edges,
  DT = DT,
  window = window,
  id = 'ID'
)

# Print
print(delay[, mean(dir_corr_delay, na.rm = TRUE), by = .(ID1, ID2)][V1 > 0])



# Plot --------------------------------------------------------------------
# Test data
g <- ggplot(DT_test, aes(X, Y, color = ID)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw()

g_delay <- ggplot(delay_test) +
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
