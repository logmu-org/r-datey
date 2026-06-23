# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

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
anyNA.durationy <- function(x, recursive = FALSE) {
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
#'
#' `durationy()` to create a `durationy` from the following types:
#'
#' - `integer`. The value is interpreted as the specified
#'   number of years.
#' - `double`. The value is interpreted as the specified
#'   number of years, rounded to fixed precision of a `durationy`. This means that
#'   `durationy(0.5)` is precise but `durationy(0.01)` is not.
#' - `datey_interval`. The duration of the interval *provided it is proper*
#'   (i.e. start <= end).
#'   If the interval is improper then the result is `NA_durationy_`.
#'   When `x` is a `datey_interval` then `x$duration` is identical to
#'   `durationy(x)`.
#'   (`strict` is ignored.)
#' - `character`. Valid text is of the form `[S]...Y[.F...][ U...]` where:
#'
#'   - `[S]` is an optional plus or a minus sign, i.e. one of '+' (U+002B), true minus (U+2212) or ASCII hyphen-minus '-' (U+002D).
#'   - `...Y` is number of whole years (leading zeros allowed).
#'   - `[.F...]` is an optional fractional part of year, including '.' to represent the decimal point.
#'   - `[ U...]` is the unit name for one year preceded by a space if the unit name is not blank. The unit name cannot be longer than 20 UTF-8 bytes or contain control characters.
#'
#'   If `blank_is_NA` is `TRUE` then blanks are treated as `NA`.
#'   If `strict` is `TRUE` (the default) then non-compliant text will
#'   stop execution.
#'   If the text is NA then NA is returned.
#'   This is the same format as produced by [as.character.durationy()].
#' - `durationy`. Value is passed through unchanged.
#'
#' NA arguments *of the appropriate type* result in `NA_durationy_` --
#' they do not stop execution (regardless of `strict`).
#' Note that `NA` is `logical` and therefore it *will* cause an error.
#'
#' @param x The argument to convert to a `durationy`.
#' @param strict
#' How non-compliant non-NA `x`, e.g. years greater than 2000 in magnitude or
#' invalid text, should be handled.
#' If `strict` is `TRUE` -- the default -- then execution is stopped.
#' If `strict` is `FALSE` then `NA` is returned.
#' @param blank_is_NA
#' Whether blanks should be treated as `NA`.
#' Defaults to `FALSE`.
#' @param year_unit The year unit name to expect.
#' If not blank then the value is expected to be followed by a space and this unit text.
#' Cannot be more than 20 characters (UTF-8 bytes) or contain control
#' characters.
#' Defaults to `"yr"`.
#' @param ... Not used.
#' @returns A vector of `durationy`.
#' @examples
#' durationy(1)    # 1 yr
#' durationy(0.5)  # 0.5 yr
#' durationy(-2.3) # -2.3 yr
#' durationy(2001 %to% 2002) # 1 yr
#' durationy(2002 %to% 2001) # `NA_durationy_` because interval is improper
#'
#' # NA:
#' durationy(NA_real_)
#' try(durationy(NA)) # NA is logical, not numeric
#'
#' # Invalid durations:
#' try(durationy(3000.1)) # default strict = TRUE
#' durationy(3000.1, strict = FALSE)
#'
#' # Text:
#' durationy("10 yr")
#' durationy("+10 yr")
#' durationy("-10 yr")
#' durationy("10", year_unit = "")
#' durationy("10 a", year_unit = "a")
#'
#' # Text round trips:
#' d <- durationy(1.234)
#' identical(d, durationy(as.character(d))) # TRUE
#'
#' # Handling blank text:
#' try(durationy(""))
#' durationy("", blank_is_NA = TRUE)
#'
#' # Invalid text:
#' try(durationy("abc"))
#' try(durationy("2000.000001 yr"))
#' durationy("abc", strict = FALSE) # NA
#' durationy("2000.000001 yr", strict = FALSE) # NA
#' durationy("2000.000000 yr") # This is valid
#' @seealso [datey], [datey_interval], [text_from_durationy], [as_years_durationy],
#'   [ops], [is_NA],
#'   `vignette("why-datey", package = "datey")` for the annual-grid design,
#'   `vignette("datey", package = "datey")` for a worked introduction
#' @name durationy
NULL

#' @rdname durationy
#' @export
durationy <- function(x, ...) UseMethod("durationy")

#' @rdname durationy
#' @export
durationy.default <- function(x, ...) {
  arg_name <- deparse(substitute(x))
  stop("S3 function `durationy` is not implemented for `", arg_name, "`.", call. = FALSE)
}
#' @rdname durationy
#' @export
durationy.durationy <- function(x, ...) {
  #ensure_is_durationy(x)
  x
}
#' @rdname durationy
#' @export
durationy.integer <- function(x, strict = TRUE, ...) {
  ensure_is_switch(strict)
  in_range <- x >= -2000L & x <= 2000L
  if (strict && !all(in_range, na.rm = TRUE)) stop("Years cannot be more than 2000.", call. = FALSE)
  x <- pmax(-2000L, pmin(2000L, x))
  clicks <- ifelse(in_range, x * 534360L, NA_integer_)
  durationy_from_clicks(clicks)
}
#' @rdname durationy
#' @export
durationy.double <- function(x, strict = TRUE, ...) {
  ensure_is_switch(strict)
  in_range <- x >= -2000 & x <= 2000
  if (strict && !all(in_range, na.rm = TRUE)) stop("Years cannot be more than 2000.", call. = FALSE)
  #x <- pmax(-2000, pmin(2000, x))
  clicks <- ifelse(in_range, round(x * 534360), NA_real_)
  durationy_from_clicks(clicks)
}
#' @rdname durationy
#' @export
durationy.datey_interval <- function(x, ...) {
  clicks <- cpp_dateyIntervalDuration(x)
  durationy_from_clicks(clicks)
}
#' @rdname durationy
#' @export
durationy.character <- function(x, strict = TRUE, blank_is_NA = FALSE, year_unit = "yr", ...) {
  ensure_is_switch(strict)
  ensure_is_switch(blank_is_NA)
  ensure_is_text_scalar(year_unit)
  clicks <- cpp_durationyFromRString(x, strict, blank_is_NA, year_unit)
  durationy_from_clicks(clicks)
}

#' Convert a `durationy` to duration in years
#'
#' @description
#' Converts a `durationy` to its duration measured in years.
#'
#' `as.numeric()` is the same as `as.double()`.
#'
#' `as.integer()` obtains the integer part as an `integer`, e.g.
#' `as.integer(durationy(1.75))` is `1`
#' and `as.integer(durationy(-1.75))` is `-1` (i.e. rounding towards `0`).
#' It is also the case that if `x` is a `durationy` then
#' `as.integer(x)` is the same as `as.integer(as.double(x))`.
#'
#' @param x The `durationy` to convert to years.
#' @param ... Not used.
#' @returns A vector of `double`.
#' @examples
#' d <- durationy(1.75)
#' d                   # 1.75 yr
#' as.double(d)        # 1.75
#' as.numeric(d)       # 1.75
#' as.integer(d)       # 1
#' as.integer(-d)      # -1
#' identical(as.integer(d), 1L) # TRUE
#' @seealso [durationy], [as_years_datey], [ops]
#' @name as_years_durationy
NULL

#' @rdname as_years_durationy
#' @export
as.double.durationy <- function(x, ...) {
  clicks <- convert_durationy_to_valid_clicks(x)
  clicks / 534360
}
#' @rdname as_years_durationy
#' @export
as.integer.durationy <- function(x, ...) {
  clicks <- convert_durationy_to_valid_clicks(x)
  # Integer division rounds down towards negative infinity,
  # which is would be perfect in other circumstances but is unfortunately
  # inconsistent with floating point. So we use floating point
  # division and then the rounding conversion to integer.
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
#' [true minus sign ('-', U+2212)](https://www.compart.com/en/unicode/U+2212)
#' sign as opposed to the
#' [ASCII hyphen (-, U+002D)](https://www.compart.com/en/unicode/U+002D).
#' Defaults to `TRUE`.
#' @param year_unit The year unit name to print.
#' If not blank then the value is followed by a space and the unit.
#' Cannot be more than 20 characters (UTF-8 bytes) or contain control characters.
#' Defaults to `"yr"`.
#' @param  max Numeric or `NULL`, specifying the maximal number of entries to be
#' printed. When `NULL`, `getOption("max.print")` used. Defaults to `NULL`.
#' @param ... Other arguments.
#' @returns `as.character` and `format` return a vector of `character`.
#' `print` invisibly returns `x`.
#' @examples
#' pos <- durationy(1)
#' neg <- durationy(-2.3)
#' format(pos) # "1 yr"
#' format(pos, include_plus = TRUE) # "+1 yr"
#' format(pos, year_unit = "") # "1"
#' format(neg) # U+2212 (true minus) followed by "2.3" (CRAN-compliance)
#' format(neg, use_true_minus = FALSE) # "-2.3 yr"
#' format(neg, use_true_minus = FALSE, year_unit = "a") # "-2.3 a"
#' @seealso [durationy]
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
