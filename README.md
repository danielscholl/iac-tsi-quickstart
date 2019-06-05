# Introduction
Infrastructure as Code using ARM - Time Series Solution using ADSL Gen 2.

[![Build Status](https://dascholl.visualstudio.com/IoT/_apis/build/status/danielscholl.iac-tsi-quickstart?branchName=master)](https://dascholl.visualstudio.com/IoT/_build/latest?definitionId=28&branchName=master)


### Related Repositories
The solution can be tested with the following Simple Device Simulators

- [iot-device-js](https://github.com/danielscholl/iot-device-js) - Simple Device Testing (NodeJS)
- [iot-device-net](https://github.com/danielscholl/iot-device-net) - Simple Device Testing (C#)


# Provision Infrastructure 

>NOTE:  This can be performed via Portal UI or CloudShell (Bash/Powershell)

## Provision using portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fiac-tsi-quickstart%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


## Provision using bash

1. Run Install Script for ARM Process

```bash
# Initialize the Modules
initials="<your_initials>"
install.sh $initials
```


## Provision using powershell

1. Run Install Script for ARM Process

```bash
# Initialize the Modules
$initials = "<your_initials>"
install.ps1 -Initials $initials
```


# Test and Provision

>NOTE:  THIS CAN ONLY BE DONE FROM A LINUX SHELL!!

1. Manually run the test suite

```bash
npm install
npm test
```

2. Manually provision the infrastructure.

```bash
# Provision the infrastructure
npm run provision
```

# Azure Pipelines

1. Build Definition

    This project uses YAML builds.  A build would typically be created automatically but if not then a new Definition can be created and then import the `azure-pipelins.yml` YAML build file.

    - Ensure that the proper Project Level Service Connection exists to be able to utilize the desired Subscription

  