taxize_studies <- function(DT) {
  DT_in <- DT[, strsplit(.SD[['species']], ';'), by = covidence_number]
  DT_in[, species := trimws(V1)]
  DT_in[, V1 := NULL]
