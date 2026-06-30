# CRAN submission comments — datey 0.1.0

## Resubmission

This is a resubmission.

Responses to CRAN reviewer's comments:

1.  Add references describing the methods in your package

    The fixed-precision integer representation of dates in this package is not,
    to my knowledge, described in any external publication, which is why I have
    not added a reference to the DESCRIPTION file.

    The complete mapping is fully specified in the package's own vignette
    (`vignette("spec", package = "datey")`).

    For *whole days* only (as opposed to the fractional days implemented by this
    package), adjusting day length inversely to the number of days in the
    relevant calendar year is a common and obvious approach. For instance:

    - In a mortality context, this approach has sometimes been used by the UK
      CMI (although it's not published as a standard by them).

    - The Actual/Actual (ISDA) standardises this as the day-count convention for
      derivatives markets (although different conventions prevail in other 
      financial markets).

    But these describe a whole-day day-count convention, not the fixed-precision
    sub-day method used in this package, and so I don't think they are suitable
    as references for the method this package actually implements.

2.  Missing `\value` Rd-tags

    I have added `\value` tags to the items that were missing them (mapping to 
    the files `all_of_time.Rd`, `integer_constants.Rd` and `NAs.Rd`), describing
    both the class and the meaning of the value in each case.

    These are exported constants rather than functions and they didn't show up
    in any of the checks I ran, which is why I missed adding the tags originally
    -- apologies.


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
