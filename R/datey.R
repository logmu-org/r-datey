#' The first *valid* calendar year.
#' @export
valid_years_start <- 1000L

#' The first *invalid* calendar year after <see cref="ValidYearsStart"/>.</summary>
#' @export
valid_years_end <- 3000L

#' Is `x` a leap year?
#'
#' @description
#' Tests whether a date or year is a leap year.
#'
#' For years outside \[1000,3000), this returns `NA`.
#'
#' This is an S3 generic. This package provides methods for:
#'
#' - date types `datey`, `Date`, `POSIXct` and `POSIXlt`, and
#' - numeric types `double` and `integer`.
#'
#' @param x A vector date type or numeric year.
#' @param ... Additional arguments (unused by this package).
#' @export
#' @return
#'   `NA` if `x` is not interpretable as a year or date, or outside \[1000,3000),
#'   `TRUE` if `x` is a leap year, otherwise
#'   `FALSE`.
#' @examples
#' is_leap_year(2009) # FALSE
#' is_leap_year(2008.5) # TRUE
#' is_leap_year(datey(1900, 1, 1, 0)) # FALSE
#' is_leap_year(2000) # TRUE
is_leap_year <- function(x, ...) UseMethod("is_leap_year")

#' @rdname is_leap_year
#' @export
is_leap_year.default <- function(x, ...) NA
#' @rdname is_leap_year
#' @export
is_leap_year.integer <- function(x, ...) cpp_isLeapYear(x)
#' @rdname is_leap_year
#' @export
is_leap_year.double <- function(x, ...) cpp_isLeapYear(as.integer(x))
#' @rdname is_leap_year
#' @export
is_leap_year.datey <- function(x, ...) cpp_isLeapYear(unclass(x) %/% 534360L)
#' @rdname is_leap_year
#' @export
is_leap_year.Date <- function(x, ...) is_leap_year(as_datey(x, 0))
#' @rdname is_leap_year
#' @export
is_leap_year.POSIXct <- function(x, ...) is_leap_year(as_datey(x))
#' @rdname is_leap_year
#' @export
is_leap_year.POSIXct <- function(x, ...) is_leap_year(as_datey(x))

#' Check if object is a `datey`
#'
#' Checks whether an object is a `datey`
#'
#' @export
#' @param x The object to test.
is_datey <- function(x) {
  typeof(x) == "integer" && inherits(x, "datey")
}

#' Create a `datey`
#'
#' Creates a `datey` from
#' a year, month, day and day-fraction.
#'
#' `year`, `month` and `day` must be integral and of the
#' same length.
#'
#' `day_fraction` must be numeric, lie in \[0,1\]
#' and be either the same length as the date arguments or a scalar.
#'
#' Calendar years outside the interval \[1000,3000)
#' are treated as NA.
#'
#' To deconstruct a `datey`, use [as_ymdf].
#'
#' @param year
#'   Calendar year.
#'   Valid years are from 1000 (inclusive) to 3000 (exclusive).
#' @param month
#'   Month number in calendar year, with 1 representing January.
#' @param day
#'   Day number in month, with 1 representing the first day of the month.
#' @param day_fraction
#'   The fraction of the day, in \[0,1\].
#'   0 means the start of the day,
#'   0.5 means the middle of the day, and
#'   1 means the end of the day
#'   (which is identical to the start of the next day).
#' @export
datey <- function(year, month, day, day_fraction) {

  year <- as_integer_for_cpp(year)
  month <- as_integer_for_cpp(month)
  day <- as_integer_for_cpp(day)
  day_fraction <- as_double_for_cpp(day_fraction)

  datey <- cpp_dateyFromYMDF(year, month, day, day_fraction)

  structure(datey, class = "datey")
}

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
  if (!is_datey(datey)) stop("Argument is not a `datey`.")
  cpp_dateyToYMDF(datey)
}

