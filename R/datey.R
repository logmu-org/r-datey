#' The first *valid* calendar year.
#' @export
valid_years_start <- 1000L

#' The first *invalid* calendar year after <see cref="ValidYearsStart"/>.</summary>
#' @export
valid_years_end <- 3000L

clicks_per_year <- 534360L
valid_clicks_start <- valid_years_start * clicks_per_year
valid_clicks_end <- valid_years_end * clicks_per_year

as_integer_or_NA <- function(x) {
  if (is.integer(x)) {
    x
  } else if (is.double(x)) {
    cpp_safeDoubleToInteger(x)
  } else {
    NA_integer_
  }
}
as_double_or_NA <- function(x) {
  if (is.double(x)) {
    x
  } else if (is.integer(x)) {
    as.double(x)
  } else {
    NA_real_
  }
}

#' Is year a leap year?
#'
#' Tests whether a year is a leap year, *and* that it is
#' integral and in \[1000,3000).
#'
#' @export
#' @param year The year to test.
#' @return
#'   `NA` if `year` is non-numeric, non-integral or outside \[1000,3000),
#'   `TRUE` if `year` is a leap year, otherwise
#'   `FALSE`.
#' @examples
#' is_leap_year(2009) # FALSE
#' is_leap_year(2008) # TRUE
#' is_leap_year(1900) # FALSE
#' is_leap_year(2000) # TRUE
is_leap_year <- function(year) {
  year <- as_integer_or_NA(year)
  cpp_isLeapYear(year)
}

#' Check if object is a `datey`
#'
#' Checks whether an object is a `datey`
#'
#' @export
#' @param x The object to test.
is.datey <- function(x) {
  typeof(x) == "integer" && inherits(x, "datey")
}

#' Create a `datey`
#'
#' Creates a `datey` from
#' either (a) a base R date type
#' or (b) a year, month and day,
#' plus, *in both cases*, a mandatory day-fraction.
#'
#' If present, `year`, `month` and `day` must be integral and of the
#' same length.
#'
#' In all cases, calendar years outside the interval \[1000,3000)
#' are treated as invalid.
#'
#' `day_fraction` must be numeric and lie in \[0,1).
#' It must be either the same length as the date arguments or a scalar.
#'
#' @export
#' @param date
#'   Date represented as one of [Date], [POSIXct] or [POSIXlt].
#' @param year
#'   Calendar year.
#'   Valid years are from 1000 (inclusive) to 3000 (exclusive).
#' @param month
#'   Month number in calendar year, with 1 representing January.
#' @param day
#'   Day number in month, with 1 representing the first day of the month.
#' @param day_fraction
#'   The fraction of the day, in \[0,1\].
#'   In particular,
#'   0 means the start of the day,
#'   0.5 means the middle of the day, and
#'   1 means the end of the day.
datey <- function(
  date = NULL,
  year = NULL, month = NULL, day = NULL,
  day_fraction
) {

  day_fraction <- as_double_or_NA(day_fraction)

  if (is.null(date)) {

    stopifnot(is.null(date))

    year <- as_integer_or_NA(year)
    month <- as_integer_or_NA(month)
    day <- as_integer_or_NA(day)

    clicks <- cpp_clicksFromYMDF(year, month, day, day_fraction)

  } else {

    stopifnot(is.null(year), is.null(month), is.null(day))

  }

  structure(clicks, class = "datey")
}

start_day <- function() {
  1
}
mid_day <- function() {
  1
}
end_day <- function() {
  1
}

#' Deconstruct a `datey`
#'
#' Deconstructs a `datey` into a list comprising `year`, `month`, `day` and
#' `day_fraction` components (in that order).
#'
#' If `datey` is valid then the components will lie in the following intervals:
#' - `year` an `integer` in \[1000,3000),
#' - `month` an `integer` in \[1,12],
#' - `day` an `integer` in \[1,N], where N is the number of days
#'   in the month specified by `year` and `month`, and
#' - `day_fraction` a `double` in \[0,1) representing the fraction of the day,
#'   where, for instance, 0 means the start of the day and 0.5 means the middle of the day.
#' @param datey The `datey` to deconstruct.
#' @export
as.ymdf <- function(datey) {
  if (!is.datey(datey)) {
    stop("Argument is not a `datey`.")
  }
  cpp_clicksToYMDF(datey)
}

#' Generic operators for `datey`
#' @param e1 First (`datey`) parameter.
#' @param e2 Second parameter -- must be `datey` or `durationy`.
# @exportS3Method package::generic
Ops.datey <- function(e1, e2) {

  # Legal ops with first parameter a datey:
  #   datey rel_op datey
  #   datey + durationy
  #   datey - durationy

  u1 <- unclass(e1)
  u2 <- unclass(e2)

    #if (!typeof(e1) != "integer") stop()
  if (inherits(e2, "datey")) {
    #if (!typeof(e2) != "integer") stop()
    if (.Generic %in% c("==", "!=", "<", "<=", ">", ">=")) {
      get(.Generic)(u1, u2)
    } else {
      stop(.Generic, " is supported only for comparison with other dateys")
    }
  }
  else if (inherits(e2, "durationy")) {
    #if (!typeof(e2) != "integer") stop()
    if (.Generic %in% c("+", "-")) {
      structure(get(.Generic)(u1, u2), class = "datey")
    } else {
      stop(.Generic, " is supported only for comparison with other dateys")
    }
  } else {
    stop(.Generic, " not supported for units")
  }
}

