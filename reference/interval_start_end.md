# Extract start or end from a `datey_interval`

Extract the start or end of a `datey_interval` using the syntax `$start`
or `$end` respectively.

## Usage

``` r
# S3 method for class 'datey_interval'
x$name
```

## Arguments

- x:

  The `datey_interval`.

- name:

  Must be `start` or `end`.

## Examples

``` r
  t_1 <- start_day(2001, 1, 1)
  t_2 <- start_day(2002, 2, 2)
  interval <- datey_interval(t_1, t_2)
  interval$start
#> [1] 2001-01-01.0
  interval$end
#> [1] 2002-02-02.0
```
