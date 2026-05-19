# Create a `datey` for the start, middle or end of a day

Create a `datey` for the start, middle or end of the day specified by
calendar year, month and day.

The lengths of vector arguments must be multiples of each other.

## Usage

``` r
start_day(year, month, day, strict = TRUE)

mid_day(year, month, day, strict = TRUE)

end_day(year, month, day, strict = TRUE)
```

## Arguments

- year:

  Calendar year. Valid years are from 1000 to 3000 (although the only
  legal date in 3000 is the start of 3000-01-01).

- month:

  Month number in calendar year, with 1 representing January. If
  provided as `double` then these *must be integers*.

- day:

  Day number in month, with 1 representing the first day of the month.
  If provided as `double` then these *must be integers*.

- strict:

  How to handle calendar years less than 1000 or greater than 3000 and
  day fractions not in the interval \[0,1\].

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

- x:

  A `datey` to coerce to the start, middle or end of a day.

- ...:

  A `datey` to coerce to the start, middle or end of a day.

  (NA arguments result in NA regardless of `strict`.)

## See also

Use [`datey()`](https://logmu-org.github.io/r-datey/reference/datey.md)
to to create a `datey` direct from years or a base R date. These methods
call
[`from_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md).

To deconstruct a `datey`, use
[`to_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md).
