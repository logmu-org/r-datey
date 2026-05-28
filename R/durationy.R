# Date and duration arithmetic on an annual grid for R
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
# `[`, `[<-`
# mean, max, min, etc [in summary.R]
# seq
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
# xtfrm
# **** NOT REQUIRED ****
# [[, $, [<-, [[<-, $<-
# is.nan, is.finite is.infinite -- these automatically work

durationy_from_clicks <- function(clicks) {
  clicks <- unclass(clicks)
  if (!is.integer(clicks)) clicks <- as.integer(round(clicks))
  structure(clicks, class = c("durationy", "datey_type"))
}

# `@name NAs` is defined in datey.R
#' @rdname NAs
#' @export
NA_durationy_ <- durationy_from_clicks(NA_integer_)

# `@name is_NA` is defined in datey.R
#' @rdname is_NA
#' @export
is.na.durationy <- function(x) {
  #clicks <- unclass(x)
  #is.na(clicks) | abs(clicks) > 1068720000L
  cpp_durationyIsNA(x)
}
# `@name is_NA` is defined in datey.R
#' @rdname is_NA
#' @export
anyNA.durationy = function(x, recursive = FALSE) {
  if (!isFALSE(recursive)) stop("The recursive argument must be FALSE.", call. = FALSE)
  #any(is.na(x))
  cpp_durationyAnyNA(x)
}

# `@name is_type` is defined in datey.R
#' @param x The object to test.
#' @name is_type
#' @export
is_durationy <- function(x) typeof(x) == "integer" && isa(x, c("durationy", "datey_type"))

#' Create a `durationy` from an annual duration
#'
#' @description
#' This package provides methods to create a `durationy` from the following:
#'
#' - `integer` -- the value is interpreted as the specified
#' number of years.
#' - `double` -- the value is interpreted as the specified
#' number of years, rounded to fixed precision of a `durationy`. This means that
#' `durationy(0.5)` is precise but `durationy(0.01)` is not.
#' - `durationy` -- value is unchanged.
#'
#' This is an S3 generic.
#'
#' @param
#' x The argument to convert to a `durationy`.
#' @param strict
#' How years greater than 2000 in magnitude should be
#' handled.
#' - If `strict` is `TRUE` -- the default -- then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned.
#'
#' NA arguments result in NA (and do not stop execution) regardless of `strict`.
#' @param ... Other arguments (not used in this package).
#' @export
durationy <- function(x, strict = TRUE, ...) UseMethod("durationy")
#' @rdname durationy
#' @export
durationy.default <- function(x, strict = TRUE, ...) NA_durationy_
#' @rdname durationy
#' @export
durationy.durationy <- function(x, strict = TRUE, ...) {
  #ensure_is_durationy(x)
  x
}
#' @rdname durationy
#' @export
durationy.integer <- function(x, strict = TRUE, ...) {
  ensure_is_switch(strict)
  if (...length() > 0) stop("`...` arguments are unsupported.", call. = FALSE)
  if (strict)
  {
    if(any(x < -2000L | x > 2000L, na.rm = TRUE)) {
      stop("Absolute value of years argument is greater than 2000.", call. = FALSE)
    }
  }
  clicks <- ifelse(x >= -2000L & x <= 2000L, x * 534360L, NA_integer_)
  durationy_from_clicks(clicks)
}
#' @rdname durationy
#' @export
durationy.double <- function(x, strict = TRUE, ...) {
  ensure_is_switch(strict)
  if (...length() > 0) stop("`...` arguments are unsupported.", call. = FALSE)
  if (strict)
  {
    if(any(is.nan(x)) || any(x < -2000 | x > 2000, na.rm = TRUE)) {
      stop("Absolute value of years argument is greater than 2000.", call. = FALSE)
    }
  }
  clicks <- ifelse(x >= -2000 & x <= 2000, round(x * 534360), NA_real_)
  durationy_from_clicks(clicks)
}

#' Parse text as a `durationy`
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
#' @param strict
#' How non-compliant text (including values greater than
#' 2000 in magnitude) should be handled.
#' - If `strict` is `TRUE` then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned.
#' Defaults to `TRUE`.
#' @param blank_is_NA
#' Whether blanks should be treated as `NA`.
#' Defaults to `FALSE`.
#' @param year_unit The year unit name to expect.
#' If not blank then the value is expected to be followed by a space and this unit text.
#' Cannot be more than 20 characters (UTF-8 bytes) or contain control
#' characters.
#' Defaults to `"yr"`.
#' @param ... Other arguments (not used in this package).
#' @name text_to_durationy
NULL

