library(tidyverse)
library(haven)
library(dplyr)
library(stringr)
library(purrr)

DI_data1 = read_xpt("Data/DietaryInterview/2017-2018/DR1IFF_Jdietary-interview-1-17-18.xpt")
demoData = read_xpt("Data/DemographicData/DEMO_J.xpt")

#TODO Code that takes every demographic data file and puts them all together
demographicFiles = "Data/DemographicData"

View(demographicFiles)

partIDs = DI_data1$SEQN %>% unique()

POP_files = "Data/LaboratoryData"

POP_subdir = list.dirs(POP_files, full.names = TRUE)

POP_subdir = POP_subdir[-1] #removes parent directory

matching_file = list()

# Goes into subdirs to find files with specific years 
for (subdir in POP_subdir){
  file_list = list.files(subdir, full.names = TRUE, pattern = "\\.xpt$")
  year_files = file_list[str_detect(file_list, "2018")] # year can change, could become generalized code for future years.
  if (length(year_files) > 0){
    matching_file[[subdir]] = year_files
  }
}

matching_file = unlist(matching_file, use.names = FALSE)

data = map(matching_file, read_xpt)
names(data) = basename(matching_file)

#Finds unique SEQNs
new_seqn_data = data %>%
  map(~ pull(.x, SEQN)) %>%
  unlist() %>%
  unique()

#filter to work with just participants that have POP data
filtered_demoData = demoData %>% filter(SEQN %in% new_seqn_data)

#Filter out children
adultData = filtered_demoData %>% filter(RIDAGEYR >= 18)
childData = filtered_demoData %>% filter(RIDAGEYR < 18)

#demo data with everyone
final_demoData = filtered_demoData %>% filter(SEQN %in% DI_data1$SEQN)

#final_demoData filtered into adults and children
finalAdultData = adultData %>% filter(SEQN %in% DI_data1$SEQN)
finalChildData = childData %>% filter(SEQN %in% DI_data1$SEQN)

View(final_demoData)
View(DI_data1)
View(finalChildData)
View(finalAdultData)

