# Minimum, maximum or range of `datey` or `durationy`

Gets the minimum, maximum or range of one or more `datey` or `durationy`
vectors. All arguments must be of the same type.

Returns a typed NA (`NA_datey_` or `NA_durationy_`) for empty input or
when all values are NA and `na.rm = TRUE`.

These are S3 methods for the `Summary` group generic.

## Usage

``` r
# S3 method for class 'datey_interval'
Summary(..., na.rm = FALSE)

# S3 method for class 'datey'
Summary(..., na.rm = FALSE)

# S3 method for class 'durationy'
Summary(..., na.rm = FALSE)
```

## Arguments

- ...:

  One or more `datey` or `durationy` vectors. All must be the same type.

- na.rm:

  A logical (`TRUE` or `FALSE`) indicating whether NA values should be
  removed before the computation.

## Value

`min` and `max` return a scalar. `range` returns a two element vector,
the first element being the minimum and the second the maximum.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[durationy](https://r-datey.logmu.org/reference/durationy.md),
[mean.datey](https://r-datey.logmu.org/reference/mean.md)

## Examples

``` r
    t <- datey(2000:2003)
    t
#> [1] 2000-01-01.0 2001-01-01.0 2002-01-01.0 2003-01-01.0
    min(t)
#> [1] 2000-01-01.0
    max(t)
#> [1] 2003-01-01.0
    range(t)
#> [1] 2000-01-01.0 2003-01-01.0
```
