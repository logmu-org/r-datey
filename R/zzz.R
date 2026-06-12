# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# `all_of_time` and `NA_datey_interval_` are computed via `datey_interval()`,
# which calls compiled code, so they cannot be assigned at build time -- they
# must be computed when the package is loaded on the user's machine. `<<-`
# here finds and updates the placeholder bindings declared in
# R/datey_interval.R, before the namespace is sealed and its exports are
# copied for `library()` users.
.onLoad <- function(libname, pkgname) {
  all_of_time <<- datey_interval(valid_years_start, valid_years_end)
  NA_datey_interval_ <<- datey_interval(NA_datey_, NA_datey_, strict = FALSE)
}
