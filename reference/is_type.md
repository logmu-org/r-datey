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
```
