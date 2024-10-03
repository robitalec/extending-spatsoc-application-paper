count_list <- function(DT, col) {
  count <- DT[, strsplit(.SD[[1]], ';'), .SDcols = col, by = covidence_number]
  count[, (paste0('n_', col)) := trimws(V1)]
  return(count)
}