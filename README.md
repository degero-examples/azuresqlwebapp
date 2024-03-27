# Example Azure .Net 8 ASP.Net Core EFCore Azure SQL VNet

Example of Azure Webapp using Azure SQL with VNet Integration via PrivateLink

## Introduction

Azure Web App + Azure SQL Server on vnet with privatelink DNS registration
Designed to test infrastructure with azure sql and private connectivity on vnets

## Infrastructure

See Bicep in (/IAC/bicep) to setup. 

Update local.biceppparam with your sql server settings (servername=resourcename)

Either use vscode bicep plugin to deploy main.bicep

OR

cd iac/bicep
az group create -n <rgname> -l <location>
az deployment group create --resource-group rgname --template-file main.bicep

NOTE: This example aims to keep your costs at a minimum and does not include Azure SQL server/db and sets app service plan as Free.
To keep your costs minimal, use an existing (or manually create) SQL Server free instance and Database; Scale up/down your app service plan to the necessary B1 to use as you need

After deployment:

- Scale up to Basic app service plan 
- Turn on [vnet integration](https://learn.microsoft.com/en-us/azure/app-service/configure-vnet-integration-enable) to 10.0.0.0 subnet
- Add private endpoint for sql server in the target RG with dynamic ip, using existing privatelink.database.windows.net in target RG and on 10.1.0.0 (default2) subnet
- Turn off public network access for sql server
- Deploy to AzureSqlCoreApiWebApp.csproj to app service

# Production use

As this is only a demonstration, ideal security would invovle

- Add an NSG to default2 (10.1.0.0) subnet allowing only 1433
- Add application gateway + waf to app service and turn off app service public endpoint