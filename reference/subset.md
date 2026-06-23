# Subset `datey`, `durationy` or `datey_interval` vectors

Subsets `datey`, `durationy` or `datey_interval` vectors.

## Usage

``` r
# S3 method for class 'datey'
x[i, ...]

# S3 method for class 'durationy'
x[i, ...]

# S3 method for class 'datey_interval'
x[i, ...]

# S3 method for class 'datey'
x[i] <- value

# S3 method for class 'durationy'
x[i] <- value

# S3 method for class 'datey_interval'
x[i] <- value
```

## Arguments

- x:

  A `datey`, `durationy` or `datey_interval`.

- i:

  Indices to extract.

- ...:

  Other arguments.

- value:

  Value to assign.

## Value

The subset.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[durationy](https://r-datey.logmu.org/reference/durationy.md),
[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md),
[combine](https://r-datey.logmu.org/reference/combine.md)

## Examples

``` r
  x <- datey(2001:2004)
  x
#> [1] 2001-01-01.0 2002-01-01.0 2003-01-01.0 2004-01-01.0
  x[2:3]
#> [1] 2002-01-01.0 2003-01-01.0
  x[2:3] <- datey(1999)
  x
#> [1] 2001-01-01.0 1999-01-01.0 1999-01-01.0 2004-01-01.0
```
