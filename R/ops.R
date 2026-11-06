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
#' The following are the available binary operations on `datey`,`durationy` and
#' `datey_interval` only operands, and their meaning:
#'
#' | Left | Operators | Right | Result | Notes |
#' | :---: | :---: | :---: | :---: | :--- |
#' | `datey` | `==` `!=` `<` `<=` `>` `>=` | `datey` | logical | Comparisons for dates
#' | `durationy` | `==` `!=` `<` `<=` `>` `>=` | `durationy` | `logical` | Comparisons for durations
#' | `datey_interval` | `==` `!=` | `datey_interval` | `logical` | Equality for date intervals
#' | `datey` | `-` | `datey` | `durationy` | Duration between two dates
#' | `datey` | `+` `-` | `durationy` | `datey` | A date offset by a duration
#' | `durationy` | `+` | `datey` | `datey` | A date offset by a duration
#' | `durationy` | `+` `-` | `durationy` | `durationy` | Duration addition and subtraction
#' | `datey` | `%to%` | `datey` | `datey_interval` | Create a date interval -- syntactic sugar for `datey_interval()`
#' | `datey_interval` | `%includes%` | `datey` | `logical` | Whether an interval includes a date -- syntactic sugar for `interval_includes()`
#' | `datey_interval` | `&` | `datey_interval` | `datey_interval` | Intersection of two date intervals -- `NA_datey_interval_` if the intervals are disjoint and non-adjacent
#'
#' `datey`s and `durationy`s can also be mixed with numeric operands, in which case
#' the `datey` or `durationy` is first converted to years, The following
#' operations are implemented
#'
#' - Comparison, i.e. a `datey` or `durationy` `==` `!=` `<` `<=` `>` `>=` numeric or vice versa. Result is `logical`.
#' - `datey` addition and subtraction, i.e. a `datey` `+` `-` a numeric or vice versa. Result is `double`.
#' - `durationy` arithmetic, i.e. a `durationy` `+` `-` `*` `/` a numeric or vice versa. Result is `double`.
#' - The `%to%` operator accepts numbers, which are treated as years and coerced to `datey`.
#' - The `%includes%` operator accepts a number as its right hand operand, which is treated as years and coerced to `datey`.
#'
#' When applied to `datey_interval`s, `&` is the 'intersection' operator.
#' For intervals that do not intersect the result of `&`
#' depends on whether the intervals are adjacent. If they are adjacent then the result
#' is an empty interval starting (and ending) at the point in time they touch.
#' Otherwise it is `NA_datey_interval_`. You can test whether intervals
#' `a` and `b` intersect using `is_collapsed(a & b)`.
#'
#' Throughout the **datey** package, `NA` will cause an error when used where
#' a `datey`, `durationy` or `datey_interval` is expected.
#' This is because its type is `logical` and potentially indicates user
#' error. If you want an NA value with a **datey** system type, use one of `NA_datey_`, `NA_durationy_`
#' or `NA_datey_interval_`.
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
#'
#' # %to% also accepts numbers:
#' 2000 %to% 2001
#'
#' interval %includes% t_2000 # TRUE -- start *is* included in an interval
#' interval %includes% (t_2000 + d_0.5) # TRUE
#' interval %includes% t_2001 # FALSE -- end is *not* included in an interval
#'
#' # %includes% also accepts a number as its right hand operand:
#' interval %includes% 2000.5
#'
#' # %includes% handling of NAs:
#' interval %includes% NA_datey_         # FALSE (not NA)
#' NA_datey_interval_ %includes% t_2000  # FALSE (not NA)
#'
#' (2000 %to% 2020) & (2010 %to% 2030) # [2010-01-01.0, 2020-01-01.0)
#'
#' # Non-intersecting *adjacent* intervals:
#' (2000 %to% 2001) & (2001 %to% 2002) # [2001-01-01.0, 2001-01-01.0)
#' # Non-intersecting *non*-adjacent intervals:
#' (1900 %to% 1901) & (2001 %to% 2001) # <NA>
#' @seealso [datey], [durationy], [datey_interval],
#'   `vignette("datey", package = "datey")` for a worked introduction
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
    # number op e2

    if (is_datey(e2)) {
      # N  + - == != < <= > >=  T => ?
      if (.Generic %in% c("+", "-", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(e1, as.double(e2)))
    } else if (is_durationy(e2)) {
      # N  + - * / == != < <= > >=  D => ?
      if (.Generic %in% c("+", "-", "*", "/", "==", "!=", "<", "<=", ">", ">="))
        return(get(.Generic)(e1, as.double(e2)))
    }

  } else if (is_pure_numeric(e2)) {
    # e1 op number

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

    # Neither e1 nor e2 are numeric

    if (is_datey(e1)) {

      u1 <- convert_datey_to_valid_clicks(e1)

      # datey op e2
      if (is_datey(e2)) {
        u2 <- convert_datey_to_valid_clicks(e2)
        # T R T => logical
        if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return(get(.Generic)(u1, u2))
        # T - T => D
        if (.Generic == "-") return(durationy_from_clicks(u1 - u2))
      } else if (is_durationy(e2)) {
        u2 <- convert_durationy_to_valid_clicks(e2)
        # T + D => T
        if (.Generic == "+") return(datey_from_clicks(u1 + u2))
        # T - D => T
        if (.Generic == "-") return(datey_from_clicks(u1 - u2))
      }

    } else if (is_durationy(e1)) {

      u1 <- convert_durationy_to_valid_clicks(e1)

      # durationy op e2

      if (is_datey(e2)) {
        u2 <- convert_datey_to_valid_clicks(e2)
        # D + T => T
        if (.Generic == "+") return(datey_from_clicks(u1 + u2))
      } else if (is_durationy(e2)) {
        u2 <- convert_durationy_to_valid_clicks(e2)
        # D R D => logical
        if (.Generic %in% c("==", "!=", "<", "<=", ">", ">="))  return(get(.Generic)(u1, u2))
        # D + D => D
        if (.Generic == "+") return(durationy_from_clicks(u1 + u2))
        # D - D => D
        if (.Generic == "-") return(durationy_from_clicks(u1 - u2))
      }

    } else if (is_datey_interval(e1) || is_datey_interval(e2)) {

      if (is_datey_interval(e1) && is_datey_interval(e2)) {
        if (.Generic == "==") return(e1$start == e2$start & e1$end == e2$end)
        if (.Generic == "!=") return(e1$start != e2$start | e1$end != e2$end)
      }

      # We allow datey_interval & logical
      i1 <- e1
      i2 <- e2
      if (is_pure_logical(i1)) i1 <- datey_interval(i1)
      if (is_pure_logical(i2)) i2 <- datey_interval(i2)
      if (is_datey_interval(i1) && is_datey_interval(i2)) {
        if (.Generic == "&") {
          start <- datey_from_clicks(pmax(unclass(i1$start), unclass(i2$start)))
          end <- datey_from_clicks(pmin(unclass(i1$end), unclass(i2$end)))
          xx <- datey_interval(start, end, strict = FALSE)

          return(datey_interval_from_punned_double(ifelse(is_proper(xx), xx, NA_datey_interval_)))
        }
      }

    }
  }

  stop("Binary operator `", .Generic, "` is undefined for `", deparse(substitute(e1)), "` and `", deparse(substitute(e2)), "`.", call. = FALSE)
}
