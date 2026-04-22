#include <cpp11.hpp>
//#include <math.h>
#include "datey.h"

constexpr int DaysToStartByMonth365[13] = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 };
constexpr int DaysToStartByMonth366[13] = { 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 };

bool isLeapYear(int year)
{
  if ((year & 3) != 0) { return false; }
  if ((year & 15) == 0) { return true; }
  return year % 25 != 0;
}

bool isValidYear(int year)
{
  return (uint)(year - ValidYearsStart) < (uint)(ValidYearsEnd - ValidYearsStart);
}

bool isValidMonth(int month)
{
  return (uint)(month - 1) < (uint)12;
}

int clicksFromYMDF(int year, int month, int day, double dayFraction)
{
  // Assume NA_INTEGER is not in any of these ranges
  if (!isValidYear(year)
        || !isValidMonth(month)
        || day < 1
        || !(dayFraction >= 0.0 && dayFraction < 1.0) // NaN!
  )
  {
    return NA_INTEGER;
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
  if ((uint)dayLess1 >= (uint)(daysToEndOfMonth - daysToStartOfMonth))
  {
    return NA_INTEGER;
  }

  int dayCount = daysToStartOfMonth + dayLess1;
  double clicksInYear = (dayCount + dayFraction) * clicksPerDay;
  return year * ClicksPerYear + (int)roundBankers(clicksInYear);
}

std::tuple<int, int, int, double> clicksToYMDF(int clicks)
{
  if ((uint)(clicks - ValidClicksStart) >= (uint)(ValidClicksEnd - ValidClicksStart))
  {
    return std::make_tuple(NA_INTEGER, NA_INTEGER, NA_INTEGER, NA_REAL);
  }

  int year = clicks / ClicksPerYear;
  clicks -= year * ClicksPerYear;

  int clicksInOneDay;
  int const *daysToStartByMonth;
  if (isLeapYear(year))
  {
    clicksInOneDay = ClicksPerDay366;
    daysToStartByMonth = DaysToStartByMonth366;
  }
  else
  {
    clicksInOneDay = ClicksPerDay365;
    daysToStartByMonth = DaysToStartByMonth365;
  }

  int wholeDaysFromStartOfYear = clicks / clicksInOneDay;
  clicks -= wholeDaysFromStartOfYear * clicksInOneDay;

  for (int monthLess1 = 11; ; --monthLess1)
  {
    int daysToStartOfMonth = daysToStartByMonth[monthLess1];
    if (wholeDaysFromStartOfYear >= daysToStartOfMonth)
    {
      int day = wholeDaysFromStartOfYear - daysToStartOfMonth + 1;
      int month = monthLess1 + 1;
      double dayFraction = clicks / (double)clicksInOneDay;
      return std::make_tuple(year, month, day, dayFraction);
    }
  }

  // This is unreachable.
  return std::make_tuple(NA_INTEGER, NA_INTEGER, NA_INTEGER, NA_REAL);
}

