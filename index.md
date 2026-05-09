# datey

**datey** provides a standard mapping of dates onto an annual grid.

This matters in contexts where the primary unit is years and where
definitions need to be precise.

A classic example is actuarial mortality experience analysis or
valuation of life assurance and annuities. Mortality rates are defined
*per annum* but experience and valuation data is usually defined using
dates (i.e. days).

The benefits of using **datey** are:

1.  A consistent framework for converting dates to and from a uniform
    annual grid based on the most common approach.

2.  Handling the often-overlooked issue of whether a date means the
    start, during or end of a day.

3.  Fixed precision arithmetic, which excludes bugs relating to floating
    point arithmetic[^1].

If you are mixing annual rates and dates, and working primarily in the
annual domain, then it is worth considering using **datey**.

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
