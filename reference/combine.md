# Combine multiple `datey` or `durationy` vectors

Combines (flattens) `datey` or `durationy` into a single vector.

All arguments must have the same class, i.e. they must be all `datey`s
or all `durationy`s.

If the first element in `c(...)` is not a `datey` or `durationy` then
this method will not be called. For instance,
`c(NA, datey("2000-01-01.0"))` results in `c(NA_integer_, 1068720000L)`.

## Usage

``` r
# S3 method for class 'datey'
c(..., recursive = FALSE)

# S3 method for class 'durationy'
c(..., recursive = FALSE)
```

## Arguments

- ...:

  The items to combine.

- recursive:

  Unused.

## Value

[`c()`](https://rdrr.io/r/base/c.html) returns a `datey` or `durationy`
depending on the first argument.

## Examples

``` r
  c(datey(2000:2019), datey("2020-01-01.0"))
#>  [1] 2000-01-01.0 2001-01-01.0 2002-01-01.0 2003-01-01.0 2004-01-01.0
#>  [6] 2005-01-01.0 2006-01-01.0 2007-01-01.0 2008-01-01.0 2009-01-01.0
#> [11] 2010-01-01.0 2011-01-01.0 2012-01-01.0 2013-01-01.0 2014-01-01.0
#> [16] 2015-01-01.0 2016-01-01.0 2017-01-01.0 2018-01-01.0 2019-01-01.0
#> [21] 2020-01-01.0
```
