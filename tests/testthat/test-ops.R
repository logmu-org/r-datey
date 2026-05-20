# Date and duration arithmetic on an annual grid for R
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
})

test_that("undefined operators throw errors for dateys", {

  T1 <- datey(1999)
  T2 <- datey(2000)
  N1 <- 1
  N2 <- 2L

  expect_error(+T1)
  expect_error(-T1)

  expect_error(T1 + T2)
  expect_error(T1 * T2)
  expect_error(T1 * N1)
  expect_error(T1 * N2)
  expect_error(N1 * T1)
  expect_error(N2 * T1)

  expect_error(T1 / N2)
  expect_error(N1 / T1)
})
test_that("undefined operators throw errors for durationys", {

  D1 <- durationy(1)
  D2 <- durationy(2)

  expect_error(D1 * D2)
  expect_error(D1 / D2)
})
test_that("datey / durationy operators with numerics", {

  T_2000 <- datey(2000)
  D_10 <- durationy(10)

  # ✔ T  + - == != < <= > >=  N => ?
  expect_identical(T_2000 + 1, 2001)
  expect_identical(T_2000 - 1, 1999)
  expect_identical(T_2000 == 2000, TRUE)
  expect_identical(T_2000 != 2000, FALSE)
  expect_identical(T_2000 < 2000, FALSE)
  expect_identical(T_2000 <= 2000, TRUE)
  expect_identical(T_2000 > 2000, FALSE)
  expect_identical(T_2000 >= 2000, TRUE)
  expect_identical(T_2000 == 1999, FALSE)
  expect_identical(T_2000 != 1999, TRUE)
  expect_identical(T_2000 < 1999, FALSE)
  expect_identical(T_2000 <= 1999, FALSE)
  expect_identical(T_2000 > 1999, TRUE)
  expect_identical(T_2000 >= 1999, TRUE)

  # ✔ N  + - == != < <= > >=  T => ?
  expect_identical(1 + T_2000, 2001)
  expect_identical(1 - T_2000, -1999)
  expect_identical(2000 == T_2000, TRUE)
  expect_identical(2000 != T_2000, FALSE)
  expect_identical(2000 < T_2000, FALSE)
  expect_identical(2000 <= T_2000, TRUE)
  expect_identical(2000 > T_2000, FALSE)
  expect_identical(2000 >= T_2000, TRUE)
  expect_identical(1999 == T_2000, FALSE)
  expect_identical(1999 != T_2000, TRUE)
  expect_identical(1999 < T_2000, TRUE)
  expect_identical(1999 <= T_2000, TRUE)
  expect_identical(1999 > T_2000, FALSE)
  expect_identical(1999 >= T_2000, FALSE)

  # ✔ Δ  + - * / == != < <= > >=  N => ?
  expect_identical(D_10 + 1, 11)
  expect_identical(D_10 - 1, 9)
  expect_identical(D_10 * 2, 20)
  expect_identical(D_10 / 2, 5)
  expect_identical(D_10 == 10, TRUE)
  expect_identical(D_10 != 10, FALSE)
  expect_identical(D_10 < 10, FALSE)
  expect_identical(D_10 <= 10, TRUE)
  expect_identical(D_10 > 10, FALSE)
  expect_identical(D_10 >= 10, TRUE)
  expect_identical(D_10 == 9, FALSE)
  expect_identical(D_10 != 9, TRUE)
  expect_identical(D_10 < 9, FALSE)
  expect_identical(D_10 <= 9, FALSE)
  expect_identical(D_10 > 9, TRUE)
  expect_identical(D_10 >= 9, TRUE)

  # ✔ N  + - * / == != < <= > >=  Δ => ?
  expect_identical(1 + D_10, 11)
  expect_identical(1 - D_10, -9)
  expect_identical(2 * D_10, 20)
  expect_identical(20 / D_10, 2)
  expect_identical(10 == D_10, TRUE)
  expect_identical(10 != D_10, FALSE)
  expect_identical(10 < D_10, FALSE)
  expect_identical(10 <= D_10, TRUE)
  expect_identical(10 > D_10, FALSE)
  expect_identical(10 >= D_10, TRUE)
  expect_identical(9 == D_10, FALSE)
  expect_identical(9 != D_10, TRUE)
  expect_identical(9 < D_10, TRUE)
  expect_identical(9 <= D_10, TRUE)
  expect_identical(9 > D_10, FALSE)
  expect_identical(9 >= D_10, FALSE)
})

