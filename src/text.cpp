// S3 annualised fixed precision dates and durations for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include "datey.h"

bool isDigit(int c) { return c >= '0' && c <= '9'; }

// Simpler to implement explicitly
void writeN(int value, char *buffer, int n)
{
  for (char *p = buffer + (n - 1); p >= buffer; --p)
  {
    int value_div_10 = value / 10;
    int digit = value - value_div_10 * 10;
    *p = (char)('0' + digit);
    value = value_div_10;
  }
}

int readN(const char *chars, int n)
{
  int value = 0;
  for (int i = 0; i < n; ++i)
  {
    char c = chars[i];
    if (c == 0) { return -1; }
    if (!isDigit(c)) { return -1; }
    value = value * 10 + c - '0';
  }
  return value;
}
