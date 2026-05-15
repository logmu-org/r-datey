# The datey specification

## Introduction

The datey system provides fixed precision 32 bit date and duration
arithmetic on an annual grid across multiple platforms.

Replicating real-world date arithmetic or text representations is a non
goal. Handling that complexity should take place *outside* the datey
system. In typical use, dates should be inputs to the datey system, not
outputs (and durations should be neither[^1]). The datey approach is to
assume that input dates have been calculated appropriately and that its
job is to handle intervals between those dates.

## Definitions

- `double` means IEEE 754 binary64, i.e. 64-bit binary floating-point.

- `integer` means 32 bit two’s complement integer.

- Dates are written using [YYYY‑MM‑DD notation](https://xkcd.com/1179/),
  where YYYY is a four-digit year, MM is a two-digit month of the year,
  01 to 12, and DD is the two-digit day of the month, 01 to 31.

- Banker’s rounding[^2] means round a `double` to the nearest integer
  unless the fractional part is ±0.5, in which case round it to the
  nearest even integer. In the algorithms below, it also entails
  conversion to `integer`, which is safe because in all cases the
  algorithms guarantee that the value to convert lies within the range
  of `integer`.

## The fixed precision annual grid

The datey system assumes the following:

1.  All calendar years have the same duration.

2.  *Within a calendar year*, all days have the same duration.

3.  Time is granular, with the smallest indivisible unit being a
    *click*, which is 1 / 534 360 of a year.

Any other variation arising from, for instance, time zones, daylight
saving time or leap seconds is out of scope – allowance for these must
be done *outside* the datey system.

## Types

The datey system defines two types:

1.  A `datey` represents a date.

2.  A `durationy` represents the difference between two dates.

Both of these types are represented using clicks stored as `integer`.

## Dates

Dates are mapped to `datey`s as the number of clicks since the start of
the notional year 0000 on the proleptic Gregorian calendar, i.e. the
Gregorian calendar extended backwards from its introduction in 1582.

A `datey` that would otherwise represent a date before calendar year
1000 or after calendar year 2999 should be treated as invalid[^3] when
mapping dates to or from a `datey`.

### Mapping a date *to* a `datey`

When mapping a date specified by calendar year, month and day to a
`datey` the point within the day also needs to be specified. In typical
use, it is expected that only the start, middle and end of a day will be
specified, but a mapping including the day-fraction is specified for
full generality.

The mapping as a function of `integer` *year*, *month* and *day*, and
`double` *day_fraction* is as follows:

1.  Valid inputs are

    - *year*: `integer` from 1000 to 2999 inclusive
    - *month*: `integer` from 1 to 12 inclusive
    - *day*: `integer` from 1 to the number of days in the month
      specified by *year* and *month*
    - *day_fraction*: `double` from 0 to 1 inclusive

    In addition, the special case of 0999-12-31 and a *day_fraction*
    precisely equal to 1 should also be treated as valid.

    If any of *year*, *month*, *day* or *day_fraction* are invalid then
    the result is invalid.

2.  Define *clicks_per_day* as 1460 if *year* is a leap year and 1464
    otherwise.

3.  Define the `integer` *days_to_start_of_month* as the number of days
    from the start of the year to the start of *month* (allowing for
    whether *year* is a leap year).

4.  Define the `integer` *day_count* as *days_to_start_of_month* + *day*
    − 1.

5.  Define the `integer` *fraction_clicks* as *day_fraction* ×
    *clicks_per_day* rounded to `integer` using banker’s rounding.

6.  The resulting number of clicks is defined as the `integer`
    calculation

    *year* × 534 360 + *day_count* × *clicks_per_day* +
    *fraction_clicks*

    For avoidance of doubt, the special case of 2999-12-31 and a
    *day_fraction* that rounds to 1 should be returned as is.

For convenience, a datey implementation should also provide a mapping to
a `datey` from the *start*, *middle* and *end* of a date using the above
as follows.

- *start_day*(*year*, *month*, *day*) := *datey_from_YMDF*(*year*,
  *month*, *day*, 0.0)
- *mid_day*(*year*, *month*, *day*) := *datey_from_YMDF*(*year*,
  *month*, *day*, 0.5)
- *end_day*(*year*, *month*, *day*) := *datey_from_YMDF*(*year*,
  *month*, *day*, 1.0)

Worked examples:

| Point in time | Clicks | Calculation |
|:---|---:|:---|
| Start of 2000 | 1 068 720 000 | 2000 × 534 360 |
| Middle of 2000‑01‑01 | 1 068 720 730 | 2000 is a leap year and therefore there are 534 360 / 366 = 1460 clicks in each day. The middle of 2000‑01‑01 is half a day into the year 2000 and therefore the number of clicks is 2000 × 534 360 + 1460 / 2. |
| End of 2021‑03‑15 | 1 080 049 896 | 2021 is a not a leap year and therefore there are 534 360 / 365 = 1464 clicks in each day. The number of days from the start of 2021 to the end of 2021‑03‑15 is 31 + 28 + 15 = 74. Hence the number of clicks is 2021 × 534 360 + 74 × 1460. |

### Mapping a `datey` to a date and day-fraction

A `datey` is mapped from *clicks* to *year*, *month*, *day* and
*day_fraction* as follows:

1.  If *clicks* \< 1000 × 534 360 or *clicks* ≥ 3000 × 534 360 then the
    `datey` is invalid and therefore the result is also invalid.

2.  *year* is *clicks* div 534 360, where div means `integer` division
    rounded down to the nearest integer.

3.  Define *clicks_remaining* as *clicks* − *year* × 534 360.

4.  Define *clicks_per_day* as 1460 if *year* is a leap year and 1464
    otherwise.

5.  Define the *day_in_year* as *clicks_remaining* div *clicks_per_day*,
    where div means `integer` division rounded down to the nearest
    integer.

6.  Use *day_in_year* to determine *month* and *day*.

7.  Define *day_fraction_clicks* as *clicks_remaining* − *day_in_year* ×
    *clicks_per_day*.

8.  *day_fraction* is *day_fraction_clicks* / *clicks_per_day* using
    `double` division.

## Durations

A `durationy` represents a duration using clicks.

A `durationy` that would otherwise represent a duration of magnitude
more than 2000 years should be treated as invalid when mapping durations
to or from a `durationy`.

### Mapping a *duration in years* to a `durationy`

As well as being the difference between two `datey`s, a `durationy` can
also be defined direct from a *duration in years* as follows:

1.  If the *duration in years* is represented by a numerical type other
    than `double` then it must first be converted to `double`. If this
    entails a loss in precision then this is an error.

2.  If the *duration in years* is not a number (NaN) or greater in
    magnitude than 2000 then the resulting `durationy` is invalid.

3.  Otherwise the resulting `durationy` number of clicks is the
    *duration in years* multiplied by 534 360 and then rounded to
    `integer` using banker’s rounding.

Worked examples:

| Duration in years   |     Clicks | Calculation     |
|:--------------------|-----------:|:----------------|
| 1 year              |    534 360 |                 |
| −2.75 years         | −1 469 490 | −2.75 × 534 360 |
| 0.5 / 534 360 years |          0 | round(0.5)      |
| 1.5 / 534 360 years |          2 | round(1.5)      |

### Mapping a `durationy` to a duration in years

A `durationy` is mapped to a duration in years as `double` as follows:

1.  If the `durationy` is invalid then the result is not a number (NaN).

2.  Otherwise the result is clicks converted to `double` and then
    divided by 534 360.

## Arithmetic operations

The following arithmetic operations are defined by applying the
specified operators to the underlying argument clicks using 32-bit two’s
complement arithmetic.

| Operation | Left | Operators | Right | Result type |
|:---|:--:|:--:|:--:|:---|
| Order relation for dates | `datey` | = ≠ \< \> ≤ ≥ | `datey` | Boolean |
| Date subtraction | `datey` | − | `datey` | `durationy` |
| Date offset by a duration | `datey` | \+ − | `durationy` | `datey` |
| Date offset by a duration | `durationy` | `+` | `datey` | `datey` |
| Order relation for durations | `durationy` | = ≠ \< \> ≤ ≥ | `durationy` | Boolean |
| Duration addition and subtraction | `durationy` | \+ − | `durationy` | `durationy` |

The unary plus (+) and minus (negation or −) operators are defined for a
`durationy`:

- The + operator returns its argument unchanged.
- The − operator changes the sign of the clicks.

It is *not* required ot expected that the above operations will be
checked for `integer` overflow – they can reasonably be supposed to be
safe within the domain of operation (i.e. date inputs that have already
been checked for validity) and datey exists to facilitate performant
calculations.

Duration scaling, i.e. number × `durationy`, `durationy` × number or
`durationy` / number, is defined by

1.  Scaling factors (i.e. ‘number’ in the above) represented by
    numerical types other than `double` must first be converted to
    `double`. If this entails a loss in precision then this is an error.

2.  If the `durationy` is invalid then the result is invalid.

3.  Otherwise convert the underlying clicks to `double`, carry out the
    specified `double` calculation and then convert the resulting
    `double` clicks back to a `durationy` as follows:

    - If the `double` clicks is not a number (NaN) or its absolute value
      is greater than 2000 × 534 360 then the result is invalid.
    - Otherwise the result is the `double` clicks rounded to `integer`
      using banker’s rounding.

In contrast to operations involving solely `datey`s and `durationy`s,
scaling operations should be checked for the validity of their result
(and consequently not used in hot paths).

## Text representations

The datey system provides a simple, standardised text input and output
format. For more complicated scenarios, dates should be parsed or
formatted *outside* the datey system.

### `datey` text format

A valid `datey` is represented in text in the format YYYY‑MM‑DD.FFF
where

- YYYY is a four-digit year,
- MM is a two-digit month of the year (starting at “01” for January)
- DD is the two-digit day of the month (with the first day of a month
  being “01”), and
- .FFF is an optional day fraction (but if ‘.’ is present then at least
  1 digit must also be provided).

For text *outputs*:

- The fraction contains no more than 3 decimal places (because this is
  sufficient to distinguish all possible day fractions at datey
  precision).
- It is an option as to whether a zero day fraction is stated explicitly
  (e.g. ‘2000-01-01.0’).

For text *inputs*:

- Blank fractions should be treated as zero.
- The fractional part is not constrained to be 3 decimal places.
- Arbitrarily long inputs e.g. more than 100 UTF-8 bytes should be
  rejected.

### `durationy` text format

Unless `durationy` itself is being serialised, it is recommended that
durations are parsed and formatted using conventional means applied to
the duration measured in years.

A valid `durationy` is represented in text in the format SY.FFFFFF UUU
where

- S is a plus or minus sign, i.e. one of ‘+’ (U+002B), true minus ‘−’
  (U+2212) or ASCII hyphen-minus ‘-’ (U+002D).
- Y is number of whole years
- .FFFFFF is an optional fractional part of year.
- UUU is the unit name for one year. If UUU is non-blank then it is
  preceded by a space. UUU cannot be longer than 20 UTF-8 bytes or
  contain control characters.

For text *outputs*:

- It is optional whether ‘+’ (U+002B) plus sign is included for positive
  durations is optional. (Default is no ‘+’).
- It is optional whether to use the true minus sign ‘−’ (U+002B) or the
  ASCII ‘-’ (U+002D) hyphen-minus character. (Default is true minus
  sign.)
- The fraction contains no more than 6 decimal places (because this is
  sufficient to distinguish all possible duration fractions at datey
  precision).
- The unit is user-specifiable. (Default is ‘yrs’.)

For text *inputs*:

- All plus or minus sign included above are parsed (including for zero
  durations).
- The fractional part is not constrained to be 6 decimal places.
- The unit is user-specifiable. If non-blank then the unit text must be
  present and preceded by a space. (The default is ’ yrs’.)
- Arbitrarily long inputs e.g. more than 100 UTF-8 bytes should be
  rejected.

[^1]: There is no unique way to map dates to an annual grid – days do
    not map cleanly to years. And things get even worse when dates and
    durations are mixed. For instance, the duration from 2000-01-01 to
    2001-01-01 is 366 days but from 2000-03-01 to 2001-03-01 is
    365 days, which is a clue that adding durations to dates can be
    messy. And that’s before we’re asked what 2000-02-29 plus one year
    should be! Corralling this ambiguity is datey’s raison d’être.

[^2]: Banker’s rounding is also known as ‘round to nearest, ties to
    even’ or ‘round half to even’. It is the default rounding mode for
    IEEE 754 binary floating-point.

[^3]: This means that both 0 (the default in many languages) and −2³¹
    (used by some languages to indicate missing data or `NA`) are
    invalid `datey`s.
