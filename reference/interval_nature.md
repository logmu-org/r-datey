# Properties of a `datey_interval`

Test whether intervals, \\\[a,b)\\, are 'proper' or 'collapsed':

- A *proper* interval does not end before its start, i.e. \\a \le b\\.

- A *collapsed* interval does not start before its end, i.e. \\a \ge
  b\\.

An NA interval is treated as collapsed and improper.

These definitions imply the following:

- A collapsed interval could be empty or improper.

- To test for an empty interval, i.e. \\\[a,a)\\, test that it is both
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

(`any_proper()` is not implemented because there is no obvious use
case.)

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

## Value

- `is_XXX` functions return a logical vector corresponding the property.

- `all_XXX` and `any_XXX` functions return a logical scalar.

## See also

[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md),
[interval_properties](https://r-datey.logmu.org/reference/interval_properties.md),
[interval_includes](https://r-datey.logmu.org/reference/interval_includes.md)

## Examples

``` r
  non_empty   <- 1900 %to% 2000
  empty       <- 2000 %to% 2000
  improper    <- 2000 %to% 1900
  na          <- NA_datey_interval_

  is_collapsed(non_empty) # FALSE
#> [1] FALSE
  is_collapsed(empty)     # TRUE
#> [1] TRUE
  is_collapsed(improper)  # TRUE
#> [1] TRUE
  is_collapsed(na)        # TRUE
#> [1] TRUE

  is_proper(non_empty)    # TRUE
#> [1] TRUE
  is_proper(empty)        # TRUE
#> [1] TRUE
  is_proper(improper)     # FALSE
#> [1] FALSE
  is_proper(na)           # FALSE
#> [1] FALSE
```
