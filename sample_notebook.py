# # COMMAND ----------
# from dataclasses import dataclass
# from typing import List


# @dataclass
# class SourceInfo:
#     table: str
#     path: str
#     database: str = "ref"


# # COMMAND ----------
# sources: List[SourceInfo] = [
#     SourceInfo(table="test_data", path="/tmp/test_data.csv")
# ]

# # COMMAND ----------
# for source in sources:
#     spark.sql("create database if not exists {}".format(source.database))
#     spark.sql("""
#     create table if not exists {database}.{table} using com.databricks.spark.csv options (path "{path}", header "true")
#   """.format(
#         database=source.database,
#         table=source.table,
#         path=source.path))
#     spark.sql("refresh table {database}.{table}".
#           format(database=source.database, table=source.table))
