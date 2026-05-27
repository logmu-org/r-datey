# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Integer constants
#'
#' @description
#'
#' The following integer constants may make code clearer.
#'
#' | Constant | Value | Meaning |
#' | :--- | :--- | :--- |
#' | `valid_years_start` | `1000L` | The first calendar year for a `datey` |
#' | `valid_years_end` | `3000L` | The final valid calendar year for a `datey` (noting that only the start of this year is valid) |
#' | `valid_duration_years_max` | `2000L` | The maximum valid duration in years for a `durationy` |
#'
#' @keywords NA
#' @seealso [is_NA], [NAs]
#' @examples
#'   datey(valid_years_start - 0.001)
#'   datey(valid_years_start)
#'   datey(valid_years_end)
#'   datey(valid_years_end + 0.001)
#'   durationy(-(valid_duration_years_max + 0.001))
#' @name integer_constants


#' @rdname integer_constants
#' @export
valid_years_start <- 1000L

#' @rdname integer_constants
#' @export
valid_years_end <- 3000L

#' @rdname integer_constants
#' @export
valid_duration_years_max <- 2000L

