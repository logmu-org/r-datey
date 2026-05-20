# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# datey constants ==================================================
test_that("`NA_datey_` is a `datey`", expect_identical(is_datey(NA_datey_), TRUE))
test_that("`NA_datey_` is NA", expect_identical(is.na(NA_datey_), TRUE))
test_that("`valid_years_start` is 1000", expect_identical(valid_years_start, 1000L))
test_that("`valid_years_end` is 3000", expect_identical(valid_years_end, 3000L))

# is_datey <- function(x) ==================================================
test_that("`is_datey()`", {
  expect_identical(is_datey(NA_datey_), TRUE)
  expect_identical(is_datey(from_ymdf(2000, 1, 1, 0)), TRUE)

  expect_identical(is_datey(NA), FALSE)
  expect_identical(is_datey(TRUE), FALSE)
  expect_identical(is_datey(2000), FALSE)
  expect_identical(is_datey(2000L), FALSE)
  expect_identical(is_datey("2000-01-01"), FALSE)
})

# from_ymdf <- function(year, month, day, day_fraction, strict = TRUE) ==================================================
test_that("`from_ymdf()` clicks", {

  expect_identical(unclass(from_ymdf(0999, 12, 31, 1.00)), 534360000L)
  expect_identical(unclass(from_ymdf(1000, 01, 01, 0.00)), 534360000L)
  expect_identical(unclass(from_ymdf(2000, 01, 01, 0.00)), 1068720000L)
  expect_identical(unclass(from_ymdf(2000, 01, 01, 0.50)), 1068720730L)
  expect_identical(unclass(from_ymdf(2021, 03, 15, 1.00)), 1080049896L)
  expect_identical(unclass(from_ymdf(2021, 03, 16, 0.00)), 1080049896L)
})
# from_ymdf <- function(year, month, day, day_fraction, strict = TRUE) ==================================================
test_that("`from_ymdf()` with vector and scalar `day_fraction`s", {

  year <- c(1960, 2001, 2099);
  month <- c(11, 3, 7);
  day <- c(3, 31, 15);
  df_scalar <- 0.25;
  df_vector <- c(0.25, 0.25, 0.25);

  datey_scalar <- from_ymdf(year, month, day, df_scalar)

  datey_vector <- from_ymdf(year, month, day, df_vector)

  expect_identical(datey_vector, datey_scalar)
})
test_that("`from_ymdf()` cyclically and for integer/double combos", {

  y <- c(1960, 2001, 1999, 2000, 2001, 2099)
  m <- c(12, 3, 7, 1, 8, 5) # All months with 31 days
  d <- c(3, 31, 15, 10, 1, 25)
  f <- c(0.9, 0.1, 0.7, 0.3, 0.55, 0.45)

  y3 <- c(1960, 2001, 1999)
  y3_full <- c(1960, 2001, 1999, 1960, 2001, 1999)
  y2 <- c(1960, 2001)
  y2_full <- c(1960, 2001, 1960, 2001, 1960, 2001)
  y1 <- 1960
  y1_full <- c(1960, 1960, 1960, 1960, 1960, 1960)

  m3 <- c(12, 3, 7)
  m3_full <- c(12, 3, 7, 12, 3, 7)
  m2 <- c(12, 3)
  m2_full <- c(12, 3, 12, 3, 12, 3)
  m1 <- 12
  m1_full <- c(12, 12, 12, 12, 12, 12)

  d3 <- c(3, 31, 15)
  d3_full <- c(3, 31, 15, 3, 31, 15)
  d2 <- c(3, 31)
  d2_full <- c(3, 31, 3, 31, 3, 31)
  d1 <- 3
  d1_full <- c(3, 3, 3, 3, 3, 3)

  f3 <- c(0.9, 0.1, 0.7)
  f3_full <- c(0.9, 0.1, 0.7, 0.9, 0.1, 0.7)
  f2 <- c(0.9, 0.1)
  f2_full <- c(0.9, 0.1, 0.9, 0.1, 0.9, 0.1)
  f1 <- 0.9
  f1_full <- c(0.9, 0.9, 0.9, 0.9, 0.9, 0.9)

  testX <- function(y_act, m_act, d_act, f_act, y_exp, m_exp, d_exp, f_exp) {

    expected <- from_ymdf(y_exp, m_exp, d_exp, f_exp)

    y_int <- as.integer(y_act)
    m_int <- as.integer(m_act)
    d_int <- as.integer(d_act)

    y_dbl <- as.double(y_act)
    m_dbl <- as.double(m_act)
    d_dbl <- as.double(d_act)

    expect_identical(from_ymdf(y_int, m_int, d_int, f_act), expected)
    expect_identical(from_ymdf(y_int, m_int, d_dbl, f_act), expected)
    expect_identical(from_ymdf(y_int, m_dbl, d_int, f_act), expected)
    expect_identical(from_ymdf(y_int, m_dbl, d_dbl, f_act), expected)
    expect_identical(from_ymdf(y_dbl, m_int, d_int, f_act), expected)
    expect_identical(from_ymdf(y_dbl, m_int, d_dbl, f_act), expected)
    expect_identical(from_ymdf(y_dbl, m_dbl, d_int, f_act), expected)
    expect_identical(from_ymdf(y_dbl, m_dbl, d_dbl, f_act), expected)
  }

  testX(y, m, d, f, y, m, d, f) # Test double/integer combos

  testX(y3, m, d, f, y3_full, m, d, f)
  testX(y, m3, d, f, y, m3_full, d, f)
  testX(y, m, d3, f, y, m, d3_full, f)
  testX(y, m, d, f3, y, m, d, f3_full)

  testX(y2, m, d, f, y2_full, m, d, f)
  testX(y, m2, d, f, y, m2_full, d, f)
  testX(y, m, d2, f, y, m, d2_full, f)
  testX(y, m, d, f2, y, m, d, f2_full)

  testX(y1, m, d, f, y1_full, m, d, f)
  testX(y, m1, d, f, y, m1_full, d, f)
  testX(y, m, d1, f, y, m, d1_full, f)
  testX(y, m, d, f1, y, m, d, f1_full)

  testX(y3, m2, d, f, y3_full, m2_full, d, f)
  testX(y, m3, d, f, y, m3_full, d, f)
  testX(y2, m, d3, f, y2_full, m, d3_full, f)
  testX(y, m2, d, f3, y, m2_full, d, f3_full)
  testX(y3, m2, d, f3, y3_full, m2_full, d, f3_full)
  testX(y3, m, d2, f1, y3_full, m, d2_full, f1_full)

  expect_error(from_ymdf(y3, m2, d1, f1))
  expect_error(from_ymdf(y1, m3, d2, f1))
  expect_error(from_ymdf(y1, m1, d3, f2))
  expect_error(from_ymdf(y2, m1, d1, f3))
})
test_that("`datey` is illegal but not error for 2999-12-31 plus `day_fraction = 1`", {
  expect_identical(unclass(from_ymdf(2999, 12, 31, 1)), 3000L * 534360L)
})
test_that("`datey` errors in invalid inputs when `strict = TRUE`", {
  expect_error(from_ymdf(999, 12, 31, 0.999998))
  expect_error(from_ymdf(3000,01, 01, 0.000002))
})
test_that("`datey` errors for non-integer years, months or days", {
  expect_error(from_ymdf(1000.01, 01.00, 01.00, 0.00))
  expect_error(from_ymdf(1800.00, 02.01, 05.00, 0.00))
  expect_error(from_ymdf(1900.00, 04.00, 10.01, 0.00))
  expect_error(from_ymdf(1999.99, 06.00, 15.00, 0.00))
  expect_error(from_ymdf(2000.00, 08.99, 20.00, 0.00))
  expect_error(from_ymdf(2087.00, 10.00, 25.99, 0.00))
  expect_error(from_ymdf(2999.50, 12.00, 31.00, 0.00))
})

