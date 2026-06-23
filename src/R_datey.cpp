// Date and duration arithmetic on an annual grid for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.h"

using namespace cpp11;

[[cpp11::register]]
integers cpp_asSafeIntegers(doubles x)
{
  R_xlen_t n = x.size();

  writable::integers result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    int int_x;
    if (!tryConvertToSafeInteger(x[i], int_x))
    {
      stop("When using doubles for integers, the double values must be exact integers.");
    }

    result[i] = int_x;
  }

  return result;
}

[[cpp11::register]]
logicals cpp_dateyIsNA(integers clicks)
{
  R_xlen_t n = clicks.size();

  writable::logicals result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = !isValidDatey(clicks[i]);
  }

  return result;
}
[[cpp11::register]]
bool cpp_dateyAnyNA(integers clicks)
{
  R_xlen_t n = clicks.size();

  for(R_xlen_t i = 0; i < n; ++i)
  {
    if (!isValidDatey(clicks[i])) { return true; }
  }

  return false;
}

[[cpp11::register]]
integers cpp_dateyFromYMDF(
    integers year,
    integers month,
    integers day,
    doubles dayFraction,
    bool strict)
{
  R_xlen_t n_y = year.size();
  R_xlen_t n_m = month.size();
  R_xlen_t n_d = day.size();
  R_xlen_t n_f = dayFraction.size();

  // Optimise common case where
  // (a) `dayFraction` is a scalar, and
  // (b) other vectors are same length.
  if (n_f == 1 && n_y == n_m && n_y == n_d)
  {
    writable::integers result(n_y);

    double dayFraction_0 = dayFraction[0];
    for(R_xlen_t i = 0; i < n_y; ++i)
    {
      result[i] = dateyFromYMDF(year[i], month[i], day[i], dayFraction_0, strict);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(std::max(n_y, n_m), std::max(n_d, n_f));

    writable::integers result(n);

    if (n > 0)
    {
      if (n_y == 0 || n_m == 0 || n_d == 0 || n_f == 0)
      {
        stop("If one of `year`, `month`, `day` and `day_fraction` has a non-zero length then all must.");
      }
      if (n % n_y != 0 || n % n_m != 0 || n % n_d != 0 || n % n_f != 0)
      {
        stop("Lengths of `year`, `month`, `day` and `day_fraction` must be multiples of each other.");
      }
    }

    R_xlen_t i_y = 0;
    R_xlen_t i_m = 0;
    R_xlen_t i_d = 0;
    R_xlen_t i_f = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyFromYMDF(year[i_y], month[i_m], day[i_d], dayFraction[i_f], strict);

      if (++i_y >= n_y) { i_y = 0;}
      if (++i_m >= n_m) { i_m = 0;}
      if (++i_d >= n_d) { i_d = 0;}
      if (++i_f >= n_f) { i_f = 0;}
    }

    return result;
  }
}
[[cpp11::register]]
integers cpp_dateyFromYMDF_dblYMD(
    doubles year,
    doubles month,
    doubles day,
    doubles dayFraction,
    bool strict)
{
  R_xlen_t n_y = year.size();
  R_xlen_t n_m = month.size();
  R_xlen_t n_d = day.size();
  R_xlen_t n_f = dayFraction.size();

  // Optimise common case where
  // (a) `dayFraction` is a scalar, and
  // (b) other vectors are same length.
  if (n_f != 1 || n_y != n_m || n_y != n_d)
  {
    stop("Internal error. datey has failed to check lengths of `year`, `month` and `day` are equal and `day_fraction` is a scalar.");
  }
  writable::integers result(n_y);

  double dayFraction_0 = dayFraction[0];
  for(R_xlen_t i = 0; i < n_y; ++i)
  {
    int int_y, int_m, int_d;
    if (!tryConvertToSafeInteger(year[i], int_y)
      || !tryConvertToSafeInteger(month[i], int_m)
      || !tryConvertToSafeInteger(day[i], int_d)
    )
    {
      stop("When using doubles for integers, the double values must be exact integers.");
    }

    result[i] = dateyFromYMDF(int_y, int_m, int_d, dayFraction_0, strict);
  }

  return result;
}

[[cpp11::register]]
list cpp_dateyToYMDF(integers clicks)
{
  R_xlen_t n = clicks.size();

  cpp11::writable::integers year(n);
  cpp11::writable::integers month(n);
  cpp11::writable::integers day(n);
  cpp11::writable::doubles dayFraction(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto ymdf = dateyToYMDF(clicks[i]);

    year[i] = std::get<0>(ymdf);
    month[i] = std::get<1>(ymdf);
    day[i] = std::get<2>(ymdf);
    dayFraction[i] = std::get<3>(ymdf);
  }

  cpp11::writable::list result(4);
  result[0] = year;
  result[1] = month;
  result[2] = day;
  result[3] = dayFraction;
  result.names() = {"year", "month", "day", "day_fraction"};

  return result;
}
[[cpp11::register]]
integers cpp_dateyToY(integers clicks)
{
  R_xlen_t n = clicks.size();
  cpp11::writable::integers result(n);
  for(R_xlen_t i = 0; i < n; ++i)
  {
    int clicks_i = clicks[i];
    result[i] = isValidDatey(clicks_i) ? clicks_i / ClicksPerYear : NA_INTEGER;
  }

  return result;
}
[[cpp11::register]]
integers cpp_dateyToM(integers clicks)
{
  R_xlen_t n = clicks.size();
  cpp11::writable::integers result(n);
  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto ymdf = dateyToYMDF(clicks[i]);
    result[i] = std::get<1>(ymdf);
  }

  return result;
}
[[cpp11::register]]
integers cpp_dateyToD(integers clicks)
{
  R_xlen_t n = clicks.size();
  cpp11::writable::integers result(n);
  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto ymdf = dateyToYMDF(clicks[i]);
    result[i] = std::get<2>(ymdf);
  }

  return result;
}
[[cpp11::register]]
doubles cpp_dateyToF(integers clicks)
{
  R_xlen_t n = clicks.size();
  cpp11::writable::doubles result(n);
  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto ymdf = dateyToYMDF(clicks[i]);
    result[i] = std::get<3>(ymdf);
  }

  return result;
}

