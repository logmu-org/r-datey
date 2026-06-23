# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

is_pure_logical <- function(x) is.logical(x) && !is.object(x)
is_pure_numeric <- function(x) is.numeric(x) && !is.object(x)
is_pure_character <- function(x) is.character(x) && !is.object(x)


as_integer_for_cpp <- function(x) {
  # Exclude anything other than base numerics
  if (is.object(x) || !is.numeric(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be numeric.", call. = FALSE)
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
    stop("The argument `", arg_name, "` must be numeric.", call. = FALSE)
  }
  as.double(x)
}

convert_datey_to_valid_clicks <- function(x) {
  clicks <- unclass(x)
  clicks <- ifelse(clicks >= 534360000L & clicks <= 1603080000L, clicks, NA_integer_)
}

convert_durationy_to_valid_clicks <- function(x) {
  clicks <- unclass(x)
  clicks <- ifelse(clicks >= -1068720000L & clicks <= 1068720000L, clicks, NA_integer_)
}

ensure_is_scalar <- function(x) {
  if (is.null(x) || length(x) != 1L) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a scalar.", call. = FALSE)
  }
}

ensure_is_switch <- function(x) {
  if (length(x) != 1L || is.na(x) || !is.logical(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a logical scalar.", call. = FALSE)
  }
}

ensure_is_text_scalar <- function(x) {
  if (length(x) != 1L || is.na(x) || !is.character(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a (single) string.", call. = FALSE)
  }
}

ensure_is_datey <- function(x) {
  if (!is_datey(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a `datey`.", call. = FALSE)
  }
}

ensure_is_datey_scalar <- function(x) {
  if (!is_datey(x) || length(x) != 1L) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a scalar `datey`.", call. = FALSE)
  }
}

ensure_is_durationy <- function(x) {
  if (!is_durationy(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a `durationy`.", call. = FALSE)
  }
}

ensure_is_durationy_scalar <- function(x) {
  if (!is_durationy(x) || length(x) != 1L) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a scalar `durationy`.", call. = FALSE)
  }
}

ensure_is_datey_interval <- function(x) {
  if (!is_datey_interval(x)) {
    arg_name <- deparse(substitute(x))
    stop("The argument `", arg_name, "` must be a `datey_interval`.", call. = FALSE)
  }
}
