#Usage:
# - Location: westeurope
# - Token: provide your databricks token
# - LibraryPath: VSTS path variable to the library file (in the repo)
# - ClusterConfigPath: VSTS path variable to the library file (in the repo)
# - *Other parameters: The parameters used in Databricks notebook
#==================================================================================


Param(
  [string]$Location,
  [string]$Token,
  [string]$ClusterConfigPath
)


<# Init for TLS 1.2 #>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add("Authorization", "Bearer $Token")

$ClusterBody = Get-Content -Path $ClusterConfigPath
$ClusterBody


Try{

#Create cluster using JSON body
function Create-Cluster( $Location, $Headers, $ClusterBody) {
    $Uri = "https://$Location.azuredatabricks.net/api/2.0/clusters/create"
    return Invoke-RestMethod -Method Post $Uri -Headers $Headers -Body $ClusterBody -Verbose
}

$ClusterId = (Create-Cluster $Location $Headers $ClusterBody)
$ClusterId = $ClusterId.cluster_id
$ClusterId

"##vso[task.setvariable variable=ClusterId]$ClusterId"

Write-Host "The Cluster is created with Cluster ID ""$ClusterId"""

}

Catch{

Write-Host $_.ErrorDetails.Message
exit 1

}
