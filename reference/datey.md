# Create a `datey`

Create a `datey` from a year, month, day and, for `datey()`, a
day-fraction.

In general, prefer the explicit `start_day()`, `mid_day()` and
`end_day()` versions.

To deconstruct a `datey`, use
[`as_ymdf()`](https://logmu-org.github.io/r-datey/reference/as_ymdf.md).

The lengths of vector arguments must be multiples of each other.

## Usage

``` r
datey(year, month, day, day_fraction, strict = TRUE)

start_day(year, month, day, strict = TRUE)

mid_day(year, month, day, strict = TRUE)

end_day(year, month, day, strict = TRUE)
```

## Arguments

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

1.  `(year = 999, month = 12, day = 31, day_fraction = 1`). This *will*
    cause an error, even though in theory it represents the legal
    `datey` 1000-01-01.0.

2.  `(year = 2999, month = 12, day = 31, day_fraction = 1`). This will
    *not* cause an error, even though in theory it represents the
    illegal `datey` 3000-01-01.0. (The resulting `datey` will be invalid
    though.)
