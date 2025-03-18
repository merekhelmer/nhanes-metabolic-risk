import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from sklearn.impute import SimpleImputer
import os
from sklearn.metrics import silhouette_score, silhouette_samples

def filename_to_title(filename):
    fname = filename[10:-5]
    fname = no_dashes = fname.replace('-', ' ')
    fname = no_dashes[0].upper() + no_dashes[1:]
    return fname

# read data in 
data_path  = "Data/Processed_Datasets"
for filename in os.listdir(data_path):
    print(f"stating with {filename}")
    
    if filename == "Demo_Diet_thyroid-profile.xlsx":
        print(f"skipping {filename}")
        continue
    if filename == "Demo_Diet_standard-biochemistry-profile.xlsx":
        print(f"skipping {fname}")
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
    #imputer = SimpleImputer(strategy='mean')
    #X_imputed = imputer.fit_transform(X)
    X.iloc[:,-1] = scaler.fit_transform(X.iloc[:,[-1]])

    # find optimal of amount clusters
    inertia = []
    silhouette_scores = []
    k = 4
    kmeans = KMeans(n_clusters=k, random_state=42)
    y_means = kmeans.fit_predict(X)
    inertia.append(kmeans.inertia_)

    score = silhouette_score(X, kmeans.labels_)
    silhouette_scores.append(score)

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
    ax.set_ylabel("cluster label")
    ax.set_yticks([])
    ax.set_xlim(-0.1, 0.5)

    plt.show()
    

"""
    # give me the plot!
    plt.figure(figsize=(8, 4))
    plt.plot(k_range, inertia, marker='o')
    plt.xlabel('Number of clusters')
    plt.ylabel('Inertia')
    plt.title('Elbow Method for Optimal k')
    plt.show()

    plt.figure(figsize=(8, 4))
    plt.plot(k_range, silhouette_scores, marker='o')
    plt.xlabel('Number of clusters')
    plt.ylabel('Silhouette Score')
    plt.title('Silhouette Score for Optimal k')
    plt.show()"
"""