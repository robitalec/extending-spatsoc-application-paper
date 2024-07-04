calc_dir_to_group_centroid <- function(DT, xcol, ycol) {
  pre <- 'group_mean_'
  group_xcol <- paste0(pre, xcol)
  group_ycol <- paste0(pre, ycol)

  stopifnot(xcol %in% colnames(DT))
  stopifnot(ycol %in% colnames(DT))
  stopifnot(group_xcol %in% colnames(DT))
  stopifnot(group_ycol %in% colnames(DT))


  DT[, dir_to_group_centroid :=
       # TODO: if atan2(0, 0) then return NaN
       atan2(.SD[[group_xcol]] - .SD[[xcol]],
              (.SD[[group_ycol]] - .SD[[ycol]]))]

  return(DT[])
}