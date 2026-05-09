# Is a `datey` the start (or end) or middle of a day?

`is_start_day()` checks whether `x` is the start or end of a day.

`is_mid_day()` checks whether `x` is the middle of a day.

Note that these properties are *not* necessarily preserved when a
duration of *n* years is added or subtracted.

## Usage

``` r
is_start_day(x)

is_mid_day(x)
```

## Arguments

- x:

  The `datey` to test.
