# The datey specification

## Introduction

The **datey** system provides a standard mapping of dates onto an annual
grid.

This matters in contexts where the primary unit is years but input data
uses dates (i.e. days)[^1].

The goal of **datey** is to provide performant date and duration-related
arithmetic for intervals between input dates.

The following are non goals and should be handled outside the **datey**
system:

- Real-world date arithmetic[^2], including calculating dates for
  output.
- Parsing and formatting dates.

## Definitions

`double` means IEEE 754 binary64, i.e. 64-bit binary floating-point.

`integer` means 32 bit two’s complement signed integer.

Literal dates in this specification are written using [`YYYY-MM-DD`
notation](https://xkcd.com/1179/), where `YYYY` is a four-digit year,
`MM` is a two-digit month of the year, 01 to 12, and `DD` is the
two-digit day of the month, 01 to 31.

Banker’s rounding[^3] means round a `double` to the nearest integer
unless the fractional part is +/-0.5, in which case round it to the
nearest even integer. In the algorithms below, it also entails
conversion to `integer`, which is safe because, in all cases, the
algorithms guarantee that the value to convert lies within the range of
`integer`.

## The fixed precision annual grid

The **datey** system assumes the following:

- All calendar years have the same duration.

- Within a calendar year, all days have the same duration.

- Time is granular, with the smallest indivisible unit being a *click*,
  which is 1 / 534 360 of a year.

Any other variation arising from, for instance, time zones, daylight
saving time or leap seconds is out of scope – allowance for these must
be done *outside* the **datey** system.

## Types

The **datey** system defines two types:

1.  A `datey` represents a date.

2.  A `durationy` represents the difference between two dates.

Both of these types are represented using clicks stored as `integer`.

### Dates

Dates are mapped to `datey`s as the number of clicks since the start of
the notional year 0000 on the proleptic[^4] Gregorian calendar.

A `datey` that would otherwise represent a date before calendar year
1000 or after the start of calendar year 3000 should be treated as
invalid[^5] when mapping dates to or from a `datey`.

### Durations

A `durationy` represents a duration using clicks.

A `durationy` that would otherwise represent a duration of magnitude
more than 2000 years should be treated as invalid when mapping durations
to or from a `durationy`.

### Mapping *years* to a `datey` or `durationy`

A `datey` can be defined direct as the *duration in years* from the
start of the notional year 0000 and a `durationy` can be defined direct
from a *duration in years* as follows:

1.  If the *duration in years* is represented by a numerical type with
    lower precision than `double` then it must first be converted to
    `double`.

2.  The result is invalid if any of the following apply:

    - The *duration in years* is not a number (NaN).
    - For a `datey`, if the *duration in years* is less than 1000 or
      greater than 3000.
    - For a `durationy`, if the absolute value of the *duration in
      years* is greater than 2000.

3.  Otherwise the resulting number of clicks is the *duration in years*
    multiplied by 534 360, then rounded using banker’s rounding and
    finally converted to `integer` .

Worked examples:

| Target type | Duration in years |        Clicks | Calculation       |
|:------------|:-----------------:|--------------:|:------------------|
| `datey`     |      999.99       |       Invalid |                   |
| `datey`     |       1000        |   534 360 000 | 1000 × 534 360    |
| `datey`     |      1999.75      | 1 068 586 410 | 1999.75 × 534 360 |
| `datey`     |       3000        | 1 603 080 000 | 3000 × 534 360    |
| `datey`     |      3000.01      |       Invalid |                   |
| `durationy` |        +1         |      +534 360 |                   |
| `durationy` |       -2.75       |    -1 469 490 | -2.75 × 534 360   |
| `durationy` | +/-0.5 / 534 360  |             0 | round(±0.5)       |
| `durationy` |  +1.5 / 534 360   |            +2 | round(+1.5)       |
| `durationy` |  -1.5 / 534 360   |            -2 | round(-1.5)       |
| `durationy` |    +/-2000.01     |       Invalid |                   |

### Mapping a date to a `datey`

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

    The special cases (a) 0999-12-31 with *day_fraction* = 1 and
    (b) 3000-01-01 with *day_fraction* = 0 should also be treated as
    valid (and where equality is precise equality, i.e. not after
    rounding).

    Other than the above special cases, if any of *year*, *month*, *day*
    or *day_fraction* are invalid then the result is invalid.

2.  Determine whether *year* is a leap year using the proleptic
    Gregorian calendar.

3.  Define *clicks_per_day* as 1460 if *year* is a leap year and 1464
    otherwise.

4.  Define the `integer` *days_to_start_of_month* as the number of days
    from the start of the year to the start of *month*, allowing for
    whether *year* is a leap year.

5.  Define the `integer` *day_count* as *days_to_start_of_month* +
    *day* - 1.

6.  Define the `integer` *fraction_clicks* as *day_fraction* ×
    *clicks_per_day* rounded to `integer` using banker’s rounding.

7.  The resulting number of clicks is defined as the `integer`
    calculation

    *year* × 534 360 + *day_count* × *clicks_per_day* +
    *fraction_clicks*

For convenience, a **datey** implementation should also provide a
mapping to a `datey` from the *start*, *middle* and *end* of a date
defined as:

- *start_day*(*year*, *month*, *day*) := *datey_from_YMDF*(*year*,
  *month*, *day*, 0.0)
- *mid_day*(*year*, *month*, *day*) := *datey_from_YMDF*(*year*,
  *month*, *day*, 0.5)
- *end_day*(*year*, *month*, *day*) := *datey_from_YMDF*(*year*,
  *month*, *day*, 1.0)

where *datey_from_YMDF* is the above algorithm as a function of *year*,
*month*, *day* and *day_fraction*.

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

3.  Define *clicks_remaining* as *clicks* - *year* × 534 360.

4.  Define *clicks_per_day* as 1460 if *year* is a leap year and 1464
    otherwise.

5.  Define the *day_in_year* as *clicks_remaining* div *clicks_per_day*,
    where div means `integer` division rounded down to the nearest
    integer.

6.  Use *day_in_year* to determine *month* and *day*.

7.  Define *day_fraction_clicks* as *clicks_remaining* - *day_in_year* ×
    *clicks_per_day*.

8.  *day_fraction* is *day_fraction_clicks* / *clicks_per_day* using
    `double` division.

## Arithmetic and comparative operations

### Pure `datey` and `duration` operations

The following arithmetic operations are defined by applying the
specified operators to the underlying argument clicks using 32-bit two’s
complement arithmetic.

| Operation | Left | Operators | Right | Result type |
|:---|:--:|:--:|:--:|:---|
| Order relation for dates | `datey` | = ≠ \< \> ≤ ≥ | `datey` | Boolean |
| Date subtraction | `datey` | \- | `datey` | `durationy` |
| Date offset by a duration | `datey` | \+ - | `durationy` | `datey` |
| Date offset by a duration | `durationy` | `+` | `datey` | `datey` |
| Order relation for durations | `durationy` | = ≠ \< \> ≤ ≥ | `durationy` | Boolean |
| Duration addition and subtraction | `durationy` | \+ - | `durationy` | `durationy` |

The unary plus (+) and minus (negation or -) operators are defined for a
`durationy`:

- The + operator returns its argument unchanged.
- The - operator changes the sign of the clicks.

It is *not* required or expected that the above operations will be
checked for `integer` overflow in *intermediate* calculations on the
basis that

- overflows are unlikely to occur within the domain of operation,
  i.e. times periods between date inputs that have already been checked
  for validity, and
- a key rationale for **datey** is to facilitate *performant*
  calculations.

### Mixed `datey` / `durationy` and numeric operations

For convenience, binary operations are also defined when one of the
operands is a `datey` or `duration` and the other is numeric. The first
step is to convert the `datey` or `duration` operand to years as
follows:

1.  If the `datey` or `durationy` is invalid then the result is not a
    number (NaN).
2.  Otherwise the result is clicks converted to `double` and then
    divided by 534 360.

If required the numeric operand should be converted to `double`. If this
entails a loss in precision then this is an error.

The following standard operations are legal

[TABLE]

## Text representations

The **datey** system provides a simple, standardised text input and
output format. For more complicated scenarios, dates should be parsed or
formatted *outside* the **datey** system.

### `datey` text format

A valid `datey` is represented in text in the format
`YYYY&#x2011;MM&#x2011;DD[.FFF]` where

- `YYYY` is a four-digit year,
- `MM` is a two-digit month of the year (starting at “01” for January)
- `DD` is the two-digit day of the month (with the first day of a month
  being “01”), and
- `[.F...]` is an optional day fraction (but if ‘.’ is present then at
  least 1 digit must also be provided).

For text *outputs*:

- The fraction contains no more than 4 decimal places (because this is
  sufficient to distinguish all possible day fractions at **datey**
  precision).
- The preferred (but not required) behaviour when there is a non-zero
  fraction is for trailing zeros to be omitted (e.g. prefer
  ‘2000-01-01.5’ to ‘2000-01-01.5000’).
- It is a user option as to whether a zero day fraction is stated
  explicitly (e.g. ‘2000-01-01.0’). The default is to include ‘.0’ (to
  avoid the ambiguity as to whether this is a normal date as opposed to
  a **datey** date).

For text *inputs*:

- Blank fractions should be treated as zero.
- Arbitrarily long inputs e.g. more than 100 UTF-8 bytes should be
  rejected.
- Subject to this overall limit, the fractional part can contain an
  arbitrary number of digits.

### `durationy` text format

Unless `durationy` itself is being serialised, it is recommended that
durations are parsed and formatted using conventional means applied to
the duration measured in years.

A valid `durationy` is represented in text in the format
`[S]...Y[.F...][ U...]` where

- `[S]` is an optional plus or a minus sign, i.e. one of ‘+’ (U+002B),
  true minus ‘-’ (U+2212) or ASCII hyphen-minus ‘-’ (U+002D).
- `...Y` is number of whole years (leading zeros allowed).
- `[.F...]` is an optional fractional part of year, including ‘.’ to
  represent the decimal point.
- `[ U...]` is the unit name for one year preceded by a space if the
  unit name is not blank. The unit name cannot be longer than 20 UTF-8
  bytes or contain control characters.

For text *outputs*:

- It is optional whether ‘+’ (U+002B) plus sign is included for positive
  durations. (Default is omit ‘+’).
- It is optional whether to use the true minus sign ‘-’ (U+2212) or the
  ASCII ‘-’ (U+002D) hyphen-minus character. (Default is use true minus
  sign.)
- The fraction contains no more than 6 decimal places (because this is
  sufficient to distinguish all possible duration fractions at **datey**
  precision).
- The preferred (but not required) behaviour is for trailing zeros to be
  omitted and, when the fraction is zero, for there to be no decimal
  point or fraction.
- The unit name is user-specifiable. (Default is ‘yr’.)

For text *inputs*:

- All plus or minus signs included above are parsed (including for zero
  durations).
- The unit is user-specifiable. If non-blank then the unit text must be
  present and preceded by a space. (The default is ’ yr’.)
- Arbitrarily long inputs e.g. more than 100 UTF-8 bytes should be
  rejected.
- Subject to this overall limit, the fractional part can contain an
  arbitrary number of digits.

[^1]: Classic examples are actuarial mortality experience analysis or
    valuation of life assurance and annuities. Mortality rates are
    defined per year but experience and valuation data use dates.

[^2]: Even simple-sounding calculations involving dates and durations
    can be problematic. Consider, for example, what ‘add 1 year’ should
    mean. The duration from 2000-02-01 to 2001-02-01 is 366 days but
    from 2000-03-01 to 2001-03-01 is 365 days, which means that there is
    no simple definition of duration that accords with this standard
    calculation. And that’s before we ask what 2000-02-29 plus 1 year
    should be! Corralling this ambiguity is **datey**’s raison d’être.

[^3]: Banker’s rounding is also known as ‘round to nearest, ties to
    even’ or ‘round half to even’. It is the default rounding mode for
    IEEE 754 binary floating-point.

[^4]: The proleptic Gregorian calendar is the Gregorian calendar
    extended *backwards* from its introduction in 1582 in accordance
    with the same rules that it is projected.

[^5]: This means that both 0 (the default in many languages) and -2³¹
    (used by R to indicate missing data or `NA`) are invalid `datey`s.
