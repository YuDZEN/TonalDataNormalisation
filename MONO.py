import pandas as pd
from scipy.stats import zscore

#this was the original path to the data. So here, change the path to the path of your data
dataframe = pd.read_excel(r'C:\Users\Yu\OneDrive\桌面\GENERAL\CORPUS_SHANGHAIEN_MONO.xlsx')


columns_to_normalize = ['F0_10%', 'F0_20%', 'F0_30%', 'F0_40%', 'F0_50%', 'F0_60%', 'F0_70%', 'F0_80%', 'F0_90%', 'F0_100%']

# use zscore to normalise the data
for column in columns_to_normalize:
    dataframe[column] = zscore(dataframe[column])

# use grouped mean to replace the original data
mean_df = dataframe.groupby(['TON_DE_REFERENCE'])[columns_to_normalize].mean()

# reset the index
mean_df = mean_df.reset_index()

# save the data
mean_df.to_csv('average_values_MONO.csv', index=False)
print(dataframe)