#========================================================================
#Usage:
# - ADBSecrets: List of databricks secrets
# - Location: westeurope
# - Token: provide your databricks token
# - ScopeName: Databricks secret scope name
#========================================================================

Param(

    [string]$Location,
    [string]$Token,
    [string]$ScopeName,
    [string]$ServicePrincipalAppId,
    [string]$ServicePrincipalPwd,
    [string]$tenantId,
    [string]$BlobAccountKey,
    [string]$SynapseSqlServerUser,
    [string]$SynapseSqlServerPwd,
    [string]$MetadataAPIToken,
    [string]$MetadataAPITokenPrd,
    [string]$ServicenowAPIRefreshToken,
    [string]$ServicenowClientId,
    [string]$ServicenowClientSecret
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add("Authorization", "Bearer $Token")

$ADBSecrets = @{
    "service_principal_appid" = $ServicePrincipalAppId
    "service_principal_pwd" = $ServicePrincipalPwd
    "tenant_id" = $tenantId
    "blob_account_key" = $BlobAccountKey
    "synapse_sql_server_user" = $SynapseSqlServerUser
    "synapse_sql_server_pwd" = $SynapseSqlServerPwd
    "metadata_api_token" = $MetadataAPIToken
    "metadata_api_token_prd" = $MetadataAPITokenPrd
    "servicenow_api_refresh_token" = $ServicenowAPIRefreshToken
    "servicenow_api_client_id" = $ServicenowClientId
    "servicenow_api_client_secret" = $ServicenowClientSecret
}

#List secret scopes
function List-SecretScopes($Location, $Headers){
    $Uri = "https://$Location.azuredatabricks.net/api/2.0/secrets/scopes/list"
    Invoke-RestMethod -Method GET $Uri -Headers $Headers -Verbose
}

#List secrets
function List-Secrets($Location, $Headers, $ScopeName){
    $Uri = "https://$Location.azuredatabricks.net/api/2.0/secrets/list?scope=$ScopeName"
    Invoke-RestMethod -Method GET $Uri -Headers $Headers -Verbose
}

#Create secret scope
function Create-SecretScope($Location, $Headers, $ScopeName){
    $Uri = "https://$Location.azuredatabricks.net/api/2.0/secrets/scopes/create"
    $bodyparm = @{scope="$ScopeName"
    initial_manage_principal="users"
    }
    Invoke-RestMethod -Method POST $Uri -Headers $Headers -Body (ConvertTo-Json $bodyparm) -Verbose
}

#delete secret scope
function Delete-Scope($Location, $Headers, $ScopeName){
    $Uri = "https://$Location.azuredatabricks.net/api/2.0/secrets/scopes/delete"
    $bodyparm = @{scope="$ScopeName"}
    Invoke-RestMethod -Method POST $Uri -Headers $Headers -Body (ConvertTo-Json $bodyparm) -Verbose
}

#Set secrets
function Set-Secret($Location, $Headers, $ScopeName, $Key, $Value) {
    $uri = "https://$Location.azuredatabricks.net/api/2.0/secrets/put"
    $bodyParams = @{scope="$ScopeName"; key="$key"; string_value="$value"}
    return Invoke-RestMethod -Method Post $uri  -Headers $headers -Body (ConvertTo-Json $bodyParams) -Verbose
}

(List-SecretScopes $Location $Headers).scopes.name

Try{
    $ErrorActionPreference = "Stop"
    ((List-Secrets $Location $Headers $ScopeName).secrets) | Out-Null
}

catch {
    #($_.ErrorDetails.Message | ConvertFrom-Json).error_code
    Write-Host $_.ErrorDetails.Message
}

If($ScopeName -in (List-SecretScopes $Location $Headers).scopes.name){
    Write-Host "The scope ""$ScopeName"" already exists" -ForegroundColor Green
    (List-Secrets $Location $Headers $ScopeName).secrets
    # Removing scope so we can re-create with all secrets
    (Delete-Scope $Location $Headers $ScopeName)
    Write-Host "The scope ""$ScopeName"" has successfully been deleted"
    #Exit 0
    Write-Host "The scope ""$ScopeName"" deleted, let's create one and load the secrets!" -ForegroundColor Red
    Try{
        $ErrorActionPreference = "Stop"
        Create-SecretScope $Location $Headers $ScopeName
        $ADBSecrets.Keys | ForEach-Object {"key = $_, value = " + $ADBSecrets.Item($_)} | Out-Null
        $ADBSecrets.Keys | ForEach-Object {Set-Secret $Location $Headers $ScopeName $_ $ADBSecrets.Item($_)}
        Write-Host "The databricks secret scope ""$ScopeName"" has been created" -ForegroundColor Green
        (List-Secrets $Location $Headers $ScopeName).secrets
    }
    Catch{
        $_.ErrorDetails.Message
    }
}

Else{
    Write-Host "The scope ""$ScopeName"" doesn't exists, let's create one and load the secrets!" -ForegroundColor Red
    Try{
        $ErrorActionPreference = "Stop"
        Create-SecretScope $Location $Headers $ScopeName
        $ADBSecrets.Keys | ForEach-Object {"key = $_, value = " + $ADBSecrets.Item($_)} | Out-Null
        $ADBSecrets.Keys | ForEach-Object {Set-Secret $Location $Headers $ScopeName $_ $ADBSecrets.Item($_)}
        Write-Host "The databricks secret scope ""$ScopeName"" has been created" -ForegroundColor Green
        (List-Secrets $Location $Headers $ScopeName).secrets
    }
    Catch{
        $_.ErrorDetails.Message
    }
}