# start_day / mid_day <- function(year, month, day, strict = TRUE) ==================================================
test_that("`datey` and `start_day`, `mid_day` and `end_day` are consistent", {
  y <- c(999, 1000, 1900, 1950, 2000, 2020, 2999, 3000)
  m <- c(12, 1, 6, 3, 2, 5, 6, 1)
  d <- c(31, 1, 15, 3, 29, 20, 10, 1)

  expect_identical(from_ymdf(y, m, d, 0, strict = FALSE), start_day(y, m, d, strict = FALSE))
  expect_identical(from_ymdf(y, m, d, 0.5, strict = FALSE), mid_day(y, m, d, strict = FALSE))
  expect_identical(from_ymdf(y, m, d, 1, strict = FALSE), end_day(y, m, d, strict = FALSE))
})

# to_ymdf <- function(datey) ==================================================
test_that("`datey` round-trips from ymdf and back", {

  testX <- function(year, month, day, day_fraction) {
    datey <- from_ymdf(year, month, day, day_fraction)
    ymdf <- to_ymdf(datey)
    expect_identical(ymdf$year, as.integer(year))
    expect_identical(ymdf$month, as.integer(month))
    expect_identical(ymdf$day, as.integer(day))
    expect_equal(ymdf$day_fraction, as.double(day_fraction))
  }

  # There are
  # - 1464 clicks per day in a normal year
  # - 1460 clicks per day in a *leap* year

  testX(1800L, 1L, 1L, 0L) # LLLL
  testX(1857L, 1L, 31L, 0.25) # LLLD
  testX(1899, 2, 1, 123 / 1464)
  testX(1904, 2, 29, 123 / 1460)
  testX(2000, 2, 29, 567 / 1460)
  testX(2004, 2, 29, 1231 / 1460)
  testX(1901, 3, 1, 1231 / 1464)
  testX(1932L, 3L, 31, 0L) # LLDL
  testX(1945L, 4L, 1, 0) # LLDD
  testX(1976L, 4, 30L, 0L) # LDLL
  testX(1989L, 5, 1L, 0) # LDLD
  testX(2010L, 5, 31, 0L) # LDDL
  testX(2023L, 6, 1, 0) # LDDD
  testX(2054, 6L, 30L, 0L) # DLLL
  testX(2067, 7L, 1L, 0) # DLLD
  testX(2098, 7L, 31, 0L) # DLDL
  testX(2101, 8L, 1, 0) # DLDD
  testX(2132, 8, 31L, 0L) # DDLL
  testX(2145, 9, 1L, 0) # DDLD
  testX(2176, 9, 30, 0L) # DDDL
  testX(2189, 10, 1, 0) # DDDD
  testX(2210, 10, 31, 0)
  testX(2223, 11, 1, 0)
  testX(2254, 11, 30, 0)
  testX(2267, 12, 1, 0)
  testX(2298, 12, 31, 0)
})

