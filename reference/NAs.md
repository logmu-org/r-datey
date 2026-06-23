# The `datey`, `durationy` and `datey_interval` versions of NA

Throughout the **datey** package, `NA` will cause an error when used
where a `datey_`, `durationy_` or `datey_interval_` is expected. This is
because its type is `logical` and potentially indicates user error. If
you want an NA value with a **datey** system type, use one of
`NA_datey_`, `NA_durationy_` or `NA_datey_interval_`.

## Usage

``` r
NA_datey_

NA_datey_interval_

NA_durationy_
```

## See also

[is_NA](https://r-datey.logmu.org/reference/is_NA.md),
[integer_constants](https://r-datey.logmu.org/reference/integer_constants.md),
[datey](https://r-datey.logmu.org/reference/datey.md),
[durationy](https://r-datey.logmu.org/reference/durationy.md),
[datey_interval](https://r-datey.logmu.org/reference/datey_interval.md)

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
  is_datey_interval(NA_datey_interval_)
#> [1] TRUE
```
