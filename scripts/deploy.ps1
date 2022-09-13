<#
.DESCRIPTION
    This script will deploy the ARM template

.PARAMETER ResourceGroupName [String]
    Name of the resource group

.PARAMETER Location [String]
    Location of the deloyment

.PARAMETER TemplatePath [String]
    TemplatePath path

.PARAMETER ParameterPath [String]
    ParameterPath path

#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [String] $ResourceGroupName,

    [Parameter(Mandatory)]
    [String] $Location,

    [Parameter(Mandatory)]
    [String] $TemplatePath,

    [Parameter(Mandatory)]
    [String] $ParameterPath
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

#. $PSScriptRoot/TODO

# Write-Host "Resource group deployment starting with $ResourceGroupName and $Location"
# New-AzDeployment -Name $ResourceGroupName -TemplateFile "rgdeploy.json" -Location $Location

New-AzResourceGroup -Name $ResourceGroupName -Location $Location

$templateFile = "$TemplatePath/azuredeploy.json"
$parameterFile = "$ParameterPath/azuredeploy.parameters.dev.json"

If (!(Test-Path $TemplateFile)) {
    Write-Host "Template file not found"
}

$params = @{
    "ResourceGroupName"     = $ResourceGroupName
    "Mode"                  = "Incremental"
    "TemplateFile"          = $templateFile
    "TemplateParameterFile" = $parameterFile
    "location"              = $location
    "ErrorVariable"         = "errorMessages"
}

Test-AzResourceGroupDeployment @params -ErrorAction Stop
Write-Host "Validation Succeded"

New-AzResourceGroupDeployment @params -DeploymentDebugLogLevel None

If ($errorMessages ){
    Write-Error "Deployment Failed"
}
Else {
    Write-Host "Deployment Succeded"
}