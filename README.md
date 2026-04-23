# Extending {spatsoc} to measure intragroup social dynamics

[![DOI](https://zenodo.org/badge/1219321542.svg)](https://doi.org/10.5281/zenodo.19712779)

- Authors:
  - [Alec L. Robitaille](http://robitalec.ca)
  - [Quinn M.R. Webber](https://qwebber.weebly.com/)
  - [Eric Vander Wal](http://weel.gitlab.io)

### Abstract

1. Beyond proximity-based social networks and home range overlap, animal
telemetry data can also be used to measure intragroup social dynamics including
individual position within groups, individual and group level movement
directions, leadership patterns and lagged follower behaviours. 

2. We used a scoping review of literature across domains, including behavioural
ecology, collective movement, and GISciences, to identify widely used metrics
for measuring intragroup social dynamics that are not openly available in the R
programming language.

3. We present a case study illustrating 18 new functions for the R package
{spatsoc} measuring intragroup social dynamics with animal telemetry data.

4. The open availability of these new and flexible functions in {spatsoc} will
allow researchers to easily measure intragroup social dynamics to more
comprehensively measure the multifaceted animal social behaviours in their study
systems.


### Open science

All data and code used to produce figures are available on GitHub at
https://github.com/robitalec/extending-spatsoc-application-paper and on Zenodo
at https://doi.org/10.5281/zenodo.19712779. The data used in this case study are
included with the package and can be read with:

```r
library(spatsoc)
library(data.table)
DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))
```

The code for producing the scoping review results, figures, tables and
manuscript was developed as a reproducible pipeline with the R package {targets}
(Landau, 2021). Figures and tables were constructed using {ggplot2} (Wickham,
2016), {ggdist} (Kay, 2025), {patchwork} (Pedersen, 2025) and {tintytable}
(Arel-Bundock, 2025). The manuscript was produced using {quarto} (Allaire &
Dervieux, 2024). The {spatsoc} package gratefully depends on the R packages
{adehabitatHR} (Calenge, 2024), {data.table} (Barrett et al., 2025), {igraph}
(Csárdi et al., 2026), {sf} (Pebesma, 2018), {lwgeom} (Pebesma, 2025),
{CircStats} (Lund & Agostinelli, 2025), {units} (Pebesma et al., 2016), and
{rlang} (Henry & Wickham, 2026).