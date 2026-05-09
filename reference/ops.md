# Operators for `datey` and `durationy`

The unary `-` operator can be applied to a `durationy` to change its
sign. The following are the available binary operators and their
meaning.

|  |  |  |  |  |
|----|----|----|----|----|
| Left | Operators | Right | Result | Notes |
| `datey` | `==` `!=` `<` `<=` `>` `>=` | `datey` | logical | Order relation for dates |
| `datey` | `-` | `datey` | `durationy` | Duration between two dates |
| `datey` | `+` `-` | `durationy` | `datey` | A date offset by a duration |
| `durationy` | `+` | `datey` | `datey` | A date offset by a duration |
| `durationy` | `==` `!=` `<` `<=` `>` `>=` | `durationy` | logical | Order relation for durations |
| `durationy` | `+` `-` | `durationy` | `durationy` | Duration addition and substraction |
| `durationy` | `*` `/` | numeric | `durationy` | A scaled duration |
| numeric | `*` | `durationy` | `durationy` | A scaled duration |

## Usage

``` r
# S3 method for class 'datey_type'
Ops(e1, e2)
```

## Arguments

- e1:

  First parameter – must be `datey` or `durationy`.

- e2:

  Second parameter (missing if a unary operator).

## Value

See above table. In essence

- subtracting two `datey`s results in a `durationy`,

- comparing two `T`s results in a logical,

- adding or subtracting a `durationy` to or from a `T` results in a `T`,
  and

- scaling a `durationy` results in a `durationy`,

where `T` is either `datey` or `durationy` in each of the above.
