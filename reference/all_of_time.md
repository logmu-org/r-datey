# 'All of time' — the maximum valid `datey_interval`

`all_of_time` is the `datey_interval` \[1000-01-01.0, 3000-01-01.0),
spanning the full valid date range. It is referred to as 'all of time'
throughout the **datey** documentation.

It is the value produced by `datey_interval(TRUE)` and is used when a
`datey_interval` is intersected with a logical `TRUE` via `&`.

## Usage

``` r
all_of_time
```

## See also

[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md),
[ops](https://r-datey.logmu.org/reference/ops.md)

## Examples

``` r
  all_of_time
#> [1] [1000-01-01.0, 3000-01-01.0)
```
