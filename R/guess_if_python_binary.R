
#' Subfunction to check if a specified file 
#' has Python binary file name such as  "python.exe" or "python.d{1}.d{1,2}".
#'
#' @param file  File to check.
#'
#' @return  Boolean
is_filename_python <- function(file) {

    # Check OS.
    os <- Sys.info()["sysname"]

    # Get the basename of the file.
    file_name <- basename(file)

    switch(os,
        "Windows" = {
            # On Windows, check if file name is "python.exe"
            return(file_name == "python.exe")
        },
        {
            # Pattern of Python in Linux or macOS.
            pattern <- "^python\\d{1}\\.\\d{1,2}"

            # Check if file name matches the pattern.
            return(grepl(pattern, file_name))
        }
    )
}


#' Subfunction to guess if a specified file is a Python binary
#' 
#' This function checks
#'  * file existence
#'  * if filename is consistent with Python binary
#' @param file  File to check
#'
#' @return  Boolean
#' @importFrom utils file_test
guess_if_python_binary <- function(file) {


    # Check if the file exists and not a directory.
    if (!file_test("-f", file)) {
        return(FALSE)
    }

    # Check if name of specified file includes "python".
    if (!is_filename_python(file)) {
        return(FALSE)
    }

    # Return TRUE if all checks pass.
    return(TRUE)

}