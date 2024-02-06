geocode_studies <- function(DT) {
  DT_in <- DT[, strsplit(.SD[['region']], ';'), by = covidence_number]
  DT_in[, region := trimws(V1)]
  DT_in[, V1 := NULL]


