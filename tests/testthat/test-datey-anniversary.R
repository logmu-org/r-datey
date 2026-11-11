# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon


# start_anniversary_day_to_ymd
# start_anniversary_day <- function(year, month, day, strict = TRUE) {
# is_start_anniversary_day

test_that("`datey` anniversary days", {

  testX <- function(year, month, day) {
    t <- start_anniversary_day(year, month, day)

    ymd <- start_anniversary_day_to_ymd(t)

    expect_identical(is_start_anniversary_day(t), rep(TRUE, length(t)))
    expect_identical(ymd$year, as.integer(year))
    expect_identical(ymd$month, as.integer(month))
    expect_identical(ymd$day, as.integer(day))

    expect_identical(t + durationy(1), start_anniversary_day(year + 1, month, day))
    expect_identical(t + durationy(2), start_anniversary_day(year + 2, month, day))
    expect_identical(t + durationy(3), start_anniversary_day(year + 3, month, day))
    expect_identical(t + durationy(4), start_anniversary_day(year + 4, month, day))
}

  c_y <- c(1000, 1800, 1900, 2000, 2001, 2990)
  c_m <- c(1, 2, 3, 6, 10, 12)
  c_d <- c(1, 29, 7, 17, 23, 31)

  testX(as.double(c_y), as.double(c_m), as.double(c_d))
  testX(as.integer(c_y), as.integer(c_m), as.integer(c_d))

  # Leap year
  testX(2004L, 2, 28)
  testX(2004L, 2L, 29)
  testX(2004L, 3L, 01L)

  # Non-leap year
  testX(2005, 2, 28)
  testX(2005L, 2, 29)
  testX(2005L, 3L, 01)
})

test_that("`datey` invalid anniversary days", {

  testX <- function(year, month, day) {
    expect_error(start_anniversary_day(year, month, day, strict = TRUE))
    expect_error(start_anniversary_day(year, month, day))
    expect_true(is.na(start_anniversary_day(year, month, day, strict = FALSE)))
  }

  testX(999, 12, 31)

  testX(2000, 0, 1)
  testX(2000, 13, 1)
  testX(2000, 1, 32)
  testX(2000, 2, 30)
  testX(2000, 9, 31)
  testX(2000, 12, 32)

  testX(3000, 1, 2)
  testX(3000, 2, 29)
})

test_that("`datey` anniversary days at the ends of the valid range", {
  first <- start_anniversary_day(1000, 1, 1)
  last <- start_anniversary_day(3000, 1, 1)
  final_day <- start_anniversary_day(2999, 12, 31)

  expect_identical(first, start_day(1000, 1, 1))
  expect_identical(last, start_day(3000, 1, 1))
  expect_identical(is_start_anniversary_day(c(first, final_day, last)), c(TRUE, TRUE, TRUE))
  expect_identical(
    start_anniversary_day_to_ymd(c(first, final_day, last)),
    list(year = c(1000L, 2999L, 3000L), month = c(1L, 12L, 1L), day = c(1L, 31L, 1L))
  )

  # 31 December is an ordinary anniversary day of 1463 clicks
  expect_identical(last - final_day, durationy(1463 / 534360))
})

test_that("`datey` anniversary days across 29 February", {
  feb_28 <- start_anniversary_day(2021, 2, 28)
  feb_29 <- start_anniversary_day(2021, 2, 29)
  mar_01 <- start_anniversary_day(2021, 3, 1)

  # 28 February is an ordinary anniversary day but 29 February is 365 clicks
  expect_identical(feb_29 - feb_28, durationy(1463 / 534360))
  expect_identical(mar_01 - feb_29, durationy(365 / 534360))

  # The anniversary grid is the same in leap and non-leap years
  expect_identical(feb_29 + durationy(3), start_anniversary_day(2024, 2, 29))
  expect_identical(mar_01 - durationy(1), start_anniversary_day(2020, 3, 1))
})

