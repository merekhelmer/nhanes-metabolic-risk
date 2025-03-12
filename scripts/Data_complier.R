library(tidyverse)
library(haven)
library(dplyr)
library(stringr)
library(purrr)
library(openxlsx)

total_lead = function(lab) {
  keeps_liters = c("LBXBCD","LBXTHG","LBXBSE","LBXBMN")
  keeps_dliters = c("LBXBPB")
  lab = mutate(lab, Total_Cadmium_Lead_and_Manganese = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps_liters) {
      lab = mutate(lab, Total_Cadmium_Lead_and_Manganese = Total_Cadmium_Lead_and_Manganese + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
    else {
      if (col %in% keeps_dliters) {
        lab = mutate(lab, Total_Cadmium_Lead_and_Manganese = Total_Cadmium_Lead_and_Manganese + (ifelse(is.na(lab[[col]]), 0, lab[[col]]))/10)
      }
    }
  }
  return(lab[, c("SEQN", "Total_Cadmium_Lead_and_Manganese")])
}

total_phenols = function(lab) {
  keeps = c("URX4TO","URXPB3","URXBPH","URXTRS","URXBUP","URXEPB","URXMPB","URXPPB","URXTRS")
  lab = mutate(lab, Total_environmental_phenols = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_environmental_phenols = Total_environmental_phenols + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_environmental_phenols")])
}

total_flamer = function(lab) {
  keeps = c("SSDPHP","SSBDCPP","SSBCPP","SSSBCED","SSDPCP","SSDOCP","SSDBUP","SSDBZP","SSTBB","URXBCPP","URXPCEP","URXBDCP","URXDBUP","URXDPHP","URXTBBA","SSDCP","SSTBBA","SSIPPP","SSBPPP")
  lab = mutate(lab, Total_flame_retardants = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_flame_retardants = Total_flame_retardants + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_flame_retardants")])
}

total_metals = function(lab) {
  keeps = c("URXUBA","URXUBE","URXUCD","URXUCO","URXUCS","URXUMO","URXUPB","URXUPT","URXUSB","URXUTL","URXUTU","URXUUR","URXUMN","URXUSN","URXUSR")
  lab = mutate(lab, Total_metals = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_metals = Total_metals + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_metals")])
}

total_insecticides = function(lab) {
  keeps = c("URXOP1","URXOP2","URXOP3","URXOP4","URXOP5","URXOP6")
  lab = mutate(lab, Total_insecticides = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_insecticides = Total_insecticides + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_insecticides")])
}

total_pesticides = function(lab) {  
  keeps = c("URXAPE","URXETU","URXMMI","URXMTO","URXOMO","URXPTU","URXBSM","URXCHS","URXEMM","URXFRM","URXHLS","URXMSM","URXMTM","URXNOS","URXOXS","URXPIM","URXPRO","URXRIM","URXSMM","URXSSF","URXTHF","URXTRA","URXTRN","URXOPP","URS14D","URXDCB","URX1TB","URX3TB")
  lab = mutate(lab, Total_pesticides = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_pesticides = Total_pesticides + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_pesticides")])
}

total_polychems = function(lab) {
  keeps = c("LBXPFDE","LBXPFHS","LBXMPAH","LBXPFBS","LBXPFHP","LBXPFNA","LBXPFUA","LBXPFDO","LBXEPAH","LBXPFDE","LBXPFOA","LBXPFOS","LBXPFSA","LBXPFHS")
  lab = mutate(lab, Total_polychems = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_polychems = Total_polychems + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_polychems")])
}

total_herbicides = function(lab) {
  keeps = c("URX24D","URX25T","URX4FP","URXCB3","URXCPM","URXMAL","URXOPM","URXOXY","URXPAR","URXTCC")
  lab = mutate(lab, Total_herbicides = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_herbicides = Total_herbicides + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_herbicides")])
}

total_biochem = function(lab) {
  keeps = c("URX24D","URX25T","URX4FP","URXCB3","URXCPM","URXMAL","URXOPM","URXOXY","URXPAR","URXTCC")
  lab = mutate(lab, Total_biochem = 0)
  for (col in colnames(lab)) {
    if (col %in% keeps) {
      lab = mutate(lab, Total_biochem = Total_biochem + ifelse(is.na(lab[[col]]), 0, lab[[col]]))
    }
  }
  return(lab[,c("SEQN", "Total_biochem")])
}

find_totals = function(lab, key) {
  lab = switch(key,
               "Data/LaboratoryData/Cadmium-Lead-and-Manganese" = total_lead(lab),
               "Data/LaboratoryData/environmental-phenols" = total_phenols(lab),
               "Data/LaboratoryData/flame-retardants" = total_flamer(lab),
               "Data/LaboratoryData/metals" = total_metals(lab),
               "Data/LaboratoryData/organophosphate-insecticides" = total_insecticides(lab),
               "Data/LaboratoryData/parathyroid-hormone" = lab,
               "Data/LaboratoryData/pesticides" = total_pesticides(lab),
               "Data/LaboratoryData/polychlorinated-biphenyls" = lab,
               "Data/LaboratoryData/polyfluoroalkyl-chemicals" = total_polychems(lab),
               "Data/LaboratoryData/pyrethroids-herbicides-and-OP-metabolites" = total_herbicides(lab),
               "Data/LaboratoryData/standard-biochemistry-profile" = lab,
               "Data/LaboratoryData/thyroid-profile" = lab)
  return (lab)
}

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

Lab_data = lapply(names(matching_file), function(key){
  lab = bind_rows(lapply(matching_file[[key]], read_xpt))
  lab = find_totals(lab,key)
  lab %>% mutate(key = basename(key))
})

# tibbles in data are now renamed into correct POP names
names(Lab_data) <- sub("^Data/LaboratoryData/", "", names(matching_file))

# combine all data together
Demo_Diet_data = Demo_data %>%
  left_join(Diet_data, by = "SEQN")

for (i in seq_along(Lab_data)){
  POP_tib = Lab_data[[i]]
  POP_name = names(Lab_data)[i]
  
  Demo_Diet_POP_data = left_join(Demo_Diet_data, POP_tib, by="SEQN")
  output_file_name = paste0("Demo_Diet_", POP_name, ".xlsx")
  write.xlsx(Demo_Diet_POP_data, output_file_name)
  
}


