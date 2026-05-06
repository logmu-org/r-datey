# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# **** TO DO ****
# sort(x, decreasing = FALSE, na.last = NA, ...)
# is.unsorted
# mean, max, min, other summary/stats methods
# **** DONE ****
# as.character
# as.double (automatically includes is.numeric)
# as.integer
# is.na,
# anyNA
# c
# **** TO CONSIDER ****
# length, length<-
# lengths
# dimnames, dimnames<-
# dim, dim<-
# names, names<-
# levels<-
# @, @<-,
# unlist, cbind, rbind
# as.complex, as.logical, as.raw, as.vector
# as.call, as.environment
# is.array, is.matrix,
# nchar
# rep, rep.int rep_len
# seq.int (which dispatches methods for "seq")
# xtfrm
# **** NOT REQUIRED ****
# [, [[, $, [<-, [[<-, $<-
# is.nan, is.finite is.infinite -- these automatically work


#' Handling invalid dates
#'
#' @description
#'
#' Valid dates within the datey system have calendar years in the interval
#' [1000,3000).
#'
#' Dates outside this interval are treated as NA.
#'
#' Use
#'
#' - `is.na()` to test whether `datey` is NA by element, and
#' - `anyNA()` to test whether any element of a `datey` is NA.
#'
#' The `datey` version of NA is `NA_datey_`.
#'
#' For convenience, the following constants are also available:
#' - `valid_years_start`: The first *valid* calendar year (1000).
#' - `valid_years_end`: The first *invalid* calendar year after
#' `valid_years_start` (3000).
#'
#' For performance reasons, intermediate calculations may not check for NAs.
#'
#' @param x The `datey` to test for validity.
#' @param recursive	Unused.
#' @return A single logical value, `TRUE` or `FALSE`, never `NA` and never
#'   anything other than a single value.
#' @keywords NA
#' @seealso as_datey
#' @examples
#'   x <- c(NA_datey_, as_datey(2000))
#'   is.na(x) # c(TRUE, FALSE)
#'   anyNA(x) # TRUE
#' @name datey.NA
NULL

#' @rdname datey.NA
#' @export
NA_datey_ <- structure(NA_integer_, class = "datey")
#' @rdname datey.NA
#' @export
is.na.datey <- function(x) {
  clicks <- unclass(x)
  is.na(clicks) | clicks < 534360000L | clicks >= 1603080000L
}
#' @rdname datey.NA
#' @export
anyNA.datey = function(x, recursive = FALSE) any(is.na(x))
#' @rdname datey.NA
#' @export
valid_years_start <- 1000L
#' @rdname datey.NA
#' @export
valid_years_end <- 3000L

#' Check if an object is a `datey`
#'
#' Checks whether an object is a `datey`.
#'
#' @param x The object to test.
#' @export
is_datey <- function(x) typeof(x) == "integer" && inherits(x, "datey")

