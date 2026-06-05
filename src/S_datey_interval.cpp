// Date and duration arithmetic on an annual grid for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.hpp"

double dateyInterval(int start, int end, bool strict)
{
  if (!isValidDatey(start) || !isValidDatey(end))
  {
    if (strict) { cpp11::stop("`start` and/or `end` is NA"); }

    start = NA_INTEGER;
    end = NA_INTEGER;
  }

  return getDoubleFromStartEnd(start, end);
}

cpp11::r_string dateyIntervalToRString(double interval, bool includeDayFraction)
{
  auto start_end = getStartEndFromDouble(interval);
  int start = std::get<0>(start_end);
  int end = std::get<1>(start_end);
  if (!isValidDatey(start) || !isValidDatey(end)) { return NA_STRING; }

  // 4 digits distinguishes between values
  // 16 chars captures max text plus 0 terminator
  // [YYYY-MM-DD.0###, YYYY-MM-DD.0###)\0
  char chars[1 + 15 + 2 + 15 + 2];

  char* pChars = chars;

  *pChars++ = '[';
  writeValidDatey(start, includeDayFraction, pChars);
  *pChars++ = ',';
  *pChars++ = ' ';
  writeValidDatey(end, includeDayFraction, pChars);
  *pChars++ = ')';
  *pChars = '\0';

  return cpp11::r_string(chars);
}
