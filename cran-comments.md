# CRAN submission comments — datey 0.1.0

## Resubmission

This is a resubmission. In response to the CRAN reviewer's comments I have:

* Added `\value` tags to the three `.Rd` files that were missing them
  (`all_of_time.Rd`, `integer_constants.Rd` and `NAs.Rd`), describing both the
  class and the meaning of the value in each case. These pages document
  exported constants rather than functions, which is why I missed adding the
  tags -- apologies.

* Regarding references describing the methods, for *whole* days, the 
  date-to-year mapping is a relatively common but not a unique choice:
  
  - It coincides with the Actual/Actual (ISDA) day-count convention (although
  different conventions prevail in other markets).
  - It has to my knowledge been used in a mortality context by the UK CMI
  (although it's not published as a standard by them).

  That said, the fixed-precision integer representation of sub-day intervals is
  not, to my knowledge, described in any external publication, and so I have not
  added a reference to the DESCRIPTION file. The complete mapping is fully 
  specified in the package's own vignette
  (`vignette("spec", package = "datey")`).

## Test environments

- Windows 11, R 4.6.0 (local)
- Windows (R-devel), via win-builder
- Windows (R-release), via win-builder
- macOS-latest (R-release), Windows-latest (R-release),
  Ubuntu-latest (R-devel, R-release, R-oldrel-1),
  via GitHub Actions (`r-lib/actions/check-standard`)

## R CMD check results

0 errors | 0 warnings | 1 note

## Notes

This is a new submission. The single note is the standard new-submission
flag from the CRAN incoming feasibility check.
