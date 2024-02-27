targets::tar_source('R')

fp_met_thes <- file.path('map', 'metric-thesaurus.csv')


c(
  tar_file_read(
    raw_review,
    file.path('map', 'review.csv'),
    fread(!!.x)
  ),
  tar_target(
    dl_metric_thesaurus,
    read_sheet('1YInLKBejpIUaovCnpLanXvPr8uvBEA6skpUcvFc2Ov8',
               sheet = 'metric-thesaurus',
               col_types = 'c') |>
      fwrite(x = _, file = fp_met_thes),
    cue = tar_cue('always')
  ),
  tar_target(
    benchmark_papers,
    data.table(
      read_sheet('112TA9JMfQ6mK9tGPSnJVF6fSmfw9hnR_FB1aasoac-M',
               sheet = 'benchmark papers'))[
                 is.na(`Removed as benchmark`),
                 .(Citation, `Indexed in WoS`)]
  ),
  tar_file_read(
    metric_synonyms,
    fp_met_thes,
    fread(!!.x)
  ),
  tar_target(
    software_meta,
    read_sheet('1YInLKBejpIUaovCnpLanXvPr8uvBEA6skpUcvFc2Ov8',
               sheet = 'software-meta',
               col_types = 'c'),
    cue = tar_cue('always')
  ),
  tar_target(
    review,
    prep_review(
      raw_review,
      metric_synonyms
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
    count_list(review, 'analysis_code_availability')
  ),
  tar_target(
    count_raw_metric,
    count_list(review, 'metric_used_or_described')
  ),
  tar_target(
    count_metric,
    count_list(review, 'metric_agg')
  ),
  tar_target(
    geocoded,
    geocode_studies(review)
  ),
  tar_target(
    taxized,
    taxize_studies(review)
  ),
  tar_quarto(
    site,
    path = '.'
  )
)
