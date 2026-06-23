# Is a `datey` the start (or end) or middle of a day?

`is_start_day()` checks whether `x` is the start or end of a day.

`is_mid_day()` checks whether `x` is the middle of a day.

These properties are *not* necessarily preserved when a duration of
*n* years is added or subtracted.

## Usage

``` r
is_start_day(x)

is_mid_day(x)
```

## Arguments

- x:

  The `datey` to test.

## Value

A vector of `logical`. Elements of the `datey` vector that are
`NA_datey_` will result in `NA` elements of the result vector.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md)

## Examples

``` r
# Create (NA, 0 days, 1/4 day, 1/2 day):
t <- datey(c(NA_real_, 2000, 2000 + 0.25/366, 2000 + 0.5/366))
t # <NA>  2000-01-01.0  2000-01-01.25 2000-01-01.5
#> [1] <NA>          2000-01-01.0  2000-01-01.25 2000-01-01.5 

is_start_day(t) # NA  TRUE FALSE FALSE
#> [1]    NA  TRUE FALSE FALSE
is_mid_day(t)   # NA FALSE FALSE  TRUE
#> [1]    NA FALSE FALSE  TRUE

# Properties are not necessarily preserved between years:
t <- start_day(2000,7,1) # Leap year
is_start_day(t) # TRUE
#> [1] TRUE
is_start_day(t + durationy(1)) # FALSE
#> [1] FALSE
```
