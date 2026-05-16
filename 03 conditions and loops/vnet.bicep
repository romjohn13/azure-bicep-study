param subnetList array = [
  {
    name: 'VM'
    ipAddressRange: '10.0.1.0/24'
  }
  {
    name: 'VMSS'
    ipAddressRange: '10.0.2.0/24'
  }
  {
    name: 'DataBase'
    ipAddressrange: '10.0.3.0/24'
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressrange: '10.0.4.0/24'
  }
]

var subnetProperties = [for subnet in subnetList: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
    }
  }
]


param vnetlist array = [
  {
    name: 'toy'
    addressSpaceRange: '10.0.0.0/16'
    location: 'souteastasia'
    environmenttype: 'prod'
    subnet: [
              {
              name: 'VM'
              ipAddressRange: '10.0.1.0/24'
              }
              {
              name: 'VMSS'
              ipAddressRange: '10.0.2.0/24'
              }
              {
              name: 'DataBase'
              ipAddressrange: '10.0.3.0/24'
              }
              {
              name: 'AzureFirewallSubnet'
              ipAddressrange: '10.0.4.0/24'
              }
      ]
  }
    {
    name: 'toy'
    addressSpaceRange: '10.1.0.0/16'
    location: 'souteastasia'
    environmenttype: 'dev'
        subnet: [
              {
              name: 'VM'
              ipAddressRange: '10.1.1.0/24'
              }
              {
              name: 'VMSS'
              ipAddressRange: '10.1.2.0/24'
              }
              {
              name: 'DataBase'
              ipAddressrange: '10.1.3.0/24'
              }
              {
              name: 'AzureFirewallSubnet'
              ipAddressrange: '10.1.4.0/24'
              }
      ]
  }
]

resource virtualNetwork'Microsoft.Network/virtualNetworks@2025-05-01' = [ for vnet in vnetlist: {
  name: '${vnet.name}-${vnet.environmenttype}'
  location: vnet.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressSpaceRange
      ]
    }
    subnets: [ for subnet in vnet.subnet: {
      name: subnet.name
      properties: {
        addressPrefix:subnet.ipAddressrange
      }
        }
      ]
    }
  }
]

output vnetOutput array = [for i in range(0, length(vnetlist)): {
  name: virtualNetwork[i].name
  location: virtualNetwork[i].location
  id: virtualNetwork[i].id
  addressSpace: virtualNetwork[i].properties.addressSpace
  subnets: virtualNetwork[i].properties.subnets
}]
