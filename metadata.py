# -*- coding: utf-8 -*-
"""
Created on Thu May 13 13:53:46 2021

@author: Gebruiker
"""

import gzip, json
from urllib.request import urlopen
import pandas as pd
import ast

url = 'https://s3-eu-west-1.amazonaws.com/bigdata-team/job-interview/metadata.json.gz'

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
            
            if j == 50: break
        
        
df_buffer = pd.DataFrame(buffer)

test = df_buffer[['asin','categories']]

print(type(test['categories'][0]))

test = test.explode('categories')
test['Rank'] = test.groupby("asin").cumcount() + 1

test = test.explode('categories')

# Insert Dataframe into SQL Server:
