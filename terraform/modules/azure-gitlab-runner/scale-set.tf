resource "azurerm_linux_virtual_machine_scale_set" "scale-set" {
  name                = "vmss-prod-gitlab-runner-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_D8as_v5"
  admin_username      = "adminuser"
  admin_password      = "<securepassword>" # This password will only be valid for the spawned vms and only from internal
  disable_password_authentication = false

  source_image_id = var.azurerm_shared_image

  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-gitlab-runner-scaled"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
    }
  }
# Ignore running instances, they are managed by the static runner
  lifecycle {
    ignore_changes = [
      instances
    ]
  }
}