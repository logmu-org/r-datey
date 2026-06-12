#pragma once

#include <tuple>
#include <cpp11.hpp>

const int ValidDateStartYear = 1000;
const int ValidDateEndYear = 3000;
const int ValidDurationMaxYears = 2000;

const int ClicksPerYear = 534360;
const int ClicksPerHalfYear = ClicksPerYear / 2;
const int ClicksPerDay366 = ClicksPerYear / 366;
const int ClicksPerDay365 = ClicksPerYear / 365;

const double YearsPerClick = 1.0 / (double)ClicksPerYear;

const int ValidDateStartClicks = ClicksPerYear * ValidDateStartYear;
const int ValidDateEndClicks = ClicksPerYear * ValidDateEndYear;
const int ValidDurationMaxClicks = ClicksPerYear * ValidDurationMaxYears;

const std::string::size_type MaxYearUnitLength = 20;

// The NaN chosen by the R Core Team to represent NA is an internal
// implementation detail and so we've had to hard code it here.
// If the representation changes then the *sole* consequence of this hard-coding
// is that a `datey_interval` will no longer be NA if it drops its class.
const uint64_t NA_REAL_uint64 = 0x7ff00000000007a2ULL;
const uint64_t DateyIntervalMask = NA_REAL_uint64 ^ (
  (
      static_cast<uint64_t>(static_cast<uint32_t>(NA_INTEGER)) << 32)
    | static_cast<uint64_t>(static_cast<uint32_t>(NA_INTEGER))
  );

// math.cpp
double roundBankers(double x);
bool tryConvertToSafeInteger(double x, int& int_x);

// text.cpp
bool isDigit(int c);
void writeN(int value, char *buffer, int n);
int readN(const char *chars, int n);

// S_datey.cpp
bool isValidDatey(int clicks);
bool isValidYear(int year);
bool isValidMonth(int month);
bool isValidDayFraction(double dayFraction);
bool isLeapYear(int year);
int dateyFromYMDF(int year, int month, int day, double dayFraction, bool strict);
std::tuple<int, int, int, double> dateyToYMDF(int datey);
int dateyWithNewDayFraction(int datey, double dayFraction, bool strict);
int dateyFromRDate(double rDate, bool strict);
int dateyFromRDateAndDayFraction(double rDate, double dayFraction, bool strict);
int yearFromJulianDay(int julianDay);
int firstJulianDayOfYear(int year);
// The following leaves pChars pointing to `trailing `\0` end byte
void writeValidDatey(int datey, bool includeDayFraction, char*& pChars);
cpp11::r_string dateyToRString(int datey, bool includeDayFraction);
int dateyFromRStringOnly(cpp11::r_string rString, bool blank_is_NA, bool strict);
int dateyFromRStringAndDayFraction(cpp11::r_string rString, double dayFraction, bool blank_is_NA, bool strict);

// S_durationy.cpp
bool isValidDurationy(int clicks);
cpp11::r_string durationyToRString(int durationy, bool includePlusSign, bool useTrueMinusSign, std::string yearUnit);
int durationyFromRString(cpp11::r_string rString, bool strict, bool blankIsNA, std::string yearUnit);

// S_datey_interval.cpp

inline double getDoubleFromStartEnd(int start, int end)
{
  uint64_t bits = (static_cast<uint64_t>(static_cast<uint32_t>(start)) << 32) | static_cast<uint64_t>(static_cast<uint32_t>(end));
  bits ^= DateyIntervalMask;
  // std::bit_cast unavailable until C++20.
  // C++11 standard is to use std::memcpy, which should be optimised away by the compiler.
  double punned;
  std::memcpy(&punned, &bits, sizeof(bits));
  return punned;
}
inline std::tuple<int, int> getStartEndFromDouble(double punnedDouble)
{
  // std::bit_cast unavailable until C++20.
  // C++11 standard is to use std::memcpy, which should be optimised away by the compiler.
  uint64_t bits;
  std::memcpy(&bits, &punnedDouble, sizeof(punnedDouble));
  bits ^= DateyIntervalMask;
  auto start = static_cast<int>(static_cast<uint32_t>(bits >> 32));
  auto end = static_cast<int>(static_cast<uint32_t>(bits));
  return std::make_tuple(start, end);
}

inline bool isProperDateyInterval(double punnedDouble)
{
  auto x = getStartEndFromDouble(punnedDouble);
  int start = std::get<0>(x);
  int end = std::get<1>(x);
  return isValidDatey(start) && isValidDatey(end) && start <= end;
}
inline bool isCollapsedDateyInterval(double punnedDouble)
{
  auto x = getStartEndFromDouble(punnedDouble);
  int start = std::get<0>(x);
  int end = std::get<1>(x);
  return !isValidDatey(start) || !isValidDatey(end) || start >= end;
}

double dateyInterval(int start, int end, bool strict);
cpp11::r_string dateyIntervalToRString(double dateyInterval, bool includeDayFraction);
