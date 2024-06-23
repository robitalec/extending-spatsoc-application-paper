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
calc_dir_corr_delay(DT_test, window  = 1)# |>
#   print()
#
# DT_test[, .BY, ]
#
# DT_test[DT_test[!id %in% .SD[, unique(id)],
#                 .(timegroup_r = timegroup, id_r = id, az_r = az)],
#         .(az - az_r, id),
#         on = 'timegroup',
#         by = .EACHI]
# find a solution to taking a matrix of az in a window
# and returning pairwise which min diff
# then map over timegroup

# by = .EACHI

DT_test[, by = .EACHI]

calc_delay <- function(DT) {
  m <- cast_az(DT)
  combs <- CJ(ID1 = seq.int(ncol(m)), ID2 = seq.int(ncol(m)))[ID1 != ID2]
  combs[, .(delay =
              which.min(
                # focal timegroup observation for column V1
                m[median(seq.int(nrow(m))), V1] -
                  # moving window observation for column V2
                  m[,V2])),
        by = .(V1, V2)]
}

DT_test[, calc_delay(.SD), by = timegroup, .SDcols = colnames(DT_test)]


m
combs[, .(m[median(seq.int(nrow(m))), V1], m[,V2]),
      by = .(V1, V2)]

cast_az(DT_test) |>
  filter(filter = 1)

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



