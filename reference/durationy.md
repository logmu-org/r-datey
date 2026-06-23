# Create a `durationy` from an annual duration

`durationy()` to create a `durationy` from the following types:

- `integer`. The value is interpreted as the specified number of years.

- `double`. The value is interpreted as the specified number of years,
  rounded to fixed precision of a `durationy`. This means that
  `durationy(0.5)` is precise but `durationy(0.01)` is not.

- `datey_interval`. The duration of the interval *provided it is proper*
  (i.e. start \<= end). If the interval is improper then the result is
  `NA_durationy_`. When `x` is a `datey_interval` then `x$duration` is
  identical to `durationy(x)`. (`strict` is ignored.)

- `character`. Valid text is of the form `[S]...Y[.F...][ U...]` where:

  - `[S]` is an optional plus or a minus sign, i.e. one of '+' (U+002B),
    true minus (U+2212) or ASCII hyphen-minus '-' (U+002D).

  - `...Y` is number of whole years (leading zeros allowed).

  - `[.F...]` is an optional fractional part of year, including '.' to
    represent the decimal point.

  - `[ U...]` is the unit name for one year preceded by a space if the
    unit name is not blank. The unit name cannot be longer than 20 UTF-8
    bytes or contain control characters.

  If `blank_is_NA` is `TRUE` then blanks are treated as `NA`. If
  `strict` is `TRUE` (the default) then non-compliant text will stop
  execution. If the text is NA then NA is returned. This is the same
  format as produced by
  [`as.character.durationy()`](https://r-datey.logmu.org/reference/text_from_durationy.md).

- `durationy`. Value is passed through unchanged.

NA arguments *of the appropriate type* result in `NA_durationy_` – they
do not stop execution (regardless of `strict`). Note that `NA` is
`logical` and therefore it *will* cause an error.

## Usage

``` r
durationy(x, ...)

# Default S3 method
durationy(x, ...)

# S3 method for class 'durationy'
durationy(x, ...)

# S3 method for class 'integer'
durationy(x, strict = TRUE, ...)

# S3 method for class 'double'
durationy(x, strict = TRUE, ...)

# S3 method for class 'datey_interval'
durationy(x, ...)

# S3 method for class 'character'
durationy(x, strict = TRUE, blank_is_NA = FALSE, year_unit = "yr", ...)
```

## Arguments

- x:

  The argument to convert to a `durationy`.

- ...:

  Not used.

- strict:

  How non-compliant non-NA `x`, e.g. years greater than 2000 in
  magnitude or invalid text, should be handled. If `strict` is `TRUE` –
  the default – then execution is stopped. If `strict` is `FALSE` then
  `NA` is returned.

- blank_is_NA:

  Whether blanks should be treated as `NA`. Defaults to `FALSE`.

- year_unit:

  The year unit name to expect. If not blank then the value is expected
  to be followed by a space and this unit text. Cannot be more than 20
  characters (UTF-8 bytes) or contain control characters. Defaults to
  `"yr"`.

## Value

A vector of `durationy`.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md),
[text_from_durationy](https://r-datey.logmu.org/reference/text_from_durationy.md),
[as_years_durationy](https://r-datey.logmu.org/reference/as_years_durationy.md),
[ops](https://r-datey.logmu.org/reference/ops.md),
[is_NA](https://r-datey.logmu.org/reference/is_NA.md),
[`vignette("why-datey", package = "datey")`](https://r-datey.logmu.org/articles/why-datey.md)
for the annual-grid design,
[`vignette("datey", package = "datey")`](https://r-datey.logmu.org/articles/datey.md)
for a worked introduction

## Examples

``` r
durationy(1)    # 1 yr
#> [1] 1 yr
durationy(0.5)  # 0.5 yr
#> [1] 0.5 yr
durationy(-2.3) # -2.3 yr
#> [1] −2.3 yr
durationy(2001 %to% 2002) # 1 yr
#> [1] 1 yr
durationy(2002 %to% 2001) # `NA_durationy_` because interval is improper
#> [1] <NA>

# NA:
durationy(NA_real_)
#> [1] <NA>
try(durationy(NA)) # NA is logical, not numeric
#> Error : S3 function `durationy` is not implemented for `NA`.

# Invalid durations:
try(durationy(3000.1)) # default strict = TRUE
#> Error : Years cannot be more than 2000.
durationy(3000.1, strict = FALSE)
#> [1] <NA>

# Text:
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

# Text round trips:
d <- durationy(1.234)
identical(d, durationy(as.character(d))) # TRUE
#> [1] TRUE

# Handling blank text:
try(durationy(""))
#> Error : Blank durationy text (and blank_is_NA is FALSE).
durationy("", blank_is_NA = TRUE)
#> [1] <NA>

# Invalid text:
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
