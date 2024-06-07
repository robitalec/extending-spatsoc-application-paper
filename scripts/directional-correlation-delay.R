# https://static-content.springer.com/esm/art%3A10.1038%2Fnature08891/MediaObjects/41586_2010_BFnature08891_MOESM272_ESM.pdf


# https://www.zora.uzh.ch/id/eprint/9627/10/2008_Dodge_etal_IV_2008_MoveAnalysisTaxonomy_preprint.pdf
# https://cran.r-project.org/web/packages/collapse/collapse.pdf

library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)


calc_az <- function(DT) {
  DT[, az := c(
    units::drop_units(
      lwgeom::st_geod_azimuth(st_as_sf(.SD, coords = c('x', 'y'), crs = 4326))),
    NA), by = id]
}

shift_window <- function(x, size) {
  c(
    shift(x, n = size, type = 'lead'),
    x,
    shift(x, n = size, type = 'lag')
  )
}


shift_window(c(1, 2, 3, 4, 5), 2)
  # Troubleshooting:
  # Error in set(x, j = name, value = value) :
  # Supplied 9 items to be assigned to 10 items of column 'az'. If you wish to 'recycle' the RHS please use rep() to make this intent clear to readers of your code.
  # ^ Related to units and st_geod_azimuth dropping last instead of returning NA
  # ^ Related: https://github.com/r-quantities/units/issues/163
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
  length.out = .N),
  by = id
]

zz <- calc_dir_corr_delay(DT)
print(zz)
