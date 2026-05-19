# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# **** TO DO ****
# sort(x, decreasing = FALSE, na.last = NA, ...)
# is.unsorted
# **** DONE ****
# as.character
# as.double (automatically includes is.numeric)
# as.integer
# is.na,
# anyNA
# c
# mean, max, min, etc [in summary.R]
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

datey_from_clicks <- function(clicks) {
  clicks <- unclass(clicks)
  if (!is.integer(clicks)) clicks <- as.integer(round(clicks))
  structure(clicks, class = c("datey_type", "datey"))
}

#' The `datey` version of NA
#' @seealso [is_NA], [NA_durationy_], [integer_constants]
#' @examples
#'   is_datey(NA_datey_) # TRUE
#' @export
NA_datey_ <- datey_from_clicks(NA_integer_)

#' Whether `datey` or `durationy` are NA
#'
#' @description
#'
#' Valid datey system ranges:
#' - Valid dates are from the start of 1000 to the start of 3000.
#' - Valid durations are 2000 years or less in magnitude.
#'
#' Values outside the above ranges are treated as NA.
#'
#' `is.na()` tests whether a `datey` or `durationy` is NA by element.
#'
#' `anyNA()` tests whether any element of a `datey` or `durationy` is NA.
#'
#' For convenience,
#'
#' - the constants [NA_datey_] and [NA_datey_] are the `datey` and `durationy`
#' versions of NA respectively, and
#' - [integer constants](integer_constants) describing the above valid ranges
#' are also provided.
#'
#' For performance reasons, intermediate calculations may not check for NAs.
#'
#' @param x The `datey` or `durationy` to test for NA
#' @param recursive	Currently required to be `FALSE` (the default)
#' @returns
#'
#' - `is.na()` returns a vector of logical the same length as `x`.
#' - `anyNA()` always returns `TRUE` or `FALSE`, never `NA` and
#' never anything other than a single value.
#' @keywords NA
#' @seealso [NA_datey_], [NA_datey_], [integer_constants]
#' @examples
#'   t <- c(NA_datey_, datey(2000), datey(999.99))
#'   is.na(t) # c(TRUE, FALSE, TRUE)
#'   anyNA(t) # TRUE
#'
#'   d <- c(NA_durationy_, durationy(1.5))
#'   is.na(d) # c(TRUE, FALSE)
#'   anyNA(d) # TRUE
#' @name is_NA
NULL

#' @rdname is_NA
#' @export
is.na.datey <- function(x) {
  clicks <- unclass(x)
  is.na(clicks) | clicks < 534360000L | clicks > 1603080000L
}
#' @rdname is_NA
#' @export
anyNA.datey = function(x, recursive = FALSE) {
  any(is.na(x))
}

#' Is `x` a `datey` or a `durationy`?
#'
#' @description
#'
#' `is_datey()` checks whether an object is a `datey`.
#'
#' `is_durationy()` checks whether an object is a `durationy`.
#'
#' @param x The object to test.
#' @name is_type
NULL

#' @rdname is_type
#' @export
is_datey <- function(x) typeof(x) == "integer" && inherits(x, "datey")

#' Create or decompose a `datey` using calendar year, month, day and day fraction
#'
#' @description
#'
#' The lengths of vector arguments must be multiples of each other.
#'
#' `to_ymdf()` returns a list of the `year`, `month`, `day` and `day_fraction`
#' breakdown of a `datey`, where
#' - `year` is an `integer` in \[1000,3000],
#' - `month` is an `integer` in \[1,12],
#' - `day` is an `integer` in \[1,N], where N is the number of days
#' in the month specified by `year` and `month`, and
#' - `day_fraction` is a `double` in \[0,1) representing the fraction of the day,
#' where e.g. 0 means the start and 0.5 means the middle of the day.
#'
#' If the `datey` was constructed using `end_day` or `day_fraction = 1` then
#' `to_ymdf()` will return the *start* of the *next* day with `day_fraction =
#' 0`.
#'
#' `from_ymdf()` creates a `datey` from a calendar year, month, and day
#' fraction. In practice, prefer one of [start_day()], [mid_day()] or
#' [end_day()] for clarity.
#'
#' @seealso Use [datey()] to create a `datey` direct from years or a base R
#' date.
#'
#' @param year
#'   Calendar year.
#'   Valid years are from 1000 to 3000 (although the only legal date in 3000
#'   is the start of 3000-01-01).
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
#' How to handle invalid arguments.
#' - If `strict` is `TRUE` -- the default -- then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned.
#'
#' (NA arguments result in NA regardless of `strict`.)
#' @param datey A `datey` to be deconstructed.
#' @name ymdf
NULL

