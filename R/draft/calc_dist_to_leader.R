calc_dist_to_leader <- function(DT, coords = c('x', 'y'), group = 'group') {
  stopifnot(first(coords) %in% colnames(DT))
  stopifnot(last(coords) %in% colnames(DT))
  stopifnot(group %in% colnames(DT))
  stopifnot('rank_dist_along_group_az' %in% colnames(DT))

  DT[, dist_to_leader :=
       as.matrix(dist(cbind(.SD[order(rank_dist_along_group_az)]), diag = TRUE))[, 1],
     .SDcols = c(coords),
     by = c(group)]

  return(DT)
}