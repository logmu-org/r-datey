# datey

The **datey** package provides a standardisd mapping of dates onto an
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

1.  A consistent framework for converting dates to and from a uniform
    annual grid.

2.  Handling the often-overlooked issue of whether a date means the
    start, during or end of a day.

3.  Fixed precision arithmetic, which excludes bugs relating to floating
    point arithmetic[^1].

See

- surv package author’s comments
  [here](https://cran.r-project.org/web/packages/survival/vignettes/tiedtimes.pdf).
  Note that they use days to avoid this issue.

- See [CRAN FAQ
  7.31](https://cran.r-project.org/doc/FAQ/R-FAQ.html#Why-doesn_0027t-R-think-these-numbers-are-equal_003f)

## Installation

You can install the development version of datey from
[GitHub](https://github.com/) with:

``` r

# install.packages("pak")
pak::pak("logmu-org/r-datey")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r

library(datey)
## basic example code
```

[^1]: Specifically, the
    [non-associativity](https://en.wikipedia.org/wiki/Associative_property#Nonassociativity_of_floating-point_calculation)
    of floating point arithmetic.
