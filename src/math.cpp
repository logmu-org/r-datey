// S3 annualised fixed precision dates and durations for R
//
// This file is licensed to you under the MIT License.
//
// Copyright (c) Tim Gordon

#include <math.h>
#include "datey.h"

double roundBankers(double x)
{
  // Needs to work only for |x| < 2^31

  double trunc_x = std::trunc(x);

  //abs_x=ABS(x-trunc_x)
  double abs_x = std::abs(x - trunc_x);

  //=IF(abs_x<0.5,trunc_x,IF(abs_x>0.5,trunc_x+SIGN(x),trunc_x+fmod_trunc_x_2))
  if (abs_x < 0.5) { return trunc_x; }
  if (abs_x > 0.5) { return trunc_x + std::copysign(1.0, x); }
  return trunc_x + std::fmod(trunc_x, 2.0);
}

bool tryConvertToSafeInteger(double x, int& int_x)
{
  if (cpp11::is_na(x))
  {
    int_x = NA_INTEGER;
  }
  else
  {
    double rounded = std::trunc(x);
    if(!(abs(x) <= INT_MAX && x == rounded))
    {
      return false;
    }
    int_x = (int)x;
  }

  return true;
}
