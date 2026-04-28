# Get year, month day and day fraction for a `datey`

`as_ymdf()` returns a list of the `year`, `month`, `day` and
`day_fraction` breakdown of a `datey`, where

- `year` is an `integer` in \[1000,3000),

- `month` is an `integer` in \[1,12\],

- `day` is an `integer` in \[1,N\], where N is the number of days in the
  month specified by `year` and `month`, and

- `day_fraction` is a `double` in \[0,1) representing the fraction of
  the day, where e.g. 0 means the start and 0.5 means the middle of the
  day.

If the `datey` was constructed using `end_day` or `day_fraction = 1`
then `as_ymdf()` will return the *start* of the *next* day with
`day_fraction = 0`.

## Usage

``` r
as_ymdf(datey)
```

## Arguments

- datey:

  The `datey` to deconstruct.
