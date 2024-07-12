calc_polarization <- function(DT,  group = 'group') {
  stopifnot('az' %in% colnames(DT))
  stopifnot('group' %in% colnames(DT))

  # Klamser 2021: polarization = absolute value of the mean heading direction
  # DT[, polarization := abs(mean(az)), by = c(group)]

  DT[, polarization := CircStats::r.test(.SD[[1]])$r.bar, by = c(group),
     .SDcols = c('az')]


  return(DT)
}