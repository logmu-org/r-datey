# Changelog

## datey 0.1.0

Initial CRAN release.

- `datey` and `durationy` represent dates and durations on a discrete
  annual grid, with exact, associative arithmetic (`+`, `-`,
  comparisons, [`mean()`](https://r-datey.logmu.org/reference/mean.md),
  [`range()`](https://rdrr.io/r/base/range.html), etc.).
- [`start_day()`](https://r-datey.logmu.org/reference/datey.md),
  [`mid_day()`](https://r-datey.logmu.org/reference/datey.md),
  [`end_day()`](https://r-datey.logmu.org/reference/datey.md) and
  [`datey()`](https://r-datey.logmu.org/reference/datey.md) map calendar
  year/month/day (and day-fraction), fractional years and `Date`,
  `POSIXct`, `POSIXlt` to `datey`.
- [`to_ymdf()`](https://r-datey.logmu.org/reference/datey_components.md)
  and `$year`, `$month`, `$day` and `$day_fraction` provide the
  breakdown of a `datey` into year, month, day and day fraction
  components.
- [`is_start_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md)
  and
  [`is_mid_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md)
  provides checking of `datey` alignment.
- [`as.double()`](https://rdrr.io/r/base/double.html) and
  [`as.integer()`](https://rdrr.io/r/base/integer.html) provide
  convenient conversion to numeric types as years, with mixed number and
  `datey`/`durationy` arithmetic adhering to the same convention using
  implicit conversion.
- `NA_datey_`, `NA_durationy_` and `NA_datey_interval_` provide
  type-correct `NA`s, with full
  [`is.na()`](https://rdrr.io/r/base/NA.html)/[`anyNA()`](https://rdrr.io/r/base/NA.html)
  support.
- Text parsing and formatting for `datey`, `durationy` and
  `datey_interval`.
- `pillar_shaft()` methods for readable printing of `datey`/`durationy`/
  `datey_interval` columns in tibbles.
- [`is_leap_year()`](https://r-datey.logmu.org/reference/is_leap_year.md)
  for integer years and `datey`s.
- `datey_interval` (constructed with
  [`datey_interval()`](https://r-datey.logmu.org/reference/datey_interval.md)
  or `%to%`) represents a half-open `[start, end)` date interval.
  Operations include:
  - `==` and `!=` for equality comparison.
  - `%includes%` (or
    [`interval_includes()`](https://r-datey.logmu.org/reference/interval_includes.md))
    to test whether an interval contains a `datey` or numeric value.
  - `&` for intersection: returns an empty collapsed interval for
    adjacent intervals, `NA_datey_interval_` for non-intersecting
    non-adjacent intervals.
  - [`is_collapsed()`](https://r-datey.logmu.org/reference/interval_nature.md),
    [`is_proper()`](https://r-datey.logmu.org/reference/interval_nature.md)
    and related predicates.
  - Constants `all_of_time` and `NA_datey_interval_`.
- [`seq()`](https://r-datey.logmu.org/reference/seq.md) is supported for
  `datey` and `durationy` via a `by` argument (note: `length.out` is not
  supported).
