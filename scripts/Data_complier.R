library(tidyverse)
library(haven)
library(dplyr)
library(stringr)
library(purrr)
library(openxlsx)

Demo = "Data/DemographicData"
Lab = "Data/LaboratoryData"
Diet = "Data/DietaryInterview"


# Creating Master Demographic List
# read all of the files in Demo dir
Demo_files = list.files(Demo, full.names = TRUE) 

# concatenate all files together
Demo_data = bind_rows(lapply(Demo_files, read_xpt))


# Creating Master Lab List
# read all subdirs/files in Lab dir
POP_subdirs = list.dirs(Lab, full.names = TRUE)

#removes parent directory
POP_subdirs = POP_subdirs[-1]

matching_file = list()

# goes into subdirs to find potential files
for (subdir in POP_subdirs){
  file_list = list.files(subdir, full.names = TRUE, pattern = "\\.xpt$")
  matching_file[[subdir]] = file_list
}

# combine data files of similarly named file from matching_files 
Lab_data = lapply(names(matching_file), function(key){
  lab = bind_rows(lapply(matching_file[[key]], read_xpt))
  lab %>% mutate(key = basename(key))
})

# tibbles in data are now renamed into correct POP names
names(Lab_data) <- sub("^Data/LaboratoryData/", "", names(matching_file))

print(Lab_data)

# DI_data1 = read_xpt("Data/DietaryInterview/2017-2018/DR1IFF_Jdietary-interview-1-17-18.xpt")
# demoData = read_xpt("Data/DemographicData/DEMO_E.xpt")
# 
# view(demoData)
# 
# write.xlsx(DI_data1, "data.xlsx")
# 
# partIDs = demoData$SEQN %>% unique()
# 
# 
# print(partIDs)
# 
# POP_files = "Data/LaboratoryData"
# 
# POP_subdir = list.dirs(POP_files, full.names = TRUE)
# 
# POP_subdir = POP_subdir[-1] #removes parent directory
# 
# matching_file = list()
# 
# # Goes into subdirs to find files with specific years 
# for (subdir in POP_subdir){
#   file_list = list.files(subdir, full.names = TRUE, pattern = "\\.xpt$")
#   year_files = file_list[str_detect(file_list, "2018")] # year can change, could become generalized code for future years.
#   if (length(year_files) > 0){
#     matching_file[[subdir]] = year_files
#   }
# }
# 
# matching_file = unlist(matching_file, use.names = FALSE)
# 
# data = map(matching_file, read_xpt)
# names(data) = basename(matching_file)
# 
# #Finds unique SEQNs
# new_seqn_data = data %>%
#   map(~ pull(.x, SEQN)) %>%
#   unlist() %>%
#   unique()
# 
# #filter to work with just participants that have POP data
# filtered_demoData = demoData %>% filter(SEQN %in% new_seqn_data)
#   
# #TODO run filtered data on the diet data to get what we are working with
# final_demoData = filtered_demoData %>% filter(SEQN %in% DI_data1$SEQN)
# 
# #write.xlsx(final_demoData, "test final data.xlsx")
# 
