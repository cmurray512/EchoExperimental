#' Read in an HMIS CSV/XML Export
#'
#' Reads in .csv files from data exported from HMIS per the specified date and returns a list of tibbles.
#'
#' @param extractPath the path to the folder containing the HMIS CSV/XML Export .csv files.
#' @param extractPath the path to the folder containing the HMIS CSV/XML Export .csv files.
#' @param include_disabilities OPTIONAL: specifies whether to import the disabilities file (defaults to FALSE).
#'
#' @return a list of 8-9 tibbles: client, services, entry, exit, project, healthanddv, incomebenefits, & organization (and disabilities if include_disabilities = TRUE).
#' @export
hmis.import_extract <- function(extractPath, extractDate, ..., include_disabilities = FALSE)
{
    requireNamespace("dplyr", quitely = TRUE)
    requireNamespace("readr", quitely = TRUE)
    requireNamespace("stringr", quitely = TRUE)
    requireNamespace("lubridate", quitely = TRUE)
    requireNamespace("tibble", quitely = TRUE)

    client <- readr::read_csv(stringr::str_c(extractPath, "Client.csv")) %>%
        dplyr::mutate(Gender = dplyr::case_when(is.na(GenderNone) == FALSE ~ "Data not collected",
                                                NoSingleGender == 1 ~ "No Single Gender",
                                                Questioning == 1 ~ "Questioning",
                                                Female == 1 ~ "Female",
                                                Male == 1 ~ "Male",
                                                TRUE ~ "Other"),
                      Transgender = dplyr::case_when(is.na(GenderNone) == FALSE ~ "Data not collected",
                                                     Transgender == 1 ~ "Transgender",
                                                     TRUE ~ "Not transgender"),
                      Ethnicity = dplyr::case_when(Ethnicity == 0 ~ "Non-Hispanic/Non-Latino",
                                                   Ethnicity == 1 ~ "Hispanic/Latino",
                                                   Ethnicity %in% c(8,9,99) ~ "Unknown"),
                      Race = dplyr::case_when(AmIndAKNative == 1 & (Asian + BlackAfAmerican + NativeHIPacific + White) == 0 ~ "AmIndAKNative",
                                              Asian == 1 & (AmIndAKNative + BlackAfAmerican + NativeHIPacific + White) == 0 ~ "Asian",
                                              BlackAfAmerican == 1 & (AmIndAKNative + Asian + NativeHIPacific + White) == 0 ~ "BlackAfAmerican",
                                              NativeHIPacific == 1 & (AmIndAKNative + Asian + BlackAfAmerican + White) == 0 ~ "NativeHIOtherPacific",
                                              White == 1 & (AmIndAKNative + Asian + BlackAfAmerican + NativeHIPacific) == 0 ~ "White",
                                              (AmIndAKNative + Asian + BlackAfAmerican + NativeHIPacific + White) >= 2 ~ "Two or more races",
                                              is.na(RaceNone) == FALSE ~ "Data not collected"),
                      Race_Ethnicity = dplyr::case_when(Ethnicity == "Hispanic/Latino" ~ "Hispanic/Latino",
                                                        TRUE ~ Race),
                      Age = lubridate::interval(DOB, lubridate::ymd(extractDate)) %/% lubridate::years(1)) %>%
        dplyr::select(PersonalID, Race, Ethnicity, Race_Ethnicity, Gender, Transgender, VeteranStatus, DOB, Age)

    entry <- readr::read_csv(stringr::str_c(extractPath, "Enrollment.csv")) %>%
        dplyr::select(EnrollmentID,
                      HouseholdID,
                      PersonalID,
                      ProjectID,
                      EntryDate,
                      MoveInDate,
                      LivingSituationEntry = LivingSituation,
                      HOH = RelationshipToHoH,
                      DisablingCondition,
                      LengthOfStay,
                      LOSUnderThreshold,
                      PreviousStreetESSH,
                      DateToStreetESSH,
                      TimesHomelessPastThreeYears,
                      MonthsHomelessPastThreeYears) %>%
        dplyr::mutate(ConsolidatedProject = dplyr::if_else(ProjectID %in% consolidatedProjects, TRUE, FALSE)) %>%
        dplyr::mutate(Chronic = dplyr::case_when(DisablingCondition == 1 &
                                                     LivingSituationEntry %in% c(1, 16, 18) &
                                                     LengthOfStay == 5 | EntryDate - DateToStreetESSH >= 365 ~ 1,
                                                 DisablingCondition == 1 &
                                                     LivingSituationEntry %in% c(1, 16, 18) &
                                                     TimesHomelessPastThreeYears == 4 &
                                                     MonthsHomelessPastThreeYears %in% c(112, 113) ~ 1,
                                                 DisablingCondition == 1 &
                                                     LivingSituationEntry %in% c(15, 6, 7, 25, 4, 5) &
                                                     LOSUnderThreshold == 1 &
                                                     PreviousStreetESSH == 1 &
                                                     EntryDate - DateToStreetESSH >= 365 ~ 1,
                                                 DisablingCondition == 1 &
                                                     LivingSituationEntry %in% c(15, 6, 7, 25, 4, 5) &
                                                     LOSUnderThreshold == 1 &
                                                     PreviousStreetESSH == 1 &
                                                     TimesHomelessPastThreeYears == 4 &
                                                     MonthsHomelessPastThreeYears %in% c(112, 113) ~ 1,
                                                 TRUE ~ 0)) %>%
        dplyr::mutate(EstimatedChronicity = hmis.estimate_chronicity_list(entry, extractDate))

    exit <- readr::read_csv(stringr::str_c(extractPath, "Exit.csv")) %>%
        dplyr::select(EnrollmentID, PersonalID, ExitDate, Destination)

    # Creates list of most recent service per enrollment
    services <- readr::read_csv(stringr::str_c(extractPath, "Services.csv")) %>%
        dplyr::select(EnrollmentID, PersonalID, LatestServiceDate = DateProvided) %>%
        dplyr::arrange(dplyr::desc(LatestServiceDate)) %>%
        dplyr::distinct(EnrollmentID, .keep_all = TRUE)

    project <- readr::read_csv(stringr::str_c(extractPath, "Project.csv")) %>%
        dplyr::select(OrganizationID, ProjectID, ProjectName, ProjectType) %>%
        dplyr::mutate(ConsolidatedProject = dplyr::if_else(ProjectID %in% consolidatedProjects, TRUE, FALSE)) %>%
        dplyr::mutate(ActiveProject = dplyr::if_else(!stringr::str_detect(ProjectName, "ZZZ"), TRUE, FALSE))

    projectcoc <- readr::read_csv(stringr::str_c(extractPath, "ProjectCoC.csv")) %>%
        dplyr::select(ProjectID, CoCCode)

    healthanddv <- readr::read_csv(stringr::str_c(extractPath, "HealthAndDV.csv")) %>%
        dplyr::arrange(dplyr::desc(InformationDate)) %>%
        dplyr::distinct(PersonalID, .keep_all = TRUE) %>%
        dplyr::select(PersonalID, DomesticViolenceVictim, CurrentlyFleeing)

    incomebenefits <- readr::read_csv(stringr::str_c(extractPath, "IncomeBenefits.csv")) %>%
        dplyr::group_by(EnrollmentID, PersonalID) %>%
        dplyr::filter(DataCollectionStage == max(DataCollectionStage)) %>%
        dplyr::ungroup() %>%
        dplyr::select(EnrollmentID, PersonalID, IncomeFromAnySource, TotalMonthlyIncome, Earned, EarnedAmount, DataCollectionStage)

    organization <- readr::read_csv(stringr::str_c(extractPath, "Organization.csv")) %>%
        dplyr::select(OrganizationID, OrganizationName) %>%
        dplyr::left_join(project, by = 'OrganizationID') %>%
        dplyr::select(ProjectID, OrganizationName)

    if (!include_disabilities)
    {
        output <- list(client = as_tibble(client),
                       entry = as_tibble(entry),
                       exit = as_tibble(exit),
                       services = as_tibble(services),
                       project = as_tibble(dplyr::left_join(project, projectcoc, by = 'ProjectID')) %>%
                           dplyr::relocate(ActiveProject, .after = last_col()) %>%
                           dplyr::relocate(ConsolidatedProject, .after = last_col()),
                       healthanddv = as_tibble(healthanddv),
                       incomebenefits = as_tibble(incomebenefits),
                       organization = as_tibble(organization))
    }
    else
    {
        disabilities <- readr::read_csv(stringr::str_c(extractPath, "Disabilities.csv")) %>%
            dplyr::filter(DataCollectionStage == 1) %>%
            dplyr::count(PersonalID, EnrollmentID, DisabilityType, DisabilityResponse) %>%
            dplyr::mutate(DisabilityType_Label = dplyr::case_when(DisabilityType == 5 ~ "Physical disability",
                                                                  DisabilityType == 6 ~ "Developmental disability",
                                                                  DisabilityType == 7 ~ "Chronic health condition",
                                                                  DisabilityType == 8 ~ "HIV/AIDS",
                                                                  DisabilityType == 9 ~ "Mental health problem",
                                                                  DisabilityType == 10 ~ "Substance abuse")) %>%
            tidyr::pivot_wider(id_cols = c(PersonalID, EnrollmentID), names_from = DisabilityType_Label, values_from = DisabilityResponse) %>%
            dplyr::mutate(dplyr::across(`Mental health problem`:`Substance abuse`, ~tidyr::replace_na(.x, 0)),
                          dplyr::across(`Mental health problem`:`Substance abuse`, ~replace(., . %in% c(8,9,99), NA)),
                          'Substance abuse' = dplyr::case_when(`Substance abuse` > 0 ~ 1,
                                                               TRUE ~ 0))

        output <- list(client = as_tibble(client),
                       entry = as_tibble(entry),
                       exit = as_tibble(exit),
                       services = as_tibble(services),
                       project = as_tibble(dplyr::left_join(project, projectcoc, by = 'ProjectID')) %>%
                           dplyr::relocate(ActiveProject, .after = last_col()) %>%
                           dplyr::relocate(ConsolidatedProject, .after = last_col()),
                       healthanddv = as_tibble(healthanddv),
                       incomebenefits = as_tibble(incomebenefits),
                       organization = as_tibble(organization),
                       disabilities = as_tibble(disabilities))
    }

    return(output)
}
