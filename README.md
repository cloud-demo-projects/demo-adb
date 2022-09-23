# Demo ADB
Notebook CI/CD with ADB

## IaC Prerequsites
- Vnet with adbprivate01-subnet and adbpublic01-subnet with NSGs attached. MSFT backend sets the custom NSG rules themselves.
- KV with purge protection enabled.

## Notebook Azure SQL connectivity with Private Endpoint Prerequisites
- PLE subnet with private sqlserver endpoint deployed underneath; should create VNet private endpoint
- Public subnet NSG outbound rule whitelisting towards ple-subnet on port 1433
- PLE subnet inbound whitelisting from public-subnet on port 1433
- Keep Azure SQL "Allow Azure service" whitelisting off for security purpose
![image](https://user-images.githubusercontent.com/67367858/191954451-e8f3ae4e-4b07-4f40-bc54-b105fb33f1f6.png)

## Notebook Azure SQL connectivity with Service Endpoint Prerequisites
- Public subnet NSG rule whitelisting towards Microsoft.Sql destination on port 1433
- Public subnet service endpoint towards Microsoft.Sql
- Azure SQL selected networks whitelisting ADB public subnet
- Keep Azure SQL "Allow Azure service" whitelisting off for security purpose
![image](https://user-images.githubusercontent.com/67367858/191954659-c48be317-df17-4b61-aac0-2bcc8be7d2d4.png)

## Databricks Runtime Libraries
https://learn.microsoft.com/en-us/azure/databricks/release-notes/runtime/10.4#system-environment

## Additional Libraries
To make third-party or custom code available to notebooks and jobs running on your clusters, you can install a library.
https://learn.microsoft.com/en-us/azure/databricks/libraries/
