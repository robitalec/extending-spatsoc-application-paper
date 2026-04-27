#' Review count
#'
#' @param DT input data.table
#'
#' @returns counts of review characteristics e.g. programming language, metric used
review_count <- function(DT) {
  count_list <- function(DT, col) {
    count <- DT[, strsplit(.SD[[1]], ';'), .SDcols = col, by = covidence_number]
    count[, (col) := trimws(V1)]
    count[, V1 := NULL]
    return(count)
  }

  count_programming_language <- count_list(DT, 'programming_language')
  count_software <- count_list(DT, 'software_package_s_used')
  count_analysis_code_availability <- count_list(
    DT,
    'analysis_code_availability'
  )
  count_raw_metric <- count_list(DT, 'metric_used_or_described')
  count_metric <- count_list(DT, 'metric_agg')
  count_dom_metric <- count_list(DT, 'dominance_metric_agg')

  list(
    count_prog_lang = count_programming_language,
    count_software = count_software,
    count_code_avail = count_analysis_code_availability,
    count_metric = count_metric,
    count_raw_metric = count_raw_metric,
    count_dom_metric = count_dom_metric
  )
}
