test_that("`is_leap_year` on years 1000 to 2999 ", {

  integer_year <- 1000L:2999L
  # Any fractions will do but =, < and > that 0.5 is vulnerable to round so test
  # these explicitly
  double_year <- integer_year + ((integer_year %%  13L) %%  4L) / 4

  expected <- (integer_year %% 4L == 0L) & (integer_year %% 100L != 0L | (integer_year %% 400L == 0L))

  expect_identical(is_leap_year(integer_year), expected)
  expect_identical(is_leap_year(double_year), expected)
  expect_identical(is_leap_year(datey(double_year)), expected)
})

test_that("`is_leap_year` examples", {
  expect_false(any(is_leap_year(c(1900, 1901, 2001, 3000))))
  expect_true(all(is_leap_year(c(1904.1, 2000.5, 2004.9))))
})

test_that("`is_leap_year` on `Date`", {
  expect_identical(is_leap_year(as.Date("1804-04-01")), TRUE)
  expect_identical(is_leap_year(as.Date("1813-08-30")), FALSE)
  expect_identical(is_leap_year(as.Date("2044-01-02")), TRUE)
  expect_identical(is_leap_year(as.Date("2047-12-29")), FALSE)
})

test_that("`is_leap_year` gives `NA` for invalid args", {
  expect_equal(is_leap_year(NA_real_), NA)
  expect_equal(is_leap_year(NA_integer_), NA)
  expect_equal(is_leap_year(NA_datey_), NA)
  expect_equal(is_leap_year(999L), NA)
  expect_equal(is_leap_year(3001L), NA)
  expect_equal(is_leap_year(999.99), NA)
  expect_equal(is_leap_year(3000.000001), NA)
})

