# Coerce a calendar year (including fractional part) or another date type to a `datey` for the start, middle of end of the day

Accepted types are:

- Numeric, interpreted as calendar year, with the fractional part
  representing the fraction of the year. For instance, `datey(2000.5)`
  means halfway though the year 2000.

- The base R date types (`Date` and `POSIXct` and `POSIXlt`).

- `character`, in ISO 8601 extended format, i.e. YYYY-MM-DD.

- `datey`, which is interpreted as is but with the start, middle or end
  day override.

Beware that `as_end_day()` will add a day to a `datey` that is already
on a day boundary, *even if it was originally defined as an end day*.

## Usage

``` r
as_start_day(x, strict = TRUE)

as_mid_day(x, strict = TRUE)

as_end_day(x, strict = TRUE)
```

## Arguments

- x:

  The argument to convert to a `datey`.

- strict:

  How invalid results (given non-NA inputs) should be handled.

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

  (NA inputs will result in NA regardless of this switch.)

## See also

Use
[`start_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md),
[`mid_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
and
[`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
to create a `datey` direct from year, month and day.
