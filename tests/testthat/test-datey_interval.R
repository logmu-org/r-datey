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

  a <- datey(1000 + 0:9 * 100.123) # [1000.0, ...)
  b <- datey(3000 - 0:9 * 100.567) # (..., 3000.0]

  interval <- datey_interval(t_1, t_2)
  intervals <- datey_interval(c(t_1, t_3), c(t_2, t_4))
  intervals_same_start <- datey_interval(t_1, c(t_2, t_4))
  intervals_same_end <- datey_interval(c(t_1, t_3), t_4)
  interval_ab <- datey_interval(a, b)

  expect_identical(t_1 %to% t_2, interval)
  expect_identical(interval$start, t_1)
  expect_identical(interval$end, t_2)
  expect_identical(interval$duration, t_2 - t_1)
  expect_identical(durationy(interval), t_2 - t_1)

  expect_identical(intervals$start, c(t_1, t_3))
  expect_identical(intervals$end, c(t_2, t_4))
  expect_identical(intervals$duration, c(t_2, t_4) - c(t_1, t_3))
  expect_identical(durationy(intervals), c(t_2, t_4) - c(t_1, t_3))

  expect_identical(intervals_same_start$start, c(t_1, t_1))
  expect_identical(intervals_same_start$end, c(t_2, t_4))
  expect_identical(intervals_same_start$duration, c(t_2, t_4) - c(t_1, t_1))
  expect_identical(durationy(intervals_same_start), c(t_2, t_4) - c(t_1, t_1))

  expect_identical(intervals_same_end$start, c(t_1, t_3))
  expect_identical(intervals_same_end$end, c(t_4, t_4))

  expect_identical(intervals_same_end$duration, c(t_4, t_4) - c(t_1, t_3))
  expect_identical(durationy(intervals_same_end), c(t_4, t_4) - c(t_1, t_3))

  expect_identical(a %to% b, interval_ab)
  expect_identical(interval_ab$start, a)
  expect_identical(interval_ab$end, b)
  expect_identical(interval_ab$duration, b - a)
  expect_identical(durationy(interval_ab), b - a)

  expect_identical(NA_datey_interval_$start, NA_datey_)
  expect_identical(NA_datey_interval_$end, NA_datey_)
  expect_identical(NA_datey_interval_$duration, NA_durationy_)
  expect_identical(durationy(NA_datey_interval_), NA_durationy_)
})
test_that("`datey_interval(logical)`", {

  i <- datey_interval(c(TRUE, FALSE, NA))

  expect_identical(i[1]$start, datey(1000))
  expect_identical(i[1]$end, datey(3000))
  expect_identical(i[2], NA_datey_interval_)
  expect_identical(i[3], NA_datey_interval_)
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
  pre <- datey(1999, 12, 31, 1 - 1/1464)
  start <- datey(2000)
  mid <- datey(2001)
  end <- datey(2002)
  post <- datey(2002, 1, 1, 1/1464)

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
test_that("%includes% on an empty interval includes nothing", {
  t <- datey(2000)

  expect_identical((t %to% t) %includes% t, FALSE)
})
test_that("%includes% includes the start of exposure but not its end", {
  entry <- start_day(2018, 9, 12)
  exit <- mid_day(2024, 3, 7)

  expect_identical((entry %to% exit) %includes% entry, TRUE)
  expect_identical((entry %to% exit) %includes% exit, FALSE)
})
test_that("%includes% on adjacent intervals includes each point exactly once", {
  a <- start_day(2024, 1, 1)
  b <- start_day(2025, 1, 1)
  c <- start_day(2026, 1, 1)
  points <- c(a, mid_day(2024, 6, 30), b, mid_day(2025, 6, 30), c)

  in_first <- (a %to% b) %includes% points
  in_second <- (b %to% c) %includes% points

  expect_identical(in_first, c(TRUE, TRUE, FALSE, FALSE, FALSE))
  expect_identical(in_second, c(FALSE, FALSE, TRUE, TRUE, FALSE))
  expect_identical(in_first | in_second, (a %to% c) %includes% points)
  expect_identical(any(in_first & in_second), FALSE)
})
test_that("all_of_time includes its first instant and excludes its last", {
  expect_identical(all_of_time %includes% datey(valid_years_start), TRUE)
  expect_identical(all_of_time %includes% datey(valid_years_end), FALSE)
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

