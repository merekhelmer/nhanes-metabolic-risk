library(haven)
library(dplyr)
library(tidyr)

pcbFile <- "Data/2003-2004Data/L28NPB_C_PCBs2003-2004.xpt"
dietFile <- "Data/2003-2004Data/DR1IFF_CDiet2003-2004.xpt"
demoFile <- "Data/2003-2004Data/DEMO_C2003-2004.xpt"
dietData <- read_xpt(dietFile)
pcbData <- read_xpt(pcbFile)
demoData <- read_xpt(demoFile)

pcbNeededCols <- c("SEQN", "LBX044", "LBX044LA", "LBX049", "LBX049LA", "LBX052", "LBX052LA", 
           "LBX087", "LBX087LA", "LBX099", "LBX099LA", "LBX101", "LBX101LA", "LBX110", 
           "LBX110LA", "LBX128", "LBX128LA", "LBX138", "LBX138LA", "LBX146", "LBX146LA", 
           "LBX149", "LBX149LA", "LBX151", "LBX151LA", "LBX153", "LBX153LA", "LBX170", 
           "LBX170LA", "LBX172", "LBX172LA", "LBX177", "LBX177LA", "LBX178", "LBX178LA", 
           "LBX180", "LBX180LA", "LBX183", "LBX183LA", "LBX187", "LBX187LA", "LBX194", 
           "LBX194LA", "LBX195", "LBX195LA", "LBX196", "LBX196LA", "LBX206", "LBX206LA", 
           "LBX209", "LBX209LA")

filtered_PCB_data <- pcbData[, pcbNeededCols]
filtered_PCB_data <- filtered_PCB_data[rowSums(is.na(filtered_PCB_data[, -1])) < ncol(filtered_PCB_data[, -1]), ] #Get rid of rows of all NA
filtered_PCB_data <- filtered_PCB_data %>%
  filter(SEQN %in% demoData$SEQN)

View(filtered_PCB_data)


#Filter Diet Data


dietData <- dietData %>%
  filter(SEQN %in% demoData$SEQN)
# Keep only records with DR1DRSTZ equal to 1 or 4
data_filtered <- dietData %>%
  filter(DR1DRSTZ %in% c(1, 4))

# Create food groups based on first digit of USDA food code
data_filtered <- data_filtered %>%
  mutate(FoodGroup = substr(as.character(DR1IFDCD), 1, 1))

# Sum grams consumed (DR1IGRMS) for each individual (SEQN) by food group
aggregated_data <- data_filtered %>%
  group_by(SEQN, FoodGroup) %>%
  summarise(total_grams = sum(DR1IGRMS, na.rm = TRUE)) %>%
  ungroup()

# Ensure every individual has an entry for all 9 food groups
unique_SEQNs <- unique(aggregated_data$SEQN)
all_food_groups <- as.character(1:9)
complete_data <- expand.grid(SEQN = unique_SEQNs, FoodGroup = all_food_groups, stringsAsFactors = FALSE) %>%
  left_join(aggregated_data, by = c("SEQN", "FoodGroup"))

complete_data <- complete_data %>%
  mutate(zero_flag = (total_grams == 0 | is.na(total_grams)))

# Filter out zero-gram records for quantile calculation
non_zero <- complete_data %>%
  filter(!zero_flag)

non_zero <- non_zero %>%
  group_by(FoodGroup) %>%
  mutate(
    low_cutoff  = quantile(total_grams, probs = 1/3, na.rm = TRUE),
    high_cutoff = quantile(total_grams, probs = 2/3, na.rm = TRUE),
    intake_level = case_when(
      total_grams <= low_cutoff       ~ "Low",
      total_grams <= high_cutoff      ~ "Medium",
      TRUE                            ~ "High"
    )
  ) %>%
  ungroup()

# Add back zero gram entries with "None" intake level
complete_data <- bind_rows(
  non_zero,
  complete_data %>%
    filter(zero_flag) %>%
    mutate(intake_level = "None")
)

# Pivot data for one row per individual
final_table <- complete_data %>%
  select(SEQN, FoodGroup, intake_level) %>%
  pivot_wider(names_from = FoodGroup, values_from = intake_level, names_prefix = "FoodGroup_")

# Rename columns for clarity
highLowDietTable <- final_table %>%
  rename(`Milk and milk products` = FoodGroup_1,
         `Meat, poultry, fish, and mixtures` = FoodGroup_2,
         `Eggs` = FoodGroup_3,
         `Legumes, nuts, and seeds` = FoodGroup_4,
         `Grain products` = FoodGroup_5,
         `Fruits` = FoodGroup_6,
         `Vegetables` = FoodGroup_7,
         `Fats, oils, and salad dressings` = FoodGroup_8,
         `Sugars, sweets, and beverages` = FoodGroup_9)

View(highLowDietTable)

#Joined pcb and diet tables
pcbDietTable <- inner_join(highLowDietTable, filtered_PCB_data, by = "SEQN")
View(pcbDietTable)

wanted_cols <- c("SEQN", "RIAGENDR", "RIDAGEYR", "RIDAGEMN")

demoData <- demoData %>%
  select(any_of(wanted_cols)) %>%
  rename(
    Gender = RIAGENDR,
    Age_Years = RIDAGEYR,
    Age_Months = RIDAGEMN
  )

# Add Age_Years and Age_Group to pcbDietTable
pcbDietTable <- pcbDietTable %>%
  left_join(demoData %>% select(SEQN, Age_Years), by = "SEQN") %>%
  mutate(Age_Group = if_else(Age_Years < 18, "Child", "Adult")) %>%
  select(SEQN, Age_Years, Age_Group, everything())


#View(pcbDietTable)

file_path <- "Data/Processed_Datasets/pcbDietTable.xlsx"

#write_xlsx(pcbDietTable, path = file_path)