#' Create a `datey`
#'
#' @description
#'
#' Create a `datey` from
#' a year, month, day and, for `datey()`, a day-fraction.
#'
#' In general, prefer the explicit [start_day()], [mid_day()] and [end_day()]
#' versions.
#'
#' To deconstruct a `datey`, use [as_ymdf()].
#'
#' The lengths of vector arguments must be multiples of each other.
#'
#' # Edge cases
#'
#' The following are special cases:
#'
#' 1. `(year = 999, month = 12, day = 31, day_fraction = 1`). This *will* cause
#' an error, even though in theory it represents the legal `datey` 1000-01-01.0.
#'
#' 1. `(year = 2999, month = 12, day = 31, day_fraction = 1`). This will *not*
#' cause an error, even though in theory it represents the illegal `datey`
#' 3000-01-01.0. (The resulting `datey` will be invalid though.)
#'
#' @param year
#'   Calendar year.
#'   Valid years are from 1000 (inclusive) to 3000 (exclusive).
#'   If provided as `double` then these *must be integers*.
#' @param month
#'   Month number in calendar year, with 1 representing January.
#'   If provided as `double` then these *must be integers*.
#' @param day
#'   Day number in month, with 1 representing the first day of the month.
#'   If provided as `double` then these *must be integers*.
#' @param day_fraction
#'   The fraction of the day, in \[0,1\].
#'   0 means the start of the day,
#'   0.5 means the middle of the day, and
#'   1 means the end of the day
#'   (which is identical to the start of the next day).
#' @param strict
#' How to handle calendar years less than 1000 or greater than or equal to 3000 and day
#' fractions not in the interval \[0,1\].
#' - If `strict` is `TRUE` -- the default -- then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned.
#'
#' (NA arguments result in NA regardless of `strict`.)
#' @export
datey <- function(year, month, day, day_fraction, strict = TRUE) {

  day_fraction <- as_double_for_cpp(day_fraction)

  ensure_is_switch(strict)

  # We expect a common case to be
  # `year`, `month` and `day` are vectors of `double`, and
  # `day_fraction` is a scalar,
  #
  # In such a case, conversion of the vectors of `double` to vectors of
  # `integer` is inefficient because it creates 3 new vectors.
  #
  # So we pull out this special case as its own C++ method.

  if (is.double(year) && is.double(month) && is.double(day)
    && length(day_fraction) == 1L
    && length(year) == length(month) && length(year) == length(day)
    ) {
    clicks <- cpp_dateyFromYMDF_dblYMD(year, month, day, day_fraction, strict)
  }
  else {
    year <- as_integer_for_cpp(year)
    month <- as_integer_for_cpp(month)
    day <- as_integer_for_cpp(day)

    clicks <- cpp_dateyFromYMDF(year, month, day, day_fraction, strict)
  }

  structure(clicks, class = "datey")
}

#' @rdname datey
#' @export
start_day <- function(year, month, day, strict = TRUE) datey(year, month, day, day_fraction = 0, strict)
#' @rdname datey
#' @export
mid_day <- function(year, month, day, strict = TRUE) datey(year, month, day, day_fraction = 0.5, strict)
#' @rdname datey
#' @export
end_day <- function(year, month, day, strict = TRUE) datey(year, month, day, day_fraction = 1, strict)

#' Get year, month day and day fraction for a `datey`
#'
#' @description
#' `as_ymdf()` returns a list of the `year`, `month`, `day` and `day_fraction`
#' breakdown of a `datey`, where
#' - `year` is an `integer` in \[1000,3000),
#' - `month` is an `integer` in \[1,12],
#' - `day` is an `integer` in \[1,N], where N is the number of days
#' in the month specified by `year` and `month`, and
#' - `day_fraction` is a `double` in \[0,1) representing the fraction of the day,
#' where e.g. 0 means the start and 0.5 means the middle of the day.
#'
#' If the `datey` was constructed using `end_day` or `day_fraction = 1` then
#' `as_ymdf()` will return the *start* of the *next* day with `day_fraction =
#' 0`.
#' @param datey The `datey` to deconstruct.
#' @export
as_ymdf <- function(datey) {
  ensure_is_datey(datey)
  cpp_dateyToYMDF(datey)
}

