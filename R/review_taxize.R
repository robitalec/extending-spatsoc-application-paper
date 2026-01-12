#' Review taxizer
#'
#' Taxizing with [rgnparser::gn_parse_tidy()]
#'
#' Fields described:
#'
#' Field 	Meaning
#' Id 	UUID v5 generated out of Verbatim
#' Verbatim 	Input name-string without any changes
#' Cardinality 	0 - N/A, 1 - Uninomial, 2 - Binomial etc.
#' CanonicalStem 	Simplest canonical form with removed suffixes
#' CanonicalSimple 	Simplest canonical form
#' CanonicalFull 	Canonical form with hybrid sign and ranks
#' Authors 	Authorship of a name
#' Year 	Year of the name (if given)
#' Quality 	Parsing quality
#'
#' Output described:
#'
#' https://github.com/gnames/gnparser?tab=readme-ov-file#figuring-out-if-names-are-well-formed
#' "quality": 1 - No problems were detected.
#' "quality": 2 - There were small problems, normalized result should still be good.
#' "quality": 3 - There are some significant problems with parsing.
#' "quality": 4 - There were serious problems with the name, and the final result is rather doubtful.
#' "quality": 0 - A string could not be recognized as a scientific name and parsing failed.
#'
#' @param DT input data.table
#'
#' @returns taxized study species in input data.table
#' @seealso [rgnparser::gn_parse_tidy()]
review_taxize <- function(DT) {
  DT_in <- DT[, strsplit(.SD[['species']], ';'), by = covidence_number]
  DT_in[, species := trimws(V1)]
  DT_in[, V1 := NULL]

  DT_parse <- gn_parse_tidy(DT_in[, unique(species)])
  setDT(DT_parse)

  DT_out <- merge(
    DT_in,
    DT_parse[, .(verbatim, canonicalsimple, quality)],
    by.x = 'species',
    by.y = 'verbatim'
  )

  # Trim any subspecies etc "Genus species [X Y Z ...]"
  DT_out[, fix_parse := do.call(
    paste,
    tstrsplit(canonicalsimple, ' ', keep = 1:2)
  )]

  message('Trim any rank below species:\n',
          'reducing number of unique species from ',
          DT_out[, uniqueN(canonicalsimple)],
          ' to ',
          DT_out[, uniqueN(fix_parse)])

  # Manually fix species input / parsing output
  DT_out[covidence_number == 1444, fix_parse := 'Papio ursinus']
  DT_out[fix_parse == 'Humans NA', fix_parse := 'Homo sapiens']
  DT_out[grepl('viginianus', fix_parse),
         fix_parse := gsub('viginianus', 'virginianus', fix_parse)]
  DT_out[grepl('heifer', species), fix_parse := 'Bos taurus']
  DT_out[grepl('Holstein|Angus', species), fix_parse := 'Bos taurus']
  DT_out[grepl('horses', species), fix_parse := 'Equus ferus']
  DT_out[grepl('geoffroyi', fix_parse), fix_parse :=
           gsub('geoffroyi', 'geoffroy', fix_parse)]
  DT_out[grepl('Ciconia ciconi', fix_parse), fix_parse := 'Ciconia ciconia']
  DT_out[, .N, fix_parse]

  setDT(DT_out)
  setnames(DT_out,
           c('canonicalsimple', 'quality'),
           c('parsed_species', 'parse_quality'))

  return(DT_out[parse_quality == 1])
}
