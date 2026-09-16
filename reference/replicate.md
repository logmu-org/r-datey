# Replicate `datey`, `durationy` or `datey_interval` vectors

Replicates `datey`, `durationy` or `datey_interval` vectors.

## Usage

``` r
# S3 method for class 'datey'
rep(x, ...)

# S3 method for class 'durationy'
rep(x, ...)

# S3 method for class 'datey_interval'
rep(x, ...)
```

## Arguments

- x:

  A `datey`, `durationy` or `datey_interval`.

- ...:

  Other arguments.

## Value

The replicated vector.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[durationy](https://r-datey.logmu.org/reference/durationy.md),
[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md)

## Examples

``` r
  x <- datey(2001:2004)
  rep(x, 2)
#> [1] 2001-01-01.0 2002-01-01.0 2003-01-01.0 2004-01-01.0 2001-01-01.0
#> [6] 2002-01-01.0 2003-01-01.0 2004-01-01.0
  rep(x, each = 2)
#> [1] 2001-01-01.0 2001-01-01.0 2002-01-01.0 2002-01-01.0 2003-01-01.0
#> [6] 2003-01-01.0 2004-01-01.0 2004-01-01.0
  pmax(x, datey(2002))
#> [1] 2002-01-01.0 2002-01-01.0 2003-01-01.0 2004-01-01.0
```
