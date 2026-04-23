test_that("`is_leap_year` works", {
  expect_identical(datey::is_leap_year(2009.0), FALSE)
  expect_identical(datey::is_leap_year(2008L),  TRUE)
  expect_identical(datey::is_leap_year(2000.1),  TRUE)
  expect_identical(datey::is_leap_year(1901),  FALSE)
  expect_identical(datey::is_leap_year(1900),  FALSE)
  expect_identical(datey::is_leap_year(as_datey("2044-01-02.0")), TRUE)
  expect_identical(datey::is_leap_year(as_datey("2047-12-29.0")), FALSE)
  expect_identical(datey::is_leap_year(as.Date("1804-04-01.0")), TRUE)
  expect_identical(datey::is_leap_year(as.Date("1813-08-30.0")), FALSE)
})

test_that("`is_leap_year` gives `NA` for invalid args", {
  expect_equal(datey::is_leap_year(NA), NA)
  expect_equal(datey::is_leap_year("2000"), NA)
})

test_that("a `datey` is numeric", {
  expect_identical(base::is.numeric(datey::datey(2000, 1, 1, 0)), TRUE)
})

test_datey_round_trip <- function(year, month, day, day_fraction, valid) {
  datey <- datey::datey(year, month, day, day_fraction)
  ymdf <- datey::as_ymdf(datey)
  expect_identical(ymdf$year, ifelse(valid, as.integer(year), NA_integer_))
  expect_identical(ymdf$month, ifelse(valid, as.integer(month), NA_integer_))
  expect_identical(ymdf$day, ifelse(valid, as.integer(day), NA_integer_))
  expect_equal(ymdf$day_fraction, ifelse(valid, as.double(day_fraction), NA_real_))
}

test_valid <- function(year, month, day, day_fraction) {
  datey <- datey::datey(year, month, day, day_fraction)
  ymdf <- datey::as_ymdf(datey)
  expect_identical(ymdf$year, as.integer(year))
  expect_identical(ymdf$month, as.integer(month))
  expect_identical(ymdf$day, as.integer(day))
  expect_equal(ymdf$day_fraction, as.double(day_fraction))
}

test_that("`datey` round-trips from ymdf and back", {
  test_datey_round_trip(1800, 1, 1, 0, valid = TRUE)
  test_datey_round_trip(1857, 1, 31, 0.25, valid = TRUE)
  test_datey_round_trip(1899, 2, 1, 0, valid = TRUE)
  test_datey_round_trip(1904, 2, 29, 0, valid = TRUE)
  test_datey_round_trip(2000, 2, 29, 0, valid = TRUE)
  test_datey_round_trip(2004, 2, 29, 0, valid = TRUE)
  test_datey_round_trip(1901, 3, 1, 0, valid = TRUE)
  test_datey_round_trip(1932, 3, 31, 0, valid = TRUE)
  test_datey_round_trip(1945, 4, 1, 0, valid = TRUE)
  test_datey_round_trip(1976, 4, 30, 0, valid = TRUE)
  test_datey_round_trip(1989, 5, 1, 0, valid = TRUE)
  test_datey_round_trip(2010, 5, 31, 0, valid = TRUE)
  test_datey_round_trip(2023, 6, 1, 0, valid = TRUE)
  test_datey_round_trip(2054, 6, 30, 0, valid = TRUE)
  test_datey_round_trip(2067, 7, 1, 0, valid = TRUE)
  test_datey_round_trip(2098, 7, 31, 0, valid = TRUE)
  test_datey_round_trip(2101, 8, 1, 0, valid = TRUE)
  test_datey_round_trip(2132, 8, 31, 0, valid = TRUE)
  test_datey_round_trip(2145, 9, 1, 0, valid = TRUE)
  test_datey_round_trip(2176, 9, 30, 0, valid = TRUE)
  test_datey_round_trip(2189, 10, 1, 0, valid = TRUE)
  test_datey_round_trip(2210, 10, 31, 0, valid = TRUE)
  test_datey_round_trip(2223, 11, 1, 0, valid = TRUE)
  test_datey_round_trip(2254, 11, 30, 0, valid = TRUE)
  test_datey_round_trip(2267, 12, 1, 0, valid = TRUE)
  test_datey_round_trip(2298, 12, 31, 0, valid = TRUE)

  test_datey_round_trip(2001, 2, 29, 0, valid = FALSE)
  test_datey_round_trip(2000, 3, 0, 0, valid = FALSE)
})

test_that("`datey` works with vector and scalar `day_fraction`s", {

  year <- c(1960, 2001, 2099);
  month <- c(11, 3, 7);
  day <- c(3, 31, 15);
  df_scalar <- 0.25;
  df_vector <- c(0.25, 0.25, 0.25);

  datey_scalar <- datey::datey(year, month, day,
                               df_scalar)

  datey_vector <- datey::datey(year, month, day,
                               df_vector)


  expect_identical(datey_vector, datey_scalar)
})

test_that("`datey` matches `Date`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(as.Date("1000-01-01"), 0))
  expect_identical(as_datey("2999-12-31.0"), as_datey(as.Date("2999-12-31"), 0))
  expect_identical(as_datey("0999-12-31.5"), as_datey(as.Date("0999-12-31"), 0))
  expect_identical(as_datey("3000-01-01.0"), as_datey(as.Date("3000-01-01"), 0))
})

test_that("`datey` matches `POSIXct`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(as.POSIXct("1000-01-01")))
  expect_identical(as_datey("2999-12-31.5"), as_datey(as.POSIXct("2999-12-31 12:00")))
  expect_identical(as_datey("0999-12-31.5"), as_datey(as.POSIXct("0999-12-31 12:00")))
  expect_identical(as_datey("3000-01-01.0"), as_datey(as.POSIXct("3000-01-01")))
})

test_that("`datey` matches `POSIXlt`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(as.POSIXlt("1000-01-01")))
  expect_identical(as_datey("2999-12-31.5"), as_datey(as.POSIXlt("2999-12-31 12:00")))
  expect_identical(as_datey("0999-12-31.5"), as_datey(as.POSIXlt("0999-12-31 12:00")))
  expect_identical(as_datey("3000-01-01.0"), as_datey(as.POSIXlt("3000-01-01")))
})
