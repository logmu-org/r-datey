#ifndef INCLUDED_DATEY
#define INCLUDED_DATEY

#include <tuple>
#include <cpp11.hpp>

const int ValidYearsStart = 1000;
const int ValidYearsEnd = 3000;
const int ValidYearsDuration = 2000;

const int ClicksPerYear = 534'360;
const int ClicksPerHalfYear = ClicksPerYear / 2;
const int ClicksPerDay366 = ClicksPerYear / 366;
const int ClicksPerDay365 = ClicksPerYear / 365;

const double YearsPerClick = 1.0 / (double)ClicksPerYear;

const int ValidClicksStart = ClicksPerYear * ValidYearsStart;
const int ValidClicksEnd = ClicksPerYear * ValidYearsEnd;
const int ValidClicksDuration = ClicksPerYear * ValidYearsDuration;

// math.cpp
double roundBankers(double x);

// date_functions.cpp
bool isLeapYear(int year);
bool isValidDatey(int datey);
bool isValidYear(int year);
bool isValidMonth(int month);
int dateyFromYMDF(int year, int month, int day, double dayFraction);
std::tuple<int, int, int, double> dateyToYMDF(int datey);
int dateyFromRDate(double rDate, double dayFraction);
int yearFromJulianDay(int julianDay);
int firstJulianDayOfYear(int year);
cpp11::r_string dateyToRString(int datey);
int dateyFromRStringOnly(cpp11::r_string rString);
int dateyFromRStringAndDayFraction(cpp11::r_string rString, double dayFraction);
#endif
