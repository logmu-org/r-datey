# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

if (getRversion() >= "2.15.1")  utils::globalVariables("pillar_shaft_character")

.pkg_env <- new.env(parent = emptyenv())


.onLoad <- function(libname, pkgname) {

  assignInMyNamespace("all_of_time", datey_interval(1000,3000))
}
