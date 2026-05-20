# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

test_that("datey as.character(x) == format(x)", {
  x <- datey(1950)
  expect_identical(as.character(x), format(x))
})

test_that("durationy as.character(x) == format(x)", {
  x <- durationy(12.34)
  expect_identical(as.character(x), format(x))
})
