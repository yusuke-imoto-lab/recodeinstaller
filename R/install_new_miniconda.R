#' Install Miniconda to create a new RECODE-enabled conda environment.
#' 
#' This function installs Miniconda with reticulate::install_minicona, 
#' and create a new conda environment to install RECODE.
#'
#' @return install_info  Vector of install information.
install_new_miniconda <- function() {
    
    # Stop if conda is already available.
    if (is_conda_command_available()) {
        stop("In install_new_miniconda:\nconda is already installed. Stopping Miniconda installation.")
    }

    # Ask whether to proceed Miniconda installation.
    proceed_installation <- ask_permission("\nProceed with installation of Miniconda?")

    if (proceed_installation) {
        # Install Miniconda
        reticulate::install_miniconda()
    } else {
        stop("In install_new_miniconda:\nMiniconda installation was cancelled.")
    }

    # Environment name.
    env_name <- NULL
    
    # Create RECODE environment.
    tryCatch(
        {
            # Create new condaenv.
            env_name <- create_new_recode_condaenv()
        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In install_new_miniconda:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)        
        }
    )

    message(paste0('\nconda environment ', env_name, " was created.\n"))
    
    # Make and return install information vector.
    install_info <- c("conda", env_name)
    return(install_info)
}