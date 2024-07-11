calc_dir_to_leader <- function(DT, coords = c('x', 'y'), group = 'group') {
  stopifnot(first(coords) %in% colnames(DT))
  stopifnot(last(coords) %in% colnames(DT))
  stopifnot(group %in% colnames(DT))
  stopifnot('rank_dist_along_group_az' %in% colnames(DT))

  check_has_leader <- DT[, .(has_leader = any(rank_dist_along_group_az == 1)),
                         by = c(group)][!(has_leader)]

  if (check_has_leader[, .N > 0]) {
    warning('groups found missing leader (rank_dist_along_group_az == 1): \n',
            check_has_leader[, paste(group, collapse = ', ')])
  }

  DT[, temp_leader_xcol := .SD[which(rank_dist_along_group_az == 1)],
     .SDcols = first(coords), by = c(group)]
  DT[, temp_leader_ycol := .SD[which(rank_dist_along_group_az == 1)],
     .SDcols = last(coords), by = c(group)]

  DT[!group %in% check_has_leader$group, dir_to_leader := fifelse(
    .SD[[first(coords)]] == .SD[['temp_leader_xcol']] &
      .SD[[last(coords)]] == .SD[['temp_leader_ycol']],
    NaN,
    atan2(.SD[['temp_leader_xcol']] - .SD[[first(coords)]],
          (.SD[['temp_leader_ycol']] - .SD[[last(coords)]]))
  )]
  return(DT)
}