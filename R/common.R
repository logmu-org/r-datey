# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Combine multiple `datey`, `durationy` or `datey_interval` vectors
#'
#' @description
#' Combines (flattens) `datey`, `durationy` or `datey_interval` into a single
#' vector.
#'
#' All arguments must have the same class, i.e. all `datey`s, all `durationy`s
#' or all `datey_interval`s.
#'
#' If the first element in `c(...)` is not a `datey`, `durationy` or
#' `datey_interval` then this method will not be called. For instance,
#' `c(NA, datey("2000-01-01.0"))` results in `c(NA_integer_, 1068720000L)`.
#'
#' @param ... The items to combine.
#' @param recursive Unused.
#'
#' @returns
#'   [c()] returns a `datey`, `durationy` or `datey_interval` depending on the
#'   first argument.
#'
#' @keywords combine
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
#' @rdname combine
#' @export
c.datey_interval <- function(..., recursive = FALSE) {
  args <- list(...)
  if (!all(vapply(args, is_datey_interval, TRUE)))
    stop("All arguments must be `datey_interval`.", call. = FALSE)

  # Concatenate the underlying numeric (integer) values
  result <- NextMethod("c")
  datey_interval_from_punned_double(result)
}


#' Subset `datey`, `durationy` or `datey_interval` vectors
#'
#' @description
#' Subsets `datey`, `durationy` or `datey_interval` vectors.
#'
#' @param x A `datey`, `durationy` or `datey_interval`.
#' @param i Indices to extract.
#' @param value Value to assign.
#' @param ... Other arguments.
#'
#' @returns
#'   The subset.
#'
#' @keywords subset
#' @examples
#'   x <- datey(2001:2004)
#'   x
#'   x[2:3]
#'   x[2:3] <- datey(1999)
#'   x
#'
#' @name subset
# NULL

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
#' @rdname subset
#' @export
`[.datey_interval` <- function(x, i, ...) {
  result <- NextMethod("[")
  datey_interval_from_punned_double(result)
}

#' @rdname subset
#' @export
`[<-.datey` <- function(x, i, value) {
  result <- NextMethod("[<-")
  datey_from_clicks(result)
}
#' @rdname subset
#' @export
`[<-.durationy` <- function(x, i, value) {
  result <- NextMethod("[<-")
  durationy_from_clicks(result)
}
#' @rdname subset
#' @export
`[<-.datey_interval` <- function(x, i, value) {
  result <- NextMethod("[<-")
  datey_interval_from_punned_double(result)
}


#' Create `datey` or `durationy` sequence vector
#'
#' @description
#' Creates a `datey` or `durationy` vector by defining a sequence.
#'
#' @param from
#'     The first value in the sequence.
#'     A scalar `datey` or `durationy`.
#' @param to
#'     The sequence stops before values exceed `to`.
#'     A scalar `datey` or `durationy`.
#' @param by The increment of the sequence.
#'     A scalar `datey` or `durationy`.
#' @param ... Other arguments (not used in this package).
#'
#' @keywords sequence
#' @examples
#'   seq(from = datey(2000), to = datey(2005), by = durationy(2))
#'   seq(from = datey(2000), to = datey(1999), by = durationy(-0.25))
#' @name seq
NULL

#' @rdname seq
#' @export
seq.datey <- function(from, to, by, ...) {
  ensure_is_scalar(from)
  ensure_is_datey_scalar(to)
  ensure_is_durationy_scalar(by)
  if (...length() > 0) stop("`...` arguments are unsupported.", call. = FALSE)

  from <- unclass(from)
  to <- unclass(to)
  by <- unclass(by)

  clicks <- seq(from = from, to = to, by = by)

  datey_from_clicks(clicks)
}
#' @rdname seq
#' @export
seq.durationy <- function(from, to, by, ...) {
  ensure_is_scalar(from)
  ensure_is_durationy_scalar(to)
  ensure_is_durationy_scalar(by)

  from <- unclass(from)
  to <- unclass(to)
  by <- unclass(by)

  clicks <- seq(from = from, to = to, by = by)

  durationy_from_clicks(clicks)
}
