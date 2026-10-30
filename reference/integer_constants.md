# Integer constants

The following integer constants may make code clearer.

[TABLE]

## Usage

``` r
valid_years_start

valid_years_end

valid_duration_years_max
```

## Value

Each of these constants is a scalar `integer` giving one of the
boundaries of the valid `datey` or `durationy` range described above.

## See also

[is_NA](https://r-datey.logmu.org/reference/is_NA.md),
[NAs](https://r-datey.logmu.org/reference/NAs.md),
[datey](https://r-datey.logmu.org/reference/datey.md),
[all_of_time](https://r-datey.logmu.org/reference/all_of_time.md)

## Examples

``` r
  datey(valid_years_start - 0.001, strict = FALSE)
#> [1] <NA>
  datey(valid_years_start)
#> [1] 1000-01-01.0
  datey(valid_years_end)
#> [1] 3000-01-01.0
  datey(valid_years_end + 0.001, strict = FALSE)
#> [1] <NA>
  durationy(valid_duration_years_max)
#> [1] 2000 yr
  durationy(valid_duration_years_max + 0.001, strict = FALSE)
#> [1] <NA>
```
