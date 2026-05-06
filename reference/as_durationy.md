# Convert an object to a `durationy`

This is an S3 generic. This package provides methods for the following
classes:

- `integer` – the value is interpreted as the specified number of years.

- `double` – the value is interpreted as the specified number of years,
  rounded to fixed precision of a `durationy`. This means that
  `as_durationy(0.5)` is precise but `as_durationy(0.01)` is not.

- `durationy` – value is unchanged.

## Usage

``` r
as_durationy(x, strict = TRUE, ...)

# Default S3 method
as_durationy(x, strict = TRUE, ...)

# S3 method for class 'durationy'
as_durationy(x, strict = TRUE, ...)

# S3 method for class 'integer'
as_durationy(x, strict = TRUE, ...)

# S3 method for class 'double'
as_durationy(x, strict = TRUE, ...)
```

## Arguments

- x:

  A vector of the S3 class.

- strict:

  How years greater than 2000 in magnitude should be handled.

  - If `strict` is `TRUE` – the default – then execution is stopped.

  - If `strict` is `FALSE` then `NA` is returned.

  (NAs will result in NA regardless of this switch.)

- ...:

  Other arguments (not used in this package).
