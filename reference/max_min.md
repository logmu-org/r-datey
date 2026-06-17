# Minimum, maximum or range of `datey` or `durationy`

Minimum, maximum or range of `datey` or `durationy`

## Usage

``` r
# S3 method for class 'datey'
Summary(..., na.rm = FALSE)

# S3 method for class 'durationy'
Summary(..., na.rm = FALSE)
```

## Arguments

- ...:

  The `datey` or `durationy` arguments.

- na.rm:

  A logical (`TRUE` or `FALSE`) indicating whether NA values should be
  removed before the computation.

## Value

`min` and `max` return a `datey` scalar. `range` returns a two element
`datey` vector, the first element being the minimum and the second the
maximum.

## Examples

``` r
    t <- datey(2000:2003)
    t
#> [1] 2000-01-01.0 2001-01-01.0 2002-01-01.0 2003-01-01.0
    min(t)
#> [1] 2000-01-01.0
    max(t)
#> [1] 2003-01-01.0
    range(t)
#> [1] 2000-01-01.0 2003-01-01.0
```
