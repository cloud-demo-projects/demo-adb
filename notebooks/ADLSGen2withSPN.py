# Configure authentication
service_credential = dbutils.secrets.get(scope="<scope>",key="<service-credential-key>")
 
spark.conf.set("fs.azure.account.auth.type.<storage-account>.dfs.core.windows.net", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type.<storage-account>.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.<storage-account>.dfs.core.windows.net", "<application-id>")
spark.conf.set("fs.azure.account.oauth2.client.secret.<storage-account>.dfs.core.windows.net", service_credential)
spark.conf.set("fs.azure.account.oauth2.client.endpoint.<storage-account>.dfs.core.windows.net", "https://login.microsoftonline.com/<directory-id>/oauth2/token")

# Read Databricks Dataset JSON
df = spark.read.json("/databricks-datasets/iot/iot_devices.json")

# Write Delta table to external path
df.write.save("abfss://<container-name>@<storage-account-name>.dfs.core.windows.net/<path-to-data>")

# List filesystem
dbutils.fs.ls("abfss://<container-name>@<storage-account-name>.dfs.core.windows.net/<path-to-data>")

# Read IoT Devices JSON from ADLS Gen2 filesystem
df2 = spark.read.load("abfss://<container-name>@<storage-account-name>.dfs.core.windows.net/<path-to-data>")
display(df2)
