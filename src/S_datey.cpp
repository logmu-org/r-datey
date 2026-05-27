// Date and duration arithmetic on an annual grid for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.h"
//#include <math.h>

constexpr int DaysToStartByMonth365[13] = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 };
constexpr int DaysToStartByMonth366[13] = { 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 };

bool isValidDatey(int clicks)
{
  return clicks >= ValidDateStartClicks && clicks <= ValidDateEndClicks;
}

bool is1000To2999(int year)
{
  return year >= ValidDateStartYear && year < ValidDateEndYear;
}

bool isValidMonth(int month)
{
  return month >= 1 && month <= 12;
}

bool isValidDayFraction(double dayFraction)
{
  // Exclude NaNs
  return dayFraction >= 0.0 && dayFraction <= 1.0;
}

bool isLeapYear(int year)
{
  // For comparison and benchmarking of various approaches see
  // https://www.benjoffe.com/fast-leap-year.

  // Source: https://hueffner.de/falk/blog/a-leap-year-check-in-three-instructions.html.
  // uint32_t is part of C++11.
  const uint32_t f = 1073750999u;
  const uint32_t m = 3221352463u;
  const uint32_t t = 126976u;
  return ((uint32_t(year) * f) & m) <= t;
}

int dateyFromYMDF(int year, int month, int day, double dayFraction, bool strict)
{
  if (!is1000To2999(year) || !isValidMonth(month) || day < 1 || !isValidDayFraction(dayFraction))
  {
    if (
      // Special case: 0999-12-31 + day_fraction == 1 (*not* rounds to 1)
      !(year == 999 && month == 12 && day == 31 && dayFraction == 1.0)
      // Special case: 3000-01-01 + day_fraction == 0 (*not* rounds to 0)
      && !(year == 3000 && month == 1 && day == 1 && dayFraction == 0.0)
      )
    {
      if (cpp11::is_na(year) || cpp11::is_na(month) || cpp11::is_na(day) || cpp11::is_na(dayFraction) )
      {
        return NA_INTEGER;
      }

      if (strict)
      {
        const char *msg;
        if (!is1000To2999(year))
        {
          msg = "`year` is outside [1000,2999] and date is not 0999-12-31.1 or 3000-01-01.0.";
        }
        else if (!isValidMonth(month))
        {
          msg = "`month` must be 1 to 12 inclusive.";
        }
        else
        {
          msg = "`day_fraction` must be in the interval [0,1].";
        }
        cpp11::stop(msg);
      }

      return NA_INTEGER;
    }
  }

  double clicksPerDay;
  int const *daysToStartByMonth;
  if (isLeapYear(year))
  {
    clicksPerDay = ClicksPerDay366;
    daysToStartByMonth = DaysToStartByMonth366;
  }
  else
  {
    clicksPerDay = ClicksPerDay365;
    daysToStartByMonth = DaysToStartByMonth365;
  }

  int daysToEndOfMonth = daysToStartByMonth[month];
  int daysToStartOfMonth = daysToStartByMonth[month - 1];

  int dayLess1 = day - 1;
  if (dayLess1 < 0 || dayLess1 >= daysToEndOfMonth - daysToStartOfMonth)
  {
    if (strict)
    {
      cpp11::stop("`day` argument must be 1 to M, where M is the number of days in the month.");
    }
    return NA_INTEGER;
  }

  int dayCount = daysToStartOfMonth + dayLess1;

  int fractionClicks = (int)roundBankers(dayFraction * clicksPerDay);

  return year * ClicksPerYear + dayCount * clicksPerDay + fractionClicks;
}

std::tuple<int, int, int, double> dateyToYMDF(int datey)
{
  if (!isValidDatey(datey))
  {
    return std::make_tuple(NA_INTEGER, NA_INTEGER, NA_INTEGER, NA_REAL);
  }

  int year = datey / ClicksPerYear;
  int clicksRemaining = datey - year * ClicksPerYear;

  int clicksPerDay;
  int const *daysToStartByMonth;
  if (isLeapYear(year))
  {
    clicksPerDay = ClicksPerDay366;
    daysToStartByMonth = DaysToStartByMonth366;
  }
  else
  {
    clicksPerDay = ClicksPerDay365;
    daysToStartByMonth = DaysToStartByMonth365;
  }

  int wholeDaysFromStartOfYear = clicksRemaining / clicksPerDay;
  clicksRemaining -= wholeDaysFromStartOfYear * clicksPerDay;

  for (int monthLess1 = 11; ; --monthLess1)
  {
    int daysToStartOfMonth = daysToStartByMonth[monthLess1];
    if (wholeDaysFromStartOfYear >= daysToStartOfMonth)
    {
      int day = wholeDaysFromStartOfYear - daysToStartOfMonth + 1;
      int month = monthLess1 + 1;
      double dayFraction = clicksRemaining / (double)clicksPerDay;
      return std::make_tuple(year, month, day, dayFraction);
    }
  }

  // This is unreachable.
  return std::make_tuple(NA_INTEGER, NA_INTEGER, NA_INTEGER, NA_REAL);
}

