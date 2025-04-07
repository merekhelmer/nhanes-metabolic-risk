import pandas as pd
import os
from scipy.stats import chi2_contingency

thyroid_df_list = []
data_path = "Data/Questionnaire/ThyroidQuestionaire"
for filename in os.listdir(data_path):
    file_path = os.path.join(data_path, filename)

    data = pd.read_sas(file_path)
    df_subset = data[['SEQN', 'MCQ160M']]

    thyroid_df_list.append(df_subset)

thyroid_df = pd.concat(thyroid_df_list, ignore_index=True)

thyroid_df = thyroid_df.dropna()

thyroid_df = thyroid_df.astype(int)

thyroid_df = thyroid_df[thyroid_df['MCQ160M'].isin([1, 2])]


significance_table = []
data_path  = "Data/Clustered_Datasets"
for filename in os.listdir(data_path):
    file_path = os.path.join(data_path, filename)

    data = pd.read_excel(file_path, engine='openpyxl')

    joined_table = pd.merge(thyroid_df, data, on='SEQN', how='inner')
    cluster0_yes = 0
    cluster1_yes = 0
    cluster2_yes = 0
    cluster3_yes = 0
    cluster0_no = 0
    cluster1_no = 0
    cluster2_no = 0
    cluster3_no = 0
    for index, row in joined_table.iterrows():
        if row['MCQ160M'] == 1 and row[0] == 0:
            cluster0_yes += 1
        elif row['MCQ160M'] == 2 and row[0] == 0:
            cluster0_no += 1
        elif row['MCQ160M'] == 1 and row[0] == 1:
            cluster1_yes += 1
        elif row['MCQ160M'] == 2 and row[0] == 1:
            cluster1_no += 1
        elif row['MCQ160M'] == 1 and row[0] == 2:
            cluster2_yes += 1
        elif row['MCQ160M'] == 2 and row[0] == 2:
            cluster2_no += 1
        elif row['MCQ160M'] == 1 and row[0] == 3:
            cluster3_yes += 1
        elif row['MCQ160M'] == 2 and row[0] == 3:
            cluster3_no += 1
    observed = [[cluster0_yes, cluster1_yes, cluster2_yes, cluster3_yes],[cluster0_no, cluster1_no, cluster2_no, cluster3_no]]
    chi2_statistic, p_value, degrees_of_freedom, expected_values = chi2_contingency(observed)
    table_row = [filename, chi2_statistic, p_value]
    significance_table.append(table_row)
significance_table = pd.DataFrame(significance_table)
significance_table.to_excel('Significance.xlsx', index=False)
print('finished! yay!')
