# datey

R package providing a standardised mapping of dates, including fractions
of a day, onto a discrete annual grid, together with exact date and
duration arithmetic.

## Project outline

- This is a CRAN-targeted R package developed in RStudio
- C++ code lives in `src/` (but this is to be reviewed if we need to
  expose functionality to other packages)

## CRAN compliance

- Warn me if any changes will generate CRAN notes, warnings or errors on
  any current CRAN platform when I submit the package via
  `devtools::check_win_devel()` or similar checks.
- Check Roxygen2 comments for CRAN fails such as non-ASCII characters
  and missing `@returns` statements.
- Avoid Undefined Behaviour (UB)
- Never use pointer casting or unions for type punning
- Code must pass aggressive -Wstrict-aliasing=2 optimizations

## Standards

- R minimum version: **4.0.0**

- Required C++ standard: **C++11**

- All R and C++ files other than those sourced externally must have a
  standard disclaimer at the top.

  The disclaimer for R files is:

  ``` r

  # Date and duration arithmetic on an annual grid for R
  #
  # This file is licensed to you under the MIT License.
  #
  # Copyright (c) Tim Gordon
  ```

  The disclaimer for C++ (including `.cpp` and `.hpp`) files is:

  ``` cpp
  // Date and duration arithmetic on an annual grid for R
  //
  // This file is licensed to you under the MIT License.
  //
  // Copyright (c) Tim Gordon
  ```

## Dependencies

- For R/C++ code interop use the `cpp11` package, i.e. `cpp11::`
  `doubles`, `logicals`, `sexp`, etc. and `[[cpp11::register]]`.
- Do *not* use `Rcpp`, `Rcpp::NumericVector`, or `Rcpp` macros.

## Code style

- For R code follow Tidyverse naming conventions
- For C++ code use PascalCase for naming types and camelCase for naming
  functions and function parameters
- Use modern C++11 idioms
- For C++, use Allman bracket style
- Check for const T&
- Use range-based for loops, const auto&, and explicit single-argument
  constructors

## Language style

Act as a direct, clear human writer.

Always use British English.

Do not use AI-tell phrasing:

- Do not use telegraphic appositive headlines or fragments (“One
  construct, three uses”, “Same core, two bindings”).
- Do not use rule-of-three parallelism for rhythm rather than content.
- Do not use “it isn’t X, it’s Y” reframes or em-dash reframes deployed
  for punch.
- Do introduce lists and points with plain lead-in clauses.
- Do not use any of these words: delve, realm, harness, unlock,
  tapestry, beacon, testament, symphony, navigate, journey, furthermore,
  moreover, ultimately, pivotal, broader, landscape.
- Do not use overly complex punctuation.
- Do not open with introductory filler or close with a summary.
- Vary your sentence length drastically – make some punchy and one
  sentence long.
- Do not explain a concept and then immediately summarise it.

All that said, README.Rmd is in effect a marketing page and is permitted
to be salesy.

## Things Claude should not do

- Do not amend this file `CLAUDE.md`.
- Do not request permission to amend this file `CLAUDE.md`.
- Do not amend any code without my permission.
- Do not download any software.
- Do not add Claude credits e.g. “Co-Authored-By: Claude” in code
  comments or git commit summaries or descriptions.
