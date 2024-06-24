# because we don't anticipate a user wants to calculate this metric
#  for all rows, consider the precursor steps
# group_times for temporal grouping
# edge_dist for distance between individuals, with some threshold
# return distance = true to allow comparing the distance to the resulting metric

# what about edge_az following edge_dist with a threshold but
#  computes the az difference in radians (with 2pi check) and also returns dist
# that could be passed to calc dir corr delay and directly
calc_dir_corr_delay <- function(DT, edges, window) {
  setorder(DT, timegroup)
  setorder(edges, timegroup)
  # id_tg <- DT[, .(ID1 = unique(id), focal_az = az),
  #             by = .(tg = timegroup)][!is.na(focal_az)]
  edges[DT, focal_az := az, on = .(ID1 == id, timegroup)]
  # id_tg <- edges[DT, .(focal_az = az), on = .(ID1 == id, timegroup)]
  # setnames(id_tg, 'timegroup', 'tg')
  id_tg[, {
    DT[between(timegroup, tg - window, tg + window) & id == .BY$ID2][,
       .(delay = tg - timegroup[which.min(focal_az - az)])]
  }, by = .(ID1, ID2, tg)]
}
# Note: results must be saved like edge_ functions
# Naming: edge_dir_delay?
# TODO: consider using new env() functionality from data.table
# TODO: if so, refactor package to use throughout
# TODO: check chmatch

# TODO: is there some way to avoid double calculating, with dyadID?