# Parse text as a `datey`

If `day_fraction` *is* provided then the text must be in ISO 8601
extended format, i.e. "YYYY-MM-DD".

If `day_fraction` is *not* provided then the text must be formatted as
"YYYY-MM-DD.FFF", where ".FFF" is the optional day fraction. This means
that e.g. "2000-01-01" represents the *start* of 1 January 2000.

If `blank_is_NA` is `TRUE` then blanks are treated as `NA`.

If `strict` is `TRUE` (which is the default) then non-compliant text
will stop execution.

The lengths of vector arguments must be multiples of each other.

## Usage

``` r
# S3 method for class 'character'
as_datey(x, day_fraction = NULL, strict = TRUE, blank_is_NA = FALSE, ...)
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
  greater than or equal to 3000) should be handled.

  - If `strict` is `TRUE` then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned. Defaults to `TRUE`.

- blank_is_NA:

  Whether blanks should be treated as `NA`. Defaults to `FALSE`.

- ...:

  Other arguments (not used in this package).
