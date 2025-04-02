library(tidyverse)
library(haven)
library(openxlsx)

cad = read.xlsx("Data/Processed_Datasets/Demo_Diet_Cadmium-Lead-and-Manganese.xlsx")
pho = read.xlsx("Data/Processed_Datasets/Demo_Diet_environmental-phenols.xlsx")
fla = read.xlsx("Data/Processed_Datasets/Demo_Diet_flame-retardants.xlsx")
met = read.xlsx("Data/Processed_Datasets/Demo_Diet_metals.xlsx")
org = read.xlsx("Data/Processed_Datasets/Demo_Diet_organophosphate-insecticides.xlsx")
pes = read.xlsx("Data/Processed_Datasets/Demo_Diet_pesticides.xlsx")
pol = read.xlsx("Data/Processed_Datasets/Demo_Diet_polyfluoroalkyl-chemicals.xlsx")
pyr = read.xlsx("Data/Processed_Datasets/Demo_Diet_pyrethroids-herbicides-and-OP-metabolites.xlsx")

cad_last_col <- tail(names(cad), 1)
cad <- cad %>% 
  mutate(across(all_of(cad_last_col), ~ ntile(., 4)))


dataset_list <- list(pho, fla, met, org, pes, pol, pyr)

# For each dataframe, keep only the SEQN column and its last column (with its original name)
dataset_list <- lapply(dataset_list, function(df) {
  last_col_name <- tail(names(df), 1)
  df %>% 
    select(SEQN, all_of(last_col_name)) %>%
    mutate(across(all_of(last_col_name), ~ ntile(., 5)))
})

# Merge using full_join to preserve all SEQN values and silence many-to-many warnings.
final_result <- reduce(dataset_list, full_join, .init = cad, by = "SEQN", relationship = "many-to-many")

cols_to_check <- c("Total_Cadmium_Lead_and_Manganese", "Total_environmental_phenols", "Total_flame_retardants", "Total_metals", "Total_insecticides", "Total_pesticides", "Total_polychems", "Total_herbicides")

# Keep participants that have equal to or less than 3 NAs POPs
final_result <- final_result %>%
  filter(rowSums(across(all_of(cols_to_check), ~ is.na(.) | . == 0)) < 4)

write.xlsx(final_result, "Data/Processed_Datasets/NAs_<=3_MasterSheet.xlsx")