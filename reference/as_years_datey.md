# Convert a `datey` to calendar years (including fractional part)

Converts a `datey` to calendar years, including a fractional part that
represents the proportion of the calendar year that has elapsed.

For example, the middle of 2000-10-01 is precisely three-quarters
through the (leap) year 2000 and so `as.double(mid_day(2000,10,1))`
results in `2000.75`.

[`as.numeric()`](https://rdrr.io/r/base/numeric.html) is the same as
[`as.double()`](https://rdrr.io/r/base/double.html).

[`as.integer()`](https://rdrr.io/r/base/integer.html) gives the calendar
year as an `integer`, e.g. `as.integer(datey(2000.75))` is `2000`. It is
also the case that if `x` is a `datey` then `as.integer(x)` is the same
as `as.integer(as.double(x))`.

## Usage

``` r
# S3 method for class 'datey'
as.double(x, ...)

# S3 method for class 'datey'
as.integer(x, ...)
```

## Arguments

- x:

  The `datey` to convert to years.

- ...:

  Not used.

## Value

A vector of `double`.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[as_years_durationy](https://r-datey.logmu.org/reference/as_years_durationy.md),
[ops](https://r-datey.logmu.org/reference/ops.md)

## Examples

``` r
t <- datey(2000.75)
t                   # 2000-10-01.5
#> [1] 2000-10-01.5
as.double(t)        # 2000.75
#> [1] 2000.75
as.numeric(t)       # 2000.75
#> [1] 2000.75
as.integer(t)       # 2000
#> [1] 2000
identical(as.integer(t), 2000L) # TRUE
#> [1] TRUE
```
