using 'vm.bicep'

param deployvms = true

@description('Admin password collected from KeyVault')
param adminPassword = az.getSecret(subId , kvRg , kvName, adminUsername, '')

var kvRg = ''
var kvName = ''

// Variables
var vmName = 'vm-azvm-01'
var subId = '00000000-0000-0000-0000-000000000000'
var vmRg = 'rg-uks-prod-01'
var adminUsername = 'adminuser'
var addssubnetResourceId = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-uks-prod-01/providers/Microsoft.Network/virtualNetworks/vnet-uks-prod-01/subnets/subnet-uks-prod-01'

var defaultTags = {
  environment: 'Production'
  costCenter: '123'
}

param vms = {
  vms: [
    {
      name: vmName
      subid: subId
      rg: vmRg
      adminUsername: adminUsername
      zone: 1
      privateIPAddress: 'CHANGEME'
      nicConfigurations: [
        {
        name: '${vmName}-nic-01'
        enableAcceleratedNetworking: false
        ipConfigurations: [
          {
            name: 'ipconfig1'
            privateIPAllocationMethod: 'Static'
            privateIPAddress: 'CHANGEME'
            subnetResourceId: addssubnetResourceId
          }
        ]
      }
      ]
      imageReference: {
        offer: 'WindowsServer'
        publisher: 'MicrosoftWindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
        }
        osDisk: {
          caching: 'ReadWrite'
          deleteOption: 'Detach'
          diskSizeGB: 128
          createOption: 'FromImage'
          managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          }
          name: '${vmName}-osdisk'
        }
        dataDisks: [
        {
          caching: 'None'
          deleteOption: 'Detach'
          diskSizeGB: 32
          createOption: 'Empty'
          managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          }
          name: '${vmName}-sysvol-datadisk'
        }
      ]
      osType: 'Windows'
      vmSize: 'Standard_B2ms'
      tags: union(defaultTags,{
          Importance: 'Critical'
          Purpose: 'VM Purpose'
          Service: 'Virtual Machine'
        })
      encryptionAtHost: true
    }
  ]
}
