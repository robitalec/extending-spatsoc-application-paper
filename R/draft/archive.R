zz_dir_corr_delay <- function(DT, window = 5) {
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


calc_delay <- function(DT, window) {
  setorder(DT, timegroup)

  # tgs <- DT[, unique(.SD), .SDcols = c('id', 'timegroup')]
  # tgs[, timegroup_low := timegroup - window]
  # tgs[, timegroup_high := timegroup + window]

  DT[]
  id_tg <- DT[, .(ID1 = unique(id), focal_az = az),
              by = .(tg = timegroup)][!is.na(focal_az)]
  # cj_id_tg <- id_tg[, CJ(ID1,
  #            ID2 = DT[between(timegroup, tg - window, tg + window), id],
  #            unique = TRUE),
  #       by = tg]

  id_tg[, {
    DT[between(timegroup, tg - window, tg + window) &
         id != .BY$ID1][,
                        .(delay = tg - timegroup[which.min(focal_az - az)]),
                        by = id]
  }, by = .(ID1, tg)]

  id_tg[, {
    DT[between(timegroup, tg - window, tg + window) &
         id != .BY$ID1][, .SD[which.min(az - focal_az), timegroup], by = .(ID2 = id)]


    # m <- cast_az(
    #   DT[between(timegroup, tg - window, tg + window) &
    #                   id != .BY$ID1]
    #   ) - az
    # combs <- CJ(ID1 = .BY$id, ID2 = colnames(m))[ID1 != ID2]
    # combs[, .(delay =
    #             which.min(
    #               # focal timegroup observation for ID1
    #               m[median(seq.int(nrow(m))), ID1] -
    #                 # moving window observation for ID2
    #                 m[, ID2])),
    # by = .(ID1, ID2)]
    # }calc_az_and_which(
    # DT[between(timegroup, tg - window, tg + window)]
  }, by = .(ID1, tg)]

  calc_az_and_which <- function(DT) {
    m <- cast_az(DT)
    combs <- CJ(ID1 = colnames(m), ID2 = colnames(m))[ID1 != ID2]
    combs[, .(delay =
                which.min(
                  # focal timegroup observation for ID1
                  m[median(seq.int(nrow(m))), ID1] -
                    # moving window observation for ID2
                    m[, ID2])),
          by = .(ID1, ID2)]
  }

}
