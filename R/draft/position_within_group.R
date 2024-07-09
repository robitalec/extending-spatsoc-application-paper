position_within_group <- function(DT, coords = c('x', 'y')) {
  stopifnot('az' %in% colnames(DT))
  stopifnot('group' %in% colnames(DT))
  stopifnot(paste0('group_mean_', coords[1]) %in% colnames(DT))
  stopifnot(paste0('group_mean_', coords[2]) %in% colnames(DT))
  # TODO: check if az in radians not degrees

  DT[, group_az := mean(az), by = group]

  DT[, dist_along_group_az :=
       (matrix(c(cos(.SD[['group_az']]), -sin(.SD[['group_az']]),
                 sin(.SD[['group_az']]), cos(.SD[['group_az']])),
               byrow = TRUE, ncol = 2) %*%
          (c(.SD[[2]] - .SD[[4]], .SD[[3]] - .SD[[5]])))[2,],
     .SDcols = c('group_az', coords, paste0('group_mean_', coords)),

}