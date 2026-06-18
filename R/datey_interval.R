# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# TODO:
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
#' There are two syntaxes:
#'
#' - operator: `start %to% end`
#' - function: `datey_interval(start, end)`
#'
#' These are equivalent other than `strict` is always on for the operator
#' version.
#'
#' @param start,end The start (inclusive) and end of the interval (exclusive).
#' These can be any type that is convertible to a `datey`. These have the same
#' numbers of elements or their lengths must be multiples of each other.
#' @param strict
#' How NAs should be handled.
#' If `strict` is `TRUE` -- the default -- then execution is stopped.
#' If `strict` is `FALSE` then `NA` is returned if `start` and/or `end` is NA.
#' @returns A vector of `datey_interval`.
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


#' Get the start, end or duration of a `datey_interval`
#'
#' @description
#' Get the start, end or duration of a `datey_interval` using the syntax
#' `$start`, `$end` or `$duration` respectively.
#'
#' @param x The `datey_interval`.
#' @param name
#' Must be `start`, `end` or `duration`.
#' @returns `start` and `end` return a vector of `datey`;
#'  `duration` returns a vector of `durationy`.
#' @examples
#'   t_1 <- start_day(2001, 1, 1)
#'   t_2 <- start_day(2002, 2, 2)
#'   interval <- datey_interval(t_1, t_2)
#'   interval
#'   interval$start
#'   interval$end
#'   interval$duration
#' @name interval_properties
#' @export
`$.datey_interval` <- function(x, name) {
  #ensure_is_datey_interval(x)
  if (length(name) == 1L && !is.na(name) && is.character(name)) {
    if (name == "start") return(datey_from_clicks(cpp_dateyIntervalStart(x)))
    if (name == "end") return(datey_from_clicks(cpp_dateyIntervalEnd(x)))
    if (name == "duration") return(durationy_from_clicks(cpp_dateyIntervalDuration(x)))
    stop("A `datey_interval` does not have a property called `", name, "`. Must be `start`, `end` or `duration`.", call. = FALSE)
  }

  stop("Invalid `datey_interval` property. Must be `start` or `end`.", call. = FALSE)
}

# `@name NAs` is defined in datey.R
#' @rdname NAs
#' @export
# Computed in .onLoad (R/zzz.R), as `datey_interval()` calls compiled code.
NA_datey_interval_ <- NULL

# `@name is_NA` is defined in datey.R
#' @rdname is_NA
#' @export
is.na.datey_interval <- function(x) {
  cpp_dateyIntervalIsNA(x)
}
# `@name is_NA` is defined in datey.R
#' @export
#' @rdname is_NA
anyNA.datey_interval <- function(x, recursive = FALSE) {
  if (!isFALSE(recursive)) stop("The recursive argument must be FALSE.", call. = FALSE)
  cpp_dateyIntervalAnyNA(x)
}

#' Maximum valid `datey_interval`
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
#' Test whether intervals, \eqn{[a,b)}, are 'proper' or 'collapsed':
#'
#' - A *proper* interval does not end before its start,
#' i.e. \eqn{a \le b}{a <= b}.
#' - A *collapsed* interval does not start before its end,
#' i.e. \eqn{a \ge b}{a >= b}.
#'
#' An NA interval is treated as collapsed and improper.
#'
#' These definitions imply the following:
#'
#' - A collapsed interval could be empty or improper.
#' - To test for an empty interval, i.e. \eqn{[a,a)}, test that it is both
#' proper and collapsed.
#'
#' These methods are guaranteed to return `TRUE` or `FALSE`, i.e. not `NA`
#' (provided the argument is an interval).
#'
#' Vector versions mapping each element of `x` to `TRUE` or `FALSE`:
#'
#' `is_proper(x)` tests whether the elements of `x` are proper.
#' `is_collapsed(x)` tests whether the elements of `x` are collapsed.
#'
#' Scalar versions mapping `x` to a scalar `TRUE` or `FALSE`:
#'
#' `all_proper(x)` tests whether all the elements of `x` are proper.
#' `all_collapsed(x)` tests whether all the elements of `x` are collapsed.
#' `any_collapsed(x)` tests whether at least one of the elements of `x` is
#' collapsed.
#'
#' These are S3 generic functions.
#'
#' @param x The interval to test.
#' @returns
#'   - `is_XXX` functions return a logical vector corresponding the property.
#'   - `all_XXX` and `any_XXX` functions return a logical scalar.
#' @examples
#'   a <- datey(1999)
#'   b <- datey(2000)
#'   is_collapsed(a %to% b)
#'   is_collapsed(a %to% a)
#'   is_collapsed(b %to% a)
#'   is_collapsed(NA_datey_interval_)
#'   is_proper(a %to% b)
#'   is_proper(a %to% a)
#'   is_proper(b %to% a)
#'   is_proper(NA_datey_interval_)
#' @name interval_nature
NULL

