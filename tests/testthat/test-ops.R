# S3 annualised fixed precision dates and durations for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

# +Δ
# -Δ
test_that("durationy unary operators", {

  D_pos <- durationy(+1)
  D_neg <- durationy(-1)

  expect_identical(+D_pos, D_pos)
  expect_identical(-D_pos, D_neg)
  expect_identical(+D_neg, D_neg)
  expect_identical(-D_neg, D_pos)
})

test_that("datey relational operators", {

  T_1999 <- datey(1999)
  T_2000 <- datey(2000)

  # T R T => logical

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

test_that("durationy relational operators", {

  D_1 <- durationy(1)
  D_2 <- durationy(2)

  # Δ R Δ => logical

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

test_that("datey and durationy arithmetic operators", {

  T_1990 <- datey(1990)
  T_2000 <- datey(2000)
  D_10 <- durationy(10)
  D_15 <- durationy(15)
  D_5 <- durationy(5)

  # T - T => Δ
  expect_identical(T_2000 - T_1990, D_10)
  # T + Δ => T
  expect_identical(T_1990 + D_10, T_2000)
  # T - Δ => T
  expect_identical(T_2000 - D_10, T_1990)

  # Δ + T => T
  expect_identical(D_10 + T_1990, T_2000)
  # Δ + Δ => Δ
  expect_identical(D_10 + D_5, D_15)
  # Δ - Δ => Δ
  expect_identical(D_15 - D_5, D_10)

  # Δ * N => Δ
  expect_identical(D_5 * 3, D_15)
  # Δ / N => Δ
  expect_identical(D_10 / 2L, D_5)

  # N * Δ => Δ
  expect_identical(3 * D_5, D_15)
})

test_that("undefined operators throw errors for dateys", {

  T1 <- datey(1999)
  T2 <- datey(2000)

  expect_error(+T1)
  expect_error(-T1)

  expect_error(T1 + T2)
  expect_error(T1 * T2)
  expect_error(T1 * 1)
  expect_error(1 * T1)

  expect_error(T1 + 1)
  expect_error(T1 - 1L)
})
test_that("undefined operators throw errors for dateys", {

  D1 <- durationy(1)
  D2 <- durationy(2)

  expect_error(D1 * D2)

  expect_error(D1 + 1)
  expect_error(D1 - 1L)
})
