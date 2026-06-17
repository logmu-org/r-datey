# Operators for `datey`, `durationy` and `datey_interval`

The unary `-` operator can be applied to a `durationy` to change its
sign.

The following are the available binary operations on `datey` and
`durationy` only operands, and their meaning:

|  |  |  |  |  |
|----|----|----|----|----|
| Left | Operators | Right | Result | Notes |
| `datey` | `==` `!=` `<` `<=` `>` `>=` | `datey` | logical | Order relation for dates |
| `datey` | `-` | `datey` | `durationy` | Duration between two dates |
| `datey` | `+` `-` | `durationy` | `datey` | A date offset by a duration |
| `durationy` | `+` | `datey` | `datey` | A date offset by a duration |
| `durationy` | `==` `!=` `<` `<=` `>` `>=` | `durationy` | logical | Order relation for durations |
| `durationy` | `+` `-` | `durationy` | `durationy` | Duration addition and substraction |
| `datey` | `+` `-` `==` `!=` `<` `<=` `>` `>=` | numeric | numeric | The `datey` is first converted to years |
| numeric | `+` `-` `==` `!=` `<` `<=` `>` `>=` | `datey` | numeric | The `datey` is first converted to years |
| `durationy` | `+` `-` `*` `/` `==` `!=` `<` `<=` `>` `>=` | numeric | `durationy` | The `durationy` is first converted to years |
| numeric | `+` `-` `*` `/` `==` `!=` `<` `<=` `>` `>=` | `durationy` | `durationy` | The `durationy` is first converted to years |
| `datey` | `%to%` | `datey` | `datey_interval` | Syntactic sugar for [`datey_interval()`](https://logmu-org.github.io/r-datey/reference/datey_interval.md) |
| `datey_interval` | `%includes%` | `datey` | logical | Whether the interval contains the date |

## Usage

``` r
# S3 method for class 'datey_type'
Ops(e1, e2)
```

## Arguments

- e1:

  First parameter.

- e2:

  Second parameter (missing if a unary operator).

## Value

See above table. In essence

- subtracting two `datey`s results in a `durationy`,

- comparing two `T`s results in a logical,

- adding or subtracting a `durationy` to or from a `T` results in a `T`,
  and

- mixing `durationy` and `datey` with numeric operands first converts
  the `durationy` and `datey` to years and then results in standard
  numeric evaluation,

where `T` is either `datey` or `durationy` in each of the above.

## Examples

``` r
t_2000 <- datey(2000)
t_2001 <- datey(2001)
d_0.5 <- durationy(0.5)

t_2000
#> [1] 2000-01-01.0
t_2001
#> [1] 2001-01-01.0
d_0.5
#> [1] 0.5 yr

t_2001 - t_2000 # `datey` - `datey` is a `durationy`
#> [1] 1 yr
t_2000 + d_0.5  # `datey` + `durationy` is a `datey`
#> [1] 2000-07-02.0
t_2001 - d_0.5  # `datey` - `durationy` is a `datey`
#> [1] 2000-07-02.0
t_2000 + 0.5    # Arithmetic with numerics results in a double
#> [1] 2000.5
d_0.5 + d_0.5   # `durationy` + `durationy` is a `durationy`
#> [1] 1 yr
d_0.5 + 0.5     # Arithmetic with numerics results in a double
#> [1] 1
d_0.5 * 2       # Arithmetic with numerics results in a double
#> [1] 1

interval <- t_2000 %to% t_2001
interval
#> [1] [2000-01-01.0, 2001-01-01.0)
interval %includes% t_2000 # TRUE -- start *is* included in an interval
#> [1] TRUE
interval %includes% (t_2000 + d_0.5) # TRUE
#> [1] TRUE
interval %includes% t_2001 # FALSE -- end is *not* included in an interval
#> [1] FALSE
```
