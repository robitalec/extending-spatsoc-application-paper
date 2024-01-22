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
  )
)