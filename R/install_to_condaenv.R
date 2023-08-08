
#' Install RECODE to new or existing conda environment.
#' 
#' This function creates a new RECODE-enabled conda environment 
#' or install RECODE to an existing conda environment.
#' The reticulate::conda_create and reticulate::conda_install 
#' functions are used.
#' 
#' @return install_info  Vector of install information.
#' @importFrom utils menu
install_to_condaenv <- function() {

    # Check if conda is already installed.
    if (!is_conda_command_available()) {
        stop("In install_to_condaenv:\nconda is not installed. Stopping RECODE installation.")
    }

    # List of conda environments.
    conda_list <- reticulate::conda_list()

    # List of installation options.
    installation_option_list <- c(
        "Create a new conda environment", 
        sprintf("%s%s", "Install RECODE to ", conda_list$name)
        )

    # Name of chosen existing conda environment.
    env_name <- NULL
    
    # Ask user's choice.
    installation_choice <- menu(installation_option_list, 
        title="\nPlease choose the number of your preferred option (0 to quit).")

    # If user's choice is 0, stop.
    if (installation_choice == 0) {
        stop("In install_to_condaenv:\ninstallation was cancelled.")
    }

    tryCatch(
        {
            if (installation_choice == 1) {        
                # Create a new RECODE-enabled conda environment.
                env_name <- create_new_recode_condaenv()
                message(
                    paste0('\nconda environment ', env_name, " was created.\n"))

            } else if (installation_choice >= 2) {

                # Chosen conda environment.
                env_name <- conda_list$name[installation_choice - 1]

                # Install RECODE to the chosen conda environment.
                env_name <- install_to_existing_condaenv(env_name)
            }

            # Make and return install information.
            install_info <- c("conda", env_name)
            return(install_info)
        },
        error = function(e) {
            # Add message.
            error_msg <- paste0('In install_to_condaenv:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)        
        }
    )
}