#' @rdname ymdf
#' @export
to_ymdf <- function(datey) {
  ensure_is_datey(datey)
  cpp_dateyToYMDF(datey)
}

#' @rdname ymdf
#' @export
from_ymdf <- function(year, month, day, day_fraction, strict = TRUE) {

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

  datey_from_clicks(clicks)
}

#' Create a `datey` for the start, middle or end of a day
#'
#' @description
#'
#' Create a `datey` for the start, middle or end of the day
#' specified by calendar year, month and day.
#'
#' The lengths of vector arguments must be multiples of each other.
#'
#' @seealso Use [datey()] to to create a `datey` direct from years or a base R
#' date. These methods call [from_ymdf()].
#'
#' To deconstruct a `datey`, use [to_ymdf()].
#'
#' @param year
#'   Calendar year.
#'   Valid years are from 1000 to 3000 (although the only legal date in 3000
#'   is the start of 3000-01-01).
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
#' @name xxx_day
NULL

#' @rdname xxx_day
#' @export
start_day <- function(year, month, day, strict = TRUE) from_ymdf(year, month, day, day_fraction = 0, strict)
#' @rdname xxx_day
#' @export
mid_day <- function(year, month, day, strict = TRUE) from_ymdf(year, month, day, day_fraction = 0.5, strict)
#' @rdname xxx_day
#' @export
end_day <- function(year, month, day, strict = TRUE) from_ymdf(year, month, day, day_fraction = 1, strict)

