# === spatsoc paper 2 -----------------------------------------------------
# Alec L. Robitaille


# Source functions, packages
targets::tar_source('R')

# Variables
fp_met_thes <- file.path('map', 'metric-thesaurus.csv')



# Targets: Review ---------------------------------------------------------
targets_review <- c(
  tar_file_read(
    raw_review,
    file.path('map', 'review.csv'),
    fread(!!.x)
  ),
  tar_target(
    dl_metric_thesaurus,
    write_gs4_to_csv('1YInLKBejpIUaovCnpLanXvPr8uvBEA6skpUcvFc2Ov8',
                     sheet = 'metric-thesaurus',
                     file = fp_met_thes),
    cue = tar_cue('always')
  ),
  tar_target(
    benchmark_papers,
    data.table(
      read_sheet(
        '112TA9JMfQ6mK9tGPSnJVF6fSmfw9hnR_FB1aasoac-M',
        sheet = 'benchmark papers'))[
          is.na(`Removed as benchmark`),
          .(Citation, `Indexed in WoS`)]
  ),
  tar_target(
    search_strings,
    data.table(
      read_sheet(
        '112TA9JMfQ6mK9tGPSnJVF6fSmfw9hnR_FB1aasoac-M',
        sheet = 'iterative search'))[, last(.SD)[, .(String)], Source]
  ),
  tar_file_read(
    metric_synonyms,
    dl_metric_thesaurus,
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
    geocoded,
    geocode_studies(review)
  ),
  tar_target(
    taxized,
    taxize_studies(review)
  ),
  tar_target(
    counted,
    count_studies(review)
  ),
  tar_quarto(
    site,
    path = '.'
  )
)



# Targets: Figures --------------------------------------------------------
targets_figures <- c(

)


# Targets: All ------------------------------------------------------------
# Automatically grab all the 'targets_*' lists above
lapply(grep('targets', ls(), value = TRUE), get)
