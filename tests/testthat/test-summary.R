# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

test_that("mean of datey", {
  x <- c(datey(1950), datey(1900), datey(2000), datey(2050))
  expect_identical(mean(x), datey(1975))
})

test_that("mean of durationy", {
  x <- c(durationy(-5), durationy(+10), durationy(+1))
  expect_identical(mean(x), durationy(+2))
})

test_that("summaries of datey", {
  x <- c(datey(1950), datey(1900), datey(2000), datey(2050))
  x2 <- c(datey(1800), datey(2100))
  expect_identical(min(x), datey(1900))
  expect_identical(min(x, x2), datey(1800))
  expect_identical(max(x), datey(2050))
  expect_identical(max(x, x2), datey(2100))
  expect_identical(range(x), c(datey(1900), datey(2050)))
  expect_identical(range(x, x2), c(datey(1800), datey(2100)))
})

test_that("summaries of durationy", {
  x <- c(durationy(-5), durationy(+10), durationy(+1))
  x2 <- c(durationy(-10), durationy(+20))
  expect_identical(min(x), durationy(-5))
  expect_identical(min(x, x2), durationy(-10))
  expect_identical(max(x), durationy(+10))
  expect_identical(max(x, x2), durationy(+20))
  expect_identical(range(x), c(durationy(-5),durationy(+10)))
  expect_identical(range(x, x2), c(durationy(-10),durationy(+20)))
})
