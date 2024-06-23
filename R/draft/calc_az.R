calc_az <- function(DT) {
  DT[, az := c(
    NA,
    units::drop_units(
      lwgeom::st_geod_azimuth(st_as_sf(.SD, coords = c('x', 'y'), crs = 4326)))),
    by = id]
}

# TODO: option for projected coordinates?

# TODO: lead/lag?

# TODO: NaN return
# R: p = st_sfc(st_point(c(7,52)), st_point(c(8,53)), st_point(c(8,53)), crs = 4326)
# R: st_geod_azimuth(p)
# Units: [rad]
# [1] 0.541   NaN
# R: p = st_sfc(st_point(c(7,52)), st_point(c(8,53)), st_point(c(8,54)), crs = 4326)
# R: st_geod_azimuth(p)
# Units: [rad]
# [1] 0.541 0.000