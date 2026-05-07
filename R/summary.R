# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Mean value of `datey` or `durationy`
#' @param x The `datey` or `durationy`.
#' @param na.rm	A logical (`TRUE` or `FALSE`) indicating whether NA values should be removed before the computation.
#' @param ...	Ignored.
#' @export
mean.datey <- function (x, ..., na.rm = FALSE) {
  clicks <- convert_datey_to_valid_clicks(x)
  datey_from_clicks(mean(clicks, na.rm = na.rm))
}
#' @rdname mean.datey
#' @export
mean.durationy <- function (x, ..., na.rm = FALSE) {
  clicks <- convert_durationy_to_valid_clicks(x)
  durationy_from_clicks(mean(clicks, na.rm = na.rm))
}

#' Maximum, minimum or range of `datey` or `durationy`
#' @param ... The `datey` or `durationy` arguments.
#' @param na.rm	A logical (`TRUE` or `FALSE`) indicating whether NA values should be removed before the computation.
#' @exportS3Method base::Summary
Summary.datey <- function (..., na.rm = FALSE) {

  if (!(.Generic %in% c("min", "max", "range")))
    stop("Unrecognised summary method `", .Generic, "`.")

  args <- list(...)

  if (length(args) == 0) return (NA_datey_)

  classes <- lapply(args, class)

  # Check all classes are identical
  all_same <- all(vapply(classes, identical, logical(1), classes[[1]]))

  if (!all_same) {
    stop("All arguments in '...' must be of the same class.")
  }

  args_as_clicks <- lapply(args, convert_datey_to_valid_clicks)
  args_as_clicks$na.rm <- na.rm

  result_as_clicks <- do.call(get(.Generic), args_as_clicks)

  datey_from_clicks(result_as_clicks)
}
#' @rdname Summary.datey
#' @export
Summary.durationy <- function (..., na.rm = FALSE) {

  if (!(.Generic %in% c("min", "max", "range")))
    stop("Unrecognised summary method `", .Generic, "`.")

  args <- list(...)

  if (length(args) == 0) return (NA_durationy_)

  classes <- lapply(args, class)

  # Check all classes are identical
  all_same <- all(vapply(classes, identical, logical(1), classes[[1]]))

  if (!all_same) {
    stop("All arguments in '...' must be of the same class.")
  }

  args_as_clicks <- lapply(args, convert_durationy_to_valid_clicks)
  args_as_clicks$na.rm <- na.rm

  result_as_clicks <- do.call(get(.Generic), args_as_clicks)

  durationy_from_clicks(result_as_clicks)
}
