# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Combine multiple `datey` or `durationy` vectors
#'
#' @description
#' Combines (flattens) `datey` or `durationy` into a single vector.
#'
#' All arguments must have the same class, i.e. they must be all `datey`s or all
#' `durationy`s.
#'
#' If the first element in `c(...)` is not a `datey` or `durationy` then this
#' method will not be called. For instance, `c(NA, datey("2000-01-01.0"))`
#' results in `c(NA_integer_, 1068720000L)`.
#'
#'
#' @param ... The items to combine.
#' @param recursive Unused.
#'
#' @returns
#'   [c()] returns a `datey` or `durationy` depending on the first argument.
#'
#' @keywords classes manip
#' @examples
#'   c(datey(2000:2019), datey("2020-01-01.0"))
#' @name combine
NULL

#' @rdname combine
#' @export
c.datey <- function(..., recursive = FALSE) {
  args <- list(...)
  if (!all(vapply(args, is_datey, TRUE)))
    stop("All arguments must be `datey`.", call. = FALSE)

  # Concatenate the underlying numeric (integer) values
  result <- NextMethod("c")
  datey_from_clicks(result)
}

#' @rdname combine
#' @export
c.durationy <- function(..., recursive = FALSE) {
  args <- list(...)
  if (!all(vapply(args, is_durationy, TRUE)))
    stop("All arguments must be `durationy`.", call. = FALSE)

  # Concatenate the underlying numeric (integer) values
  result <- NextMethod("c")
  durationy_from_clicks(result)
}


#' Subset `datey` or `durationy` vectors
#'
#' @description
#' Subsets `datey` or `durationy` vectors without dropping S3 class.
#'
#' @param x A `datey` or `durationy`.
#' @param i Indices to extract.
#' @param ... Passed through.
#'
#' @returns
#'   The subset.
#'
#' @keywords classes setset
#' @examples
#'   c(datey(2000:2019), datey("2020-01-01.0"))
#' @name subset
NULL

#' @rdname subset
#' @export
`[.datey` <- function(x, i, ...) {
  result <- NextMethod("[")
  datey_from_clicks(result)
}

#' @rdname subset
#' @export
`[.durationy` <- function(x, i, ...) {
  result <- NextMethod("[")
  durationy_from_clicks(result)
}
