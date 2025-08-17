# FOUNDATIONS OF INTERACTIVE 
# Author: Maggie Dougherty
# Date: January 20, 2025
# Topic: Chicago PD UoF 2020-2024

# set working directory
setwd("/Users/MaggieDougherty/Desktop/Northwestern/Q2/Chicago Investigative Lab/UoF/")

# install packages
install.packages('readxl')
install.packages('tidyverse')
install.packages('tidyr')
install.packages('reshape2')
install.packages('xlsx')
install.packages('writexl')

# empty old data (if applicable)
ls()
rm(raw)

# import data
library(readxl)
raw_trr <- read_excel("Raw/Copy of Chicago UoF 2020-2024.xlsx", sheet = "TRR DATA")
raw_officers <- read_excel("Raw/Copy of Chicago UoF 2020-2024.xlsx", sheet = "TRR INVOLVED OFFICERS")

# limit to cases flagged as mental illness related
mental <- raw_trr[grep("MENTAL ILL./EMOTIONAL DISORDER", raw_trr$SUBJECT_CONDITION_NEW_TRR), ]

# analytics
myfun_cat <- function(x) {
  nmiss <-sum(is.na(x))
  n <- table(x)
  p <- prop.table(n)
  OUT <- cbind(n, p)
  nmiss <-c(nmiss, rep(NA, nrow(OUT)-1))
  OUT <-cbind(OUT, nmiss)
  return(OUT)
}

myfun_cat(mental$SUBJECT_CONDITION_NEW_TRR)
myfun_cat(mental$`Subject Actions`)

############
working_data <-subset(mental, select = c(`REPORT NO`, INCIDENTDATETIME, `STREET NO`, DIR, `STREET NAME`, CITY, STATE, `ZIP CODE`, `LOCATION CODE`, BEAT, WARD, COMMUNITY, EVENT_NO, RD_NO, MEM_WAS_ALONE_PARTNER, PATROL_TYPE, INVOLVED_PURSUIT, `TITLE AT INCIDENT`, `MEMBER LAST NAME`, `MEMBER FIRST NAME`, MI, `UNIT AT INCIDENT`, `CURRENT UNIT`, MEMBER_WATCH, MEMBERSEX, MEMBERRACE, MEMBER_BIRTH_YEAR, APPOINTED_DATE, MEMBER_ON_DUTY, MEMBER_IN_UNIFORM, MEMBER_INJURED, MEMBER_INJURY_NEW_TRR, SUBJSEX, SUB_RACE, SUB_BIRTHYEAR, SUB_ZIPCODE, SUBJECT_CONDITION_NEW_TRR, SUBJECT_INJURED, SUBJECT_ALLEGED_INJURY, `Subject Med Treatment New TRR`, `Subject Actions`, SUBJECT_HOSPITALIZED, SUBJECT_ARMED, SUBJECTARMEDWITH, WEAPON_PERCEIVED_AS, SUBJECT_WEAPON_USE, `Subject Weapon`, SUBDRUGRELATED, `Type Activity New TRR`, `ReasonForResponse New TRR`, `ForceMitigationEfforts New TRR`, `ControlTactics New TRR`, `ResponseWithoutWeapons New TRR`, `ResponseWithWeapon New TRR`, `ForceWhileHandcuffed New TRR`, `WEAPON TYPE`, OBJSTRCK_DISCH_MEMWEAP_NEW_TRR, FADISCHRG_FIRST_SHOT_CD, FADISCHRG_MEM_SHOT_FIRED_CNT, FADISCHRG_RELOADED_I, FADISCHRG_FIRED_AT_VEH_I, FADISCHRG_MAKE_CD, FIREARM_MAKE, FADISCHRG_MODEL_CD, FIREARM_MODEL, `FORCE LEVEL`))

subject_demographics <-subset(working_data, select = c(`REPORT NO`, INCIDENTDATETIME, `STREET NO`, DIR, `STREET NAME`, CITY, STATE, `ZIP CODE`, `LOCATION CODE`, BEAT, WARD, COMMUNITY, EVENT_NO,SUBJSEX, SUB_RACE, SUB_BIRTHYEAR, SUB_ZIPCODE, SUBJECT_CONDITION_NEW_TRR, SUBJECT_INJURED, SUBJECT_ALLEGED_INJURY, `Subject Med Treatment New TRR`, `Subject Actions`, SUBJECT_HOSPITALIZED, SUBJECT_ARMED, SUBJECTARMEDWITH, WEAPON_PERCEIVED_AS, SUBJECT_WEAPON_USE, `Subject Weapon`, SUBDRUGRELATED, `Type Activity New TRR`, `ReasonForResponse New TRR`, `ForceMitigationEfforts New TRR`, `ControlTactics New TRR`))

force_level <-subset(working_data, select = c(`REPORT NO`, INCIDENTDATETIME, `STREET NO`, DIR, `STREET NAME`, CITY, STATE, `ZIP CODE`, `LOCATION CODE`, BEAT, WARD, COMMUNITY, EVENT_NO,SUBJSEX, SUB_RACE, SUB_BIRTHYEAR, SUB_ZIPCODE, SUBJECT_CONDITION_NEW_TRR, SUBJECT_INJURED, SUBJECT_ALLEGED_INJURY, `Subject Med Treatment New TRR`, `Subject Actions`, SUBJECT_HOSPITALIZED, SUBJECT_ARMED, SUBJECTARMEDWITH, WEAPON_PERCEIVED_AS, SUBJECT_WEAPON_USE, `Subject Weapon`, SUBDRUGRELATED, `Type Activity New TRR`, `ReasonForResponse New TRR`, `ForceMitigationEfforts New TRR`, `ControlTactics New TRR`, `FORCE LEVEL`))

#export data
writexl::write_xlsx(subject_demographics, 'Int/Subject Demographics_Mental Illness Flag_TRRs.xlsx')
writexl::write_xlsx(force_level, 'Int/Force Level_Mental Illness Flag_TRRs.xlsx')


# merge
#total <- merge(vendors,ids,by="Vendor")

# filter
# library(tidyverse)
# data_filtered <- total %>% filter(Duration > 4)

# reshape wide
#data_wide <- reshape2::dcast(total, Year ~ Vendor, value.var="Duration")
#data_wide <- reshape2::dcast(data_filtered, Year ~ Vendor, value.var="Duration")

# years wide:
# data_wide <- reshape2::dcast(data_filtered, Vendor ~ Year, value.var="Duration")

#save new data
#write.csv(data_wide, 'Vendors by Year.csv')
