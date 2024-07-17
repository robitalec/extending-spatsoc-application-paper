# ties.method = 'average' by default, see ?frank
# if 1.5, 2.5, etc - points have exactly same location, possible error missed in prep
calc_dist_group_az <- function(DT, coords = c('x', 'y'), group = 'group',
                                  return_rank = FALSE, ties.method = 'average') {

  xcol <- first(coords)
  ycol <- last(coords)
  xcol_group <- paste0('group_mean_', xcol)
  ycol_group <- paste0('group_mean_', ycol)

  stopifnot('az' %in% colnames(DT))
  stopifnot(group %in% colnames(DT))
  stopifnot(xcol %in% colnames(DT))
  stopifnot(ycol %in% colnames(DT))
  stopifnot(xcol_group %in% colnames(DT))
  stopifnot(ycol_group %in% colnames(DT))
  # TODO: check if az in radians not degrees

  group_az_col <- 'group_az'
  DT[, c(group_az_col) := mean(az), by = c(group)]

  DT[, dist_along_group_az :=
       cos(.SD[[group_az_col]]) * (.SD[[xcol]] - .SD[[xcol_group]]) +
       sin(.SD[[group_az_col]]) * (.SD[[ycol]] - .SD[[ycol_group]]),
     by = .I]

  if (return_rank) {
    DT[, N_by_group := .N, by = c(group)]
    DT[, rank_dist_along_group_az :=
         frank(-dist_along_group_az, ties.method = ties.method),
       by = c(group)]
  }

  return(DT)
}
