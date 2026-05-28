# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Is `x` a leap year?
#'
#' @description
#' Tests whether a date or year is a leap year.
#'
#' For years outside \[1000,3000), this returns `NA`.
#'
#' This is an S3 generic. This package provides methods for:
#'
#' - numeric types `double` and `integer` (interpreted as years), and
#' - date types `datey`, `Date`, `POSIXct` and `POSIXlt`.
#'
#' @param x A vector date type or numeric year.
#' @param ... Other arguments (not used in this package).
#' @export
#' @return
#'   `NA` if `x` is not interpretable as a year or date, or outside \[1000,3000),
#'   `TRUE` if `x` is a leap year, otherwise
#'   `FALSE`.
#' @examples
#' any(is_leap_year(c(1900, 1901, 2001))) #FALSE
#' all(is_leap_year(c(1904.1, 2000.5, 2004.9))) #TRUE
is_leap_year <- function(x, ...) UseMethod("is_leap_year")

#' @rdname is_leap_year
#' @export
is_leap_year.default <- function(x, ...) NA
#' @rdname is_leap_year
#' @export
is_leap_year.integer <- function(x, ...) cpp_isLeapYear_integer(x)
#' @rdname is_leap_year
#' @export
is_leap_year.double <- function(x, ...) cpp_isLeapYear_double(x)
#' @rdname is_leap_year
#' @export
is_leap_year.datey <- function(x, ...) cpp_isLeapYear_datey(unclass(x))
#' @rdname is_leap_year
#' @export
is_leap_year.Date <- function(x, ...) is_leap_year(datey(x, strict = FALSE))
#' @rdname is_leap_year
#' @export
is_leap_year.POSIXct <- function(x, ...) is_leap_year(datey(x, strict = FALSE))
#' @rdname is_leap_year
#' @export
is_leap_year.POSIXlt <- function(x, ...) is_leap_year(datey(x, strict = FALSE))
