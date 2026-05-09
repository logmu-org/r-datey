# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# durationy constants ==================================================
test_that("`NA_durationy_` is a `durationy`", expect_identical(is_durationy(NA_durationy_), TRUE))
test_that("`NA_durationy_` is NA", expect_identical(is.na(NA_durationy_), TRUE))
test_that("`valid_duration_years_max` is 2000", expect_identical(valid_duration_years_max, 2000L))

# is_durationy <- function(x) ==================================================
test_that("`is_durationy()`", {
  expect_identical(is_durationy(NA_durationy_), TRUE)
  expect_identical(is_durationy(durationy(1.5)), TRUE)
  expect_identical(is_durationy(durationy(1L)), TRUE)

  expect_identical(is_durationy(NA), FALSE)
  expect_identical(is_durationy(TRUE), FALSE)
  expect_identical(is_durationy(1), FALSE)
  expect_identical(is_durationy(1L), FALSE)
  expect_identical(is_durationy("1"), FALSE)
})

# durationy.default <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`durationy.default()`", {
  expect_identical(durationy(structure(0, class = "FAKE")), NA_durationy_)
})

# durationy.durationy <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`durationy.durationy()`", {
  expect_identical(durationy(durationy(1.23456)), durationy(1.23456))
  expect_identical(durationy(datey::NA_durationy_), datey::NA_durationy_)
})

# durationy.integer <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`durationy.integer()`", {
  expect_identical(durationy(0L), durationy(0))
  expect_identical(durationy(1L), durationy(1))
  expect_identical(durationy(-1L), durationy(-1))
  expect_identical(durationy(2000L), durationy(2000))
  expect_identical(durationy(-2000L), durationy(-2000))
  expect_identical(durationy(2001L, strict = FALSE), datey::NA_durationy_)
  expect_identical(durationy(-2001L, strict = FALSE), datey::NA_durationy_)
})

# durationy.double <- function(x, day_fraction = NULL, strict = TRUE, ...) ==================================================
test_that("`durationy.double()`", {

  expect_identical(durationy(0), durationy("0 yr"))
  expect_identical(durationy(1), durationy("+1 yr"))
  expect_identical(durationy(-1), durationy("-1 yr"))
  expect_identical(durationy(2000 - 1 / (4*365*366)), durationy("+1999.999998 yr"))
  expect_identical(durationy(-(2000 - 1 / (4*365*366))), durationy("-1999.999998 yr"))
  expect_identical(durationy(2000), durationy("+2000 yr"))
  expect_identical(durationy(-2000), durationy("-2000 yr"))
  expect_identical(durationy(2000.0000001, strict = FALSE), datey::NA_durationy_)
  expect_identical(durationy(-2000.0000001, strict = FALSE), datey::NA_durationy_)
})

# durationy.character <- function(x, day_fraction = NULL, blank_is_NA = FALSE, strict = TRUE, ...) ==================================================
test_that("`durationy.character()`", {

  testX <- function(years, text_no_units) {
    durationy <- durationy(years)

    from_text_no_units <- durationy(text_no_units, year_unit = "")
    expect_identical(from_text_no_units, durationy)

    text_with_yr_units <- paste0(text_no_units, " yr")
    from_text_with_yr_units <- durationy(text_with_yr_units)
    expect_identical(from_text_with_yr_units, durationy)

    text_with_XX_units <- paste0(text_no_units, " ABCDEFGHIJABCDEFGHIJ")
    from_text_with_XX_units <- durationy(text_with_XX_units, year_unit = "ABCDEFGHIJABCDEFGHIJ")
    expect_identical(from_text_with_XX_units, durationy)

    # Next line replaces hyphen-minus (U+002D) with true minus (U+2212)
    text_unicode_minus <- chartr('\u002D', '\u2212', text_no_units)
    from_text_unicode_minus <- durationy(text_unicode_minus, year_unit = "")
    expect_identical(from_text_unicode_minus, durationy)
  }

  testX(0, "0")
  testX(1, "1")
  testX(-1, "-1")
  testX(0.25, "0.25")
  testX(-1/ (4*365*366), "-0.000002")
  testX(-1999.99999813, "-1999.999998")
})
# as.double.durationy <- function(x, ...) ==================================================
# as.numeric dispatches to as.double.XXX
test_that("`is.numeric.durationy()`, `as.numeric.durationy()` and `as.double.durationy()`", {

  d_0 <- durationy(0)
  d_pos <- durationy(1.75)
  d_neg <- durationy(-123.1)

  expect_identical(is.numeric(d_0), TRUE)
  expect_identical(as.numeric(d_0), 0)
  expect_identical(as.double(d_0), 0)

  expect_identical(is.numeric(d_pos), TRUE)
  expect_identical(as.numeric(d_pos), 1.75)
  expect_identical(as.double(d_pos), 1.75)

  expect_identical(is.numeric(d_neg), TRUE)
  expect_identical(as.numeric(d_neg), -123.1)
  expect_identical(as.double(d_neg), -123.1)

  expect_identical(is.numeric(NA_durationy_), TRUE)
  expect_identical(as.numeric(NA_durationy_), NA_real_)
  expect_identical(as.double(NA_durationy_), NA_real_)
})

