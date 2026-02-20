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

  # Manual fixes
  DT_in[grepl('Yakushuma Island, Japan', region), region := 'Yakushima, Japan']
  DT_in[grepl('NWT', region), region := 'Northwest Territories, Canada']
  DT_in[
    grepl('Gonarezhou National Park', region),
    region := 'Gonarezhou National Park'
  ]
  DT_in[
    grepl('Gap Arid Zone Research Station', region),
    region := 'NSW 2880, Australia'
  ]
  DT_in[
    grepl('Arctic National Wildlife Refuge', region),
    region := 'Arctic National Wildlife Refuge'
  ]
  DT_in[grepl('60.10 N, 148 W', region), region := '60.10 N, 148 W']
  DT_out <- tidygeocoder::geocode(DT_in, address = 'region')
  setDT(DT_out)

  return(DT_out)
}
