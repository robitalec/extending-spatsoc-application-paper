# === Test polarization ---------------------------------------------------



# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)
library(testthat)
library(patchwork)
library(ggdist)


# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')



# Data --------------------------------------------------------------------
n <- 10
DT_test <- data.table(
  x = runif(n, -10, 10),
  y = runif(n, -10, 10),
  id = LETTERS[seq.int(n)],
  az = runif(n, CircStats::rad(0), CircStats::rad(360)),
  group = 1
)

DT_fogo <- fread('../prepare-locs/output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv')


# Test --------------------------------------------------------------------
calc_polarization(DT_test, az = 'az')
print(DT_test)
print(paste0('swaRm::pol_order() = ', swaRm::pol_order(DT_test$az)))
print(paste0('CircStats::r.test() = ', CircStats::r.test(DT_test$az)$r.bar))

DT_test[, az_degree := CircStats::deg(az)]
calc_polarization(DT_test, az = 'az_degree', degree = TRUE)
print(DT_test)
# Note: swaRm::pol_order expects headings in radians
print(paste0('swaRm::pol_order() = ', swaRm::pol_order(DT_test$az_degree)))
print(paste0('CircStats::r.test() = ', CircStats::r.test(DT_test$az_degree, degree = TRUE)$r.bar))



threshold <- 50
DT_fogo[, datetime := as.POSIXct(datetime, tz = 'UTC')]
group_times(DT_fogo, datetime = 'datetime', threshold = '20 minutes')
group_pts(DT_fogo, threshold = threshold, id = 'id',
          coords = c('x_proj', 'y_proj'), timegroup = 'timegroup')
calc_az_sequential(DT_fogo, c('x_long', 'y_lat'), 4326)

calc_polarization(DT_fogo)



# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(CircStats::deg(az))) +
  stat_dotsinterval(binwidth = NA) +
  theme_bw() +
  xlim(0, 360) +
  labs(title = paste0('Polarization: ', format(DT_test[1, polarization], digits = 2)))

print(g)



sel_group <- DT_fogo[, .N, group][N > 6, sample(group, 5)]
sub_fogo <- DT_fogo[group %in% sel_group]
g_fogo <- ggplot(sub_fogo, aes(CircStats::deg(az))) +
  stat_dotsinterval(binwidth = 10, overflow = "keep", dotsize = 1) +
  geom_text(x = 50, y = 0.75,
            aes(label = format(polarization, digits = 2))) +
  theme_bw() +
  facet_grid(group~.)

print(g_fogo)

