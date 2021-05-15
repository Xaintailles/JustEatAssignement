# -*- coding: utf-8 -*-
"""
Created on Thu May 13 13:53:46 2021

@author: Gebruiker
"""
# %% library imports

import gzip, json
from urllib.request import urlopen
import numpy as np
import pandas as pd
import ast
import pyodbc

# %% define constants

url = 'https://s3-eu-west-1.amazonaws.com/bigdata-team/job-interview/metadata.json.gz'
server = 'DESKTOP-CP47TBL' 
database = 'stagingAmazonReviews'
 
# %% pull

#extra steps because file comes with ' instead of " in the json file, so some intermediate transformations are needed

buffer = []

with urlopen(url) as r:
    with gzip.GzipFile(fileobj=r) as f:
        for j, ln in enumerate(f):
            if ln == b'[\n' or ln == b']\n':
                continue
            if ln.endswith(b',\n'): # all but the last element
                obj = ast.literal_eval(ln[:-2].decode('utf8'))
                obj = json.dumps(obj)
                obj = json.loads(obj)
            else:
                obj = ast.literal_eval(ln.decode('utf8'))
                obj = json.dumps(obj)
                obj = json.loads(obj)
                        
            buffer.append(obj)
            
            if j == 10000: break
        
df_buffer = pd.DataFrame(buffer)
        
# %% category transformation
 
df_category = df_buffer[['asin','categories']]

# We have a list of categories and sub_categories nested in a list of list
# We first get the lists out and number them, to find back the first one if need be

df_category = df_category.explode('categories')

df_category['category_list_rank'] = df_category.groupby("asin").cumcount() + 1

# Once we have that, we explode the lists and number the items again so that we can find the root each time
# The main item would then be where list_rank = 1 and item_rank = 1

df_category = df_category.explode('categories')

df_category['category_item_rank'] = df_category.groupby(['asin','category_list_rank']).cumcount() + 1

df_category = df_category.where(pd.notnull(df_category), None)

# %% salesRank transformation

df_salesrank = df_buffer[['asin','salesRank']]

# We get the values out of the dictionnary, then melt the df to have a normalized table to export

df_salesrank = pd.concat([df_salesrank.drop(['salesRank'], axis=1), df_salesrank['salesRank'].apply(pd.Series)], axis=1)

df_salesrank = df_salesrank.melt(id_vars=['asin'], var_name='category', value_name='sales_rank').dropna()

df_salesrank = df_salesrank.where(pd.notnull(df_salesrank), None)

# %% related transformation

df_related = df_buffer[['asin','related']]

# We get the values out of the dictionnary, then melt the df to have a normalized table to export

df_related = pd.concat([df_related.drop(['related'], axis=1), df_related['related'].apply(pd.Series)], axis=1)

df_related = df_related.melt(id_vars=['asin'], var_name='related_type', value_name='related').dropna()

df_related = df_related.explode('related')

df_related = df_related.where(pd.notnull(df_related), None)

# %% metadata

df_metadata = df_buffer.drop(['salesRank','categories','related'], axis = 1)

# None is equivalent to NULL in sql, necessary to insert in float columns

df_metadata['description'] = df_metadata['description'].str.slice(0,3999)

df_metadata = df_metadata.where(pd.notnull(df_metadata), None)

# %% Insert Dataframe into SQL Server:

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';Trusted_Connection=yes;')

cursor = cnxn.cursor()

# first we clear the tables

cursor.execute("""
               TRUNCATE TABLE [stagingAmazonReviews].[staging].[category];
               TRUNCATE TABLE [stagingAmazonReviews].[staging].[salesrank];
               TRUNCATE TABLE [stagingAmazonReviews].[staging].[related];
               TRUNCATE TABLE [stagingAmazonReviews].[staging].[metadata];
               """)
 
cnxn.commit()    

# then we run the inserts from the df we transformed earlier

try:
    for index, row in df_category.iterrows():
        cursor.execute("""INSERT INTO stagingAmazonReviews.staging.category\
                       ([asin]\
                       ,[categories]\
                       ,[category_list_rank]\
                       ,[category_item_rank])\
                       values(?,?,?,?)"""
                       , row.asin
                       , row.categories
                       , row.category_list_rank
                       , row.category_item_rank
                       )        
    cnxn.commit()
except Exception as Arg:
    cursor.execute("""INSERT INTO [logs].[dbo].[silver_import_log]\
               ([timestamp]\
               ,[process]\
               ,[error])\
               values(GETDATE(),'silver_layer_metadata_category.py',?)"""
               , str(Arg)
               )
    cnxn.commit()
    
try:    
    for index, row in df_salesrank.iterrows():
        cursor.execute("""INSERT INTO stagingAmazonReviews.staging.salesrank\
                       ([asin]\
                       ,[category]\
                       ,[sales_rank])\
                       values(?,?,?)"""
                       , row.asin
                       , row.category
                       , row.sales_rank
                       )
            
    cnxn.commit()
except Exception as Arg:
    cursor.execute("""INSERT INTO [logs].[dbo].[silver_import_log]\
               ([timestamp]\
               ,[process]\
               ,[error])\
               values(GETDATE(),'silver_layer_metadata_salesrank.py',?)"""
               , str(Arg)
               )
    cnxn.commit()

try:     
    for index, row in df_related.iterrows():
        cursor.execute("""INSERT INTO stagingAmazonReviews.staging.related\
                       ([asin]\
                       ,[related_type]\
                       ,[related])\
                       values(?,?,?)"""
                       , row.asin
                       , row.related_type
                       , row.related
                       )
            
    cnxn.commit()
except Exception as Arg:
    cursor.execute("""INSERT INTO [logs].[dbo].[silver_import_log]\
               ([timestamp]\
               ,[process]\
               ,[error])\
               values(GETDATE(),'silver_layer_metadata_related.py',?)"""
               , str(Arg)
               )
    cnxn.commit()

try:     
    for index, row in df_metadata.iterrows():
        cursor.fast_executemany = True
        cursor.execute("""INSERT INTO stagingAmazonReviews.staging.metadata\
                       ([asin]\
                       ,[imUrl]\
                       ,[title]\
                       ,[description]\
                       ,[price]\
                       ,[brand])\
                       values(?,?,?,?,?,?)"""
                       , row.asin
                       , row.imUrl
                       , row.title
                       , row.description
                       , row.price
                       , row.brand
                       )
    
    cnxn.commit()
except Exception as Arg:
    cursor.execute("""INSERT INTO [logs].[dbo].[silver_import_log]\
               ([timestamp]\
               ,[process]\
               ,[error])\
               values(GETDATE(),'silver_layer_metadata_metadata.py',?)"""
               , str(Arg)
               )
    cnxn.commit()

cursor.close()





































