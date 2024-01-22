targets::tar_source('R')



c(
  tar_file(
    raw_review,
    file.path('map', 'review_384590_20240123073254.csv')
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
  )
)