library(tidyverse)
library(haven)
library(dplyr)
library(stringr)
library(purrr)
library(openxlsx)

Demo = "Data/DemographicData"
Lab = "Data/LaboratoryData"
Diet_data = read.xlsx("scripts/DIdata.xlsx")


# Creating Master Demographic List
# read all of the files in Demo dir
Demo_files = list.files(Demo, full.names = TRUE) 

# concatenate all files together
wanted_cols = c("SEQN", "RIAGENDR", "RIDAGEYR", "RIDAGEMN",
                "RIDRETH1","RIDRETH3", "INDFMIN2","INDFMPIR")

rename_map <- c(
  "Gender" = "RIAGENDR",
  "Age_Years" = "RIDAGEYR",
  "Age_Months" = "RIDAGEMN",
  "Ethnicity" = "RIDRETH1",
  "Ethnicity_Non_Asian" = "RIDRETH3",
  "Family_Income" = "INDFMIN2",
  "Poverty_Ratio" = "INDFMPIR"
)

Demo_data = bind_rows(lapply(Demo_files, read_xpt)) %>%
  select(any_of(wanted_cols)) %>%
  rename(any_of(rename_map))


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
  new_key = sub("^Data/LaboratoryData/", "", key)
  lab %>% 
    mutate(key = new_key) %>%
    select(where(function(col) !all(is.na(col))))
})

# tibbles in data are now renamed into correct POP names
names(Lab_data) <- sub("^Data/LaboratoryData/", "", names(matching_file))

# combine all data together
master_lab_data <- bind_rows(Lab_data)

Demo_Lab_data <- Demo_data %>%
  left_join(master_lab_data, by = "SEQN")

Master_data <- Demo_Lab_data %>%
  left_join(Diet_data, by = "SEQN") %>%
  filter(!is.na(key) & key != "")

write.xlsx(Master_data, "Master_dataset.xlsx")

