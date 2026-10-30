# CRAN submission comments — datey 0.2.0

## Summary

This is a minor release with one deliberate breaking change.
The interval convention for `datey_interval` has been changed
from left-closed, right-open `[start, end)`
to left-open, right-closed `(start, end]`
for consistency with survival analysis and actuarial exposed-to-risk.
This means that `%includes%` now
excludes an interval's start and includes its end, and
intervals print as `(start, end]`.

## Maintainer email

The maintainer's email address has changed
- from: Tim Gordon <tim.gordon@btinternet.com>
- to: Tim Gordon <tim@timgord.com>

I can confirm the change from the old address.

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

0 errors | 0 warnings | 1 note

* New maintainer -- the maintainer email address has changed (per the above)

## Reverse dependencies

This package has no reverse dependencies.
