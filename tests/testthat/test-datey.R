test_that("`is_leap_year` works", {
  expect_identical(datey::is_leap_year(2009.0), FALSE)
  expect_identical(datey::is_leap_year(2008L),  TRUE)
  expect_identical(datey::is_leap_year(2000),  TRUE)
  expect_identical(datey::is_leap_year(1901),  FALSE)
  expect_identical(datey::is_leap_year(1900),  FALSE)
})

test_that("`is_leap_year` gives `NA` for invalid args", {
  expect_equal(datey::is_leap_year(NA), NA)
  expect_equal(datey::is_leap_year(2000.1), NA)
  expect_equal(datey::is_leap_year("2000"), NA)
  #expect_equal(datey::is_leap_year(as.Date("2009-08-02")), NA)
})

test_datey <- function(year, month, day, day_fraction, valid) {
  datey <- datey::datey(year = year, month = month, day = day, day_fraction = day_fraction)
  ymdf <- datey::as.ymdf(datey)
  expect_identical(ymdf$year, ifelse(valid, as.integer(year), NA_integer_))
  expect_identical(ymdf$month, ifelse(valid, as.integer(month), NA_integer_))
  expect_identical(ymdf$day, ifelse(valid, as.integer(day), NA_integer_))
  expect_equal(ymdf$day_fraction, ifelse(valid, as.double(day_fraction), NA_real_))
}

test_valid <- function(year, month, day, day_fraction) {
  datey <- datey::datey(year = year, month = month, day = day, day_fraction = day_fraction)
  ymdf <- datey::as.ymdf(datey)
  expect_identical(ymdf$year, as.integer(year))
  expect_identical(ymdf$month, as.integer(month))
  expect_identical(ymdf$day, as.integer(day))
  expect_equal(ymdf$day_fraction, as.double(day_fraction))
}

test_that("`datey` round-trips from ymdf and back", {
  test_datey(year = 1800, month = 1, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 1857, month = 1, day = 31, day_fraction = 0.25, valid = TRUE)
  test_datey(year = 1899, month = 2, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 1904, month = 2, day = 29, day_fraction = 0, valid = TRUE)
  test_datey(year = 2000, month = 2, day = 29, day_fraction = 0, valid = TRUE)
  test_datey(year = 2004, month = 2, day = 29, day_fraction = 0, valid = TRUE)
  test_datey(year = 1901, month = 3, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 1932, month = 3, day = 31, day_fraction = 0, valid = TRUE)
  test_datey(year = 1945, month = 4, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 1976, month = 4, day = 30, day_fraction = 0, valid = TRUE)
  test_datey(year = 1989, month = 5, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2010, month = 5, day = 31, day_fraction = 0, valid = TRUE)
  test_datey(year = 2023, month = 6, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2054, month = 6, day = 30, day_fraction = 0, valid = TRUE)
  test_datey(year = 2067, month = 7, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2098, month = 7, day = 31, day_fraction = 0, valid = TRUE)
  test_datey(year = 2101, month = 8, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2132, month = 8, day = 31, day_fraction = 0, valid = TRUE)
  test_datey(year = 2145, month = 9, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2176, month = 9, day = 30, day_fraction = 0, valid = TRUE)
  test_datey(year = 2189, month = 10, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2210, month = 10, day = 31, day_fraction = 0, valid = TRUE)
  test_datey(year = 2223, month = 11, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2254, month = 11, day = 30, day_fraction = 0, valid = TRUE)
  test_datey(year = 2267, month = 12, day = 1, day_fraction = 0, valid = TRUE)
  test_datey(year = 2298, month = 12, day = 31, day_fraction = 0, valid = TRUE)

  test_datey(year = 2001, month = 2, day = 29, day_fraction = 0, valid = FALSE)
  test_datey(year = 2000, month = 3, day = 15, day_fraction = 1, valid = FALSE)
})

test_that("`datey` works with vector and scalar `day_fraction`s", {

  year = c(1960, 2001, 2099);
  month = c(11, 3, 7);
  day = c(3, 31, 15);
  df_scalar = 0.25;
  df_vector = c(0.25, 0.25, 0.25);

  datey_scalar <- datey::datey(year = year, month = month, day = day,
    day_fraction = df_scalar)

  datey_vector <- datey::datey(year = year, month = month, day = day,
    day_fraction = df_vector)


  expect_identical(datey_vector, datey_scalar)
})


