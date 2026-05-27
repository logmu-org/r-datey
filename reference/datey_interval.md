# Create a `datey_interval`

Creates the `datey_interval` \[`start`, `end`).

The operator syntax may be clearer, i.e. `start %to% end`.

## Usage

``` r
datey_interval(start, end, strict = TRUE)

start %to% end
```

## Arguments

- start, end:

  The start (inclusive) and end of the interval (exclusive). These can
  be any type that is convertible to a `datey`. Must have the same
  numbers of elements or be multiples of each other.

- strict:

  How NAs should be handled.

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned if `start` and/or `end`
    is NA.

## Examples

``` r
  t_1 <- start_day(2001, 1, 1)
  t_2 <- start_day(2002, 2, 2)
  datey_interval(t_1, t_2)
#> [1] [2001-01-01.0, 2002-02-02.0)
  t_1 %to% t_2
#> [1] [2001-01-01.0, 2002-02-02.0)
```
