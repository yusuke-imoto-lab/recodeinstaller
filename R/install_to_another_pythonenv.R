#' Install RECODE to another Python environment other than conda.
#' 
#' This function enables the user to install RECODE to 
#' an existing virtualenv or a Python environment using
#' a specified binary.
#' 
#' @return install_info  Vector of install information.
#' @importFrom utils menu
install_to_another_pythonenv <- function() {

    # Check if virtualenv environment already exists.
    is_virtualenv_available <- if_virtualenv_exists()

    if (is_virtualenv_available) {
        # If existing virtualenv is available, 
        # virtualenv is proposed as the first option.
        installation_option_list <- c(
            "Install RECODE to an existing virtualenv.",
            "Install RECODE using a specified Python binary.")
    } else {
        # Otherwise, propose using specified Python binary.
        installation_option_list <- c(
            "Install RECODE using a specified Python binary.")
    }


    title <- paste0(
            "\nInstalling RECODE to an existing Python environment other than conda.\n",
            "Please choose the number of your preferred option (0 to quit)."
            )

    # Ask user's choice.
    users_choice <- menu(
        installation_option_list, 
        title = title
        )

    # Variables to make the install information.
    install_info <- NULL

    tryCatch(
        {
            if (is_virtualenv_available) {
                # The case when virtualenv is an option.
                switch (
                as.character(users_choice),
                "1" = {
                    # Install to virtualenv.
                    virtualenv_name <- install_to_existing_virtualenv()
                    
                    # RECODE-enabled virtualenv name is set to the install info.
                    install_info <- c("virtualenv", virtualenv_name)
                    },
                "2" = {
                    # Install to a Python environment using a specified Python binary.
                    python <- install_to_existing_pythonenv()

                    #  RECODE-enabled Python file is set to the install info.
                    install_info <- c("binary", python)
                    },
                "0" = stop("In install_to_another_pythonenv:\ninstallation was cancelled.")
                )
            } else {
                switch (
                as.character(users_choice),
                "1" = {
                    # Install to a Python environment using a specified Python binary.
                    python <- install_to_existing_pythonenv()

                    #  RECODE-enabled Python file is set to the install info.
                    install_info <- c("binary", python)
                    },
                "0" = stop("In install_to_another_pythonenv:\ninstallation was cancelled.")
                )
            }
            
            # Return install information.
            return(install_info)

        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In install_to_another_pythonenv:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)        

        }
    )
}
