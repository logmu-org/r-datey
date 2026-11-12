# Why datey?

``` r

library(datey)
```

## Calculating *per annum* rates from *date* input data

Mortality rates, valuation assumptions and many other actuarial
quantities are defined *per year*, but the data they are applied to –
dates of birth, dates of death, policy anniversaries, valuation dates –
are measured in days.

It’s common to treat mapping dates onto an annual scale as trivial, but
consider these two calculations:

- *‘Add half a year’ twice starting from 2000‑01‑01.* Does this land on
  the same point in time as a single ‘add one year’ step? With most
  day-based arithmetic, the answer is no – the result depends on how you
  split the year up, and on the order in which you do the additions.

- *‘Add one year’ to 2024‑02‑29.* There is no 2025‑02‑29, so is it
  2025‑02‑28 or is it 2025‑03‑01? Both are defensible, and different
  tools (and different people) choose differently.

For a single *ad hoc* calculation we usually ignore the ambiguity and do
‘something sensible’. But actuarial modelling typically entails
thousands or even millions of these calculations, and so it is important
to ensure that they produce consistent results.

## An annual grid of *clicks*

**datey** picks a single standardised and precise mapping from dates to
*clicks*, where one click is 1 / 534 360 of a year, a number chosen so
that 1/365 and 1/366 of a year, and useful fractions of days and years,
are represented exactly.

Dates (`datey`) and durations (`durationy`) are stored internally as a
count of *clicks*, which means that date and duration calculations
reduce to plain old integer arithmetic.

The practical import is that the two-steps-vs-one-step problem above
does not arise:

``` r

start <- start_day(2000, 1, 1)

half_year <- durationy(0.5)
two_steps <- (start + half_year) + half_year
one_step  <- start + (half_year + half_year)

two_steps
#> [1] 2001-01-01.0
one_step
#> [1] 2001-01-01.0
identical(two_steps, one_step)
#> [1] TRUE
```

In general, `(a + d1) + d2 == a + (d1 + d2)` for any `datey` `a` and
`durationy`s `d1`, `d2`, regardless of leap years or the order of
operations.

For full details see the [**datey**
specification](https://r-datey.logmu.org/articles/spec.md).

## Fractions of a day

Because a `datey` can represent a position *within* a day (as a fraction
of a year), **datey** provides
[`start_day()`](https://r-datey.logmu.org/reference/datey.md),
[`mid_day()`](https://r-datey.logmu.org/reference/datey.md) and
[`end_day()`](https://r-datey.logmu.org/reference/datey.md) for the
three points within a day that come up most often:

- [`start_day()`](https://r-datey.logmu.org/reference/datey.md) – the
  day is *included* from its start. Use this e.g. for the start of a
  period at risk.
- [`end_day()`](https://r-datey.logmu.org/reference/datey.md) – the day
  is included up to and including its end. This is often how the end of
  risk periods are specified.
- [`mid_day()`](https://r-datey.logmu.org/reference/datey.md) – on
  average, an event such as death occurs halfway through the day it is
  recorded on.

Choosing consistently between these (rather than, say, always using
midnight) improves clarity and accuracy as to what events are and are
not included in a time period.

``` r

y <- 2026L
m <- 1L
d <- 1L
one_day_period <- start_day(y, m, d) %to% end_day(2026, m, d)
one_day_period
#> [1] [2026-01-01.0, 2026-01-02.0)

mid <- mid_day(y, m, d)
mid
#> [1] 2026-01-01.5

interval_includes(one_day_period, mid)
#> [1] TRUE
```

## Interval algebra for time periods

Actuarial calculations often involve asking ‘for how much of this period
did rate X apply?’ – e.g. combining a policy’s time at risk with the
period over which a particular assumption set is valid.

**datey** represents time intervals using the atomic[^1] type
`datey_interval`, created using `start %to% end`. These are half-open,
i.e. `[start, end)`, intervals, which means consecutive periods
interlock precisely without gaps or double-counting.

**datey** provides interval algebra to work with time intervals
directly:

``` r

period_2024 <- datey(2024) %to% datey(2025) # Calendar year 2024

period_2024 %includes% datey(2024) # TRUE
#> [1] TRUE
period_2024 %includes% datey(2025) # FALSE
#> [1] FALSE

time_at_risk <- start_day(2023, 4, 1) %to% end_day(2024, 4, 1)

# the part of the time at risk to which the 2024 rate applies
overlap <- time_at_risk & period_2024
overlap
#> [1] [2024-01-01.0, 2024-04-02.0)

# ... as a duration in years, ready to multiply by an annual rate
durationy(overlap$end - overlap$start)
#> [1] 0.251366 yr
```

## What **datey** is *not* for

**datey** is deliberately narrowly scoped – it is *not* the right tool
for

- general date arithmetic for output, e.g. ‘what date is 3 months from
  now’ for a calendar shown to a user,
- parsing or formatting dates beyond the simple `YYYY-MM-DD[.fff]`
  representation, or
- handling time zones, daylight saving time, leap seconds, or different
  calendars.

If you need that kind of functionality check out packages like
[clock](https://clock.r-lib.org/) and
[lubridate](https://lubridate.tidyverse.org/).

[^1]: Even though `datey_interval` stores the start and end of a time
    interval, it is atomic (as are `datey` and `durationy`), which means
    that `datey_interval`s can be stored in a single R vector without
    any additional special handling.
