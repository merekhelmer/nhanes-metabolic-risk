import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import os
from sklearn.metrics import silhouette_score, silhouette_samples

# read data in
data_path = "../Data/Processed_Datasets"
for filename in os.listdir(data_path):
    if "profile" in filename:
        continue
    print(f"starting with {filename}")
    file_path = os.path.join(data_path, filename)

    data = pd.read_excel(file_path, engine='openpyxl')

    # grab just the POPs
    features = data.columns[-2]
    X = data[features]
    print(X)

"""
    # normalize the data
    scaler = StandardScaler()
    #X.iloc[:, -1] = scaler.fit_transform(X.iloc[:, [-1]])
    X = scaler.fit_transform(X)

    # run clustering
    silhouette_scores = []
    k_range = range(4, 7)
    for k in k_range:
        kmeans = KMeans(n_clusters=k, random_state=42)
        kmeans.fit(X)
        y_means = kmeans.fit_predict(X)

        score = silhouette_score(X, kmeans.labels_)
        silhouette_scores.append(score)

        fig, ax = plt.subplots(figsize=(7, 7))

        sil_val = silhouette_samples(X, y_means)

        y_lower = 10

        for i in range(k):
            ith_cluster_sil_val = sil_val[y_means == i]
            ith_cluster_sil_val.sort()
            y_upper = y_lower + len(ith_cluster_sil_val)

            color = plt.cm.jet(i / 4)
            ax.fill_betweenx(np.arange(y_lower, y_upper), 0, ith_cluster_sil_val, facecolor=color, edgecolor=color,
                             alpha=0.7)

            y_lower = y_upper + 10

        ax.axvline(x=np.mean(sil_val), color="red", linestyle="--")

        ax.set_title("Sil plot")
        ax.set_xlabel("sil coeff")
        ax.set_ylabel("cluster laber")
        ax.set_yticks([])
        ax.set_xlim(-0.1, 1)

        plt.show()
"""