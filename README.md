
<!--
**Make sure you're editing README.Rmd, *not* README.md!!**
(README.md is generated from README.Rmd.)
&#10;After changing this file, run `devtools::build_readme()`!!
-->

# datey <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

<!-- badges: end -->

The **datey** package provides a standardised mapping of dates onto an
annual grid together with performant date and duration-related
arithmetic.

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

2.  **Fixed precision arithmetic.** This excludes classes of bug related
    to the imprecision of floating point arithmetic\[^FloatingPoint\].
    These are sufficiently common to justify [a CRAN
    FAQ](https://cran.r-project.org/doc/FAQ/R-FAQ.html#Why-doesn_0027t-R-think-these-numbers-are-equal_003f)
    and, in a mortality-specific context, [Terry Therneau’s
    note](https://cran.r-project.org/web/packages/survival/vignettes/tiedtimes.pdf)
    on the problems floating point causes in the context of the R surv
    package.[^1]

3.  Handling the often-overlooked issue of **whether a date means the
    start, during or end of a day**. This may seem trivial but
    systematic errors in relation to this issue can accumulate.

For more detail on the motivation for **datey**, see [Why
**datey**?](https://logmu-org.github.io/r-datey/articles/why-datey.html).

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
started](https://logmu-org.github.io/r-datey/articles/datey.html). <!--

What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so:


``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots in the man/figures folder, for example:

<img src="man/figures/README-pressure-1.png" alt="" width="100%" />

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN.
-->

[^1]: That author’s preferred solution is to use day counts, which is
    also a fixed precision approach.
