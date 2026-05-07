# Handling invalid dates

Valid dates within the datey system have calendar years in the interval
\[1000,3000).

Dates outside this interval are treated as NA.

Use

- [`is.na()`](https://rdrr.io/r/base/NA.html) to test whether `datey` is
  NA by element, and

- [`anyNA()`](https://rdrr.io/r/base/NA.html) to test whether any
  element of a `datey` is NA.

The `datey` version of NA is `NA_datey_`.

For convenience, the following constants are also available:

- `valid_years_start`: The first *valid* calendar year (1000).

- `valid_years_end`: The first *invalid* calendar year after
  `valid_years_start` (3000).

For performance reasons, intermediate calculations may not check for
NAs.

## Usage

``` r
NA_datey_

# S3 method for class 'datey'
is.na(x)

# S3 method for class 'datey'
anyNA(x, recursive = FALSE)

valid_years_start

valid_years_end
```

## Format

An object of class `datey_type` (inherits from `datey`) of length 1.

An object of class `integer` of length 1.

An object of class `integer` of length 1.

## Arguments

- x:

  The `datey` to test for validity.

- recursive:

  Unused.

## Value

A single logical value, `TRUE` or `FALSE`, never `NA` and never anything
other than a single value.

## See also

datey

## Examples

``` r
  x <- c(NA_datey_, datey(2000))
  is.na(x) # c(TRUE, FALSE)
#> [1]  TRUE FALSE
  anyNA(x) # TRUE
#> [1] TRUE
```
