# Databricks notebook source
# MAGIC %md
# MAGIC # Import csv and create table

# COMMAND ----------

import pandas as pd

# COMMAND ----------

test_pd = pd.read_csv("test.csv", sep='|', delimiter=None)
test_pd = spark.createDataFrame(test_pd)
test_pd.createOrReplaceTempView("test_used")
