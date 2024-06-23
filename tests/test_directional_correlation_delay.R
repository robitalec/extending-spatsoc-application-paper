# Packages ----------------------------------------------------------------
library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)
library(spatsoc)


# Functions ---------------------------------------------------------------
targets::tar_source('R/draft')


# Data --------------------------------------------------------------------
DT_test_A <- data.table(
  x = c(0, 10, 20),
  y = c(0, 20, 30),
  timegroup = c(4, 5, 6),
  id =  'C'
)

DT_test <- rbindlist(list(
  DT_test_A,
  DT_test_A[, .(x, y, timegroup = timegroup - 2, id = 'A')],
  DT_test_A[, .(x, y, timegroup = timegroup - 1, id = 'B')],
  DT_test_A[, .(x, y, timegroup = timegroup + 1, id = 'D')]
))

setorder(DT_test, timegroup)


# Test --------------------------------------------------------------------
calc_az(DT_test)
calc_dir_corr_delay(DT_test, window = 3)
DT_test

# TODO: test where exaggerated window still returns same result





# Plot --------------------------------------------------------------------
g <- ggplot(DT_test, aes(x, y)) +
  geom_path(arrow = arrow()) +
  geom_label(aes(label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
print(g)



