# Create a `datey_interval`

Create a `datey_interval` representing \[`start`, `end`).

These are closed-open ('clopen') intervals `start` \<= t \< `end`, i.e.
the interval includes `start` but excludes `end`.

There are two equivalent syntaxes,

- operator: `start %to% end`, and

- function: `datey_interval(start, end)`.

## Usage

``` r
datey_interval(start, end, strict = TRUE)

start %to% end
```

## Arguments

- start, end:

  The start (inclusive) and end of the interval (exclusive). These can
  be any type that is convertible to a `datey`. These have the same
  numbers of elements or their lengths must be multiples of each other.

- strict:

  How NAs should be handled.

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned if `start` and/or `end`
    is NA.

## Examples

``` r
  datey(1999) %to% mid_day(2025, 7, 15)
#> [1] [1999-01-01.0, 2025-07-15.5)
  datey(1999) %to% datey(2000:2002)
#> [1] [1999-01-01.0, 2000-01-01.0) [1999-01-01.0, 2001-01-01.0)
#> [3] [1999-01-01.0, 2002-01-01.0)
```
