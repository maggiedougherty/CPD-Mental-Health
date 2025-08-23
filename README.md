# CPD-Mental-Health
PURPOSE: For Medill Investigative Lab - Mindsite News Analyses
BY: Maggie Dougherty

CODE: The programs used to process data are stored in the "CPD-Mental-Health/Code". 

RAW DATA: The programs import data from the "CPD-Mental-Health/Raw Data" folder.

PROCESSED DATA: The programs export data to the "CPD-Mental-Health/Processed Data" folder.

USAGE NOTES: 
Data is primarily used for creation of this map: https://public.flourish.studio/visualisation/24717626/.

Both code files are limited to Mental Health incidents. 

----
The data processed by the file "MH race by TRR_2020-2024" is a count of MH TRRs by Ward and Subject Race. This represents each report filed by an officer. 

Note that multiple officers often fill out a TRR for the same subject. This should NOT be used as a count of UNIQUE incidents, but rather a count of officers who used force on a given subject.

----
The data processed by the file "MH race by event_2020-2024" includes counts of each subject race associated with a single event number, as well as a total unique count of event numbers. This gives the total unique events in which CPD used force during a MH incident. It also provides a breakdown by race. 

Note that the sum of counts by race is more than the count of total events, because there could be multiple subjects with different races -- or a single subject for whom officers reported different races -- associated with a single event number.