# datey.default <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`datey.default()`", {
  expect_identical(datey(structure(0, class = "FAKE")), NA_datey_)
})

# datey.datey <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`datey.datey()`", {
  expect_identical(datey(from_ymdf(1999, 02, 28, 0.00)), from_ymdf(1999, 02, 28, 0.00))
  expect_identical(datey(from_ymdf(1999, 11, 17, 0.25)), from_ymdf(1999, 11, 17, 0.25))
  expect_identical(datey(from_ymdf(2000, 10, 11, 0.00)), from_ymdf(2000, 10, 11, 0.00))
  expect_identical(datey(from_ymdf(2000, 03, 05, 0.25)), from_ymdf(2000, 03, 05, 0.25))
  expect_identical(datey(from_ymdf(0999, 12, 31, 0.90, strict = FALSE)), datey::NA_datey_)

  expect_identical(datey(from_ymdf(1999, 02, 28, 0.00), day_fraction = 0.75), from_ymdf(1999, 02, 28, 0.75))
  expect_identical(datey(from_ymdf(1999, 11, 17, 0.25), day_fraction = 0.75), from_ymdf(1999, 11, 17, 0.75))
  expect_identical(datey(from_ymdf(2000, 10, 11, 0.00), day_fraction = 0.75), from_ymdf(2000, 10, 11, 0.75))
  expect_identical(datey(from_ymdf(2000, 03, 05, 0.25), day_fraction = 0.75), from_ymdf(2000, 03, 05, 0.75))

  expect_identical(datey(from_ymdf(0999, 12, 31, 0.90, strict = FALSE), day_fraction = 0.75), datey::NA_datey_)
  expect_identical(datey(from_ymdf(0999, 12, 31, 1.00), day_fraction = 0.75), from_ymdf(1000, 01, 01, 0.75))
  expect_identical(datey(from_ymdf(3000, 01, 01, 0.10, strict = FALSE), day_fraction = 0.25), datey::NA_datey_)
  expect_identical(datey(from_ymdf(3000, 01, 01, 0.00), day_fraction = 0.25, strict = FALSE), datey::NA_datey_)
})

