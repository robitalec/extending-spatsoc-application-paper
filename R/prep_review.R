prep_review <- function(DT, metric_synonyms = NULL) {
  setnames(DT, make_clean_names(colnames(DT)))

  if (!is.null(metric_synonyms)) {
    DT[, metric_agg :=
         stringi::stri_replace_all(
           str = metric_used_or_described,
           replacement = metric_synonyms$metric_agg,
           regex = metric_synonyms$metric,
           vectorize_all = FALSE
         )]
  }

  return(DT)
}