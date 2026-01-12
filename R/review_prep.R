#' Review prep
#'
#' @param DT input data.table
#' @param metric_thesaurus thesaurus of metric synonyms
#'
#' @returns prepared review data.table
review_prep <- function(DT, metric_thesaurus = NULL, metric_definitions = NULL,
                        dominance_thesaurus = NULL) {
  data.table::setnames(DT, janitor::make_clean_names(colnames(DT)))

  if (!is.null(metric_thesaurus)) {
    DT[, metric_agg := metric_thesaurus[
      metric %in% trimws(unlist(strsplit(.BY[[1]], ';'))),
      paste(metric_agg, collapse = '; ')],
      by = metric_used_or_described
    ]
  }

  if (!is.null(metric_definitions)) {
    DT[metric_definitions,
       c('definition', 'definition_category') :=
         .(definitions_of_leader_initiator_etc,
           category),
       on = 'study_id']
  }

  if (!is.null(dominance_thesaurus)) {
    DT[dominance_thesaurus,
       dominance_metric_agg := dominance_metric_agg,
       on = 'study_id']
  }

  DT[, yr := tstrsplit(study_id, ' ', keep = 2, type.convert = TRUE)]

  return(DT)
}
