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


#' Handling invalid durations
#'
#' @description
#'
#' A duration within the datey system is valid if it represents 2000 years or
#' less.
#'
#' Larger durations are treated as NA.
#'
#' Use
#'
#' - `is.na()` to test whether `datey` is NA by element, and
#' - `anyNA()` to test whether any element of a `datey` is NA.
#'
#' The `durationy` version of NA is `NA_durationy_`.
#'
#' For convenience, the constant `valid_max_duration` is the maximum valid
#' duration in years (2000).
#'
#' For performance reasons, intermediate calculations may not check for NAs.
#'
#' @param x The `durationy` to test for validity.
#' @param recursive	Unused.
#' @return A single logical value, `TRUE` or `FALSE`, never `NA` and never
#'   anything other than a single value.
#' @keywords NA
#' @seealso as_durationy
#' @examples
#'   x <- c(NA_durationy_, as_durationy(1.5))
#'   is.na(x) # c(TRUE, FALSE)
#'   anyNA(x) # TRUE
#' @name durationy.NA
NULL

#' @rdname durationy.NA
#' @export
NA_durationy_ <- structure(NA_integer_, class = "durationy")
#' @rdname durationy.NA
#' @export
is.na.durationy <- function(x) {
  clicks <- unclass(x)
  is.na(clicks) | abs(clicks) > 1068720000L
}
#' @rdname durationy.NA
#' @export
anyNA.durationy = function(x, recursive = FALSE) any(is.na(x))
#' @rdname durationy.NA
#' @export
valid_duration_years_max <- 2000L

#' Check if an object is a `durationy`
#'
#' Checks whether an object is a `durationy`.
#'
#' @param x The object to test.
#' @export
is_durationy <- function(x) typeof(x) == "integer" && inherits(x, "durationy")

#' Convert an object to a `durationy`
#'
#' @description
#' This is an S3 generic. This package provides methods for the
#' following classes:
#'
#' - `integer` -- the value is interpreted as the specified
#' number of years.
#' - `double` -- the value is interpreted as the specified
#' number of years, rounded to fixed precision of a `durationy`. This means that
#' `as_durationy(0.5)` is precise but `as_durationy(0.01)` is not.
#' - `durationy` -- value is unchanged.
#'
#' @param
#' x A vector of the S3 class.
#' @param strict
#' How years greater than 2000 in magnitude should be
#' handled.
#' - If `strict` is `TRUE` -- the default -- then execution is stopped.
#' - If `strict` is `FALSE` then `NA` is returned.
#'
#' (NAs will result in NA regardless of this switch.)
#' @param ... Other arguments (not used in this package).
#' @export
as_durationy <- function(x, strict = TRUE, ...) UseMethod("as_durationy")
#' @rdname as_durationy
#' @export
as_durationy.default <- function(x, strict = TRUE, ...) NA_durationy_
#' @rdname as_durationy
#' @export
as_durationy.durationy <- function(x, strict = TRUE, ...) {
  #ensure_is_durationy(x)
  x
}
#' @rdname as_durationy
#' @export
as_durationy.integer <- function(x, strict = TRUE, ...) {
  ensure_is_switch(strict)
  if (strict)
  {
    if(any(x < -2000L | x > 2000L, na.rm = TRUE)) {
      stop("Absolute value of years argument is greater than 2000.")
    }
  }
  clicks <- ifelse(x >= -2000L & x <= 2000L, x * 534360L, NA_integer_)
  structure(clicks, class = "durationy")
}
#' @rdname as_durationy
#' @export
as_durationy.double <- function(x, strict = TRUE, ...) {
  ensure_is_switch(strict)
  if (strict)
  {
    if(any(is.nan(x)) || any(x < -2000 | x > 2000, na.rm = TRUE)) {
      stop("Absolute value of years argument is greater than 2000.")
    }
  }
  clicks <- ifelse(x >= -2000 & x <= 2000, round(x * 534360), NA_real_)
  structure(as.integer(clicks), class = "durationy")
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
#' Cannot be more than 20 characters (UTF-8 bytes) or contain control characters.
#' Defaults to `"yr"`.
#' @param ... Other arguments (not used in this package).
#' @export
as_durationy.character <- function(x, strict = TRUE, blank_is_NA = FALSE, year_unit = "yr", ...) {
  ensure_is_switch(strict)
  ensure_is_switch(blank_is_NA)
  ensure_is_text_scalar(year_unit)
  clicks <- cpp_durationyFromRString(x, strict, blank_is_NA, year_unit)
  structure(clicks, class = "durationy")
}

#' A `durationy` as years
#'
#' @description
#' A `durationy` converted to years.
#'
#' Conversion to an integer rounds to the nearest whole year.
#'
#' @param x The `durationy` to convert to years.
#' @param ... Further arguments to be passed from or to other methods.
#' @export
as.double.durationy <- function(x, ...) {
  clicks <- convert_durationy_to_valid_clicks(x)
  clicks / 534360
}
#' @rdname as.double.durationy
#' @export
as.integer.durationy <- function(x, ...) {
  clicks <- convert_durationy_to_valid_clicks(x)
  # Integer division rounds down towards negative infinity,
  # which is inconsistent with float-point. So we use floating point division
  # first.
  #clicks %/% 534360L
  as.integer(clicks / 534360)
}

#' Concatenate `durationy` vectors
#'
#' @description
#' Combines (flattens) `durationy` vectors.
#'
#' If the first element in `c(...)` is not a `durationy` then this method will not
#' be called. For instance, `c(NA, as_durationy(1))` is *not* a `durationy`.
#'
#' @param ... The items to combine
#' @param recursive Unused.
#'
#' @returns
#'   [c()] returns a vector of `durationy`s.
#'
#'   \[cbind()\] and \[rbind()\] return a matrix, data.frame or list with dimensions
#'
#' @note
#' R currently only dispatches generic `c` to method `c.durationy` if the
#'   first argument is a `durationy`.
#'
#' @keywords classes manip
#' @examples
#'   c(as_durationy(1), as_durationy("2.5 yr"))
#' @export
c.durationy <- function(..., recursive = FALSE) {
  args <- list(...)
  if (!all(vapply(args, inherits, TRUE, "durationy")))
    stop("All arguments must inherit from \"durationy\".")

  # Concatenate the underlying numeric (integer) values
  result <- NextMethod("c")

  # Re-apply class
  class(result) <- "durationy"
  result
}

#' Format or print a `durationy`
#'
#' @description
#' A `durationy` is printed as a decimal.
#'
#' This format is readable by [as_durationy.character()].
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
#' @param ... Further arguments to be passed from or to other methods.
#' @examples
#'   pos <- as_durationy(1)
#'   neg <- as_durationy(-2.3)
#'   format(pos) # "1 yr"
#'   format(pos, include_plus = TRUE) # "1 yr"
#'   format(pos, year_unit = "") # "1"
#'   format(neg) # "−2.3 yr"
#'   format(neg, use_true_minus = TRUE) # "−2.3 yr"
#'   format(neg, year_unit = "a") # "-2.3 a"
#' @export
format.durationy <- function(x, include_plus = FALSE, use_true_minus = TRUE, year_unit = "yr", ...) {
  ensure_is_durationy(x)
  ensure_is_switch(include_plus)
  ensure_is_switch(use_true_minus)
  ensure_is_text_scalar(year_unit)
  cpp_durationyToRString(x, include_plus, use_true_minus, year_unit)
}

#' @rdname format.durationy
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
