import pandas as pd
from scipy.stats import zscore
# 读取XLSX文件并加载为DataFrame
dataframe = pd.read_excel(r'C:\Users\Yu\OneDrive\桌面\GENERAL\CORPUS_SHANGHAIEN_SN.xlsx')

# 定义你想要标准化的列
columns_to_normalize = ['F0_10%', 'F0_20%', 'F0_30%', 'F0_40%', 'F0_50%', 'F0_60%', 'F0_70%', 'F0_80%', 'F0_90%', 'F0_100%']

# 对每列使用 zscore 函数进行标准化
for column in columns_to_normalize:
    dataframe[column] = zscore(dataframe[column])

# 使用 groupby 来分组数据，并计算平均值
mean_df = dataframe.groupby(['TON_COMBINAISON', 'POSITION_SYL'])[columns_to_normalize].mean()

# 重设索引，将分组的列重新变为普通列
mean_df = mean_df.reset_index()

# 将结果保存到 csv 文件中
mean_df.to_csv('average_values_SN.csv', index=False)
print(dataframe)