# Is `x` a leap year?

Tests whether a date or year is a leap year.

This returns `NA` if the corresponding `datey` would be invalid,
including years before 1000 and dates after 3000-01-01.0.

For numerics, this returns `NA` for years values less than 1000 or
greater than 3000.

This is an S3 generic. This package provides methods for:

- numeric types `double` and `integer` (interpreted as calendar years,
  e.g. `2000.9` means the calendar year 2000), and

- date types `datey`, `Date`, `POSIXct` and `POSIXlt`.

## Usage

``` r
is_leap_year(x)

# Default S3 method
is_leap_year(x)

# S3 method for class 'integer'
is_leap_year(x)

# S3 method for class 'double'
is_leap_year(x)

# S3 method for class 'datey'
is_leap_year(x)

# S3 method for class 'Date'
is_leap_year(x)

# S3 method for class 'POSIXct'
is_leap_year(x)

# S3 method for class 'POSIXlt'
is_leap_year(x)
```

## Arguments

- x:

  A vector date type or numeric year.

## Value

`NA` if `x` is not interpretable as a year or date, or outside
\[1000,3000\], `TRUE` if `x` is a leap year, otherwise `FALSE`.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md)

## Examples

``` r
any(is_leap_year(c(1900, 1901, 2001))) #FALSE
#> [1] FALSE
all(is_leap_year(c(1904.1, 2000.5, 2004.9))) #TRUE
#> [1] TRUE
```
