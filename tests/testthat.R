
if (!requireNamespace("testthat", quietly = TRUE)) {
    stop("'testthat' package is required for testing. Stop")
}

library(testthat)
library(recodeinstaller)
test_check("recodeinstaller")

