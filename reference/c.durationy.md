# Concatenate `durationy` vectors

Combines (flattens) `durationy` vectors.

If the first element in `c(...)` is not a `durationy` then this method
will not be called. For instance, `c(NA, as_durationy(1))` is *not* a
`durationy`.

## Usage

``` r
# S3 method for class 'durationy'
c(..., recursive = FALSE)
```

## Arguments

- ...:

  The items to combine

- recursive:

  Unused.

## Value

[`c()`](https://rdrr.io/r/base/c.html) returns a vector of `durationy`s.

\[cbind()\] and \[rbind()\] return a matrix, data.frame or list with
dimensions

## Note

R currently only dispatches generic `c` to method `c.durationy` if the
first argument is a `durationy`.

## Examples

``` r
  c(as_durationy(1), as_durationy("2.5 yr"))
#> [1] 1 yr   2.5 yr
```
