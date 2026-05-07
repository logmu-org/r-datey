# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

ensure_is_switch <- function(x) {
  if (length(x) != 1 || is.na(x) || !is.logical(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a logical scalar.")
  }
}

ensure_is_text_scalar <- function(x) {
  if (length(x) != 1 || is.na(x) || !is.character(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a (single) string.")
  }
}

ensure_is_datey <- function(x) {
  if (!is_datey(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a `datey`.")
  }
}

convert_datey_to_valid_clicks <- function(x) {
  clicks <- unclass(x)
  clicks <- ifelse(clicks >= 534360000L & clicks < 1603080000L, clicks, NA_integer_)
}

ensure_is_durationy <- function(x) {
  if (!is_durationy(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a `durationy`.")
  }
}

convert_durationy_to_valid_clicks <- function(x) {
  clicks <- unclass(x)
  clicks <- ifelse(clicks >= -1068720000L & clicks <= 1068720000L, clicks, NA_integer_)
}

is_pure_numeric <- function(x) is.numeric(x) && !is.object(x)

as_integer_for_cpp <- function(x) {
  # Exclude anything other than base numerics
  if (is.object(x) || !is.numeric(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be numeric.")
  }
  if (is.double(x)) {
    x <- cpp_asSafeIntegers(x)
  }
  x
}

as_double_for_cpp <- function(x) {
  # Exclude anything other than base numerics
  if (is.object(x) || !is.numeric(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be numeric.")
  }
  as.double(x)
}
