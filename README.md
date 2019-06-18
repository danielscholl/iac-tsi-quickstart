# Introduction
Infrastructure as Code using ARM - Time Series Solution using ADSL Gen 2.

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

>Note:  This can be performed via Portal UI or CloudShell (Bash/Powershell)

__Provision using portal__

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)



__Provision using bash__

>Note:  Requires the use of [direnv](https://direnv.net/)

1. Run Install Script for ARM Process

```bash
# Initialize the Modules
initials="<your_initials>"
install.sh $initials
```

__Provision using powershell__

>Note:  Requires the use of [powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-6)

1. Run Install Script for ARM Process

```bash
# Initialize the Modules
$initials = "<your_initials>"
install.ps1 -Initials $initials
```

### Configure Access Rights to the Registry

This project provides a Container Registry.  It is important that an Access Control Role Assignment be setup with a Service Principal with a Reader Role for projects to be able to pull from the registry.


### Test the Solution (Optional)

>NOTE:  THIS CAN ONLY BE DONE FROM A LINUX SHELL!!

Manually run the test suite

```bash
npm install
npm test
```
