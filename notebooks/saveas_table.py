df = spark.read.load("/databricks-datasets/learning-spark-v2/people/people-10m.delta")

# Write the data to a table.
table_name = "people_10m"
df.write.saveAsTable(table_name)

# Describe Saved Table
display(spark.sql('DESCRIBE DETAIL people_10m'))

# Read Table
people_df = spark.read.table(table_name)
display(people_df)
