fission_fusion <- function(edges, threshold = 50, min_run_len = 2,
                           max_missing_obs = 1)  {
  unique_edges <- unique(edges[, .(dyadID, timegroup, distance)])

  setorder(unique_edges, 'timegroup')

  unique_edges[, within := distance < threshold]
  unique_edges[, tg_diff := c(NA, diff(timegroup)), by = dyadID]
  unique_edges[, run_id := fifelse(
    within,
    rleid(tg_diff <= 1 + max_missing_obs & within),
    NA),
  by = dyadID]

  if (!is.null(min_run_len)) {
    unique_edges[!is.na(run_id),
                 run_id := fifelse(.N >= min_run_len, run_id, NA),
                 by = .(dyadID, run_id)]
  }

  unique_edges[!is.na(run_id), dyad_fusion_id := .GRP, by = .(dyadID, run_id)]
  unique_edges[, c('within', 'tg_diff', 'run_id') := NULL]

  # return merged?
  # edges[unique_edges, dyad_fusion_id := dyad_fusion_id, on = .(timegroup, dyadID)]
  # return(edges)

  return(unique_edges)
}