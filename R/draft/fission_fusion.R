fission_fusion <- function(edges, threshold = 50, min_run_len = 2,
                           max_missing_obs = 1)  {
  unique_edges <- unique(edges[, .(dyadID, timegroup, distance)])

  setorder(unique_edges, 'timegroup')

  unique_edges[, within := distance < threshold]
