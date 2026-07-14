# CRAN submission comments — datey 0.1.1

## Summary

This is a patch release addressing the `UndefinedBehaviorSanitizer` report
emailed by Prof Brian Ripley on 2026-07-07, and the corresponding additional
issues (clang-UBSAN and gcc-UBSAN) shown on the package check page.

The sanitiser flagged the potential negation of `NA_INTEGER` (i.e. -2^31) in
C++ code, which is undefined behaviour. The fix moves the negation to inside a 
check that the relevant value is not `NA_INTEGER` -- see `src/S_durationy.cpp`
(search 'integer overflow').

There is no change to observable behaviour on conforming hardware.

## Test environments

- Windows 11, R 4.6.0 (local)
- Windows (R-devel), via win-builder
- Windows (R-release), via win-builder
- macOS-latest (R-release), Windows-latest (R-release),
  Ubuntu-latest (R-devel, R-release, R-oldrel-1),
  via GitHub Actions (`r-lib/actions/check-standard`)
- Linux (R-devel) with clang `UndefinedBehaviorSanitizer`, via the
  `rocker/r-devel-san` container

## R CMD check results

0 errors | 0 warnings | 0 notes

## Undefined behaviour sanitiser

Under `rocker/r-devel-san`, the package tests now run cleanly with no
`UndefinedBehaviorSanitizer` diagnostics.
