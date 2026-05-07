# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# +Δ
# -Δ
test_that("durationy unary operators work", {

  D_pos <- durationy(+1)
  D_neg <- durationy(-1)

  expect_identical(+D_pos, D_pos)
  expect_identical(-D_pos, D_neg)
  expect_identical(+D_neg, D_neg)
  expect_identical(-D_neg, D_pos)
})

# T R T => logical
test_that("datey relational operators work", {

  T_1999 <- as_datey(1999)
  T_2000 <- as_datey(2000)

  expect_identical(T_1999 == T_1999, TRUE)
  expect_identical(T_1999 != T_1999, FALSE)
  expect_identical(T_1999 > T_1999, FALSE)
  expect_identical(T_1999 >= T_1999, TRUE)
  expect_identical(T_1999 < T_1999, FALSE)
  expect_identical(T_1999 <= T_1999, TRUE)

  expect_identical(T_1999 == T_2000, FALSE)
  expect_identical(T_1999 != T_2000, TRUE)
  expect_identical(T_1999 > T_2000, FALSE)
  expect_identical(T_1999 >= T_2000, FALSE)
  expect_identical(T_1999 < T_2000, TRUE)
  expect_identical(T_1999 <= T_2000, TRUE)

  expect_identical(T_2000 == T_1999, FALSE)
  expect_identical(T_2000 != T_1999, TRUE)
  expect_identical(T_2000 > T_1999, TRUE)
  expect_identical(T_2000 >= T_1999, TRUE)
  expect_identical(T_2000 < T_1999, FALSE)
  expect_identical(T_2000 <= T_1999, FALSE)
})

# Δ R Δ => logical
test_that("durationy relational operators work", {

  D_1 <- durationy(1)
  D_2 <- durationy(2)

  expect_identical(D_1 == D_1, TRUE)
  expect_identical(D_1 != D_1, FALSE)
  expect_identical(D_1 > D_1, FALSE)
  expect_identical(D_1 >= D_1, TRUE)
  expect_identical(D_1 < D_1, FALSE)
  expect_identical(D_1 <= D_1, TRUE)

  expect_identical(D_1 == D_2, FALSE)
  expect_identical(D_1 != D_2, TRUE)
  expect_identical(D_1 > D_2, FALSE)
  expect_identical(D_1 >= D_2, FALSE)
  expect_identical(D_1 < D_2, TRUE)
  expect_identical(D_1 <= D_2, TRUE)

  expect_identical(D_2 == D_1, FALSE)
  expect_identical(D_2 != D_1, TRUE)
  expect_identical(D_2 > D_1, TRUE)
  expect_identical(D_2 >= D_1, TRUE)
  expect_identical(D_2 < D_1, FALSE)
  expect_identical(D_2 <= D_1, FALSE)
})

# T - T => Δ
# T + Δ => T
# T - Δ => T
# T + N => T
# T - N => T
# Δ + T => T
# Δ + Δ => Δ
# Δ - Δ => Δ
# Δ + N => Δ
# Δ - N => Δ
# Δ * N => Δ
# Δ / N => Δ

# N + T => T

# N + Δ => Δ
# N - Δ => Δ
# N * Δ => Δ
test_that("datey arithmetic operators work", {

  T_1990 <- as_datey(1990)
  T_2000 <- as_datey(2000)
  D_0 <- durationy(0)
  D_0.25 <- durationy(0.25)
  D_10 <- durationy(10)
  D_20 <- durationy(20)

  expect_identical(T_2000 - T_1990, D_10)
})

test_that("undefined operators throw errors for dateys", {

  T1 <- as_datey(1999)
  T2 <- as_datey(2000)

  expect_error(+T1)
  expect_error(-T1)

  expect_error(T1 + T2)
  expect_error(T1 * T2)
  expect_error(T1 * 1)
  expect_error(1 * T1)
})
