#' Saves an HMIS CSV/XML Export in .rda file format.
#'
#' Uses the hmis.import_extract function to read in .csv files from data exported from HMIS per the specified date and saves each tibble to an hmisData_extractdate.rda file instead of returning a list of tibbles. NOTE: This requires you to have a RStudio Project open and use the here() package!
#'
#' @param extractPath the path to the folder containing the HMIS CSV/XML Export .csv files.
#' @param extractDate the date the CSV/XML extract was pulled from HMIS: YYYY-MM-DD.
#' @param saveInDirectory the directory in which you want to save the output file.
#' @param full Defaults to FALSE. If set to TRUE it will include all 14 CSV files from the XML extract instead of the usual 9.
#'
#' @return saves a file called hmisData_extractdate.rda with 9 tibbles: client, services, entry, exit, project, healthanddv, incomebenefits, organization, and disabilities.
#' @export
admin.save_extract <- function(extractPath, extractDate, saveInDirectory, full = FALSE)
{
    requireNamespace("here", quietly = TRUE)
    requireNamespace("readr", quietly = TRUE)
    requireNamespace("stringr", quietly = TRUE)

    if(!full)
    {
        hmisData <- hmis.import_extract(extractPath, extractDate, include_disabilities = TRUE)

        client <- hmisData$client
        entry <- hmisData$entry
        exit <- hmisData$exit
        services <- hmisData$services
        project <- hmisData$project
        healthanddv <- hmisData$healthanddv
        incomebenefits <- hmisData$incomebenefits
        organization <- hmisData$organization
        disabilities <- hmisData$disabilities

        return(save(extractDate,
                    client,
                    entry,
                    exit,
                    services,
                    project,
                    healthanddv,
                    incomebenefits,
                    organization,
                    disabilities,
                    compress = "xz",
                    file = here(saveInDirectory, "/", stringr::str_c("hmisData_", extractDate, ".rda"))))
    }
    else
    {
        client <- readr::read_csv(stringr::str_c(extractPath, "Client.csv"))
        current_living_situation <- readr::read_csv(stringr::str_c(extractPath, "CurrentLivingSituation.csv"))
        disabilities <- readr::read_csv(stringr::str_c(extractPath, "Disabilities.csv"))
        enrollment <- readr::read_csv(stringr::str_c(extractPath, "Enrollment.csv"))
        enrollment_CoC <- readr::read_csv(stringr::str_c(extractPath, "EnrollmentCoC.csv"))
        exit <- readr::read_csv(stringr::str_c(extractPath, "Exit.csv"))
        funder <- readr::read_csv(stringr::str_c(extractPath, "Funder.csv"))
        health_and_dv <- readr::read_csv(stringr::str_c(extractPath, "HealthAndDV.csv"))
        income_benefits <- readr::read_csv(stringr::str_c(extractPath, "IncomeBenefits.csv"))
        inventory <- readr::read_csv(stringr::str_c(extractPath, "Inventory.csv"))
        organization <- readr::read_csv(stringr::str_c(extractPath, "Organization.csv"))
        project <- readr::read_csv(stringr::str_c(extractPath, "Project.csv"))
        project_CoC <- readr::read_csv(stringr::str_c(extractPath, "ProjectCoC.csv"))
        services <- readr::read_csv(stringr::str_c(extractPath, "Services.csv"))

        return(save(extractDate,
                    client,
                    current_living_situation,
                    disabilities,
                    enrollment,
                    enrollment_CoC,
                    exit,
                    funder,
                    health_and_dv,
                    income_benefits,
                    inventory,
                    organization,
                    project,
                    project_CoC,
                    services,
                    compress = "xz",
                    file = here::here(saveInDirectory, "/", stringr::str_c("CSV_Extract_", extractDate, ".rda"))))
    }
}
