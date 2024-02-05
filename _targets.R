targets::tar_source('R')



c(
  tar_file_read(
    raw_review,
    file.path('map', 'review.csv'),
    fread(!!.x)
  ),
  tar_file_read(
    metric_synonyms,
    'map/metric-thesaurus.csv',
    fread(!!.x)
  ),
  tar_target(
    review,
    prep_review(
      raw_review
    )
  ),
  tar_target(
    count_programming_language,
    count_list(review, 'programming_language')
  ),
  tar_target(
    count_software,
    count_list(review, 'software_package_s_used')
  ),
  tar_target(
    count_analysis_code_availability,
    count_list(review, 'analysis_code_availability')[, .N, V1]
  ),
  tar_target(
    count_metric,
    count_list(review, 'metric_used_or_described')
  ),
  tar_quarto(
    site,
    path = '.'
  )
)