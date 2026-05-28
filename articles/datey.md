# Get started with datey

``` r

library(datey)
```

Link to other pages here

There are sound reasons for working in annual units, but it is a
(convenient) fiction because not all years have the same length.

So when we want to convert dates, which are measured in days, to an
annual system, something has to give.

The best we can do is make this conversion well-defined and consistent,
which is what **datey** aims to do.

To this end **datey** adopts what seems to be the most common approach,
which is to treat days as 1/366 of a year in a leap year and 1/365 of a
year otherwise.

More specifically, **datey**

- handles dates from the start of 1000 to the end of 2999,
- accurately represents the start and middle of any day as a fraction of
  a calendar year, and
- accurately represents 1/120 of a calendar year

It achieves this by using fixed precision with units of
1/(4 × 365 × 366) of a year. The full specification is \[here\]\[spec\].

You can convert from standard base R dates `Date`, `POSIXct` and
`POSIXlt`.

Typically use `start_day`, `mid_day` or `end_day`.

Date intervals are \[a,b). Standard because they behave sensibly under
partition, e.g

\[a,c) == \[a,b) + \[b,c) for a ≤ b ≤ c

For instance

- start of E2R is typically included, so use `start_day`.
- if the individual survived then the end of the E2R is also typically
  included, so use `end_day`. This means that if the E2R comprises
  separate periods then they will interlock correctly (E2Rs being
  [measurable](https://timgord.com/2025-08/mortality-measures-matter/#Insight2))
- If the individual died then on average this is during the final day
  and so use `mid_day`.
