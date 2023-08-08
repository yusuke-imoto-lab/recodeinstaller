#' Subfunction to check if virtualenv already exists.
#' 
#' This function uses reticulate::virtualenv_list.
#' @return Boolean
if_virtualenv_exists <- function() {

    # List of existing virtualenv environments.
    virtualenv_list <- reticulate::virtualenv_list()
    
    # List of possible installation choices.
    if (!identical(virtualenv_list, character(0))) {
        return(TRUE)
    } else {
        return(FALSE)
    }
}



#' Install RECODE to an existing virtualenv.
#' 
#' This function installs RECODE to an existing virtualenv environment
#' with reticulate::virtualenv_install.
#' Note that creation of new virtualenv is not supported.
#'
#' @param installation_choice  Default to NULL, specified iff test mode.
#' 
#' @return virtualenv name to which RECODE is installed.
#' @importFrom utils menu
install_to_existing_virtualenv <- function(installation_choice = NULL) {

    message("\nInstalling to existing virtualenv.\n")

    # If there's no existing virtualenv, stop.
    if (!if_virtualenv_exists()) {
        stop("In install_to_existing_virtualenv:\nno existing virtualenv found.")
    }

    # If installation_choice is given, set to be test mode.
    if_test <- !is.null(installation_choice)

    # installation_choice must be 0 or 1 in test mode.
    if (if_test) {
        if ((installation_choice != 0) && (installation_choice != 1)) {
                stop("In install_to_existing_virtualenv (test mode):\ninstallation_choice is invalid.")
            }
    }

    # List of existing virtualenv environments.
    virtualenv_list <- reticulate::virtualenv_list()

    # List of installation choices.
    installation_choice_list <- c(sprintf("%s%s", "Install RECODE to ", virtualenv_list))

    # If not test mode, ask user's choice.
    if (!if_test) {
        # User's choice.
        installation_choice <- menu(installation_choice_list, 
                title="Please choose the number of your preferred option (0 to quit).")
    }

    if (installation_choice >= 1) {
        # Chosen virtualenv name.
        virtualenv <- virtualenv_list[installation_choice]


        # If test mode, skip asking permission.
        if (!if_test) {
            query <- paste0(
                "\nInstalling RECODE to ", 
                virtualenv, ".",
                "\nVersions of installed packages (e.g., NumPy) may be changed.\n",
                "\nAre you sure you want to proceed?")

            # Ask user whether to proceed installation.
            proceed_install <- ask_permission(query)

            # Stop if user doesn't want installation.
            if (!proceed_install) {
                stop("In install_to_existing_virtualenv:\ninstallation of RECODE was cancelled.")
            }
        }

        tryCatch(
            {
                # If test mode, virtualenv_install is skipped.
                if (!if_test) {
                    # Install RECODE to the virtualenv.
                    # pip arguments are set to meet scanpy and numba dependencies.
                    reticulate::virtualenv_install(
                        envname = virtualenv, 
                        packages = c("screcode", "numpy<1.24,>=1.18", "session-info"))
                }

                # Return virtualenv name to which RECODE is installed.
                return(virtualenv)
            },
            error = function(e) {
                # Add message
                error_msg <- paste0('In install_to_existing_virtualenv:\n', e$message)

                e$message <- error_msg

                # Re-throw error.
                stop(e)                        
            }
        )
        
    } else if (installation_choice == 0) {
        stop("In install_to_existing_virtualenv:\ninstallation was cancelled.")
    }
}



