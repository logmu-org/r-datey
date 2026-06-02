# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# TODO:
# intersection
# seq_datey_interval

datey_interval_from_punned_double <- function(punned_double) {
  structure(punned_double, class = c("datey_interval", "datey_type"))
}

# `@name is_type` is defined in datey.R
#' @param x The object to test.
#' @name is_type
#' @export
is_datey_interval <- function(x) typeof(x) == "double" && isa(x, c("datey_interval", "datey_type"))

#' Create a `datey_interval`
#'
#' @description
#' Create a `datey_interval` representing [`start`, `end`).
#'
#' These are closed-open ('clopen') intervals `start` <= t < `end`, i.e. the
#' interval includes `start` but excludes `end`.
#'
#' There are two equivalent syntaxes,
#' - operator: `start %to% end`, and
#' - function: `datey_interval(start, end)`.
#'
#' @param start,end The start (inclusive) and end of the interval (exclusive).
#' These can be any type that is convertible to a `datey`. These have the same
#' numbers of elements or their lengths must be multiples of each other.
#' @param strict
#' How NAs should be handled.
#' - If `strict` is `TRUE` -- the default -- then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned if `start` and/or `end` is NA.
#' @examples
#'   datey(1999) %to% mid_day(2025, 7, 15)
#'   datey(1999) %to% datey(2000:2002)
#' @export
datey_interval <- function(start, end, strict = TRUE) {
  start <- datey(start, strict = strict)
  end <- datey(end, strict = strict)
  punned_double <- cpp_dateyInterval(start, end, strict)
  datey_interval_from_punned_double(punned_double)
}

#' @rdname datey_interval
#' @export
`%to%` <- function(start, end) datey_interval(start, end)


#' Extract start or end from a `datey_interval`
#'
#' @description
#' Extract the start or end of a `datey_interval` using the syntax
#' `$start` or `$end` respectively.
#'
#' @param x The `datey_interval`.
#' @param name
#' Must be `start` or `end`.
#' @examples
#'   t_1 <- start_day(2001, 1, 1)
#'   t_2 <- start_day(2002, 2, 2)
#'   interval <- datey_interval(t_1, t_2)
#'   interval$start
#'   interval$end
#' @name interval_properties
#' @export
`$.datey_interval` <- function(x, name) {
  #ensure_is_datey_interval(x)
  if (length(name) == 1L && !is.na(name) && is.character(name)) {
    if (name == "start") return(datey_from_clicks(cpp_dateyIntervalStart(x)))
    if (name == "end") return(datey_from_clicks(cpp_dateyIntervalEnd(x)))
    stop("A `datey_interval` does not have a property called `", name, "`. Must be `start` or `end`.", call. = FALSE)
  }

  stop("Invalid `datey_interval` property. Must be `start` or `end`.", call. = FALSE)
}

# `@name NAs` is defined in datey.R
#' @rdname NAs
#' @export
# Ideally we'd use this:
#NA_datey_interval_ <- datey_interval(NA_datey_, NA_datey_, strict = FALSE)
# but the C++ function it references does not exist when this is assigned.
# So we are forced to rely on NA_real_, which means we've hard-coded the
# representation.
NA_datey_interval_ <- datey_interval_from_punned_double(NA_real_)

# `@name is_NA` is defined in datey.R
#' @rdname is_NA
#' @export
is.na.datey_interval <- function(x) {
  cpp_dateyIntervalIsNA(x)
}
# `@name is_NA` is defined in datey.R
#' @export
#' @rdname is_NA
anyNA.datey_interval = function(x, recursive = FALSE) {
  if (!isFALSE(recursive)) stop("The recursive argument must be FALSE.", call. = FALSE)
  cpp_dateyIntervalAnyNA(x)
}

#' All valid `datey` calendar years, i.e. 1000 to 2999 inclusive.
#'
#' @description
#' The `datey_interval` [1000-01-01.0, 3000-01-01.0).
#'
#' This is the value used when a `datey_interval` is combined with a logical
#' using the `&` operator.
#' @export
#' @examples
#'   all_of_time
all_of_time <- NULL

#' Properties of a `datey_interval`
#'
#' @description
#' Test whether a `datey_interval` is empty or proper:
#'
#' - An *empty* interval does not start before its end.
#' - A *proper* interval does not end before its start.
#'
#' An NA interval is treated as empty and improper, so these methods are
#' guaranteed to return `TRUE` or `FALSE` provided the argument is a
#' `datey_interval`.
#'
#' @param interval The `datey_interval` to test.
#' @examples
#'   a <- datey(1999)
#'   b <- datey(2000)
#'   is_empty_interval(a %to% b)
#'   is_empty_interval(a %to% a)
#'   is_empty_interval(b %to% a)
#'   is_empty_interval(NA_datey_interval_)
#'   is_proper_interval(a %to% b)
#'   is_proper_interval(a %to% a)
#'   is_proper_interval(b %to% a)
#'   is_proper_interval(NA_datey_interval_)
#' @name interval_nature
NULL

#' @rdname interval_nature
#' @export
is_empty_interval <- function(interval) {
  ensure_is_datey_interval(interval)
  cpp_dateyIntervalIsEmpty(interval)
}
#' @rdname interval_nature
#' @export
is_proper_interval <- function(interval) {
  ensure_is_datey_interval(interval)
  cpp_dateyIntervalIsProper(interval)
}

#' Whether a `datey_interval` includes a `datey`
#'
#' @description
#' Test whether a `datey_interval`, [start, end) includes a `datey`, i.e.
#' start ≤ value and value < end.
#'
#' The `%includes%` operator is syntactic sugar for `interval_includes()`.
#'
#' An NA interval is treated as empty and an NA date is treated as not being in
#' any interval, so these methods are guaranteed to return `TRUE` or `FALSE`.
#'
#' @param interval The `datey_interval`.
#' @param value The `datey` to test for inclusion.
#' @name interval_includes
NULL

#' @rdname interval_includes
#' @export
interval_includes <- function(interval, value) {
  ensure_is_datey_interval(interval)
  ensure_is_datey(value)
  cpp_dateyIntervalIncludes(interval, value)
}
#' @rdname interval_includes
#' @export
`%includes%` <- function(interval, value) interval_includes(interval, value)

#' Format or print a `datey_interval`
#'
#' @description
#' A `datey_interval` is printed as "[start, end)", where start and end are
#' printed either as
#' - `YYYY-MM-DD`, i.e. ISO 8601 extended date format, or
#' - `YYYY-MM-DD.FFF` where `.FFF` is the day fraction part.
#'
#' If `include_day_fraction` is `TRUE` then `.FFF` is included even if it is 0.
#'
#' @param x The `datey_interval` to print or format.
#' @param include_day_fraction Whether to include the fractional day part.
#' Defaults to `FALSE`.
#' @param  max Numeric or `NULL`, specifying the maximal number of entries to be
#' printed. When `NULL`, `getOption("max.print")` used. Defaults to `NULL`.
#' @param ... Further arguments to be passed from or to other methods.
#' @name text_from_datey_interval
NULL

#' @rdname text_from_datey_interval
#' @export
as.character.datey_interval <- function(x, ...) format.datey_interval(x)

#' @rdname text_from_datey_interval
#' @export
format.datey_interval <- function(x, include_day_fraction = TRUE, ...) {
  ensure_is_datey_interval(x)
  ensure_is_switch(include_day_fraction)
  cpp_dateyIntervalToRString(x, include_day_fraction)
}

#' @rdname text_from_datey_interval
#' @export
print.datey_interval <- function(x, include_day_fraction = TRUE, max = NULL, ...) {
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
