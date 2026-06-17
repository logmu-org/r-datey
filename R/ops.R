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
#' @examples
#' t_2000 <- datey(2000)
#' t_2001 <- datey(2001)
#' d_0.5 <- durationy(0.5)
#'
#' t_2000
#' t_2001
#' d_0.5
#'
#' t_2001 - t_2000 # `datey` - `datey` is a `durationy`
#' t_2000 + d_0.5  # `datey` + `durationy` is a `datey`
#' t_2001 - d_0.5  # `datey` - `durationy` is a `datey`
#' t_2000 + 0.5    # Arithmetic with numerics results in a double
#' d_0.5 + d_0.5   # `durationy` + `durationy` is a `durationy`
#' d_0.5 + 0.5     # Arithmetic with numerics results in a double
#' d_0.5 * 2       # Arithmetic with numerics results in a double
#'
#' interval <- t_2000 %to% t_2001
#' interval
#' interval %includes% t_2000 # TRUE -- start *is* included in an interval
#' interval %includes% (t_2000 + d_0.5) # TRUE
#' interval %includes% t_2001 # FALSE -- end is *not* included in an interval
#' @name ops

#' @rdname ops
#' @export
Ops.datey_type <- function(e1, e2) {

  # Legal ops (where T is datey, D is durationy, N is numeric, R is relop):

  # Ordered by type of first op then type of second op:

  # T R T => logical
  # T - T => D
  # T + D => T
  # T - D => T

  # +D
  # -D
  # D + T => T
  # D R D => logical
  # D + D => D
  # D - D => D

  # T  + - == != < <= > >=  N => ?
  # N  + - == != < <= > >=  T => ?
  # D  + - * / == != < <= > >=  N => ?
  # N  + - * / == != < <= > >=  D => ?

  if (missing(e2)) {

    if (is_durationy(e1)) {
      # +D
      if (.Generic == "+") return(e1)
      # -D
      if (.Generic == "-") return(durationy_from_clicks(-unclass(e1)))
    }

    stop("Unary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "`.", call. = FALSE)
  }

  if (is_pure_numeric(e1)) {

    if (is_datey(e2)) {
      # N  + - == != < <= > >=  T => ?
      if (.Generic %in% c("+", "-", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(e1, as.double(e2)))
    } else if (is_durationy(e2)) {
      # N  + - * / == != < <= > >=  D => ?
      if (.Generic %in% c("+", "-", "*", "/", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(e1, as.double(e2)))
    }

  } else if (is_pure_numeric(e2))
  {
    if (is_datey(e1)) {
      # T  + - == != < <= > >=  N => ?
      if (.Generic %in% c("+", "-", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(as.double(e1), e2))
    } else if (is_durationy(e1)) {
      # D  + - * / == != < <= > >=  N => ?
      if (.Generic %in% c("+", "-", "*", "/", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(as.double(e1), e2))
    }

  } else {

    u1 <- unclass(e1)
    u2 <- unclass(e2)

    if (is_datey(e1)) {

      if (is_datey(e2)) {
        # T R T => logical
        if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return(get(.Generic)(u1, u2))
        # T - T => D
        if (.Generic == "-") return(durationy_from_clicks(u1 - u2))
      } else if (is_durationy(e2)) {
        # T + D => T
        if (.Generic == "+") return(datey_from_clicks(u1 + u2))
        # T - D => T
        if (.Generic == "-") return(datey_from_clicks(u1 - u2))
      }

    } else if (is_durationy(e1)) {

      if (is_datey(e2)) {
        # D + T => T
        if (.Generic == "+") return(datey_from_clicks(u1 + u2))
      } else if (is_durationy(e2)) {
        # D R D => logical
        if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return(get(.Generic)(u1, u2))
        # D + D => D
        if (.Generic == "+") return(durationy_from_clicks(u1 + u2))
        # D - D => D
        if (.Generic == "-") return(durationy_from_clicks(u1 - u2))
      } else if (is_pure_numeric(e2)) {
        # D * N => D
        if (.Generic == "*") return(durationy_from_clicks(u1 * u2))
        # D / N => D
        if (.Generic == "/") return(durationy_from_clicks(u1 / u2))
      }

    } else if (is_datey_interval(e1) || is_datey_interval(e2)) {

      if (is_pure_logical(e1)) {
        e1 <- ifelse(e1, all_of_time, NA_datey_interval_)
      }
      if (is_pure_logical(e2)) {
        e2 <- ifelse(e2, all_of_time, NA_datey_interval_)
      }
      if (is_datey_interval(e1) && is_datey_interval(e2)) {
        if (.Generic == "&") {
          start <- datey_from_clicks(max(unclass(e1$start), unclass(e2$start)))
          end <- datey_from_clicks(min(unclass(e1$end), unclass(e2$end)))

          return(datey_interval(start, end, strict = FALSE))
        }
      }

    }
  }

  stop("Binary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "` and `", deparse(substitute(e2)), "`.", call. = FALSE)
}