test_that("`datey` anniversary days are not other points in time", {
  one_click <- durationy(1 / 534360)
  anniversary <- start_anniversary_day(2021, c(1, 2, 3, 12), c(2, 28, 1, 31))
  all_na <- list(
    year = rep(NA_integer_, 4),
    month = rep(NA_integer_, 4),
    day = rep(NA_integer_, 4)
  )

  expect_identical(is_start_anniversary_day(anniversary + one_click), rep(FALSE, 4))
  expect_identical(is_start_anniversary_day(anniversary - one_click), rep(FALSE, 4))
  expect_identical(start_anniversary_day_to_ymd(anniversary + one_click), all_na)
  expect_identical(start_anniversary_day_to_ymd(anniversary - one_click), all_na)

  # An ordinary start of day in a leap year is not the start of an anniversary day
  normal <- start_day(2020, 4, 1)
  expect_false(is_start_anniversary_day(normal))
  expect_identical(
    start_anniversary_day_to_ymd(normal),
    list(year = NA_integer_, month = NA_integer_, day = NA_integer_)
  )
})

test_that("`datey` anniversary days inside 29 February", {
  feb_29 <- start_anniversary_day(2021, 2, 29)
  inside <- feb_29 + durationy(c(1, 182, 364) / 534360)
  all_na <- list(
    year = rep(NA_integer_, 3),
    month = rep(NA_integer_, 3),
    day = rep(NA_integer_, 3)
  )

  expect_identical(is_start_anniversary_day(inside), rep(FALSE, 3))
  expect_identical(start_anniversary_day_to_ymd(inside), all_na)

  # The click after the last one in 29 February starts 1 March
  next_day <- feb_29 + durationy(365 / 534360)
  expect_identical(next_day, start_anniversary_day(2021, 3, 1))
  expect_true(is_start_anniversary_day(next_day))
})

test_that("`datey` anniversary days with NA", {
  expect_identical(start_anniversary_day(NA_integer_, 1, 1), NA_datey_)
  expect_identical(start_anniversary_day(2000, NA_integer_, 1), NA_datey_)
  expect_identical(start_anniversary_day(2000, 1, NA_real_), NA_datey_)
  expect_identical(start_anniversary_day(NA_integer_, 1, 1, strict = FALSE), NA_datey_)

  feb_29 <- start_anniversary_day(2021, 2, 29)
  expect_identical(is_start_anniversary_day(NA_datey_), NA)
  expect_identical(is_start_anniversary_day(c(feb_29, NA_datey_)), c(TRUE, NA))
  expect_identical(
    start_anniversary_day_to_ymd(c(feb_29, NA_datey_)),
    list(year = c(2021L, NA), month = c(2L, NA), day = c(29L, NA))
  )

  # Invalid values in a vector become NA when not strict
  expect_identical(
    start_anniversary_day(2001, 2, 28:30, strict = FALSE),
    c(start_anniversary_day(2001, 2, 28), start_anniversary_day(2001, 2, 29), NA_datey_)
  )
})

test_that("`datey` anniversary days with recycling and zero length", {
  expect_identical(
    start_anniversary_day(2001, 1:2, 1:4),
    start_anniversary_day(rep(2001, 4), c(1, 2, 1, 2), 1:4)
  )
  expect_error(start_anniversary_day(2000, 1:2, 1:3))
  expect_error(start_anniversary_day(integer(0), 1, 1))

  empty <- start_anniversary_day(integer(0), integer(0), integer(0))
  expect_identical(length(empty), 0L)
  expect_identical(is_start_anniversary_day(empty), logical(0))
  expect_identical(
    start_anniversary_day_to_ymd(empty),
    list(year = integer(0), month = integer(0), day = integer(0))
  )
})

test_that("`datey` anniversary days reject bad argument types", {
  expect_error(start_anniversary_day(2000.5, 1, 1))
  expect_error(start_anniversary_day("2000", 1, 1))
  expect_error(is_start_anniversary_day(1L))
  expect_error(start_anniversary_day_to_ymd(1L))
})
