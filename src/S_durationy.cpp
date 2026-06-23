// Date and duration arithmetic on an annual grid for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.h"
#include <math.h>

bool isValidDurationy(int clicks)
{
  // Don't use abs() -- NA_INTEGER is pathological case
  return clicks >= -ValidDurationMaxClicks && clicks <= ValidDurationMaxClicks;
}

bool isValidDurationYears(int years)
{
  // Don't use abs() -- NA_INTEGER is pathological case
  return years >= -ValidDurationMaxYears && years <= ValidDurationMaxYears;
}
bool isValidDurationYears(double years)
{
  return std::abs(years) <= ValidDurationMaxYears;
}

int durationyFromYears(int years, bool strict)
{
  if (!isValidDurationYears(years))
  {
    if (cpp11::is_na(years))
    {
      return NA_INTEGER;
    }

    if (strict)
    {
      cpp11::stop("Years cannot be more than 2000.");
    }

    return NA_INTEGER;
  }

  return years * ClicksPerYear;
}
int durationyFromYears(double years, bool strict)
{
  if (!isValidDurationYears(years))
  {
    if (cpp11::is_na(years))
    {
      return NA_INTEGER;
    }

    if (strict)
    {
      cpp11::stop("Years cannot be more than 2000.");
    }

    return NA_INTEGER;
  }

  return years * ClicksPerYear;
}

double durationyToYears(int clicks)
{
  if (!isValidDurationy(clicks))
  {
    return NA_REAL;
  }

  return clicks / (double)ClicksPerYear;
}

cpp11::r_string durationyToRString(
  int clicks,
  bool includePlusSign,
  bool useTrueMinusSign,
  std::string yearUnit
)
{
  if (!isValidDurationy(clicks)) { return NA_STRING; }

  // "SYYYY.FFFFFF UUUUUUUUUUUUUUUUUUUU"
  // Max char count =
  // + 3 <- for sign, noting that true minus sign (U+2212) is 3 UTF-8 chars 0xE2 0x88 0x92
  // + 4 <- "YYYY"
  // + 7 <- ".FFFFFF" 1 / 534360 = 0.0000019 so we need 6 decimal digits
  // + 21 <- " " + "UUUUUUUUUUUUUUUUUUUU" -- we limit unit text to 20 UTF-8 chars
  // + 1 <- '\0'
  // = 36
  char chars[3 + 4 + 7 + 1 + MaxYearUnitLength + 1];

  char *p = chars;

  if (clicks > 0)
  {
    if (includePlusSign)
    {
      *p++ = '+';
    }
  }
  else if(clicks < 0)
  {
    clicks = -clicks;

    if (useTrueMinusSign)
    {
      *p++ = '\xE2';
      *p++ = '\x88';
      *p++ = '\x92';
    }
    else
    {
      *p++ = '-';
    }
  }

  int int_part = clicks / ClicksPerYear;
  int fractional_part = clicks - int_part * ClicksPerYear;

  if (int_part == 0)
  {
    *p++ = '0';
  }
  else
  {
    int n;
    if (int_part <= 9) { n = 1; }
    else if (int_part <= 99) { n = 2; }
    else if (int_part <= 999) { n = 3; }
    else { n = 4; }
    writeN(int_part, p, n);
    p += n;
  }

  if (fractional_part != 0)
  {
    *p++ = '.';

    // Explicit rounding to nearest 1 / 534360 = 0.000002
    // means we can be relatively relaxed here
    const double Multiplier = 1000000.0 / (double)ClicksPerYear;
    int f_times_1000000 = (int)roundBankers(fractional_part * Multiplier);

    writeN(f_times_1000000, p, 6);

    p += 6;
    // We don't have to check the '0' after '.'
    for (int i = 0; i < 5; ++i)
    {
      if (p[-1] != '0') { break; }
      --p;
    }
  }

  if (yearUnit.size() != 0)
  {
    *p++ = ' ';
    for (const char& u : yearUnit) { *p++ = u; }
  }

  *p = '\0';

  return cpp11::r_string(chars);
}

