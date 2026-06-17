# Package index

## Date and duration methods

- [`start_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  [`mid_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  [`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  :

  Create a `datey` for the start, middle or end of a day

- [`as_start_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
  [`as_mid_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
  [`as_end_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
  :

  Create a `datey` aligned to the start, middle of end of the day
  specified by a fractional calendar year or another date type.

- [`datey()`](https://logmu-org.github.io/r-datey/reference/datey.md) :

  Create a `datey` from a calendar year (including its fractional part)
  or another date type

- [`` `$`( ``*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/datey_properties.md)
  :

  Extract year, month, day or day_fraction from a `datey`

- [`to_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md)
  [`from_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md)
  :

  Create or decompose a `datey` using calendar year, month, day and day
  fraction

- [`durationy()`](https://logmu-org.github.io/r-datey/reference/durationy.md)
  :

  Create a `durationy` from an annual duration

- [`seq(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/seq.md)
  [`seq(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/seq.md)
  :

  Create `datey` or `durationy` sequence vector

## Properties

- [`is_datey()`](https://logmu-org.github.io/r-datey/reference/is_type.md)
  [`is_datey_interval()`](https://logmu-org.github.io/r-datey/reference/is_type.md)
  [`is_durationy()`](https://logmu-org.github.io/r-datey/reference/is_type.md)
  :

  Is `x` a `datey`, `durationy` or `datey_interval`?

- [`is_start_day()`](https://logmu-org.github.io/r-datey/reference/is_xxx_day.md)
  [`is_mid_day()`](https://logmu-org.github.io/r-datey/reference/is_xxx_day.md)
  :

  Is a `datey` the start (or end) or middle of a day?

- [`is_leap_year()`](https://logmu-org.github.io/r-datey/reference/is_leap_year.md)
  :

  Is `x` a leap year?

## Conversion to years

- [`as.double(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_datey.md)
  [`as.integer(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_datey.md)
  :

  Convert a `datey` to calendar years (including fractional part)

- [`as.double(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_durationy.md)
  [`as.integer(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/as_years_durationy.md)
  :

  Convert a `durationy` to duration in years

## Operators and statistics

- [`Ops(`*`<datey_type>`*`)`](https://logmu-org.github.io/r-datey/reference/ops.md)
  :

  Operators for `datey`, `durationy` and `datey_interval`

- [`mean(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/mean.md)
  [`mean(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/mean.md)
  :

  Mean value of `datey` or `durationy`

- [`Summary(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/max_min.md)
  [`Summary(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/max_min.md)
  :

  Minimum, maximum or range of `datey` or `durationy`

## Date intervals

- [`datey_interval()`](https://logmu-org.github.io/r-datey/reference/datey_interval.md)
  [`` `%to%` ``](https://logmu-org.github.io/r-datey/reference/datey_interval.md)
  :

  Create a `datey_interval`

- [`is_proper()`](https://logmu-org.github.io/r-datey/reference/interval_nature.md)
  [`all_proper()`](https://logmu-org.github.io/r-datey/reference/interval_nature.md)
  [`is_collapsed()`](https://logmu-org.github.io/r-datey/reference/interval_nature.md)
  [`all_collapsed()`](https://logmu-org.github.io/r-datey/reference/interval_nature.md)
  [`any_collapsed()`](https://logmu-org.github.io/r-datey/reference/interval_nature.md)
  : Properties of an interval.

- [`` `$`( ``*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/interval_properties.md)
  :

  Get the start, end or duration of a `datey_interval`

- [`interval_includes()`](https://logmu-org.github.io/r-datey/reference/interval_includes.md)
  [`` `%includes%` ``](https://logmu-org.github.io/r-datey/reference/interval_includes.md)
  :

  Whether a `datey_interval` includes a `datey`

- [`all_of_time`](https://logmu-org.github.io/r-datey/reference/all_of_time.md)
  :

  All valid `datey` calendar years, i.e. 1000 to 2999 inclusive.

## Text parsing and printing

- [`datey(`*`<character>`*`)`](https://logmu-org.github.io/r-datey/reference/text_to_datey.md)
  :

  Parse text as a `datey`

- [`durationy(`*`<character>`*`)`](https://logmu-org.github.io/r-datey/reference/text_to_durationy.md)
  :

  Parse text as a `durationy`

- [`as.character(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey.md)
  [`format(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey.md)
  [`print(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey.md)
  :

  Format or print a `datey`

- [`as.character(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_durationy.md)
  [`format(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_durationy.md)
  [`print(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_durationy.md)
  :

  Format or print a `durationy`

- [`as.character(`*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey_interval.md)
  [`format(`*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey_interval.md)
  [`print(`*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/text_from_datey_interval.md)
  :

  Format or print a `datey_interval`

## Utilities

- [`c(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/combine.md)
  [`c(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/combine.md)
  [`c(`*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/combine.md)
  :

  Combine multiple `datey`, `durationy` or `datey_interval` vectors

- [`` `[`( ``*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/subset.md)
  [`` `[`( ``*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/subset.md)
  [`` `[`( ``*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/subset.md)
  [`` `[<-`( ``*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/subset.md)
  [`` `[<-`( ``*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/subset.md)
  [`` `[<-`( ``*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/subset.md)
  :

  Subset `datey`, `durationy` or `datey_interval` vectors

## NA handling

- [`is.na(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`anyNA(`*`<datey>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`is.na(`*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`anyNA(`*`<datey_interval>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`is.na(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  [`anyNA(`*`<durationy>`*`)`](https://logmu-org.github.io/r-datey/reference/is_NA.md)
  :

  Whether `datey` or `durationy` are NA

- [`NA_datey_`](https://logmu-org.github.io/r-datey/reference/NAs.md)
  [`NA_datey_interval_`](https://logmu-org.github.io/r-datey/reference/NAs.md)
  [`NA_durationy_`](https://logmu-org.github.io/r-datey/reference/NAs.md)
  :

  The `datey`, `durationy` and `datey_interval` versions of NA

- [`valid_years_start`](https://logmu-org.github.io/r-datey/reference/integer_constants.md)
  [`valid_years_end`](https://logmu-org.github.io/r-datey/reference/integer_constants.md)
  [`valid_duration_years_max`](https://logmu-org.github.io/r-datey/reference/integer_constants.md)
  : Integer constants
