targetScope = 'resourceGroup'

param vms object
param deployvms bool
@secure()
param adminPassword string

module deployVM 'br/public:avm/res/compute/virtual-machine:0.12.2' = [for vm in vms.vms: if (deployvms) {
  name: 'deploy-vm-${vm.name}'
  scope: resourceGroup(vm.subid,vm.rg)
  params: {
    name: vm.name
    adminUsername: vm.adminUsername
    adminPassword: adminPassword
    imageReference: vm.imageReference
    nicConfigurations: vm.nicConfigurations
    osDisk: vm.osDisk
    osType: vm.osType
    vmSize: vm.vmSize
    zone: vm.zone
    dataDisks: vm.dataDisks
    location: resourceGroup().location
    timeZone: 'GMT Standard Time'
    secureBootEnabled: true
    vTpmEnabled: true
    securityType: 'TrustedLaunch'
    encryptionAtHost: vm.encryptionAtHost
    tags: vm.tags
  }
}
]
