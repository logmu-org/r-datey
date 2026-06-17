# Convert a `durationy` to duration in years

Converts a `durationy` to duration in years.

Note the following:

- [`as.numeric()`](https://rdrr.io/r/base/numeric.html) is the same as
  [`as.double()`](https://rdrr.io/r/base/double.html).

- [`as.integer()`](https://rdrr.io/r/base/integer.html) obtains the
  integer part, e.g. `as.integer(durationy(1.9))` is `1` and
  `as.integer(durationy(-1.9))` is `-1`. `as.integer(x)` is the same as
  `as.integer(as.double(x))`.

## Usage

``` r
# S3 method for class 'durationy'
as.double(x, ...)

# S3 method for class 'durationy'
as.integer(x, ...)
```

## Arguments

- x:

  The `durationy` to convert to years.

- ...:

  Other arguments (not used in this package).

## Value

A vector of `double`.
