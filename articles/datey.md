# Get started with datey

``` r

library(datey)
```

This vignette is a hands-on guide to the **datey** package. For the
motivation behind the annual-grid approach and the associativity
guarantee, see [Why
**datey**?](https://r-datey.logmu.org/articles/why-datey.md). For the
complete formal specification, see the [**datey**
specification](https://r-datey.logmu.org/articles/spec.md).

## The core types

**datey** provides three S3 classes:

- **`datey`** – a point in time, stored at day-fraction precision.
- **`durationy`** – a duration in years.
- **`datey_interval`** – a half-open `[start, end)` time interval.

These are atomic types[^1] that store dates and durations as integers
with units of 1/534 360 of a year). As a result, arithmetic with these
types is exact and associative.

## Creating a `datey`

### When in the day?

Exposure periods specified by the dates to typically mean that the whole
of the day and the whole of the day are included. In the **datey**
system this corresponds to using
[`start_day()`](https://r-datey.logmu.org/reference/datey.md) for and
[`end_day()`](https://r-datey.logmu.org/reference/datey.md) for .

Deaths on the other hand typically happen *during* a day. In the
**datey** system this corresponds to using
[`mid_day()`](https://r-datey.logmu.org/reference/datey.md).

These distinctions may be new to you and your first reaction may be that
they are immaterial. But it costs very little to be precise and
sometimes systematic errors can accumulate and end up being material.

### From year, month and day

[`start_day()`](https://r-datey.logmu.org/reference/datey.md),
[`mid_day()`](https://r-datey.logmu.org/reference/datey.md) and
[`end_day()`](https://r-datey.logmu.org/reference/datey.md) create a
`datey` from scratch:

``` r

start_day(2024, 3, 7)   # start of 7 March 2024
#> [1] 2024-03-07.0
mid_day(2024, 3, 7)     # middle of 7 March 2024
#> [1] 2024-03-07.5
end_day(2024, 3, 7)     # end of 7 March 2024
#> [1] 2024-03-08.0
```

The end of a day is the same point as the start of the next, so
[`end_day()`](https://r-datey.logmu.org/reference/datey.md) applied to a
day is identical to
[`start_day()`](https://r-datey.logmu.org/reference/datey.md) applied to
the following day:

``` r

identical(end_day(2024, 3, 7), start_day(2024, 3, 8))
#> [1] TRUE
```

For an arbitrary position within a day,
[`datey()`](https://r-datey.logmu.org/reference/datey.md) accepts a day
fraction between 0 and 1:

``` r

datey(2024, 3, 7, 0.25)   # one quarter of the way through 7 March 2024
#> [1] 2024-03-07.25
```

### From base R dates

It is often the case that data already contains dates defined using the
standard base R types `Date`[^2], `POSIXct` or `POSIXlt`.

To convert these to a `datey`, use
[`start_day()`](https://r-datey.logmu.org/reference/datey.md),
[`mid_day()`](https://r-datey.logmu.org/reference/datey.md) or
[`end_day()`](https://r-datey.logmu.org/reference/datey.md):

``` r

d <- as.Date("2024-03-07")
start_day(d)
#> [1] 2024-03-07.0
mid_day(d)
#> [1] 2024-03-07.5
end_day(d)
#> [1] 2024-03-08.0
```

### From fractional years or text

[`datey()`](https://r-datey.logmu.org/reference/datey.md) also accepts a
fractional calendar year or a character string in `YYYY-MM-DD[.f]`
format:

``` r

datey(2024)     # start of 2024
#> [1] 2024-01-01.0
datey(2024.5)   # halfway through 2024
#> [1] 2024-07-02.0

datey("2024-03-07")   # start of 7 March 2024 (day fraction defaults to 0)
#> [1] 2024-03-07.0
datey("2024-03-07.5") # middle of 7 March 2024
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

If you need several components at once, it is more efficient to use
[`to_ymdf()`](https://r-datey.logmu.org/reference/datey_components.md)
instead:

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

[`is_start_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md)
and [`is_mid_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md)
test the position within the day. Note that
[`end_day()`](https://r-datey.logmu.org/reference/datey.md) produces a
`datey` at the start of the following day, so it tests as
[`is_start_day()`](https://r-datey.logmu.org/reference/is_xxx_day.md):

``` r

is_start_day(start_day(2024, 3, 7))     # TRUE
#> [1] TRUE
is_mid_day(mid_day(2024, 3, 7))         # TRUE
#> [1] TRUE
is_start_day(end_day(2024, 3, 7))       # TRUE because end = start of next day
#> [1] TRUE
is_mid_day(datey(2024, 3, 7, 0.25)) # FALSE
#> [1] FALSE
```

## Creating a `durationy`

`durationy`s typically arise as `datey` differences:

``` r

dob <- start_day(as.Date("1965-09-12"))
dod <- mid_day(2024, 3, 7)
age <- dod - dob
age
#> [1] 58.485804 yr
```

You can create them explicitly using
[`durationy()`](https://r-datey.logmu.org/reference/durationy.md), which
accepts a number of years:

``` r

durationy(1)      # one year
#> [1] 1 yr
durationy(0.5)    # half a year
#> [1] 0.5 yr
durationy(-2.5)   # two and a half years in the past
#> [1] −2.5 yr
```

And you can convert them back to numerics using
[`as.double()`](https://rdrr.io/r/base/double.html), which gives the
duration as years, and
[`as.integer()`](https://rdrr.io/r/base/integer.html), which truncates
toward zero:

``` r

as.double(age)
#> [1] 58.4858
as.integer(age)   # whole years only
#> [1] 58
```

## Comparisons and arithmetic

A number of arithmetic operations are available for `datey`, `durationy`
and `datey_interval`.

Beware that not all combinations are valid because, for instance, it
doesn’t make sense to add two dates together.

The table below summarises the valid arithmetic and comparison
operations. All arithmetic is carried out as exact integer arithmetic on
the underlying click counts, so the results are exact and associative.

| Left             | Op                | Right            | Result           |
|:-----------------|:------------------|:-----------------|:-----------------|
| `datey`          | `-`               | `datey`          | `durationy`      |
| `datey`          | `+ -`             | `durationy`      | `datey`          |
| `durationy`      | `+`               | `datey`          | `datey`          |
| `durationy`      | `+ -`             | `durationy`      | `durationy`      |
| `datey`          | `== != < <= > >=` | `datey`          | `logical`        |
| `durationy`      | `== != < <= > >=` | `durationy`      | `logical`        |
| `datey`          | `%to%`            | `datey`          | `datey_interval` |
| `datey_interval` | `== !=`           | `datey_interval` | `logical`        |
| `datey_interval` | `%includes%`      | `datey`          | `logical`        |
| `datey_interval` | `&`               | `datey_interval` | `datey_interval` |

``` r

start  <- start_day(2000, 1, 1)
one_yr <- durationy(1)
qtr_yr <- durationy(0.25)

start + one_yr    # one year later
#> [1] 2001-01-01.0
start - qtr_yr    # a quarter of a year earlier
#> [1] 1999-10-01.75

one_yr - qtr_yr   # three quarters of a year
#> [1] 0.75 yr
one_yr + qtr_yr
#> [1] 1.25 yr

datey(2024) < datey(2025)     # TRUE
#> [1] TRUE
durationy(1) > durationy(0.5) # TRUE
#> [1] TRUE
```

You can also do mixed arithmetic with `datey` and `durationy` and
numbers, in which case `datey`s and `durationy`s are first converted to
`double`s:

``` r

identical(datey(2000) + 25, 2025)     # TRUE
#> [1] TRUE
identical(durationy(2) * 0.05, 0.10)  # TRUE
#> [1] TRUE
```

## `datey_interval` – representing a time period

A `datey_interval` is a half-open `[start, end)` interval. Create one
with
[`datey_interval()`](https://r-datey.logmu.org/reference/datey_interval.md)
or the `%to%` operator:

``` r

a  <- start_day(2024, 1, 1)
b  <- start_day(2025, 1, 1)
interval <- a %to% b
interval
#> [1] [2024-01-01.0, 2025-01-01.0)
```

The `$start`, `$end` and `$duration` properties extract the interval’s
components:

``` r

interval$start
#> [1] 2024-01-01.0
interval$end
#> [1] 2025-01-01.0
interval$duration
#> [1] 1 yr
```

[`durationy()`](https://r-datey.logmu.org/reference/durationy.md)
accepts a `datey_interval` directly:

``` r

durationy(interval)
#> [1] 1 yr
```

### Interval membership testing

`%includes%` tests whether a `datey` falls inside the interval. The
interval includes its start and excludes its end:

``` r

interval %includes% a                     # TRUE  -- start is included
#> [1] TRUE
interval %includes% b                     # FALSE -- end is excluded
#> [1] FALSE
interval %includes% mid_day(2024, 6, 15)  # TRUE
#> [1] TRUE
```

### Interval properties

[`is_proper()`](https://r-datey.logmu.org/reference/interval_nature.md)
returns `TRUE` when start ≤ end;
[`is_collapsed()`](https://r-datey.logmu.org/reference/interval_nature.md)
returns `TRUE` when start ≥ end. A point interval `[a, a)` is both
proper and collapsed (it contains no time):

``` r

is_proper(interval)    # TRUE because start <= end
#> [1] TRUE
is_collapsed(interval) # FALSE because start < end
#> [1] FALSE

pt <- a %to% a         # empty (point) interval
is_proper(pt)          # TRUE because a <= a
#> [1] TRUE
is_collapsed(pt)       # TRUE because a >= a
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

overlap$duration  # exposure in calendar year 2024, in years
#> [1] 0.497268 yr
```

## NA values

Throughout the **datey** package, `NA` will cause an error when used
where a `datey_`, `durationy_` or `datey_interval_` is expected. This is
because its type is `logical` and potentially indicates user error.

If you want an NA value with a **datey** system type, use `NA_datey_`,
`NA_durationy_` or `NA_datey_interval_` as appropriate.

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

[`seq()`](https://r-datey.logmu.org/reference/seq.md),
[`min()`](https://rdrr.io/r/base/Extremes.html),
[`max()`](https://rdrr.io/r/base/Extremes.html),
[`range()`](https://rdrr.io/r/base/range.html) and
[`mean()`](https://r-datey.logmu.org/reference/mean.md) all work on
`datey` and `durationy` vectors:

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

[^1]: Even though `datey_interval` stores the start and the end of a
    time interval, it too is atomic, which means that `datey_interval`s
    can be stored in a single vector without any additional special
    handling.

[^2]: Even though the `Date` type is not designed for fractional dates,
    it typically uses floating point under the covers, and can
    unintentionally end up with a fractional value e.g. by taking a mean
    of `Date`s. For this reason, a `day_fraction` argument is always
    required for a `Date`.
