# Get started with datey

``` r

library(datey)
```

This vignette is a hands-on guide to the **datey** package. For the
motivation behind the annual-grid approach and the associativity
guarantee, see [Why
**datey**?](https://logmu-org.github.io/r-datey/articles/why-datey.md).
For the complete formal specification, see the [**datey**
specification](https://logmu-org.github.io/r-datey/articles/spec.md).

## The three types

**datey** provides three S3 classes:

- **`datey`** – a point in time, stored at day-fraction precision.
- **`durationy`** – a duration in years.
- **`datey_interval`** – a half-open `[start, end)` time interval.

All values are stored as exact integers (in units of 1/534 360 of a
year), so arithmetic is both precise and associative.

## Creating a `datey`

### From year, month and day

[`start_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md),
[`mid_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
and
[`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
position a `datey` at the start, middle or end of a calendar day:

``` r

start_day(2024, 3, 7)   # start of 7 March 2024
#> [1] 2024-03-07.0
mid_day(2024, 3, 7)     # middle of 7 March 2024
#> [1] 2024-03-07.5
end_day(2024, 3, 7)     # end of 7 March 2024
#> [1] 2024-03-08.0
```

The end of a day is the same point as the start of the next, so
`end_day(y, m, d)` is always identical to `start_day(y, m, d + 1)`:

``` r

identical(end_day(2024, 3, 7), start_day(2024, 3, 8))
#> [1] TRUE
```

For an arbitrary position within a day,
[`from_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md)
accepts a day fraction between 0 and 1:

``` r

from_ymdf(2024, 3, 7, 0.25)   # one quarter of the way through 7 March 2024
#> [1] 2024-03-07.25
```

### From base R dates

[`as_start_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md),
[`as_mid_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
and
[`as_end_day()`](https://logmu-org.github.io/r-datey/reference/as_xxx_day.md)
convert `Date`, `POSIXct` or `POSIXlt` values, fixing the day fraction:

``` r

d <- as.Date("2024-03-07")
as_start_day(d)
#> [1] 2024-03-07.0
as_mid_day(d)
#> [1] 2024-03-07.5
as_end_day(d)
#> [1] 2024-03-08.0
```

A `Date` carries no time component, so `datey(d)` is equivalent to
`as_start_day(d)`.

### From fractional years or text

[`datey()`](https://logmu-org.github.io/r-datey/reference/datey.md) also
accepts a fractional calendar year or a character string in
`YYYY-MM-DD[.f]` format:

``` r

datey(2024)     # start of 2024
#> [1] 2024-01-01.0
datey(2024.5)   # halfway through 2024
#> [1] 2024-07-02.0

datey("2024-03-07")      # start of 7 March 2024 (day fraction defaults to 0)
#> [1] 2024-03-07.0
datey("2024-03-07.5")    # middle of 7 March 2024
#> [1] 2024-03-07.5
```

## Properties of a `datey`

The `$` operator extracts components of a `datey`:

``` r

t <- mid_day(2024, 3, 7)
t$year
#> [1] 2024
t$month
#> [1] 3
t$day
#> [1] 7
t$day_fraction
#> [1] 0.5
```

When several components are needed at once,
[`to_ymdf()`](https://logmu-org.github.io/r-datey/reference/ymdf.md) is
more efficient:

``` r

to_ymdf(t)
#> $year
#> [1] 2024
#> 
#> $month
#> [1] 3
#> 
#> $day
#> [1] 7
#> 
#> $day_fraction
#> [1] 0.5
```

[`as.double()`](https://rdrr.io/r/base/double.html) converts to a
fractional calendar year;
[`as.integer()`](https://rdrr.io/r/base/integer.html) gives the calendar
year:

``` r

as.double(t)
#> [1] 2024.182
as.integer(t)
#> [1] 2024
```

[`is_start_day()`](https://logmu-org.github.io/r-datey/reference/is_xxx_day.md)
and
[`is_mid_day()`](https://logmu-org.github.io/r-datey/reference/is_xxx_day.md)
test the position within the day. Note that
[`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
produces a `datey` at the start of the following day, so it tests as
[`is_start_day()`](https://logmu-org.github.io/r-datey/reference/is_xxx_day.md):

``` r

is_start_day(start_day(2024, 3, 7))      # TRUE
#> [1] TRUE
is_mid_day(mid_day(2024, 3, 7))          # TRUE
#> [1] TRUE
is_start_day(end_day(2024, 3, 7))        # TRUE: end = start of next day
#> [1] TRUE
is_mid_day(from_ymdf(2024, 3, 7, 0.25)) # FALSE
#> [1] FALSE
```

## Creating a `durationy`

[`durationy()`](https://logmu-org.github.io/r-datey/reference/durationy.md)
accepts a number of years:

``` r

durationy(1)      # one year
#> [1] 1 yr
durationy(0.5)    # half a year
#> [1] 0.5 yr
durationy(-2.5)   # two and a half years in the past
#> [1] −2.5 yr
```

The most natural way to obtain a `durationy` is to subtract two `datey`
values:

``` r

dob <- as_start_day(as.Date("1965-09-12"))
dod <- mid_day(2024, 3, 7)
age <- dod - dob
age
#> [1] 58.485804 yr
```

[`as.double()`](https://rdrr.io/r/base/double.html) gives the duration
as years; [`as.integer()`](https://rdrr.io/r/base/integer.html)
truncates toward zero:

``` r

as.double(age)
#> [1] 58.4858
as.integer(age)   # whole years only
#> [1] 58
```

## Arithmetic

The table below summarises the typed arithmetic operations. All
arithmetic is carried out as exact integer arithmetic on the underlying
click counts, so the results are precise and associative.

|    Left     |        Op         |    Right    |   Result    |
|:-----------:|:-----------------:|:-----------:|:-----------:|
|   `datey`   |        `−`        |   `datey`   | `durationy` |
|   `datey`   |       `+ −`       | `durationy` |   `datey`   |
| `durationy` |        `+`        |   `datey`   |   `datey`   |
| `durationy` |       `+ −`       | `durationy` | `durationy` |
|   `datey`   | `== != < <= > >=` |   `datey`   |   logical   |
| `durationy` | `== != < <= > >=` | `durationy` |   logical   |

``` r

start  <- start_day(2000, 1, 1)
one_yr <- durationy(1)
qtr_yr <- durationy(0.25)

start + one_yr          # one year later
#> [1] 2001-01-01.0
start - qtr_yr          # three months earlier
#> [1] 1999-10-01.75

one_yr - qtr_yr         # three quarters of a year
#> [1] 0.75 yr
one_yr + qtr_yr
#> [1] 1.25 yr

datey(2024) < datey(2025)        # TRUE
#> [1] TRUE
durationy(1) > durationy(0.5)   # TRUE
#> [1] TRUE
```

## `datey_interval` – representing a time period

A `datey_interval` is a half-open `[start, end)` interval. Create one
with
[`datey_interval()`](https://logmu-org.github.io/r-datey/reference/datey_interval.md)
or the `%to%` operator:

``` r

a  <- start_day(2024, 1, 1)
b  <- start_day(2025, 1, 1)
iv <- a %to% b
iv
#> [1] [2024-01-01.0, 2025-01-01.0)
```

The `$start`, `$end` and `$duration` properties extract the interval’s
components:

``` r

iv$start
#> [1] 2024-01-01.0
iv$end
#> [1] 2025-01-01.0
iv$duration
#> [1] 1 yr
```

[`durationy()`](https://logmu-org.github.io/r-datey/reference/durationy.md)
accepts a `datey_interval` directly:

``` r

durationy(iv)
```

### Membership testing

`%includes%` tests whether a `datey` falls inside the interval. The
interval includes its start and excludes its end:

``` r

iv %includes% a                      # TRUE  -- start is included
#> [1] TRUE
iv %includes% b                      # FALSE -- end is excluded
#> [1] FALSE
iv %includes% mid_day(2024, 6, 15)  # TRUE
#> [1] TRUE
```

### Interval properties

[`is_proper()`](https://logmu-org.github.io/r-datey/reference/interval_nature.md)
returns `TRUE` when start ≤ end;
[`is_collapsed()`](https://logmu-org.github.io/r-datey/reference/interval_nature.md)
returns `TRUE` when start ≥ end. A point interval `[a, a)` is both
proper and collapsed (it contains no time):

``` r

is_proper(iv)          # TRUE: start < end
#> [1] TRUE
is_collapsed(iv)       # FALSE
#> [1] FALSE

pt <- a %to% a         # empty (point) interval
is_proper(pt)          # TRUE
#> [1] TRUE
is_collapsed(pt)       # TRUE
#> [1] TRUE
```

### Intersection

The `&` operator returns the intersection of two `datey_interval`s. This
is the most direct way to compute the overlap of two time periods:

``` r

period    <- start_day(2023, 7, 1) %to% end_day(2024, 6, 30)
year_2024 <- start_day(2024, 1, 1) %to% end_day(2024, 12, 31)

overlap <- period & year_2024
overlap
#> [1] [2024-01-01.0, 2024-07-01.0)

durationy(overlap)   # exposure in calendar year 2024, in years
```

## NA values

Each type has a dedicated NA constant:

``` r

NA_datey_
#> [1] <NA>
NA_durationy_
#> [1] <NA>
NA_datey_interval_
#> [1] <NA>
```

[`is.na()`](https://rdrr.io/r/base/NA.html) and
[`anyNA()`](https://rdrr.io/r/base/NA.html) work as expected:

``` r

is.na(NA_datey_)
#> [1] TRUE
anyNA(c(datey(2000), NA_datey_, datey(2024)))
#> [1] TRUE
```

By default (`strict = TRUE`), out-of-range inputs stop execution. With
`strict = FALSE` they become `NA` instead:

``` r

datey(999.9, strict = FALSE)     # below valid range: NA
#> [1] <NA>
durationy(2001, strict = FALSE)  # exceeds 2000-year limit: NA
#> [1] <NA>
```

NA values propagate through arithmetic:

``` r

start_day(2024, 1, 1) + NA_durationy_
#> [1] <NA>
```

## Sequences and statistics

[`seq()`](https://logmu-org.github.io/r-datey/reference/seq.md),
[`min()`](https://rdrr.io/r/base/Extremes.html),
[`max()`](https://rdrr.io/r/base/Extremes.html),
[`range()`](https://rdrr.io/r/base/range.html) and
[`mean()`](https://logmu-org.github.io/r-datey/reference/mean.md) all
work on `datey` and `durationy` vectors:

``` r

dates <- c(datey(2021), datey(2022), datey(2023))

min(dates)
#> [1] 2021-01-01.0
max(dates)
#> [1] 2023-01-01.0
mean(dates)
#> [1] 2022-01-01.0

seq(from = datey(2020), to = datey(2024), by = durationy(2))
#> [1] 2020-01-01.0 2022-01-01.0 2024-01-01.0
```
