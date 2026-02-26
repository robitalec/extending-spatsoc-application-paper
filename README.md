# spatsoc-paper-2
<!-- TODO: fix title --> 

<!-- TODO: [![DOI](https://zenodo.org/badge/.svg)](https://zenodo.org/badge/latestdoi/) -->



- Authors:
  - [Alec L. Robitaille](http://robitalec.ca)
  - [Quinn M.R. Webber](https://qwebber.weebly.com/)
  - [Eric Vander Wal](http://weel.gitlab.io)

<!-- TODO: links -->

### Abstract

<!-- TODO: abstract -->


### Open science

All data and code used to produce figures are available on GitHub at <!-- TODO: link --> and on Zenodo at <!-- TODO: link-->. The data used in this case study are included with the package and can be imported with:

```r
library(spatsoc)
library(data.table)
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))
```

The code for producing the scoping review results, figures, tables and manuscript was developed as a reproducible pipeline with the R package {targets} (Landau, 2021). Figures and tables were constructed using {ggplot2} (Wickham, 2016), {ggdist} (Kay, 2025), {patchwork} (Pedersen, 2025) and {tintytable} (Arel-Bundock, 2025). The manuscript was produced using {quarto} (Allaire & Dervieux, 2024). The {spatsoc} package gratefully depends on the R packages {adehabitatHR} (Calenge, 2024), {data.table} (Barrett et al., 2025), {igraph} (Csárdi et al., 2026), {sf} (Pebesma, 2018), {lwgeom} (Pebesma, 2025), {CircStats} (Lund & Agostinelli, 2025), {units} (Pebesma et al., 2016), and {rlang} (Henry & Wickham, 2026).