
#' Make an R script which loads RECODE-enabled Python environment.
#' 
#' This function creates directory "recodeloader" in 
#' the working directory to output an R script "load_recodeenv.R" 
#' into the directory. 
#' If installation is done using a Python binary,
#' .RData file "install_info.RData", 
#' which contains Python's path information, 
#' is also created in the same directory.
#' 
#' The user can load the created RECODE-enabled Python by running
#' 
#' source("recodeloader/load_recodeenv.R")
#' 
#' in the working directory.
#'
#' @param install_info  Install information
#'
#' @return File path of created "load_recodeenv.R" is returned.
make_loader <- function(install_info) {

    message("Making an R script which loads RECODE-enabled Python.")

    # Output directory
    loader_dir <- file.path(getwd(), "recodeloader")

    # Create directory (if not exists).
    dir.create(loader_dir, showWarnings = TRUE)

    # Output to "load_recodeenv.R" on working directory. 
    load_recodeenv_R <- file.path(loader_dir, "load_recodeenv.R")

    # Data file to output install information (used only when "binary" case)
    RData <- file.path(loader_dir, "install_info.RData")
    


    # If the loader already exists, ask user whether to overwrite.
    if (file.exists(load_recodeenv_R)) {
        query <- paste0(
            '"recodeloader/load_recodeenv.R" already exists. \n',
            'Do you want to overwrite it?\n',
            'Please choose the number of your preferred option.'
        )

        if_overwrite <- ask_permission(query)

        if (!if_overwrite) {
             stop("In make_loader:\nloader R script was not created.")
        }
    }

    if (install_info[1] == "binary") {
        # If the "install_info.RData" already exists, ask user if overwrite.
        if (file.exists(RData)) {
            query <- paste0(
                'Installation .RData file already exists. \n',
                'Do you want to overwrite it?\n',
                'Please choose the number of your preferred option.'
            )
            if_overwrite <- ask_permission(query)

            if (!if_overwrite) {
                stop("In make_loader:\nloader R script was not created.")
            }
        }
    }


    # Make an R script command to load RECODE-enabled Python environment.
    # First, we make the message part.
    r_script <- paste0("message(", dQuote("Load installed Python RECODE.", q = FALSE), ")\n")

    # Next, make reticulate::use* part.
    switch(install_info[1],
        "conda" = {            
            # reticulate::use_condaenv 
            use_condaenv_command <- paste0(
                "\nreticulate::use_condaenv(",
                dQuote(install_info[2], q = FALSE),
                ")\n"
            )
            r_script <- paste0(
                r_script, 
                use_condaenv_command
            )
        },
        "virtualenv" = {            
            # reticulate::use_virtualenv 
            use_virtualenv_command <- paste0(
                "\nreticulate::use_virtualenv(",
                dQuote(install_info[2], q = FALSE),
                ")\n"
            )
            r_script <- paste0(
                r_script, 
                use_virtualenv_command
            )
        },
        "binary" = {            
            # Save Python's path to RData file.
            python_info <- install_info[2]
            save(python_info, file = RData)


            # R command: script_dir <- dirname(sys.frame(1)$ofile)
            specify_dir_command <- "script_dir <- dirname(sys.frame(1)$ofile)\n"
        
            # R command: RData <- file.path(script_dir, "install_info.RData")
            make_RData_command <- 'RData <- file.path(script_dir, "install_info.RData")\n'

            # R command: if (!file.exists(RData)) stop("Installation .RData file was not found.")
            check_existence_command <- 'if (!file.exists(RData)) stop("Installation .RData file was not found.")\n'

            # R command: python <- get(load(RData))
            load_command <- paste0(
                "python",
                " <- ",
                "get(load(RData))\n"
            )
            # reticulate::use_python
            use_python_command <- "\nreticulate::use_python(python)\n"

            # R script
            r_script <- paste0(
                r_script, 
                specify_dir_command,
                make_RData_command,
                check_existence_command,
                load_command,
                use_python_command
            )
        }
    )

    # Output to R script file.
    tryCatch(
        {
            # Output to file
            cat(r_script, file =  load_recodeenv_R)
        },
        error = function(e) {
            # Add message
            error_msg <- paste0('In make_loader:\n', e$message)

            e$message <- error_msg

            # Re-throw error.
            stop(e)                        
        }
    )

    return(load_recodeenv_R)
}

