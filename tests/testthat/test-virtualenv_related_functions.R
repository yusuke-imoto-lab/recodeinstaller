
test_that("Testing for virtualenv related functions. Note that real installation is not performed.", {

    # if virtualenv does not exist, skip the following tests.
    if (!if_virtualenv_exists()) {
        skip("No virtualenv is found. Skipping test_virtualenv_related_functions test.")
    } else {

        # List of existing virtualenv.
        existing_virtualenv <- reticulate::virtualenv_list()[1]

        # Test if install_to_existing_virtualenv returns existing virtualenv name.
        expect_equal(install_to_existing_virtualenv(1),  existing_virtualenv)

        # Test if cancellation works.
        expect_error(install_to_existing_virtualenv(0))

    }

})
