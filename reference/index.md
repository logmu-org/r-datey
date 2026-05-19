# Package index

## Creation and conversion

- [`datey()`](https://logmu-org.github.io/r-datey/reference/datey.md) :

  Create a `datey` from a calendar year (including its fractional part)
  or another date type

- [`start_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  [`mid_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  [`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  :

  Create a `datey` for the start, middle or end of a day

- [`as_start_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
  [`as_mid_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
  [`as_end_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
  :

  Coerce a calendar year (including fractional part) or another date
  type to a `datey` for the start, middle of end of the day

- [`durationy()`](https://logmu-org.github.io/r-datey/reference/durationy.md)
  :

  Create a `durationy` from an annual duration

- [`as.double(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_datey.md)
  [`as.integer(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_datey.md)
  :

  Convert a `datey` to calendar years (including fractional part)

- [`as.double(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_durationy.md)
  [`as.integer(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_durationy.md)
  :

  Convert a `durationy` to duration in years

- [`to_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md)
  [`from_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md)
  :

  Create or decompose a `datey` using calendar year, month, day and day
  fraction

## Text parsing and printing

- [`datey(`*`<character>`*`)`](https://logmu-org.github.io/r-datey/reference/text_to_datey.md)
  :

  Parse text as a `datey`

- [`durationy(`*`<character>`*`)`](https://logmu-org.github.io/r-datey/reference/text_to_durationy.md)
  :

  Parse text as a `durationy`

- [`format(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey.md)
  [`print(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey.md)
  :

  Format or print a `datey`

- [`format(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_durationy.md)
  [`print(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_durationy.md)
  :

  Format or print a `durationy`

## Checks

- [`is_datey()`](https://logmu-org.github.io/r-datey/reference/is_type.md)
  [`is_durationy()`](https://logmu-org.github.io/r-datey/reference/is_type.md)
  :

  Is `x` a `datey` or a `durationy`?

- [`is_start_day()`](https://logmu-org.github.io/r-datey/reference/is_xxx_day.md)
  [`is_mid_day()`](https://logmu-org.github.io/r-datey/reference/is_xxx_day.md)
  :

  Is a `datey` the start (or end) or middle of a day?

- [`is_leap_year()`](https://logmu-org.github.io/r-datey/reference/is_leap_year.md)
  :

  Is `x` a leap year?

## Validity

- [`is.na(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`anyNA(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`is.na(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`anyNA(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  :

  Whether `datey` or `durationy` are NA

- [`NA_datey_`](https://logmu-org.github.io/r-datey/reference/NA_datey_.md)
  :

  The `datey` version of NA

- [`NA_durationy_`](https://logmu-org.github.io/r-datey/reference/NA_durationy_.md)
  :

  The `durationy` version of NA

- [`valid_years_start`](https://logmu-org.github.io/r-datey/reference/integer_constants.md)
  [`valid_years_end`](https://logmu-org.github.io/r-datey/reference/integer_constants.md)
  [`valid_duration_years_max`](https://logmu-org.github.io/r-datey/reference/integer_constants.md)
  : Integer constants

## Summary statistics and operators

- [`mean(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/mean.md)
  [`mean(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/mean.md)
  :

  Mean value of `datey` or `durationy`

- [`Summary(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/max_min.md)
  [`Summary(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/max_min.md)
  :

  Minimum, maximum or range of `datey` or `durationy`

- [`Ops(`*`<datey_type>`*`)`](https://logmu-org.github.io/r-datey/reference/ops.md)
  :

  Operators for `datey` and `durationy`

## Utility

- [`c(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/combine.md)
  [`c(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/combine.md)
  :

  Combine multiple `datey` or `durationy` vectors
