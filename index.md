# datey

The **datey** package provides a standardised mapping of dates onto a
discrete annual grid, together with exact date and duration arithmetic.

If you work primarily with mortality rates and time intervals defined by
year but your input data uses dates, *and* precision is important, then
it is worth considering using **datey**.

Classic examples are mortality experience analysis and the valuation of
life assurance and annuities. Mortality rates are defined *per annum*
but experience and valuation data is usually defined using dates
(i.e. days).

The benefits of using **datey** are:

1.  **Standardised mapping of dates to a uniform annual timescale.**
    There is no unique way to map dates to an annual timescale. Without
    standardisation, sooner or later errors will arise.[^1]

2.  **Fixed precision arithmetic.** Using fixed precision excludes
    common bugs arising from the imprecision of floating point
    arithmetic.[^2]

3.  Handling **whether a date means the start, during or end of a day**.
    This issue is usually ignore. But even though in may seem trivial,
    systematic errors can accumulate and end up being material.

For more detail on the motivation for **datey**, see [Why
**datey**?](https://r-datey.logmu.org/articles/why-datey.html).

## Installation

You can install the development version of datey from
[GitHub](https://github.com/) with:

``` r

# install.packages("pak")
pak::pak("logmu-org/r-datey")
```

## Example

``` r

library(datey)

# Create datey from a base R date ...
start <- as_start_day(as.Date("2018-09-12")) # Exposure includes the whole day
# ... or direct from year/month/day
exit <- mid_day(2024, 3, 7) # Death is mid-day on average
# ... or as a fractional calendar year (which will be rounded to grid precision)
t <- datey(2021.234) # A date in the middle of the exposure period

c(start, t, exit) # 2018-09-12.0 2021-03-27.4098 2024-03-07.5
#> [1] 2018-09-12.0    2021-03-27.4098 2024-03-07.5

interval <- start %to% exit # Exposure period
interval # [2018-09-12.0, 2024-03-07.5)
#> [1] [2018-09-12.0, 2024-03-07.5)

interval %includes% t # Test if a point in time is in an interval
#> [1] TRUE

exit - start      # Duration of exposure period
#> [1] 5.485804 yr
interval$duration # Same thing
#> [1] 5.485804 yr

interval$duration * 0.01 # Converted to years when mixed with plain numbers
#> [1] 0.05485804
```

A hands-on guide is provided in [Get
started](https://r-datey.logmu.org/articles/datey.html).

[^1]: Even the highly-regarded
    [CMI](https://www.actuaries.org.uk/learn-and-develop/continuous-mortality-investigation)
    has had issues with inconsistencies on this point within the same
    model.

[^2]: This is a sufficiently common problem that there is a [CRAN
    FAQ](https://CRAN.R-project.org/doc/FAQ/R-FAQ.html#Why-doesn_0027t-R-think-these-numbers-are-equal_003f)
    on the topic.

    In a mortality-adjacent context, Terry Therneau added [this
    note](https://therneau.r-universe.dev/survival/doc/tiedtimes.pdf) to
    his `survival` package on the problems floating point can cause.
    Therneau’s preferred approach is to use integer day counts, which is
    implicitly fixed precision.