# datey.integer <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`datey.integer()`", {
  expect_identical(datey(1000L), from_ymdf(0999, 12, 31, 1.00))
  expect_identical(datey(1000L), from_ymdf(1000, 01, 01, 0.00))
  expect_identical(datey(1999L, day_fraction = 0.75), from_ymdf(1999, 01, 01, 0.75))
  expect_identical(datey(2000L, day_fraction = 0.75), from_ymdf(2000, 01, 01, 0.75))
  expect_identical(datey(2999L), from_ymdf(2999, 01, 01, 0.00))
  expect_identical(datey(3000L), from_ymdf(2999, 12, 31, 1.00))
  expect_identical(datey(3000L), from_ymdf(3000, 01, 01, 0.00))

  expect_identical(datey(0999L, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(3001L, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(0999L, day_fraction = 1.00, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(3000L, day_fraction = 1 / 1460, strict = FALSE), datey::NA_datey_)
})

# datey.double <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`datey.double()`", {

  d_1999_01_15_0.25 <- 1999 + ((15.25 - 1) * 1464) / 534360 # Normal year
  d_2000_01_15_0.25 <- 2000 + ((15.25 - 1) * 1460) / 534360 # Leap year
  d_2108_02_29_0.25 <- 2108 + ((31 + 29.25 - 1) * 1460) / 534360 # Leap year
  d_2109_02_28_0.25 <- 2109 + ((31 + 28.25 - 1) * 1464) / 534360 # Normal year

  expect_identical(datey(1000), from_ymdf(0999, 12, 31, 1.0))
  expect_identical(datey(d_1999_01_15_0.25), from_ymdf(1999, 01, 15, 0.25))
  expect_identical(datey(d_2000_01_15_0.25), from_ymdf(2000, 01, 15, 0.25))
  expect_identical(datey(d_2108_02_29_0.25), from_ymdf(2108, 02, 29, 0.25))
  expect_identical(datey(d_2109_02_28_0.25), from_ymdf(2109, 02, 28, 0.25))

  expect_identical(datey(d_1999_01_15_0.25, day_fraction = 0.75), from_ymdf(1999, 01, 15, 0.75))
  expect_identical(datey(d_2000_01_15_0.25, day_fraction = 0.75), from_ymdf(2000, 01, 15, 0.75))
  expect_identical(datey(d_2108_02_29_0.25, day_fraction = 0.75), from_ymdf(2108, 02, 29, 0.75))
  expect_identical(datey(d_2109_02_28_0.25, day_fraction = 0.75), from_ymdf(2109, 02, 28, 0.75))

  expect_identical(datey(d_1999_01_15_0.25, day_fraction = 0.00), from_ymdf(1999, 01, 15, 0.00))
  expect_identical(datey(d_2000_01_15_0.25, day_fraction = 0.00), from_ymdf(2000, 01, 15, 0.00))
  expect_identical(datey(d_2108_02_29_0.25, day_fraction = 1.00), from_ymdf(2108, 02, 29, 1.00))
  expect_identical(datey(d_2109_02_28_0.25, day_fraction = 1.00), from_ymdf(2109, 02, 28, 1.00))
  expect_identical(datey(3000, day_fraction = 0.00), from_ymdf(3000, 01, 01, 0.00))

  expect_identical(datey(3000), from_ymdf(3000, 01, 01, 0.0))

  expect_identical(datey(1000 - 1/534360, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(3000 + 1/534360, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(3000, day_fraction = 1 / 1460, strict = FALSE), datey::NA_datey_)
})

# datey.Date <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`datey.Date()`", {

  # Get a `Date` that is actually a fraction
  D_2021_09_16.5 <- mean(c(as.Date("2021-09-16"), as.Date("2021-09-17")))

  expect_identical(datey(as.Date("1000-01-01")), from_ymdf(1000, 01, 01, 0.00))
  expect_identical(datey(as.Date("2000-07-23")), from_ymdf(2000, 07, 23, 0.00))
  expect_identical(datey(as.Date("2999-12-31")), from_ymdf(2999, 12, 31, 0.00))
  expect_identical(datey(D_2021_09_16.5), from_ymdf(2021, 09, 16, 0.50))
  expect_identical(datey(as.Date("0999-12-31"), strict = FALSE), datey::NA_datey_)
  expect_identical(datey(as.Date("3000-01-01"), strict = FALSE), datey::NA_datey_)

  expect_identical(datey(as.Date("1000-01-01"), day_fraction = 0.75), from_ymdf(1000, 01, 01, 0.75))
  expect_identical(datey(as.Date("2000-07-23"), day_fraction = 0.75), from_ymdf(2000, 07, 23, 0.75))
  expect_identical(datey(as.Date("2999-12-31"), day_fraction = 0.75), from_ymdf(2999, 12, 31, 0.75))
  expect_identical(datey(D_2021_09_16.5, day_fraction = 0.75), from_ymdf(2021, 09, 16, 0.75))
  expect_identical(datey(as.Date("0999-12-31"), day_fraction = 1.00, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(as.Date("3000-01-01"), day_fraction = 0.00, strict = FALSE), datey::NA_datey_)
})
test_that("`datey.Date()` cyclically", {

  Date_A <- as.Date("1000-01-01")
  Date_B <- as.Date("1801-03-05")
  Date_C <- as.Date("1999-05-10")
  Date_D <- as.Date("2004-08-20")
  Date_E <- as.Date("2101-10-25")
  Date_F <- as.Date("2999-12-31")

  Dates <- c(Date_A, Date_B, Date_C, Date_D, Date_E, Date_F)

  f <- c(0.9, 0.1, 0.7, 0.3, 0.55, 0.45)

  Dates3 <- c(Date_A, Date_B, Date_C)
  Dates3_full <- c(Date_A, Date_B, Date_C, Date_A, Date_B, Date_C)
  Dates2 <- c(Date_A, Date_B)
  Dates2_full <- c(Date_A, Date_B, Date_A, Date_B, Date_A, Date_B)
  Dates1 <- Date_A
  Dates1_full <- c(Date_A, Date_A, Date_A, Date_A, Date_A, Date_A)

  f3 <- c(0.9, 0.1, 0.7)
  f3_full <- c(0.9, 0.1, 0.7, 0.9, 0.1, 0.7)
  f2 <- c(0.9, 0.1)
  f2_full <- c(0.9, 0.1, 0.9, 0.1, 0.9, 0.1)
  f1 <- 0.9
  f1_full <- c(0.9, 0.9, 0.9, 0.9, 0.9, 0.9)

  expect_identical(datey(Dates, day_fraction = f3), datey(Dates, day_fraction = f3_full))
  expect_identical(datey(Dates, day_fraction = f2), datey(Dates, day_fraction = f2_full))
  expect_identical(datey(Dates, day_fraction = f1), datey(Dates, day_fraction = f1_full))
  expect_identical(datey(Dates3, day_fraction = f), datey(Dates3_full, day_fraction = f))
  expect_identical(datey(Dates2, day_fraction = f), datey(Dates2_full, day_fraction = f))
  expect_identical(datey(Dates1, day_fraction = f), datey(Dates1_full, day_fraction = f))

  expect_error(datey(Dates3, day_fraction = f2))
  expect_error(datey(Dates2, day_fraction = f3))
})

