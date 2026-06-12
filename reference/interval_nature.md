# Properties of an interval.

Test whether intervals, \[*a*,*b*), are 'proper' or 'collapsed':

- A *proper* interval does not end before its start, i.e. *a* ≤ *b*.

- An *collapsed* interval does not start before its end, i.e. *a* ≥ *b*.

An NA interval is treated as collapsed and improper.

These definitions imply the following:

- A collapsed interval could be empty or improper.

- To test for an empty interval, i.e. \[*a*,*a*), test that it is both
  proper and collapsed.

These methods are guaranteed to return `TRUE` or `FALSE`, i.e. not `NA`
(provided the argument is an interval).

Vector versions mapping each element of `x` to `TRUE` or `FALSE`:

`is_proper(x)` tests whether the elements of `x` are proper.
`is_collapsed(x)` tests whether the elements of `x` are collapsed.

Scalar versions mapping `x` to a scalar `TRUE` or `FALSE`:

`all_proper(x)` tests whether all the elements of `x` are proper.
`all_collapsed(x)` tests whether all the elements of `x` are collapsed.
`any_collapsed(x)` tests whether at least one of the elements of `x` is
collapsed.

These are S3 generic functions.

## Usage

``` r
is_proper(x)

# Default S3 method
is_proper(x)

# S3 method for class 'datey_interval'
is_proper(x)

all_proper(x)

# Default S3 method
all_proper(x)

# S3 method for class 'datey_interval'
all_proper(x)

is_collapsed(x)

# Default S3 method
is_collapsed(x)

# S3 method for class 'datey_interval'
is_collapsed(x)

all_collapsed(x)

# Default S3 method
all_collapsed(x)

# S3 method for class 'datey_interval'
all_collapsed(x)

any_collapsed(x)

# Default S3 method
any_collapsed(x)

# S3 method for class 'datey_interval'
any_collapsed(x)
```

## Arguments

- x:

  The interval to test.

## Examples

``` r
  a <- datey(1999)
  b <- datey(2000)
  is_collapsed(a %to% b)
#> [1] FALSE
  is_collapsed(a %to% a)
#> [1] TRUE
  is_collapsed(b %to% a)
#> [1] TRUE
  is_collapsed(NA_datey_interval_)
#> [1] TRUE
  is_proper(a %to% b)
#> [1] TRUE
  is_proper(a %to% a)
#> [1] TRUE
  is_proper(b %to% a)
#> [1] FALSE
  is_proper(NA_datey_interval_)
#> [1] FALSE
```
