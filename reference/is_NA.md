# Whether `datey`, `durationy` or `datey_interval` are NA

Valid datey system ranges:

- Valid dates are from the start of 1000 to the start of 3000.

- Valid durations are 2000 years or less in magnitude.

Values outside the above ranges are treated as NA.

[`is.na()`](https://rdrr.io/r/base/NA.html) tests whether a `datey`,
`durationy` or `datey_interval` is NA by element.

[`anyNA()`](https://rdrr.io/r/base/NA.html) tests whether any element of
a `datey`, `durationy` or `datey_interval` is NA.

For convenience,

- the constants
  [NA_datey\_](https://r-datey.logmu.org/reference/NAs.md),
  [NA_durationy\_](https://r-datey.logmu.org/reference/NAs.md) and
  [NA_datey_interval\_](https://r-datey.logmu.org/reference/NAs.md) are
  the `datey`, `durationy` and `datey_interval` versions of NA
  respectively, and

- [integer
  constants](https://r-datey.logmu.org/reference/integer_constants.md)
  describing the above valid ranges are also provided.

For performance reasons, intermediate **datey** system calculations are
*not* required to check for NAs.

Throughout the **datey** package, `NA` will cause an error when used
where a `datey`, `durationy` or `datey_interval` is expected. This is
because its type is `logical` and potentially indicates user error. If
you want an NA value with a **datey** system type, use one of
`NA_datey_`, `NA_durationy_` or `NA_datey_interval_`.

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

  The `datey`, `durationy` or `datey_interval` to test for NA.

- recursive:

  Currently required to be `FALSE` (the default).

## Value

[`is.na()`](https://rdrr.io/r/base/NA.html) returns a vector of logical
the same length as `x`. [`anyNA()`](https://rdrr.io/r/base/NA.html)
always returns `TRUE` or `FALSE`, never `NA` and never anything other
than a single value.

## See also

[NA_datey\_](https://r-datey.logmu.org/reference/NAs.md),
[NA_durationy\_](https://r-datey.logmu.org/reference/NAs.md),
[NA_datey_interval\_](https://r-datey.logmu.org/reference/NAs.md),
[integer_constants](https://r-datey.logmu.org/reference/integer_constants.md),
[datey](https://r-datey.logmu.org/reference/datey.md),
[durationy](https://r-datey.logmu.org/reference/durationy.md),
[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md)

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

  i <- c(NA_datey_interval_, 2000 %to% 2001)
  is.na(i)
#> [1]  TRUE FALSE
  anyNA(i)
#> [1] TRUE
```
