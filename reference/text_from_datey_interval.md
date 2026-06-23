# Format or print a `datey_interval`

A `datey_interval` is printed as "\[start, end)", where start and end
are printed either as

- `YYYY-MM-DD`, i.e. ISO 8601 extended date format, or

- `YYYY-MM-DD.F...` where `.F...` is the day fraction part.

If `include_day_fraction` is `TRUE` then `[.F...]` is included even if
it is 0 (i.e. `.0`).

## Usage

``` r
# S3 method for class 'datey_interval'
as.character(x, ...)

# S3 method for class 'datey_interval'
format(x, include_day_fraction = TRUE, ...)

# S3 method for class 'datey_interval'
print(x, include_day_fraction = TRUE, max = NULL, ...)
```

## Arguments

- x:

  The `datey_interval` to print or format.

- ...:

  Further arguments to be passed from or to other methods.

- include_day_fraction:

  Whether to include the fractional day part. Defaults to `TRUE`.

- max:

  Numeric or `NULL`, specifying the maximal number of entries to be
  printed. When `NULL`, `getOption("max.print")` used. Defaults to
  `NULL`.

## Value

`as.character` and `format` return a vector of `character`. `print`
invisibly returns `x`.

## See also

[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md)
