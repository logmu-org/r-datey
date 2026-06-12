# `all_proper(x)` tests whether all the elements of `x` are proper. `all_collapsed(x)` tests whether all the elements of `x` are collapsed. `any_collapsed(x)` tests whether at least one of the elements of `x` is collapsed. Whether a `datey_interval` includes a `datey`

Test whether a `datey_interval`, \[start, end) includes a `datey`, i.e.
start ≤ value and value \< end.

The `%includes%` operator is syntactic sugar for `interval_includes()`.

An NA interval is treated as empty and an NA date is treated as not
being in any interval, so these methods are guaranteed to return `TRUE`
or `FALSE`.

## Usage

``` r
interval_includes(interval, value)

interval %includes% value
```

## Arguments

- interval:

  The `datey_interval`.

- value:

  The `datey` to test for inclusion.
