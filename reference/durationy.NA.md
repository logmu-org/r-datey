# Handling invalid durations

A duration within the datey system is valid if it represents 2000 years
or less.

Larger durations are treated as NA.

Use

- [`is.na()`](https://rdrr.io/r/base/NA.html) to test whether `datey` is
  NA by element, and

- [`anyNA()`](https://rdrr.io/r/base/NA.html) to test whether any
  element of a `datey` is NA.

The `durationy` version of NA is `NA_durationy_`.

For convenience, the constant `valid_max_duration` is the maximum valid
duration in years (2000).

For performance reasons, intermediate calculations may not check for
NAs.

## Usage

``` r
NA_durationy_

# S3 method for class 'durationy'
is.na(x)

# S3 method for class 'durationy'
anyNA(x, recursive = FALSE)

valid_duration_years_max
```

## Format

An object of class `durationy` of length 1.

An object of class `integer` of length 1.

## Arguments

- x:

  The `durationy` to test for validity.

- recursive:

  Unused.

## Value

A single logical value, `TRUE` or `FALSE`, never `NA` and never anything
other than a single value.

## See also

as_durationy

## Examples

``` r
  x <- c(NA_durationy_, as_durationy(1.5))
  is.na(x) # c(TRUE, FALSE)
#> [1]  TRUE FALSE
  anyNA(x) # TRUE
#> [1] TRUE
```
