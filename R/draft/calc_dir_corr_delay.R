calc_dir_corr_delay <- function(DT, edges, window) {
  setorder(DT, timegroup)

  id_tg <- edges[!is.na(fusionID), .(
    tg = unique(timegroup),
    dyadID = unique(dyadID),
    ID1 = first(ID1),
    ID2 = first(ID2)
    ), by = fusionID]
  id_tg[, min_tg := fifelse(tg - window < min(tg), min(tg), tg - window), by = fusionID]
  id_tg[, max_tg := fifelse(tg + window < min(tg), min(tg), tg + window), by = fusionID]

  id_tg[, delay_tg := {
    focal_az <- DT[timegroup == .BY$tg & id == ID1, az]
    DT[between(timegroup, min_tg, max_tg) & id == ID2,
       timegroup[which.min(abs(focal_az -  az))]]

  # TODO more fifelse

}

# Note: results must be saved like edge_ functions
# Naming: edge_dir_delay?
# TODO: consider using new env() functionality from data.table
# TODO: if so, refactor package to use throughout
# TODO: check chmatch

# TODO: is there some way to avoid double calculating, with dyadID?

# TODO: if only one observation eg. run of 1 observations grouped
#       what should we return?
