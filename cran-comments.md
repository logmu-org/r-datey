# CRAN submission comments — datey 0.1.3

## Summary

This is a patch release that replaces datey 0.2.0, which I submitted on
30 October 2026 and which is still in the incoming 'waiting' queue.
Please discard that 0.2.0 submission.

On reflection, the breaking change to the `datey_interval` convention
proposed in 0.2.0 has been dropped, so this release has no API changes.
The only other change is the maintainer's email address.

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
