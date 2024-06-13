calc_az <- function(DT) {
  DT[, az := c(
    units::drop_units(
      lwgeom::st_geod_azimuth(st_as_sf(.SD, coords = c('x', 'y'), crs = 4326))),
    NA), by = id]
}