#' Convert an object to a `datey`
#'
#' @description
#' This is an S3 generic. This package provides methods for the
#' following classes:
#'
#' - `double` and `integer` -- the value is interpreted as the specified
#' calendar year, with the fractional part representing the fraction of the
#' year. For instance, `as_datey(2000.5)` means halfway though the year 2000.
#' (`integer` means the *start* of the calendar year, e.g. `as_datey(2000L)`
#' means the start of the year 2000.
#' - `datey`, `Date` and `POSIXct` and `POSIXlt` are interpreted as fractional
#' years. If no `day_fraction` argument is provided then the day fraction is
#' determined by the hours, minutes, and seconds. For instance,
#' `as_datey(as.POSIXct("2000-03-21 12:00"))` means the *middle* of 2000-03-21.
#' Note that in standard use, a `Date` has no fractional part and therefore
#' means the *start* of the day. For instance,
#' `as_datey(as.Date("2000-03-21 12:00"))` means the *start* of 2000-03-21.
#' - `character` -- If `day_fraction` *is* provided then the text format must
#' be in ISO 8601 extended format, i.e. YYYY-MM-DD. If `day_fraction` *is*
#' provided then the text format must be YYYY-MM-DD.FFF, where .FFF is the day
#' fraction and must be present even if the fraction is 0, e.g. "2000-01-01.0"
#' for the start of 1 January 2000.
#'
#' The lengths of vector arguments must be multiples of each other.
#'
#' @param
#' x A vector of the S3 class.
#' @param day_fraction
#' The `day_fraction` override. Defaults to `NULL`.
#'
#' - If `day_fraction` is *not* provided then `x` is used to derive both
#' the calendar year, month, day *and* the day fraction.
#'
#' - If `day_fraction` *is* provided then `x` is used solely to derive the
#' calendar year, month and day, while `day_fraction` provides the position in
#' the day. `day_fraction` must lie in the inclusive interval \[0,1\], with
#' - 0 meaning the start of the day,
#' - 0.5 meaning the middle of the day, and
#' - 1 meaning the end of the day (which is identical to the start of the next
#' day).
#' @param strict
#' How calendar years less than 1000 or greater than or equal to 3000 and day
#' fractions not in the interval \[0,1\] should be
#' handled.
#' - If `strict` is `TRUE` -- the default -- then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned.
#'
#' (NAs will result in NA regardless of this switch.)
#' @param ... Other arguments (not used in this package).
#' @export
as_datey <- function(x, day_fraction = NULL, strict = TRUE, ...) UseMethod("as_datey")
#' @rdname as_datey
#' @export
as_datey.default <- function(x, day_fraction = NULL, strict = TRUE, ...) NA_datey_
#' @rdname as_datey
#' @export
as_datey.datey <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  #ensure_is_datey(x)
  ensure_is_switch(strict)
  if (!is.null(day_fraction)) {
    day_fraction <- as_double_for_cpp(day_fraction)
    x <- cpp_dateyWithNewDayFraction(x, day_fraction, strict)
    x <- structure(x, class = "datey")
  }
  x
}
#' @rdname as_datey
#' @export
as_datey.integer <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  ensure_is_switch(strict)
  clicks <- ifelse(x >= 1000L & x < 3000L, x * 534360L, NA_integer_)
  datey <- structure(clicks, class = "datey")
  if (!is.null(day_fraction)) datey <- as_datey.datey(datey, day_fraction, ...)
  datey
}
#' @rdname as_datey
#' @export
as_datey.double <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  ensure_is_switch(strict)
  clicks <- ifelse(x >= 1000 & x < 3000, round(x * 534360), NA_real_)
  datey <- structure(as.integer(clicks), class = "datey")
  if (!is.null(day_fraction)) datey <- as_datey.datey(datey, day_fraction, ...)
  datey
}
#' @rdname as_datey
#' @export
as_datey.Date <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  ensure_is_switch(strict)
  x <- as_double_for_cpp(unclass(x))
  if (is.null(day_fraction)) clicks <- cpp_dateyFromRDate(x, strict)
  else {
    day_fraction <- as_double_for_cpp(day_fraction)
    clicks <- cpp_dateyFromRDateAndFraction(x, day_fraction, strict)
  }
  datey <- structure(as.integer(clicks), class = "datey")
}
#' @rdname as_datey
#' @export
as_datey.POSIXct <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  as_datey.POSIXlt(as.POSIXlt(x), day_fraction, strict, ...)
}
#' @rdname as_datey
#' @export
as_datey.POSIXlt <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  # From POSIXlt docs:
  # `sec` in 0–61: seconds, allowing for leap seconds.
  # `min` in 0–59: minutes.
  # `hour` in 0–23: hours.
  # `year`: years since 1900.
  # `yday` in 0–365: day of the year (365 only in leap years).

  ensure_is_switch(strict)

  year <- as.integer(x$year) + 1900L

  seconds <- (((x$yday * 24 + x$hour) * 60 + x$min) * 60 + x$sec)
  # (366 or 365) * 24 * 60 * 60
  seconds_in_year <- ifelse(is_leap_year(year), 31622400, 31536000)
  year_fraction <- seconds / seconds_in_year
  # Ignore leap seconds added on 30 June
  # But leap seconds on 31 December would take the fraction over 1
  year_fraction <- pmin(1, year_fraction)

  clicks <- year * 534360L + as.integer(round(year_fraction * 534360))
  clicks <- ifelse(year < 1000L | year >= 3000L, NA_integer_, clicks)

  datey <- structure(as.integer(clicks), class = "datey")
  as_datey.datey(datey, day_fraction, strict)
}

