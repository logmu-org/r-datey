# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Operators for `datey`, `durationy` and `datey_interval`
#'
#' @description
#'
#' The unary `-` operator can be applied to a `durationy` to change its sign.
#'
#' The following are the available binary operations on `datey` and `durationy`
#' only operands, and their meaning:
#'
#' | Left | Operators | Right | Result | Notes |
#' | :---: | :---: | :---: | :---: | :--- |
#' | `datey` | `==` `!=` `<` `<=` `>` `>=` | `datey` | logical | Order relation for dates
#' | `datey` | `-` | `datey` | `durationy` | Duration between two dates
#' | `datey` | `+` `-` | `durationy` | `datey` | A date offset by a duration
#' | `durationy` | `+` | `datey` | `datey` | A date offset by a duration
#' | `durationy` | `==` `!=` `<` `<=` `>` `>=` | `durationy` | logical |  Order relation for durations
#' | `durationy` | `+` `-` | `durationy` | `durationy` | Duration addition and substraction
#' | `datey` | `+` `-` `==` `!=` `<` `<=` `>` `>=` | numeric | numeric | The `datey` is first converted to years
#' | numeric | `+` `-` `==` `!=` `<` `<=` `>` `>=` | `datey` | numeric | The `datey` is first converted to years
#' | `durationy` | `+` `-` `*` `/` `==` `!=` `<` `<=` `>` `>=` | numeric | `durationy` | The `durationy` is first converted to years
#' | numeric | `+` `-` `*` `/` `==` `!=` `<` `<=` `>` `>=` | `durationy` | `durationy` | The `durationy` is first converted to years
#' | `datey` | `%to%` | `datey` | `datey_interval` | Syntactic sugar for `datey_interval()`
#' | `datey_interval` | `%includes%` | `datey` | logical | Whether the interval contains the date
#'
#' @param e1 First parameter.
#' @param e2 Second parameter (missing if a unary operator).
#' @returns See above table. In essence
#' - subtracting two `datey`s results in a `durationy`,
#' - comparing two `T`s results in a logical,
#' - adding or subtracting a `durationy` to or from a `T` results in a
#'   `T`, and
#' - mixing `durationy` and `datey` with numeric operands first converts
#'   the `durationy` and `datey` to years and then results in standard numeric
#'   evaluation,
#'
#' where `T` is either `datey` or `durationy` in each of the above.
#' @name ops

#' @rdname ops
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

  # ✔ T  + - == != < <= > >=  N => ?
  # ✔ N  + - == != < <= > >=  T => ?
  # ✔ Δ  + - * / == != < <= > >=  N => ?
  # ✔ N  + - * / == != < <= > >=  Δ => ?

  if (missing(e2)) {

    if (is_durationy(e1)) {
      # ✔ +Δ
      if (.Generic == "+") return(e1)
      # ✔ -Δ
      if (.Generic == "-") return(durationy_from_clicks(-unclass(e1)))
    }

    stop("Unary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "`.")
  }

  if (is_pure_numeric(e1)) {

    if (is_datey(e2)) {
      # ✔ N  + - == != < <= > >=  T => ?
      if (.Generic %in% c("+", "-", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(e1, as.double(e2)))
    } else if (is_durationy(e2)) {
      # ✔ N  + - * / == != < <= > >=  Δ => ?
      if (.Generic %in% c("+", "-", "*", "/", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(e1, as.double(e2)))
    }

  } else if (is_pure_numeric(e2))
  {
    if (is_datey(e1)) {
      # ✔ T  + - == != < <= > >=  N => ?
      if (.Generic %in% c("+", "-", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(as.double(e1), e2))
    } else if (is_durationy(e1)) {
      # ✔ Δ  + - * / == != < <= > >=  N => ?
      if (.Generic %in% c("+", "-", "*", "/", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(as.double(e1), e2))
    }

  } else {

    u1 <- unclass(e1)
    u2 <- unclass(e2)

    if (is_datey(e1)) {

      if (is_datey(e2)) {
        # ✔ T R T => logical
        if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return(get(.Generic)(u1, u2))
        # ✔ T - T => Δ
        if (.Generic == "-") return(durationy_from_clicks(u1 - u2))
      } else if (is_durationy(e2)) {
        # ✔ T + Δ => T
        if (.Generic == "+") return(datey_from_clicks(u1 + u2))
        # ✔ T - Δ => T
        if (.Generic == "-") return(datey_from_clicks(u1 - u2))
      }

    } else if (is_durationy(e1)) {

      if (is_datey(e2)) {
        # ✔ Δ + T => T
        if (.Generic == "+") return(datey_from_clicks(u1 + u2))
      } else if (is_durationy(e2)) {
        # ✔ Δ R Δ => logical
        if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return(get(.Generic)(u1, u2))
        # ✔ Δ + Δ => Δ
        if (.Generic == "+") return(durationy_from_clicks(u1 + u2))
        # ✔ Δ - Δ => Δ
        if (.Generic == "-") return(durationy_from_clicks(u1 - u2))
      } else if (is_pure_numeric(e2)) {
        # ✔ Δ * N => Δ
        if (.Generic == "*") return(durationy_from_clicks(u1 * u2))
        # ✔ Δ / N => Δ
        if (.Generic == "/") return(durationy_from_clicks(u1 / u2))
      }

    }
  }

  stop("Binary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "` and `", deparse(substitute(e2)), "`.", call. = FALSE)
}
