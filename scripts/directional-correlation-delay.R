# https://static-content.springer.com/esm/art%3A10.1038%2Fnature08891/MediaObjects/41586_2010_BFnature08891_MOESM272_ESM.pdf


# https://www.zora.uzh.ch/id/eprint/9627/10/2008_Dodge_etal_IV_2008_MoveAnalysisTaxonomy_preprint.pdf
# https://cran.r-project.org/web/packages/collapse/collapse.pdf

library(data.table)
library(ggplot2)
library(sf)
library(lwgeom)


calc_az <- function(DT) {
  DT[, az := c(
    units::drop_units(
      lwgeom::st_geod_azimuth(st_as_sf(.SD, coords = c('x', 'y'), crs = 4326))),
    NA), by = id]
}

shift_window <- function(x, size) {
  c(
    shift(x, n = size, type = 'lead'),
    x,
    shift(x, n = size, type = 'lag')
  )
}


shift_window(c(1, 2, 3, 4, 5), 2)

abs_diff_rad <- function(x,  y) {
  d <- abs(x - y)
  fifelse(d > 2 * pi | is.na(d), d - (2 * pi), d)
}

calc_dir_corr_delay <- function(DT, window = 5) {
  calc_az(DT)
  dyads <- CJ(
    ID1 = unique(DT$id),
    ID2 = unique(DT$id),
    tg = unique(DT$timegroup)
  )[ID1 != ID2]

  calc_closest_az <- function(dyad_DT, locs_DT, window) {
    dyad_DT[, .(tg_delay = which.min(abs_diff_rad(
      locs_DT[.SD, az, on = .(id == ID1, timegroup == tg)],
      locs_DT[id == ID2 & between(timegroup, tg - window, tg + window), az]
    )) - window - 1L),
    by = .(ID1, ID2), .SDcols = colnames(dyad_DT)]
  }
  dyads[, calc_closest_az(.SD, DT, window),
        by = tg,
        .SDcols = colnames(dyads)]
}

