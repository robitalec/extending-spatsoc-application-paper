position_within_group <- function(DT, coords = c('x', 'y')) {

  xcol <- first(coords)
  ycol <- last(coords)
  xcol_group <- paste0('group_mean_', xcol)
  ycol_group <- paste0('group_mean_', ycol)

  stopifnot('az' %in% colnames(DT))
  stopifnot('group' %in% colnames(DT))
  stopifnot(xcol %in% colnames(DT))
  stopifnot(ycol %in% colnames(DT))
  stopifnot(xcol_group %in% colnames(DT))
  stopifnot(ycol_group %in% colnames(DT))
  # TODO: check if az in radians not degrees

  DT[, group_az := mean(az), by = group]

  DT[, dist_along_group_az :=
       (matrix(c(cos(.SD[['group_az']]), -sin(.SD[['group_az']]),
                 sin(.SD[['group_az']]), cos(.SD[['group_az']])),
               byrow = TRUE, ncol = 2) %*%
          (c(.SD[[2]] - .SD[[4]], .SD[[3]] - .SD[[5]])))[2,],
     .SDcols = c('group_az', coords, paste0('group_mean_', coords)),
     by = .I]
}