int durationyFromRString(cpp11::r_string rString, bool strict, bool blankIsNA, std::string yearUnit)
{
  if (cpp11::is_na(rString)) { return NA_INTEGER; }

  // [sign][max 4 digits]['.'fraction][space+unit]
  std::string s = static_cast<std::string>(rString);

  auto size = s.size();

  if (size == 0)
  {
    if (blankIsNA) { return NA_INTEGER; }
    cpp11::stop("Blank durationy text (and blank_is_NA is FALSE).");
  }

  int clicks = NA_INTEGER;
  const char *failReason = nullptr;

  if (size > 100)
  {
    failReason = "Text is too long.";
  }
  else
  {
    // As of C++11, `data()` is guaranteed to be null-terminated.
    // See: https://en.cppreference.com/cpp/string/basic_string/data
    const char* p = s.data();

    // 1. Handle sign
    bool isNegative = false;
    char c = *p;
    if (c == '+')
    {
      ++p;
      c = *p;
    }
    else if (c == '-')
    {
      isNegative = true;
      ++p;
      c = *p;
    }
    else if (c == '\xE2' && p[1] == '\x88' && p[2] == '\x92')
    {
      isNegative = true;
      p += 3;
      c = *p;
    }

    // 2. Handle 1 to 4 year digits
    if (!isDigit(c))
    {
      failReason = "Missing year digit.";
    }
    else
    {
      int n;
      if (!isDigit(p[1])) { n = 1; }
      else if (!isDigit(p[2])) { n = 2; }
      else if (!isDigit(p[3])) { n = 3; }
      else { n = 4; }
      int years = readN(p, n);
      p += n;
      // Need to check here to avoid integer overflow because
      // 9999 * 534360 > 2^31 - 1
      if (years <= ValidDurationMaxYears)
      {
        clicks = years * ClicksPerYear;
      }
      else
      {
        failReason = "Cannot be more than 2000 years.";
      }
    }

    // 3. Error if too many non-fractional digits
    if (clicks != NA_INTEGER && isDigit(*p))
    {
      clicks = NA_INTEGER;
      failReason = "Cannot be more than 2000 years.";
    }


    // 4. Handle year fraction ".FFFF"
    if (clicks != NA_INTEGER && *p =='.')
    {
      ++p;
      if (!isDigit(*p))
      {
        clicks = NA_INTEGER;
        failReason = "Missing digit after decimal point ('.').";
      }
      else
      {
        // Read the fraction backwards
        int n = 1;
        while(isDigit(p[n])) { ++n; }
        double yearFraction = 0.0;
        for (int i = n - 1; i >= 0; --i)
        {
          yearFraction = yearFraction / 10.0 + (double)(p[i] - '0');
        }

        yearFraction /= 10.0;
        clicks += (int)roundBankers(yearFraction * ClicksPerYear);
        if (clicks > ValidDurationMaxClicks)
        {
          clicks = NA_INTEGER;
          failReason = "Cannot be more than 2000 years.";
        }
        p += n;
      }
  }

    // 5. Handle unit
    if (clicks != NA_INTEGER && yearUnit.size() != 0)
    {
      if (*p != ' ')
      {
        clicks = NA_INTEGER;
        failReason = "Space missing between amount and year unit.";
      }
      else
      {
        ++p;
        if (yearUnit.compare(p) == 0)
        {
          p += yearUnit.size();
        }
        else
        {
          clicks = NA_INTEGER;
          failReason = "Missing or mismatched year unit.";
        }
      }
    }

    // 6. Check we've reached the end of the string
    if (clicks != NA_INTEGER && *p != '\0')
    {
      clicks = NA_INTEGER;
      failReason = "Unrecognised character.";
    }
    else
    {
      if (isNegative) { clicks = -clicks; }
    }
  }

  if (strict && clicks == NA_INTEGER)
  {
    std::string msg = "Invalid durationy text. "; // Space is for concatenation!
    msg += failReason;
    cpp11::stop(msg);
  }

  return clicks;
}

