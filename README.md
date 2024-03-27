# Example Azure .Net 8 ASP.Net Core EFCore Azure SQL VNet Azure DNS

Example of Azure Webapp using Azure SQL with VNet Integration via PrivateLink.
This is a simplified version not for production use.


## Introduction

Azure Web App + Azure SQL Server on vnet with privatelink DNS registration.\
Designed to test infrastructure with azure sql and private connectivity on vnets.


## Prereqs

- A SQL Server + DB (it is not included in bicep as you can create 1 Free instance per subscription to keep your costs down)


## Costs

Not all services are free to use this example, only the app service plan is the most costly and is recommended to scale up / down from Free as neeeded to test out:

- 1 x App Service Plan B1 (needed to use VNet integration to reach SQL server) [Pricing](https://azure.microsoft.com/en-us/pricing/details/app-service/windows/)
- 1 x PrivateLink [Pricing](https://azure.microsoft.com/en-us/pricing/details/private-link/)
- 1 x Private dns zone [Pricing]https://azure.microsoft.com/en-in/pricing/details/dns/()


## Benefits

- SQL server not publicly accessible
- DNS resolution for sql connectionstring / dynamic IPs makes for simpler configuration and deployment 


## Infrastructure

See Bicep in (/IAC/bicep) to setup. 

Update local.biceppparam with your sql server settings (servername=resourcename)

Either use [vscode bicep plugin](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to deploy main.bicep

OR using Azure CLI

cd iac/bicep
az group create -n <rgname> -l <location>
az deployment group create --resource-group rgname --template-file main.bicep

NOTE: This example aims to keep your costs at a minimum and does not include Azure SQL server/db and sets app service plan as Free.
To keep your costs minimal, use an existing (or manually create) SQL Server free instance and Database; Scale up/down your app service plan to the necessary B1 to use as you need

After deployment:

- Scale up to Basic app service plan 
- Turn on Web app [vnet integration](https://learn.microsoft.com/en-us/azure/app-service/configure-vnet-integration-enable) to 10.0.0.0 subnet
- Add private endpoint for the sql server in the target RG with dynamic ip, using existing privatelink.database.windows.net in target RG and on 10.1.0.0 (services) subnet [create-a-private-endpoint](https://learn.microsoft.com/en-us/azure/private-link/create-private-endpoint-portal?tabs=dynamic-ip#create-a-private-endpoint)
- Turn off public network access for sql server
- Deploy to AzureSqlCoreApiWebApp.csproj to app service


## Production use

As this is only a demonstration, recommended security would include but not limited to:

- Add an NSGs eg: to webapp subnet (10.0.0.0) only 80/443, to services subnet (10.1.0.0) allowing only 1433
- Turn off SQL user auth and use Managed identity on App Service and alter connection string
- Add application gateway + waf to app service and turn off app service public endpoint


## Further Reading

[Architecture - Zone redundant webapp sql](https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant)\
[Connect to SQL Server behind vnet](https://learn.microsoft.com/en-us/azure/app-service/tutorial-dotnetcore-sqldb-app#how-do-i-connect-to-the-azure-sql-database-server-thats-secured-behind-the-virtual-network-with-other-tools)