calc_dir_corr_delay <- function(DT, window) {
  setorder(DT, timegroup)
  id_tg <- DT[, .(ID1 = unique(id), focal_az = az),
              by = .(tg = timegroup)][!is.na(focal_az)]
  id_tg[, {
    DT[between(timegroup, tg - window, tg + window) & id != .BY$ID1][,
       .(delay = tg - timegroup[which.min(focal_az - az)]),
       by = .(ID2 = id)]
  }, by = .(ID1, tg)]
}
