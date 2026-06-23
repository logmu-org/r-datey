// Date and duration arithmetic on an annual grid for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.h"

using namespace cpp11;

[[cpp11::register]]
logicals cpp_durationyIsNA(integers clicks)
{
  R_xlen_t n = clicks.size();

  writable::logicals result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = !isValidDurationy(clicks[i]);
  }

  return result;
}
[[cpp11::register]]
bool cpp_durationyAnyNA(integers clicks)
{
  R_xlen_t n = clicks.size();

  for(R_xlen_t i = 0; i < n; ++i)
  {
    if (!isValidDurationy(clicks[i])) { return true; }
  }

  return false;
}


std::string GetValidatedYearUnit(strings yearUnit)
{
  if (yearUnit.size() != 1)
  {
    stop("Year unit argument cannot be a vector.");
  }

  std::string s_yearUnit = (std::string)yearUnit[0] ;
  if (s_yearUnit.size() > MaxYearUnitLength)
  {
    stop("`year_unit` cannot exceed 20 UTF-8 bytes.");
  }

  // Checking for Unicode control chars is hard. But we can check for ASCII ones

  for (char c : s_yearUnit)
  {
    if (c < 0x20 || c == 0x7F)
    {
      stop("`year_unit` cannot contain control characters.");
    }
  }

  return s_yearUnit;
}

[[cpp11::register]]
strings cpp_durationyToRString(integers clicks, bool includePlusSign, bool useTrueMinusSign, strings yearUnit)
{
  R_xlen_t n = clicks.size();

  writable::strings result(n);

  std::string s_yearUnit = GetValidatedYearUnit(yearUnit);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = durationyToRString(clicks[i], includePlusSign, useTrueMinusSign, s_yearUnit);
  }

  return result;
}

[[cpp11::register]]
integers cpp_durationyFromRString(strings x, bool strict, bool blankIsNA, strings yearUnit)
{
  R_xlen_t n = x.size();

  writable::integers result(n);

  std::string s_yearUnit = GetValidatedYearUnit(yearUnit);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = durationyFromRString(x[i], strict, blankIsNA, s_yearUnit);
  }

  return result;
}
