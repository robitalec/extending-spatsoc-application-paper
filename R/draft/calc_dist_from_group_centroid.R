calc_dist_from_group_centroid <- function(DT, xcol, ycol) {
  pre <- 'group_mean_'
  DT[, dist_from_group_centroid :=
       sqrt((.SD[[xcol]] - .SD[[paste0(pre, xcol)]])^2 +
              (.SD[[ycol]] - .SD[[paste0(pre, ycol)]])^2)]
  return(DT[])
}