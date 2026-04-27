---
output: github_document
---

<!--
**Make sure you're editing README.Rmd, *not* README.md!!**
(README.md is generated from README.Rmd.)

After changing this file, run `devtools::build_readme()`!!
-->

```{r, include = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "man/figures/README-",
  out.width = "100%"
)
```

# datey <img src="man/figures/logo.png" align="right" />
<!-- badges: start -->
<!-- badges: end -->

The goal of datey is to ...

standardise annual, i.e. year-based calculations e.g. as required for actuarial
mortality experience analyses or valuations.

- Fixed precision dates for calendar years [1000, 3000)
- Technically this is the Proleptic Gregorian calendar

Guarantees:

- Can represent start and middle of any day leap year and non leap year
- Years divisible by 120

You can convert from standard base R dates (`Date`, `POSIXct` and `POSIXlt`).

Key argument is `day_fraction`. Simpler just to use `start_day`, `mid_day` or 
`end_day`.

For instance

- start of E2R is typically included, so use `start_day`.
- if the individual survived then the end of the E2R is also typically included, 
so use `end_day`. This means that if the E2R comprises separate periods then 
they will interlock correctly (E2Rs being [measurable](https://timgord.com/2025-08/mortality-measures-matter/#Insight2))
- If the individual died then on average this is during the final day and so 
use `mid_day`.


## Installation

You can install the development version of datey from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("logmu-org/r-datey")
```

## Example

This is a basic example which shows you how to solve a common problem:

```{r example}
library(datey)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so:

```{r cars}
summary(cars)
```

You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots in the man/figures folder, for example:

```{r pressure, echo = FALSE}
plot(pressure)
```

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN.
