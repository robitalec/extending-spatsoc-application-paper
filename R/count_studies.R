count_studies <- function(review) {
  count_programming_language <- count_list(review, 'programming_language')
  count_software <- count_list(review, 'software_package_s_used')
  count_analysis_code_availability <- count_list(review, 'analysis_code_availability')
  count_raw_metric <- count_list(review, 'metric_used_or_described')
  count_metric <- count_list(review, 'metric_agg')

  list(
    count_prog_lang = count_programming_language,
    count_software = count_software,
    count_code_avail = count_analysis_code_availability,
    count_metric = count_metric,
    count_raw_metric = count_raw_metric
  )
}
