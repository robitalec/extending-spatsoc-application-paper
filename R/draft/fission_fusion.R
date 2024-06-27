fission_fusion <- function(edges, threshold = 50, min_run_len = 2,
                           n_max_missing = 0)  {
  unique_edges <- unique(edges[, .(dyadID, timegroup, distance)])

  setorder(unique_edges, 'timegroup')

  unique_edges[, within := distance < threshold]
  unique_edges[, tg_diff := c(NA, diff(timegroup)), by = dyadID]
  unique_edges[, run_id := fifelse(
  unique_edges[, runID := fifelse(
    within,
    rleid((tg_diff <= 1 + n_max_missing)),
    NA_integer_),
  by = dyadID]

  if (!is.null(min_run_len)) {
    unique_edges[!is.na(runID),
                 runID := fifelse(.N >= min_run_len, runID, NA_integer_),
                 by = .(dyadID, runID)]
  }

  unique_edges[!is.na(runID), runID := .GRP, by = .(dyadID, runID)]

  # return merged?
  # edges[unique_edges, dyad_fusion_id := dyad_fusion_id, on = .(timegroup, dyadID)]
  # return(edges)

  return(unique_edges)
}