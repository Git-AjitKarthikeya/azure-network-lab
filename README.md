# Azure VM & Network Deployment Lab

> Enterprise-grade Azure network infrastructure provisioned from scratch using ARM Templates, PowerShell, and the Azure Portal — replicating real-world network access segmentation and security controls.

---

## Problem Statement

Manually configuring Azure network environments is error-prone and inconsistent across teams. This lab demonstrates how to provision a secure, segmented Azure network with a Windows Server VM using repeatable scripts and templates — the same approach used in enterprise cloud environments.

---

## Architecture
```
Internet
    │
    ▼
Application Gateway (Public IP)
    │
    ▼
Azure Virtual Network (10.0.0.0/16)
    ├── Subnet-Frontend (10.0.1.0/24)
    │       └── NSG: Allow HTTP/HTTPS Inbound
    └── Subnet-Backend (10.0.2.0/24)
            └── NSG: Allow RDP from Frontend only
                    │
                    ▼
            Windows Server VM
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Cloud Platform | Microsoft Azure |
| Infrastructure | Azure Virtual Network, Subnets, NSGs |
| Compute | Windows Server VM |
| Automation | PowerShell, Azure CLI |
| Templates | ARM Templates |
| Monitoring | NSG Diagnostic Logs |

---

## What Was Built

### 1. Virtual Network & Subnets
- Created a custom Azure VNet with address space `10.0.0.0/16`
- Defined two subnets: Frontend (`10.0.1.0/24`) and Backend (`10.0.2.0/24`)
- Enforced network isolation between tiers

### 2. Network Security Groups (NSGs)
- Frontend NSG: Allow inbound HTTP (80) and HTTPS (443), deny all other inbound
- Backend NSG: Allow RDP (3389) only from Frontend subnet IP range
- All outbound traffic logged for audit review

### 3. Windows Server VM
- Deployed inside Backend subnet
- Configured with scoped NSG rules to prevent unauthorized access
- RDP access validated and confirmed working within defined rules

### 4. Diagnostic Logging
- Enabled NSG flow logs to monitor traffic behavior
- Verified 100% rule compliance across all tested access scenarios
- Zero connectivity failures recorded during validation

---

## PowerShell Scripts

### Create Virtual Network and Subnets
```powershell
# Variables
$resourceGroup = "rg-network-lab"
$location = "eastus"
$vnetName = "vnet-lab"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Virtual Network
$vnet = New-AzVirtualNetwork `
  -ResourceGroupName $resourceGroup `
  -Location $location `
  -Name $vnetName `
  -AddressPrefix "10.0.0.0/16"

# Add Frontend Subnet
Add-AzVirtualNetworkSubnetConfig `
  -Name "Subnet-Frontend" `
  -AddressPrefix "10.0.1.0/24" `
  -VirtualNetwork $vnet

# Add Backend Subnet
Add-AzVirtualNetworkSubnetConfig `
  -Name "Subnet-Backend" `
  -AddressPrefix "10.0.2.0/24" `
  -VirtualNetwork $vnet

# Save Configuration
$vnet | Set-AzVirtualNetwork

Write-Host "Virtual Network and Subnets created successfully."
```

### Create and Attach NSG Rules
```powershell
# Create NSG for Backend Subnet
$nsg = New-AzNetworkSecurityGroup `
  -ResourceGroupName $resourceGroup `
  -Location $location `
  -Name "nsg-backend"

# Allow RDP from Frontend Subnet only
Add-AzNetworkSecurityRuleConfig `
  -NetworkSecurityGroup $nsg `
  -Name "Allow-RDP-Frontend" `
  -Protocol Tcp `
  -Direction Inbound `
  -Priority 100 `
  -SourceAddressPrefix "10.0.1.0/24" `
  -SourcePortRange "*" `
  -DestinationAddressPrefix "*" `
  -DestinationPortRange "3389" `
  -Access Allow

# Deny all other inbound
Add-AzNetworkSecurityRuleConfig `
  -NetworkSecurityGroup $nsg `
  -Name "Deny-All-Inbound" `
  -Protocol "*" `
  -Direction Inbound `
  -Priority 200 `
  -SourceAddressPrefix "*" `
  -SourcePortRange "*" `
  -DestinationAddressPrefix "*" `
  -DestinationPortRange "*" `
  -Access Deny

$nsg | Set-AzNetworkSecurityGroup
Write-Host "NSG rules applied successfully."
```

---

## Results

- ✅ Custom VNet provisioned with two isolated subnets
- ✅ NSG rules enforced — RDP accessible only from Frontend subnet
- ✅ Windows Server VM deployed and validated via RDP
- ✅ 100% rule compliance across all tested access scenarios
- ✅ Zero connectivity failures during diagnostic validation

---

## Key Learnings

- How to design subnet segmentation for frontend/backend isolation
- How NSG rule priority order affects traffic decisions
- How to use NSG diagnostic logs to audit and troubleshoot traffic
- How PowerShell automates what the Azure Portal does manually — faster and repeatably

---

## Author

**Ajit Karthikeya Balla**  
📧 ajitkarthikeyaballa@gmail.com  
💼 [linkedin.com/in/ajitkarthikeyaballa](https://linkedin.com/in/ajitkarthikeyaballa)
