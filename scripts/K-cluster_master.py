import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from sklearn.impute import SimpleImputer

# read data in 
data  = pd.read_excel("Data/Master_dataset.xlsx")

# features are the varible names in the columns of the data set
features = list(data.columns)

# gets pop categories and diet features to one-hot encode in data
pop = [features[8]]
diet_features = list(reversed(features[-1:-10:-1]))
cat_features = pop + diet_features

data_encoded = pd.get_dummies(data, columns=cat_features)

# transformed features added to encoded data
encoded_features = list(data_encoded.columns)
X = data_encoded[encoded_features]

# standardize features
scaler = StandardScaler()
imputer = SimpleImputer(strategy='mean')
X_imputed = imputer.fit_transform(X)
X_scaled = scaler.fit_transform(X_imputed)

# find optimal of amount clusters
inertia = []
k_range = range(50,60)
for k in k_range:
    print(f"starting with {k}")
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_scaled)
    inertia.append(kmeans.inertia_)

# give me the plot!
plt.figure(figsize=(8, 4))
plt.plot(k_range, inertia, marker='o')
plt.xlabel('Number of clusters')
plt.ylabel('Inertia')
plt.title('Elbow Method for Optimal k')
plt.show()



