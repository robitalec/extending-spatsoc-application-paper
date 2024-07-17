calc_az <- function(DT, coords = c('x', 'y'), projection = NULL) {
#' Ensure input DT is ordered by datetime or timegroup using
#' eg. setorder(DT, timegroup)
calc_az <- function(DT, id = NULL, coords = NULL, projection = NULL) {
  stopifnot(!is.null(id))
  stopifnot(!is.null(coords))
  stopifnot(!is.null(projection))

  if (st_is_longlat(projection)) {
    DT[, az := c(
      units::drop_units(
        lwgeom::st_geod_azimuth(st_as_sf(.SD, coords = coords, crs = projection))),
      NA),
      by = c(id)]
  } else {
    DT[, az := c(
      units::drop_units(
        lwgeom::st_geod_azimuth(st_transform(
          st_as_sf(.SD, coords = coords, crs = projection),
          crs =  4326))),
      NA),
      by = c(id)]

  }
}

# https://postgis.net/docs/ST_Azimuth.html


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