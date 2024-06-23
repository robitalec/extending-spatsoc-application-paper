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
  x = c(0, 10),
  y = c(0, 20),
  timegroup = c(4, 5),
  id =  'C'
)

DT_test <- rbindlist(list(
  DT_test_A,
  DT_test_A[, .(x, y, timegroup = timegroup - 2, id = 'A')],
  DT_test_A[, .(x, y, timegroup = timegroup - 1, id = 'B')],
  DT_test_A[, .(x, y, timegroup = timegroup + 1, id = 'D')]
))

setorder(DT_test, id)


# Test --------------------------------------------------------------------
calc_dir_corr_delay(DT_test, window  = 1) |>
  print()

cast_az(DT_test)

window <- 3
DT_test[id == 'A' & !is.na(az)][,
        apply(
          dcast(DT_test[timegroup %in% seq.int(-window, window) + .BY[[2]]],
                            timegroup ~ id, value.var = 'az')[, .SD, .SDcols = -c('timegroup')] - az,
              MARGIN = 2, FUN = which.min),
        by = .(id, timegroup)]

# Plot --------------------------------------------------------------------
g <- ggplot(DT_test) +
  geom_path(aes(x, y, color = id, group = id), arrow = arrow()) +
  geom_label(aes(x, y, label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
print(g)



