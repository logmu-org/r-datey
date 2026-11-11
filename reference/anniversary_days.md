# Anniversary days

The position of a date relative to the start of its calendar year
depends on whether that calendar year is a leap year or not. This means
that in **datey** (and reality!) the start of 2020-04-01 plus 1 year is
not equal to the start of 2021-04-01.

This is by design and is usually precisely what's required. But this
behaviour can be awkward when anniversaries are the focus and,
fictitious as it may be, the position of a date in a year is required to
be the same regardless of whether the year is or is not a leap year.

To help with such cases, **datey** also provides anniversary days, which
assume every year has 366 days but that 29 February is just under a
quarter of the length of the other days. This convenient fiction ensures
that anniversaries always occur at the same point in the year.

These functions are intended for special cases, e.g. when anniversaries
are used to define datasets. *For standard calculations, the normal
approach is recommended.*

## Usage

``` r
start_anniversary_day_to_ymd(x)

start_anniversary_day(year, month, day, strict = TRUE)

is_start_anniversary_day(x)
```

## Arguments

- x:

  The `datey` to test or deconstruct.

- year, month, day:

  The year (1000 to 3000), month (1 to 12) and day (1 to 31).

  Note that 29 February is valid for all years.

- strict:

  How non-compliant *non-NA* inputs should be handled. If `strict` is
  `TRUE` – the default – then execution is stopped. If `strict` is
  `FALSE` then `NA` is returned.

## Value

`start_anniversary_day()` returns a `datey` the same length as its
arguments.

`is_start_anniversary_day()` returns a `logical` the same length as its
argument.

`start_anniversary_day_to_ymd()` returns a list of integer vector
`year`, integer vector `month`, and integer vector `day`, all with the
same length.

If the `datey` is not the start of an anniversary day then all
components are `NA`.

## See also

[datey](https://r-datey.logmu.org/reference/datey.md),
[datey_components](https://r-datey.logmu.org/reference/datey_components.md),
[is_xxx_day](https://r-datey.logmu.org/reference/is_xxx_day.md)

## Examples

``` r
# Adding whole years to the start of a day can leave the day boundary,
# because days in a leap year are shorter:
t <- start_day(2020, 4, 1) + durationy(0:4)
t
#> [1] 2020-04-01.0    2021-04-01.7514 2022-04-01.7514 2023-04-01.7514
#> [5] 2024-04-01.0   
is_start_day(t)
#> [1]  TRUE FALSE FALSE FALSE  TRUE

# Anniversary days stay on the anniversary:
anniversary <- start_anniversary_day(2020, 4, 1) + durationy(0:4)
is_start_anniversary_day(anniversary)
#> [1] TRUE TRUE TRUE TRUE TRUE
as.data.frame(start_anniversary_day_to_ymd(anniversary))
#>   year month day
#> 1 2020     4   1
#> 2 2021     4   1
#> 3 2022     4   1
#> 4 2023     4   1
#> 5 2024     4   1

# 29 February is an anniversary day in every year:
leap_day <- start_anniversary_day(2020, 2, 29) + durationy(0:4)
as.data.frame(start_anniversary_day_to_ymd(leap_day))
#>   year month day
#> 1 2020     2  29
#> 2 2021     2  29
#> 3 2022     2  29
#> 4 2023     2  29
#> 5 2024     2  29

# The cost is that anniversary days rarely match calendar days. Indeed, in
# 2020, a leap year, the 1 April anniversary day starts on 31 March:
anniversary[1:2]
#> [1] 2020-03-31.4349 2021-04-01.1878

# Anniversary day deconstruction is NA for non-anniversary days:
as.data.frame(start_anniversary_day_to_ymd(start_day(2020, 4, 1)))
#>   year month day
#> 1   NA    NA  NA
```
