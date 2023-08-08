#' Install the Python version of RECODE (screcode) for R.
#' 
#' This function enables the user to install 
#' the Python version RECODE by using the R reticulate package.\cr
#' \cr
#' RECODE - resolution of curse of dimensionality in single-cell data analysis : https://github.com/yusuke-imoto-lab/RECODE \cr
#' \cr
#' Ushey K, Allaire J, Tang Y (2023). reticulate: Interface to 'Python'. https://rstudio.github.io/reticulate/, https://github.com/rstudio/reticulate. \cr
#' 
#' This function supports the following types of RECODE installation.
#' - Install Miniconda to create a new RECODE-enabled conda environment (if conda is not installed, recommended)..
#' - Install RECODE to a new or existing conda environment (if conda is installed, recommended).
#' - Install RECODE to an existing virtualenv environment.
#' - Install RECODE using a specified Python binary (e.g., local Python, Python embeddable).
#' 
#' The user can choose their preferred installation type 
#' according to the guidance.
#' 
#' After the installation is done, a directory called "recodeloader", 
#' is created in the working directory.
#' This directory contains an R script for loading the RECODE-enabled Python. 
#' 
#' The user can load the created RECODE-enabled Python by running
#' 
#' source("recodeloader/load_recodeenv.R")
#' 
#' in the working directory.
#' 
#' @export
#' @importFrom utils install.packages menu
install_screcode <- function() {

    # Check if conda (s.t., Anaconda, Miniconda) is installed.
    is_conda_installed <- is_conda_command_available()

    # Make list of installation options.
    if (is_conda_installed) {
        installation_option_list <- c(
            "Install RECODE to a conda environment.",
            "Install RECODE to another Python environment."
        )
    } else {
        installation_option_list <- c(
            "Install Miniconda to create a RECODE-enabled conda environment.",
            "Install RECODE to another Python environment."
        )
    }

    # Ask user's choice.
    users_choice <- menu(
        installation_option_list, 
        title = "\nPlease choose the number of your preferred option (0 to quit).\n")


    # Vector of install information.
    # [1] installation type ["conda", "virtualenv", "binary"]
    # [2] environment name if type is "conda" or "virtualenv",
    #     absolute file path of Python binary if "binary".
    install_info <- NULL


    tryCatch(
        {
            # If conda is installed, propose installing to conda as a option.
            if (is_conda_installed) {
                switch (
                as.character(users_choice),
                "1" = {install_info <- install_to_condaenv()},
                "2" = {install_info <- install_to_another_pythonenv()},
                "0" = stop("In install_screcode:\ninstallation was cancelled.")
                )
            } else {
            # Otherwise, propose installing Miniconda.
                switch (
                as.character(users_choice),
                "1" = {install_info <- install_new_miniconda()},
                "2" = {install_info <- install_to_another_pythonenv()},
                "0" = stop("In install_screcode:\ninstallation was cancelled.")
                )
            }
        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In install_screcode:\n', e$message)

            e$message <- error_msg

            # Throw error.
            stop(e)        
        }
    )

    info_msg <- NULL
    switch(install_info[1],
        "conda" = {
            info_msg <- paste0(
                "\nRECODE was installed in conda environment ",
                install_info[2],
                "\n")
        },
        "virtualenv" = {
            info_msg <- paste0(
                "\nRECODE was installed in virtualenv environment ",
                install_info[2],
                "\n")
        },
        "binary" = {
            info_msg <- paste0(
                "\nRECODE was installed with the specified binary ",
                install_info[2],
                "\n")
        },
    )
    
    # Show install information.
    message(info_msg)

    # Make loader
    tryCatch(
        {
            # Make an R script which loads RECODE-enabled python.
            load_recodeenv_R <- make_loader(install_info)

            # Tell the user how to load.
            message(
                paste0(
                   "The loader R script was created as \n", 
                   dQuote(load_recodeenv_R, q = FALSE),
                   "\n",
                   "You can load the created Python RECODE environment\n",
                    " by loading the script using the source command.")
            )

        },
        error = function(e) {
            message("Loader R script was not created.")
            # Throw error.
            stop(e)                        
        }
    )
}