# datey.POSIXct <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`datey.POSIXct()`", {

  expect_identical(datey(as.POSIXct("1000-01-01")), from_ymdf(1000, 01, 01, 0.00))
  expect_identical(datey(as.POSIXct("2000-07-23")), from_ymdf(2000, 07, 23, 0.00))
  expect_identical(datey(as.POSIXct("2999-12-31")), from_ymdf(2999, 12, 31, 0.00))
  expect_identical(datey(as.POSIXct("2021-09-16 12:00")), from_ymdf(2021, 09, 16, 0.50))
  expect_identical(datey(as.POSIXct("0999-12-31"), strict = FALSE), datey::NA_datey_)
  expect_identical(datey(as.POSIXct("3000-01-01"), strict = FALSE), datey::NA_datey_)

  expect_identical(datey(as.POSIXct("1000-01-01"), day_fraction = 0.75), from_ymdf(1000, 01, 01, 0.75))
  expect_identical(datey(as.POSIXct("2000-07-23"), day_fraction = 0.75), from_ymdf(2000, 07, 23, 0.75))
  expect_identical(datey(as.POSIXct("2999-12-31"), day_fraction = 0.75), from_ymdf(2999, 12, 31, 0.75))
  expect_identical(datey(as.POSIXct("2021-09-16 12:00"), day_fraction = 0.75), from_ymdf(2021, 09, 16, 0.75))
  expect_identical(datey(as.POSIXct("0999-12-31"), day_fraction = 1.00, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(as.POSIXct("3000-01-01"), day_fraction = 0.00, strict = FALSE), datey::NA_datey_)
})

# datey.POSIXlt <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`datey.POSIXlt()`", {

  expect_identical(datey(as.POSIXlt("1000-01-01")), from_ymdf(1000, 01, 01, 0.00))
  expect_identical(datey(as.POSIXlt("2000-07-23")), from_ymdf(2000, 07, 23, 0.00))
  expect_identical(datey(as.POSIXlt("2999-12-31")), from_ymdf(2999, 12, 31, 0.00))
  expect_identical(datey(as.POSIXlt("2021-09-16 12:00")), from_ymdf(2021, 09, 16, 0.50))
  expect_identical(datey(as.POSIXlt("0999-12-31"), strict = FALSE), datey::NA_datey_)
  expect_identical(datey(as.POSIXlt("3000-01-01"), strict = FALSE), datey::NA_datey_)

  expect_identical(datey(as.POSIXlt("1000-01-01"), day_fraction = 0.75), from_ymdf(1000, 01, 01, 0.75))
  expect_identical(datey(as.POSIXlt("2000-07-23"), day_fraction = 0.75), from_ymdf(2000, 07, 23, 0.75))
  expect_identical(datey(as.POSIXlt("2999-12-31"), day_fraction = 0.75), from_ymdf(2999, 12, 31, 0.75))
  expect_identical(datey(as.POSIXlt("2021-09-16 12:00"), day_fraction = 0.75), from_ymdf(2021, 09, 16, 0.75))
  expect_identical(datey(as.POSIXlt("0999-12-31"), day_fraction = 1.00, strict = FALSE), datey::NA_datey_)
  expect_identical(datey(as.POSIXlt("3000-01-01"), day_fraction = 0.00, strict = FALSE), datey::NA_datey_)
})

