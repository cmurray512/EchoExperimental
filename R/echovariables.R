# library(here)
# library(tidyverse)
#
# consolidatedProjects <- c(9211, 9311, 9244)
# cocProjects <- c(2621, 9166, 9583, 3995, 3994, 9379, 9477, 9451)
# yhdpProjects <- c(9499, 9504, 9502, 9503, 9500)
#
# unknown <- c(8, 9, 99)
#
# pType <- data.frame(Code = c(1:4, 6:14),
#                     Label = c("es", "th", "psh", "outreach", "sso", "other", "safeHaven", "phHousingOnlyProject", "phHousingWServicesNoDisability", "dayShelter", "hp", "rrh", "ce"),
#                     Title = c("Emergency Shelter",
#                               "Transitional Housing",
#                               "Permanent Supportive Housing",
#                               "Street Outreach",
#                               "Supportive Services Only",
#                               "Other",
#                               "Safe Haven",
#                               "PH - Housing Only",
#                               "PH - Housing W/Services (No Disability)",
#                               "Day Shelter",
#                               "Homelessness Prevention",
#                               "Rapid Re-Housing",
#                               "Coordinated Entry"))
#
# qAnswer <- data.frame(Code = unknown,
#                       Label = c("clientDoesNotKnow", "clientRefused", "dataNotCollected"),
#                       Title = c("Client Doesn't Know", "Client Refused", "Data Not Collected"))
#
# deepRed       <- "#7C0D0E"
# deepBlue      <- "#072A6C"
# deepGreen     <- "#034B03"
# brightYellow  <- "#FFEB2A"
# brightGreen   <- "#66FF00"
# brightRed     <- "#FF160C"
# brightMagenta <- "#FF00CD"
# deepOrange    <- "#CD3700"
# deepPurple    <- "#540062"
# boldViolet    <- "#710193"
# mediumOrange  <- "#FC6A03"
# lightGrey     <- "#9897A9"
# mediumGrey    <- "#696880"
# deepGrey      <- "#3F3F4E"
# lightBrown    <- "#80471C"
# boldBrown     <- "#4A2511"
# mediumBrown   <- "#371D10"
# deepBrown     <- "#2E1503"
# boldGreen     <- "#028A0F"
# mediumGreen   <- "#32612D"
# brightCyan    <- "#00FFFF"
# lightBlue     <- "#0492C2"
# boldBlue      <- "#0000FF"
# mediumBlue    <- "#1034A6"
# BLACK         <- "#000000"
# WHITE         <- "#FFFFFF"
#
# my_palette_OLD <- data.frame(Hex = c(deepRed,
#                                  deepBlue,
#                                  deepGreen,
#                                  brightYellow,
#                                  brightGreen,
#                                  brightRed,
#                                  brightMagenta,
#                                  deepOrange,
#                                  deepPurple,
#                                  boldViolet,
#                                  mediumOrange,
#                                  lightGrey,
#                                  mediumGrey,
#                                  deepGrey,
#                                  lightBrown,
#                                  boldBrown,
#                                  mediumBrown,
#                                  deepBrown,
#                                  boldGreen,
#                                  mediumGreen,
#                                  brightCyan,
#                                  lightBlue,
#                                  boldBlue,
#                                  mediumBlue,
#                                  BLACK,
#                                  WHITE),
#                          Color = c("deepRed",
#                                    "deepBlue",
#                                    "deepGreen",
#                                    "brightYellow",
#                                    "brightGreen",
#                                    "brightRed",
#                                    "brightMagenta",
#                                    "deepOrange",
#                                    "deepPurple",
#                                    "boldViolet",
#                                    "mediumOrange",
#                                    "lightGrey",
#                                    "mediumGrey",
#                                    "deepGrey",
#                                    "lightBrown",
#                                    "boldBrown",
#                                    "mediumBrown",
#                                    "deepBrown",
#                                    "brightCyan",
#                                    "boldGreen",
#                                    "mediumGreen",
#                                    "lightBlue",
#                                    "boldBlue",
#                                    "mediumBlue",
#                                    "BLACK",
#                                    "WHITE"))
#
# my_palette <- data.frame(Hex = c(deepRed,
#                                  deepBlue,
#                                  deepGreen,
#                                  brightYellow,
#                                  brightGreen,
#                                  brightRed,
#                                  brightMagenta,
#                                  deepOrange,
#                                  deepPurple,
#                                  boldViolet,
#                                  mediumOrange,
#                                  lightGrey,
#                                  mediumGrey,
#                                  deepGrey,
#                                  lightBrown,
#                                  boldBrown,
#                                  mediumBrown,
#                                  deepBrown,
#                                  boldGreen,
#                                  mediumGreen,
#                                  brightCyan,
#                                  lightBlue,
#                                  boldBlue,
#                                  mediumBlue,
#                                  BLACK,
#                                  WHITE),
#                          Color = c("deepRed",
#                                    "deepBlue",
#                                    "deepGreen",
#                                    "brightYellow",
#                                    "brightGreen",
#                                    "brightRed",
#                                    "brightMagenta",
#                                    "deepOrange",
#                                    "deepPurple",
#                                    "boldViolet",
#                                    "mediumOrange",
#                                    "lightGrey",
#                                    "mediumGrey",
#                                    "deepGrey",
#                                    "lightBrown",
#                                    "boldBrown",
#                                    "mediumBrown",
#                                    "deepBrown",
#                                    "boldGreen",
#                                    "mediumGreen",
#                                    "brightCyan",
#                                    "lightBlue",
#                                    "boldBlue",
#                                    "mediumBlue",
#                                    "BLACK",
#                                    "WHITE"))
#
# entry_sit <- here("../", "../", "Data", "ph_destinations_hud.csv")
# ph_dest   <- here("../", "../", "Data", "entry_livingsituation_classification.csv")
# entry_sit_table <- read_csv(entry_sit)
# ph_dest_table   <- read_csv(ph_dest)
#
# save(consolidatedProjects,
#      unknown,
#      pType,
#      qAnswer,
#      my_palette,
#      cocProjects,
#      yhdpProjects,
#      entry_sit_table,
#      ph_dest_table,
#      file = "R/sysdata.rda")