#' @rdname text_to_durationy
#' @export
durationy.character <- function(x, strict = TRUE, blank_is_NA = FALSE, year_unit = "yr", ...) {
  ensure_is_switch(strict)
  ensure_is_switch(blank_is_NA)
  ensure_is_text_scalar(year_unit)
  if (...length() > 0) stop("`...` arguments are unsupported.", call. = FALSE)
  clicks <- cpp_durationyFromRString(x, strict, blank_is_NA, year_unit)
  durationy_from_clicks(clicks)
}

#' Convert a `durationy` to duration in years
#'
#' @description
#' Converts a `durationy` to duration in years.
#'
#' Note the following:
#'
#' - `as.numeric()` is the same as `as.double()`.
#' - `as.integer()` obtains the integer part,
#'   e.g. `as.integer(durationy(1.9))` is `1`
#'   and `as.integer(durationy(-1.9))` is `-1`.
#'   `as.integer(x)` is the same as `as.integer(as.double(x))`.
#'
#' @param x The `durationy` to convert to years.
#' @param ... Other arguments (not used in this package).
#' @name as_years_durationy
NULL

#' @rdname as_years_durationy
#' @export
as.double.durationy <- function(x, ...) {
  if (...length() > 0) stop("`...` arguments are unsupported.", call. = FALSE)
  clicks <- convert_durationy_to_valid_clicks(x)
  clicks / 534360
}
#' @rdname as_years_durationy
#' @export
as.integer.durationy <- function(x, ...) {
  if (...length() > 0) stop("`...` arguments are unsupported.", call. = FALSE)


    clicks <- convert_durationy_to_valid_clicks(x)
  # Integer division rounds down towards negative infinity,
  # which is inconsistent with floating point. So we use floating point
  # division first before conversion to integer.
  #clicks %/% 534360L
  as.integer(clicks / 534360)
}

#' Format or print a `durationy`
#'
#' @description
#' A `durationy` is printed as a decimal.
#'
#' This format is readable by [durationy.character()].
#'
#' @param x The `durationy` to print or format.
#' @param include_plus Whether to include a plus ('+') sign for positive
#' durations.
#' Defaults to `FALSE`.
#' @param use_true_minus Whether to use the
#' [true minus sign ('−', U+2212)](https://www.compart.com/en/unicode/U+2212)
#' sign as opposed to the
#' [ASCII hyphen (-, U+2212)](https://www.compart.com/en/unicode/U+002D).
#' Defaults to `FALSE`.
#' @param year_unit The year unit name to print.
#' If not blank then the value is followed by a space and the unit.
#' Cannot be more than 20 characters (UTF-8 bytes) or contain control characters.
#' Defaults to `"yr"`.
#' @param  max Numeric or `NULL`, specifying the maximal number of entries to be
#' printed. When `NULL`, `getOption("max.print")` used. Defaults to `NULL`.
#' @param ... Other arguments.
#' @examples
#'   pos <- durationy(1)
#'   neg <- durationy(-2.3)
#'   format(pos) # "1 yr"
#'   format(pos, include_plus = TRUE) # "1 yr"
#'   format(pos, year_unit = "") # "1"
#'   format(neg) # "−2.3 yr"
#'   format(neg, use_true_minus = TRUE) # "−2.3 yr"
#'   format(neg, year_unit = "a") # "-2.3 a"
#' @name text_from_durationy
NULL

#' @rdname text_from_durationy
#' @export
as.character.durationy <- function(x, ...) format.durationy(x)

#' @rdname text_from_durationy
#' @export
format.durationy <- function(x, include_plus = FALSE, use_true_minus = TRUE, year_unit = "yr", ...) {
  ensure_is_durationy(x)
  ensure_is_switch(include_plus)
  ensure_is_switch(use_true_minus)
  ensure_is_text_scalar(year_unit)
  cpp_durationyToRString(x, include_plus, use_true_minus, year_unit)
}

#' @rdname text_from_durationy
#' @export
print.durationy <- function(x, include_plus = FALSE, use_true_minus = TRUE, year_unit = "yr", max = NULL, ...) {
  if (is.null(max)) max <- getOption("max.print", 9999L)

  if (max < length(x)) {
    print(noquote(format(x[seq_len(max)], include_plus, use_true_minus, year_unit)), max=max+1, ...)
    cat(" [ reached 'max' / getOption(\"max.print\") -- omitted",
        length(x) - max, 'entries ]\n')
  } else if(length(x)) {
    print(noquote(format(x, include_plus, use_true_minus, year_unit)), max = max, ...)
  }
  else {
    cat(class(x)[1L], "of length 0\n")
  }

  invisible(x)
}
