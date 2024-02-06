taxize_studies <- function(DT) {
  DT_in <- DT[, strsplit(.SD[['species']], ';'), by = covidence_number]
  DT_in[, species := trimws(V1)]
  DT_in[, V1 := NULL]

  # Field 	Meaning
  # Id 	UUID v5 generated out of Verbatim
  # Verbatim 	Input name-string without any changes
  # Cardinality 	0 - N/A, 1 - Uninomial, 2 - Binomial etc.
  # CanonicalStem 	Simplest canonical form with removed suffixes
  # CanonicalSimple 	Simplest canonical form
  # CanonicalFull 	Canonical form with hybrid sign and ranks
  # Authors 	Authorship of a name
  # Year 	Year of the name (if given)
  # Quality 	Parsing quality
  DT_parse <- gn_parse_tidy(DT_in[, unique(species)])
  setDT(DT_parse)

  DT_out <- merge(
    DT_in,
    DT_parse[, .(verbatim, canonicalsimple, quality)],
    by.x = 'species',
    by.y = 'verbatim'
  )
