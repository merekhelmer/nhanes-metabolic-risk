import pandas as pd
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from sklearn.metrics import silhouette_score
from sklearn.impute import SimpleImputer

data = pd.read_excel("Data/Processed_Datasets/master.xlsx", engine='openpyxl')

# features are the varible names in the columns of the data set
features = list(data.columns[19:])

# transformed features added to encoded data
X = data[features].copy()

imputer = SimpleImputer(strategy='mean')
X_imputed = imputer.fit_transform(X)
X = pd.DataFrame(X_imputed, columns=features)

# standardize features
scaler = StandardScaler()
X.iloc[:,-1] = scaler.fit_transform(X.iloc[:,[-1]])

# find optimal of amount clusters
inertia = []
silhouette_scores = []
k = 3
kmeans = KMeans(n_clusters=k, random_state=42)
y_means = kmeans.fit_predict(X)
inertia.append(kmeans.inertia_)

score = silhouette_score(X, kmeans.labels_)
silhouette_scores.append(score)

data["cluster"] = y_means

pca = PCA(n_components=2)
X_pca = pca.fit_transform(X)

plt.figure(figsize=(8, 5))
plt.scatter(X_pca[:, 0], X_pca[:, 1], c=data['cluster'], cmap='viridis', alpha=0.6)
plt.xlabel("PCA Component 1")
plt.ylabel("PCA Component 2")
plt.title(f"Clusters Visualization via PCA for all POPs")
plt.colorbar(label="Cluster")
plt.show()

# Create a DataFrame for easier interpretation of loadings
loadings_df = pd.DataFrame(pca.components_.T, index=features, columns=["PC1", "PC2"])
print(loadings_df)

# Visualize the loadings for PC1
plt.figure(figsize=(8, 5))
plt.bar(loadings_df.index, loadings_df["PC1"])
plt.xlabel("PCA variables")
plt.ylabel("Loading on PC1")
plt.title(f"PCA Loadings for PC1")
plt.xticks(rotation=30, ha="right")
plt.show()

# And visualizing loadings for PC2
plt.figure(figsize=(8, 5))
plt.bar(loadings_df.index, loadings_df["PC2"])
plt.xlabel("PCA variables")
plt.ylabel("Loading on PC2")
plt.title(f"PCA Loadings for PC2")
plt.xticks(rotation=30, ha="right")
plt.show()
