#include <math.h>
#include "datey.h"

//double roundBankers(double x)
//{
//  // Operation depends on current rounding mode
//  // https://en.cppreference.com/cpp/numeric/math/nearbyint
//  return std::nearbyint(x);
//}

double roundBankers(double x)
{
  // Needs to work only for |x| < 2^31

  double trunc_x = std::trunc(x);

  //abs_f=ABS(x-trunc_x)
  double abs_f = std::abs(x - trunc_x);

  //=IF(abs_f<0.5,trunc_x,IF(abs_f>0.5,trunc_x+SIGN(x),trunc_x+fmod_trunc_x_2))
  if (abs_f < 0.5) { return trunc_x; }
  if (abs_f > 0.5) { return trunc_x + std::copysign(1.0, x); }
  return trunc_x + std::fmod(trunc_x, 2.0);
}

