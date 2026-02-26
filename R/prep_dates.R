#' Prepare datetime columns
#'
#' @param DT data.table
#' @param datetime character; datetime column name
#'
#' @return
#' data.table with datetime columns added
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' prep_dates(DT, 'datetime')
prep_dates <- function(DT, datetime) {
  if (!datetime %in% colnames(DT)) {
    stop('datetime not found in DT')
  }

  DT[, datetime := as.POSIXct(datetime), env = list(datetime = datetime)]

  DT[, doy := data.table::yday(datetime)]
  DT[, yr := data.table::year(datetime)]
  DT[, mnth := data.table::month(datetime)]

  return(DT)
}
