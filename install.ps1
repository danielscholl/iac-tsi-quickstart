<#
.SYNOPSIS
  Infrastructure as Code Component
.DESCRIPTION
  Install a Time Series Instance Solution
.EXAMPLE
  .\install.ps1
  Version History
  v1.0   - Initial Release
#>
#Requires -Version 5.1
#Requires -Module @{ModuleName='AzureRM.Resources'; ModuleVersion='5.0'}

Param(
  [string]$Subscription = $env:ARM_AZURE_SUBSCRIPTION,
  [string]$Initials = "cat",
  [string]$ResourceGroupName,
  [string]$Location = $env:AZURE_LOCATION,
  [string] $servicePrincipalAppId = $env:AZURE_PRINCIPAL
)

. ./.env.ps1
Get-ChildItem Env:*AZURE*

if ( !$Subscription) { throw "Subscription Required" }
if ( !$ResourceGroupName) { $ResourceGroupName = "$Initials-tsi-resources" }
if ( !$Location) { throw "Location Required" }


###############################
## FUNCTIONS                 ##
###############################
function Write-Color([String[]]$Text, [ConsoleColor[]]$Color = "White", [int]$StartTab = 0, [int] $LinesBefore = 0, [int] $LinesAfter = 0, [string] $LogFile = "", $TimeFormat = "yyyy-MM-dd HH:mm:ss") {
  # version 0.2
  # - added logging to file
  # version 0.1
  # - first draft
  #
  # Notes:
  # - TimeFormat https://msdn.microsoft.com/en-us/library/8kb3ddd4.aspx

  $DefaultColor = $Color[0]
  if ($LinesBefore -ne 0) {  for ($i = 0; $i -lt $LinesBefore; $i++) { Write-Host "`n" -NoNewline } } # Add empty line before
  if ($StartTab -ne 0) {  for ($i = 0; $i -lt $StartTab; $i++) { Write-Host "`t" -NoNewLine } }  # Add TABS before text
  if ($Color.Count -ge $Text.Count) {
    for ($i = 0; $i -lt $Text.Length; $i++) { Write-Host $Text[$i] -ForegroundColor $Color[$i] -NoNewLine }
  }
  else {
    for ($i = 0; $i -lt $Color.Length ; $i++) { Write-Host $Text[$i] -ForegroundColor $Color[$i] -NoNewLine }
    for ($i = $Color.Length; $i -lt $Text.Length; $i++) { Write-Host $Text[$i] -ForegroundColor $DefaultColor -NoNewLine }
  }
  Write-Host
  if ($LinesAfter -ne 0) {  for ($i = 0; $i -lt $LinesAfter; $i++) { Write-Host "`n" } }  # Add empty line after
  if ($LogFile -ne "") {
    $TextToFile = ""
    for ($i = 0; $i -lt $Text.Length; $i++) {
      $TextToFile += $Text[$i]
    }
    Write-Output "[$([datetime]::Now.ToString($TimeFormat))]$TextToFile" | Out-File $LogFile -Encoding unicode -Append
  }
}

function Get-ScriptDirectory {
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

function LoginAzure() {
  Write-Color -Text "Logging in and setting subscription..." -Color Green
  if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    if($env:AZURE_TENANT) {
      Login-AzureRmAccount -TenantId $env:AZURE_TENANT
    } else {
      Login-AzureRmAccount
    }
  }
  Set-AzureRmContext -SubscriptionId ${Subscription} | Out-null

}

function CreateResourceGroup([string]$ResourceGroupName, [string]$Location) {
  # Required Argument $1 = RESOURCE_GROUP
  # Required Argument $2 = LOCATION

  $group = Get-AzureRmResourceGroup -Name $ResourceGroupName
  if($group) {
    Write-Color -Text "Resource Group ", "$ResourceGroupName ", "already exists." -Color Green, Red, Green
    return $group.Tags.RANDOM
  } else {
    Write-Host "Creating Resource Group $ResourceGroupName..." -ForegroundColor Yellow

    $UNIQUE = ( Get-Random -Minimum 0 -Maximum 999 ).ToString('000')
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{ RANDOM=$UNIQUE; contact=$Initials }
    return $UNIQUE
  }
}

function ResourceProvider([string]$ProviderNamespace) {
  # Required Argument $1 = RESOURCE

  $result = Get-AzureRmResourceProvider -ProviderNamespace $ProviderNamespace | Where-Object -Property RegistrationState -eq "Registered"

  if ($result) {
    Write-Color -Text "Provider ", "$ProviderNamespace ", "already registered." -Color Green, Red, Green
  }
  else {
    Write-Host "Registering Provider $ProviderNamespace..." -ForegroundColor Yellow
    Register-AzureRmResourceProvider -ProviderNamespace $ProviderNamespace
  }
}

###############################
## Azure Initialize           ##
###############################
$BASE_DIR = Get-ScriptDirectory
$DEPLOYMENT = Split-Path $BASE_DIR -Leaf
LoginAzure

$UNIQUE = CreateResourceGroup $ResourceGroupName $Location
ResourceProvider Microsoft.Storage
ResourceProvider Microsoft.Devices
ResourceProvider Microsoft.TimeSeriesInsights

Write-Color -Text "Gathering Service Principal..." -Color Green
if ($servicePrincipalAppId) {
  $ID = $servicePrincipalAppId
}
else {
  $ACCOUNT = $(Get-AzureRmContext).Account
  if ($ACCOUNT.Type -eq 'User') {
    $USER = Get-AzureRmADUser -UPN $(Get-AzureRmContext).Account
    $ID = $USER.Id.Guid
  }
  else {
    $ID = Read-Host 'Input your Service Principal.'
  }
}

##############################
## Deploy Template          ##
##############################
Write-Color -Text "`r`n---------------------------------------------------- "-Color Yellow
Write-Color -Text "Deploying ", "$DEPLOYMENT ", "template..." -Color Green, Red, Green
Write-Color -Text "---------------------------------------------------- "-Color Yellow
New-AzureRmResourceGroupDeployment -Name $DEPLOYMENT `
  -TemplateFile $BASE_DIR\azuredeploy.json `
  -TemplateParameterFile $BASE_DIR\azuredeploy.parameters.json `
  -initials $INITIALS `
  -random $UNIQUE `
  -ResourceGroupName $ResourceGroupName
