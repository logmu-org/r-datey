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

test_that("intersection for datey_interval", {

  T1 <- datey(2001)
  T2 <- datey(2002)
  T3 <- datey(2003)
  T4 <- datey(2004)

  I12 <- datey_interval(T1, T2)
  I13 <- datey_interval(T1, T3)
  I23 <- datey_interval(T2, T3)
  I24 <- datey_interval(T2, T4)
  I34 <- datey_interval(T3, T4)

  # Overlapping intervals
  expect_identical(I13 & I24, I23)

  # Adjacent intervals produce an empty (collapsed, proper) interval
  expect_identical(I12 & I23, datey_interval(T2, T2))
  expect_true(is_collapsed(I12 & I23))
  expect_true(is_proper(I12 & I23))

  # Non-adjacent non-intersecting intervals produce NA
  expect_identical(I12 & I34, NA_datey_interval_)
})

test_that("equality for datey_interval", {

  T1 <- datey(2001)
  T2 <- datey(2002)
  T3 <- datey(2003)

  I12 <- datey_interval(T1, T2)
  I13 <- datey_interval(T1, T3)

  expect_identical(I12 == I12, TRUE)
  expect_identical(I12 != I12, FALSE)
  expect_identical(I12 == I13, FALSE)
  expect_identical(I12 != I13, TRUE)

  # NA propagation: NA interval produces NA result
  expect_identical(NA_datey_interval_ == I12, NA)
  expect_identical(I12 == NA_datey_interval_, NA)
  expect_identical(NA_datey_interval_ == NA_datey_interval_, NA)
})

test_that("%includes% accepts numeric RHS", {

  interval <- datey(2000) %to% datey(2001)

  expect_identical(interval %includes% 2000,   TRUE)
  expect_identical(interval %includes% 2000.5, TRUE)
  expect_identical(interval %includes% 2001,   FALSE)
  expect_identical(interval %includes% 1999.9, FALSE)
})

test_that("all op result types", {

  t <- datey(2000)
  t2 <- datey(2002.5)
  d <- durationy(2.5)
  d2 <- durationy(5)
  interval <- datey_interval(t, t2)

  # | `datey` | `==` `!=` `<` `<=` `>` `>=` | `datey` | logical | Order relation for dates
  expect_identical(t == t2, FALSE)
  expect_identical(t != t2, TRUE)
  expect_identical(t < t2, TRUE)
  expect_identical(t <= t2, TRUE)
  expect_identical(t > t2, FALSE)
  expect_identical(t >= t2, FALSE)

  # | `datey` | `-` | `datey` | `durationy` | Duration between two dates
  expect_identical(t2 - t, d)
  # | `datey` | `+` `-` | `durationy` | `datey` | A date offset by a duration
  expect_identical(t + d, t2)
  expect_identical(t2 - d, t)
  # | `durationy` | `+` | `datey` | `datey` | A date offset by a duration
  expect_identical(d + t, t2)

  # | `durationy` | `==` `!=` `<` `<=` `>` `>=` | `durationy` | `logical` |  Order relation for durations
  expect_identical(d == d2, FALSE)
  expect_identical(d != d2, TRUE)
  expect_identical(d < d2, TRUE)
  expect_identical(d <= d2, TRUE)
  expect_identical(d > d2, FALSE)
  expect_identical(d >= d2, FALSE)

  # | `durationy` | `+` `-` | `durationy` | `durationy` | Duration addition and subtraction
  expect_identical(d + d, d2)
  expect_identical(d2 - d, d)

  # | `datey` | `%to%` | `datey` | `datey_interval` | Syntactic sugar for `datey_interval()`
  expect_identical(t %to% t2, interval)

  # | `datey_interval` | `%includes%` | `datey` | `logical` | Whether the interval contains the date
  expect_identical(interval %includes% t, TRUE)


  #' - Comparison, i.e. a `datey` or `durationy` `==` `!=` `<` `<=` `>` `>=` numeric or vice versa. Result is `logical`.
  expect_identical(t == 2002.5, FALSE)
  expect_identical(t != 2002.5, TRUE)
  expect_identical(t < 2002.5, TRUE)
  expect_identical(t <= 2002.5, TRUE)
  expect_identical(t > 2002.5, FALSE)
  expect_identical(t >= 2002.5, FALSE)
  expect_identical(d == 5, FALSE)
  expect_identical(d != 5, TRUE)
  expect_identical(d < 5, TRUE)
  expect_identical(d <= 5, TRUE)
  expect_identical(d > 5, FALSE)
  expect_identical(d >= 5, FALSE)

  #' - `datey` addition and subtraction, i.e. a `datey` `+` `-` a numeric or vice versa. Result is `double`.
  expect_identical(t + 2.5, 2002.5)
  expect_identical(2.5 + t, 2002.5)
  expect_identical(t2 - 2.5, 2000)
  expect_identical(2002.5 - t, 2.5)

  #' - `durationy` arithmetic, i.e. a `durationy` `+` `-` `*` `/` a numeric or vice versa. Result is `double`.
  expect_identical(d + 2, 4.5)
  expect_identical(2 + d, 4.5)
  expect_identical(d - 2, 0.5)
  expect_identical(2 - d, -0.5)
  expect_identical(d * 2, 5)
  expect_identical(2 * d, 5)
  expect_identical(d / 2, 1.25)
  expect_identical(2 / d, 0.8)
})
