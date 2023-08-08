random_string <- function() {

    #return random 6 characters.
    return(paste0(sample(letters, 6, replace = TRUE), collapse = ""))

}


test_that("Testing for conda related functions. Note that real installation is not performed.", {

    # if conda command is not available, skip the following tests.
    if (!is_conda_command_available()) {
        skip("conda is not installed. Skipping test_conda_related_functions test.")
    } else {

        # Test if if_condaenvname_already_exists("base") is TRUE.
        expect_true(if_condaenvname_already_exists("base"))

        if ("recode" %in% reticulate::conda_list()$name) {
            # If "recode" already exists, 
            # test if ask_new_condaenv_name throws error.
            expect_error(ask_new_condaenv_name(""))
        } else {
            # Otherwise, test if ask_new_condaenv_name returns default name.
            expect_equal(ask_new_condaenv_name(""), "recode")
        }

        # Test if ask_new_condaenv_name throws error for "quit".
        expect_error(ask_new_condaenv_name("quit"))

        # Test if ask_new_condaenv_name throws error for "base".
        expect_error(ask_new_condaenv_name("base"))

        # Test if create_new_recode_condaenv throws error for "base".
        expect_error(create_new_recode_condaenv("base", if_test = TRUE))

        # Test if create_new_recode_condaenv throws error for "base".
        expect_error(create_new_recode_condaenv("base", if_test = TRUE))

        # Test if create_new_recode_condaenv returns env_name for random input, 
        # since the same name environment is highly expected not to exist.
        env_name <- random_string()
        expect_equal(create_new_recode_condaenv(env_name, if_test = TRUE), env_name)

        # Test if create_new_recode_condaenv throws error for env_name "base".
        env_name <- "base"
        expect_error(create_new_recode_condaenv(env_name, if_test = TRUE))

        # Test if install_to_existing_condaenv throws error for random input, 
        # since the same name environment is highly expected not to exist.
        env_name <- random_string()
        expect_error(install_to_existing_condaenv(env_name, if_test = TRUE))

        # Test if install_to_existing_condaenv returns same name for "base", 
        # since the same name environment is highly expected to exist.
        env_name <- "base"
        expect_equal(install_to_existing_condaenv(env_name, if_test = TRUE), env_name)

    }

})
