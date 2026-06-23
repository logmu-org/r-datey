# Convert a `durationy` to duration in years

Converts a `durationy` to its duration measured in years.

[`as.numeric()`](https://rdrr.io/r/base/numeric.html) is the same as
[`as.double()`](https://rdrr.io/r/base/double.html).

[`as.integer()`](https://rdrr.io/r/base/integer.html) obtains the
integer part as an `integer`, e.g. `as.integer(durationy(1.75))` is `1`
and `as.integer(durationy(-1.75))` is `-1` (i.e. rounding towards `0`).
It is also the case that if `x` is a `durationy` then `as.integer(x)` is
the same as `as.integer(as.double(x))`.

## Usage

``` r
# S3 method for class 'durationy'
as.double(x, ...)

# S3 method for class 'durationy'
as.integer(x, ...)
```

## Arguments

- x:

  The `durationy` to convert to years.

- ...:

  Not used.

## Value

A vector of `double`.

## See also

[durationy](https://r-datey.logmu.org/reference/durationy.md),
[as_years_datey](https://r-datey.logmu.org/reference/as_years_datey.md),
[ops](https://r-datey.logmu.org/reference/ops.md)

## Examples

``` r
d <- durationy(1.75)
d                   # 1.75 yr
#> [1] 1.75 yr
as.double(d)        # 1.75
#> [1] 1.75
as.numeric(d)       # 1.75
#> [1] 1.75
as.integer(d)       # 1
#> [1] 1
as.integer(-d)      # -1
#> [1] -1
identical(as.integer(d), 1L) # TRUE
#> [1] TRUE
```
