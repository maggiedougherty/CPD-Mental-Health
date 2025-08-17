# FOUNDATIONS OF INTERACTIVE 
# Author: Maggie Dougherty
# Date: January 20, 2025
# Updated: Aug 17, 2025 for fact checking
# Topic: Chicago PD UoF 2020-2024

# set working directory
setwd("/Users/MaggieDougherty/Documents/GitHub/CPD-Mental-Health/")

# install packages
install.packages('readxl')
install.packages('tidyverse')
install.packages('tidyr')
install.packages('xlsx')
install.packages('writexl')
install.packages("dplyr")
library(readxl)
library(dplyr)
library(tidyr)

# empty old data (if applicable)
ls()
rm(raw_trr, mh)

# import data
raw_trr <- read_excel("Raw Data/Copy of Chicago UoF 2020-2024.xlsx", sheet = "TRR DATA")

# limit to cases flagged as mental illness related in either the Subj Condition or Type Activity columns
mh <- raw_trr[
  grepl("MENTAL ILL./EMOTIONAL DISORDER", raw_trr$SUBJECT_CONDITION_NEW_TRR, ignore.case = TRUE) |
    grepl("MENTAL HEALTH", raw_trr$`Type Activity New TRR`, ignore.case = TRUE),
]

# make copy of the data with relevant demographic information
working_data <-subset(mh, select = c(`REPORT NO`, INCIDENTDATETIME, `STREET NO`, DIR, `STREET NAME`, CITY, STATE, `ZIP CODE`, `LOCATION CODE`, BEAT, WARD, COMMUNITY, EVENT_NO,SUBJSEX, SUB_RACE, SUB_BIRTHYEAR, SUB_ZIPCODE, SUBJECT_CONDITION_NEW_TRR, SUBJECT_INJURED, SUBJECT_ALLEGED_INJURY, `Subject Med Treatment New TRR`, `Subject Actions`, SUBJECT_HOSPITALIZED, SUBJECT_ARMED, SUBJECTARMEDWITH, WEAPON_PERCEIVED_AS, SUBJECT_WEAPON_USE, `Subject Weapon`, SUBDRUGRELATED, `Type Activity New TRR`, `ReasonForResponse New TRR`, `ForceMitigationEfforts New TRR`, `ControlTactics New TRR`))

# clean incident date + gen year variable
working_data$INCIDENTDATETIME <- strptime(working_data$INCIDENTDATETIME, format = "%d-%b-%Y %H:%M")
working_data$year <- format(working_data$INCIDENTDATETIME, "%Y")

# get counts by year (sanity check)
year_summary <- working_data %>%
  group_by(year) %>%
  summarise(Count = n()) %>%
  arrange(year)

# group by racial demographics and ward
subject_demographics <- working_data %>%
  mutate(WARD = as.numeric(WARD)) %>% # force R to treat ward as numeric for sorting
  group_by(WARD, SUB_RACE) %>%
  summarise(Count = n(), .groups = "drop") %>%
  arrange(WARD, SUB_RACE)

# reshape data wide for flourish
subj_dem_wide <- subject_demographics %>%
  pivot_wider(
    names_from = SUB_RACE,
    values_from = Count,
    values_fill = 0  
  )

# export data
writexl::write_xlsx(subj_dem_wide, 'Processed Data/Subject Demographics_Mental Health Flag_TRRs.xlsx')

# end of file