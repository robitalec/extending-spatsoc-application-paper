# === Test fission fusion -------------------------------------------------

# Packages ----------------------------------------------------------------
source('R/packages.R')


# Functions ---------------------------------------------------------------
# fusion_id released in {spatsoc} v0.2.4

# Data --------------------------------------------------------------------
n <- 10
DT_allow_split <- data.table(
  ID1 = rep('A', n),
  ID2 = rep('B', n),
  timegroup = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
  distance = c(0, 0, 0, 0, 50, 0, 0, 0, 0, 0)
)
DT_allow_split <- rbindlist(list(
  DT_allow_split,
  DT_allow_split[, .(ID1 = ID2, ID2 = ID1, timegroup, distance)]
))
dyad_id(DT_allow_split, 'ID1', 'ID2')


DT_match_query_bug <- data.table(
  ID1 = rep('A', 11),
  ID2 = rep('B', 11),
  timegroup = c(0, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14),
  distance = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
)
DT_match_query_bug <- rbindlist(list(
  DT_match_query_bug,
  DT_match_query_bug[, .(ID1 = ID2, ID2 = ID1, timegroup, distance)]
))
dyad_id(DT_match_query_bug, 'ID1', 'ID2')

DT_simplest <- data.table(
  ID1 = rep('A', 8),
  ID2 = rep('B', 8),
  timegroup = c(1, 4, 5, 6, 7, 8, 9, 10),
  distance = c(0, 0, 0, 0, 0, 100, 0, 0)
)
DT_simplest <- rbindlist(list(
  DT_simplest,
  DT_simplest[, .(ID1 = ID2, ID2 = ID1, timegroup, distance)]
))
dyad_id(DT_simplest, 'ID1', 'ID2')


# Test --------------------------------------------------------------------

# If all distances except one are within the threshold distance,
#  and allow split is true, there should be only one fusion ID
expect_equal(
  uniqueN(
    fusion_id(copy(DT_allow_split), threshold = 25, allow_split = TRUE)$fusionID
  ),
  1
)

# If all distances except one are within the threshold distance,
#  and allow split is false, there should be more than one fusion ID
expect_gt(
  uniqueN(
    fusion_id(
      copy(DT_allow_split),
      threshold = 25,
      allow_split = FALSE
    )$fusionID
  ),
  1
)


fusion_id(
  edges = DT_match_query_bug,
  threshold = 50,
  n_min_length = 3,
  n_max_missing = 1,
  allow_split = TRUE
)
DT_match_query_bug[ID1 == 'A']


fusion_id(
  DT_simplest,
  threshold = 50,
  n_min_length = 1,
  n_max_missing = 1,
  allow_split = FALSE
)[ID1 == 'A']

fusion_id(
  DT_simplest,
  threshold = 50,
  n_min_length = 1,
  n_max_missing = 1,
  allow_split = FALSE
)[ID1 == 'A']
