# Parse text as a `durationy`

This function parses text a `durationy`.

If the text is NA then NA is returned.

Valid text is of the form "DDD.DDD" or "DDD.DDD UUU" where

- "DDD.DDD" is the duration in years with "D" being decimal digits (and
  the fractional part is not required for whole years), and

- "UUU" is the unit text (which defaults to "yrs"). If blank then there
  is no space after the duration in years.

If `blank_is_NA` is `TRUE` then blanks are treated as `NA`.

If `strict` is `TRUE` (which is the default) then non-compliant text
will stop execution.

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
  magnitude) should be handled. If `strict` is `TRUE` then execution is
  stopped. If `strict` is `FALSE` then `NA` is returned. Defaults to
  `TRUE`.

- blank_is_NA:

  Whether blanks should be treated as `NA`. Defaults to `FALSE`.

- year_unit:

  The year unit name to expect. If not blank then the value is expected
  to be followed by a space and this unit text. Cannot be more than 20
  characters (UTF-8 bytes) or contain control characters. Defaults to
  `"yr"`.

- ...:

  Other arguments (not used in this package).

## Value

A vector of `durationy`.

## Examples

``` r
durationy("10 yr")
#> [1] 10 yr
durationy("+10 yr")
#> [1] 10 yr
durationy("-10 yr")
#> [1] −10 yr
durationy("10", year_unit = "")
#> [1] 10 yr
durationy("10 a", year_unit = "a")
#> [1] 10 yr

# Handling blanks:
try(durationy(""))
#> Error : Blank durationy text (and blank_is_NA is FALSE).
durationy("", blank_is_NA = TRUE)
#> [1] <NA>

# Invalids:
try(durationy("abc"))
#> Error : Invalid durationy text. Missing year digit.
try(durationy("2000.000001 yr"))
#> Error : Invalid durationy text. Cannot be more than 2000 years.
durationy("abc", strict = FALSE) # NA
#> [1] <NA>
durationy("2000.000001 yr", strict = FALSE) # NA
#> [1] <NA>
durationy("2000.000000 yr") # This is valid
#> [1] 2000 yr
```
