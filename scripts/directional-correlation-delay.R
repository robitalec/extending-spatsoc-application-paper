library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)

calc_dir_corr_delay <- function(DT) {

}


n <- 10
n_id <- 2
DT <- data.table(
  x = -88 + runif(n),
  y = 55 + runif(n),
  id = LETTERS[seq.int(n_id)]
)
