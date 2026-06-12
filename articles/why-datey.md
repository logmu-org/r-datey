# Why datey?

``` r

library(datey)
```

## Years are the unit, but dates are the data

Mortality rates, valuation assumptions and many other actuarial
quantities are defined *per year*. The data they are applied to – dates
of birth, dates of death, policy anniversaries, valuation dates – are
measured in days.

Converting between the two seems like it should be trivial, but it
isn’t.

- Consider “add one year to 2024‑02‑29”. There is no date 2025‑02‑29, so
  what should the answer be – 2025‑02‑28 or 2025‑03‑01? Both are
  defensible, and different tools (and different people) choose
  differently.

- Now consider two consecutive “add half a year” steps starting from
  2000‑01‑01: do they land on the same date as a single “add one year”
  step? With most day-based arithmetic, the answer is no – the result
  depends on *how* you split the year up, and on the order in which you
  do the additions.

For a single *ad hoc* calculation this kind of ambiguity is a curiosity.
For an actuarial model that combines exposure periods, runs
sensitivities, and is reconciled and audited, it’s a problem: the same
logical calculation, expressed two different but equivalent ways, can
produce two different numbers.

## **datey**’s answer: a fixed annual grid

**datey** does not try to be a general-purpose calendar library –
packages like [clock](https://clock.r-lib.org/) and
[lubridate](https://lubridate.tidyverse.org/) already do that, with full
support for time zones, locales, calendar arithmetic and so on.

Instead, **datey** picks *one* standardised, precise mapping from dates
onto an annual grid, and guarantees that arithmetic on that grid is
exact and associative. Every `datey` and `durationy` is stored
internally as a count of *clicks*, where a click is 1 / 534 360 of a
year (chosen so that 1/365 and 1/366 of a year, and useful fractions of
days and years, are represented exactly). With this approach, date and
duration calculations reduce to plain old integer arithmetic on clicks.

The practical consequence is that the two-steps-vs-one-step problem
above simply does not arise:

``` r

start <- start_day(2000, 1, 1)

half_year <- durationy(0.5)
two_steps <- (start + half_year) + half_year
one_step    <- start + (half_year + half_year)

two_steps
#> [1] 2001-01-01.0
one_step
#> [1] 2001-01-01.0
identical(two_steps, one_step)
#> [1] TRUE
```

`(a + d1) + d2 == a + (d1 + d2)` for any `datey` `a` and `durationy`s
`d1`, `d2` – always, exactly, regardless of leap years or the order of
operations. That’s the guarantee **datey** is built around, and the
[specification](https://logmu-org.github.io/r-datey/articles/spec.md)
sets it out precisely.

## Interval algebra for rate periods

Actuarial calculations very often involve asking “for how much of this
period did rate X apply?” – e.g. combining a policy’s time at risk with
the period over which a particular assumption set is valid.

**datey** represents time intervals as `datey_interval`s, written
`start %to% end`. These are half-open, i.e. `[start, end)`, intervals,
which means consecutive periods interlock precisely without gaps or
double-counting.

**datey** provides interval algebra to work with time intervals
directly:

``` r

time_at_risk <- start_day(2023, 4, 1) %to% end_day(2024, 4, 1)
rate_period_2024 <- start_day(2024, 1, 1) %to% end_day(2025, 12, 31)

# the part of the time at risk to which the 2024 rate applies
overlap <- time_at_risk & rate_period_2024
overlap
#> [1] [2024-01-01.0, 2024-04-02.0)

# ... as a duration in years, ready to multiply by an annual rate
durationy(overlap$end - overlap$start)
#> [1] 0.251366 yr
```

## Standardised day-fractions for exposure calculations

Because a `datey` can represent a position *within* a day (as a fraction
of a year), **datey** provides
[`start_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md),
[`mid_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
and
[`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
for the three points within a day that come up most often:

- [`start_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  – the day is *included* from its start. Use this e.g. for the start of
  a period at risk.
- [`end_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  – the day is included up to and including its end. This is often how
  the end of risk periods are specified.
- [`mid_day()`](https://logmu-org.github.io/r-datey/reference/xxx_day.md)
  – on average, an event such as death occurs halfway through the day it
  is recorded on.

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

## What **datey** deliberately leaves out

To keep the guarantees above simple and dependable, **datey** is very
narrowly scoped. It is *not* the right tool for:

- General date arithmetic for output, e.g. “what date is 3 months from
  now” for a calendar shown to a user – use `clock` or `lubridate`.
- Parsing or formatting dates beyond the simple `YYYY-MM-DD[.fff]`
  representation – again, `clock`/`lubridate`, or
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)/[`format()`](https://rdrr.io/r/base/format.html).
- Time zones, daylight saving time, leap seconds, or any calendar other
  than the proleptic Gregorian calendar.

The trade-off is deliberate: by refusing to be a general date library,
**datey** can make a precise, associative annual grid *the*
representation for rate-related calculations, with one well-defined
answer regardless of how the calculation is structured.
