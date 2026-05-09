# `datey` in terms of calendar year, month, day and day fraction components

`to_ymdf()` returns a list of the `year`, `month`, `day` and
`day_fraction` breakdown of a `datey`, where

- `year` is an `integer` in \[1000,3000),

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
fraction.

The lengths of vector arguments must be multiples of each other.

## Usage

``` r
to_ymdf(datey)

point_in_day(year, month, day, day_fraction, strict = TRUE)
```

## Arguments

- datey:

  The `datey` to be deconstructed by `from_ymdf()`.

- year:

  Calendar year. Valid years are from 1000 (inclusive) to 3000
  (exclusive). If provided as `double` then these *must be integers*.

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

  How to handle calendar years less than 1000 or greater than or equal
  to 3000 and day fractions not in the interval \[0,1\].

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

  (NA arguments result in NA regardless of `strict`.)

## Edge cases

The following are special cases:

1.  `from_ymdf(999, 12, 31, 1)` *will* cause an error, even though in
    theory it represents the legal `datey` 1000-01-01.0.

2.  `from_ymdf(2999, 12, 31, 1)` will *not* cause an error, even though
    in theory it represents the illegal `datey` 3000-01-01.0. The
    resulting `datey` will be invalid though.
