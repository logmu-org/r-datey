# Format or print a `datey`

A `datey` is printed as either

- `YYYY-MM-DD`, i.e. ISO 8601 extended date format, or

- `YYYY-MM-DD.F...` where `.F...` is the day fraction part.

If `include_day_fraction` is `TRUE` then `[.F...]` is included even if
it is 0 (i.e. `.0`).

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

  Whether to include the fractional day part. Defaults to `TRUE`.

- max:

  Numeric or `NULL`, specifying the maximal number of entries to be
  printed. When `NULL`, `getOption("max.print")` used. Defaults to
  `NULL`.

## Value

`as.character` and `format` return a vector of `character`. `print`
invisibly returns `x`.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md)

## Examples

``` r
start      <- start_day(2001, 2, 3)
fractional <- datey(    2001, 2, 3, day_fraction = 0.4444)
mid        <- mid_day(  2001, 2, 3)
end        <- end_day(  2001, 2, 3)

format(start)                               # "2001-02-03.0"
#> [1] "2001-02-03.0"
format(start, include_day_fraction = FALSE) # "2001-02-03"
#> [1] "2001-02-03"
format(fractional)                          # "2001-02-03.4447"
#> [1] "2001-02-03.4447"
format(mid)                                 # "2001-02-03.5"
#> [1] "2001-02-03.5"
format(end)                                 # "2001-02-04.0"
#> [1] "2001-02-04.0"
```
