#' The first *valid* calendar year.
#' @export
valid_years_start <- 1000L

#' The first *invalid* calendar year after [valid_years_start].
#' @export
valid_years_end <- 3000L

#' Check if object is a `datey`
#'
#' Checks whether an object is a `datey`.
#'
#' @param x The object to test.
#' @export
is_datey <- function(x) {
  typeof(x) == "integer" && inherits(x, "datey")
}

#' Create a `datey`
#'
#' @description
#' Create a `datey` from
#' a year, month, day and, optionally, a day-fraction.
#'
#' In general, prefer the explicit [start_day()], [mid_day()] and [end_day()]
#' versions.
#'
#' To deconstruct a `datey`, use [as_ymdf()].
#'
#' @param year
#'   Calendar year.
#'   Valid years are from 1000 (inclusive) to 3000 (exclusive).
#'   Doubles are truncated to integers.
#' @param month
#'   Month number in calendar year, with 1 representing January.
#'   Doubles are truncated to integers.
#' @param day
#'   Day number in month, with 1 representing the first day of the month.
#'   Doubles are truncated to integers.
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

#' @rdname datey
#' @export
start_day <- function(year, month, day) datey(year, month, day, day_fraction = 0)
#' @rdname datey
#' @export
mid_day <- function(year, month, day) datey(year, month, day, day_fraction = 0.5)
#' @rdname datey
#' @export
end_day <- function(year, month, day) datey(year, month, day, day_fraction = 1)

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
#' @param ... Other arguments (not used in this package).
#' @export
as_datey <- function(x, day_fraction = NULL, ...) UseMethod("as_datey")
#' @rdname as_datey
#' @export
as_datey.default <- function(x, day_fraction = NULL, ...) NA
#' @rdname as_datey
#' @export
as_datey.datey <- function(x, day_fraction = NULL, ...) {
  ensure_is_datey(datey)
  if (!is.null(day_fraction)) {
    day_fraction <- as_double_for_cpp(day_fraction)
    x <- cpp_dateyWithNewDayFraction(datey, day_fraction, ...)
  }
  x
}
#' @rdname as_datey
#' @export
as_datey.integer <- function(x, day_fraction = NULL, ...) {
  clicks <- ifelse(x >= 1000L & x < 3000L, x * 534360L, NA_integer_)
  datey <- structure(clicks, class = "datey")
  if (!is.null(day_fraction)) datey <- as_datey.datey(datey, day_fraction, ...)
  datey
}
#' @rdname as_datey
#' @export
as_datey.double <- function(x, day_fraction = NULL, ...) {
  clicks <- ifelse(x >= 1000 & x < 3000, round(x * 534360), NA_real_)
  datey <- structure(as.integer(clicks), class = "datey")
  if (!is.null(day_fraction)) datey <- as_datey.datey(datey, day_fraction, ...)
  datey
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
as_datey.Date <- function(x, day_fraction = NULL, ...) {
  x <- as_double_for_cpp(unclass(x))
  if (is.null(day_fraction)) clicks <- cpp_dateyFromRDate(x)
  else {
    day_fraction <- as_double_for_cpp(day_fraction)
    clicks <- cpp_dateyFromRDateAndFraction(x, day_fraction)
  }
  datey <- structure(as.integer(clicks), class = "datey")
}
#' @rdname as_datey
#' @export
as_datey.POSIXct <- function(x, day_fraction = NULL, ...)
  as_datey.POSIXlt(as.POSIXlt(x, day_fraction, ...))
#' @rdname as_datey
#' @export
as_datey.POSIXlt <- function(x, day_fraction = NULL, ...) {
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

  datey <- structure(as.integer(clicks), class = "datey")
  if (!is.null(day_fraction)) datey <- as_datey.datey(datey, day_fraction, ...)
  datey
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
  clicks <- convert_datey_to_valid_clicks(datey)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year.integer(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == 0L
}
#' @rdname is_start_day
#' @export
is_mid_day <- function(datey) {
  clicks <- convert_datey_to_valid_clicks(datey)
  year <- clicks %/% 534360L
  clicks_per_day <- ifelse(is_leap_year.integer(year), 1460L, 1464L)
  day_fraction_clicks <- clicks %% clicks_per_day
  day_fraction_clicks == clicks_per_day / 2L
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
  if (length(include_day_fraction) != 1 ||
    is.na(include_day_fraction) ||
    !is.logical(include_day_fraction)
  ) {
    arg_name <- deparse(substitute(include_day_fraction))
    stop(paste0("include_day_fraction '", arg_name, "' must be numeric."))
  }

  cpp_dateyToRString(x, include_day_fraction)
}

#' @rdname format.datey
#' @export
print.datey <- function(x, include_day_fraction = TRUE, max = NULL, ...) {
  ensure_is_datey(x)
  if (is.null(max)) max <- getOption("max.print", 9999L)

  if (max < length(x)) {
    print(format(x[seq_len(max)], include_day_fraction), max=max+1, ...)
    cat(" [ reached 'max' / getOption(\"max.print\") -- omitted",
        length(x) - max, 'entries ]\n')
  } else if(length(x)) {
    print(format(x, include_day_fraction), max = max, ...)
  }
  else {
    cat(class(x)[1L], "of length 0\n")
  }

  invisible(x)
}
