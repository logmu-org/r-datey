# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

#' Generic operators for `datey`
#' @param e1 First (`datey`) parameter.
#' @param e2 Second parameter -- must be `datey` or `durationy`.
# @exportS3Method package::generic
Ops.datey <- function(e1, e2) {

  # Legal ops with first parameter a datey:
  #   datey rel_op datey
  #   datey + durationy
  #   datey - durationy

  u1 <- unclass(e1)
  u2 <- unclass(e2)

  #if (!typeof(e1) != "integer") stop()
  if (inherits(e2, "datey")) {
    #if (!typeof(e2) != "integer") stop()
    if (.Generic %in% c("==", "!=", "<", "<=", ">", ">=")) {
      get(.Generic)(u1, u2)
    } else {
      stop(.Generic, " is supported only for comparison with other dateys")
    }
  }
  else if (inherits(e2, "durationy")) {
    #if (!typeof(e2) != "integer") stop()
    if (.Generic %in% c("+", "-")) {
      structure(get(.Generic)(u1, u2), class = "datey")
    } else {
      stop(.Generic, " is supported only for comparison with other dateys")
    }
  } else {
    stop(.Generic, " not supported for units")
  }
}
