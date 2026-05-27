// Date and duration arithmetic on an annual grid for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.h"

using namespace cpp11;

[[cpp11::register]]
doubles cpp_dateyInterval(integers start, integers end, bool strict)
{
  R_xlen_t n_start = start.size();
  R_xlen_t n_end = end.size();

  // Optimise common case where these are the same length.
  if (n_start == n_end)
  {
    writable::doubles result(n_start);

    for(R_xlen_t i = 0; i < n_start; ++i)
    {
      result[i] = dateyInterval(start[i], end[i], strict);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(n_start, n_end);

    writable::doubles result(n);

    if (n > 0)
    {
      if (n_start == 0 || n_end == 0)
      {
        stop("If one of `start` and `end` has a non-zero length then all must.");
      }
      if (n % n_start != 0 || n % n_end != 0)
      {
        stop("Lengths of `start` and `end` must be multiples of each other.");
      }
    }

    R_xlen_t i_start = 0;
    R_xlen_t i_end = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyInterval(start[i_start], end[i_end], strict);

      if (++i_start >= n_start) { i_start = 0;}
      if (++i_end >= n_end) { i_end = 0;}
    }

    return result;
  }
}

[[cpp11::register]]
integers cpp_dateyIntervalStart(doubles interval)
{
  R_xlen_t n = interval.size();

  writable::integers result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = std::get<0>(getStartEndFromDouble(interval[i]));
  }

  return result;
}
[[cpp11::register]]
integers cpp_dateyIntervalEnd(doubles interval)
{
  R_xlen_t n = interval.size();

  writable::integers result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = std::get<1>(getStartEndFromDouble(interval[i]));
  }

  return result;
}

[[cpp11::register]]
logicals cpp_dateyIntervalIsNA(doubles interval)
{
  R_xlen_t n = interval.size();

  writable::logicals result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto x = getStartEndFromDouble(interval[i]);
    result[i] = !isValidDatey(std::get<0>(x)) || !isValidDatey(std::get<1>(x));
  }

  return result;
}
[[cpp11::register]]
bool cpp_dateyIntervalAnyNA(doubles interval)
{
  R_xlen_t n = interval.size();

  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto x = getStartEndFromDouble(interval[i]);
    if (!isValidDatey(std::get<0>(x)) || !isValidDatey(std::get<1>(x)))
    {
      return true;
    }
  }

  return false;
}

[[cpp11::register]]
logicals cpp_dateyIntervalIsEmpty(doubles interval)
{
  R_xlen_t n = interval.size();

  writable::logicals result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto x = getStartEndFromDouble(interval[i]);
    int start = std::get<0>(x);
    int end = std::get<1>(x);
    result[i] = !isValidDatey(start) || !isValidDatey(end) || start >= end;
  }

  return result;
}
[[cpp11::register]]
logicals cpp_dateyIntervalIsProper(doubles interval)
{
  R_xlen_t n = interval.size();

  writable::logicals result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    auto x = getStartEndFromDouble(interval[i]);
    int start = std::get<0>(x);
    int end = std::get<1>(x);
    result[i] = isValidDatey(start) && isValidDatey(end) && start <= end;
  }

  return result;
}
[[cpp11::register]]
logicals cpp_dateyIntervalIncludes(doubles interval, integers value)
{
  R_xlen_t n_interval = interval.size();
  R_xlen_t n_value = value.size();

  // Optimise common case XXX.
  //if (XXX)
  //{
  //  writable::doubles result(n_start);
  //
  //  for(R_xlen_t i = 0; i < n_start; ++i)
  //  {
  //    result[i] = interval(start[i], end[i], strict);
  //  }
  //
  //  return result;
  //}
  //else
  {
    R_xlen_t n = std::max(n_interval, n_value);

    writable::logicals result(n);

    if (n > 0)
    {
      if (n_interval == 0 || n_value == 0)
      {
        stop("If one of `interval` and `datey` has a non-zero length then all must.");
      }
      if (n % n_interval != 0 || n % n_value != 0)
      {
        stop("Lengths of `interval` and `datey` must be multiples of each other.");
      }
    }

    R_xlen_t i_interval = 0;
    R_xlen_t i_value = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      auto x = getStartEndFromDouble(interval[i_interval]);
      int start = std::get<0>(x);
      int end = std::get<1>(x);

      int value_i = value[i_value];

      result[i] = isValidDatey(start) && isValidDatey(end)
        && isValidDatey(value_i)
        && start <= value_i && value_i < end;

      if (++i_interval >= n_interval) { i_interval = 0;}
      if (++i_value >= n_value) { i_value = 0;}
    }

    return result;
  }
}

[[cpp11::register]]
strings cpp_dateyIntervalToRString(doubles interval, bool includeDayFraction)
{
  R_xlen_t n = interval.size();

  writable::strings result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = dateyIntervalToRString(interval[i], includeDayFraction);
  }

  return result;
}


