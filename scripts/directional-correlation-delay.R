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
DT[, datetime := seq.POSIXt(
  as.POSIXct('2022-01-01 10:00:00'),
  as.POSIXct('2022-01-02 10:00:00'),
  length.out = .N,
  each = n_id
)]

print(calc_dir_corr_delay(DT))
