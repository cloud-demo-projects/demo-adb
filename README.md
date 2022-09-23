# Demo ADB
Notebook CI/CD with ADB

## IaC Prerequsites
- Vnet with adbprivate01-subnet and adbpublic01-subnet with NSGs attached. MSFT backend sets the custom NSG rules themselves.
- KV with purge protection enabled.

## Notebook Azure SQL connectivity with Service Endpoint Prerequisites
- Public subnet NSG rule whitelisting towards Microsoft.Sql destination on port 1433
- Public subnet service endpoint towards Microsoft.Sql
- Azure SQL selected networks whitelisting ADB public subnet
- Keep Azure SQL "Allow Azure service" whitelisting off for security purpose

## Databricks Runtime Libraries
https://learn.microsoft.com/en-us/azure/databricks/release-notes/runtime/10.4#system-environment
