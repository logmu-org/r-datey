# Extract year, month, day or day_fraction from a `datey`

Extract the year, month, day or day_fraction of a `datey` using the
syntax `$year`, `$month`, `$day` or `$day_fraction` respectively.

`$year`, `$month` and `$day` are `integer`, and `$day_fraction` is
`double`.

## Usage

``` r
# S3 method for class 'datey'
x$name
```

## Arguments

- x:

  The `datey`.

- name:

  Must be `year`, `month`, `day` or `day_fraction`.

## See also

If you need more than one component then
[`to_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md) may
be more efficient.

## Examples

``` r
  t <- mid_day(2001, 2, 3)
  t$year
#> [1] 2001
  t$month
#> [1] 2
  t$day
#> [1] 3
  t$day_fraction
#> [1] 0.5
```
