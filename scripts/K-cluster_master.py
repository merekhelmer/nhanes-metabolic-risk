import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt

data  = pd.read_excel("Data/Master_dataset.xlsx")

print(data.head())