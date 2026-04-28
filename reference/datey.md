# Create a `datey`

Create a `datey` from a year, month, day and, optionally, a
day-fraction.

In general, prefer the explicit `start_day()`, `mid_day()` and
`end_day()` versions.

To deconstruct a `datey`, use
[`as_ymdf()`](http://logmu-org.github.io/r-datey/reference/as_ymdf.md).

## Usage

``` r
datey(year, month, day, day_fraction)

start_day(year, month, day)

mid_day(year, month, day)

end_day(year, month, day)
```

## Arguments

- year:

  Calendar year. Valid years are from 1000 (inclusive) to 3000
  (exclusive). Doubles are truncated to integers.

- month:

  Month number in calendar year, with 1 representing January. Doubles
  are truncated to integers.

- day:

  Day number in month, with 1 representing the first day of the month.
  Doubles are truncated to integers.

- day_fraction:

  The fraction of the day, in \[0,1\]. 0 means the start of the day, 0.5
  means the middle of the day, and 1 means the end of the day (which is
  identical to the start of the next day).
