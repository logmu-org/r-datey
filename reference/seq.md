# Create `datey` or `durationy` sequence vector

Creates a `datey` or `durationy` vector by defining a sequence.

## Usage

``` r
# S3 method for class 'datey'
seq(from, to, by, ...)

# S3 method for class 'durationy'
seq(from, to, by, ...)
```

## Arguments

- from:

  The first value in the sequence. A scalar `datey` or `durationy`.

- to:

  The sequence stops before values exceed `to`. A scalar `datey` or
  `durationy`.

- by:

  The increment of the sequence. A scalar `datey` or `durationy`.

- ...:

  Other arguments (not used in this package).

## Examples

``` r
  seq(from = datey(2000), to = datey(2005), by = durationy(2))
#> [1] 2000-01-01.0 2002-01-01.0 2004-01-01.0
  seq(from = datey(2000), to = datey(1999), by = durationy(-0.25))
#> [1] 2000-01-01.0  1999-10-01.75 1999-07-02.5  1999-04-02.25 1999-01-01.0 
```
