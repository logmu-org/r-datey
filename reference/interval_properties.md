# Properties of a `datey_interval`

Test whether a `datey_interval` is empty or proper:

- An *empty* interval does not start before its end.

- A *proper* interval does not end before its start.

An NA interval is treated as empty and improper, so these methods are
guaranteed to return `TRUE` or `FALSE` provided the argument is a
`datey_interval`.

## Usage

``` r
is_empty_interval(interval)

is_proper_interval(interval, ignore_NA = FALSE)
```

## Arguments

- interval:

  The `datey_interval` to test.

## Examples

``` r
  a <- datey(1999)
  b <- datey(2000)
  is_empty_interval(a %to% b)
#> [1] FALSE
  is_empty_interval(a %to% a)
#> [1] TRUE
  is_empty_interval(b %to% a)
#> [1] TRUE
  is_empty_interval(NA_datey_interval_)
#> [1] TRUE
  is_proper_interval(a %to% b)
#> [1] TRUE
  is_proper_interval(a %to% a)
#> [1] TRUE
  is_proper_interval(b %to% a)
#> [1] FALSE
  is_proper_interval(NA_datey_interval_)
#> [1] FALSE
```
