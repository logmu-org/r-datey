# Convert an object to a `datey`

This is an S3 generic. This package provides methods for the following
classes:

- `double` and `integer` – the value is interpreted as the specified
  calendar year, with the fractional part representing the fraction of
  the year. For instance, `as_datey(2000.5)` means halfway though the
  year 2000. (`integer` means the *start* of the calendar year, e.g.
  `as_datey(2000L)` means the start of the year 2000.

- `datey`, `Date` and `POSIXct` and `POSIXlt` are interpreted as
  fractional years. If no `day_fraction` argument is provided then the
  day fraction is determined by the hours, minutes, and seconds. For
  instance, `as_datey(as.POSIXct("2000-03-21 12:00"))` means the
  *middle* of 2000-03-21. Note that in standard use, a `Date` has no
  fractional part and therefore means the *start* of the day. For
  instance, `as_datey(as.Date("2000-03-21 12:00"))` means the *start* of
  2000-03-21.

- `character` – If `day_fraction` *is* provided then the text format
  must be in ISO 8601 extended format, i.e. YYYY-MM-DD. If
  `day_fraction` *is* provided then the text format must be
  YYYY-MM-DD.FFF, where .FFF is the day fraction and must be present
  even if the fraction is 0, e.g. "2000-01-01.0" for the start of 1
  January 2000.

The lengths of vector arguments must be multiples of each other.

## Usage

``` r
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

# Default S3 method
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'datey'
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'integer'
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'double'
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'Date'
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'POSIXct'
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

# S3 method for class 'POSIXlt'
as_datey(x, day_fraction = NULL, strict = TRUE, ...)

as_start_day(x, ...)

as_mid_day(x, ...)

as_end_day(x, ...)
```

## Arguments

- x:

  A vector of the S3 class.

- day_fraction:

  The `day_fraction` override. Defaults to `NULL`.

  - If `day_fraction` is *not* provided then `x` is used to derive both
    the calendar year, month, day *and* the day fraction.

  - If `day_fraction` *is* provided then `x` is used solely to derive
    the calendar year, month and day, while `day_fraction` provides the
    position in the day. `day_fraction` must lie in the inclusive
    interval \[0,1\], with

  - 0 meaning the start of the day,

  - 0.5 meaning the middle of the day, and

  - 1 meaning the end of the day (which is identical to the start of the
    next day).

- strict:

  How calendar years less than 1000 or greater than or equal to 3000 and
  day fractions not in the interval \[0,1\] should be handled.

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

  (NAs will result in NA regardless of this switch.)

- ...:

  Other arguments (not used in this package).
