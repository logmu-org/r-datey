# Integer constants

The following integer constants may make code clearer.

|  |  |  |
|----|----|----|
| Constant | Value | Meaning |
| `valid_years_start` | `1000L` | The first calendar year for a `datey` |
| `valid_years_end` | `3000L` | The final valid calendar year for a `datey` (noting that only the start of this year is valid) |
| `valid_duration_years_max` | `2000L` | The maximum valid duration in years for a `durationy` |

## Usage

``` r
valid_years_start

valid_years_end

valid_duration_years_max
```

## See also

[is_NA](https://r-datey.logmu.org/reference/is_NA.md),
[NAs](https://r-datey.logmu.org/reference/NAs.md)

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
  durationy(-(valid_duration_years_max + 0.001), strict = FALSE)
#> [1] <NA>
```
