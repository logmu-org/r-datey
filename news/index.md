# Changelog

## datey 0.1.0

Initial CRAN release.

- `datey` and `durationy` represent dates and durations on a
  fixed-precision annual grid, with exact, associative arithmetic (`+`,
  `-`, comparisons,
  [`mean()`](https://r-datey.logmu.org/reference/mean.md),
  [`range()`](https://rdrr.io/r/base/range.html), etc.).
- [`start_day()`](https://r-datey.logmu.org/reference/xxx_day.md),
  [`mid_day()`](https://r-datey.logmu.org/reference/xxx_day.md),
  [`end_day()`](https://r-datey.logmu.org/reference/xxx_day.md) and
  [`from_ymdf()`](https://r-datey.logmu.org/reference/ymdf.md) map
  calendar year/month/day (and day-fraction) to a `datey`;
  [`to_ymdf()`](https://r-datey.logmu.org/reference/ymdf.md) and the
  `as_*_day()`/`is_*_day()` helpers provide the reverse mapping and
  checks.
- Conversion to and from `Date`, `POSIXct`, `POSIXlt`, and to/from years
  via
  [`as.double()`](https://rdrr.io/r/base/double.html)/[`as.integer()`](https://rdrr.io/r/base/integer.html).
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
  or `%to%`) represents a half-open `[start, end)` date interval, with
  `%includes%`,
  [`is_collapsed()`](https://r-datey.logmu.org/reference/interval_nature.md),
  [`is_proper()`](https://r-datey.logmu.org/reference/interval_nature.md),
  intersection via `&`, and the constants `all_of_time` and
  `NA_datey_interval_`.