# datey.character <- function(x, day_fraction = NULL, blank_is_NA = FALSE, strict = TRUE, ...) ==================================================
test_that("`datey.character()`", {

  testX <- function(x, text) {
    expect_identical(datey(text), x)

    text_no_fraction <- sub("\\..*", "", text)
    expect_identical(datey(text_no_fraction, day_fraction = 0.00), datey(x, day_fraction = 0.00))
    expect_identical(datey(text_no_fraction, day_fraction = 0.75), datey(x, day_fraction = 0.75))

    # While we're here, check that text round-trips
    expect_identical(x, datey(format(x)))
  }

  testX(datey(1999), "1999-01-01")
  testX(datey(1999), "1999-01-01.000")

  # 1 day in a non-leap year is 534360 / 365 = 1464 clicks
  # 1 click / 1 day = 1 / 1464 = 0.0006830601
  testX(datey(1999 + 1 / 534360), "1999-01-01.0007")
  testX(datey(1999 + 1 / 534360), "1999-01-01.0006830601")

  # 1 July is 181 days
  # 777 clicks / 1 day = 777 / 1464 = 0.530737705
  testX(datey(1999 + (1464 * 181 + 777) / 534360), "1999-07-01.5307")
  testX(datey(1999 + (1464 * 181 + 777) / 534360), "1999-07-01.530737705")

  # (1 day less 1 click) / 1 day = 1463 / 1464 = 0.99931694
  testX(datey(1999 + (1464 * 364 + 1463) / 534360), "1999-12-31.9993")
  testX(datey(1999 + (1464 * 364 + 1463) / 534360), "1999-12-31.99931694")

  # 1 day in a leap year is 534360 / 366 = 1460 clicks
  # 1 click / 1 day = 1 / 1460 = 0.0006849315
  testX(datey(2000 + 1 / 534360), "2000-01-01.0007")
  testX(datey(2000 + 1 / 534360), "2000-01-01.0006849315")

  # 1 July is 182 days
  # 777 clicks / 1 day = 777 / 1460 = 0.53219178
  testX(datey(2000 + (1460 * 182 + 777) / 534360), "2000-07-01.5322")
  testX(datey(2000 + (1460 * 182 + 777) / 534360), "2000-07-01.53219178")

  # (1 day less 1 click) / 1 day = 1459 / 1460 = 0.99931506
  testX(datey(2000 + (1460 * 365 + 1459) / 534360), "2000-12-31.9993")
  testX(datey(2000 + (1460 * 365 + 1459) / 534360), "2000-12-31.99931506")
})
test_that("`datey.character()` cyclically", {

  text_A <- "1000-01-01"
  text_B <- "1801-03-05"
  text_C <- "1999-05-10"
  text_D <- "2004-08-20"
  text_E <- "2101-10-25"
  text_F <- "2999-12-31"

  texts <- c(text_A, text_B, text_C, text_D, text_E, text_F)

  f <- c(0.9, 0.1, 0.7, 0.3, 0.55, 0.45)

  texts3 <- c(text_A, text_B, text_C)
  texts3_full <- c(text_A, text_B, text_C, text_A, text_B, text_C)
  texts2 <- c(text_A, text_B)
  texts2_full <- c(text_A, text_B, text_A, text_B, text_A, text_B)
  texts1 <- text_A
  texts1_full <- c(text_A, text_A, text_A, text_A, text_A, text_A)

  f3 <- c(0.9, 0.1, 0.7)
  f3_full <- c(0.9, 0.1, 0.7, 0.9, 0.1, 0.7)
  f2 <- c(0.9, 0.1)
  f2_full <- c(0.9, 0.1, 0.9, 0.1, 0.9, 0.1)
  f1 <- 0.9
  f1_full <- c(0.9, 0.9, 0.9, 0.9, 0.9, 0.9)

  expect_identical(datey(texts, day_fraction = f3), datey(texts, day_fraction = f3_full))
  expect_identical(datey(texts, day_fraction = f2), datey(texts, day_fraction = f2_full))
  expect_identical(datey(texts, day_fraction = f1), datey(texts, day_fraction = f1_full))
  expect_identical(datey(texts3, day_fraction = f), datey(texts3_full, day_fraction = f))
  expect_identical(datey(texts2, day_fraction = f), datey(texts2_full, day_fraction = f))
  expect_identical(datey(texts1, day_fraction = f), datey(texts1_full, day_fraction = f))

  expect_error(datey(texts3, day_fraction = f2))
  expect_error(datey(texts2, day_fraction = f3))
})

