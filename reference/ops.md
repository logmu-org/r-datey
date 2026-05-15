# Operators for `datey` and `durationy`

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