[[cpp11::register]]
integers cpp_dateyWithNewDayFraction(integers clicks, doubles dayFraction, bool strict)
{
  R_xlen_t n_dy = clicks.size();
  R_xlen_t n_f = dayFraction.size();

  if (n_f == 1)
  {
    // Optimise common case
    writable::integers result(n_dy);

    double dayFraction_0 = dayFraction[0];
    for(R_xlen_t i = 0; i < n_dy; ++i)
    {
      result[i] = dateyWithNewDayFraction(clicks[i], dayFraction_0, strict);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(n_dy, n_f);

    if (n > 0)
    {
      if (n_dy == 0 || n_f == 0)
      {
        stop("If one of `datey` and `day_fraction` has a non-zero length then both must.");
      }
      if (n % n_dy != 0 || n % n_f != 0)
      {
        stop("Lengths of `datey` and `day_fraction` must be multiples of each other.");
      }
    }

    writable::integers result(n);

    R_xlen_t i_dy = 0;
    R_xlen_t i_f = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyWithNewDayFraction(clicks[i_dy], dayFraction[i_f], strict);

      if (++i_dy >= n_dy) { i_dy = 0;}
      if (++i_f >= n_f) { i_f = 0;}
    }

    return result;
  }
}

/* It's not safe to create a datey treating an r date as a fraction
[[cpp11::register]]
integers cpp_dateyFromRDate(doubles rDate, bool strict)
{
  R_xlen_t n = rDate.size();

  writable::integers result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = dateyFromRDate(rDate[i], strict);
  }

  return result;
}
*/
[[cpp11::register]]
integers cpp_dateyFromRDateAndFraction(doubles rDate, doubles dayFraction, bool strict)
{
  R_xlen_t n_rd = rDate.size();
  R_xlen_t n_f = dayFraction.size();

  if (n_f == 1)
  {
    // Optimise common case
    writable::integers result(n_rd);

    double dayFraction_0 = dayFraction[0];
    for(R_xlen_t i = 0; i < n_rd; ++i)
    {
      result[i] = dateyFromRDateAndDayFraction(rDate[i], dayFraction_0, strict);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(n_rd, n_f);

    writable::integers result(n);

    if (n > 0)
    {
      if (n_rd == 0 || n_f == 0)
      {
        stop("If one of the date vector and `day_fraction` has a non-zero length then both must.");
      }
      if (n % n_rd != 0 || n % n_f != 0)
      {
        stop("Lengths of the date vector and `day_fraction` must be multiples of each other.");
      }
    }

    R_xlen_t i_rd = 0;
    R_xlen_t i_f = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyFromRDateAndDayFraction(rDate[i_rd], dayFraction[i_f], strict);

      if (++i_rd >= n_rd) { i_rd = 0;}
      if (++i_f >= n_f) { i_f = 0;}
    }

    return result;
  }
}

[[cpp11::register]]
strings cpp_dateyToRString(integers clicks, bool includeDayFraction)
{
  R_xlen_t n = clicks.size();

  writable::strings result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = dateyToRString(clicks[i], includeDayFraction);
  }

  return result;
}


[[cpp11::register]]
integers cpp_dateyFromRStringOnly(strings x, bool strict, bool blankIsNA)
{
  R_xlen_t n = x.size();

  writable::integers result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = dateyFromRStringOnly(x[i], strict, blankIsNA);
  }

  return result;
}
[[cpp11::register]]
integers cpp_dateyFromRStringAndDayFraction(strings x, doubles dayFraction, bool strict, bool blankIsNA)
{
  R_xlen_t n_x = x.size();
  R_xlen_t n_f = dayFraction.size();

  if (n_f == 1)
  {
    // Optimise common case
    writable::integers result(n_x);

    double dayFraction_0 = dayFraction[0];
    for(R_xlen_t i = 0; i < n_x; ++i)
    {
      result[i] = dateyFromRStringAndDayFraction(x[i], dayFraction_0, strict, blankIsNA);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(n_x, n_f);

    writable::integers result(n);

    if (n > 0)
    {
      if (n_x == 0 || n_f == 0)
      {
        stop("If one of the character vector and `day_fraction` has a non-zero length then both must.");
      }
      if (n % n_x != 0 || n % n_f != 0)
      {
        stop("Lengths of the character vector and `day_fraction` must be multiples of each other.");
      }
    }

    R_xlen_t i_x = 0;
    R_xlen_t i_f = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyFromRStringAndDayFraction(x[i_x], dayFraction[i_f], strict, blankIsNA);

      if (++i_x >= n_x) { i_x = 0;}
      if (++i_f >= n_f) { i_f = 0;}
    }

    return result;
  }
}
