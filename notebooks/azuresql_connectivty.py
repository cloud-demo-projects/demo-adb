jdbcUrl = "jdbc:sqlserver://demo-adf-dbserver.database.windows.net:1433;database=demo-adf-db;user=<USER>@demo-adf-dbserver;password=<PASSWORD>;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"

df = spark.read.jdbc(url=jdbcUrl, table='emp')
display(df)
