// Date and duration arithmetic on an annual grid for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.h"

using namespace cpp11;

[[cpp11::register]]
logicals cpp_isLeapYear_integer(integers year)
{
  R_xlen_t n = year.size();
  writable::logicals results(n);
  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto year_i = year[i];
    r_bool result_i;
    if (year_i >= ValidDateStartYear && year_i < ValidDateEndYear)
    {
      result_i = isLeapYear(year_i) ? TRUE : FALSE;
    }
    else
    {
      // This includes NA
      result_i = NA_LOGICAL;
    }
    results[i] = result_i;
  }

  return results;
}
[[cpp11::register]]
logicals cpp_isLeapYear_double(doubles year)
{
  R_xlen_t n = year.size();
  writable::logicals results(n);
  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto year_i = year[i];
    r_bool result_i;
    if (year_i >= 1000.0 && year_i < 3000.0) // Excludes NaNs
    {
      // Cast `double` to `int` here means round down given we
      // know (a) `year_i` > 0 and (b) `year_i` lies within the representable
      // range of `int`.
      // See https://en.cppreference.com/cpp/language/implicit_conversion.
      result_i = isLeapYear((int)year_i) ? TRUE : FALSE;
    }
    else
    {
      // This includes NA
      result_i = NA_LOGICAL;
    }
    results[i] = result_i;
  }

  return results;
}
[[cpp11::register]]
logicals cpp_isLeapYear_datey(integers datey)
{
  R_xlen_t n = datey.size();
  writable::logicals results(n);
  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto datey_i = datey[i];
    r_bool result_i;
    if (datey_i >= ValidDateStartClicks && datey_i < ValidDateEndClicks)
    {
      // We know `/` rounds down because datey_i >= 0
      result_i = isLeapYear(datey_i / ClicksPerYear) ? TRUE : FALSE;
    }
    else
    {
      // This includes NA
      result_i = NA_LOGICAL;
    }
    results[i] = result_i;
  }

  return results;
}
