calc_dist_to_group_centroid <- function(DT, xcol, ycol, group = 'group',
                                        return_rank = FALSE) {
  pre <- 'group_mean_'
  group_xcol <- paste0(pre, xcol)
  group_ycol <- paste0(pre, ycol)

  stopifnot(xcol %in% colnames(DT))
  stopifnot(ycol %in% colnames(DT))
  stopifnot(group_xcol %in% colnames(DT))
  stopifnot(group_ycol %in% colnames(DT))
  stopifnot(group %in% colnames(DT))


  DT[, dist_to_group_centroid :=
       sqrt((.SD[[xcol]] - .SD[[group_xcol]])^2 +
              (.SD[[ycol]] - .SD[[group_ycol]])^2)]

  if (return_rank) {
    DT[, N_by_group := .N, by = c(group)]
    DT[, rank_dist_to_group_centroid :=
         rank(dist_to_group_centroid),
       by = c(group)]
  }
  return(DT[])
}