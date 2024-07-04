group_centroid <- function(DT, xcol, ycol, group = 'group', na.rm = FALSE) {
  stopifnot(xcol %in% colnames(DT))
  stopifnot(ycol %in% colnames(DT))
  stopifnot(group %in% colnames(DT))
  DT[, group_mean_x := .SD, by = c(group), .SDcols = xcol]
  DT[, group_mean_y := .SD, by = c(group), .SDcols = xcol]
  return(DT[])
}