fission_fusion <- function(edges, threshold = 50,
                           n_min_length = 2, n_max_missing = 0)  {
  # TODO: check for dyadID
  unique_edges <- unique(edges[, .(dyadID, timegroup, distance)])

  setorder(unique_edges, 'timegroup')

  unique_edges[, within := distance < threshold]
  unique_edges[, tg_diff := shift(timegroup, -1, fill = -999) - timegroup, by = dyadID]
  unique_edges[, fusionID := fifelse(
    within,
    rleid((tg_diff <= 1 + n_max_missing)),
    NA_integer_),
  by = dyadID]

  if (!is.null(min_run_len)) {
    unique_edges[!is.na(fusionID),
                 fusionID := fifelse(.N >= min_run_len, fusionID, NA_integer_),
                 by = .(dyadID, fusionID)]
  }

  unique_edges[!is.na(fusionID), fusionID := .GRP, by = .(dyadID, fusionID)]
  unique_edges[, c('within', 'tg_diff') := NULL]

  return(unique_edges)
}

# TODO: move to vignette
# unique_edges[!is.na(run_id), dyad_run_len := max(timegroup) - min(timegroup), by = .(dyadID, run_id)]

# TODO: consider
# return merged?
# edges[unique_edges, dyad_fusion_id := dyad_fusion_id, on = .(timegroup, dyadID)]
# return(edges)