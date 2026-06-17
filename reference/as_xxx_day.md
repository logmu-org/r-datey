# Create a `datey` aligned to the start, middle or end of the day specified by a fractional calendar year or another date type.

Accepted types are:

- Numeric, interpreted as calendar year, with the fractional part
  representing the fraction of the year. For instance, `datey(2000.5)`
  means halfway through the year 2000.

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

  How invalid *non-NA* inputs should be handled. If `strict` is `TRUE` –
  the default – then execution is stopped. If `strict` is `FALSE` then
  `NA` is returned.

  NA arguments result in NA (and do not stop execution) regardless of
  `strict`.

## Value

A vector of `datey`.

## See also

Use [`start_day()`](https://r-datey.logmu.org/reference/xxx_day.md),
[`mid_day()`](https://r-datey.logmu.org/reference/xxx_day.md) and
[`end_day()`](https://r-datey.logmu.org/reference/xxx_day.md) to create
a `datey` direct from year, month and day.

## Examples

``` r
  R_date <- as.Date("2025-07-01")
  as_start_day(R_date)
#> [1] 2025-07-01.0
  as_mid_day(R_date)
#> [1] 2025-07-01.5
  as_end_day(R_date)
#> [1] 2025-07-02.0
```
