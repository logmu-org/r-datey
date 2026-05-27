# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

pillar_shaft.datey <- function(x, ...) {
  text <- as.character(x)
  pillar_shaft_character(text, align = "right")
}
pillar_shaft.durationy <- function(x, ...) {
  text <- as.character(x)
  pillar_shaft_character(text, align = "right")
}
pillar_shaft.datey_interval <- function(x, ...) {
  text <- as.character(x)
  pillar_shaft_character(text, align = "right")
}