calc_dir_corr_delay_zz <- function(DT, window = 5) {
  calc_az(DT)


# -------------------------------------------------------------------------
  dyads <- CJ(ID1 = unique(DT$id), ID2 = unique(DT$id))[ID1 != ID2]
  dyads[, tg := 5]
  dyads[DT, focal_az := az, on = .(ID1 == id, tg == timegroup)]
  # dyads[, closest_az := DT[id == ID2 &
  #              between(timegroup, tg - window, tg + window),
  #            which.min(abs(focal_az - az))],
  #       by = .(ID1, ID2)]
  dyads[, closest_az_with_f := DT[id == ID2 &
                             between(timegroup, tg - window, tg + window),
                           which.min(abs_diff_rad(focal_az, az))],
        by = .(ID1, ID2)]
  dyads[, adj_closest := closest_az_with_f  - window - 1]
# -------------------------------------------------------------------------


  dyads

  spatsoc::group_times(DT, 'datetime')
  # DT[sample(.N, 5), c('x', 'y') := NA]
  dyads <- CJ(ID1 = unique(DT$id), ID2 = unique(DT$id), tg = unique(DT$timegroup))[ID1 != ID2]
  window <- 2
  calc_closest_az <- function(dyad_DT, locs_DT, window) {
    dyad_DT <- copy(dyad_DT)
    dyad_DT[locs_DT, focal_az := az, on = .(ID1 == id, tg == timegroup)]
    dyad_DT[, closest_az_with_f :=
              locs_DT[id == ID2 & between(timegroup, tg - window, tg + window),
                      which.min(abs_diff_rad(focal_az, az))],
            by = .(ID1, ID2)]
    return(dyad_DT)
  }
  dyads[tg == 5, calc_closest_az(.SD, DT, window)[]]
  # .SD locked i by timegroup, works if copy
  dyads[, calc_closest_az(.SD, DT, window), by = tg, .SDcols = colnames(dyads)]


  calc_closest_az <- function(dyad_DT, locs_DT, window) {
    dyad_DT[, which.min(abs_diff_rad(
      locs_DT[.SD, az, on = .(id == ID1, timegroup == tg)],
      locs_DT[id == ID2 & between(timegroup, tg - window, tg + window), az]
    )) - window - 1L,
    by = .(ID1, ID2), .SDcols = colnames(dyad_DT)]
  }
  calc_closest_az(dyads[tg == 5], DT, window)
  dyads[, calc_closest_az(.SD, DT, window),
        by = tg,
        .SDcols = colnames(dyads)]

  # TODO: dyads[, adj_closest := closest_az_with_f  - window - 1]



  # TODO: check where 2 pi differs
  # TODO: timing, improve
  # TODO: build into timegroup, maybe by building dyad * timegroup set



  # TODO: switch datetime to group_times
  cast <- dcast(DT, datetime ~ id, value.var = 'az')
  spatsoc::group_times(cast, 'datetime')


  cast[between(timegroup, i - window, i + window),
       .SD,
       .SDcols = -c('datetime', 'timegroup')]

  merge(dyads, DT[, .(id, az)], by.x = 'ID2', by.y = 'id', allow.cartesian = TRUE)
  dyads[DT,
        # [between(timegroup, 5 - window, 5 + window)],
        # which_min_diff := which.min(focal_az - az),
        ls_min_diff := list(list(focal_az - az,
                                 id)
                            ),
        # {print(focal_az - az);rep(1, .N)},
           on = .(ID2 == id, low_timegroup >= timegroup, high_timegroup <= timegroup)]

  # for each timegroup
  # make matrix of timegroup - window to timegroup to timegroup + window
  # rename cols/rows to index timegroup - window to timegroup + window
  # for each direction + dyad, find min diff
  # return timegroup diff

  i <- 5
  window <- 2

  # to grab focal row: .SD[median(.I)]

  cast[timegroup == i,
       .SD,
       .SDcols = -c('datetime', 'timegroup')]

  cast[between(timegroup, i - window, i + window),
       .SD,
       .SDcols = -c('datetime', 'timegroup')]

  cast[between(timegroup, i - window, i + window),
       {
         dist(.SD, upper = TRUE, diag = FALSE) |> print();
         pmin(.SD) |> print();
         pmin(t(.SD))
       },
       .SDcols = -c('datetime', 'timegroup')]

  #




  # cast[cast, on = .(datetime = between(datetime, datetime - window, datetime + window))]
  # cast[3 + seq(-2, 2),
  #      fdiff(c(A,  B))]

  # data.table roll nearest

  frollapply(cast[, .(A, B)], 2, FUN = function(x) x$A - x$B)


  nms <- setdiff(colnames(cast), 'datetime')
  cast[3:5, (.SD), .SDcols = -'datetime']
  # https://stackoverflow.com/questions/19933788/r-compare-all-the-columns-pairwise-in-matrix
  # https://stats.stackexchange.com/questions/600794/how-to-make-a-pairwise-correlation-matrix-including-interaction-with-a-third-var

  which.min(cast[5, A] - cast[, t(B)])

  only_pos <- function(x) {x[x <= 0] <- NA; x}

  cast[, A] - cast[only_pos(seq.int(.N) - 2), B]
  cast[, A] - cast[only_pos(seq.int(.N) - 1), B]
  cast[, A] - cast[only_pos(seq.int(.N)), B]
  cast[, A] - cast[only_pos(seq.int(.N) + 1), B]
  cast[, A] - cast[only_pos(seq.int(.N) + 2), B]

  lapply(unique(cast$datetime), FUN = function(i) {
    which_i <- which(cast$datetime == i)
    which_b <- which_i + seq(-window, window)

    cast[which_i, A] -
      cast[, B[which_b[which_b > 0]]]
  })


  cast

  D(cast, cols = function(x) x$A[3] - x$B[seq(-3, 3)])

  as.matrix(cast[, .(A, B)])

  c(-2, 3, 4) - 2

  cast[5, which.min(flag(B, seq(-2, 2)) - A)]

  cast[5, A] - flag(cast$B, seq(-2, 2))


  dapply()

  TRA(cast,
      STATS = ,
      FUN = "-",
      )

  cast[, shift(A, seq(-window, window))]
  cast[, A] %r-% cast[, shift(B, seq(-window, window))]

  cast[, A - B]
  # TODO: ensure sort by datetime?


  # https://stackoverflow.com/questions/24520720/subtract-a-constant-vector-from-each-row-in-a-matrix-in-r
  # {collapse}
  # lapply(seq.int(window), function(i) {
  #   lapply(unique(DT$id), function(focal) {
  #     cast[, , env = .()]
  #   })
  # })

  # roll?

  # focal <- 'A'

  # seq(-window, window)
  # which.max
  #
  # sweep(cast[, .(B)], MARGIN = 1, FUN = sum)
  #
  # cast[, A %-% B]
  #
  # A <- cast$A
  # t(t(cast$B)) - A
  #
  # cast
  #
  # cast[, matrix(shift(.SD, n = c(-3, -2, -1, 0, 1, 2, 3))),
  #      # env = list(focal = focal),
  #      .SDcols = 'B']
  #      # .SDcols = -c('datetime', focal)]


  # DT[, diff := as.numeric(dist(az)), by = datetime]
  # DT[, min_diff := diff == min(diff, na.rm = TRUE)]

  # TODO: figure out directionality

  # TODO: extend to 3
  # TODO: extend to exclude based on distance, or is this based on
  #       group_times -> group_pts -> runs of groups together -> calc dirr cor delay

  # Troubleshooting:
  # Error in set(x, j = name, value = value) :
  # Supplied 9 items to be assigned to 10 items of column 'az'. If you wish to 'recycle' the RHS please use rep() to make this intent clear to readers of your code.
  # ^ Related to units and st_geod_azimuth dropping last instead of returning NA
  # ^ Related: https://github.com/r-quantities/units/issues/163
}


