# Package index

## Package overview

- [`datey-package`](https://r-datey.logmu.org/reference/datey-package.md)
  : Exact date and duration arithmetic on an annual grid

## Create a `datey` or `durationy`

- [`datey()`](https://r-datey.logmu.org/reference/datey.md)
  [`start_day()`](https://r-datey.logmu.org/reference/datey.md)
  [`mid_day()`](https://r-datey.logmu.org/reference/datey.md)
  [`end_day()`](https://r-datey.logmu.org/reference/datey.md) :

  Create a `datey`

- [`durationy()`](https://r-datey.logmu.org/reference/durationy.md) :

  Create a `durationy` from an annual duration

- [`seq(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/seq.md)
  [`seq(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/seq.md)
  :

  Create `datey` or `durationy` sequence vector

- [`c(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/combine.md)
  [`c(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/combine.md)
  [`c(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/combine.md)
  :

  Combine multiple `datey`, `durationy` or `datey_interval` vectors

- [`` `[`( ``*`<datey>`*`)`](https://r-datey.logmu.org/reference/subset.md)
  [`` `[`( ``*`<durationy>`*`)`](https://r-datey.logmu.org/reference/subset.md)
  [`` `[`( ``*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/subset.md)
  [`` `[<-`( ``*`<datey>`*`)`](https://r-datey.logmu.org/reference/subset.md)
  [`` `[<-`( ``*`<durationy>`*`)`](https://r-datey.logmu.org/reference/subset.md)
  [`` `[<-`( ``*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/subset.md)
  :

  Subset `datey`, `durationy` or `datey_interval` vectors

## Properties of `datey` and `durationy`

- [`to_ymdf()`](https://r-datey.logmu.org/reference/datey_components.md)
  [`` `$`( ``*`<datey>`*`)`](https://r-datey.logmu.org/reference/datey_components.md)
  :

  Get year, month, day or day_fraction breakdown of a `datey`

- [`is_datey()`](https://r-datey.logmu.org/reference/is_type.md)
  [`is_datey_interval()`](https://r-datey.logmu.org/reference/is_type.md)
  [`is_durationy()`](https://r-datey.logmu.org/reference/is_type.md) :

  Is `x` a `datey`, `durationy` or `datey_interval`?

- [`is_start_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md)
  [`is_mid_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md) :

  Is a `datey` the start (or end) or middle of a day?

- [`is_leap_year()`](https://r-datey.logmu.org/reference/is_leap_year.md)
  :

  Is `x` a leap year?

## Conversion to years

- [`as.double(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/as_years_datey.md)
  [`as.integer(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/as_years_datey.md)
  :

  Convert a `datey` to calendar years (including fractional part)

- [`as.double(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/as_years_durationy.md)
  [`as.integer(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/as_years_durationy.md)
  :

  Convert a `durationy` to duration in years

## Operators and statistics

- [`Ops(`*`<datey_type>`*`)`](https://r-datey.logmu.org/reference/ops.md)
  :

  Operators for `datey`, `durationy` and `datey_interval`

- [`mean(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/mean.md)
  [`mean(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/mean.md)
  [`mean(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/mean.md)
  :

  Mean value of `datey` or `durationy`

- [`Summary(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/max_min.md)
  [`Summary(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/max_min.md)
  [`Summary(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/max_min.md)
  :

  Minimum, maximum or range of `datey` or `durationy`

## `datey_interval`

- [`datey_interval()`](https://r-datey.logmu.org/reference/datey_interval.md)
  [`` `%to%` ``](https://r-datey.logmu.org/reference/datey_interval.md)
  :

  Create a `datey_interval`

- [`is_proper()`](https://r-datey.logmu.org/reference/interval_nature.md)
  [`all_proper()`](https://r-datey.logmu.org/reference/interval_nature.md)
  [`is_collapsed()`](https://r-datey.logmu.org/reference/interval_nature.md)
  [`all_collapsed()`](https://r-datey.logmu.org/reference/interval_nature.md)
  [`any_collapsed()`](https://r-datey.logmu.org/reference/interval_nature.md)
  :

  Properties of a `datey_interval`

- [`` `$`( ``*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/interval_properties.md)
  :

  Get the start, end or duration of a `datey_interval`

- [`interval_includes()`](https://r-datey.logmu.org/reference/interval_includes.md)
  [`` `%includes%` ``](https://r-datey.logmu.org/reference/interval_includes.md)
  :

  Whether a `datey_interval` includes a `datey`

- [`all_of_time`](https://r-datey.logmu.org/reference/all_of_time.md) :

  'All of time' — the maximum valid `datey_interval`

## Formatting and printing

- [`as.character(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/text_from_datey.md)
  [`format(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/text_from_datey.md)
  [`print(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/text_from_datey.md)
  :

  Format or print a `datey`

- [`as.character(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/text_from_durationy.md)
  [`format(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/text_from_durationy.md)
  [`print(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/text_from_durationy.md)
  :

  Format or print a `durationy`

- [`as.character(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/text_from_datey_interval.md)
  [`format(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/text_from_datey_interval.md)
  [`print(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/text_from_datey_interval.md)
  :

  Format or print a `datey_interval`

## NA handling

- [`is.na(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/is_NA.md)
  [`anyNA(`*`<datey>`*`)`](https://r-datey.logmu.org/reference/is_NA.md)
  [`is.na(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/is_NA.md)
  [`anyNA(`*`<datey_interval>`*`)`](https://r-datey.logmu.org/reference/is_NA.md)
  [`is.na(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/is_NA.md)
  [`anyNA(`*`<durationy>`*`)`](https://r-datey.logmu.org/reference/is_NA.md)
  :

  Whether `datey`, `durationy` or `datey_interval` are NA

- [`NA_datey_`](https://r-datey.logmu.org/reference/NAs.md)
  [`NA_datey_interval_`](https://r-datey.logmu.org/reference/NAs.md)
  [`NA_durationy_`](https://r-datey.logmu.org/reference/NAs.md) :

  The `datey`, `durationy` and `datey_interval` versions of NA

- [`valid_years_start`](https://r-datey.logmu.org/reference/integer_constants.md)
  [`valid_years_end`](https://r-datey.logmu.org/reference/integer_constants.md)
  [`valid_duration_years_max`](https://r-datey.logmu.org/reference/integer_constants.md)
  : Integer constants
