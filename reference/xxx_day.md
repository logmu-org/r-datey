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
  day fractions not in the interval \[0,1\]. If `strict` is `TRUE` – the
  default – then execution is stopped. If `strict` is `FALSE` then `NA`
  is returned.

  NA arguments result in NA (and do not stop execution) regardless of
  `strict`.

## Value

A vector of `datey`.

## See also

Use
[`as_start_day()`](https://r-datey.logmu.org/reference/as_xxx_day.md),
[`as_mid_day()`](https://r-datey.logmu.org/reference/as_xxx_day.md) or
[`as_end_day()`](https://r-datey.logmu.org/reference/as_xxx_day.md) to
create a `datey` from a base R date or datetime.

Use [`datey()`](https://r-datey.logmu.org/reference/datey.md) to create
a `datey` direct from fractional calendar years.

To deconstruct a `datey`, use
[`to_ymdf()`](https://r-datey.logmu.org/reference/ymdf.md).

## Examples

``` r
  start_day(1999, 12, 31)
#> [1] 1999-12-31.0
  mid_day(1999, 12, 31)
#> [1] 1999-12-31.5
  end_day(1999, 12, 31)
#> [1] 2000-01-01.0
```
