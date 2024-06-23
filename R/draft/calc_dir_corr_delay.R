calc_dir_corr_delay <- function(DT, window = 5) {
  calc_az(DT)
  dyads <- CJ(
    ID1 = unique(DT$id),
    ID2 = unique(DT$id),
    tg = unique(DT$timegroup)
  )[ID1 != ID2]
  setorder(DT, -timegroup)
  setorder(dyads, tg)

  dyads[, calc_closest_az(.SD, DT, window),
        by = tg,
        .SDcols = colnames(dyads)]
}

calc_closest_az <- function(dyad_DT, locs_DT, window) {
  i_tg <- unique(dyad_DT$tg)
  seq_tg <- seq(i_tg - window, i_tg + window) - i_tg
  dyad_DT[, #.(tg_delay =
          seq_tg[which.min(
          abs_diff_rad(
    locs_DT[.SD, az, on = .(id == ID1, timegroup == tg)],
    locs_DT[id == ID2 & between(timegroup, tg - window, tg + window), az]
    )
    )]
    ,
  # )) - window), # rm 1l
  by = .(ID1, ID2), .SDcols = colnames(dyad_DT)]
}


cast_az <- function(DT) {
  as.matrix(dcast(DT, timegroup ~ id, value.var = 'az')[,-c(1)])
}