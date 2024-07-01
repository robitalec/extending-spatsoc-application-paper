calc_dir_corr_delay <- function(DT, edges, window) {
  stopifnot('dyadID' %in% colnames(edges))
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
       timegroup[which.min(delta_rad(focal_az, az))]]
  }, by = .(tg,  dyadID)]

  id_tg[, dir_corr_delay := tg - delay_tg]

  setnames(id_tg,  c('tg'), c('timegroup'))
  set(id_tg, j = c('min_tg', 'max_tg','delay_tg'), value = NULL)
  setorder(id_tg, timegroup, ID1, ID2, dir_corr_delay)

  rbindlist(list(
    id_tg,
    id_tg[, .(timegroup,  dyadID, fusionID,
              ID1 = ID2, ID2 = ID1, dir_corr_delay = - dir_corr_delay)]
  ), use.names = TRUE)

}