#' Review geocoder
#'
#' Geocoding with [tidygeocoder::geocode()]
#'
#' @param DT input data.table
#'
#' @returns geocoded regions in input data.table
#' @seealso [tidygeocoder::geocode()]
review_geocode <- function(DT) {
  DT_in <- DT[, strsplit(.SD[['region']], ';'), by = covidence_number]
  DT_in[, region := trimws(V1)]
  DT_in[, V1 := NULL]

  DT_out <- tidygeocoder::geocode(DT_in, address = 'region')
  setDT(DT_out)

  return(DT_out)
}
