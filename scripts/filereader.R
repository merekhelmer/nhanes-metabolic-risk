library(tidyverse)
library(haven)
library(dplyr)
library(stringr)
library(purrr)

DI_data1 = read_xpt("Data/DietaryInterview/2007-2008/DR1IFF_Edietary-interview-1-07-08.xpt")
demoData = read_xpt("Data/DemographicData/DEMO_E.xpt")
#View(demoData)
partIDs = DI_data1$SEQN %>% unique()

#print(partIDs)

POP_files = "Data/LaboratoryData"

POP_subdir = list.dirs(POP_files, full.names = TRUE)

POP_subdir = POP_subdir[-1]

#print(POP_subdir)

matching_file = list()

for (subdir in POP_subdir){
  file_list = list.files(subdir, full.names = TRUE, pattern = "\\.xpt$")
  year_files = file_list[str_detect(file_list, "2007")]
  
  if (length(year_files) > 0){
    matching_file[[subdir]] = year_files
  }
}
matching_file = unlist(matching_file, use.names = FALSE)


data = map(matching_file, read_xpt)
names(data) = basename(matching_file)

new_seqn_data = data %>%
  map(~ pull(.x, SEQN)) %>%
  unlist() %>%
  unique()

filtered_demoData = demoData %>% filter(SEQN %in% new_seqn_data)

View(filtered_demoData)

