#' Subfunction to ask user's permission 
#' for the query.
#'
#' @param query  Query
#'
#' @return Boolean
#' @importFrom utils menu
ask_permission <- function(query) {

    if_proceed <- menu(c("Yes", "No"), title = query)

    if (if_proceed == 1) {
        return(TRUE)
    } else {
        return(FALSE)
    }
}