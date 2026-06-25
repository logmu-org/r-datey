#' @title Exact date and duration arithmetic on an annual grid
#' @description
#' The **datey** package provides three types for date and duration arithmetic
#' on an annual grid:
#'
#' - [datey] — a point in time, expressed as a calendar date with an optional
#'   day fraction.
#' - [durationy] — a duration in years.
#' - [datey_interval] — a closed-open interval \[`start`, `end`) of time.
#'
#' Arithmetic, comparison and summary operations are defined in [ops],
#' [mean.datey] and [max_min].
#'
#' @seealso
#' - [datey], [durationy], [datey_interval] for the core types.
#' - [ops] for arithmetic and comparison operators.
#' - [is_NA] and [NAs] for handling missing values.
#' - `vignette("datey")` for a worked introduction.
#' - `vignette("why-datey")` for the motivation and design of the annual grid.
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom lifecycle deprecated
#' @useDynLib datey, .registration = TRUE
## usethis namespace: end
NULL
