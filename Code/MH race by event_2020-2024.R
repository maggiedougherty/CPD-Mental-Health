# MEDILL INVESTIGATIVE LAB
# Author: Maggie Dougherty
# Date: August 23, 2025
# Topic: Get unique count of event numbers and event numbers by race for Flourish subhead.

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
library(writexl)
library(dplyr)
library(tidyr)
library(stringr)

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
working_data <-subset(mh, select = c(EVENT_NO, SUB_RACE))

# create subject id for reshape
working_data <- working_data %>%
  filter(!is.na(EVENT_NO)) %>%
  group_by(EVENT_NO) %>%
  mutate(SUBJECT_ID = row_number()) %>%
  ungroup()

# reshape subj info wide
wide_data <- working_data %>%
  pivot_wider(
    id_cols = EVENT_NO,
    names_from = SUBJECT_ID,
    values_from = c(SUB_RACE),
    names_sep = "_"
  )

# add subject race back to column names
names(wide_data)[names(wide_data) != "EVENT_NO"] <- paste0("SUB_RACE_", names(wide_data)[names(wide_data) != "EVENT_NO"])

# reshape back to long for unique event number & race combinations
long_data <- wide_data %>%
  pivot_longer(
    cols = -EVENT_NO,  # all columns except EVENT_NO
    names_to = c(".value", "SUBJECT_ID"),
    names_sep = "_"
  )

# drop where race is missing
long_data_clean <- long_data %>%
  filter(!is.na(SUB))

long_data_clean <- long_data_clean %>%
  select(-SUBJECT_ID)

long_data_clean <- long_data_clean %>%
  mutate(across(where(is.character), str_trim))

# remove duplicates based on event number and subject race
dedup <- long_data_clean[!duplicated(long_data_clean[, c("EVENT_NO", "SUB")]), ] # 1585 obs

# group count by race
summary_race <- dedup %>%
  group_by(SUB) %>%
  summarise(Count = n()) %>%
  arrange(SUB)

# get unique event count
unique_event_count <- length(unique(long_data_clean$EVENT_NO)) 
# 1548 unique observations, meaning there are at least 37 with multiple different races listed
count_df <- data.frame(`Unique Events` = unique_event_count) # make df for export

# export data to file
write_xlsx(
  list(
    `Events by Race` = summary_race,
    `Unique Events` = count_df
  ),
  path = "Processed Data/MH Events Dedup.xlsx"
)

# end of file