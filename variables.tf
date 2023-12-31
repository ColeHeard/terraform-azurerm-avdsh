###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "rg" {
  type        = string
  description = "Name of the resource group."
}
variable "side" {
  type        = string
  description = "Optional, appends an A or a B to the hostname for Blue/Green deployments."
  validation {
    condition = anytrue([
      lower(var.side) == "a",
      lower(var.side) == "b"
    ])
    error_message = "Invalid input. The accepted values are a or b."
  }
}
variable "pool_input" {
  type = map(object({
    workspace_prefix = string
    region_prefix    = string
    pool_type_prefix = string
    pool_number      = string
    pool_name        = string
  }))
  description = "Hostpool information created by companion module."
}
variable "token" {
  type        = string
  description = "Hostpool registration token created by companion module."
  sensitive   = true
}
variable "region" {
  type        = string
  description = "The desired Azure region for the session host. See also var.region_prefix_map."
  validation {
    condition = anytrue([
      lower(var.region) == "northcentralus",
      lower(var.region) == "southcentralus",
      lower(var.region) == "westcentral",
      lower(var.region) == "centralus",
      lower(var.region) == "westus",
      lower(var.region) == "eastus",
      lower(var.region) == "northeurope",
      lower(var.region) == "westeurope",
      lower(var.region) == "norwayeast",
      lower(var.region) == "norwaywest",
      lower(var.region) == "swedencentral",
      lower(var.region) == "switzerlandnorth",
      lower(var.region) == "uksouth",
      lower(var.region) == "ukwest"
    ])
    error_message = "Please select one of the approved regions: northcentralus, southcentralus, westcentral, centralus, westus, eastus, northeurope, westeurope, norwayeast, norwaywest, swedencentral, switzerlandnorth, uksouth, or ukwest."
  }
}
variable "vmnumber" {
  type        = number
  description = "The number of VM appended to the VM name. This exists for VM id."
  default     = 0
  validation {
    condition = (
      var.vmnumber >= 0 &&
      var.vmnumber <= 99
    )
    error_message = "The number of VMs must be between 0 and 99."
  }
}
variable "secure_boot" {
  type        = bool
  description = "Controls the trusted launch settings for the sessionhost VMs."
  default     = true
}
variable "market_place_image" {
  type        = map(any)
  description = "The publisher, offer, sku, and version of an image in Azure's market place. Only used if var.custom_image is null."
  default = {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-10"
    sku       = "win10-22h2-ent"
    version   = "latest"
  }
}
variable "managed_image_id" {
  type        = any
  description = "The ID of an Azure Compute Gallery image."
  default     = null
}
variable "network_data" {
  type        = any
  description = "The network data needed for sessionhost connectivity."
}
variable "local_admin" {
  type        = string
  description = "The local administrator username."
  default     = null
}
variable "local_pass" {
  type        = string
  description = "The local administrator password."
  default     = null
  sensitive   = true
}
variable "domain" {
  type        = string
  description = "Domain name string."
  default     = null
}
variable "domain_user" {
  type        = string
  description = "The identity that will join the VM to the domain. Omit the domain name itself."
  default     = null
}
variable "domain_pass" {
  type        = string
  description = "Password for var.domain_user"
  sensitive   = true
  default     = null
}
variable "workspace_id" {
  type        = string
  description = "The ID of the Log Analytics Workspace that will collect the data."
  default     = null
}
variable "workspace_key" {
  type        = string
  description = "The Log Analytics Workspace key."
  sensitive   = true
  default     = null
}
variable "vmsize" {
  type        = string
  description = "The SKU desired for the VM."
  default     = "standard_d2as_v4"
}
# To-do Azure Automation runbook to key off OU VM tag. This will be included within another repository.
variable "ou" {
  type        = string
  description = "The OU a VM should be placed within."
  default     = "" # Currently does not work, needs blank string to create VMs.
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables - Naming
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "region_prefix_map" {
  type        = map(any)
  description = "A list of prefix strings to concat in locals. Can be replaced or appended."
  default = {
    northcentralus   = "NCU"
    southcentralus   = "SCU"
    westcentral      = "WCU"
    centralus        = "USC"
    westus           = "USW"
    eastus           = "USE"
    northeurope      = "NEU"
    westeurope       = "WEU"
    norwayeast       = "NWE"
    norwaywest       = "NWN"
    swedencentral    = "SWC"
    switzerlandnorth = "SLN"
    uksouth          = "UKS"
    ukwest           = "UKW"
  }
}