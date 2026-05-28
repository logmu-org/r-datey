# Convert a `datey` to calendar years (including fractional part)

Converts a `datey` to calendar years. The fractional part represents the
proportion of the calendar year that has elapsed.

For example,

- the *start* of 2000-01-01 (or, equivalently, the *end* of 1999-12-31),
  results in `2000`, and

- the *middle* of the calendar year 2000 results in `2000.5`.

Note the following:

- [`as.numeric()`](https://rdrr.io/r/base/numeric.html) is the same as
  [`as.double()`](https://rdrr.io/r/base/double.html).

- [`as.integer()`](https://rdrr.io/r/base/integer.html) gives the
  calendar year, e.g. `as.integer(datey(2000.9))` is `2000`.
  `as.integer(x)` is the same as `as.integer(as.double(x))`.

## Usage

``` r
# S3 method for class 'datey'
as.double(x, ...)

# S3 method for class 'datey'
as.integer(x, ...)
```

## Arguments

- x:

  The `datey` to convert to years.

- ...:

  Other arguments (not used in this package).
