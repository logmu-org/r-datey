# Mean value of `datey` or `durationy`

Gets the mean value of a vector of `datey` or `durationy` as a scalar.

This will entail rounding if the mean of the underlying click counts is
not an integer.

## Usage

``` r
# S3 method for class 'datey'
mean(x, ..., na.rm = FALSE)

# S3 method for class 'durationy'
mean(x, ..., na.rm = FALSE)
```

## Arguments

- x:

  The `datey` or `durationy`.

- ...:

  Other arguments (not used in this package).

- na.rm:

  A logical (`TRUE` or `FALSE`) indicating whether NA values should be
  removed before the computation.

## Value

A scalar of `datey` or `duration` as appropriate.

## Examples

``` r
    t <- datey(2000:2003)
    t
#> [1] 2000-01-01.0 2001-01-01.0 2002-01-01.0 2003-01-01.0
    mean(t)
#> [1] 2001-07-02.5
```
