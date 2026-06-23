# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

datey_from_clicks <- function(clicks) {
  clicks <- unclass(clicks)
  if (!is.integer(clicks)) clicks <- as.integer(round(clicks))
  structure(clicks, class = c("datey", "datey_type"))
}

datey_from_ymdf <- function(year, month, day, day_fraction, strict) {

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


#' The `datey`, `durationy` and `datey_interval` versions of NA
#'
#' @description
#'
#' Throughout the **datey** package, `NA` will cause an error when used where
#' a `datey_`, `durationy_` or `datey_interval_` is expected.
#' This is because its type is `logical` and potentially indicates user
#' error. If you want an NA value with a **datey** system type, use one of `NA_datey_`, `NA_durationy_`
#' or `NA_datey_interval_`.
#' @seealso [is_NA], [integer_constants], [datey], [durationy], [datey_interval]
#' @examples
#'   is_datey(NA_datey_)
#'   is.na(NA_datey_)
#'   is_durationy(NA_durationy_)
#'   is.na(NA_durationy_)
#'   is_datey_interval(NA_datey_interval_)
#' @name NAs
NULL

#' @rdname NAs
#' @export
NA_datey_ <- datey_from_clicks(NA_integer_)

#' Whether `datey`, `durationy` or
#' `datey_interval` are NA
#'
#' @description
#'
#' Valid datey system ranges:
#' - Valid dates are from the start of 1000 to the start of 3000.
#' - Valid durations are 2000 years or less in magnitude.
#'
#' Values outside the above ranges are treated as NA.
#'
#' `is.na()` tests whether a `datey`, `durationy` or
#' `datey_interval` is NA by element.
#'
#' `anyNA()` tests whether any element of a `datey`, `durationy` or
#' `datey_interval` is NA.
#'
#' For convenience,
#'
#' - the constants [NA_datey_], [NA_durationy_] and [NA_datey_interval_]
#' are the `datey`, `durationy` and `datey_interval`
#' versions of NA respectively, and
#' - [integer constants][integer_constants] describing the above valid ranges
#' are also provided.
#'
#' For performance reasons, intermediate **datey** system
#' calculations are *not* required to check for NAs.
#'
#' Throughout the **datey** package, `NA` will cause an error when used where
#' a `datey_`, `durationy_` or `datey_interval_` is expected.
#' This is because its type is `logical` and potentially indicates user
#' error. If you want an NA value with a **datey** system type, use one of `NA_datey_`, `NA_durationy_`
#' or `NA_datey_interval_`.
#'
#' @param x The `datey`, `durationy` or `datey_interval` to test for NA.
#' @param recursive	Currently required to be `FALSE` (the default).
#' @returns
#' `is.na()` returns a vector of logical the same length as `x`.
#' `anyNA()` always returns `TRUE` or `FALSE`, never `NA` and
#' never anything other than a single value.
#' @keywords NA
#' @seealso [NA_datey_], [NA_durationy_], [NA_datey_interval_], [integer_constants],
#'   [datey], [durationy], [datey_interval]
#' @examples
#'   t <- c(NA_datey_, datey(2000), datey(999.99, strict = FALSE))
#'   is.na(t)
#'   anyNA(t)
#'
#'   d <- c(NA_durationy_, durationy(1.5))
#'   is.na(d)
#'   anyNA(d)
#'
#'   i <- c(NA_datey_interval_, 2000 %to% 2001)
#'   is.na(i)
#'   anyNA(i)
#' @name is_NA
NULL

#' @rdname is_NA
#' @export
is.na.datey <- function(x) {
  #clicks <- unclass(x)
  #is.na(clicks) | clicks < 534360000L | clicks > 1603080000L
  cpp_dateyIsNA(x)
}
#' @rdname is_NA
#' @export
anyNA.datey <- function(x, recursive = FALSE) {
  if (!isFALSE(recursive)) stop("The recursive argument must be FALSE.", call. = FALSE)
  #any(is.na(x))
  cpp_dateyAnyNA(x)
}

#' Is `x` a `datey`, `durationy` or `datey_interval`?
#'
#' @description
#'
#' These methods will always return a scalar logical `TRUE` or `FALSE`:
#'
#' - `is_datey()` tests whether an object is a `datey`.
#' - `is_durationy()` tests whether an object is a `durationy`.
#' - `is_datey_interval()` tests whether an object is a `datey_interval`.
#'
#' @param x The object to test.
#' @returns
#'   A logical scalar indicating whether `x` a `datey`, `durationy` or
#'   `datey_interval` as appropriate.
#'   Always `FALSE` or `TRUE`; never `NULL` or `NA`.
#' @examples
#' t <- datey(2000:2001)
#' t
#' is_datey(t)
#' is_datey(NULL)
#' is_datey(NA)
#'
#' d <- durationy(0:2)
#' d
#' is_durationy(d)
#' is_durationy(NULL)
#' is_durationy(NA)
#'
#' interval <- datey(2000:2001) %to% datey(2001:2002)
#' interval
#' is_datey_interval(interval)
#' is_datey_interval(NULL)
#' is_datey_interval(NA)
#' @name is_type
NULL

#' @rdname is_type
#' @export
is_datey <- function(x) typeof(x) == "integer" && isa(x, c("datey", "datey_type"))


#' Get year, month, day or day_fraction breakdown of a `datey`
#'
#' @description
#' To extract the year, month, day or day_fraction breakdown of a `datey`,
#' use either
#'
#' - the list-like syntax `$year`, `$month`, `$day` or `$day_fraction`
#' direct, or
#' - if you need several components at once, `to_ymdf()`, which
#' returns an actual list of `year`, `month`, `day` and `day_fraction`.
#'
#' In this breakdown,
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
#' @param x The `datey` to be deconstructed.
#' @param name The name of the component for the list-like syntax.
#' Must be `year`, `month`, `day` or `day_fraction`.
#' @returns
#' `to_ymdf()` returns a list of
#'   integer vector `year`,
#'   integer vector `month`,
#'   integer vector `day`, and
#'   double vector `day_fraction`, all with the same length.
#' The list-like syntax returns these components individually.
#' @examples
#'   t <- datey(2001, 2, 3, 0.5)
#'   t
#'   to_ymdf(t)
#'   t$year
#'   t$month
#'   t$day
#'   t$day_fraction
#' @seealso [datey], [text_from_datey]
#' @name datey_components
NULL

#' @rdname datey_components
#' @export
to_ymdf <- function(x) {
  ensure_is_datey(x)
  cpp_dateyToYMDF(x)
}

#' @rdname datey_components
#' @export
`$.datey` <- function(x, name) {
  #ensure_is_datey(x)
  if (length(name) == 1L && !is.na(name) && is.character(name)) {
    if (name == "year") return(cpp_dateyToY(x))
    if (name == "month") return(cpp_dateyToM(x))
    if (name == "day") return(cpp_dateyToD(x))
    if (name == "day_fraction") return(cpp_dateyToF(x))
    stop("A `datey` does not have a property called `", name, "`. Must be `year`, `month`, `day` or `day_fraction`.", call. = FALSE)
  }

  stop("Invalid `datey` property. Must be `year`, `month`, `day` or `day_fraction`.", call. = FALSE)
}

#' Create a `datey`
#'
#' @description
#'
#' To create a `datey` use one of the following:
#'
#' - `start_day()` and `end_day()` are the points in time at the *start* and
#' *end* of the day respectively.
#' - `mid_day()` is the the *middle* of the day, commonly used to represent a
#' point in time *during* the day.
#' - `datey()` is the underlying S3 generic function.
#' `start_day()`, `mid_day()` and `end_day()` call through to `datey`
#' with an explicit `day_fraction` or `0`, `0.5` and `1` respectively.
#'
#' The generic types are as follows:
#'
#' - `double` and `integer`. These are interpreted as calendar year, optionally
#'     with a fractional part in the case of `double`.
#'
#'     Valid years are from 1000 to 3000 (although the only legal date in 3000
#'     is the start of 3000-01-01).
#'
#'     Either
#'
#'     (a)&#xA0;`month` and `day` (and for `datey()`, `day_fraction`) parameters
#'     are all provided, in which case `x` must be integral, or
#'
#'     (b)&#xA0;none of those parameters are provided,
#'     in which case
#'     `x` is interpreted as a fractional calendar year and
#'     rounded to the nearest 1 / \ifelse{html}{\out{534&#x202F;360}}{534360} of a
#'     year (Banker's rounding). This unit is called a *click* and is the
#'     resolution of all **datey** arithmetic.
#'     For instance, `datey(2000.5)` means halfway through the year 2000.
#'
#' - `Date`. This base R date type is interpreted strictly.
#'     (It is possible to end up with an unintentionally fractional
#'     underlying value, e.g. by taking a mean of `Date`s.)
#'     A `day_fraction` argument is always required.
#'
#' - `POSIXct` and `POSIXlt`. How these base R date-time types are interpreted
#' depends on whether a `day_fraction` is provided.
#'
#'     If `day_fraction` *is* provided then these are interpreted strictly
#'     using the date component only -- the time component is ignored completely.
#'
#'     If `day_fraction` is *not* provided then the day fraction is
#'     determined using the hours, minutes, and seconds. For instance,
#'     `datey(as.POSIXct("2000-03-21 12:00"))` means the *middle* of 2000-03-21.
#'
#' - `character`. How text is parsed depends on whether a `day_fraction` is provided.
#'
#'     If `day_fraction` *is* provided then the text must be in ISO 8601 extended
#'     format, i.e. `YYYY-MM-DD`.
#'
#'     If `day_fraction` is *not* provided then the text must be formatted as
#'     `YYYY-MM-DD[.F..].`, where `[.F...]` is the optional day fraction. This means
#'     that e.g. `"2000-01-01"` represents the *start* of 1 January 2000.
#'
#'     If `blank_is_NA` is `TRUE` then blanks are treated as `NA` (regardless of `strict`).
#'
#' - `datey`. This is interpreted as is but with the optional `day_fraction` override.
#' Note that a `day_fraction` of 1 will add a day to a day boundary,
#' *even if it was originally defined as an end day*.
#'
#' The lengths of vector arguments must be multiples of each other.
#'
#' Beware that `end_day()` will add a day to a `datey` that is already on a
#' day boundary, *even if it was originally defined as an end day*.
#'
#' There is no `is_end_day()` predicate: end days are stored identically to
#' the start of the following day, so `is_start_day()` is the correct test.
#'
#' NA arguments *of the appropriate type* result in `NA_datey_`
#' -- they do not stop execution (regardless of `strict`).
#' Note that `NA` is `logical` and therefore it *will* cause an error.
#'
#' @param x The argument to convert to a `datey`.
#' @param month,day
#' The month (1--12) and day (1--31).
#' Valid only for for numeric `x`.
#' If one of `month` or `day` is provided then both must be and,
#' for `datey()`, `day_fraction` must also be provided.
#' @param day_fraction
#' The `day_fraction` override. Defaults to `NULL` except for the `Date` type,
#' in which case it must always be provided.
#'
#' If `day_fraction` *is* provided (which is implicitly the case for
#' `start_day()`, `mid_day()` and `end_day()`)
#' then `x` is used solely to derive the
#' calendar year, month and day, while `day_fraction` provides the position in
#' the day. `day_fraction` must lie in the inclusive interval \[0,1\], with
#' 0 meaning the start of the day,
#' 0.5 meaning the middle of the day, and
#' 1 meaning the end of the day (which is identical to the start of the next
#' day). For text this means that there should be *no* trailing fraction, e.g.
#' `start_day("2020-01-01")`.
#'
#' If `day_fraction` is *not* provided then `x` is used to derive both
#' the calendar year, month, day *and* the day fraction.
#'
#' @param strict
#' How non-compliant *non-NA* inputs should be handled.
#' If `strict` is `TRUE` -- the default -- then execution is stopped.
#' If `strict` is `FALSE` then `NA` is returned.
#' @param blank_is_NA
#' Whether "" should be treated as `NA` (regardless of `strict`).
#' When `x` is `""` then
#' if `blank_is_NA` is `TRUE` then `""` results in `NA`, otherwise
#' execution is stopped. Defaults to `FALSE`.
#' Valid only for for character `x`.
#' @param ... Not used.
#' @returns A vector of `datey`.
#' @examples
#' start_day(2001, 2, 3)
#' mid_day(2001, 2, 3)
#' end_day(2001, 2, 3)
#'
#' # Must specify month and day for a numeric if day_fraction is provided
#' # implicitly or explicitly:
#' try(start_day(2001))
#' try(mid_day(2001))
#' try(end_day(2001))
#' try(datey(2001, day_fraction = 0))
#'
#' datey(2000) # Start of a year
#' datey(2000.5) # Middle of a leap year
#' datey(2001.5) # Middle of a non-leap year
#'
#' # Convert base R date
#' r_date <- as.Date("2001-02-03")
#' c(start_day(r_date), mid_day(r_date), end_day(r_date))
#' try(datey(r_date)) # Must specify day_fraction for a `Date`
#'
#' # Convert base R datetime
#' c_date <- as.POSIXct("2001-02-03 12:00:00") # Midday!
#' c(start_day(c_date), mid_day(c_date), end_day(c_date))
#' # An R datetime implies a position within a day:
#' datey(c_date) # 2001-02-03.5
#'
#' # Use `strict` to control error behaviour for invalid years:
#' try(end_day(0999, 12, 31))
#' try(datey(3000.1))
#' end_day(0999, 12, 31, strict = FALSE)
#' datey(3000.1, strict = FALSE)
#'
#' # NAs are passed through regardless of `strict`
#' # (provided they are numeric)
#' end_day(NA_real_, 12, 31, strict = TRUE)
#' datey(NA_real_, strict = FALSE)
#'
#' # Text:
#' start_day("2001-02-03")
#' mid_day("2001-02-03")
#' end_day("2001-02-03")
#' datey("2001-02-03")
#' datey("2001-02-03.0")
#' datey("2001-02-03", day_fraction = 0)
#' datey("2001-02-03.5")
#' datey("2001-02-03", day_fraction = 0.5)
#'
#' # Text round trips:
#' t <- datey(2001.234)
#' identical(t, datey(as.character(t))) # TRUE
#'
#' # Day fraction cannot be present
#' # both in the text and as an argument
#' # implicitly or explicitly:
#' try(start_day("2001-02-03.0"))
#' try(datey("2001-02-03.0", day_fraction = 0))
#'
#' # Handling blanks:
#' try(start_day(""))
#' start_day("", blank_is_NA = TRUE)
#'
#' # Invalids:
#' try(mid_day("abc"))
#' try(mid_day("0999-01-01"))
#' end_day("abc", strict = FALSE) # NA
#' end_day("0999-01-01", strict = FALSE) # NA
#' @seealso [durationy], [datey_interval], [text_from_datey], [as_years_datey],
#'   [datey_components], [is_xxx_day], [is_leap_year], [is_NA], [ops],
#'   `vignette("why-datey", package = "datey")` for the annual-grid design,
#'   `vignette("datey", package = "datey")` for a worked introduction
#' @name datey
NULL

validate_datey_from_numeric <- function(month = NULL, day = NULL, day_fraction = NULL, strict = TRUE, ...) {
  ensure_is_switch(strict)

  any <- !is.null(month) || !is.null(day) || !is.null(day_fraction)
  all <- !is.null(month) && !is.null(day) && !is.null(day_fraction)
  if (any != all) {
    stop("For a numeric, either all or none of `month`, `day` and `day_fraction` must be specified.", call. = FALSE)
  }
}

#' @rdname datey
#' @export
datey <- function(x, ...) UseMethod("datey")
#' @rdname datey
#' @export
datey.default <- function(x, ...) {
  arg_name <- deparse(substitute(x))
  stop("S3 function `datey` is not implemented for `", arg_name, "`.", call. = FALSE)
}
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
datey.integer <- function(x, month = NULL, day = NULL, day_fraction = NULL, strict = TRUE, ...) {
  validate_datey_from_numeric(month, day, day_fraction, strict, ...)

  if (!is.null(day_fraction)) return(datey_from_ymdf(x, month, day, day_fraction, strict))

  in_range <- x >= 1000L & x <= 3000L
  if (strict && !all(in_range, na.rm = TRUE)) stop("Year must be in [1000, 3000].", call. = FALSE)
  x <- pmax(1000L, pmin(3000L, x))
  clicks <- ifelse(in_range, x * 534360L, NA_integer_)
  datey_from_clicks(clicks)
}
#' @rdname datey
#' @export
datey.double <- function(x, month = NULL, day = NULL, day_fraction = NULL, strict = TRUE, ...) {
  validate_datey_from_numeric(month, day, day_fraction, strict, ...)

  if (!is.null(day_fraction)) return(datey_from_ymdf(x, month, day, day_fraction, strict))

  in_range <- x >= 1000 & x <= 3000
  if (strict && !all(in_range, na.rm = TRUE)) stop("Year must be in [1000, 3000].", call. = FALSE)
  #x <- pmax(1000, pmin(3000, x))
  clicks <- ifelse(in_range, x * 534360L, NA_real_)
  datey_from_clicks(clicks)
}
#' @rdname datey
#' @export
datey.Date <- function(x, day_fraction, strict = TRUE, ...) {
  ensure_is_switch(strict)
  if (missing(day_fraction)) {
    stop("`day_fraction` must be provided for the `Date` type.", call. = FALSE)
  }
  x <- as_double_for_cpp(unclass(x))
  #if (is.null(day_fraction)) clicks <- cpp_dateyFromRDate(x, strict)
  #else {
  day_fraction <- as_double_for_cpp(day_fraction)
  clicks <- cpp_dateyFromRDateAndFraction(x, day_fraction, strict)
  #}
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
  # `sec` in 0-61: seconds, allowing for leap seconds.
  # `min` in 0-59: minutes.
  # `hour` in 0-23: hours.
  # `year`: years since 1900.
  # `yday` in 0-365: day of the year (365 only in leap years).

  ensure_is_switch(strict)

  year <- as.integer(x$year) + 1900L

  seconds <- (((x$yday * 24 + x$hour) * 60 + x$min) * 60 + x$sec)
  # (366 or 365) * 24 * 60 * 60
  seconds_in_year <- ifelse(is_leap_year(year), 31622400, 31536000)
  year_fraction <- seconds / seconds_in_year
  # Ignore leap seconds added on 30 June
  # But leap seconds on 31 December would take the fraction over 1
  year_fraction <- pmin(1, year_fraction)

  in_range <- year >= 1000L & (year < 3000L | (year == 3000L & seconds == 0))
  if (strict && !all(in_range, na.rm = TRUE)) stop("Invalid POSIX date.", call. = FALSE)

  # We round here for better accuracy but this means we miss 3000 + eps
  year <- pmax(1000L, pmin(3000L, year))
  clicks <- year * 534360L + as.integer(round(year_fraction * 534360))
  clicks <- ifelse(in_range, clicks, NA_integer_)

  x <- datey_from_clicks(clicks)
  datey.datey(x, day_fraction, strict)
}
#' @rdname datey
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

#' @rdname datey
#' @export
start_day <- function(x, month = NULL, day = NULL, strict = TRUE, blank_is_NA = FALSE)
  xxx_day(x, month, day, day_fraction = 0, strict = strict, blank_is_NA = blank_is_NA)
#' @rdname datey
#' @export
mid_day <- function(x, month = NULL, day = NULL, strict = TRUE, blank_is_NA = FALSE)
  xxx_day(x, month, day, day_fraction = 0.5, strict = strict, blank_is_NA = blank_is_NA)
#' @rdname datey
#' @export
end_day <- function(x, month = NULL, day = NULL, strict = TRUE, blank_is_NA = FALSE)
  xxx_day(x, month, day, day_fraction = 1, strict = strict, blank_is_NA = blank_is_NA)

xxx_day <- function(x, month, day, day_fraction, strict, blank_is_NA) {
  if (is_pure_numeric(x)) {
    datey(x, month, day, day_fraction = day_fraction, strict = strict)
  }
  else {
    if (!is.null(month) || !is.null(day)) {
      stop("`month` or `day` arguments are only for a numeric first argument.", call. = FALSE)
    }
    if (is_pure_character(x)) {
      datey(x, day_fraction = day_fraction, strict = strict, blank_is_NA = blank_is_NA)
    } else {
      datey(x, day_fraction = day_fraction, strict = strict)
    }
  }
}

#' Is a `datey` the start (or end) or middle of a day?
#'
#' @description
#' `is_start_day()` checks whether `x` is the start or end of a day.
#'
#' `is_mid_day()` checks whether `x` is the middle of a day.
#'
#' These properties are *not* necessarily preserved when a duration of
#' *n*&#xA0;years is added or subtracted.
#'
#' @param x The `datey` to test.
#' @returns A vector of `logical`. Elements of the `datey` vector that are
#' `NA_datey_` will result in `NA` elements of the result vector.
#' @examples
#' # Create (NA, 0 days, 1/4 day, 1/2 day):
#' t <- datey(c(NA_real_, 2000, 2000 + 0.25/366, 2000 + 0.5/366))
#' t # <NA>  2000-01-01.0  2000-01-01.25 2000-01-01.5
#'
#' is_start_day(t) # NA  TRUE FALSE FALSE
#' is_mid_day(t)   # NA FALSE FALSE  TRUE
#'
#' # Properties are not necessarily preserved between years:
#' t <- start_day(2000,7,1) # Leap year
#' is_start_day(t) # TRUE
#' is_start_day(t + durationy(1)) # FALSE
#' @seealso [datey]
#' @name is_xxx_day
NULL

#' @rdname is_xxx_day
#' @export
is_start_day <- function(x) {
  ensure_is_datey(x)
  clicks <- convert_datey_to_valid_clicks(x)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == 0L
}
#' @rdname is_xxx_day
#' @export
is_mid_day <- function(x) {
  ensure_is_datey(x)
  clicks <- convert_datey_to_valid_clicks(x)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == clicks_per_day %/% 2L
}

#' Convert a `datey` to calendar years (including fractional part)
#'
#' @description
#' Converts a `datey` to calendar years,
#' including a fractional part that represents the
#' proportion of the calendar year that has elapsed.
#'
#' For example, the middle of 2000-10-01 is precisely three-quarters through
#' the (leap) year 2000 and so `as.double(mid_day(2000,10,1))` results in
#' `2000.75`.
#'
#' `as.numeric()` is the same as `as.double()`.
#'
#' `as.integer()` gives the calendar year as an `integer`, e.g.
#' `as.integer(datey(2000.75))` is `2000`.
#' It is also the case that if `x` is a `datey` then
#' `as.integer(x)` is the same as `as.integer(as.double(x))`.
#'
#' @param x The `datey` to convert to years.
#' @param ... Not used.
#' @returns A vector of `double`.
#' @examples
#' t <- datey(2000.75)
#' t                   # 2000-10-01.5
#' as.double(t)        # 2000.75
#' as.numeric(t)       # 2000.75
#' as.integer(t)       # 2000
#' identical(as.integer(t), 2000L) # TRUE
#' @seealso [datey], [as_years_durationy], [ops]
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
#' - `YYYY-MM-DD.F...` where `.F...` is the day fraction part.
#'
#' If `include_day_fraction` is `TRUE` then `[.F...]` is included even if it
#' is 0 (i.e. `.0`).
#'
#' Note that a `datey` created as the end of a day (or with day fraction 1) will
#' print as the start of the following day.
#' @param x The `datey` to print or format.
#' @param include_day_fraction Whether to include the fractional day part.
#' Defaults to `TRUE`.
#' @param  max Numeric or `NULL`, specifying the maximal number of entries to be
#' printed. When `NULL`, `getOption("max.print")` used. Defaults to `NULL`.
#' @param ... Other arguments.
#' @returns `as.character` and `format` return a vector of `character`.
#' `print` invisibly returns `x`.
#' @examples
#' start      <- start_day(2001, 2, 3)
#' fractional <- datey(    2001, 2, 3, day_fraction = 0.4444)
#' mid        <- mid_day(  2001, 2, 3)
#' end        <- end_day(  2001, 2, 3)
#'
#' format(start)                               # "2001-02-03.0"
#' format(start, include_day_fraction = FALSE) # "2001-02-03"
#' format(fractional)                          # "2001-02-03.4447"
#' format(mid)                                 # "2001-02-03.5"
#' format(end)                                 # "2001-02-04.0"
#' @seealso [datey]
#' @name text_from_datey
NULL

#' @rdname text_from_datey
#' @export
as.character.datey <- function(x, ...) format.datey(x)

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
    print(noquote(format(x[seq_len(max)], include_day_fraction)), max = max + 1, ...)
    cat(" [ reached 'max' / getOption(\"max.print\") -- omitted",
        length(x) - max, 'entries ]\n')
  } else if (length(x)) {
    print(noquote(format(x, include_day_fraction)), max = max, ...)
  }
  else {
    cat(class(x)[1L], "of length 0\n")
  }

  invisible(x)
}
