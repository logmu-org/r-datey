# The `datey`, `durationy` and `datey_interval` versions of NA

The `datey`, `durationy` and `datey_interval` versions of NA

## Usage

``` r
NA_datey_

NA_datey_interval_

NA_durationy_
```

## See also

[is_NA](https://r-datey.logmu.org/reference/is_NA.md),
[integer_constants](https://r-datey.logmu.org/reference/integer_constants.md)

## Examples

``` r
  is_datey(NA_datey_)
#> [1] TRUE
  is.na(NA_datey_)
#> [1] TRUE
  is_durationy(NA_durationy_)
#> [1] TRUE
  is.na(NA_durationy_)
#> [1] TRUE
  is_datey(NA_datey_interval_)
#> [1] FALSE
  is_datey_interval(NA_datey_interval_)
#> [1] TRUE
```
