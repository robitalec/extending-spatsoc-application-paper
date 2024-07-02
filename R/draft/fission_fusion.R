fission_fusion <- function(edges,
                           threshold = 50,
                           n_min_length = 2,
                           n_max_missing = 0,
                           allow_split = FALSE)  {
  stopifnot('dyadID' %in% colnames(edges))
  unique_edges <- unique(edges[, .(dyadID, timegroup, distance)])

  setorder(unique_edges, 'timegroup')

  unique_edges[, within := distance < threshold]
  unique_edges[, tg_diff := fifelse(
    timegroup == min(timegroup),
    0,
    timegroup - shift(timegroup, 1)),
  by = dyadID]

  unique_edges[, within_diff := fifelse(
    timegroup == min(timegroup),
    within,
    shift(within, 1) & shift(within, -1)),
  by = dyadID]
  unique_edges[, fusionID := fifelse(
    within,
    rleid((tg_diff <= 1 + n_max_missing)),
    NA_integer_),
  by = dyadID]

  if (!is.null(n_min_length) || n_min_length > 0) {
    unique_edges[!is.na(fusionID),
                 fusionID := fifelse(.N >= n_min_length, fusionID, NA_integer_),
                 by = .(dyadID, fusionID)]
  }

  unique_edges[!is.na(fusionID), fusionID := .GRP, by = .(dyadID, fusionID)]
  unique_edges[, c('within', 'tg_diff') := NULL]

  edges[unique_edges, fusionID := fusionID, on = .(timegroup, dyadID)]
  return(edges)
}

# TODO: move to vignette
# unique_edges[!is.na(run_id), dyad_run_len := max(timegroup) - min(timegroup), by = .(dyadID, run_id)]

