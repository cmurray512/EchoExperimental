#' Quickly Navigates to Certain Folders in the Research-and-Evaluation-Team Filesystem
#'
#' Shortcut() is a quicker way to use the here() function, customized to provide quick access to the HMIS extracts, CE BNL, and Dashboard Input/Output folders from the Small Data Requests, Dashboards, and Needs and Gaps folders.
#'
#' @param bookmarkedDirectory as a "string", the abbreviated name of the folder your file is in: "extracts," "bnl," "db inputs," or "db outputs."
#' @param ... the rest of the path to you file as you would type it in the here() function.
#'
#' @return Returns the first part of the set of strings to use in the here() function to reach your destination folder, so for example you can type shortcut("extracts", "hmisData_XXXX-XX-XX.rda") instead of here("../", "../", "Datasets", "HMIS_Extracts", "hmisData_XXXX-XX-XX.rda").
#' @export
shortcut <- function(bookmarkedDirectory, ...)
{
    requireNamespace("here",      quietly = TRUE)
    requireNamespace("lubridate", quietly = TRUE)
    requireNamespace("stringr",   quietly = TRUE)

    pathToFile <- as.list(...)

    if(bookmarkedDirectory %in% c("newest extract",
                                  "extracts",
                                  "bnl",
                                  "db inputs",
                                  "db outputs"))
    {
        destination <- switch(bookmarkedDirectory,
                              "newest extract" = list("Datasets", "HMIS_Extracts", stringr::str_c("hmisData_", as.character(lubridate::floor_date(lubridate::floor_date(as.Date(Sys.Date()), "month"), "week") + 4), ".rda")),
                              "extracts"       = list("Datasets", "HMIS_Extracts"),
                              "bnl"            = list("Project Requests", "Small Data Requests", "data", "CA BNL"),
                              "db inputs"      = list("Dashboards", "data", "ART_Inputs"),
                              "db outputs"     = list("Dashboards", "data", "generate_tables_output"))
    }
    else
    {
        stop("ERROR: Cannot determine destination. The options are:\n\n
             \"extracts\"\n
             \"bnl\"\n
             \"db inputs\"\n
             -or-\n
             \"db outputs.\"\n\n
             If you are trying to reach a different destination folder please type the path into the here() function instead of shortcut().")
    }

    if(stringr::str_ends(here::here(), "Small Data Requests")
       | stringr::str_ends(stringr::str_sub(here::here(),-19, -2), "Needs and Gaps/202"))
    {
        upToRoot <- list("../", "../")
    }
    else if(stringr::str_ends(here::here(), "Dashboards"))
    {
        upToRoot <- list("../")
    }
    else
    {
        stop("ERROR: Cannot determine start point. This function can originate from:\n\n
             \"Small Data Requests\"\n
             \"Dashboards\"\n
             -or-\nsubfolders of \"Needs and Gaps\" numbered by year.\n\n
             If you are starting from a different location please use the here() function instead of shortcut().")
    }

    abbreviatedPathToDestination <- list(upToRoot, destination)

    return(here(abbreviatedPathToDestination, pathToFile))
}
