import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import os
from sklearn.metrics import silhouette_score, silhouette_samples
from scipy.stats import f_oneway #import ANOVA

def filename_to_title(filename):
    fname = filename[10:-5]
    fname = no_dashes = fname.replace('-', ' ')
    fname = no_dashes[0].upper() + no_dashes[1:]
    return fname
  
anova_results = []

# read data in 
data_path  = "../Data/Processed_Datasets"
for filename in os.listdir(data_path):
    print(f"stating with {filename}")
    
    if filename == "Demo_Diet_thyroid-profile.xlsx":
        print(f"skipping {filename}")
        continue
    if filename == "Demo_Diet_standard-biochemistry-profile.xlsx":
        print(f"skipping {filename}")
        continue
    
    fname = filename_to_title(filename)
    
    file_path = os.path.join(data_path,filename)
    
    data = pd.read_excel(file_path, engine='openpyxl')

    # features are the varible names in the columns of the data set
    features = list(data.columns[10:-1])
    
    # transformed features added to encoded data
    X = data[features]
    
    # standardize features
    scaler = StandardScaler()
    X.iloc[:,-1] = scaler.fit_transform(X.iloc[:,[-1]])

    # find optimal of amount clusters
    inertia = []
    silhouette_scores = []
    k = 4
    kmeans = KMeans(n_clusters=k, random_state=42)
    y_means = kmeans.fit_predict(X)
    inertia.append(kmeans.inertia_)

    cluster_labels = pd.DataFrame(kmeans.labels_)
    output_table = pd.concat([data.iloc[:,0], cluster_labels], axis = 1)
    output_table.to_excel(rf"../Data/Clustered_Datasets/clustered_{filename}", index = False)
    print(output_table)


    score = silhouette_score(X, kmeans.labels_)
    silhouette_scores.append(score)

    data["cluster"] = y_means

    pca = PCA(n_components=2)
    X_pca = pca.fit_transform(X)

    """
    # Scatter plot of the clusters
    plt.figure(figsize=(8, 5))
    plt.scatter(X_pca[:, 0], X_pca[:, 1], c=data['cluster'], cmap='viridis', alpha=0.6)
    plt.xlabel("PCA Component 1")
    plt.ylabel("PCA Component 2")
    plt.title("Clusters Visualization via PCA")
    plt.colorbar(label="Cluster")
    plt.show()

    # Examine the PCA loadings
    print(f"PCA Components (loadings): {fname}")
    print(pca.components_)
"""

    # Explained variance ratio
    print("Explained Variance Ratio:")
    print(pca.explained_variance_ratio_)

    # Create a DataFrame for easier interpretation of loadings
    loadings_df = pd.DataFrame(pca.components_.T, index=features, columns=["PC1", "PC2"])
    print(loadings_df)

    # Visualize the loadings for PC1
    plt.figure(figsize=(8, 5))
    plt.bar(loadings_df.index, loadings_df["PC1"])
    plt.xlabel("Food Groups")
    plt.ylabel("Loading on PC1")
    plt.title(f"PCA Loadings for PC1: {fname}")
    plt.xticks(rotation=45, ha="right")
    plt.show()

    # And visualizing loadings for PC2
    plt.figure(figsize=(8, 5))
    plt.bar(loadings_df.index, loadings_df["PC2"])
    plt.xlabel("Food Groups")
    plt.ylabel("Loading on PC2")
    plt.title(f"PCA Loadings for PC2: {fname}")
    plt.xticks(rotation=45, ha="right")
    plt.show()
<<<<<<< HEAD

=======
    
    # -----ANOVA Test for POP Levels-----
    if "POP_level" in data.columns:
        # create groups of POP_level for each cluster, dropping any missing values
        groups = [group["POP_level"].dropna() for name, group in data.groupby("cluster")]
        # run ANOVA if there are at least two groups
        if len(groups) >= 2:
            anova_res = f_oneway(*groups)
            print(f"ANOVA for POP_level in {fname}: F = {anova_res.statistic:.3f}, p = {anova_res.pvalue:.3f}")
            anova_results.append({
                "File": fname,
                "F_statistic": anova_res.statistic,
                "p_value": anova_res.pvalue
            })
        else:
            print(f"Not enough groups for ANOVA in {fname}")
    else:
        print(f"POP_level column not found in {fname}")
        
# summary table of ANOVA results for all processed files
anova_df = pd.DataFrame(anova_results)
print("Summary of ANOVA Results:")
print(anova_df)

# anova_df.to_csv("anova_summary_results.csv", index=False)
    
    
    
    
    
    
>>>>>>> 2ae2d96e4f736f13328f8ac0d905951d891ea0e7
"""
    for cluster, group in data.groupby("cluster"):
        print(f"\nCluster {cluster}:")
        print(group.head())

    fig , ax = plt.subplots(figsize=(7,7))

    sil_val = silhouette_samples(X, y_means)

    y_lower = 10

    for i in range(k):
        ith_cluster_sil_val = sil_val[y_means == i]
        ith_cluster_sil_val.sort()
        y_upper = y_lower + len(ith_cluster_sil_val)

        color = plt.cm.jet(float(i)/4)
        ax.fill_betweenx(np.arange(y_lower,y_upper), 0, ith_cluster_sil_val, facecolor=color, edgecolor=color, alpha=0.7)

        y_lower = y_upper+10

    ax.axvline(x=np.mean(sil_val), color="red", linestyle="--")

    ax.set_title(f"Silhouette Plot {fname}: {k} clusters ")
    ax.set_xlabel("Silhouette Coefficient")
    ax.set_ylabel("Samples Sorted by Cluster")
    ax.set_yticks([])
    ax.set_xlim(-0.1, 0.5)

    plt.show()
    
    # give me the plot!
    plt.figure(figsize=(8, 4))
    plt.plot(k_range, silhouette_scores, marker='o')
    plt.xlabel('Number of clusters')
    plt.ylabel('Silhouette Score')
    plt.title('Silhouette Score for Optimal k')
    plt.show()"
"""