int dateyWithNewDayFraction(int datey, double dayFraction, bool strict)
{
  if (!isValidDatey(datey)) { return NA_INTEGER; }

  if (!isValidDayFraction(dayFraction))
  {
    if (cpp11::is_na(dayFraction) )
    {
      return NA_INTEGER;
    }

    if (strict)
    {
      cpp11::stop("`day_fraction` must be in the interval [0,1].");
    }

    return NA_INTEGER;
  }

  int year = datey / ClicksPerYear;
  int clicksToY = year * ClicksPerYear;
  int clicksRemaining = datey - clicksToY;

  int clicksPerDay = isLeapYear(year) ? ClicksPerDay366 : ClicksPerDay365;

  int day = clicksRemaining / clicksPerDay;
  int clicksYToD = day * clicksPerDay;
  int clicksDToF = roundBankers(dayFraction * clicksPerDay);

  int clicks = clicksToY + clicksYToD + clicksDToF;

  // 3000-01-01.0 + df > 0 can make illegal
  if (clicks > ValidDateEndClicks)
  {
    if (strict) { cpp11::stop("Resulting datey is invalid."); }
    return NA_INTEGER;
  }

  return clicks;
}

const double rDate_1000_01_01 = -354285.0;
const double rDate_3000_01_01 = 376200.0;
const int JulianDay_1970_01_01 = 719162;

int dateyFromRDate(double rDate, bool strict)
{
  // Following allows for NA and NaNs:
  if (!(rDate>= rDate_1000_01_01 && rDate < rDate_3000_01_01))
  {
    if (cpp11::is_na(rDate)) { return NA_INTEGER; }

    if (strict)
    {
      cpp11::stop("`Date` calendar year is outside valid `datey` interval [1000,3000).");
    }

    return NA_INTEGER;
  }

  // Rounding the R Date *before* adding the 1970 offset is more accurate.
  // NB We can't simply cast to `int` before adding the offset because that
  // rounds towards 0.
  double floor = std::floor(rDate);

  int julianDay = (int)floor + JulianDay_1970_01_01;
  int year = yearFromJulianDay(julianDay);

  int clicksPerDay = isLeapYear(year) ? ClicksPerDay366 : ClicksPerDay365;

  int day = julianDay - firstJulianDayOfYear(year);

  return year * ClicksPerYear
    + day * clicksPerDay
    + (int)roundBankers((rDate - floor) * clicksPerDay);
}
int dateyFromRDateAndDayFraction(double rDate, double dayFraction, bool strict)
{
  // Following allows for NA and NaNs:
  if (!(rDate>= rDate_1000_01_01 && rDate < rDate_3000_01_01))
  {
    if (strict)
    {
      cpp11::stop("`Date` calendar year is outside valid `datey` interval [1000,3000).");
    }
    return NA_INTEGER;
  }

  // Rounding the R Date *before* adding the 1970 offset is more accurate.
  // NB We can't simply cast to `int` before adding the offset because that
  // rounds towards 0.
  double floor = std::floor(rDate);

  int julianDay = (int)floor + JulianDay_1970_01_01;
  int year = yearFromJulianDay(julianDay);

  int clicksPerDay = isLeapYear(year) ? ClicksPerDay366 : ClicksPerDay365;

  int day = julianDay - firstJulianDayOfYear(year);

  return year * ClicksPerYear
    + day * clicksPerDay
    + (int)roundBankers(dayFraction * clicksPerDay);
}

int yearFromJulianDay(int julianDay)
{
  // Based on date calculation in the .NET CLR.

  // The CLR source states that it is based on
  // https://arxiv.org/pdf/2102.06959.pdf
  // Cassio Neri, Lorenz Schneider (2021)
  // "Euclidean Affine Functions and Applications to Calendar Algorithms"

  // Also see: https://onlinelibrary.wiley.com/doi/full/10.1002/spe.3172

  // This code assumes two's complement arithmetic, which is *not* currently
  // guaranteed by C++. That said,
  // - all available R C++ compilers use it, and
  // - it is proposed to be standard for C++20.
  // See https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p0907r1.html.

  // Tim Gordon 2026-04-22

  uint32_t r1 = (((uint32_t)julianDay * 4u) | 3u) + 1224u;
  uint32_t y100 = r1 / 146097u;
  r1 -= y100 * 146097u;
  uint64_t  u2 = (uint64_t)(((int64_t)r1 | 3L) * 2939745L);
  uint16_t daySinceMarch1 = (uint16_t)((uint32_t)u2 / 11758980u);
  int year = (int)(100 * y100 + (uint32_t)(u2 >> 32));
  if (daySinceMarch1 >= 306) { ++year; }
  return year;
}

int firstJulianDayOfYear(int year)
{
  int k = year - 1;
  int cent = k / 100;
  return k * (365 * 4 + 1) / 4 - cent + cent / 4;
}

