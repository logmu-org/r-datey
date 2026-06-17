# datey

The **datey** package provides a standardised mapping of dates onto an
annual grid together with precise date and duration-related arithmetic.

If you work primarily with mortality rates and time intervals defined by
year but your input data uses dates, *and* precision is important, then
it is worth considering using **datey**.

Classic examples are mortality experience analysis and the valuation of
life assurance and annuities. Mortality rates are defined *per annum*
but experience and valuation data is usually defined using dates
(i.e. days).

The benefits of using **datey** are:

1.  **A consistent framework for mapping dates to annual units.** Even
    the mighty
    [CMI](https://www.actuaries.org.uk/learn-and-develop/continuous-mortality-investigation)
    has come a cropper over inconsistencies on this point.

2.  **Fixed precision arithmetic.** This approach excludes some common
    bugs arising from the imprecision of floating point
    arithmetic\[^FloatingPoint\]. This is a sufficiently common problem
    that there is a [CRAN
    FAQ](https://CRAN.R-project.org/doc/FAQ/R-FAQ.html#Why-doesn_0027t-R-think-these-numbers-are-equal_003f)
    on the topic. And, in a mortality-specific context, Terry Therneau
    added a note to his `survival` package on the problems floating
    point can cause[^1].

3.  Handling **whether a date means the start, during or end of a day**.
    This may seem trivial but systematic errors can accumulate and end
    up being material.

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
start <- as_start_day(as.Date("2018-09-12")) # Include *all* start day 
# ... or direct from year/month/day
exit <- mid_day(2024, 3, 7) # Death is mid-day on average
# ... or simply as a fractional calendar year
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

interval$duration * 0.01 # Implicit conversion to years when mixed with numerics
#> [1] 0.05485804
```

A hands-on guide is provided in [Get
started](https://r-datey.logmu.org/articles/datey.html).

[^1]: In R, run
    [`vignette("tiedtimes", package = "survival")`](https://cran.rstudio.com/web/packages/survival/vignettes/tiedtimes.pdf)).
    Interestingly, that author’s preferred solution is to use day
    counts, which is also a fixed precision approach.
