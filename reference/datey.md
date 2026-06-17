# Create a `datey` from a calendar year (including its fractional part) or another date type

This package provides methods to create a `datey` from the following:

- `double` and `integer` are interpreted as the specified calendar year,
  with the fractional part representing the fraction of the year. For
  instance, `datey(2000.5)` means halfway through the year 2000. (This
  means that an `integer` argument always indicates the *start* of the
  calendar year, e.g. `datey(2000L)` is the start of the year 2000.)

- `Date` and `POSIXct` and `POSIXlt` are interpreted as fractional
  years. If no `day_fraction` argument is provided then the day fraction
  is determined by the hours, minutes, and seconds. For instance,
  `datey(as.POSIXct("2000-03-21 12:00"))` means the *middle* of
  2000-03-21. Note that in standard use, a `Date` has no fractional part
  and therefore means the *start* of the day. For instance,
  `datey(as.Date("2000-03-21 12:00"))` means the *start* of 2000-03-21.

- `character` – If `day_fraction` *is* provided then the text format
  must be in ISO 8601 extended format, i.e. YYYY-MM-DD. If
  `day_fraction` is *not* provided then the text format must be
  YYYY-MM-DD.FFF, where .FFF is the day fraction and must be present
  even if the fraction is 0, e.g. "2000-01-01.0" for the start of 1
  January 2000.

- `datey` is interpreted as is but with the optional `day_fraction`
  override. Note that a `day_fraction` of 1 will add a day to a day
  boundary, *even if it was originally defined as an end day*.

The lengths of vector arguments must be multiples of each other.

This is an S3 generic.

## Usage

``` r
datey(x, day_fraction = NULL, strict = TRUE, ...)

# Default S3 method
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'datey'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'integer'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'double'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'Date'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'POSIXct'
datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'POSIXlt'
datey(x, day_fraction = NULL, strict = TRUE, ...)
```

## Arguments

- x:

  The argument to convert to a `datey`.

- day_fraction:

  The `day_fraction` override. Defaults to `NULL`.

  If `day_fraction` is *not* provided then `x` is used to derive both
  the calendar year, month, day *and* the day fraction.

  If `day_fraction` *is* provided then `x` is used solely to derive the
  calendar year, month and day, while `day_fraction` provides the
  position in the day. `day_fraction` must lie in the inclusive interval
  \[0,1\], with 0 meaning the start of the day, 0.5 meaning the middle
  of the day, and 1 meaning the end of the day (which is identical to
  the start of the next day).

- strict:

  How calendar years less than 1000 or greater than 3000 and day
  fractions not in the interval \[0,1\] should be handled. If `strict`
  is `TRUE` – the default – then execution is stopped. If `strict` is
  `FALSE` then `NA` is returned.

  NA arguments result in NA (and do not stop execution) regardless of
  `strict`.

- ...:

  Other arguments (not used in this package).

## Value

A vector of `datey`.

## See also

Use [`start_day()`](https://r-datey.logmu.org/reference/xxx_day.md),
[`mid_day()`](https://r-datey.logmu.org/reference/xxx_day.md) and
[`end_day()`](https://r-datey.logmu.org/reference/xxx_day.md) to create
a `datey` direct from year, month and day. Use
[`as_start_day()`](https://r-datey.logmu.org/reference/as_xxx_day.md),
[`as_mid_day()`](https://r-datey.logmu.org/reference/as_xxx_day.md) and
[`as_end_day()`](https://r-datey.logmu.org/reference/as_xxx_day.md) to
create a `datey` from a numeric or base R date type but specifying
whether it should be the start, middle or end of the day.

See
[text_to_datey](https://r-datey.logmu.org/reference/text_to_datey.md)
for parsing and creating `datey` text.

## Examples

``` r
datey(2000)
#> [1] 2000-01-01.0
datey(2000.5) # Middle of a leap year
#> [1] 2000-07-02.0
datey(2001.5) # Middle of a non-leap year
#> [1] 2001-07-02.5
datey(as.Date("2020-01-02"))
#> [1] 2020-01-02.0
datey(as.POSIXct("2020-01-02 12:00:00"))
#> [1] 2020-01-02.5
datey(as.POSIXlt("2020-01-02 12:00:00"))
#> [1] 2020-01-02.5

# Use `strict` to control error behaviour for invalid `datey`s:
try(datey(999.9))
#> Error : The year is invalid.
try(datey(3000.1))
#> Error : The year is invalid.
datey(999.9, strict = FALSE)
#> [1] <NA>
datey(3000.1, strict = FALSE)
#> [1] <NA>
```
