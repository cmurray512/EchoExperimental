#' Chronicity Calculator for a Data Frame of Clients
#'
#' Estimates whether a client may be experiencing chronic homelessness per the available information in the HMIS export.
#'
#' @param entry_file the 'entry' data frame from the list generated/returned by the import_hmis function.
#' @param extractDate the date the CSV/XML extract was pulled from HMIS: YYYY-MM-DD.
#'
#' @return TRUE or FALSE.
#' @export
hmis.estimate_chronicity_list <- function(entry_file, extractDate)
{
    requireNamespace("tidyr", quitely = TRUE)

    entryData <- entry_file %>%
        tidyr::replace_na(list(DisablingCondition = 0)) %>%
        tidyr::replace_na(list(DateToStreetESSH = as.Date(extractDate))) %>%
        tidyr::replace_na(list(TimesHomelessPastThreeYears = 0)) %>%
        tidyr::replace_na(list(MonthsHomelessPastThreeYears = 0))

    disability <- ifelse(entryData$DisablingCondition == 1, TRUE, FALSE)

    timeline <- ifelse((as.integer(as.Date(extractDate) - as.Date(entryData$DateToStreetESSH)) >= 365) | ((entryData$TimesHomelessPastThreeYears >= 4) & (entryData$MonthsHomelessPastThreeYears >= 12)), TRUE, FALSE)

    chronicStatus <- ifelse(disability & timeline, TRUE, FALSE)

    return(chronicStatus)
}
