paste_n_percent <- function(n, denom = NULL) {
  paste0(n, ' (', scales::percent(n / ifelse(is.null(denom), sum(n), denom)), ')')
}
