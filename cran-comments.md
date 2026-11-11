# CRAN submission comments — datey 0.1.3

## Summary

This release adds three functions for anniversary-based calculations
(`start_anniversary_day()`, `is_start_anniversary_day()` and
`start_anniversary_day_to_ymd()`).

The maintainer's email address has been updated.

Existing behaviour is unchanged.

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
* Possibly invalid URL
  <https://www.actuaries.org.uk/learn-and-develop/continuous-mortality-investigation>
  (status 503) -- this is the Institute and Faculty of Actuaries' page for
  the Continuous Mortality Investigation. The URL is correct, but the whole
  actuaries.org.uk site has been returning '503 Service Unavailable' since
  at least 30 October 2026. The same URL passed the incoming checks for
  datey 0.1.2.

## Reverse dependencies

This package has no reverse dependencies.
