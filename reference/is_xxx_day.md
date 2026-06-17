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

A vector of `logical`. Invalid `datey` elements will return `NA`.

## Examples

``` r
# Start and end days:
t <- start_day(2000, 1, 1)
t
#> [1] 2000-01-01.0
is_start_day(t) # TRUE
#> [1] TRUE
is_mid_day(t)   # FALSE
#> [1] FALSE
t <- end_day(2000, 1, 1)
t
#> [1] 2000-01-02.0
is_start_day(t) # TRUE
#> [1] TRUE
is_mid_day(t)   # FALSE
#> [1] FALSE

# Mid day:
t <- mid_day(2000, 1, 1)
t
#> [1] 2000-01-01.5
is_start_day(t) # FALSE
#> [1] FALSE
is_mid_day(t)   # TRUE
#> [1] TRUE

# Neither a start nor mid day:
t <- from_ymdf(2000, 1, 1, 0.25)
t
#> [1] 2000-01-01.25
is_start_day(t) # FALSE
#> [1] FALSE
is_mid_day(t)   # FALSE
#> [1] FALSE

# Invalids return NA
is_start_day(NA_datey_) # NA
#> [1] NA
is_mid_day(NA_datey_)   # NA
#> [1] NA

# Properties are not preserved:
t <- start_day(2000,7,1) # Leap year
is_start_day(t) # TRUE
#> [1] TRUE
is_start_day(t + durationy(1)) # FALSE
#> [1] FALSE
```
