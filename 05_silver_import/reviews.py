# -*- coding: utf-8 -*-
"""
Created on Wed May 12 14:54:26 2021

@author: Gebruiker
"""
# %% Resources

#https://kokes.github.io/blog/2017/11/12/wikidata-streaming-dump.html
#https://github.com/lidalei/spark-clickhouse

# %% library imports

import gzip, json
from urllib.request import urlopen
import pandas as pd
import pyodbc

# %% define constants

url = 'https://s3-eu-west-1.amazonaws.com/bigdata-team/job-interview/item_dedup.json.gz'
server = 'DESKTOP-CP47TBL' 
database = 'stagingAmazonReviews'




buffer = []

with urlopen(url) as r:
    with gzip.GzipFile(fileobj=r) as f:
        for j, ln in enumerate(f):
            if ln == b'[\n' or ln == b']\n':
                continue
            if ln.endswith(b',\n'): # all but the last element
                obj = json.loads(ln[:-2])
            else:
                obj = json.loads(ln)
                        
            buffer.append(obj)
            
            if j == 10000: break
        
        
df_buffer = pd.DataFrame(buffer)

df_buffer = df_buffer.astype({'helpful': str})
df_buffer['reviewerName'] = df_buffer['reviewerName'].fillna('')

# %% Insert Dataframe into SQL Server:

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';Trusted_Connection=yes;')

cursor = cnxn.cursor()

# first we clear the tables

cursor.execute("""
               TRUNCATE TABLE [stagingAmazonReviews].[staging].[reviews];
               """)
 
cnxn.commit()  

# then we run the inserts from the df we transformed earlier
try:
    for index, row in df_buffer.iterrows():
        cursor.execute("""INSERT INTO stagingAmazonReviews.staging.reviews
                       (reviewerID
                        ,asin
                        ,reviewerName
                        ,helpful
                        ,overall
                        ,summary
                        ,unixReviewTime
                        ,reviewTime)
                       values(?,?,?,?,?,?,?,?)"""
                       ,row.reviewerID
                       ,row.asin
                       ,row.reviewerName
                       ,row.helpful
                       ,row.overall
                       ,row.summary
                       ,row.unixReviewTime
                       ,row.reviewTime)
    cnxn.commit()
except Exception as Arg:
    cursor.execute("""INSERT INTO [logs].[dbo].[silver_import_log]\
               ([timestamp]\
               ,[process]\
               ,[error])\
               values(GETDATE(),'silver_layer_reviews.py',?)"""
               , str(Arg)
               )
    cnxn.commit()

    
cursor.close()
