# Combine multiple `datey`, `durationy` or `datey_interval` vectors

Combines (flattens) `datey`, `durationy` or `datey_interval` into a
single vector.

All arguments must have the same class, i.e. all `datey`s, all
`durationy`s or all `datey_interval`s.

If the first element in `c(...)` is not a `datey`, `durationy` or
`datey_interval` then this method will not be called. For instance,
`c(NA, datey("2000-01-01.0"))` results in `c(NA_integer_, 1068720000L)`.

## Usage

``` r
# S3 method for class 'datey'
c(..., recursive = FALSE)

# S3 method for class 'durationy'
c(..., recursive = FALSE)

# S3 method for class 'datey_interval'
c(..., recursive = FALSE)
```

## Arguments

- ...:

  The items to combine.

- recursive:

  Unused.

## Value

[`c()`](https://rdrr.io/r/base/c.html) returns a `datey`, `durationy` or
`datey_interval` depending on the first argument.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[durationy](https://r-datey.logmu.org/reference/durationy.md),
[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md),
[subset](https://r-datey.logmu.org/reference/subset.md)

## Examples

``` r
  c(datey(2000:2019), datey("2020-01-01.0"))
#>  [1] 2000-01-01.0 2001-01-01.0 2002-01-01.0 2003-01-01.0 2004-01-01.0
#>  [6] 2005-01-01.0 2006-01-01.0 2007-01-01.0 2008-01-01.0 2009-01-01.0
#> [11] 2010-01-01.0 2011-01-01.0 2012-01-01.0 2013-01-01.0 2014-01-01.0
#> [16] 2015-01-01.0 2016-01-01.0 2017-01-01.0 2018-01-01.0 2019-01-01.0
#> [21] 2020-01-01.0
```
