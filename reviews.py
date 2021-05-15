# -*- coding: utf-8 -*-
"""
Created on Wed May 12 14:54:26 2021

@author: Gebruiker
"""

#https://kokes.github.io/blog/2017/11/12/wikidata-streaming-dump.html
#https://github.com/lidalei/spark-clickhouse

import gzip, json
from urllib.request import urlopen
import pandas as pd
import pyodbc

server = 'DESKTOP-CP47TBL' 
database = 'stagingAmazonReviews'
url = 'https://s3-eu-west-1.amazonaws.com/bigdata-team/job-interview/item_dedup.json.gz'

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';Trusted_Connection=yes;')

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
            
            if j == 50: break
        
        
df_buffer = pd.DataFrame(buffer)

df_buffer = df_buffer.astype({'helpful': str})
df_buffer['reviewerName'] = df_buffer['reviewerName'].fillna('')

# Insert Dataframe into SQL Server:

cursor = cnxn.cursor()
 
for index, row in df_buffer.iterrows():
    cursor.execute("""INSERT INTO stagingAmazonReviews.staging.reviews (reviewerID,asin,reviewerName,helpful,reviewText,overall,summary,unixReviewTime,reviewTime) values(?,?,?,?,?,?,?,?,?)"""
                   , row.reviewerID
                   , row.asin
                   , row.reviewerName
                   ,row.helpful
                   ,row.reviewText
                   ,row.overall
                   ,row.summary
                   ,row.unixReviewTime
                   ,row.reviewTime)
cnxn.commit()
cursor.close()
