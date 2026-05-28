# Format or print a `datey`

A `datey` is printed as either

- `YYYY-MM-DD`, i.e. ISO 8601 extended date format, or

- `YYYY-MM-DD.FFF` where `.FFF` is the day fraction part

If `include_day_fraction` is `TRUE` then `.FFF` is included even if it
is 0.

Note that a `datey` created as the end of a day (or with day fraction 1)
will print as the start of the following day.

## Usage

``` r
# S3 method for class 'datey'
as.character(x, ...)

# S3 method for class 'datey'
format(x, include_day_fraction = TRUE, ...)

# S3 method for class 'datey'
print(x, include_day_fraction = TRUE, max = NULL, ...)
```

## Arguments

- x:

  The `datey` to print or format.

- ...:

  Other arguments.

- include_day_fraction:

  Whether to include the fractional day part. Defaults to `FALSE`.

- max:

  Numeric or `NULL`, specifying the maximal number of entries to be
  printed. When `NULL`, `getOption("max.print")` used. Defaults to
  `NULL`.
