abs_diff_rad <- function(x,  y) {
  d <- abs(x - y)
  fifelse(d > 2 * pi, d - (2 * pi), d)
}