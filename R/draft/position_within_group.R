position_within_group <- function(DT, coords = c('x', 'y')) {
  stopifnot('az' %in% colnames(DT))
  stopifnot('group' %in% colnames(DT))
  stopifnot('group_mean_x' %in% colnames(DT))
  stopifnot('group_mean_y' %in% colnames(DT))
  # TODO: check if az in radians not degrees

  DT[, group_az := mean(az), by = group]
}