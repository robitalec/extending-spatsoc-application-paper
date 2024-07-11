calc_dirs_to_leader <- function(DT, coords = c('x', 'y'), group = 'group') {
  stopifnot(first(coords) %in% colnames(DT))
  stopifnot(last(coords) %in% colnames(DT))
  stopifnot(group %in% colnames(DT))
  stopifnot('rank_dist_along_group_az' %in% colnames(DT))
