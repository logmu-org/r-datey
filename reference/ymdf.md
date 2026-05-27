# Create or decompose a `datey` using calendar year, month, day and day fraction

The lengths of vector arguments must be multiples of each other.

`to_ymdf()` returns a list of the `year`, `month`, `day` and
`day_fraction` breakdown of a `datey`, where

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

`from_ymdf()` creates a `datey` from a calendar year, month, and day
fraction. In practice, prefer one of
[`start_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md),
[`mid_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
or
[`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
for clarity.

## Usage

``` r
to_ymdf(datey)

from_ymdf(year, month, day, day_fraction, strict = TRUE)
```

## Arguments

- datey:

  A `datey` to be deconstructed.

- year:

  Calendar year. Valid years are from 1000 to 3000 (although the only
  legal date in 3000 is the start of 3000-01-01). If provided as
  `double` then these *must be integers*.

- month:

  Month number in calendar year, with 1 representing January. If
  provided as `double` then these *must be integers*.

- day:

  Day number in month, with 1 representing the first day of the month.
  If provided as `double` then these *must be integers*.

- day_fraction:

  The fraction of the day, in \[0,1\]. 0 means the start of the day, 0.5
  means the middle of the day, and 1 means the end of the day (which is
  identical to the start of the next day).

- strict:

  How to handle invalid arguments.

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

  (NA arguments result in NA regardless of `strict`.)

## See also

Use [`datey()`](https://logmu-org.github.io/r-datey/reference/datey.md)
to create a `datey` direct from years or a base R date.

## Examples

``` r
  t <- from_ymdf(1999, 12, 31, 0.5)
  t
#> [1] 1999-12-31.5
  to_ymdf(t)
#> $year
#> [1] 1999
#> 
#> $month
#> [1] 12
#> 
#> $day
#> [1] 31
#> 
#> $day_fraction
#> [1] 0.5
#> 
```
