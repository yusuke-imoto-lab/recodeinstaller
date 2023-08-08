
test_that("Testing for binary Python related functions:", {

    # Find local Python binaries
    local_python_binary_list <- find_local_python_binary()

    # If a local Python binary is found, choose the first one as a test data.
    if (length(local_python_binary_list) >= 1) {
        local_python <- local_python_binary_list[1]
        # Test if guess_if_python_binary(local_python) return TRUE.
        expect_true(guess_if_python_binary(local_python))
    }

    # Check OS.
    os <- Sys.info()["sysname"]

    test_dir <- test_path()

    # Dummy file names representing Python binaries.
    dummy_python_win <- file.path(test_dir, "dummy_files", "python.exe")
    dummy_python_unix_311 <- file.path(test_dir, "dummy_files", "python3.11")
    dummy_python_unix_39 <- file.path(test_dir, "dummy_files", "python3.9")

    # Dummy file names representing non-Python binaries.
    dummy_not_python_win <- file.path(test_dir, "dummy_files", "not_python.exe")
    dummy_not_python_unix_311 <- file.path(test_dir, "dummy_files", "not_python3.11")

    # Dummy file names representing non-existing files.
    dummy_not_exist_file <- file.path(test_dir, "dummy_files", "not_exist")



    # expect TRUE for dummy files representing Python binaries.
    switch(os,
        "Windows" = {
            # Test for existing (dummy) Python.
            expect_true(guess_if_python_binary(dummy_python_win))

            # Test for existing (dummy) non-Python.
            expect_false(guess_if_python_binary(dummy_not_python_win))

            # Test for not existing file.
            expect_false(guess_if_python_binary(dummy_not_exist_file))
        },
        {
            # Test for existing (dummy) python 3.11.
            expect_true(guess_if_python_binary(dummy_python_unix_311))

            # Test for existing (dummy) python 3.9.
            expect_true(guess_if_python_binary(dummy_python_unix_39))

            # Test for existing (dummy) non-Python.
            expect_false(guess_if_python_binary(dummy_not_python_unix_311))

            # Test for not existing file.
            expect_false(guess_if_python_binary(dummy_not_exist_file))
        }
    )
})
