# Create `datey` or `durationy` sequence vector

Creates a `datey` or `durationy` vector by defining a sequence.

## Usage

``` r
# S3 method for class 'datey'
seq(from, to, by)

# S3 method for class 'durationy'
seq(from, to, by)
```

## Arguments

- from, to:

  The starting and (maximal) end values of the sequence. Scalar `datey`s
  or `durationy`s.

- by:

  A scalar`durationy` representing the increment of the sequence.

## Value

The sequence

## Examples

``` r
  seq(from = datey(2000), to = datey(2005), by = durationy(2))
#> [1] 2000-01-01.0 2002-01-01.0 2004-01-01.0
  # 2000-01-01 2002-01-01 2004-01-01
```
