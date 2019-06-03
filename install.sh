#!/usr/bin/env bash
#
#  Purpose: Initialize the template load for testing purposes
#  Usage:
#    install.sh



###############################
## ARGUMENT INPUT            ##
###############################

usage() { echo "Usage: install.sh " 1>&2; exit 1; }

if [ -f ./.envrc ]; then source ./.envrc; fi

if [ ! -z $1 ]; then INITIALS=$1; fi
if [ -z $INITIALS ]; then
  INITIALS="cat"
fi

if [ -z $ARM_SUBSCRIPTION_ID ]; then
  tput setaf 1; echo 'ERROR: AZURE_SUBSCRIPTION not provided' ; tput sgr0
  usage;
fi

if [ -z $AZURE_LOCATION ]; then
  tput setaf 1; echo 'ERROR: AZURE_LOCATION not provided' ; tput sgr0
  usage;
fi

if [ -z $PREFIX ]; then
  PREFIX="arm"
fi


###############################
## FUNCTIONS                 ##
###############################
function CreateResourceGroup() {
  # Required Argument $1 = RESOURCE_GROUP
  # Required Argument $2 = LOCATION

  if [ -z $1 ]; then
    tput setaf 1; echo 'ERROR: Argument $1 (RESOURCE_GROUP) not received'; tput sgr0
    exit 1;
  fi
  if [ -z $2 ]; then
    tput setaf 1; echo 'ERROR: Argument $2 (LOCATION) not received'; tput sgr0
    exit 1;
  fi

  local _result=$(az group show --name $1)
  if [ "$_result"  == "" ]
    then
      UNIQUE=$(shuf -i 100-999 -n 1)
      OUTPUT=$(az group create --name $1 \
        --location $2 \
        --tags RANDOM=$UNIQUE contact=$INITIALS \
        -ojsonc)
      tput setaf 3;  echo "Created Resource Group $1."; tput sgr0
    else
      tput setaf 3;  echo "Resource Group $1 already exists."; tput sgr0
      UNIQUE=$(az group show --name $1 --query tags.RANDOM -otsv)
    fi
}

function ResourceProvider() {
  # Required Argument $1 = RESOURCE_PROVIDER

  local _result=$(az provider show --namespace $1 --query registrationState -otsv)
  if [ "$_result"  == "" ]
    then
      az provider register --namespace $1
    else
    tput setaf 3;  echo "Resource Provider $1 already registered."; tput sgr0
  fi
}


###############################
## Azure Intialize           ##
###############################

tput setaf 2; echo 'Logging in and setting subscription...' ; tput sgr0
az account set --subscription ${ARM_SUBSCRIPTION_ID}

tput setaf 2; echo 'Creating Resource Group...' ; tput sgr0
RESOURCE_GROUP="$INITIALS-tsi-resources"
CreateResourceGroup $RESOURCE_GROUP $AZURE_LOCATION

tput setaf 2; echo 'Registering Resource Provider...' ; tput sgr0
ResourceProvider Microsoft.Storage



tput setaf 2; echo 'Deploying ARM Template...' ; tput sgr0
az group deployment create --template-file azuredeploy.json  \
    --resource-group $RESOURCE_GROUP \
    --parameters azuredeploy.parameters.json \
    --parameters initials=$INITIALS --parameters random=$UNIQUE