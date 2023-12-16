import pandas as pd
from scipy.stats import zscore
# read XLSX as DataFrame
dataframe = pd.read_excel(r'C:\Users\Yu\OneDrive\桌面\GENERAL\CORPUS_SHANGHAIEN_SV.xlsx')

# define the colums to normalize
columns_to_normalize = ['F0_10%', 'F0_20%', 'F0_30%', 'F0_40%', 'F0_50%', 'F0_60%', 'F0_70%', 'F0_80%', 'F0_90%', 'F0_100%']

# use zscore function to normalize
for column in columns_to_normalize:
    dataframe[column] = zscore(dataframe[column])

# use groupby to divide groupes and 来分组数据，并计算平均值
mean_df = dataframe.groupby(['TON_COMBINAISON', 'POSITION_SYL'])[columns_to_normalize].mean()

# reset and transform columns of groups divided as normal columns
mean_df = mean_df.reset_index()

# save as csv
mean_df.to_csv('average_values_SV.csv', index=False)
print(dataframe)