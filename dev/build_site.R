# Build pkgdown website locally.
# Run this from the package root after installing dependencies.

if (!requireNamespace("pkgdown", quietly = TRUE)) {
  install.packages("pkgdown")
}

pkgdown::build_site()
