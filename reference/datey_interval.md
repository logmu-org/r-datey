# Create a `datey_interval`

Creates a `datey_interval`, a closed-open ('clopen') interval \[`start`,
`end`).

A `datey` `t` in included in the interval if `start` \<= t \< `end`.

There are two syntaxes to create a `datey_interval` from `start` and
`end`:

- operator: `start %to% end`

- function: `datey_interval(start, end)`

in which `start` and `end` are `datey` or numeric (interpreted as
years). These are equivalent other than `strict` is always on for the
operator version. The lengths of vector arguments must be multiples of
each other.

A `datey_interval` can also be created from `logical`, mapping

- `TRUE` to \[1000,3000), which is referred to as 'all of time' in
  **datey** documentation, and

- `FALSE` and `NA` to `NA_datey_interval_`.

Arguments *of the correct type* but which are NA result in
`NA_datey_interval_` – they do not stop execution (regardless of
`strict`).

Common operations on intervals are

- testing for *inclusion*, i.e. with an interval includes a date –
  `interval %includes% t`, and

- obtaining the *intersection*, which uses the `&` operator –
  `interval_a & interval b`.

## Usage

``` r
datey_interval(x, ...)

# Default S3 method
datey_interval(x, ...)

# S3 method for class 'datey_interval'
datey_interval(x, ...)

# S3 method for class 'logical'
datey_interval(x, ...)

# S3 method for class 'datey'
datey_interval(x, end, strict = TRUE, ...)

# S3 method for class 'double'
datey_interval(x, end, strict = TRUE, ...)

# S3 method for class 'integer'
datey_interval(x, end, strict = TRUE, ...)

start %to% end
```

## Arguments

- x:

  Argument to S3 method `datey_interval()`. If `x` is a `datey` then it
  represents the start (inclusive) of an interval and an `end` argument
  is also required. If `x` is a `logical` then it is mapped to 'all of
  time' or `NA_datey_interval_`.

- ...:

  Not used.

- strict:

  How invalid *non-NA* `datey` inputs should be handled. If `strict` is
  `TRUE` – the default – then execution is stopped. If `strict` is
  `FALSE` then `NA` is returned.

- start, end:

  The start (inclusive) and end of the interval (exclusive). These can
  be any type that is convertible to a `datey`.

## Value

A vector of `datey_interval`.

## See also

[interval_properties](https://r-datey.logmu.org/reference/interval_properties.md),
[interval_nature](https://r-datey.logmu.org/reference/interval_nature.md),
[interval_includes](https://r-datey.logmu.org/reference/interval_includes.md),
[all_of_time](https://r-datey.logmu.org/reference/all_of_time.md),
[durationy](https://r-datey.logmu.org/reference/durationy.md),
[ops](https://r-datey.logmu.org/reference/ops.md),
[is_NA](https://r-datey.logmu.org/reference/is_NA.md),
[`vignette("datey", package = "datey")`](https://r-datey.logmu.org/articles/datey.md)
for a worked introduction

## Examples

``` r
start <- datey(2000)
end <- datey(2001)
interval <- start %to% end
interval  # [2000-01-01.0, 2001-01-01.0)
#> [1] [2000-01-01.0, 2001-01-01.0)

# Alternative functional syntax:
identical(interval, datey_interval(start, end)) # TRUE
#> [1] TRUE

# Can use numeric arguments:
2000 %to% 2001  # [2000-01-01.0, 2001-01-01.0)
#> [1] [2000-01-01.0, 2001-01-01.0)

# Can use vector arguments:
2000 %to% 2001:2003 # Vector of 3 intervals
#> [1] [2000-01-01.0, 2001-01-01.0) [2000-01-01.0, 2002-01-01.0)
#> [3] [2000-01-01.0, 2003-01-01.0)

# Logical values are mapped to 'all of time' or `NA_datey_interval_`:
datey_interval(c(TRUE, FALSE, NA)) # [1000-01-01.0, 3000-01-01.0) <NA> <NA>
#> [1] [1000-01-01.0, 3000-01-01.0) <NA>                        
#> [3] <NA>                        

# Test for inclusion in [start, end):
interval %includes% mid_day(1999, 12, 31) # FALSE
#> [1] FALSE
interval %includes% start                 # TRUE -- start *is* included
#> [1] TRUE
interval %includes% datey(2000.5)         # TRUE
#> [1] TRUE
interval %includes% end                   # FALSE -- end is *not* included
#> [1] FALSE

# Obtain the intersection of two intervals
interval2 <- start_day(2000, 12, 1) %to% 2010
interval & interval2  # [2000-12-01.0, 2001-01-01.0)
#> [1] [2000-12-01.0, 2001-01-01.0)
```
