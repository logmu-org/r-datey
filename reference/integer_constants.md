# Integer constants

The following integer constants may make code clearer.

|  |  |  |
|----|----|----|
| Constant | Value | Meaning |
| `valid_years_start` | `1000L` | The first *valid* calendar year for a `datey` |
| `valid_years_end` | `3000L` | The first *invalid* calendar year for a `datey` after after |
| `valid_years_start` |  |  |
| `valid_max_duration` | `2000L` | The maximum valid |
| duration in years for a `durationy` |  |  |

## Usage

``` r
valid_years_start

valid_years_end

valid_duration_years_max
```

## Format

An object of class `integer` of length 1.

An object of class `integer` of length 1.

An object of class `integer` of length 1.

## See also

[is_NA](https://logmu-org.github.io/r-datey/reference/is_NA.md),
[NA_datey\_](https://logmu-org.github.io/r-datey/reference/NA_datey_.md),
[NA_durationy\_](https://logmu-org.github.io/r-datey/reference/NA_durationy_.md)

## Examples

``` r
  x <- c(NA_durationy_, durationy(1.5))
  is.na(x) # c(TRUE, FALSE)
#> [1]  TRUE FALSE
```
