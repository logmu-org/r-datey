# The datey specification

``` r

library(datey)
```

## Introduction

The **datey** system is defined such that it can be used safely on a
cross-platform basis.

## Types

There are two types:

- `datey` represents a date in the calendar years 1000 to 2999
  inclusive.
- `durationy` represents a duration with magnitude 2000 years or less.

Both of the above types map to 32-bit two’s complement integers, which
we’ll call *clicks*.

## Fixed precision

The **datey** system uses an annual system where one year is represented
as 534 360 clicks.