#' Create a `datey` from a calendar year (including its fractional part) or
#' another date type
#'
#' @description
#' This package provides methods to create a `datey` from the following:
#'
#' - `double` and `integer` are interpreted as the specified
#' calendar year, with the fractional part representing the fraction of the
#' year. For instance, `datey(2000.5)` means halfway though the year 2000.
#' (This means that an `integer` argument always indicates the *start* of the
#' calendar year, e.g. `datey(2000L)` is the start of the year 2000.)
#' - `Date` and `POSIXct` and `POSIXlt` are interpreted as fractional
#' years. If no `day_fraction` argument is provided then the day fraction is
#' determined by the hours, minutes, and seconds. For instance,
#' `datey(as.POSIXct("2000-03-21 12:00"))` means the *middle* of 2000-03-21.
#' Note that in standard use, a `Date` has no fractional part and therefore
#' means the *start* of the day. For instance,
#' `datey(as.Date("2000-03-21 12:00"))` means the *start* of 2000-03-21.
#' - `character` -- If `day_fraction` *is* provided then the text format must
#' be in ISO 8601 extended format, i.e. YYYY-MM-DD. If `day_fraction` *is*
#' provided then the text format must be YYYY-MM-DD.FFF, where .FFF is the day
#' fraction and must be present even if the fraction is 0, e.g. "2000-01-01.0"
#' for the start of 1 January 2000.
#' - `datey` is interpreted as is but with the optional `day_fraction` override.
#' Note that a `day_fraction` of 1 will add a day to a day boundary,
#' *even if it was originally defined as an end day*.
#'
#' The lengths of vector arguments must be multiples of each other.
#'
#' This is an S3 generic.
#'
#' @seealso [start_day()], [mid_day()] and [end_day()] to create a `datey`
#' direct from year, month and day.
#'
#' @param
#' x The argument to convert to a `datey`.
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
datey <- function(x, day_fraction = NULL, strict = TRUE, ...) UseMethod("datey")
#' @rdname datey
#' @export
datey.default <- function(x, day_fraction = NULL, strict = TRUE, ...) NA_datey_
#' @rdname datey
#' @export
datey.datey <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  #ensure_is_datey(x)
  ensure_is_switch(strict)
  if (!is.null(day_fraction)) {
    day_fraction <- as_double_for_cpp(day_fraction)
    x <- cpp_dateyWithNewDayFraction(x, day_fraction, strict)
    x <- datey_from_clicks(x)
  }
  x
}
#' @rdname datey
#' @export
datey.integer <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  ensure_is_switch(strict)
  clicks <- ifelse(x >= 1000L & x <= 3000L, x * 534360L, NA_integer_)
  if (strict && anyNA(clicks)) stop("The year is invalid.")
  x <- datey_from_clicks(clicks)
  if (!is.null(day_fraction)) x <- datey.datey(x, day_fraction, strict, ...)
  x
}
#' @rdname datey
#' @export
datey.double <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  ensure_is_switch(strict)
  clicks <- ifelse(x >= 1000 & x <= 3000, round(x * 534360), NA_real_)
  if (strict && anyNA(clicks)) stop("The year is invalid.")
  x <- datey_from_clicks(clicks)
  if (!is.null(day_fraction)) x <- datey.datey(x, day_fraction, strict, ...)
  x
}
#' @rdname datey
#' @export
datey.Date <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  ensure_is_switch(strict)
  x <- as_double_for_cpp(unclass(x))
  if (is.null(day_fraction)) clicks <- cpp_dateyFromRDate(x, strict)
  else {
    day_fraction <- as_double_for_cpp(day_fraction)
    clicks <- cpp_dateyFromRDateAndFraction(x, day_fraction, strict)
  }
  datey_from_clicks(clicks)
}
#' @rdname datey
#' @export
datey.POSIXct <- function(x, day_fraction = NULL, strict = TRUE, ...) {
  datey.POSIXlt(as.POSIXlt(x), day_fraction, strict, ...)
}
#' @rdname datey
#' @export
datey.POSIXlt <- function(x, day_fraction = NULL, strict = TRUE, ...) {
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
  clicks <- ifelse(clicks < 534360000L | year > 1603080000L, NA_integer_, clicks)

  x <- datey_from_clicks(clicks)
  datey.datey(x, day_fraction, strict)
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
#' @name text_to_datey
NULL

#' @rdname text_to_datey
#' @export
datey.character <- function(x,
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
  datey_from_clicks(clicks)
}

#' @rdname xxx_day
#' @export
as_start_day <- function(x, ...) datey.datey(x, day_fraction = 0)
#' @rdname xxx_day
#' @export
as_mid_day <- function(x, ...) datey.datey(x, day_fraction = 0.5)
#' @rdname xxx_day
#' @export
as_end_day <- function(x, ...) datey.datey(x, day_fraction = 1)



#' Is a `datey` the start (or end) or middle of a day?
#'
#' @description
#' `is_start_day()` checks whether `x` is the start or end of a day.
#'
#' `is_mid_day()` checks whether `x` is the middle of a day.
#'
#' Note that these properties are *not* necessarily preserved when a duration of
#' *n*&#xA0;years is added or subtracted.
#'
#' @param x The `datey` to test.
#' @name is_xxx_day
NULL

#' @rdname is_xxx_day
#' @export
is_start_day <- function(x) {
  ensure_is_datey(x)
  clicks <- convert_datey_to_valid_clicks(x)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year.integer(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == 0L
}
#' @rdname is_xxx_day
#' @export
is_mid_day <- function(x) {
  ensure_is_datey(x)
  clicks <- convert_datey_to_valid_clicks(x)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year.integer(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == clicks_per_day / 2L
}

#' Convert a `datey` to calendar years (including fractional part)
#'
#' @description
#' Converts a `datey` to calendar years. The fractional part represents the
#' proportion of the calendar year that has elapsed.
#'
#' For example,
#' - the *start* of 2000-01-01 (or, equivalently, the *end* of 1999-12-31),
#' results in `2000`, and
#' - the *middle* of the calendar year 2000 results in `2000.5`.
#'
#' Note the following:
#'
#' - `as.numeric()` is the same as `as.double()`.
#' - `as.integer()` gives the calendar year, e.g.
#'   `as.integer(datey(2000.9))` is `2000`.
#'   `as.integer(x)` is the same as `as.integer(as.double(x))`.
#'
#' @param x The `datey` to convert to years.
#' @param ... Further arguments to be passed from or to other methods.
#' @name as_years_datey
NULL

#' @rdname as_years_datey
#' @export
as.double.datey <- function(x, ...) {
  clicks <- convert_datey_to_valid_clicks(x)
  clicks / 534360
}
#' @rdname as_years_datey
#' @export
as.integer.datey <- function(x, ...) {
  clicks <- convert_datey_to_valid_clicks(x)
  # For dates, we know that clicks are positive and hence we can use integer
  # division safely.
  # (This is *not* the case for durations, which can be negative.)
  clicks %/% 534360L
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
#' @name text_from_datey
NULL

#' @rdname text_from_datey
#' @export
format.datey <- function(x, include_day_fraction = TRUE, ...) {
  ensure_is_datey(x)
  ensure_is_switch(include_day_fraction)
  cpp_dateyToRString(x, include_day_fraction)
}

#' @rdname text_from_datey
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
