# Introduction
Infrastructure as Code using ARM - Time Series Solution using ADSL Gen 2 with IoT Hub or Event Hubs.

[![Build Status](https://dascholl.visualstudio.com/IoT/_apis/build/status/danielscholl.iac-tsi-quickstart?branchName=master)](https://dascholl.visualstudio.com/IoT/_build/latest?definitionId=28&branchName=master)


### Create Environment File

Create an environment setting file in the root directory ie: `.env.ps1` or `.envrc`

Default Environment Settings

| Parameter             | Default                              | Description                              |
| --------------------  | ------------------------------------ | ---------------------------------------- |
| _ARM_SUBSCRIPTION_ID_ | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Azure Subscription Id                    |
| _AZURE_LOCATION_      | CentralUS                            | Azure Region for Resources to be located |
| _AZURE_USER_ID_       |                                      | User Object ID for TSI Contributor       |


### Provision Infrastructure 

>Note:  This can be performed via Portal UI or CloudShell (Powershell)

__Provision using portal__


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fiac-tsi-quickstart%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


__Provision using powershell__

>Note:  Requires the use of [powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-6)

1. Run Install Script for ARM Process

```bash
# Initialize the Modules
$initials = "<your_initials>"
./install.ps1 -Show true
./install.ps1 -Initials $initials
```

### Configure Access Rights to the Registry

This project provides a Container Registry.  It is important that an Access Control Role Assignment be setup with a Service Principal with a Reader Role for projects to be able to pull from the registry.


### Generate Data with a simulator

You can use the [Windfarm Simulator](https://tsiclientsample.azurewebsites.net/windFarmGen.html) to generate data to the `Ingest` Event Hub.

Examples of how to model the data in TSI are located in this sample [iot-tsi-api](https://github.com/danielscholl/iot-tsi-api) repository.