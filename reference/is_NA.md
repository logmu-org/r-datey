# Whether `datey` or `durationy` are NA

Valid datey system ranges:

- Valid dates are from the start of 1000 to the start of 3000.

- Valid durations are 2000 years or less in magnitude.

Values outside the above ranges are treated as NA.

[`is.na()`](https://rdrr.io/r/base/NA.html) tests whether a `datey` or
`durationy` is NA by element.

[`anyNA()`](https://rdrr.io/r/base/NA.html) tests whether any element of
a `datey` or `durationy` is NA.

For convenience,

- the constants
  [NA_datey\_](https://logmu-org.github.io/r-datey/reference/NAs.md) and
  [NA_durationy\_](https://logmu-org.github.io/r-datey/reference/NAs.md)
  are the `datey` and `durationy` versions of NA respectively, and

- [integer
  constants](https://logmu-org.github.io/r-datey/reference/integer_constants.md)
  describing the above valid ranges are also provided.

For performance reasons, intermediate calculations may not check for
NAs.

## Usage

``` r
# S3 method for class 'datey'
is.na(x)

# S3 method for class 'datey'
anyNA(x, recursive = FALSE)

# S3 method for class 'datey_interval'
is.na(x)

# S3 method for class 'datey_interval'
anyNA(x, recursive = FALSE)

# S3 method for class 'durationy'
is.na(x)

# S3 method for class 'durationy'
anyNA(x, recursive = FALSE)
```

## Arguments

- x:

  The `datey` or `durationy` to test for NA.

- recursive:

  Currently required to be `FALSE` (the default).

## Value

[`is.na()`](https://rdrr.io/r/base/NA.html) returns a vector of logical
the same length as `x`. [`anyNA()`](https://rdrr.io/r/base/NA.html)
always returns `TRUE` or `FALSE`, never `NA` and never anything other
than a single value.

## See also

[NA_datey\_](https://logmu-org.github.io/r-datey/reference/NAs.md),
[NA_durationy\_](https://logmu-org.github.io/r-datey/reference/NAs.md),
[integer_constants](https://logmu-org.github.io/r-datey/reference/integer_constants.md)

## Examples

``` r
  t <- c(NA_datey_, datey(2000), datey(999.99, strict = FALSE))
  is.na(t)
#> [1]  TRUE FALSE  TRUE
  anyNA(t)
#> [1] TRUE

  d <- c(NA_durationy_, durationy(1.5))
  is.na(d)
#> [1]  TRUE FALSE
  anyNA(d)
#> [1] TRUE
```
