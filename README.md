# JustEatAssignement
 Central Repos for code

The data is available at:
Reviews: https://s3-eu-west-1.amazonaws.com/bigdata-team/job-interview/item_dedup.json.gz
Metadata: https://s3-eu-west-1.amazonaws.com/bigdata-team/job-interview/metadata.json.gz

Note: The users are not authorized to access the S3 bucket but the files can be accessed. Do not attempt to access the s3 bucket instead download the files .
 
Some descriptives on the dataset can be found at: http://jmcauley.ucsd.edu/data/amazon/links.html

Assignment
Design and implement Data Warehouse (DWH) and design and implement corresponding Extract/Transform/Load (ETL)  pipeline to load the DWH.

Your solution must include:
Dimensional modelling of data.
At least one fact table.
Product price as one of the fields in the dimensional model.
Define dimension of price buckets (and define price buckets too).
Define dimension of product category (you may use only the highest category in the categories hierarchy. Pick the first category if a product belongs to multiple categories).
Data quality considerations (describe how data quality is implemented).
Duplicates handling.
Expressive, re-usable, clean code.
Some scheduling framework or workflow platform.
Describe the data store and tools used to query it - including the presentation layer.
Open source solutions and preferably avoid proprietary products.
It would be good if your solution would:
be scalable in case new data were to flow in on a high-volume basis(10x bigger) and has to be imported at a higher frequency.
Proper exception handling / logging for bullet proof runs (3 times a day).
Include a discussion on alternative modelling approaches, which might be beneficial for the DWH.
Remarks / Comments of those parts (optimization) where you could speed up execution and / or save network traffic.
Contain modelling and implementation of the check if the products bought and viewed contained the same ids.
Contain implementation of a dimension, which is of Type 2 Slowly Changing Dimension.
use containers.
Downloading the source data from the pipeline itself and have the ability to do the same at regular intervals.
 
The final result must consist of the following 2 insights:
Obtain histogram of review ratings - and be able to see a visualisation of the same.
Analysis of products by price bucket and product category.
