# Concatenate `datey` vectors

Combines (flattens) `datey` vectors.

If the first element in `c(...)` is not a `datey` then this method will
not be called. For instance, `c(NA, datey("2000-01-01.0"))`

## Usage

``` r
# S3 method for class 'datey'
c(..., recursive = FALSE)
```

## Arguments

- ...:

  The items to combine

- recursive:

  Unused.

## Value

[`c()`](https://rdrr.io/r/base/c.html) returns a vector of `datey`s.

\[cbind()\] and \[rbind()\] return a matrix, data.frame or list with
dimensions

## Note

R currently only dispatches generic `c` to method `c.datey` if the first
argument is a `datey`.

## Examples

``` r
  c(datey(2000), datey("2020-01-01.0"))
#> [1] 2000-01-01.0 2020-01-01.0
  #cbind(1:6, as.datey(2001:2020))
  #rbind(1:6, as.datey(2001:2020))
```
