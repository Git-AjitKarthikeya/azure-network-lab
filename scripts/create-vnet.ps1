# ==============================================
# Azure Virtual Network & Subnet Provisioning
# Author: Ajit Karthikeya Balla
# ==============================================

$resourceGroup = "rg-network-lab"
$location = "eastus"
$vnetName = "vnet-lab"

New-AzResourceGroup -Name $resourceGroup -Location $location

$vnet = New-AzVirtualNetwork `
  -ResourceGroupName $resourceGroup `
  -Location $location `
  -Name $vnetName `
  -AddressPrefix "10.0.0.0/16"

Add-AzVirtualNetworkSubnetConfig `
  -Name "Subnet-Frontend" `
  -AddressPrefix "10.0.1.0/24" `
  -VirtualNetwork $vnet

Add-AzVirtualNetworkSubnetConfig `
  -Name "Subnet-Backend" `
  -AddressPrefix "10.0.2.0/24" `
  -VirtualNetwork $vnet

$vnet | Set-AzVirtualNetwork

Write-Host "VNet and Subnets created successfully."