# as.integer.durationy <- function(x, ...) ==================================================
test_that("`as.integer.durationy()`", {
  expect_identical(as.integer(durationy(0)), 0L)
  expect_identical(as.integer(durationy(2000)), 2000L)
  expect_identical(as.integer(durationy(0.5)), 0L) # Rounds to integer closest to 0
  expect_identical(as.integer(durationy(1.5)), 1L) # Rounds to integer closest to 0
  expect_identical(as.integer(durationy(-0.5)), 0L) # Rounds to integer closest to 0
  expect_identical(as.integer(durationy(-1.5)), -1L) # Rounds to integer closest to 0
  expect_identical(as.integer(NA_durationy_), NA_integer_)
})

# is.na.durationy <- function(x) ==================================================
test_that("`is.na.durationy()`", {
  expect_identical(is.na(NA_durationy_), TRUE)
  expect_identical(is.na(durationy(2000.5, strict = FALSE)), TRUE)

  expect_identical(is.na(durationy(0.1234)), FALSE)
  expect_identical(is.na(durationy(-123.4567)), FALSE)
})

# anyNA.durationy = function(x, recursive=FALSE) ==================================================
test_that("`anyNA.durationy()`", {

  na_1 <- NA_durationy_
  na_2 <- durationy(2001L, strict = FALSE)
  na_3 <- durationy(-2000.000002, strict = FALSE)

  d_1 <- durationy(1L)
  d_2 <- durationy(-123.456)
  d_3 <- durationy(2000)

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

# c.durationy <- function(..., recursive = FALSE) ==================================================
test_that("`c()` on `durationy`", {
  expect_identical(is_durationy(c(durationy(1), durationy(2))), TRUE)
  expect_identical(is_durationy(c(NA_durationy_, durationy(3))), TRUE)
})

# format.durationy <- function(x, include_plus = FALSE, use_true_minus = TRUE, year_unit = "yr", ...) ==================================================
test_that("`format.durationy()`", {

  d_0 <- durationy(0)
  d_eps <- durationy(1/(4*365*366))
  d_pos <- durationy(1.75)
  d_neg <- durationy(-123.1)
  d_subnegmax <- durationy(-(2000 - 1/(4*365*366)))
  d_posmax <- durationy(2000)

  expect_identical(format(NA_durationy_), NA_character_)

  # True minus is U+2212

  expect_identical(format(d_0), "0 yr")
  expect_identical(format(d_eps), "0.000002 yr")
  expect_identical(format(d_pos), "1.75 yr")
  expect_identical(format(d_neg), "\u2212123.1 yr")
  expect_identical(format(d_subnegmax), "\u22121999.999998 yr")
  expect_identical(format(d_posmax), "2000 yr")

  expect_identical(format(d_0, include_plus = TRUE), "0 yr")
  expect_identical(format(d_eps, include_plus = TRUE), "+0.000002 yr")
  expect_identical(format(d_pos, include_plus = TRUE), "+1.75 yr")

  expect_identical(format(d_neg, use_true_minus = FALSE), "-123.1 yr")
  expect_identical(format(d_subnegmax, use_true_minus = FALSE), "-1999.999998 yr")

  expect_identical(format(d_0, year_unit = ""), "0")
  expect_identical(format(d_eps, year_unit = "A"), "0.000002 A")
  expect_identical(format(d_pos, year_unit = ""), "1.75")
  expect_identical(format(d_neg, year_unit = "ABC"), "\u2212123.1 ABC")
  expect_identical(format(d_subnegmax, year_unit = ""), "\u22121999.999998")
  expect_identical(format(d_posmax, year_unit = "ABCDEFGHIJABCDEFGHIJ"), "2000 ABCDEFGHIJABCDEFGHIJ")
})

# print.durationy <- function(x, include_day_fraction = TRUE, max = NULL, ...) ==================================================
# NO EXPLICIT TEST
