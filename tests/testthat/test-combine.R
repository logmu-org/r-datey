# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# c.datey <- function(..., recursive = FALSE) ==================================================
test_that("`c()` on `datey`", {

  na_1 <- NA_datey_
  na_2 <- point_in_day(0999, 12, 31, 1.00, strict = FALSE)
  na_3 <- point_in_day(3000, 01, 01, 0.00, strict = FALSE)

  d_1 <- point_in_day(1000, 01, 01, 0.00)
  d_2 <- point_in_day(2020, 05, 23, 0.4567)
  d_3 <- point_in_day(2999, 12, 31, 0.9993)

  vd_4 <- point_in_day(1800:1802, 07, 01, 0)
  d_4a <- point_in_day(1800, 07, 01, 0)
  d_4b <- point_in_day(1801, 07, 01, 0)
  d_4c <- point_in_day(1802, 07, 01, 0)

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

