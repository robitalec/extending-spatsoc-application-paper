write_gs4_to_csv <- function(ss, sheet, file) {
  in_sheet <- read_sheet(ss, sheet, col_types = 'c')
  fwrite(x = in_sheet, file = file)

  return(file)
}