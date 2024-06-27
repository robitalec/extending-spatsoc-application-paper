# because we don't anticipate a user wants to calculate this metric
#  for all rows, consider the precursor steps
# group_times for temporal grouping
# edge_dist for distance between individuals, with some threshold
# return distance = true to allow comparing the distance to the resulting metric

# what about edge_az following edge_dist with a threshold but
#  computes the az difference in radians (with 2pi check) and also returns dist
# that could be passed to calc dir corr delay and directly
calc_dir_corr_delay <- function(DT, fusion, window) {
  setorder(DT, timegroup)

  fusion[, ID1 := tstrsplit(dyadID, '-', keep = 1)]

  id_tg <- fusion[, .(ID1 = unique(ID1)),
              by = .(tg = timegroup)]

  id_tg[, {
    DT[between(timegroup, tg - window, tg + window) & id != .BY$ID1][,
                                                                     # TODO: caution if timegroup = 1, delay will be -1 without any valid observations
                                                                     .(delay = tg - timegroup[which.min(focal_az - az)]),
                                                                     by = id]
  }, by = .(ID1, tg)]

  # id_tg <- DT[, .(ID1 = unique(ID1)),
  #             by = .(tg = timegroup)]#[!is.na(focal_az)]
  # edges[DT, focal_az := az, on = .(ID1 == id, timegroup)]
  # id_tg <- edges[DT, .(focal_az = az), on = .(ID1 == id, timegroup)]
  # setnames(id_tg, 'timegroup', 'tg')
  # TODO: returnDist = TRUE option and if TRUE then check col exists
  DT[, {
    DT[between(timegroup, tg - window, tg + window) & ID2 != .BY$ID1][,{
      min_diff_az <- which.min(diff_az)
      .(delay = tg - timegroup[min_diff_az],
        distance = distance[min_diff_az])
    },
       by = ID2]
  }, by = .(ID1, ID2, tg = timegroup)]
}
# Note: results must be saved like edge_ functions
# Naming: edge_dir_delay?
# TODO: consider using new env() functionality from data.table
# TODO: if so, refactor package to use throughout
# TODO: check chmatch

# TODO: is there some way to avoid double calculating, with dyadID?

# TODO: if only one observation eg. run of 1 observations grouped
#       what should we return?
# TODO: profile


calc_dir_corr_delay_from_DT <- function(DT, window) {
  setorder(DT, timegroup)
  id_tg <- DT[, .(ID1 = unique(id), focal_az = az),
              by = .(tg = timegroup)][!is.na(focal_az)]
  id_tg[, {
    DT[between(timegroup, tg - window, tg + window) & id != .BY$ID1][,
      # TODO: caution if timegroup = 1, delay will be -1 without any valid observations
        .(delay = tg - timegroup[which.min(focal_az - az)]),
         by = id]
  }, by = .(ID1, tg)]
}
