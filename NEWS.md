# datey 0.1.0

Initial CRAN release.

- `datey` and `durationy` represent dates and durations on a fixed-precision
  annual grid, with exact, associative arithmetic (`+`, `-`, comparisons,
  `mean()`, `range()`, etc.).
- `start_day()`, `mid_day()`, `end_day()` and `from_ymdf()` map calendar
  year/month/day (and day-fraction) to a `datey`; `to_ymdf()` and the
  `as_*_day()`/`is_*_day()` helpers provide the reverse mapping and checks.
- Conversion to and from `Date`, `POSIXct`, `POSIXlt`, and to/from years via
  `as.double()`/`as.integer()`.
- `NA_datey_`, `NA_durationy_` and `NA_datey_interval_` provide type-correct
  `NA`s, with full `is.na()`/`anyNA()` support.
- Text parsing and formatting for `datey`, `durationy` and `datey_interval`.
- `pillar_shaft()` methods for readable printing of `datey`/`durationy`/
  `datey_interval` columns in tibbles.
- `is_leap_year()` for integer years and `datey`s.
- `datey_interval` (constructed with `datey_interval()` or `%to%`) represents
  a half-open `[start, end)` date interval, with `%includes%`,
  `is_collapsed()`, `is_proper()`, intersection via `&`, and the
  constants `all_of_time` and `NA_datey_interval_`.
