# Is `x` a `datey`, `durationy` or `datey_interval`?

These methods will always return a scalar logical `TRUE` or `FALSE`:

- `is_datey()` tests whether an object is a `datey`.

- `is_durationy()` tests whether an object is a `durationy`.

- `is_datey_interval()` tests whether an object is a `datey_interval`.

## Usage

``` r
is_datey(x)

is_datey_interval(x)

is_durationy(x)
```

## Arguments

- x:

  The object to test.

## Value

A logical scalar indicating whether `x` a `datey`, `durationy` or
`datey_interval` as appropriate. Always `FALSE` or `TRUE`; never `NULL`
or `NA`.

## Examples

``` r
t <- datey(2000:2001)
t
#> [1] 2000-01-01.0 2001-01-01.0
is_datey(t)
#> [1] TRUE
is_datey(NULL)
#> [1] FALSE
is_datey(NA)
#> [1] FALSE

d <- durationy(0:2)
d
#> [1] 0 yr 1 yr 2 yr
is_durationy(d)
#> [1] TRUE
is_durationy(NULL)
#> [1] FALSE
is_durationy(NA)
#> [1] FALSE

interval <- datey(2000:2001) %to% datey(2001:2002)
interval
#> [1] [2000-01-01.0, 2001-01-01.0) [2001-01-01.0, 2002-01-01.0)
is_datey_interval(interval)
#> [1] TRUE
is_datey_interval(NULL)
#> [1] FALSE
is_datey_interval(NA)
#> [1] FALSE
```
