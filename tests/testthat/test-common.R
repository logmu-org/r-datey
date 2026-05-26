# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# c.datey <- function(..., recursive = FALSE) ==================================================
test_that("`c()` on `datey`", {

  na_1 <- NA_datey_
  na_2 <- from_ymdf(0999, 12, 31, 1459/1460, strict = FALSE)
  na_3 <- from_ymdf(3000, 01, 01, 1/1464, strict = FALSE)

  d_1 <- from_ymdf(1000, 01, 01, 0.00)
  d_2 <- from_ymdf(2020, 05, 23, 0.4567)
  d_3 <- from_ymdf(2999, 12, 31, 0.9993)

  vd_4 <- from_ymdf(1800:1802, 07, 01, 0)
  d_4a <- from_ymdf(1800, 07, 01, 0)
  d_4b <- from_ymdf(1801, 07, 01, 0)
  d_4c <- from_ymdf(1802, 07, 01, 0)

  expect_identical(is_datey(c(d_1)), TRUE)
  expect_identical(is_datey(c(d_2, d_1)), TRUE)
  expect_identical(is_datey(c(d_3, d_2, d_1)), TRUE)
  expect_identical(is_datey(c(na_1)), TRUE)
  expect_identical(is_datey(c(na_2, na_1)), TRUE)
  expect_identical(is_datey(c(na_3, na_2, na_1)), TRUE)
  expect_identical(is_datey(c(na_1, d_2, d_3)), TRUE)
  expect_identical(is_datey(c(d_1, na_2, d_3)), TRUE)

  expect_identical(c(d_1, vd_4, d_2), c(d_1, d_4a, d_4b, d_4c, d_2))

  expect_identical(c(datey(2001:2019), datey("2020-01-01.0"), datey(2021:2030)), datey(2001:2030))
})

# c.durationy <- function(..., recursive = FALSE) ==================================================
test_that("`c()` on `durationy`", {

  na_1 <- NA_durationy_
  na_2 <- durationy(2000.1, strict = FALSE)
  na_3 <- durationy(-9999L, strict = FALSE)

  d_1 <- durationy(0)
  d_2 <- durationy(1.4567)
  d_3 <- durationy(-100.1234)

  vd_4 <- durationy(10:12)
  d_4a <- durationy(10)
  d_4b <- durationy(11)
  d_4c <- durationy(12)

  expect_identical(is_durationy(c(d_1)), TRUE)
  expect_identical(is_durationy(c(d_2, d_1)), TRUE)
  expect_identical(is_durationy(c(d_3, d_2, d_1)), TRUE)
  expect_identical(is_durationy(c(na_1)), TRUE)
  expect_identical(is_durationy(c(na_2, na_1)), TRUE)
  expect_identical(is_durationy(c(na_3, na_2, na_1)), TRUE)
  expect_identical(is_durationy(c(na_1, d_2, d_3)), TRUE)
  expect_identical(is_durationy(c(d_1, na_2, d_3)), TRUE)

  expect_identical(c(d_1, vd_4, d_2), c(d_1, d_4a, d_4b, d_4c, d_2))

  expect_identical(c(durationy(1:19), durationy("20 yr"), durationy(21:30)), durationy(1:30))
})

# `[.datey` <- function(x, i, ...) ==================================================
# `[<-.datey` <- function(x, i, value, ...) ==================================================
test_that("`[.datey` and `[<-.datey`", {

  d_1 <- from_ymdf(1000, 01, 01, 0.00)
  d_2 <- from_ymdf(1999, 12, 31, 0.5)
  d_3 <- from_ymdf(2020, 05, 23, 0.4567)
  d_4 <- from_ymdf(2999, 12, 31, 0.9993)

  d_5 <- start_day(2000, 1, 5)
  d_6 <- start_day(2000, 1, 6)

  x <- c(d_1, d_2, d_3, d_4)

  expect_identical(x[c(1,4)], c(d_1, d_4))
  expect_identical(x[2:3], c(d_2, d_3))
  expect_identical(x[c(TRUE, FALSE, TRUE, FALSE)], c(d_1, d_3))

  y <- x
  y[2:3] <- c(d_5, d_6)
  expect_identical(y, c(d_1, d_5, d_6, d_4))
})

# `[.durationy` <- function(x, i, ...) ==================================================
# `[<-.durationy` <- function(x, i, value, ...) ==================================================
test_that("`[.durationy` and `[<-.durationy`", {

  d_1 <- durationy(0)
  d_2 <- durationy(1.4567)
  d_3 <- durationy(-100.1234)
  d_4 <- durationy(3.14159)

  d_5 <- durationy(5)
  d_6 <- durationy(6)

  x <- c(d_1, d_2, d_3, d_4)

  expect_identical(x[c(1,4)], c(d_1, d_4))
  expect_identical(x[2:3], c(d_2, d_3))
  expect_identical(x[c(TRUE, FALSE, TRUE, FALSE)], c(d_1, d_3))

  y <- x
  y[2:3] <- c(d_5, d_6)
  expect_identical(y, c(d_1, d_5, d_6, d_4))
})
