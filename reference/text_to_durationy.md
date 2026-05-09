# Parse text as a `durationy`

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
durationy(x, strict = TRUE, blank_is_NA = FALSE, year_unit = "yr", ...)
```

## Arguments

- x:

  Vector of text items to be parsed.

- strict:

  How non-compliant text (including values greater than 2000 in
  magnitude) should be handled.

  - If `strict` is `TRUE` then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned. Defaults to `TRUE`.

- blank_is_NA:

  Whether blanks should be treated as `NA`. Defaults to `FALSE`.

- year_unit:

  The year unit name to expect. If not blank then the value is expected
  to be followed by a space and this unit text. Cannot be more than 20
  characters (UTF-8 bytes) or contain control characters. Defaults to
  `"yr"`.

- ...:

  Other arguments (not used in this package).