// Leaves pChars pointing to `trailing `\0` end byte
void writeValidDatey(int datey, bool includeDayFraction, char*& pChars)
{
  auto ymdf = dateyToYMDF(datey);

  writeN(std::get<0>(ymdf), pChars, 4);
  pChars[4] = '-';
  writeN(std::get<1>(ymdf), pChars + 5, 2);
  pChars[7] = '-';
  writeN(std::get<2>(ymdf), pChars + 8, 2);

  if (includeDayFraction)
  {
    pChars[10] = '.';

    int f_times_10000 = (int)roundBankers(std::get<3>(ymdf) * 10000.0);

    writeN(f_times_10000, pChars + 11, 4);

    // Remove trailing zeros:
    pChars += 15;
    *pChars = '\0';

    // Leave at least one trailing '0'
    for (int i = 2; i >= 0; --i)
    {
      if (*(pChars - 1) != '0') { break; }
      --pChars;
      *pChars = '\0';
    }
  }
  else
  {
    pChars += 10;
    *pChars = '\0';
  }
}

cpp11::r_string dateyToRString(int datey, bool includeDayFraction)
{
  if (!isValidDatey(datey)) { return NA_STRING; }

  // 4 digits distinguishes between values
  // 16 chars captures max text plus 0 terminator
  // YYYY-MM-DD.0###\0
  char chars[16];

  char* pChars = chars;

  writeValidDatey(datey, includeDayFraction, pChars);

  return cpp11::r_string(chars);
}

int dateyFromRStringOnly(cpp11::r_string rString, bool blankIsNA, bool strict)
{
  if (cpp11::is_na(rString)) { return NA_INTEGER; }

  std::string s = (std::string)rString;

  auto size = s.size();

  if (blankIsNA && size == 0) { return NA_INTEGER; }

  int clicks;

  // "YYYY-MM-DD" or "YYYY-MM-DD.0###" = 10 or 12+ chars
  if (size < 10 || size == 11 || size > 100)
  {
    clicks = NA_INTEGER;
  }
  else
  {
    // As of C++11, `data()` is guaranteed to be null-terminated.
    // See: https://en.cppreference.com/cpp/string/basic_string/data
    const char* chars = s.data();

    int year = readN(chars, 4);
    char hyphen_YM = chars[4];
    int month = readN(chars + 5, 2);
    char hyphen_MD = chars[7];
    int day = readN(chars + 8, 2);

    if (hyphen_YM != '-' || hyphen_MD != '-')
    {
      clicks = NA_INTEGER;
    }
    else
    {
      double dayFraction = 0.0;
      bool isValid;
      if (size < 12)
      {
        isValid = true; // "YYYY-MM-DD"
      }
      else
      {
        if (chars[10] != '.')
        {
          isValid = false; // "YYYY-MM-DD.0###"
        }
        else
        {
          isValid = true;
          for(int i = (int)(size - 1); i > 10; --i)
          {
            char c = chars[i];
            int digit = c - '0';
            if (digit < 0 || digit > 9)
            {
              isValid = false;
              break;
            }
            dayFraction = dayFraction / 10.0 + (double)digit;
          }

          dayFraction /= 10.0;
        }
      }

      clicks = isValid ? dateyFromYMDF(year, month, day, dayFraction, strict) : NA_INTEGER;
    }
  }

  if (strict && clicks == NA_INTEGER)
  {
    const char *msg = blankIsNA
    ? "Invalid datey text. Should be \"\" or \"YYYY-MM-DD[.FFF]\", where \"[.FFF]\" is optional fraction with at least 1 digit."
    : "Invalid datey text. Should be \"YYYY-MM-DD[.FFF]\", where \"[.FFF]\" is optional fraction with at least 1 digit."
    ;
    cpp11::stop(msg);
  }

  return clicks;
}

int dateyFromRStringAndDayFraction(cpp11::r_string rString, double dayFraction, bool blankIsNA, bool strict)
{
  if (cpp11::is_na(rString) || cpp11::is_na(dayFraction)) { return NA_INTEGER; }

  std::string s = (std::string)rString;

  auto size = s.size();

  if (blankIsNA && size == 0) { return NA_INTEGER; }

  int clicks;

  // "YYYY-MM-DD" = exactly 10 chars
  if (size != 10)
  {
    clicks = NA_INTEGER;
  }
  else
  {
    const char* chars = s.data();

    int year = readN(chars, 4);
    char hyphen_YM = chars[4];
    int month = readN(chars + 5, 2);
    char hyphen_MD = chars[7];
    int day = readN(chars + 8, 2);

    if (hyphen_YM != '-' || hyphen_MD != '-')
    {
      clicks = NA_INTEGER;
    }
    else
    {
      clicks = dateyFromYMDF(year, month, day, dayFraction, strict);
    }
  }

  if (strict && clicks == NA_INTEGER)
  {
    const char *msg = blankIsNA
      ? "Invalid datey text. Should be \"YYYY-MM-DD\" or \"\"."
      : "Invalid datey text. Should be \"YYYY-MM-DD\"."
      ;
    cpp11::stop(msg);
  }

  return clicks;
}