# start_day / mid_day / end_day / is_start_day / is_mid_day ==================================================
test_that("`as_XXX_day()` and `is_XXX_day()`", {

  testX <- function(y, m, d) {
    d_0.00 <- from_ymdf(y, m, d, 0.00)
    d_0.50 <- from_ymdf(y, m, d, 0.50)
    d_1.00 <- from_ymdf(y, m, d, 1.00)

    expect_identical(start_day(y, m, d), d_0.00)
    expect_identical(mid_day(y, m, d), d_0.50)
    expect_identical(end_day(y, m, d), d_1.00)

    expect_identical(is_start_day(d_0.00), TRUE)
    expect_identical(is_mid_day(d_0.00), FALSE)
    expect_identical(is_start_day(d_0.50), FALSE)
    expect_identical(is_mid_day(d_0.50), TRUE)
    expect_identical(is_start_day(d_1.00), TRUE)
    expect_identical(is_mid_day(d_1.00), FALSE)

    d_0.25 <- from_ymdf(y, m, d, 0.25)
    expect_identical(is_start_day(d_0.25), FALSE)
    expect_identical(is_mid_day(d_0.25), FALSE)
  }

  testX(1000, 01, 01)
  testX(2000, 07, 23)
  testX(2999, 12, 30) # day = 31 will create an NA
})

# as.double.datey <- function(x, ...) ==================================================
# as.numeric dispatches to as.double.XXX
test_that("`is.numeric.datey()`, `as.numeric.datey()` and `as.double.datey()`", {
  expect_identical(is.numeric(from_ymdf(2000, 1, 1, 0)), TRUE)
  expect_identical(as.numeric(from_ymdf(2000, 1, 1, 0)), 2000)
  expect_identical(as.double(from_ymdf(2000, 1, 1, 0)), 2000)
  expect_identical(is.numeric(NA_datey_), TRUE)
  expect_identical(as.numeric(NA_datey_), NA_real_)
  expect_identical(as.double(NA_datey_), NA_real_)
})

# as.integer.datey <- function(x, ...) ==================================================
test_that("`as.integer.datey()`", {
  expect_identical(as.integer(from_ymdf(2000, 1, 1, 0)), 2000L)
  expect_identical(as.integer(from_ymdf(2000, 7, 1, 0)), 2000L)
  expect_identical(as.integer(from_ymdf(2000, 7, 15, 0.75)), 2000L)
  expect_identical(as.integer(from_ymdf(2000, 12, 31, 0.9993)), 2000L)
  expect_identical(as.integer(NA_datey_), NA_integer_)
})

# is.na.datey <- function(x) ==================================================
test_that("`is.na.datey()`", {
  expect_identical(is.na(NA_datey_), TRUE)
  expect_identical(is.na(from_ymdf(0999, 12, 31, 0.999998, strict = FALSE)), TRUE)
  expect_identical(is.na(from_ymdf(3000, 01, 01, 0.000002, strict = FALSE)), TRUE)

  expect_identical(is.na(from_ymdf(0999, 12, 31, 1.00)), FALSE)
  expect_identical(is.na(from_ymdf(1000, 01, 01, 0.00)), FALSE)
  expect_identical(is.na(from_ymdf(2020, 05, 23, 0.4567)), FALSE)
  expect_identical(is.na(from_ymdf(2999, 12, 31, 1.0)), FALSE)
})

# anyNA.datey = function(x, recursive=FALSE) ==================================================
test_that("`anyNA.datey()`", {

  na_1 <- NA_datey_
  na_2 <- from_ymdf(0999, 12, 31, 0.999998, strict = FALSE)
  na_3 <- from_ymdf(3000, 01, 01, 0.000002, strict = FALSE)

  d_1 <- from_ymdf(1000, 01, 01, 0.00)
  d_2 <- from_ymdf(2020, 05, 23, 0.4567)
  d_3 <- from_ymdf(2999, 12, 31, 0.9993)

  expect_identical(anyNA(c(na_1)), TRUE)
  expect_identical(anyNA(c(na_2)), TRUE)
  expect_identical(anyNA(c(na_1, na_2)), TRUE)
  expect_identical(anyNA(c(d_1, na_2, na_3)), TRUE)
  expect_identical(anyNA(c(na_2, d_3, na_3)), TRUE)
  expect_identical(anyNA(c(d_1, d_2, na_3)), TRUE)

  expect_identical(anyNA(c(d_1)), FALSE)
  expect_identical(anyNA(c(d_1, d_2)), FALSE)
  expect_identical(anyNA(c(d_1, d_2, d_3)), FALSE)
})

# c.datey <- function(..., recursive = FALSE) ==================================================
test_that("`c()` on `datey`", {
  expect_identical(is_datey(c(from_ymdf(2000, 1, 1, 0), from_ymdf(2000, 1, 1, 0))), TRUE)
  expect_identical(is_datey(c(NA_datey_, from_ymdf(2000, 1, 1, 0))), TRUE)
})

