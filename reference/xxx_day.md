# Create a `datey` for the start, middle or end of a day

Create a `datey` for the start, middle or end of the day specified by
calendar year, month and day.

The lengths of vector arguments must be multiples of each other.

To deconstruct a `datey`, use
[`to_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md).

## Usage

``` r
start_day(year, month, day, strict = TRUE)

mid_day(year, month, day, strict = TRUE)

end_day(year, month, day, strict = TRUE)

as_start_day(x, ...)

as_mid_day(x, ...)

as_end_day(x, ...)
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

- strict:

  How to handle calendar years less than 1000 or greater than or equal
  to 3000 and day fractions not in the interval \[0,1\].

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

  (NA arguments result in NA regardless of `strict`.)

- day_fraction:

  The fraction of the day, in \[0,1\]. 0 means the start of the day, 0.5
  means the middle of the day, and 1 means the end of the day (which is
  identical to the start of the next day).

## Edge cases

The following are special cases:

1.  `end_day(999, 12, 31)` *will* cause an error, even though in theory
    it represents the legal `datey` 1000-01-01.0.

2.  `end_day(2999, 12, 31)` will *not* cause an error, even though in
    theory it represents the illegal `datey` 3000-01-01.0. The resulting
    `datey` will be invalid though.
