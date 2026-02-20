#' Write gs4 to CSV
#'
#' @param ss Google Sheet identifier
#' @param sheet sheet name
#' @param file output file path
#'
#' @returns output file path after writing out file
#' @seealso [googlesheet4::read_sheet()]
write_gs4_to_csv <- function(ss, sheet, file) {
  in_sheet <- googlesheets4::read_sheet(ss, sheet, col_types = 'c')
  data.table::fwrite(x = in_sheet, file = file)

  return(file)
}
