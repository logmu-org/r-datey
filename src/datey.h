#ifndef INCLUDED_DATEY
#define INCLUDED_DATEY

#include <tuple>
#include <cpp11.hpp>

const int ValidDateStartYear = 1000;
const int ValidDateEndYear = 3000;
const int ValidDurationYears = 2000;

const int ClicksPerYear = 534'360;
const int ClicksPerHalfYear = ClicksPerYear / 2;
const int ClicksPerDay366 = ClicksPerYear / 366;
const int ClicksPerDay365 = ClicksPerYear / 365;

const double YearsPerClick = 1.0 / (double)ClicksPerYear;

const int ValidDateStartClicks = ClicksPerYear * ValidDateStartYear;
const int ValidDateEndClicks = ClicksPerYear * ValidDateEndYear;
const int ValidDurationClicks = ClicksPerYear * ValidDurationYears;

// math.cpp
double roundBankers(double x);

// date_functions.cpp
bool isLeapYear(int year);
bool isValidDatey(int datey);
bool isValidYear(int year);
bool isValidMonth(int month);
bool isValidDayFraction(double dayFraction);
int dateyFromYMDF(int year, int month, int day, double dayFraction);
std::tuple<int, int, int, double> dateyToYMDF(int datey);
int dateyWithNewDayFraction(int datey, double dayFraction);
int dateyFromRDate(double rDate);
int dateyFromRDateAndDayFraction(double rDate, double dayFraction);
int yearFromJulianDay(int julianDay);
int firstJulianDayOfYear(int year);
cpp11::r_string dateyToRString(int datey, bool includeDayFraction);
int dateyFromRStringOnly(cpp11::r_string rString);
int dateyFromRStringAndDayFraction(cpp11::r_string rString, double dayFraction);
#endif
