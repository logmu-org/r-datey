#include <cpp11.hpp>
#include "datey.h"

using namespace cpp11;

[[cpp11::register]]
integers cpp_safeDoubleToInteger(doubles x)
{
  int n = x.size();

  writable::integers result(n);

  for(int i = 0; i < n; ++i)
  {
    double x_i = x[i];

    int result_i;

    if (R_IsNaN(x_i))
    {
      result_i = NA_INTEGER;
    }
    else
    {
      // Behaviour of `nearbyint()` for fractions depends on
      // rounding mode, but that doesn't matter here.
      //
      // We deliberately exclude -(2^31) on because
      // (a) R may use it for NA_INTEGER, and
      // (b) it catches people out.
      double rounded = std::nearbyint(x_i);
      if (rounded != x_i || std::abs(rounded) > INT_MAX)
      {
        result_i = NA_INTEGER;
      }
      else
      {
        result_i = (int)rounded;
      }
    }

    result[i] = result_i;
  }

  return result;
}

[[cpp11::register]]
integers cpp_clicksFromYMDF(
  integers year,
  integers month,
  integers day,
  doubles dayFraction)
{
  int n = year.size();
  if (month.size() != n || day.size() != n)
  {
    stop("`year`, `month` and `day` must be the same size.");
  }

  writable::integers result(n);

  int n_dayFraction = dayFraction.size();

  if (n_dayFraction == n)
  {
    for(int i = 0; i < n; ++i)
    {
      result[i] = clicksFromYMDF(year[i], month[i], day[i], dayFraction[i]);
    }
  }
  else if (n_dayFraction == 1)
  {
    double dayFraction_0 = dayFraction[0];
    for(int i = 0; i < n; ++i)
    {
      result[i] = clicksFromYMDF(year[i], month[i], day[i], dayFraction_0);
    }
  }
  else
  {
    stop("`day_fraction` must have either 1 element or the same number as `year`, `month` and `day`.");
  }


  return result;
}

[[cpp11::register]]
list cpp_clicksToYMDF(integers clicks)
{
  int n = clicks.size();

  cpp11::writable::integers year(n);
  cpp11::writable::integers month(n);
  cpp11::writable::integers day(n);
  cpp11::writable::doubles dayFraction(n);

  for(int i = 0; i < n; ++i)
  {
    auto ymdf = clicksToYMDF(clicks[i]);

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
logicals cpp_isLeapYear(integers year)
{
  int n = year.size();
  writable::logicals results(n);
  for(int i = 0; i < n; ++i)
  {
    auto year_i = year[i];
    r_bool result_i;
    if (year_i == NA_INTEGER)
    {
      result_i = NA_LOGICAL;
    }
    else
    {
      result_i = isLeapYear(year_i) ? TRUE : FALSE;
    }
    results[i] = result_i;
  }

  return results;
}
