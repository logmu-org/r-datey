# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Generic operators for `datey` and `durationy`
#' @param e1 First (`datey`) parameter.
#' @param e2 Second parameter -- must be `datey` or `durationy`.
#' @export
Ops.datey_type <- function(e1, e2) {

  # Legal ops (where T is datey, Δ is durationy, N is numeric, R is relop):

  # Ordered by type of first op then type of second op:

  # ✔ T R T => logical
  # ✔ T - T => Δ
  # ✔ T + Δ => T
  # ✔ T - Δ => T

  # ✔ +Δ
  # ✔ -Δ
  # ✔ Δ + T => T
  # ✔ Δ R Δ => logical
  # ✔ Δ + Δ => Δ
  # ✔ Δ - Δ => Δ
  # · Δ * N => Δ
  # · Δ / N => Δ

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
      # ✔ T - T => Δ
      if (.Generic == "-") return (durationy_from_clicks(u1 - u2))
    } else if (is_durationy(e2)) {
      # ✔ T + Δ => T
      if (.Generic == "+") return (datey_from_clicks(u1 + u2))
      # ✔ T - Δ => T
      if (.Generic == "-") return (datey_from_clicks(u1 - u2))
    }

  } else if (is_durationy(e1)) {

    if (is_datey(e2)) {
      # ✔ Δ + T => T
      if (.Generic == "+") return (datey_from_clicks(u1 + u2))
    } else if (is_durationy(e2)) {
      # ✔ Δ R Δ => logical
      if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return (get(.Generic)(u1, u2))
      # ✔ Δ + Δ => Δ
      if (.Generic == "+") return (durationy_from_clicks(u1 + u2))
      # ✔ Δ - Δ => Δ
      if (.Generic == "-") return (durationy_from_clicks(u1 - u2))
    } else if (is_pure_numeric(e2)) {
      # ✔ Δ * N => Δ
      if (.Generic == "*") return (durationy_from_clicks(u1 * u2))
      # ✔ Δ / N => Δ
      if (.Generic == "/") return (durationy_from_clicks(u1 / u2))
    }

  } else if (is_pure_numeric(e1)) {

    if (is_durationy(e2)) {
      # ✔ N * Δ => Δ
      if (.Generic == "*") return (durationy_from_clicks(u1 * u2))
    }

  }

  stop("Binary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "`.")
}
