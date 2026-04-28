#include "datey.h"

using namespace cpp11;

[[cpp11::register]]
integers cpp_dateyFromYMDF(
  integers year,
  integers month,
  integers day,
  doubles dayFraction)
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
      result[i] = dateyFromYMDF(year[i], month[i], day[i], dayFraction_0);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(std::max(n_y, n_m), std::max(n_d, n_f));

    writable::integers result(n);

    R_xlen_t i_y = 0;
    R_xlen_t i_m = 0;
    R_xlen_t i_d = 0;
    R_xlen_t i_f = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyFromYMDF(year[i], month[i], day[i], dayFraction[0]);

      if (++i_y >= n_y) { i_y = 0;}
      if (++i_m >= n_m) { i_m = 0;}
      if (++i_d >= n_d) { i_d = 0;}
      if (++i_f >= n_f) { i_f = 0;}
    }

    return result;
  }
}

[[cpp11::register]]
list cpp_dateyToYMDF(integers datey)
{
  R_xlen_t n = datey.size();

  cpp11::writable::integers year(n);
  cpp11::writable::integers month(n);
  cpp11::writable::integers day(n);
  cpp11::writable::doubles dayFraction(n);

  for(R_xlen_t i = 0; i < n; ++i)
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
integers cpp_dateyWithNewDayFraction(integers datey, doubles dayFraction)
{
  R_xlen_t n_dy = datey.size();
  R_xlen_t n_f = dayFraction.size();

  if (n_f == 1)
  {
    // Optimise common case
    writable::integers result(n_dy);

    double dayFraction_0 = dayFraction[0];
    for(R_xlen_t i = 0; i < n_dy; ++i)
    {
      result[i] = dateyWithNewDayFraction(datey[i], dayFraction_0);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(n_dy, n_f);

    writable::integers result(n);

    R_xlen_t i_dy = 0;
    R_xlen_t i_f = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyWithNewDayFraction(datey[i], dayFraction[i]);

      if (++i_dy >= n_dy) { i_dy = 0;}
      if (++i_f >= n_f) { i_f = 0;}
    }

    return result;
  }
}

[[cpp11::register]]
integers cpp_dateyFromRDate(doubles rDate)
{
  R_xlen_t n = rDate.size();

  writable::integers result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = dateyFromRDate(rDate[i]);
  }

  return result;
}
[[cpp11::register]]
integers cpp_dateyFromRDateAndFraction(doubles rDate, doubles dayFraction)
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
      result[i] = dateyFromRDateAndDayFraction(rDate[i], dayFraction_0);
    }

    return result;
  }
  else
  {
    R_xlen_t n = std::max(n_rd, n_f);

    writable::integers result(n);

    R_xlen_t i_rd = 0;
    R_xlen_t i_f = 0;

    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyFromRDateAndDayFraction(rDate[i], dayFraction[i]);

      if (++i_rd >= n_rd) { i_rd = 0;}
      if (++i_f >= n_f) { i_f = 0;}
    }

    return result;
  }
}

[[cpp11::register]]
strings cpp_dateyToRString(integers datey, bool includeDayFraction)
{
  R_xlen_t n = datey.size();

  writable::strings result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = dateyToRString(datey[i], includeDayFraction);
  }

  return result;
}


[[cpp11::register]]
integers cpp_dateyFromRStringOnly(strings s)
{
  R_xlen_t n = s.size();

  writable::integers result(n);

  for(R_xlen_t i = 0; i < n; ++i)
  {
    result[i] = dateyFromRStringOnly(s[i]);
  }

  return result;
}
[[cpp11::register]]
integers cpp_dateyFromRStringAndDayFraction(strings s, doubles dayFraction)
{
  R_xlen_t n = s.size();

  writable::integers result(n);

  R_xlen_t n_f = dayFraction.size();

  if (n_f == n)
  {
    for(R_xlen_t i = 0; i < n; ++i)
    {
      result[i] = dateyFromRStringAndDayFraction(s[i], dayFraction[i]);
    }
  }
  else if (n_f == 1)
  {
    double dayFraction_0 = dayFraction[0];
    for(R_xlen_t i = 0; i < n; ++i)
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

