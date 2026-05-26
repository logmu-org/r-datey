# Subset `datey` or `durationy` vectors

Subsets `datey` or `durationy` vectors.

## Usage

``` r
# S3 method for class 'datey'
x[i, ...]

# S3 method for class 'durationy'
x[i, ...]

# S3 method for class 'datey'
x[i] <- value

# S3 method for class 'durationy'
x[i] <- value
```

## Arguments

- x:

  A `datey` or `durationy`.

- i:

  Indices to extract.

- ...:

  Passed through.

- value:

  Value to assign.

## Value

The subset.

## Examples

``` r
  x <- datey(2001:2004) # 2001-01-01 2002-01-01 2003-01-01 2004-01-01
  x[2:3] # 2002-01-01 2003-01-01
#> [1] 2002-01-01.0 2003-01-01.0
  x[2:3] <- datey(1999) # 2001-01-01 1999-01-01 1999-01-01 2004-01-01
```
