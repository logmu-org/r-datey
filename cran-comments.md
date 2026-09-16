# CRAN submission comments — datey 0.1.2

## Summary

This is a patch release adding `rep()` methods for the S3 classes defined in
this package. Previously `rep()` dropped the class and returned bare integer
or double values, which also caused `pmax()` and `pmin()` to return wrong
values when arguments were recycled. No C++ code has changed.

## Test environments

- Windows 11, R 4.6.1 (local)
- Windows (R-devel), via win-builder
- Windows (R-release), via win-builder
- macOS-latest (R-release), Windows-latest (R-release),
  Ubuntu-latest (R-devel, R-release, R-oldrel-1),
  via GitHub Actions (`r-lib/actions/check-standard`)
- Linux (R-devel) with clang `UndefinedBehaviorSanitizer`, via the R-hub
  `clang-ubsan` container on GitHub Actions

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

This package has no reverse dependencies.
