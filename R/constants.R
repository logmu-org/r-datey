# S3 annualised fixed precision dates and durations for R
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
#' | `valid_years_start` | `1000L` | The first *valid* calendar year for a `datey` |
#' | `valid_years_end` | `3000L` | The first *invalid* calendar year for a `datey` after after
#' `valid_years_start`|
#' | `valid_max_duration` | `2000L` | The maximum valid
#' duration in years for a `durationy` |
#'
#' @keywords NA
#' @seealso [is_NA], [NA_datey_], [NA_durationy_]
#' @examples
#'   x <- c(NA_durationy_, durationy(1.5))
#'   is.na(x) # c(TRUE, FALSE)
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

