# Format or print a `durationy`

A `durationy` is printed as a decimal.

This format is readable by
[`durationy.character()`](https://logmu-org.github.io/r-datey/reference/text_to_durationy.md).

## Usage

``` r
# S3 method for class 'durationy'
as.character(x, ...)

# S3 method for class 'durationy'
format(x, include_plus = FALSE, use_true_minus = TRUE, year_unit = "yr", ...)

# S3 method for class 'durationy'
print(
  x,
  include_plus = FALSE,
  use_true_minus = TRUE,
  year_unit = "yr",
  max = NULL,
  ...
)
```

## Arguments

- x:

  The `durationy` to print or format.

- ...:

  Further arguments to be passed from or to other methods.

- include_plus:

  Whether to include a plus ('+') sign for positive durations. Defaults
  to `FALSE`.

- use_true_minus:

  Whether to use the [true minus sign ('−',
  U+2212)](https://www.compart.com/en/unicode/U+2212) sign as opposed to
  the [ASCII hyphen (-,
  U+2212)](https://www.compart.com/en/unicode/U+002D). Defaults to
  `FALSE`.

- year_unit:

  The year unit name to print. If not blank then the value is followed
  by a space and the unit. Cannot be more than 20 characters (UTF-8
  bytes) or contain control characters. Defaults to `"yr"`.

- max:

  Numeric or `NULL`, specifying the maximal number of entries to be
  printed. When `NULL`, `getOption("max.print")` used. Defaults to
  `NULL`.

## Examples

``` r
  pos <- durationy(1)
  neg <- durationy(-2.3)
  format(pos) # "1 yr"
#> [1] "1 yr"
  format(pos, include_plus = TRUE) # "1 yr"
#> [1] "+1 yr"
  format(pos, year_unit = "") # "1"
#> [1] "1"
  format(neg) # "−2.3 yr"
#> [1] "−2.3 yr"
  format(neg, use_true_minus = TRUE) # "−2.3 yr"
#> [1] "−2.3 yr"
  format(neg, year_unit = "a") # "-2.3 a"
#> [1] "−2.3 a"
```