#' Convert an object to a `datey`
#'
#' @description
#' This is an S3 generic. This package provides methods for the
#' following classes:
#'
#' - `double` and `integer`:
#'   Values are interpreted as year, e.g. 2000.0. is the *start of*
#'   the year 2000.
#' - `Date`: Note that .
#' - `POSIXct`: Note that .
#' - `POSIXlt`: Note that .
#'
#' @param x A vector.
#' @param day_fraction
#'   The fraction of the day, in \[0,1\].
#'   0 means the start of the day,
#'   0.5 means the middle of the day, and
#'   1 means the end of the day
#'   (which is identical to the start of the next day).
#' @param ... Other arguments.
#' @export
as_datey <- function(x, ...) UseMethod("as_datey")
#' @rdname as_datey
#' @export
as_datey.default <- function(x, ...) NA
#' @rdname as_datey
#' @export
as_datey.integer <- function(x, ...) {
  valid_year <- ifelse(x >= 1000L & x < 3000L, x * 534360L, NA_integer_)
  structure(valid_year, class = "datey")
}
#' @rdname as_datey
#' @export
as_datey.double <- function(x, ...) {
  valid_year <- ifelse(x >= 1000 & x < 3000, round(x * 534360), NA_real_)
  structure(as.integer(valid_year), class = "datey")
}
#' @rdname as_datey
#' @export
as_datey.character <- function(x, day_fraction = NULL, ...) {
  if (is.null(day_fraction)) {
    clicks <- cpp_dateyFromRStringOnly(x)
  }
  else {
    day_fraction <- as_double_for_cpp(day_fraction)
    clicks <- cpp_dateyFromRStringAndDayFraction(x, day_fraction)
  }
  structure(clicks, class = "datey")
}
#' @rdname as_datey
#' @export
as_datey.Date <- function(x, day_fraction, ...) {
  rDate <- as_double_for_cpp(unclass(x))
  day_fraction <- as_double_for_cpp(day_fraction)
  clicks <- cpp_dateyFromRDate(rDate, day_fraction)
  structure(clicks, class = "datey")
}
#' @rdname as_datey
#' @export
as_datey.POSIXct <- function(x, ...) as_datey(as.POSIXlt(x))
#' @rdname as_datey
#' @export
as_datey.POSIXlt <- function(x, ...) {
  # From POSIXlt docs:
  # `sec` in 0–61: seconds, allowing for leap seconds.
  # `min` in 0–59: minutes.
  # `hour` in 0–23: hours.
  # `year`: years since 1900.
  # `yday` in 0–365: day of the year (365 only in leap years).

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

  structure(clicks, class = "datey")
}

#' @rdname datey
#' @export
as_start_day <- function(x, ...) UseMethod("as_start_day")
#' @rdname datey
#' @export
as_mid_day <- function(x, ...) UseMethod("as_mid_day")
#' @rdname datey
#' @export
as_end_day <- function(x, ...) UseMethod("as_end_day")

#' Test whether a `datey` is the start or middle of a day
#'
#' @description
#' `is_start_day()` tests whether the `datey` is the start (or end) of
#'  a day, i.e. the boundary between two days.
#'
#' `is_mid_day()` tests whether the `datey` is (exactly) the middle of
#'  a day.
#'
#' @param datey The (vector of ) `datey` to test.
#' @export
is_start_day <- function(datey) {
  clicks <- convert_datey_to_valid_clicks(datey)
  year <- clicks %/% 534360L
  is_leap <- is_leap_year.integer(year)
  day_clicks <- clicks - year * 534360L

  ### YOU ARE HERE

  is_leap_year.datey
}
#' @rdname is_start_day
#' @export
is_mid_day <- function(datey) {
  TRUE
}

#' @rdname as_datey
#' @export
format.datey <- function(x, ...) cpp_dateyToRString(x)

#' @rdname as_datey
#' @export
print.datey <- function(x, max = NULL, ...) {
  if (is.null(max)) max <- getOption("max.print", 9999L)

  if(max < length(x)) {
    print(format(x[seq_len(max)]), max=max+1, ...)
    cat(" [ reached 'max' / getOption(\"max.print\") -- omitted",
        length(x) - max, 'entries ]\n')
  } else if(length(x)) {
    print(format(x), max = max, ...)
  }
  else {
    cat(class(x)[1L], "of length 0\n")
  }

  invisible(x)
}
