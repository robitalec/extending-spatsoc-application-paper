calc_dist_to_leader <- function(DT, coords = c('x', 'y'), group = 'group') {
  stopifnot(first(coords) %in% colnames(DT))
  stopifnot(last(coords) %in% colnames(DT))
  stopifnot(group %in% colnames(DT))
  stopifnot('rank_dist_along_group_az' %in% colnames(DT))

  DT[, temp_N_by_group := .N, by = c(group)]

  DT[, dist_to_leader := fifelse(
    temp_N_by_group > 1,
    as.matrix(dist(cbind(.SD[[1]], .SD[[2]])))[, which(.SD[[3]] == 1)],
                                 0),
     .SDcols = c(coords, 'rank_dist_along_group_az'),
     by = c(group)]
  DT[, temp_N_by_group := NULL]
  return(DT)
}