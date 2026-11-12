# Create a `datey`

To create a `datey` use one of the following:

- `start_day()` and `end_day()` are the points in time at the *start*
  and *end* of the day respectively.

- `mid_day()` is the the *middle* of the day, commonly used to represent
  a point in time *during* the day.

- `datey()` is the underlying S3 generic function. `start_day()`,
  `mid_day()` and `end_day()` call through to `datey` with an explicit
  `day_fraction` or `0`, `0.5` and `1` respectively.

The generic types are as follows:

- `double` and `integer`. These are interpreted as calendar year,
  optionally with a fractional part in the case of `double`.

  Valid years are from 1000 to 3000 (although the only legal date in
  3000 is the start of 3000-01-01).

  Either

  (a) `month` and `day` (and for `datey()`, `day_fraction`) parameters
  are all provided, in which case `x` must be integral, or

  (b) none of those parameters are provided, in which case `x` is
  interpreted as a fractional calendar year and rounded to the nearest 1
  / 534 360 of a year (Banker's rounding). This unit is called a *click*
  and is the resolution of all **datey** arithmetic. For instance,
  `datey(2000.5)` means halfway through the year 2000.

- `Date`. This base R date type is interpreted strictly. (It is possible
  to end up with an unintentionally fractional underlying value, e.g. by
  taking a mean of `Date`s.) A `day_fraction` argument is always
  required.

- `POSIXct` and `POSIXlt`. How these base R date-time types are
  interpreted depends on whether a `day_fraction` is provided.

  If `day_fraction` *is* provided then these are interpreted strictly
  using the date component only – the time component is ignored
  completely.

  If `day_fraction` is *not* provided then the day fraction is
  determined using the hours, minutes, and seconds. For instance,
  `datey(as.POSIXct("2000-03-21 12:00"))` means the *middle* of
  2000-03-21.

- `character`. How text is parsed depends on whether a `day_fraction` is
  provided.

  If `day_fraction` *is* provided then the text must be in ISO 8601
  extended format, i.e. `YYYY-MM-DD`.

  If `day_fraction` is *not* provided then the text must be formatted as
  `YYYY-MM-DD[.F..].`, where `[.F...]` is the optional day fraction.
  This means that e.g. `"2000-01-01"` represents the *start* of 1
  January 2000.

  If `blank_is_NA` is `TRUE` then blanks are treated as `NA` (regardless
  of `strict`).

- `datey`. This is interpreted as is but with the optional
  `day_fraction` override. Note that a `day_fraction` of 1 will add a
  day to a day boundary, *even if it was originally defined as an end
  day*.

The lengths of vector arguments must be multiples of each other.

Beware that `end_day()` will add a day to a `datey` that is already on a
day boundary, *even if it was originally defined as an end day*.

There is no `is_end_day()` predicate: end days are stored identically to
the start of the following day, so
[`is_start_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md) is
the correct test.

NA arguments *of the appropriate type* result in `NA_datey_` – they do
not stop execution (regardless of `strict`). Note that `NA` is `logical`
and therefore it *will* cause an error.

## Usage

``` r
datey(x, ...)

# Default S3 method
datey(x, ...)

# S3 method for class 'datey'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'integer'
datey(x, month = NULL, day = NULL, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'double'
datey(x, month = NULL, day = NULL, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'Date'
datey(x, day_fraction, strict = TRUE, ...)

# S3 method for class 'POSIXct'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'POSIXlt'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'character'
datey(x, day_fraction = NULL, strict = TRUE, blank_is_NA = FALSE, ...)

start_day(x, month = NULL, day = NULL, strict = TRUE, blank_is_NA = FALSE)

mid_day(x, month = NULL, day = NULL, strict = TRUE, blank_is_NA = FALSE)

end_day(x, month = NULL, day = NULL, strict = TRUE, blank_is_NA = FALSE)
```

## Arguments

- x:

  The argument to convert to a `datey`.

- ...:

  Not used.

- day_fraction:

  The `day_fraction` override. Defaults to `NULL` except for the `Date`
  type, in which case it must always be provided.

  If `day_fraction` *is* provided (which is implicitly the case for
  `start_day()`, `mid_day()` and `end_day()`) then `x` is used solely to
  derive the calendar year, month and day, while `day_fraction` provides
  the position in the day. `day_fraction` must lie in the inclusive
  interval \[0,1\], with 0 meaning the start of the day, 0.5 meaning the
  middle of the day, and 1 meaning the end of the day (which is
  identical to the start of the next day). For text this means that
  there should be *no* trailing fraction, e.g.
  `start_day("2020-01-01")`.

  If `day_fraction` is *not* provided then `x` is used to derive both
  the calendar year, month, day *and* the day fraction.

- strict:

  How non-compliant *non-NA* inputs should be handled. If `strict` is
  `TRUE` – the default – then execution is stopped. If `strict` is
  `FALSE` then `NA` is returned.

- month, day:

  The month (1–12) and day (1–31). Valid only for for numeric `x`. If
  one of `month` or `day` is provided then both must be and, for
  `datey()`, `day_fraction` must also be provided.

- blank_is_NA:

  Whether "" should be treated as `NA` (regardless of `strict`). When
  `x` is `""` then if `blank_is_NA` is `TRUE` then `""` results in `NA`,
  otherwise execution is stopped. Defaults to `FALSE`. Valid only for
  for character `x`.

## Value

A vector of `datey`.

## See also

[durationy](https://r-datey.logmu.org/reference/durationy.md),
[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md),
[text_from_datey](https://r-datey.logmu.org/reference/text_from_datey.md),
[as_years_datey](https://r-datey.logmu.org/reference/as_years_datey.md),
[datey_components](https://r-datey.logmu.org/reference/datey_components.md),
[is_xxx_day](https://r-datey.logmu.org/reference/is_xxx_day.md),
[is_leap_year](https://r-datey.logmu.org/reference/is_leap_year.md),
[is_NA](https://r-datey.logmu.org/reference/is_NA.md),
[ops](https://r-datey.logmu.org/reference/ops.md),
[`vignette("why-datey", package = "datey")`](https://r-datey.logmu.org/articles/why-datey.md)
for the annual-grid design,
[`vignette("datey", package = "datey")`](https://r-datey.logmu.org/articles/datey.md)
for a worked introduction

## Examples

``` r
start_day(2001, 2, 3)
#> [1] 2001-02-03.0
mid_day(2001, 2, 3)
#> [1] 2001-02-03.5
end_day(2001, 2, 3)
#> [1] 2001-02-04.0

# Must specify month and day for a numeric if day_fraction is provided
# implicitly or explicitly:
try(start_day(2001))
#> Error : For a numeric, either all or none of `month`, `day` and `day_fraction` must be specified.
try(mid_day(2001))
#> Error : For a numeric, either all or none of `month`, `day` and `day_fraction` must be specified.
try(end_day(2001))
#> Error : For a numeric, either all or none of `month`, `day` and `day_fraction` must be specified.
try(datey(2001, day_fraction = 0))
#> Error : For a numeric, either all or none of `month`, `day` and `day_fraction` must be specified.

datey(2000) # Start of a year
#> [1] 2000-01-01.0
datey(2000.5) # Middle of a leap year
#> [1] 2000-07-02.0
datey(2001.5) # Middle of a non-leap year
#> [1] 2001-07-02.5

# Convert base R date
r_date <- as.Date("2001-02-03")
c(start_day(r_date), mid_day(r_date), end_day(r_date))
#> [1] 2001-02-03.0 2001-02-03.5 2001-02-04.0
try(datey(r_date)) # Must specify day_fraction for a `Date`
#> Error : `day_fraction` must be provided for the `Date` type.

# Convert base R datetime
c_date <- as.POSIXct("2001-02-03 12:00:00") # Midday!
c(start_day(c_date), mid_day(c_date), end_day(c_date))
#> [1] 2001-02-03.0 2001-02-03.5 2001-02-04.0
# An R datetime implies a position within a day:
datey(c_date) # 2001-02-03.5
#> [1] 2001-02-03.5

# Use `strict` to control error behaviour for invalid years:
try(end_day(0999, 12, 31))
#> [1] 1000-01-01.0
try(datey(3000.1))
#> Error : Year must be in [1000, 3000].
end_day(0999, 12, 31, strict = FALSE)
#> [1] 1000-01-01.0
datey(3000.1, strict = FALSE)
#> [1] <NA>

# NAs are passed through regardless of `strict`
# (provided they are numeric)
end_day(NA_real_, 12, 31, strict = TRUE)
#> [1] <NA>
datey(NA_real_, strict = FALSE)
#> [1] <NA>

# Text:
start_day("2001-02-03")
#> [1] 2001-02-03.0
mid_day("2001-02-03")
#> [1] 2001-02-03.5
end_day("2001-02-03")
#> [1] 2001-02-04.0
datey("2001-02-03")
#> [1] 2001-02-03.0
datey("2001-02-03.0")
#> [1] 2001-02-03.0
datey("2001-02-03", day_fraction = 0)
#> [1] 2001-02-03.0
datey("2001-02-03.5")
#> [1] 2001-02-03.5
datey("2001-02-03", day_fraction = 0.5)
#> [1] 2001-02-03.5

# Text round trips:
t <- datey(2001.234)
identical(t, datey(as.character(t))) # TRUE
#> [1] TRUE

# Day fraction cannot be present
# both in the text and as an argument
# implicitly or explicitly:
try(start_day("2001-02-03.0"))
#> Error : Invalid datey text. Should be "YYYY-MM-DD" (no fractional part).
try(datey("2001-02-03.0", day_fraction = 0))
#> Error : Invalid datey text. Should be "YYYY-MM-DD" (no fractional part).

# Handling blanks:
try(start_day(""))
#> Error : Blank datey text (and blank_is_NA is FALSE).
start_day("", blank_is_NA = TRUE)
#> [1] <NA>

# Invalids:
try(mid_day("abc"))
#> Error : Invalid datey text. Should be "YYYY-MM-DD" (no fractional part).
try(mid_day("0999-01-01"))
#> Error : `year` is outside [1000,2999] and date is not 3000-01-01.0.
end_day("abc", strict = FALSE) # NA
#> [1] <NA>
end_day("0999-01-01", strict = FALSE) # NA
#> [1] <NA>
```
