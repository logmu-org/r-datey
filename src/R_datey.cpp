#include "datey.h"

using namespace cpp11;

[[cpp11::register]]
logicals cpp_isLeapYear(integers year)
{
  int n = year.size();
  writable::logicals results(n);
  for(int i = 0; i < n; ++i)
  {
    auto year_i = year[i];
    r_bool result_i;
    if (year_i >= 1000 && year_i < 3000)
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
integers cpp_IntegralDoubleToInteger(doubles x)
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
integers cpp_dateyFromYMDF(
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
      result[i] = dateyFromYMDF(year[i], month[i], day[i], dayFraction[i]);
    }
  }
  else if (n_dayFraction == 1)
  {
    double dayFraction_0 = dayFraction[0];
    for(int i = 0; i < n; ++i)
    {
      result[i] = dateyFromYMDF(year[i], month[i], day[i], dayFraction_0);
    }
  }
  else
  {
    stop("`day_fraction` must be a scalar or a vector the same size as `year`, `month` and `day`.");
  }


  return result;
}

[[cpp11::register]]
list cpp_dateyToYMDF(integers datey)
{
  int n = datey.size();

  cpp11::writable::integers year(n);
  cpp11::writable::integers month(n);
  cpp11::writable::integers day(n);
  cpp11::writable::doubles dayFraction(n);

  for(int i = 0; i < n; ++i)
  {
    auto ymdf = dateyToYMDF(datey[i]);

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
integers cpp_dateyFromRDate(doubles rDate, doubles dayFraction)
{
  int n = rDate.size();

  writable::integers result(n);

  int n_dayFraction = dayFraction.size();

  if (n_dayFraction == n)
  {
    for(int i = 0; i < n; ++i)
    {
      result[i] = dateyFromRDate(rDate[i], dayFraction[i]);
    }
  }
  else if (n_dayFraction == 1)
  {
    double dayFraction_0 = dayFraction[0];
    for(int i = 0; i < n; ++i)
    {
      result[i] = dateyFromRDate(rDate[i], dayFraction_0);
    }
  }
  else
  {
    stop("`day_fraction` must be a scalar or a vector the same size as the date vector.");
  }


  return result;
}

[[cpp11::register]]
strings cpp_dateyToRString(integers datey)
{
  int n = datey.size();

  writable::strings result(n);

  for(int i = 0; i < n; ++i)
  {
    result[i] = dateyToRString(datey[i]);
  }

  return result;
}


[[cpp11::register]]
integers cpp_dateyFromRStringOnly(strings s)
{
  int n = s.size();

  writable::integers result(n);

  for(int i = 0; i < n; ++i)
  {
    result[i] = dateyFromRStringOnly(s[i]);
  }

  return result;
}
[[cpp11::register]]
integers cpp_dateyFromRStringAndDayFraction(strings s, doubles dayFraction)
{
  int n = s.size();

  writable::integers result(n);

  int n_dayFraction = dayFraction.size();

  if (n_dayFraction == n)
  {
    for(int i = 0; i < n; ++i)
    {
      result[i] = dateyFromRStringAndDayFraction(s[i], dayFraction[i]);
    }
  }
  else if (n_dayFraction == 1)
  {
    double dayFraction_0 = dayFraction[0];
    for(int i = 0; i < n; ++i)
    {
      result[i] = dateyFromRStringAndDayFraction(s[i], dayFraction_0);
    }
  }
  else
  {
    stop("`day_fraction` must be a scalar or a vector the same size as the date vector.");
  }

  return result;
}
