#include "datey.h"
//#include <math.h>

constexpr int DaysToStartByMonth365[13] = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 };
constexpr int DaysToStartByMonth366[13] = { 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 };

bool isLeapYear(int year)
{
  if ((year & 3) != 0) { return false; }
  if ((year & 15) == 0) { return true; }
  return year % 25 != 0;
}

bool isValidDatey(int datey)
{
  return datey >= ValidClicksStart && datey < ValidClicksEnd;
}

bool isValidYear(int year)
{
  return year >= ValidYearsStart && year < ValidYearsEnd;
}

bool isValidMonth(int month)
{
  return month >= 1 && month <= 12;
}

int dateyFromYMDF(int year, int month, int day, double dayFraction)
{
  // Assume NA_INTEGER is not in any of these ranges
  if (!isValidYear(year)
    || !isValidMonth(month)
    || day < 1
    || !(dayFraction >= 0.0 && dayFraction <= 1.0) // NaN!
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
  if (dayLess1 < 0 || dayLess1 >= daysToEndOfMonth - daysToStartOfMonth)
  {
    return NA_INTEGER;
  }

  int dayCount = daysToStartOfMonth + dayLess1;
  double clicksInYear = (dayCount + dayFraction) * clicksPerDay;
  return year * ClicksPerYear + (int)roundBankers(clicksInYear);
}

std::tuple<int, int, int, double> dateyToYMDF(int datey)
{
  if (!isValidDatey(datey))
  {
    return std::make_tuple(NA_INTEGER, NA_INTEGER, NA_INTEGER, NA_REAL);
  }

  int year = datey / ClicksPerYear;
  int clicksRemaining = datey - year * ClicksPerYear;

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

  int wholeDaysFromStartOfYear = clicksRemaining / clicksInOneDay;
  clicksRemaining -= wholeDaysFromStartOfYear * clicksInOneDay;

  for (int monthLess1 = 11; ; --monthLess1)
  {
    int daysToStartOfMonth = daysToStartByMonth[monthLess1];
    if (wholeDaysFromStartOfYear >= daysToStartOfMonth)
    {
      int day = wholeDaysFromStartOfYear - daysToStartOfMonth + 1;
      int month = monthLess1 + 1;
      double dayFraction = clicksRemaining / (double)clicksInOneDay;
      return std::make_tuple(year, month, day, dayFraction);
    }
  }

  // This is unreachable.
  return std::make_tuple(NA_INTEGER, NA_INTEGER, NA_INTEGER, NA_REAL);
}

int dateyFromRDate(double rDate, double dayFraction)
{
  const double rDate_1000_01_01 = -354285.0;
  const double rDate_3000_01_01 = 376200.0;
  const int JulianDay_1970_01_01 = 719162;

  // Following allows for NA and NaNs:
  if (!(rDate>= rDate_1000_01_01 && rDate < rDate_3000_01_01)
    || !(dayFraction >= 0.0 && dayFraction <= 1.0))
  {
    return NA_INTEGER;
  }

  // `Date` does not report fractional dates
  //  It uses the floor, e.g
  //    -0.5 is "1969-12-31"
  //    +0.5 is "1970-01-01"
  //
  // The safe course of action is to treat non-integral
  // values as invalid.
  //
  // NB (int) rounds to 0.

  double rounded = std::nearbyint(rDate);
  if (rounded != rDate)
  {
    return NA_INTEGER;
  }

  int julianDay = (int)rounded + JulianDay_1970_01_01;
  int year = yearFromJulianDay(julianDay);

  int clicksPerDay;
  if (isLeapYear(year))
  {
    clicksPerDay = ClicksPerDay366;
  }
  else
  {
    clicksPerDay = ClicksPerDay365;
  }

  int daysFromStartOfYear = julianDay - firstJulianDayOfYear(year);

  int clicksFromStartOfDay = (int)roundBankers(dayFraction * clicksPerDay);

  return year * ClicksPerYear
    + daysFromStartOfYear * clicksPerDay
    + clicksFromStartOfDay;
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

static const cpp11::r_string text_NA = "NA";

// Simpler to implement explicitly
static void writeN(int value, char *buffer, int n)
{
  for (char *p = buffer + (n - 1); p >= buffer; --p)
  {
    int value_div_10 = value / 10;
    int digit = value - value_div_10 * 10;
    *p = (char)('0' + digit);
    value = value_div_10;
  }
}
static int readN(const char *chars, int n)
{
  int value = 0;
  for (int i = 0; i < n; ++i)
  {
    char c = chars[i];
    if (c == 0) { return -1; }
    int digit = c - '0';
    if (digit > 9 || digit < 0) { return -1; }
    value = value * 10 + digit;
  }
  return value;
}

cpp11::r_string dateyToRString(int datey)
{
  if (!isValidDatey(datey)) { return text_NA; }

  // 4 digits distinguishes between values
  // 16 chars captures max text plus 0 terminator
  // YYYY-MM-DD.0###\0
  char chars[16];

  auto ymdf = dateyToYMDF(datey);

  writeN(std::get<0>(ymdf), chars, 4);
  chars[4] = '-';
  writeN(std::get<1>(ymdf), chars + 5, 2);
  chars[7] = '-';
  writeN(std::get<2>(ymdf), chars + 8, 2);
  chars[10] = '.';

  int f_times_10000 = (int)roundBankers(std::get<3>(ymdf) * 10000.0);

  writeN(f_times_10000, chars + 11, 4);

  char *p = chars + 15;
  *p = '\0';

  // Leave at least one trailing '0'
  for (int i = 2; i >= 0; --i)
  {
    --p;
    if (*p != '0') { break; }
    *p = '\0';
  }

  return cpp11::r_string(chars);
}

int dateyFromRStringOnly(cpp11::r_string rString)
{
  std::string s = (std::string)rString;

  size_t size = s.size();

  // "YYYY-MM-DD.0###" = min 12 chars
  if (size < 12 || size > 100) { return NA_INTEGER; }

  // `data()` is null terminated as of C++11.
  // https://en.cppreference.com/cpp/string/basic_string/data
  const char* chars = s.data();

  int year = readN(chars, 4);
  char hyphen_YM = chars[4];
  int month = readN(chars + 5, 2);
  char hyphen_MD = chars[7];
  int day = readN(chars + 8, 2);
  char point = chars[10];

  if (hyphen_YM != '-' || hyphen_MD != '-' || point != '.')
  {
    return NA_INTEGER;
  }

  double dayFraction = 0.0;

  for(int i = (int)(size - 1); i > 10; --i)
  {
    char c = chars[i];
    int digit = c - '0';
    if (digit > 9 || digit < 0) { return NA_INTEGER; }
    dayFraction = dayFraction / 10.0 + (double)digit;
  }

  dayFraction /= 10.0;

  return dateyFromYMDF(year, month, day, dayFraction);
}

int dateyFromRStringAndDayFraction(cpp11::r_string rString, double dayFraction)
{
  std::string s = (std::string)rString;

  size_t size = s.size();

  // "YYYY-MM-DD" = exactly 10 chars
  if (size != 10) { return NA_INTEGER; }

  const char* chars = s.data();

  int year = readN(chars, 4);
  char hyphen_YM = chars[4];
  int month = readN(chars + 5, 2);
  char hyphen_MD = chars[7];
  int day = readN(chars + 8, 2);

  if (hyphen_YM != '-' || hyphen_MD != '-')
  {
    return NA_INTEGER;
  }

  return dateyFromYMDF(year, month, day, dayFraction);
}
