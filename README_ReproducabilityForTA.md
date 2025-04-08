# Dietary Patterns, POP Blood Levels, and Metabolic Health

## Overview
This project aims to:
- **Identify dietary patterns** associated with elevated blood levels of persistent organic pollutants (POPs) in adults (aged ≥18 years) and children.
- **Assess the association** between diet-POP patterns and metabolic health indicators.

## Workflow

#### 1. Open RStudio and clone Github Repository
- Copy repository web url from main repository page
-Ensure your own computer has github properly set up
-Open R Studios
-Select File->New Project->Version Control->Git
-Past web URL in space provided under "Repository URL"
-Click "Create Project"
#### 2. Generate Figure 1A (Population Table)
- Open `Figure1A.Rmd` in RStudio.
- Click the "Knit" button to generate a PDF/HTML document, or run the code cells sequentially to view the output.
#### 3. Generate Figure 1B (POP Distributions)
- Open `Figure1B.Rmd` and run in the same manner as above.
- If you run into environment issues, you can select the "sessions" tab (top of page), "Restart R Session", and try again.
#### 4. Generate Figure 2 (Dietary Analysis Stacked Bar Chart)
- Open and run `Figure2.Rmd`.
#### 5. Compile Data
- Execute `Data_compiler.R` to consolidate and preprocess the dietary/POP data.
#### 6. Generate Figure 3A (Dietary Clusters)
- Open and run `Figure3A.Rmd` to create dietary clusters.
#### 7. Create Dataset with POP Clusters
- Run the script `Create_Dataset_POP_Clusters.R`.
#### 8. Generate Figure 3B (POP Clusters)
- Execute `Figure3B.py` to produce the POP clusters visualization.
- To run a Python script in RStudio, select "Source Script" next to "Run"
#### 9. Conduct Chi-Square Cluster Analysis
- Run `Figure3C.py` to perform the chi-square analysis on the clusters.
