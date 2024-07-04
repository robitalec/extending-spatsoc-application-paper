calc_dist_from_group_centroid <- function(DT, xcol, ycol) {
  pre <- 'group_mean_'
  group_xcol <- paste0(pre, xcol)
  group_ycol <- paste0(pre, ycol)

  stopifnot(xcol %in% colnames(DT))
  stopifnot(ycol %in% colnames(DT))
  stopifnot(group_xcol %in% colnames(DT))
  stopifnot(group_ycol %in% colnames(DT))


  DT[, dist_from_group_centroid :=
       sqrt((.SD[[xcol]] - .SD[[group_xcol]])^2 +
              (.SD[[ycol]] - .SD[[group_ycol]])^2)]
  return(DT[])
}