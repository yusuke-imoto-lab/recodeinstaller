
#' Subfunction to install RECODE using a Python binary.
#' 
#' @param python  Python's path
install_recode_using_python_binary <- function(python) {

    # Stop if chosen file seems not to be a Python binary.
    if (!guess_if_python_binary(python)) {
        stop("In choose_python_binary:\nchosen file seems not to be a valid Python path.")
    }

    query <- paste0(
        "Installing RECODE using a specified Python binary \n", 
        python, ".",
        "\nVersions of installed packages (e.g., NumPy) may be changed.\n",
        "\nAre you sure you want to proceed?")

    # Ask user whether to proceed installation.
    proceed_install <- ask_permission(query)

    # Stop if user cancels installation.
    if (!proceed_install) {
        stop("In install_recode_using_python_binary:\ninstallation was canceled.")
    }

    # OS info
    os <- Sys.info()["sysname"]

    # To keep std outputs
    std_outs <- NULL

    # Install RECODE by using pip.
    # pip arguments are set to meet scanpy and numba dependencies.
    tryCatch(
        {
            if (os == "Windows") {
                std_outs <- system2(
                    python, args = c(
                        "-m", "pip", "install", "screcode", "numpy<1.24,>=1.18", "session-info"), 
                        stdout = TRUE, stderr = TRUE)
            } else {
                std_outs <- system2(
                    python, args = c(
                        "-m", "pip", "install", "screcode", sQuote("numpy<1.24,>=1.18", q=FALSE), "session-info"), 
                        stdout = TRUE, stderr = TRUE)                
            }
        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In install_recode_using_python_binary:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)                        
        },
        warning = function(w) {      
            # If warning is caught, re-throw as an error for safety.

            # Add message
            error_msg <- paste0('In install_recode_using_python_binary:\n', w$message)

            # Re-throw as an error.
            stop(error_msg)                        
        }
    )

    # pip error and warning messages
    std_outs_error <- paste(std_outs[grepl("ERROR", std_outs)], collapse = "\n")
    std_outs_warning <- paste(std_outs[grepl("WARNING", std_outs)], collapse = "\n")

    # Count "ERROR" stds (this is for the pip error).
    error_count <- sum(grepl("ERROR", std_outs))

    # Stop if installation fails .
    if (error_count > 0) {
        stop(paste0("Error in installing RECODE. See the following messages.\n", std_outs_error))
    }

    # Count "WARNING" stds (this is for the pip warning).
    warning_count <- sum(grepl("WARNING", std_outs))
    # Warns if any warnings.
    if (warning_count > 0) {
        warning(paste0("WARNING in installing RECODE. See the following messages.\n", std_outs_warning))
    }
}


#' Subfunction to choose a Python binary.
#' 
#' This function asks user to choose a Python binary.
#' Local Python binaries in AppData\\Local\\Programs\\Python or ~/.local/bin are 
#' automatically found and suggested as options.
#' 
#' @return python  File path of the chosen Python binary.
#' @importFrom utils menu
choose_python_binary <- function() {

    # Find local Python
    message("\nFinding local Python binary.\n")
    local_pythons <- find_local_python_binary()

    local_pythons_count <- length(local_pythons)

    # Make list of suggested installation choices.
    installation_choice_list <- c(
        local_pythons, 
        "Choose another Python's path."
        )

    # Choose an installation choice.
    title <- paste0(
        "The following options seem to be available.\n",
        "Please choose the number of your preferred option (0 to quit)."
    )
    
    installation_choice <- menu(installation_choice_list, 
            title = title)

    # Python's path to return.
    python <- NULL

    if (installation_choice == 0) {

        # Cancel Installation
        stop("In choose_python_binary:\ninstallation was cancelled.")

    } else if (installation_choice <= local_pythons_count) {

        # Install with a suggested local Python.
        python <- local_pythons[installation_choice]

    } else if (installation_choice == local_pythons_count+1) {

        # Chosen manually by user.
        message("Please input Python's path.")
        python <- file.choose()
     
    }

    # Return chosen Python.
    return(python)
}


#' Install RECODE using a specified Python binary.
#'
#' @return python  File path of the chosen Python binary.
install_to_existing_pythonenv <- function() {

    # Message to note the risk for user.
    note_risk <- paste0(
        "Installing RECODE using a specified Python binary.\n",
        "This is an option for advanced users.\n",
        "You can choose an arbitrary Python to install RECODE to.\n",
        "However, you should do this with great care since changing \n",
        "important Python binaries\n",
        "(e.g., a Python on which other programs depend)\n",
        "may break dependencies and introduce unpredictable errors."
    )

    # Show the note.
    message(note_risk)

    # Ask the user whether to proceed.
    if_proceed <- ask_permission("Are you sure you want to proceed?")
    
    # If user cancels, stop.
    if (!if_proceed) {
        stop("In install_to_existing_pythonenv:\ninstallation was cancelled.")
    }

    # Python's path to return.
    python <- NULL
    
    # Choose Python binary.
    tryCatch(
        {
            # Choose a Python binary.
            python <- choose_python_binary()
        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In install_to_existing_pythonenv:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)                        
        }
    )
    # Normalized file path.
    python <- normalizePath(python)

    # Install RECODE to chosen Python environment.
    tryCatch(
        {                
            # Install RECODE
            install_recode_using_python_binary(python)

            # Return file path of RECODE-enabled python.
            return(python)
        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In install_to_existing_pythonenv:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)                        
        }
    )
}