# format.datey <- function(x, include_day_fraction = TRUE, ...) ==================================================
test_that("`format.datey()` on NA", {

  expect_identical(format(NA_datey_), NA_character_)
  expect_identical(format(from_ymdf(0999, 12, 31, 0.999998, strict = FALSE)), NA_character_)
  expect_identical(format(from_ymdf(3000, 01, 01, 0.000002, strict = FALSE)), NA_character_)
})
test_that("`format.datey()`", {

  testX <- function(y, m, d, f, text) {
    x <- from_ymdf(y, m, d, f)

    expect_identical(format(x), text)
    expect_identical(format(x, include_day_fraction = TRUE), text)

    # While we're here check this round trips:
    expect_identical(datey(text), x)

    text_no_fraction <- sub("\\..*", "", text)
    expect_identical(format(x, include_day_fraction = FALSE), text_no_fraction)
  }

  # Clicks in normal year = 1464 = 2^3 * 3 * 611
  # Clicks in leap year = 1460 = 2^2 * 5 * 83

  # Min legal
  testX(1000, 01, 01, 0.0000, "1000-01-01.0")
  # Max legal
  testX(3000, 01, 01, 0.0000, "3000-01-01.0")

  # Normal 1 dp:
  testX(1999, 07, 23, 0 / 1464, "1999-07-23.0")
  testX(1999, 07, 23, 732 / 1464, "1999-07-23.5")
  # Normal 2 dp:
  testX(1999, 07, 23, 161 / 1464, "1999-07-23.11")
  testX(1999, 07, 23, 571 / 1464, "1999-07-23.39")
  testX(1999, 07, 23, 893 / 1464, "1999-07-23.61")
  testX(1999, 07, 23, 1303 / 1464, "1999-07-23.89")
  # Normal 3 dp:
  testX(1999, 07, 23, 3 / 1464, "1999-07-23.002")
  testX(1999, 07, 23, 729 / 1464, "1999-07-23.498")
  testX(1999, 07, 23, 735 / 1464, "1999-07-23.502")
  # Normal 4 dp:
  testX(1999, 07, 23, 1 / 1464, "1999-07-23.0007")
  testX(1999, 07, 23, 487 / 1464, "1999-07-23.3327")
  testX(1999, 07, 23, 488 / 1464, "1999-07-23.3333")
  testX(1999, 07, 23, 490 / 1464, "1999-07-23.3347")
  testX(1999, 07, 23, 731 / 1464, "1999-07-23.4993")
  testX(1999, 07, 23, 733 / 1464, "1999-07-23.5007")
  testX(1999, 07, 23, 974 / 1464, "1999-07-23.6653")
  testX(1999, 07, 23, 976 / 1464, "1999-07-23.6667")
  testX(1999, 07, 23, 977 / 1464, "1999-07-23.6673")
  testX(1999, 07, 23, 1463 / 1464, "1999-07-23.9993")

  # Leap 1 dp:
  testX(2000, 07, 23, 0 / 1460, "2000-07-23.0")
  testX(2000, 07, 23, 146 / 1460, "2000-07-23.1")
  testX(2000, 07, 23, 730 / 1460, "2000-07-23.5")
  testX(2000, 07, 23, 1314 / 1460, "2000-07-23.9")
  # Leap 2 dp:
  testX(2000, 07, 23, 73 / 1460, "2000-07-23.05")
  testX(2000, 07, 23, 657 / 1460, "2000-07-23.45")
  testX(2000, 07, 23, 803 / 1460, "2000-07-23.55")
  testX(2000, 07, 23, 1387 / 1460, "2000-07-23.95")
  # Leap 3 dp:
  testX(2000, 07, 23, 16 / 1460, "2000-07-23.011")
  testX(2000, 07, 23, 714 / 1460, "2000-07-23.489")
  testX(2000, 07, 23, 746 / 1460, "2000-07-23.511")
  testX(2000, 07, 23, 1444 / 1460, "2000-07-23.989")
  # Leap 4 dp:
  testX(2000, 07, 23, 1 / 1460, "2000-07-23.0007")
  testX(2000, 07, 23, 486 / 1460, "2000-07-23.3329")
  testX(2000, 07, 23, 487 / 1460, "2000-07-23.3336")
  testX(2000, 07, 23, 729 / 1460, "2000-07-23.4993")
  testX(2000, 07, 23, 731 / 1460, "2000-07-23.5007")
  testX(2000, 07, 23, 973 / 1460, "2000-07-23.6664")
  testX(2000, 07, 23, 974 / 1460, "2000-07-23.6671")
  testX(2000, 07, 23, 1459 / 1460, "2000-07-23.9993")
})

# print.datey <- function(x, include_day_fraction = TRUE, max = NULL, ...) ==================================================
# NO EXPLICIT TEST
