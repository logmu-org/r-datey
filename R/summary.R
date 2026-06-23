# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Mean value of `datey` or `durationy`
#' @description
#' Gets the mean value of a vector of `datey` or `durationy` as a scalar.
#'
#' This will entail rounding if the mean of
#' the underlying click counts is not an integer.
#'
#' These are S3 methods for the `mean` generic.
#' @param x The `datey` or `durationy`.
#' @param na.rm	A logical (`TRUE` or `FALSE`) indicating whether NA values should be removed before the computation.
#' @param ... Not used.
#' @returns A scalar of `datey` or `durationy` as appropriate.
#' @examples
#'     t <- datey(2000:2003)
#'     t
#'     mean(t)
#' @seealso [datey], [durationy], [max_min]
#' @name mean

#' @rdname mean
#' @export
mean.datey_interval <- function(x, ..., na.rm = FALSE) {
  stop("`mean` is not defined for `datey_interval`; use `$start`, `$end` or `$duration`.", call. = FALSE)
}
#' @rdname mean
#' @export
mean.datey <- function (x, ..., na.rm = FALSE) {
  clicks <- convert_datey_to_valid_clicks(x)
  datey_from_clicks(mean(clicks, na.rm = na.rm))
}
#' @rdname mean
#' @export
mean.durationy <- function (x, ..., na.rm = FALSE) {
  clicks <- convert_durationy_to_valid_clicks(x)
  durationy_from_clicks(mean(clicks, na.rm = na.rm))
}

#' Minimum, maximum or range of `datey` or `durationy`
#' @description
#' Gets the minimum, maximum or range of one or more `datey` or `durationy`
#' vectors. All arguments must be of the same type.
#'
#' Returns a typed NA (`NA_datey_` or `NA_durationy_`) for empty input or
#' when all values are NA and `na.rm = TRUE`.
#'
#' These are S3 methods for the `Summary` group generic.
#' @param ... One or more `datey` or `durationy` vectors. All must be the same type.
#' @param na.rm	A logical (`TRUE` or `FALSE`) indicating whether NA values should be removed before the computation.
#' @returns
#' `min` and `max` return a scalar.
#' `range` returns a two element vector,
#' the first element being the minimum and the second the maximum.
#' @examples
#'     t <- datey(2000:2003)
#'     t
#'     min(t)
#'     max(t)
#'     range(t)
#' @seealso [datey], [durationy], [mean.datey]
#' @name max_min

#' @rdname max_min
#' @export
Summary.datey_interval <- function(..., na.rm = FALSE) {
  stop("Summary methods (`min`, `max`, `range`) are not defined for `datey_interval`; use `$start`, `$end` or `$duration`.", call. = FALSE)
}
#' @rdname max_min
#' @export
Summary.datey <- function (..., na.rm = FALSE) {

  if (!(.Generic %in% c("min", "max", "range")))
    stop("Summary method `", .Generic, "` is not implemented for `datey`.", call. = FALSE)

  args <- list(...)

  if (length(args) == 0) return(NA_datey_)

  classes <- lapply(args, class)

  # Check all classes are identical
  all_same <- all(vapply(classes, identical, logical(1), classes[[1]]))

  if (!all_same)
    stop("All arguments in '...' must be `datey`.", call. = FALSE)

  args_as_clicks <- lapply(args, convert_datey_to_valid_clicks)

  combined <- unlist(args_as_clicks, use.names = FALSE)
  if (length(combined) == 0L || (na.rm && all(is.na(combined))))
    return(if (.Generic == "range") c(NA_datey_, NA_datey_) else NA_datey_)

  args_as_clicks$na.rm <- na.rm

  result_as_clicks <- do.call(get(.Generic), args_as_clicks)

  datey_from_clicks(result_as_clicks)
}
#' @rdname max_min
#' @export
Summary.durationy <- function (..., na.rm = FALSE) {

  if (!(.Generic %in% c("min", "max", "range")))
    stop("Summary method `", .Generic, "` is not implemented for `durationy`.", call. = FALSE)

  args <- list(...)

  if (length(args) == 0) return(NA_durationy_)

  classes <- lapply(args, class)

  # Check all classes are identical
  all_same <- all(vapply(classes, identical, logical(1), classes[[1]]))

  if (!all_same) {
    stop("All arguments in '...' must be `durationy`.", call. = FALSE)
  }

  args_as_clicks <- lapply(args, convert_durationy_to_valid_clicks)

  combined <- unlist(args_as_clicks, use.names = FALSE)
  if (length(combined) == 0L || (na.rm && all(is.na(combined))))
    return(if (.Generic == "range") c(NA_durationy_, NA_durationy_) else NA_durationy_)

  args_as_clicks$na.rm <- na.rm

  result_as_clicks <- do.call(get(.Generic), args_as_clicks)

  durationy_from_clicks(result_as_clicks)
}
