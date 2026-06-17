# Get the start, end or duration of a `datey_interval`

Get the start, end or duration of a `datey_interval` using the syntax
`$start`, `$end` or `$duration` respectively.

## Usage

``` r
# S3 method for class 'datey_interval'
x$name
```

## Arguments

- x:

  The `datey_interval`.

- name:

  Must be `start`, `end` or `duration`.

## Value

`start` and `end` return a vector of `datey`; `duration` returns a
vector of `durationy`.

## Examples

``` r
  t_1 <- start_day(2001, 1, 1)
  t_2 <- start_day(2002, 2, 2)
  interval <- datey_interval(t_1, t_2)
  interval
#> [1] [2001-01-01.0, 2002-02-02.0)
  interval$start
#> [1] 2001-01-01.0
  interval$end
#> [1] 2002-02-02.0
  interval$duration
#> [1] 1.087671 yr
```
