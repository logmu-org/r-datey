# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' @exportS3Method pillar::pillar_shaft
pillar_shaft.datey <- function(x, ...) {
  text <- as.character(x)
  pillar::new_pillar_shaft_simple(text, align = "right")
}
#' @exportS3Method pillar::pillar_shaft
pillar_shaft.durationy <- function(x, ...) {
  text <- as.character(x)
  pillar::new_pillar_shaft_simple(text, align = "right")
}
#' @exportS3Method pillar::pillar_shaft
pillar_shaft.datey_interval <- function(x, ...) {
  text <- as.character(x)
  pillar::new_pillar_shaft_simple(text, align = "right")
}
