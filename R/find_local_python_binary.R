#' Subfunction to find Python binary in AppData\\Local\\Programs\\Python.
#' 
#' This function finds local Python in Windows.
#' @return appdata_pythons  Python binaries in AppData\\Local\\Programs\\Python.
find_python_in_AppData <- function() {

    # Get username and OS info.
    user <- Sys.info()["user"]
    os <- Sys.info()["sysname"]

    # Home directory.
    home <- paste0("C:\\Users\\", user)

    # Absolute path of AppData\Local\Programs\Python.
    appdata <- paste0(
        "C:\\Users\\", 
        user, 
        "\\AppData\\Local\\Programs\\Python")
    
    # Find Python in AppData\Local\Programs\Python.
    appdata_pythons <- list.files(
        path = appdata, 
        pattern = "python.exe", 
        recursive = TRUE,
        full.names = TRUE)

    # "python.exe" at the top level of folder.
    appdata_pythons <- appdata_pythons[
        !grepl("venv", appdata_pythons)]

    # Return Python in AppData\Local\Programs\Python.
    return(appdata_pythons)
}



#' Subfunction to find Python binary in ~/.local/bin.
#' 
#' This function finds local system Python in Linux or macOS.
#' @return pythons  Python binaries in ~/.local/bin.
find_python_in_local_bin <- function() {

    # Find Python in ~/.local/bin.
    local_bin <- file.path(path.expand("~"), ".local","bin")

    # Pattern for find files such as "python2.7" or "python3.11".
    pattern <- "python\\d{1}.\\d{1}$|python\\d{1}.\\d{2}$"

    # Python binaries in ~/.local/bin
    pythons <- list.files(
        path = local_bin, 
        pattern = pattern, 
        full.names = TRUE)

    return(pythons)

}

#' Subfunction to find local system Python binaries.
#' 
#' This function finds local Python binaries depending on OS.
#' 
#' @return pythons  List of found Python binaries.
find_local_python_binary <- function() {

    # Get the OS info.
    os <- Sys.info()["sysname"]

    if (os == "Windows") {
        
        # Find Python binaries in AppData\Local\Programs\Python.
        pythons <- find_python_in_AppData()

        return(pythons)
        
    } else {    
        
        # Find Python binaries in ~/.local/bin.
        pythons <- find_python_in_local_bin()

        return(pythons)
    }

}