#' @rdname interval_nature
#' @export
is_proper <- function(x) UseMethod("is_proper")
#' @rdname interval_nature
#' @export
is_proper.default <- function(x) NA
#' @rdname interval_nature
#' @export
is_proper.datey_interval <- function(x) {
  ensure_is_datey_interval(x)
  cpp_dateyIntervalIsProper(x)
}
#' @rdname interval_nature
#' @export
all_proper <- function(x) UseMethod("all_proper")
#' @rdname interval_nature
#' @export
all_proper.default <- function(x) NA
#' @rdname interval_nature
#' @export
all_proper.datey_interval <- function(x) {
  ensure_is_datey_interval(x)
  cpp_dateyIntervalAllProper(x)
}
#' @rdname interval_nature
#' @export
is_collapsed <- function(x) UseMethod("is_collapsed")
#' @rdname interval_nature
#' @export
is_collapsed.default <- function(x) NA
#' @rdname interval_nature
#' @export
is_collapsed.datey_interval <- function(x) {
  ensure_is_datey_interval(x)
  cpp_dateyIntervalIsCollapsed(x)
}
#' @rdname interval_nature
#' @export
all_collapsed <- function(x) UseMethod("all_collapsed")
#' @rdname interval_nature
#' @export
all_collapsed.default <- function(x) NA
#' @rdname interval_nature
#' @export
all_collapsed.datey_interval <- function(x) {
  ensure_is_datey_interval(x)
  cpp_dateyIntervalAllCollapsed(x)
}
#' @rdname interval_nature
#' @export
any_collapsed <- function(x) UseMethod("any_collapsed")
#' @rdname interval_nature
#' @export
any_collapsed.default <- function(x) NA
#' @rdname interval_nature
#' @export
any_collapsed.datey_interval <- function(x) {
  ensure_is_datey_interval(x)
  cpp_dateyIntervalAnyCollapsed(x)
}

#' Whether a `datey_interval` includes a `datey`
#'
#' @description
#' Test whether a `datey_interval`, \eqn{[a,b)}, includes a `datey` \eqn{t}, i.e.
#' \eqn{a \le t}{a <= t} and \eqn{t < b}.
#'
#' The `%includes%` operator is syntactic sugar for `interval_includes()`.
#'
#' An NA interval is treated as empty and an NA date is treated as not being in
#' any interval, so these methods are guaranteed to return `TRUE` or `FALSE`.
#'
#' @param interval The `datey_interval`.
#' @param value The `datey` to test for inclusion.
#' @returns A vector of `logical` corresponding to whether the interval
#' includes the value. Always TRUE or FALSE -- NAs result in FALSE.
#' @examples
#'   t_2000 <- datey(2000)
#'   t_2001 <- datey(2001)
#'   t_2002 <- datey(2002)
#'   t_2003 <- datey(2003)
#'   t_2004 <- datey(2004)
#'
#'   interval <- t_2000 %to% t_2003
#'   interval %includes% t_2000
#'   interval %includes% t_2001 # Start of interval *is* included
#'   interval %includes% t_2002
#'   interval %includes% t_2003 # End of interval *not* included
#'   interval %includes% t_2004
#'   interval %includes% NA_datey_        # NAs are FALSE
#'   NA_datey_interval_ %includes% t_2004 # NAs are FALSE
#'   interval_includes(NA_datey_interval_, t_2002) # NAs are FALSE
#'
#'   # Function syntax:
#'   interval_includes(interval, t_2002)
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
#' Defaults to `TRUE`.
#' @param  max Numeric or `NULL`, specifying the maximal number of entries to be
#' printed. When `NULL`, `getOption("max.print")` used. Defaults to `NULL`.
#' @param ... Further arguments to be passed from or to other methods.
#' @returns `as.character` and `format` return a vector of `character`.
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