#' Parse text as a `datey`
#'
#' @description
#' If `day_fraction` *is* provided then the text must be in ISO 8601 extended
#' format, i.e. "YYYY-MM-DD".
#'
#' If `day_fraction` is *not* provided then the text must be formatted as
#' "YYYY-MM-DD.FFF", where ".FFF" is the optional day fraction. This means that
#' e.g. "2000-01-01" represents the *start* of 1 January 2000.
#'
#' If `blank_is_NA` is `TRUE` then blanks are treated as `NA`.
#'
#' If `strict` is `TRUE` (which is the default) then non-compliant text will
#' stop execution.
#'
#' The lengths of vector arguments must be multiples of each other.
#'
#' @param x
#' Vector of text items to be parsed.
#' @param day_fraction
#' The `day_fraction` override. Defaults to `NULL`.
#'
#' - If `day_fraction` is *not* provided then `x` is used to derive both
#' the calendar year, month, day *and* the day fraction.
#'
#' - If `day_fraction` *is* provided then `x` is used solely to derive the
#' calendar year, month and day, while `day_fraction` provides the position in
#' the day. `day_fraction` must lie in the inclusive interval \[0,1\], with
#' - 0 meaning the start of the day,
#' - 0.5 meaning the middle of the day, and
#' - 1 meaning the end of the day (which is identical to the start of the next
#' day).
#' @param strict
#' How non-compliant text (including calendar years less than
#' 1000 or greater than or equal to 3000) should be handled.
#' - If `strict` is `TRUE` then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned.
#' Defaults to `TRUE`.
#' @param blank_is_NA
#' Whether blanks should be treated as `NA`.
#' Defaults to `FALSE`.
#' @param ... Other arguments (not used in this package).
#' @export
as_datey.character <- function(x,
  day_fraction = NULL,
  strict = TRUE,
  blank_is_NA = FALSE,
  ...
) {
  ensure_is_switch(strict)
  ensure_is_switch(blank_is_NA)
  if (is.null(day_fraction)) {
    clicks <- cpp_dateyFromRStringOnly(x, strict, blank_is_NA)
  }
  else {
    day_fraction <- as_double_for_cpp(day_fraction)
    clicks <- cpp_dateyFromRStringAndDayFraction(x, day_fraction, strict, blank_is_NA)
  }
  structure(clicks, class = "datey")
}

#' @rdname as_datey
#' @export
as_start_day <- function(x, ...) as_datey.datey(datey, day_fraction = 0)
#' @rdname as_datey
#' @export
as_mid_day <- function(x, ...) as_datey.datey(datey, day_fraction = 0.5)
#' @rdname as_datey
#' @export
as_end_day <- function(x, ...) as_datey.datey(datey, day_fraction = 1)

