# Whether a `datey_interval` includes a `datey`

Test whether a `datey_interval`, \\\[a,b)\\, includes a `datey` \\t\\,
i.e. \\a \le t\\ and \\t \lt b\\.

The `%includes%` operator is syntactic sugar for `interval_includes()`.

An NA interval is treated as empty and an NA date is treated as not
being in any interval, so these methods are guaranteed to return `TRUE`
or `FALSE`.

## Usage

``` r
interval_includes(interval, value)

interval %includes% value
```

## Arguments

- interval:

  The `datey_interval`.

- value:

  The `datey` to test for inclusion.

## Value

A vector of `logical` corresponding to whether the interval includes the
value. Always TRUE or FALSE – NAs result in FALSE.

## Examples

``` r
  t_2000 <- datey(2000)
  t_2001 <- datey(2001)
  t_2002 <- datey(2002)
  t_2003 <- datey(2003)
  t_2004 <- datey(2004)

  interval <- t_2000 %to% t_2003
  interval %includes% t_2000
#> [1] TRUE
  interval %includes% t_2001 # Start of interval *is* included
#> [1] TRUE
  interval %includes% t_2002
#> [1] TRUE
  interval %includes% t_2003 # End of interval *not* included
#> [1] FALSE
  interval %includes% t_2004
#> [1] FALSE
  interval %includes% NA_datey_        # NAs are FALSE
#> [1] FALSE
  NA_datey_interval_ %includes% t_2004 # NAs are FALSE
#> [1] FALSE
  interval_includes(NA_datey_interval_, t_2002) # NAs are FALSE
#> [1] FALSE

  # Function syntax:
  interval_includes(interval, t_2002)
#> [1] TRUE
```
