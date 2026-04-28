# Test whether a `datey` is the start or middle of a day

`is_start_day()` tests whether the `datey` is a valid start (or end) of
a day, i.e. the boundary between two days.

`is_mid_day()` tests whether the `datey` is a valid exact the middle of
a day.

## Usage

``` r
is_start_day(datey)

is_mid_day(datey)
```

## Arguments

- datey:

  The (vector of ) `datey` to test.
