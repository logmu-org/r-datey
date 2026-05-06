# A `datey` as years

A `datey` converted to years.

For example,

- the *start* of 2000-01-01 (or, equivalently, the *end* of 1999-12-31),
  results in `2000`, and

- the *middle* of the calendar year 2000 results in `2000.5`.

A `datey` converted to integer years.

For example, 2000-01-01.0 and 2000-12-31.0 both result in `2000`.

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

  Further arguments to be passed from or to other methods.