#' Test whether a `datey` is the start or middle of a day
#'
#' @description
#' `is_start_day()` tests whether the `datey` is a valid start (or end) of
#'  a day, i.e. the boundary between two days.
#'
#' `is_mid_day()` tests whether the `datey` is a valid exact the middle of
#'  a day.
#'
#' @param datey The (vector of ) `datey` to test.
#' @export
is_start_day <- function(datey) {
  ensure_is_datey(datey)
  clicks <- convert_datey_to_valid_clicks(datey)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year.integer(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == 0L
}
#' @rdname is_start_day
#' @export
is_mid_day <- function(datey) {
  ensure_is_datey(datey)
  clicks <- convert_datey_to_valid_clicks(datey)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year.integer(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == clicks_per_day / 2L
}

#' A `datey` as years
#'
#' @description
#' A `datey` converted to years.
#'
#' For example,
#' - the *start* of 2000-01-01 (or, equivalently, the *end* of 1999-12-31),
#' results in `2000`, and
#' - the *middle* of the calendar year 2000 results in `2000.5`.
#'
#' A `datey` converted to integer years.
#'
#' For example, 2000-01-01.0 and 2000-12-31.0 both result in `2000`.
#'
#' @param x The `datey` to convert to years.
#' @param ... Further arguments to be passed from or to other methods.
#' @export
as.double.datey <- function(x, ...) {
  clicks <- convert_datey_to_valid_clicks(x)
  clicks / 534360
}
#' @rdname as.double.datey
#' @export
as.integer.datey <- function(x, ...) {
  clicks <- convert_datey_to_valid_clicks(x)
  clicks %/% 534360L
}

#' Concatenate `datey` vectors
#'
#' @description
#' Combines (flattens) `datey` vectors.
#'
#' If the first element in `c(...)` is not a `datey` then this method will not
#' be called. For instance, `c(NA, as_datey("2000-01-01.0"))`
#'
#' @param ... The items to combine
#' @param recursive Unused.
#'
#' @returns
#'   [c()] returns a vector of `datey`s.
#'
#'   \[cbind()\] and \[rbind()\] return a matrix, data.frame or list with dimensions
#'
#' @note
#' R currently only dispatches generic `c` to method `c.datey` if the
#'   first argument is a `datey`.
#'
#' @keywords classes manip
#' @examples
#'   c(as_datey(2000), as_datey("2020-01-01.0"))
#'   #cbind(1:6, as.datey(2001:2020))
#'   #rbind(1:6, as.datey(2001:2020))
#' @export
c.datey <- function(..., recursive = FALSE) {
  args <- list(...)
  if (!all(vapply(args, inherits, TRUE, "datey")))
    stop("All arguments must inherit from \"datey\".")

  # Concatenate the underlying numeric (integer) values
  result <- NextMethod("c")

  # Re-apply class
  class(result) <- "datey"
  result
}

#' Format or print a `datey`
#'
#' @description
#' A `datey` is printed as either
#' - `YYYY-MM-DD`, i.e. ISO 8601 extended date format, or
#' - `YYYY-MM-DD.FFF` where `.FFF` is the day fraction part (included even if
#' the day fraction is 0).
#'
#' Note that a `datey` created as the end of a day (or with day fraction 1) will
#' print as the start of the following day.
#' @param x The `datey` to print or format.
#' @param include_day_fraction Whether to include the fractional day part.
#' Defaults to `FALSE`.
#' @param  max Numeric or `NULL`, specifying the maximal number of entries to be
#' printed. When `NULL`, `getOption("max.print")` used. Defaults to `NULL`.
#' @param ... Further arguments to be passed from or to other methods.
#' @export
format.datey <- function(x, include_day_fraction = TRUE, ...) {
  ensure_is_datey(x)
  ensure_is_switch(include_day_fraction)
  cpp_dateyToRString(x, include_day_fraction)
}

#' @rdname format.datey
#' @export
print.datey <- function(x, include_day_fraction = TRUE, max = NULL, ...) {
  if (is.null(max)) max <- getOption("max.print", 9999L)

  if (max < length(x)) {
    print(noquote(format(x[seq_len(max)], include_day_fraction)), max=max+1, ...)
    cat(" [ reached 'max' / getOption(\"max.print\") -- omitted",
        length(x) - max, 'entries ]\n')
  } else if(length(x)) {
    print(noquote(format(x, include_day_fraction)), max = max, ...)
  }
  else {
    cat(class(x)[1L], "of length 0\n")
  }

  invisible(x)
}
