# terraform-azurerm-avdsh

## Azure Virtual Desktop Session Hosts

Author: Cole Heard

Version: 1.0.0

This module creates sessionhosts for Azure Virtual desktop. It is a companion module for version 1.1.0 of [terraform-azurerm-avd](https://github.com/ColeHeard/terraform-azurerm-avd).

<!-- BEGIN_TF_DOCS -->
#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.42.0 |

#### Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_extension.domain_join_ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.mmaagent_ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vm_dsc_ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Example Usage:
```hcl
module "example" {

	 # Required Input
	 source  =
	 version  =
	 network_data  = 
	 pool_input  = 
	 region  = 
	 rg  = 
	 side  = 
	 token  = 

	 # Optional Input
	 domain  =
	 domain_pass  =
	 domain_user  =
	 local_admin  =
	 local_pass  =
	 managed_image_id  =
	 market_place_image  =
	 ou  =
	 region_prefix_map  =
	 secure_boot  =
	 vmnumber  =
	 vmsize  =
	 workspace_id  =
	 workspace_key  =
}
```

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name string. | `string` | `null` | no |
| <a name="input_domain_pass"></a> [domain\_pass](#input\_domain\_pass) | Password for var.domain\_user | `string` | `null` | no |
| <a name="input_domain_user"></a> [domain\_user](#input\_domain\_user) | The identity that will join the VM to the domain. Omit the domain name itself. | `string` | `null` | no |
| <a name="input_local_admin"></a> [local\_admin](#input\_local\_admin) | The local administrator username. | `string` | `null` | no |
| <a name="input_local_pass"></a> [local\_pass](#input\_local\_pass) | The local administrator password. | `string` | `null` | no |
| <a name="input_managed_image_id"></a> [managed\_image\_id](#input\_managed\_image\_id) | The ID of an Azure Compute Gallery image. | `any` | `null` | no |
| <a name="input_market_place_image"></a> [market\_place\_image](#input\_market\_place\_image) | The publisher, offer, sku, and version of an image in Azure's market place. Only used if var.custom\_image is null. | `map(any)` | ```{ "offer": "windows-10", "publisher": "microsoftwindowsdesktop", "sku": "win10-22h2-ent", "version": "latest" }``` | no |
| <a name="input_network_data"></a> [network\_data](#input\_network\_data) | The network data needed for sessionhost connectivity. | `any` | n/a | yes |
| <a name="input_ou"></a> [ou](#input\_ou) | The OU a VM should be placed within. | `string` | `""` | no |
| <a name="input_pool_input"></a> [pool\_input](#input\_pool\_input) | Hostpool information created by companion module. | ```map(object({ workspace_prefix = string region_prefix = string pool_type_prefix = string pool_number = string pool_name = string }))``` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The desired Azure region for the session host. See also var.region\_prefix\_map. | `string` | n/a | yes |
| <a name="input_region_prefix_map"></a> [region\_prefix\_map](#input\_region\_prefix\_map) | A list of prefix strings to concat in locals. Can be replaced or appended. | `map(any)` | ```{ "centralus": "USC", "eastus": "USE", "northcentralus": "NCU", "northeurope": "NEU", "norwayeast": "NWE", "norwaywest": "NWN", "southcentralus": "SCU", "swedencentral": "SWC", "switzerlandnorth": "SLN", "uksouth": "UKS", "ukwest": "UKW", "westcentral": "WCU", "westeurope": "WEU", "westus": "USW" }``` | no |
| <a name="input_rg"></a> [rg](#input\_rg) | Name of the resource group. | `string` | n/a | yes |
| <a name="input_secure_boot"></a> [secure\_boot](#input\_secure\_boot) | Controls the trusted launch settings for the sessionhost VMs. | `bool` | `true` | no |
| <a name="input_side"></a> [side](#input\_side) | Optional, appends an A or a B to the hostname for Blue/Green deployments. | `string` | n/a | yes |
| <a name="input_token"></a> [token](#input\_token) | Hostpool registration token created by companion module. | `string` | n/a | yes |
| <a name="input_vmnumber"></a> [vmnumber](#input\_vmnumber) | The number of VM appended to the VM name. This exists for VM id. | `number` | `0` | no |
| <a name="input_vmsize"></a> [vmsize](#input\_vmsize) | The SKU desired for the VM. | `string` | `"standard_d2as_v4"` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | The ID of the Log Analytics Workspace that will collect the data. | `string` | `null` | no |
| <a name="input_workspace_key"></a> [workspace\_key](#input\_workspace\_key) | The Log Analytics Workspace key. | `string` | `null` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->

# Disclaimer

> See the LICENSE file for all disclaimers. Copyright (c) 2023 Cole Heard
