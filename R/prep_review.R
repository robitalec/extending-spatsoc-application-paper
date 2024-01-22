prep_review <- function(path) {
  DT <- fread(path)

  setnames(DT, make_clean_names(colnames(DT)))

  return(DT)
}