calc_dir_corr_delay <- function(DT, window = 5) {
  calc_az(DT)
  dyads <- CJ(
    ID1 = unique(DT$id),
    ID2 = unique(DT$id),
    tg = unique(DT$timegroup)
  )[ID1 != ID2]

  calc_closest_az <- function(dyad_DT, locs_DT, window) {
    dyad_DT[, .(tg_delay = which.min(abs_diff_rad(
      locs_DT[.SD, az, on = .(id == ID1, timegroup == tg)],
      locs_DT[id == ID2 & between(timegroup, tg - window, tg + window), az]
    )) - window - 1L),
    by = .(ID1, ID2), .SDcols = colnames(dyad_DT)]
  }
  dyads[, calc_closest_az(.SD, DT, window),
        by = tg,
        .SDcols = colnames(dyads)]
}