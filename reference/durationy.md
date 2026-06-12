# Create a `durationy` from an annual duration

This package provides methods to create a `durationy` from the
following:

- `integer` – the value is interpreted as the specified number of years.

- `double` – the value is interpreted as the specified number of years,
  rounded to fixed precision of a `durationy`. This means that
  `durationy(0.5)` is precise but `durationy(0.01)` is not.

- `datey_interval` – the duration of the interval.

- `durationy` – value is unchanged.

This is an S3 generic.

## Usage

``` r
durationy(x, strict = TRUE, ...)

# Default S3 method
durationy(x, strict = TRUE, ...)

# S3 method for class 'durationy'
durationy(x, strict = TRUE, ...)

# S3 method for class 'integer'
durationy(x, strict = TRUE, ...)

# S3 method for class 'double'
durationy(x, strict = TRUE, ...)

# S3 method for class 'datey_interval'
durationy(x, strict = TRUE, ...)
```

## Arguments

- x:

  The argument to convert to a `durationy`.

- strict:

  How years greater than 2000 in magnitude should be handled.

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

  NA arguments result in NA (and do not stop execution) regardless of
  `strict`.

- ...:

  Other arguments (not used in this package).
