###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Resources
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine.html
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = local.name
  resource_group_name   = var.rg
  location              = var.region
  size                  = var.vmsize
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  provision_vm_agent    = true
  secure_boot_enabled   = var.secure_boot
  admin_username        = var.local_admin
  admin_password        = var.local_pass
  os_disk {
    name                 = "${local.name}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = var.managed_image_id
  dynamic "source_image_reference" {
    for_each = var.managed_image_id == null ? ["var.managed_image_id is null, single loop!"] : []
    content {
      publisher = var.market_place_image.publisher
      offer     = var.market_place_image.offer
      sku       = var.market_place_image.sku
      version   = var.market_place_image.version
    }
  }
  depends_on = [
    azurerm_network_interface.nic
  ]
  tags = merge(local.tags, {
    Automation = "OU check - AVD"
  })
}
# The sessionhost's NIC.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
resource "azurerm_network_interface" "nic" {
  name                = "${local.name}-nic"
  resource_group_name = var.rg
  location            = var.region
  ip_configuration {
    name                          = "${local.name}_config)"
    subnet_id                     = var.network_data.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags
}
# Required extension - the DSC installs all three agents and passes the registration token to the AVD agent.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension.html
resource "azurerm_virtual_machine_extension" "vm_dsc_ext" {
  name                       = "${local.name}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true
  settings                   = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${var.pool_input.v.pool_name}"
      }
    }
SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${var.token}"
    }
  }
PROTECTED_SETTINGS
  lifecycle {
    ignore_changes = [
      protected_settings,
    ]
  }
}
# Optional extension - only created if var.domain does not equal null.
# The lifecycle block prevents recreation for the existing VMs ext. when credentials are updated.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension.html
resource "azurerm_virtual_machine_extension" "domain_join_ext" {
  count                      = local.extensions.domain_join
  name                       = "${local.name}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
    {
      "Name": "${var.domain}",
      "OUPath": "${var.ou}",
      "User": "${var.domain_user}@${var.domain}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_pass}"
    }
PROTECTED_SETTINGS
  lifecycle {
    ignore_changes = [settings, protected_settings]
  }
}
# Optional extension - only created if var.workspaceid does not equal null.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension.html
resource "azurerm_virtual_machine_extension" "mmaagent_ext" {
  count                      = local.extensions.mmaagent
  name                       = "${local.name}-avd_mma"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
    {
      "workspaceId": "${var.workspace_id}"
    }
SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
   {
      "workspaceKey": "${var.workspace_key}"
   }
PROTECTED_SETTINGS
}