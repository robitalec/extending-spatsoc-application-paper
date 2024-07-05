group_centroid <- function(DT, xcol, ycol, group = 'group', na.rm = FALSE) {
  stopifnot(xcol %in% colnames(DT))
  stopifnot(ycol %in% colnames(DT))
  stopifnot(group %in% colnames(DT))
  DT[, paste0('group_mean_', xcol) := mean(.SD[[xcol]], na.rm = na.rm), by = c(group)]
  DT[, paste0('group_mean_', ycol) := mean(.SD[[ycol]], na.rm = na.rm), by = c(group)]
  return(DT[])
}