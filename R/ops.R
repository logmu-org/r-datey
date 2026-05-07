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

  # Ordered by type of first op then type of second op:

  # ✔ T R T => logical
  # · T - T => Δ
  # · T + Δ => T
  # · T - Δ => T
  # · T + N => T
  # · T - N => T

  # ✔ +Δ
  # ✔ -Δ
  # · Δ + T => T
  # ✔ Δ R Δ => logical
  # · Δ + Δ => Δ
  # · Δ - Δ => Δ
  # · Δ + N => Δ
  # · Δ - N => Δ
  # · Δ * N => Δ
  # · Δ / N => Δ

  # · N + T => T

  # · N + Δ => Δ
  # · N - Δ => Δ
  # · N * Δ => Δ

  u1 <- unclass(e1)

  if (missing(e2)) {

    if (is_durationy(e1)) {
      # ✔ +Δ
      if (.Generic == "+") return (e1)
      # ✔ -Δ
      if (.Generic == "-") return (durationy_from_clicks(-u1))
    }

    stop("Unary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "`.")
  }

  u2 <- unclass(e2)

  if (is_datey(e1)) {

    if (is_datey(e2)) {
      # ✔ T R T => logical
      if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return (get(.Generic)(u1, u2))
      # · T - T => Δ
      if (.Generic == "-") return (durationy_from_clicks(u1 - u2))
    } else if (is_durationy(e2)) {
      # · T + Δ => T
      # · T - Δ => T
    } else if (is_pure_numeric(e2)) {
      # · T + N => T
      # · T - N => T
    }

  } else if (is_durationy(e1)) {

    if (is_datey(e2)) {
      # · Δ + T => T
    } else if (is_durationy(e2)) {
      # ✔ Δ R Δ => logical
      if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return (get(.Generic)(u1, u2))
      # · Δ + Δ => Δ
      # · Δ - Δ => Δ
    } else if (is_pure_numeric(e2)) {
      # · Δ + N => Δ
      # · Δ - N => Δ
      # · Δ * N => Δ
      # · Δ / N => Δ
    }

  } else if (is_pure_numeric(e1)) {

    if (is_datey(e2)) {
      # · N + T => T
    } else if (is_durationy(e2)) {
      # · N + Δ => Δ
      # · N - Δ => Δ
      # · N * Δ => Δ
    }

  }

  stop("Binary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "`.")
}
