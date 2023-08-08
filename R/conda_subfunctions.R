#' Subfunction to check if conda command is available.
#' 
#' The reticulate::conda_list function is used.
#' @return  Boolean
is_conda_command_available <- function() {
    conda_list <- NULL

    # Check if conda is already installed.
    tryCatch(
        {
            # List of conda environments.
            conda_list <- reticulate::conda_list()

            # If not fail, return TRUE.
            return(TRUE)
        },
        error = function(e) {
            # If error is caught, return FALSE.
            return(FALSE)
        }
    )
}


#' Subfunction to check if the same conda environment 
#' as the input name already exists.
#'
#' @param env_name  Input environment name to check.
#'
#' @return  Boolean
if_condaenvname_already_exists <- function(env_name) {

    # List of conda environments
    conda_list <- reticulate::conda_list()

    # Count conda environments having same name as the input.
    env_name_count <- sum(tolower(env_name) %in% tolower(conda_list$name))

    # Check if the input environment name exists.
    return((env_name_count >= 1))
}


#' Subfunction to ask new conda environment name.
#' 
#' This function asks the user to enter a name when input variable 
#' (env_name) is not specified.
#' When input env_name is specified, the same env_name is returned 
#' if the same named conda environment does not exist.
#' 
#' @param env_name  Environment name (default to NULL).
#'
#' @return env_name  Environment name entered by the user or same name as the input.
ask_new_condaenv_name <- function(env_name = NULL) {

    # If env_name is not specified, ask user.    
    if (is.null(env_name)) {
        env_name <- readline(
            prompt = paste0(
                '\nPlease enter your preferred environment name in lower case \n',
                'or press Enter to use the default name "recode".\n',
                'If you want to quit installation, please type "quit".'
            )
        )
        # If env_name is not lower case, convert.
        if (!identical(env_name, tolower(env_name))) {
            change_to_lowercase_msg <- paste0(
                "\nThe environment name ",
                dQuote(env_name),
                " will be converted to lower case ",
                dQuote(tolower(env_name)), ".\n"
            )
            message(change_to_lowercase_msg)
            env_name <- tolower(env_name)
        }
    }
    
    # Cancel installation.
    if (env_name == "quit") {
        stop("In ask_new_condaenv_name:\ninstallation was cancelled.")
    }

    # Set default name.
    default_env_name <- "recode"
    if (env_name == "") {
        env_name <- default_env_name
    } 

    # If the same env_name already exists, stop to throw error.
    if (if_condaenvname_already_exists(env_name)) {
        stop(paste0(
            "In ask_new_condaenv_name:\nenvironment ", 
            env_name, 
            " already exists. Cancelling installation.\n"
            )
        )
    }

    return(env_name)
}

#' Subfunction to create a new RECODE-enabled conda environment.
#' 
#' This function creates a new conda environment with reticulate::conda_create, 
#' then installs RECODE to the created environment with reticulate::conda_install.
#' 
#' @param env_name  New environment name, default to NULL.
#' @param if_test  Flag for unit test mode.
#'
#' @return env_name  Created conda environment name.
create_new_recode_condaenv <- function(env_name = NULL, if_test = FALSE) {
    tryCatch(
        {
            # Ask user (default), or check input env_name.
            env_name <- ask_new_condaenv_name(env_name)

            message(paste0("\nCreating a new conda environment ", env_name, "\n"))

            # In test mode, reticulate::conda_create and conda_install are skipped.
            if (!if_test) {
                # Create a new conda environment.
                reticulate::conda_create(envname = env_name)

                message(paste0("\nInstalling RECODE to ", env_name, "\n"))

                # Install RECODE to the new conda environment.
                # pip arguments are set to meet scanpy and numba dependencies.
                reticulate::conda_install(
                    envname = env_name, 
                    packages = c("screcode", "numpy<1.24,>=1.18", "session-info"), 
                    pip = TRUE)
            }

            # Return created condaenv name.
            return(env_name)
        },
        error=function(e) {            
            # Add message
            error_msg <- paste0('In create_new_recode_condaenv:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)
        }
    )
}

#' Subfunction to install RECODE to an existing conda environment.
#' 
#' This function uses reticulate::conda_install.
#' 
#' @param env_name Environment name 
#' @param if_test Flag for unit test mode.
#'
#' @return Name of environment to which RECODE is installed.
install_to_existing_condaenv <- function(env_name, if_test = FALSE) {

    # Stop if condaenv does not exist.
    if (!if_condaenvname_already_exists(env_name)) {
        error_msg <- paste0(
            "In install_to_existing_condaenv:\n",
            env_name,
            " does not exist."
        )
        stop(error_msg)
    }

    # If test mode, skip asking permission.
    if (!if_test) {

        query <- paste0(
            "\nInstalling RECODE to ", 
            env_name, ".",
            "\nVersions of installed packages (e.g., NumPy) may be changed.\n",
            "\nAre you sure you want to proceed?")

        # Ask user whether to proceed installation.
        proceed_install <- ask_permission(query)
        
        # Stop if user cancels installation.
        if (!proceed_install) {
            stop("In install_to_existing_condaenv:\ninstallation was cancelled.")
        }
    }

    tryCatch(
        {
            # Installation is skipped if test mode.
            if (!if_test) {
                # Install RECODE to chosen existing conda environment.
                # pip arguments are set to meet scanpy and numba dependencies.
                reticulate::conda_install(
                    envname = env_name, 
                    packages = c("screcode", "numpy<1.24,>=1.18", "session-info"), 
                    pip = TRUE)
            }
        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In install_to_existing_condaenv:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)
        }
    )

    # Return conda environment name to which RECODE is installed.
    return(env_name)
}

