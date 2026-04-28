test_that("`datey` is numeric", {
  expect_identical(base::is.numeric(datey::datey(2000, 1, 1, 0)), TRUE)
})

test_that("`datey` and `start_day`, `mid_day` and `end_day` are consistent", {
  y <- c(999, 1000, 1900, 1950, 2000, 2020, 2999, 3000)
  m <- c(12, 1, 6, 3, 2, 5, 6, 1)
  d <- c(31, 1, 15, 3, 29, 20, 10, 1)

  expect_identical(datey(y, m, d, 0), start_day(y, m, d))
  expect_identical(datey(y, m, d, 0.5), mid_day(y, m, d))
  expect_identical(datey(y, m, d, 1), end_day(y, m, d))
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

  datey_scalar <- datey::datey(year, month, day, df_scalar)

  datey_vector <- datey::datey(year, month, day, df_vector)

  expect_identical(datey_vector, datey_scalar)
})


test_that("`as_datey` works for `integer`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(1000L))
  expect_identical(as_datey("2999-01-01.0"), as_datey(2999L))
  expect_identical(as_datey("0999-01-01.0"), as_datey(999L))
  expect_identical(as_datey("3000-01-01.0"), as_datey(3000L))
})
test_that("`as_datey` works for `double`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(1000))
  expect_identical(as_datey("2999-12-31.0"), as_datey(2999 + 364/365))
  expect_identical(as_datey("0999-12-31.5"), as_datey(999))
  expect_identical(as_datey("3000-01-01.0"), as_datey(3000))
})
test_that("`as_datey` works for `character`", {
  # 1 day in a non-leap year is 534360 / 365 = 1464 clicks
  # 1 click / 1 day = 1 / 1464 = 0.0006830601
  expect_identical(as_datey("1999-01-01.0007"), as_datey(1999 + 1/534360))
  expect_identical(as_datey("1999-01-01.0006830601"), as_datey(1999 + 1/534360))
  # 1 July is 181 days
  # 777 clicks / 1 day = 777 / 1464 = 0.530737705
  expect_identical(as_datey("1999-07-01.5307"), as_datey(1999 + (1464 * 181 + 777)/534360))
  expect_identical(as_datey("1999-07-01.530737705"), as_datey(1999 + (1464 * 181 + 777) /534360))
  # (1 day less 1 click) / 1 day = 1463 / 1464 = 0.99931694
  expect_identical(as_datey("1999-12-31.9993"), as_datey(1999 + (1464 * 364 + 1463)/534360))
  expect_identical(as_datey("1999-12-31.99931694"), as_datey(1999 + (1464 * 364 + 1463) /534360))

  # 1 day in a leap year is 534360 / 366 = 1460 clicks
  # 1 click / 1 day = 1 / 1460 = 0.0006849315
  expect_identical(as_datey("2000-01-01.0007"), as_datey(2000 + 1/534360))
  expect_identical(as_datey("2000-01-01.0006849315"), as_datey(2000 + 1/534360))
  # 1 July is 182 days
  # 777 clicks / 1 day = 777 / 1460 = 0.53219178
  expect_identical(as_datey("2000-07-01.5322"), as_datey(2000 + (1460 * 182 + 777)/534360))
  expect_identical(as_datey("2000-07-01.53219178"), as_datey(2000 + (1460 * 182 + 777) /534360))
  # (1 day less 1 click) / 1 day = 1459 / 1460 = 0.99931506
  expect_identical(as_datey("2000-12-31.9993"), as_datey(2000 + (1460 * 365 + 1459)/534360))
  expect_identical(as_datey("2000-12-31.99931506"), as_datey(2000 + (1460 * 365 + 1459) /534360))
})

test_that("`as_datey` works for `Date`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(as.Date("1000-01-01"), 0))
  expect_identical(as_datey("2999-12-31.0"), as_datey(as.Date("2999-12-31"), 0))
  expect_identical(as_datey("0999-12-31.5"), as_datey(as.Date("0999-12-31"), 0))
  expect_identical(as_datey("3000-01-01.0"), as_datey(as.Date("3000-01-01"), 0))
})
test_that("`as_datey` works for `POSIXct`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(as.POSIXct("1000-01-01")))
  expect_identical(as_datey("2999-12-31.5"), as_datey(as.POSIXct("2999-12-31 12:00")))
  expect_identical(as_datey("0999-12-31.5"), as_datey(as.POSIXct("0999-12-31 12:00")))
  expect_identical(as_datey("3000-01-01.0"), as_datey(as.POSIXct("3000-01-01")))
})
test_that("`as_datey` works for `POSIXlt`", {
  expect_identical(as_datey("1000-01-01.0"), as_datey(as.POSIXlt("1000-01-01")))
  expect_identical(as_datey("2999-12-31.5"), as_datey(as.POSIXlt("2999-12-31 12:00")))
  expect_identical(as_datey("0999-12-31.5"), as_datey(as.POSIXlt("0999-12-31 12:00")))
  expect_identical(as_datey("3000-01-01.0"), as_datey(as.POSIXlt("3000-01-01")))
})
