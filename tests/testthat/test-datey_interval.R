# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# datey_interval constants ==================================================
test_that("`NA_datey_interval_` is a `datey`", expect_identical(is_datey_interval(NA_datey_interval_), TRUE))
test_that("`NA_datey_interval_` is NA", expect_identical(is.na(NA_datey_interval_), TRUE))
test_that("`all_of_time`", expect_identical(all_of_time, datey_interval(valid_years_start,valid_years_end)))

# is_datey_interval <- function(x) ==================================================
test_that("`is_datey_interval()`", {

  t_1 <- start_day(2001, 1, 1)
  t_2 <- start_day(2002, 2, 2)
  interval <- datey_interval(t_1, t_2)

  expect_identical(is_datey_interval(NA_datey_interval_), TRUE)
  expect_identical(is_datey_interval(datey_interval(t_1, t_2)), TRUE)
  expect_identical(is_datey_interval(t_1 %to% t_2), TRUE)
})


# datey_interval ==================================================
test_that("`datey_interval()`, `%to%`, $start and $end", {

  t_1 <- start_day(2001, 1, 1)
  t_2 <- start_day(2002, 2, 2)
  t_3 <- start_day(2003, 3, 3)
  t_4 <- start_day(2004, 4, 4)
  interval <- datey_interval(t_1, t_2)
  intervals <- datey_interval(c(t_1, t_3), c(t_2, t_4))
  intervals_same_start <- datey_interval(t_1, c(t_2, t_4))
  intervals_same_end <- datey_interval(c(t_1, t_3), t_2)

  expect_identical(t_1 %to% t_2, interval)

  expect_identical(interval$start, t_1)
  expect_identical(interval$end, t_2)

  expect_identical(intervals$start, c(t_1, t_3))
  expect_identical(intervals$end, c(t_2, t_4))

  expect_identical(intervals_same_start$start, c(t_1, t_1))
  expect_identical(intervals_same_start$end, c(t_2, t_4))

  expect_identical(intervals_same_end$start, c(t_1, t_3))
  expect_identical(intervals_same_end$end, c(t_2, t_2))

  expect_identical(NA_datey_interval_$start, NA_datey_)
  expect_identical(NA_datey_interval_$end, NA_datey_)
})

# `datey_interval` is.NA / anyNA ==================================================
test_that("`datey_interval` is.NA / anyNA", {
  valid <- datey(1999) %to% datey(2000)

  expect_identical(is.na(valid), FALSE)
  expect_identical(anyNA(valid), FALSE)
  expect_identical(is.na(NA_datey_interval_), TRUE)
  expect_identical(anyNA(NA_datey_interval_), TRUE)

  # 4×
  expect_identical(is.na(c(valid, NA_datey_interval_, valid, NA_datey_interval_)), c(FALSE, TRUE, FALSE, TRUE))
  expect_identical(anyNA(c(valid, NA_datey_interval_, valid, NA_datey_interval_)), TRUE)
  expect_identical(anyNA(c(valid, valid, valid, valid)), FALSE)
})

# is_collapsed / is_proper ==================================================
test_that("`datey_interval` is_collapsed / is_proper", {
  a <- datey(1999)
  b <- datey(2000)

  content <- a %to% b
  empty <- a %to% a
  improper <- b %to% a


  expect_identical(is_proper(content), TRUE)
  expect_identical(is_proper(empty), TRUE)
  expect_identical(is_proper(improper), FALSE)
  expect_identical(is_proper(NA_datey_interval_), FALSE)

  # 4×
  expect_identical(is_proper(c(content, empty, improper, NA_datey_interval_)), c(TRUE, TRUE, FALSE, FALSE))
  expect_identical(all_proper(c(content, empty, improper, NA_datey_interval_)), FALSE)
  expect_identical(all_proper(c(content, empty, improper, content)), FALSE)
  expect_identical(all_proper(c(content, empty, empty, NA_datey_interval_)), FALSE)
  expect_identical(all_proper(c(content, empty, NA_datey_interval_, content)), FALSE)
  expect_identical(all_proper(c(content, empty, content, empty)), TRUE)

  expect_identical(is_collapsed(content), FALSE)
  expect_identical(is_collapsed(empty), TRUE)
  expect_identical(is_collapsed(improper), TRUE)
  expect_identical(is_collapsed(NA_datey_interval_), TRUE)

  # 4×
  expect_identical(is_collapsed(c(content, empty, improper, NA_datey_interval_)), c(FALSE, TRUE, TRUE, TRUE))

  expect_identical(all_collapsed(c(content, empty, improper, NA_datey_interval_)), FALSE)
  expect_identical(all_collapsed(c(empty, empty, improper, NA_datey_interval_)), TRUE)
  expect_identical(all_collapsed(c(empty, empty, empty, empty)), TRUE)
  expect_identical(all_collapsed(c(improper, improper, improper, improper)), TRUE)
  expect_identical(all_collapsed(c(NA_datey_interval_, NA_datey_interval_, NA_datey_interval_, NA_datey_interval_)), TRUE)

  expect_identical(any_collapsed(c(content, empty, improper, NA_datey_interval_)), TRUE)
  expect_identical(any_collapsed(c(content, content, content, content)), FALSE)
  expect_identical(any_collapsed(c(content, empty, content, content)), TRUE)
  expect_identical(any_collapsed(c(content, content, improper, content)), TRUE)
  expect_identical(any_collapsed(c(content, content, content, NA_datey_interval_)), TRUE)
})

# interval_includes / %includes% ==================================================
test_that("interval_includes / %includes%", {
  pre <- from_ymdf(1999, 12, 31, 1 - 1/1464)
  start <- datey(2000)
  mid <- datey(2001)
  end <- datey(2002)
  post <- from_ymdf(2002, 1, 1, 1/1464)

  interval <- start %to% end

  expect_identical(interval %includes% NA_datey_, FALSE)
  expect_identical(interval %includes% pre, FALSE)
  expect_identical(interval %includes% start, TRUE)
  expect_identical(interval %includes% mid, TRUE)
  expect_identical(interval %includes% end, FALSE)
  expect_identical(interval %includes% post, FALSE)

  # 1 × interval, 4 × value
  expect_identical(interval %includes% c(NA_datey_, pre, start, mid, end, post), c(FALSE, FALSE, TRUE, TRUE, FALSE, FALSE))
  # 4 × interval, 2 × value
  expect_identical(c(start %to% start, start %to% end, pre %to% start, mid %to% end) %includes% c(start, mid), c(FALSE, TRUE, FALSE, TRUE))
})

# format.datey_interval <- function(x, include_day_fraction = TRUE, ...) ==================================================
test_that("`format.datey_interval()` on NA", {

  expect_identical(format(NA_datey_interval_), NA_character_)
})
test_that("`format.datey_interval()`", {

  t_1 <- start_day(2001, 1, 1)
  t_2 <- start_day(2002, 2, 2)
  interval <- datey_interval(t_1, t_2)

  expect_identical(format(interval), "[2001-01-01.0, 2002-02-02.0)")
  expect_identical(format(interval, include_day_fraction = FALSE), "[2001-01-01, 2002-02-02)")
})

# print.datey <- function(x, include_day_fraction = TRUE, max = NULL, ...) ==================================================
# NO EXPLICIT TEST

