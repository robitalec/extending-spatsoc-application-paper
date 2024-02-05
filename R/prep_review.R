prep_review <- function(DT, metric_synonyms = NULL) {
  setnames(DT, make_clean_names(colnames(DT)))

  if (!is.null(metric_synonyms)) {
    DT[, metric_agg := metric_synonyms[
      metric %in% trimws(unlist(strsplit(.BY[[1]], ';'))),
      paste(metric_agg, collapse = '; ')],
      by = metric_used_or_described
    ]
  }

  DT[, yr := tstrsplit(study_id, ' ', keep = 2, type.convert = TRUE)]

  return(DT)
}