n <- 30
n_id <- 3
DT <- data.table(
  x = -88 + rexp(n),
  y = 55 + rexp(n),
  id = LETTERS[seq.int(n_id)],
  i = rep(seq.int(n / n_id), each = n_id, from = 1, to = n / n_id)
)
DT[, datetime := seq.POSIXt(
  as.POSIXct('2022-01-01 10:00:00'),
  as.POSIXct('2022-01-02 10:00:00'),
  length.out = .N),
  by = id
]

calc_az(DT)
print(DT)

DT[, diff := as.numeric(dist(az)), by = datetime]

g <- ggplot(DT) +
  geom_path(aes(x, y, color = id, group = id), arrow = arrow()) +
  ggrepel::geom_text_repel(
    aes(x, y,
        label = ifelse(is.na(diff), "", sprintf("%.2f", diff))),
    min.segment.length = 100) +
  geom_point(aes(x, y, size = 1 / diff), na.rm = TRUE)  +
  theme_bw() +
  guides(size = 'none', color = 'none')

plot(g)


DT_test_A <- data.table(
  x = c(0, -10, 0, 10, 5),
  y = c(0, 10, 20, 10, 5),
  id =  'A'
)
DT_test_A[, datetime := seq.POSIXt(
  as.POSIXct('2022-01-01 10:00:00'),
  as.POSIXct('2022-01-02 10:00:00'),
  length.out = .N),
  by = id
]
spatsoc::group_times(DT_test_A, 'datetime')
DT_test_A[, datetime := NULL]
DT_test <- rbindlist(list(
  DT_test_A,
  DT_test_A[, .(x, y, timegroup = shift(timegroup, 0, type = 'cyclic'), id = 'B')],
  DT_test_A[, .(x, y, timegroup = shift(timegroup, -1, type = 'cyclic'), id = 'C')],
  DT_test_A[, .(x, y, timegroup = shift(timegroup, 1, type = 'cyclic'), id = 'D')],
  DT_test_A[, .(x, y, timegroup = shift(timegroup, 2, type = 'cyclic'), id = 'E')]
), use.names = TRUE)
setorder(DT_test, timegroup)
# DT_test <- na.omit(DT_test)#[datetime %in% na.omit(DT_test)[, .N, datetime][N == 3, datetime]]
calc_dir_corr_delay(DT_test, window  = 1)[ID1 == 'A']
# Error in st_as_sf.data.frame(.SD, coords = c("x", "y"), crs = 4326) :
  # missing values in coordinates not allowed
g <- ggplot(DT_test) +
  geom_path(aes(x, y, color = id, group = id), arrow = arrow()) +
  geom_label(aes(x, y, label = timegroup)) +
  theme_bw() +
  facet_wrap(~id)
  # guides(size = 'none', color = 'none')
print(g)

