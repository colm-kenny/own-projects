#import packages
import sys

import pandas as pd
#import data
#superstore csv
df = pd.read_csv('global_superstore_2016.csv',header=0, encoding='ISO-8859-1')
print(df.columns)
# command line argument 1: Product sub-category
#sub-cat list: ['Phones' 'Chairs' 'Copiers' 'Tables' 'Bookcases' 'Art' 
# 'Appliances' 'Storage' 'Fasteners' 'Machines' 'Accessories' 'Furnishings' 'Binders'
# 'Labels' 'Paper' 'Supplies' 'Envelopes']
#return: most popular product name, most popular product name bought in same basket
#sys.argv[1] = 'Sub-Category'
print(sys.argv[1])
sub_cat=sys.argv[1]
df1 = df[df['Sub-Category'].str.contains(sub_cat)]
#print most popular product name
print(df1[['Product Name']].value_counts().idxmax())
#print most popular product bought alongside ^ most popular product in sub-Cat
#print most profitable product in sub-cat: need product name, profit & quantity
df2=df1.filter(items=['Product Name', 'Quantity', 'Profit'])
df2=df2.groupby('Product Name').sum()
df2['ProfitpQ']=df2['Profit']/df2['Quantity']
print(df2[df2['ProfitpQ'] == df2['ProfitpQ'].max()])

