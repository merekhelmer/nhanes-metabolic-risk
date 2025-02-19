``` yaml
---
title: "NHANES Data Exploration"
output: html_document
---
```

```{r setup, include=FALSE}
# Setup chunk: recommended to keep your environment clean
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
```

```{r load-and-prepare-data}
# Load libraries
library(tidyverse)
library(haven)
library(stringr)
library(purrr)
library(DT)

# Read in the data
DI_data1 <- read_xpt("Data/DietaryInterview/2007-2008/DR1IFF_Edietary-interview-1-07-08.xpt")
demoData <- read_xpt("Data/DemographicData/DEMO_E.xpt")

partIDs <- DI_data1$SEQN %>% unique()

# Directory with laboratory data files
POP_files <- "Data/LaboratoryData"
POP_subdir <- list.dirs(POP_files, full.names = TRUE)
# Remove the top-level directory
POP_subdir <- POP_subdir[-1]

matching_file <- list()

# Look for XPT files containing "2007" in the path
for (subdir in POP_subdir) {
  file_list <- list.files(subdir, full.names = TRUE, pattern = "\\.xpt$")
  year_files <- file_list[str_detect(file_list, "2007")]
  
  if (length(year_files) > 0){
    matching_file[[subdir]] <- year_files
  }
}

# Flatten list of files into a character vector
matching_file <- unlist(matching_file, use.names = FALSE)

# Read each file into a list
data <- map(matching_file, read_xpt)
names(data) <- basename(matching_file)

# Gather unique SEQNs from all files
new_seqn_data <- data %>%
  map(~ pull(.x, SEQN)) %>%
  unlist() %>%
  unique()

# Filter demoData to only those with POP data
filtered_demoData <- demoData %>% filter(SEQN %in% new_seqn_data)

# Further filter only to participants that appear in DI_data1
final_demoData <- filtered_demoData %>% filter(SEQN %in% DI_data1$SEQN)

# Preview the final data in the console
head(final_demoData)
```

```{r interactive-table, echo=FALSE}
# Create an interactive data table in the rendered document
datatable(
  final_demoData,
  options = list(pageLength = 10)
)
```
