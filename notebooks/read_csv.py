# Databricks Notebook Source
# MAGIC %md
# MAGIC ### Install libraries to read from Excel

# COMMAND ----------

# MAGIC %pip install xlrd openpyxl

# COMMAND ----------

# MAGIC %md
# MAGIC ### Import pandas to read from Excel

# COMMAND ----------

import pandas as pd

# COMMAND ----------

# MAGIC %md
# MAGIC ### Read from Excel

# COMMAND ----------

ak_pd = pd.read_excel("test.xlsx")

# COMMAND ----------

# MAGIC %md
# MAGIC ### Create spark dataframe

# COMMAND ----------

ak_df = spark.createDataFrame(ak_pd)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Create temporary view

# COMMAND ----------

ak_df.createOrReplaceTempView("test")

# COMMAND ----------

# MAGIC %md
# MAGIC ### Other functions

# COMMAND ----------

display(ak_df)

# COMMAND ----------

ak_df.count()
