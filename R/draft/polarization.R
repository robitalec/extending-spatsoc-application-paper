calc_polarization <- function(DT,  group = 'group') {
  stopifnot('az' %in% colnames(DT))
  stopifnot('group' %in% colnames(DT))

  DT[, polarization := r.test(.SD)$r.bar, by = c(group), .SDcols = c('az')]

  return(DT)
}