# Parse text as a `datey`

This function parses text as a `datey`.

If the text is NA then NA is returned.

If `day_fraction` *is* provided then the text must be in ISO 8601
extended format, i.e. "YYYY-MM-DD".

If `day_fraction` is *not* provided then the text must be formatted as
"YYYY-MM-DD.FFF", where ".FFF" is the optional day fraction. This means
that e.g. "2000-01-01" represents the *start* of 1 January 2000.

If `strict` is `TRUE` (which is the default) then non-compliant text
(other than blank or NA) will stop execution.

If `blank_is_NA` is `TRUE` then blanks are treated as `NA` (regardless
of `strict`).

The lengths of vector arguments `x` and `day_fraction` must be multiples
of each other.

## Usage

``` r
# S3 method for class 'character'
datey(x, day_fraction = NULL, strict = TRUE, blank_is_NA = FALSE, ...)
```

## Arguments

- x:

  Vector of text items to be parsed.

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

  How non-compliant text (including calendar years less than 1000 or
  greater than 3000) should be handled. If `strict` is `TRUE` then
  execution is stopped. If `strict` is `FALSE` then `NA` is returned.
  Defaults to `TRUE`.

- blank_is_NA:

  Whether "" should be treated as `NA`. If `blank_is_NA` is `FALSE` then
  execution is stopped (regardless of `strict`). If `blank_is_NA` is
  `TRUE` then "" results in `NA`. Defaults to `FALSE`.

- ...:

  Other arguments (not used in this package).

## Value

A vector of `datey`.

## Examples

``` r
datey("2000-01-01")
#> [1] 2000-01-01.0
datey("2000-01-01", day_fraction = 0)
#> [1] 2000-01-01.0
datey("2000-01-01.5")
#> [1] 2000-01-01.5
datey("2000-01-01", day_fraction = 0.5)
#> [1] 2000-01-01.5

# Day fraction cannot be present
# both in the text and as an argument:
try(datey("2000-01-01.0", day_fraction = 0))
#> Error : Invalid datey text. Should be "YYYY-MM-DD".

# Handling blanks:
try(datey(""))
#> Error : Blank datey text (and blank_is_NA is FALSE).
datey("", blank_is_NA = TRUE)
#> [1] <NA>

# Invalids:
try(datey("abc"))
#> Error : Invalid datey text. Should be "YYYY-MM-DD[.FFF]", where "[.FFF]" is optional fraction with at least 1 digit.
try(datey("0999-01-01"))
#> Error : `year` is outside [1000,2999] and date is not 3000-01-01.0.
datey("abc", strict = FALSE) # NA
#> [1] <NA>
datey("0999-01-01", strict = FALSE) # NA
#> [1] <NA>
```
