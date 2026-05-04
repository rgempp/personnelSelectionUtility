# personnelSelectionUtility 0.5.18

This maintenance release adjusts package-site presentation and source-installation behavior.

## Changes

- Replaced the temporary hidden `inst/doc/.keep` creation with a non-hidden `inst/doc/index.html` placeholder created during installation. This should avoid the R CMD check NOTE about hidden files while still preventing vignette-installation failures on Windows.
- Updated `pkgdown/extra.css` so the package logo appears once in the page header for the home, reference, news, and individual article pages, with a controlled size.
- Kept the logo hidden on the article index page to avoid the oversized logo effect there.
- Updated package metadata to version 0.5.18.

No statistical computations or exported functions were changed.
