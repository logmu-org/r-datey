# datey 0.1.1

- Fixed undefined behaviour (negation of `NA_INTEGER`) when parsing `durationy`
  from text in C++. Results are unaffected on conforming hardware.


# datey 0.1.0

Initial CRAN release.

- `datey` and `durationy` represent dates and durations on a discrete annual 
  grid, with exact, associative arithmetic (`+`, `-`, comparisons,
  `mean()`, `range()`, etc.).
- `start_day()`, `mid_day()`, `end_day()` and `datey()` map calendar
  year/month/day (and day-fraction), fractional years and 
  `Date`, `POSIXct`, `POSIXlt` to `datey`.
- `to_ymdf()` and `$year`, `$month`, `$day` and `$day_fraction` provide the 
  breakdown of a `datey` into year, month, day and day fraction components.
- `is_start_day()` and `is_mid_day()` provides checking of `datey` alignment.
- `as.double()` and `as.integer()` provide convenient conversion to numeric
  types as years, with mixed number and `datey`/`durationy` arithmetic adhering
  to the same convention using implicit conversion.
- `NA_datey_`, `NA_durationy_` and `NA_datey_interval_` provide type-correct
  `NA`s, with full `is.na()`/`anyNA()` support.
- Text parsing and formatting for `datey`, `durationy` and `datey_interval`.
- `pillar_shaft()` methods for readable printing of `datey`/`durationy`/
  `datey_interval` columns in tibbles.
- `is_leap_year()` for integer years and `datey`s.
- `datey_interval` (constructed with `datey_interval()` or `%to%`) represents
  a half-open `[start, end)` date interval. Operations include:
  - `==` and `!=` for equality comparison.
  - `%includes%` (or `interval_includes()`) to test whether an interval contains
    a `datey` or numeric value.
  - `&` for intersection: returns an empty collapsed interval for adjacent
    intervals, `NA_datey_interval_` for non-intersecting non-adjacent intervals.
  - `is_collapsed()`, `is_proper()` and related predicates.
  - Constants `all_of_time` and `NA_datey_interval_`.
- `seq()` is supported for `datey` and `durationy` via a `by` argument
  (note: `length.out` is not supported).
