# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Generic operators for `datey`
#' @param e1 First (`datey`) parameter.
#' @param e2 Second parameter -- must be `datey` or `durationy`.
#' @export
Ops.datey_type <- function(e1, e2) {

  # Legal ops (where T is datey, Δ is durationy, N is numeric, R is relop):

  #   +T
  #   +Δ
  #   -Δ

  #   T R T => logical
  #   Δ R Δ => logical

  #   T + Δ => T
  #   T - Δ => T
  #   T + N => T
  #   T - N => T
  #   Δ + T => T
  #   Δ - T => T
  #   N + T => T
  #   N - T => T

  #   N * Δ => Δ
  #   Δ * N => Δ
  #   Δ / N => Δ

  if (is_datey(e1)) {
    if (is_durationy)

  } else if (is_datey(e2)) {

  } else {

  }
  u2 <- unclass(e2)

  #if (!typeof(e1) != "integer") stop()
  if (inherits(e2, "datey")) {
    #if (!typeof(e2) != "integer") stop()
    if (.Generic %in% c("==", "!=", "<", "<=", ">", ">=")) {
      get(.Generic)(u1, u2)
    } else {
      stop(.Generic, " is supported only for comparison with other dateys")
    }
  }
  else if (inherits(e2, "durationy")) {
    #if (!typeof(e2) != "integer") stop()
    if (.Generic %in% c("+", "-")) {
      structure(get(.Generic)(u1, u2), class = "datey")
    } else {
      stop(.Generic, " is supported only for comparison with other dateys")
    }
  } else {
    stop(.Generic, " not supported for units")
  }
}

Ops.length_m <- function(e1, e2) {
  v1 <- if (inherits(e1, "length_m")) e1$value else e1
  v2 <- if (inherits(e2, "length_m")) e2$value else e2

  result <- get(.Generic)(v1, v2)

  # Comparisons return logical; arithmetic returns length_m
  if (.Generic %in% c("==", "!=", "<", "<=", ">", ">=")) {
    result
  } else if (.Generic %in% c("+", "-", "*", "/")) {
    length_m(result)
  } else {
    stop(.Generic, " is not defined for length_m")
  }
}
