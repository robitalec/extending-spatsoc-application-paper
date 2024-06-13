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
  x = c(0, -10, 0, 10, 5),
  y = c(0, 10, 20, 10, 5),
  id =  'A'
)
DT_test_A[, datetime := seq.POSIXt(
  as.POSIXct('2022-01-01 10:00:00'),
  as.POSIXct('2022-01-02 10:00:00'),
  length.out = .N),
  by = id
]

group_times(DT_test_A, 'datetime')
DT_test_A[, datetime := NULL]

DT_test <- rbindlist(list(
  DT_test_A,
  DT_test_A[, .(x, y, timegroup = shift(timegroup, 0, type = 'cyclic'), id = 'B')],
  DT_test_A[, .(x, y, timegroup = shift(timegroup, -1, type = 'cyclic'), id = 'C')],
  DT_test_A[, .(x, y, timegroup = shift(timegroup, 1, type = 'cyclic'), id = 'D')],
  DT_test_A[, .(x, y, timegroup = shift(timegroup, 2, type = 'cyclic'), id = 'E')]
), use.names = TRUE)

setorder(DT_test, timegroup)


# Test --------------------------------------------------------------------
calc_dir_corr_delay(DT_test, window  = 1)[ID1 == 'A']



# Plot --------------------------------------------------------------------
g <- ggplot(DT_test) +
  geom_path(aes(x, y, color = id, group = id), arrow = arrow()) +
  geom_label(aes(x, y, label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
print(g)



