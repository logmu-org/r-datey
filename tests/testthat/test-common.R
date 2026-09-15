# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# c.datey <- function(..., recursive = FALSE) ==================================================
test_that("`c()` on `datey`", {

  na_1 <- NA_datey_
  na_2 <- datey(0999, 12, 31, 1459/1460, strict = FALSE)
  na_3 <- datey(3000, 01, 01, 1/1464, strict = FALSE)

  d_1 <- datey(1000, 01, 01, 0.00)
  d_2 <- datey(2020, 05, 23, 0.4567)
  d_3 <- datey(2999, 12, 31, 0.9993)

  vd_4 <- datey(1800:1802, 07, 01, 0)
  d_4a <- datey(1800, 07, 01, 0)
  d_4b <- datey(1801, 07, 01, 0)
  d_4c <- datey(1802, 07, 01, 0)

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

  d_1 <- datey(1000, 01, 01, 0.00)
  d_2 <- datey(1999, 12, 31, 0.5)
  d_3 <- datey(2020, 05, 23, 0.4567)
  d_4 <- datey(2999, 12, 31, 0.9993)

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

# seq.datey ==================================================
test_that("seq.datey", {

  actual <- seq(from = datey(2000), to = datey(2005), by = durationy(2))
  expected <- c(datey(2000), datey(2002), datey(2004))
  expect_identical(actual, expected)
})
# seq.durationy ==================================================
test_that("seq.durationy", {

  actual <- seq(from = durationy(1), to = durationy(2), by = durationy(0.5))
  expected <- c(durationy(1), durationy(1.5), durationy(2))
  expect_identical(actual, expected)
})

# rep.datey ==================================================
test_that("rep.datey", {

  d_1 <- datey(2001, 03, 04, 0.25)
  d_2 <- datey(2002, 05, 06, 0.5)
  d_3 <- datey(2003, 07, 08, 0.75)

  x <- c(d_1, d_2, d_3)

  expect_identical(rep(x, 2), c(d_1, d_2, d_3, d_1, d_2, d_3))
  expect_identical(rep(x, each = 2), c(d_1, d_1, d_2, d_2, d_3, d_3))
  expect_identical(rep(x, times = 2, each = 2), c(d_1, d_1, d_2, d_2, d_3, d_3, d_1, d_1, d_2, d_2, d_3, d_3))
  expect_identical(rep(x, times = 1:3), c(d_1, d_2, d_2, d_3, d_3, d_3))
  expect_identical(rep(x, length.out = 5), c(d_1, d_2, d_3, d_1, d_2))
  expect_identical(rep(x, length.out = 2), c(d_1, d_2))
  expect_identical(rep(x, 0), datey(integer(0)))

  # `rep_len()` and `rep.int()` fall back to `rep()` dispatch since R 4.0.0
  expect_identical(rep_len(x, 5), c(d_1, d_2, d_3, d_1, d_2))
  expect_identical(rep.int(x, 2), c(d_1, d_2, d_3, d_1, d_2, d_3))

  expect_identical(rep(NA_datey_, 2), c(NA_datey_, NA_datey_))

  # Names are preserved
  named <- c(a = d_1, b = d_2)
  expect_identical(names(rep(named, 2)), c("a", "b", "a", "b"))
  expect_identical(unname(rep(named, 2)), c(d_1, d_2, d_1, d_2))
})

# pmax()/pmin() on datey rely on rep.datey for recycling ==================================================
test_that("`pmax()` and `pmin()` on `datey` with recycling", {

  x <- datey(2001:2003)

  expect_identical(pmax(x, datey(2002)), datey(c(2002, 2002, 2003)))
  expect_identical(pmin(x, datey(2002)), datey(c(2001, 2002, 2002)))
  expect_identical(pmax(datey(2002), x), datey(c(2002, 2002, 2003)))
  expect_identical(pmin(datey(2002), x), datey(c(2001, 2002, 2002)))

  na <- datey(c(2001, NA, 2003))
  expect_identical(pmax(na, datey(2002)), datey(c(2002, NA, 2003)))
  expect_identical(pmax(na, datey(2002), na.rm = TRUE), datey(c(2002, 2002, 2003)))
})

# rep.durationy ==================================================
test_that("rep.durationy", {

  d_1 <- durationy(0)
  d_2 <- durationy(1.4567)
  d_3 <- durationy(-100.1234)

  x <- c(d_1, d_2, d_3)

  expect_identical(rep(x, 2), c(d_1, d_2, d_3, d_1, d_2, d_3))
  expect_identical(rep(x, each = 2), c(d_1, d_1, d_2, d_2, d_3, d_3))
  expect_identical(rep(x, times = 1:3), c(d_1, d_2, d_2, d_3, d_3, d_3))
  expect_identical(rep(x, length.out = 5), c(d_1, d_2, d_3, d_1, d_2))
  expect_identical(rep(x, 0), durationy(integer(0)))

  expect_identical(rep_len(x, 5), c(d_1, d_2, d_3, d_1, d_2))
  expect_identical(rep.int(x, 2), c(d_1, d_2, d_3, d_1, d_2, d_3))

  expect_identical(rep(NA_durationy_, 2), c(NA_durationy_, NA_durationy_))

  expect_identical(pmax(x, durationy(1)), c(durationy(1), d_2, durationy(1)))
  expect_identical(pmin(x, durationy(1)), c(d_1, durationy(1), d_3))
})

# rep.datey_interval ==================================================
test_that("rep.datey_interval", {

  i_1 <- 2001 %to% 2002
  i_2 <- 2003 %to% 2005
  i_3 <- datey(2006, 07, 08, 0.5) %to% datey(2009, 10, 11, 0.25)

  x <- c(i_1, i_2, i_3)

  expect_identical(rep(x, 2), c(i_1, i_2, i_3, i_1, i_2, i_3))
  expect_identical(rep(x, each = 2), c(i_1, i_1, i_2, i_2, i_3, i_3))
  expect_identical(rep(x, times = 1:3), c(i_1, i_2, i_2, i_3, i_3, i_3))
  expect_identical(rep(x, length.out = 5), c(i_1, i_2, i_3, i_1, i_2))

  expect_identical(rep_len(x, 5), c(i_1, i_2, i_3, i_1, i_2))
  expect_identical(rep.int(x, 2), c(i_1, i_2, i_3, i_1, i_2, i_3))

  expect_identical(rep(NA_datey_interval_, 2), c(NA_datey_interval_, NA_datey_interval_))
})
