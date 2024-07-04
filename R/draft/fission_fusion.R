fission_fusion <- function(edges,
                           threshold = 50,
                           n_min_length = 0,
                           n_max_missing = 0,
                           allow_split = FALSE)  {
  stopifnot('dyadID' %in% colnames(edges))
  unique_edges <- unique(edges[, .(dyadID, timegroup, distance)])

  setorder(unique_edges, 'timegroup')

  unique_edges[, within := distance < threshold]

  if (allow_split) {
    unique_edges[, within := fifelse(within | timegroup == min(timegroup),
                                     within,
                                     shift(within, -1) & shift(within, 1) &
                                       timegroup - shift(timegroup, 1) == 1),
                 by = dyadID]
  }

  unique_edges[, within_rleid := rleid(within), by = dyadID]
  unique_edges[!(within), within_rleid := NA_integer_]

  unique_edges[, tg_diff := fifelse(within,
                                    timegroup - shift(timegroup) <= 1 |
                                      timegroup == min(timegroup),
                                    NA),
               by = dyadID]

  if (n_max_missing > 0) {
    unique_edges[, tg_diff := fifelse(tg_diff,
                                          tg_diff,
                                          shift(within, -1) &
                                            timegroup - shift(timegroup, 1) >=
                                            1 + n_max_missing),
                 by = dyadID]
  }
               by = dyadID]

  if (n_min_length > 0) {
    unique_edges[!is.na(both_rleid),
                 both_rleid := fifelse(.N >= n_min_length, both_rleid, NA_integer_),
                 by = .(dyadID, both_rleid)]
  }

  unique_edges[!is.na(both_rleid), fusionID := .GRP, by = .(dyadID, both_rleid)]
  unique_edges[, c('within', 'tg_diff') := NULL]

  edges[unique_edges, fusionID := fusionID, on = .(timegroup, dyadID)]
  return(edges)
}