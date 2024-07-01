# https://stackoverflow.com/a/7869457
delta_rad <- function(target, source,  signed = FALSE) {
  d <- source - target
  d <- (d + pi) %% (2 * pi) - pi
  if (signed) {
    return(d)
  } else {
    return(abs(d))
  }
}

expect_equal(delta_rad(0.1, 0.2, TRUE), 0.1)
expect_equal(delta_rad(0.1, 0.2 + 2 * pi, TRUE), 0.1)
expect_equal(delta_rad(0.1, 0.2 - 2 * pi, TRUE), 0.1)
expect_equal(delta_rad(0.1 + 2 * pi, 0.2, TRUE), 0.1)
expect_equal(delta_rad(0.1 - 2 * pi, 0.2, TRUE), 0.1)
expect_equal(delta_rad(0.2, 0.1, TRUE), -0.1)
expect_equal(delta_rad(0.2 + 2 * pi, 0.1, TRUE), -0.1)
expect_equal(delta_rad(0.2 - 2 * pi, 0.1, TRUE), -0.1)
expect_equal(delta_rad(0.2, 0.1 + 2 * pi, TRUE), -0.1)
expect_equal(delta_rad(0.2, 0.1 - 2 * pi, TRUE), -0.1)

