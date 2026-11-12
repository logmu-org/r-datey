# Get year, month, day or day_fraction breakdown of a `datey`

To extract the year, month, day or day_fraction breakdown of a `datey`,
use either

- the list-like syntax `$year`, `$month`, `$day` or `$day_fraction`
  direct, or

- if you need several components at once, `to_ymdf()`, which returns an
  actual list of `year`, `month`, `day` and `day_fraction`.

In this breakdown,

- `year` is an `integer` in \[1000,3000\],

- `month` is an `integer` in \[1,12\],

- `day` is an `integer` in \[1,N\], where N is the number of days in the
  month specified by `year` and `month`, and

- `day_fraction` is a `double` in \[0,1) representing the fraction of
  the day, where e.g. 0 means the start and 0.5 means the middle of the
  day.

If the `datey` was constructed using `end_day` or `day_fraction = 1`
then `to_ymdf()` will return the *start* of the *next* day with
`day_fraction = 0`.

## Usage

``` r
to_ymdf(x)

# S3 method for class 'datey'
x$name
```

## Arguments

- x:

  The `datey` to be deconstructed.

- name:

  The name of the component for the list-like syntax. Must be `year`,
  `month`, `day` or `day_fraction`.

## Value

`to_ymdf()` returns a list of integer vector `year`, integer vector
`month`, integer vector `day`, and double vector `day_fraction`, all
with the same length. The list-like syntax returns these components
individually.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[text_from_datey](https://r-datey.logmu.org/reference/text_from_datey.md)

## Examples

``` r
  t <- datey(2001, 2, 3, 0.5)
  t
#> [1] 2001-02-03.5
  to_ymdf(t)
#> $year
#> [1] 2001
#> 
#> $month
#> [1] 2
#> 
#> $day
#> [1] 3
#> 
#> $day_fraction
#> [1] 0.5
#> 
  t$year
#> [1] 2001
  t$month
#> [1] 2
  t$day
#> [1] 3
  t$day_fraction
#> [1] 0.5
```
