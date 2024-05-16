resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-prod-gitlab-runner-${var.name_suffix}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_B1ms"
  admin_username        = "adminuser"

  source_image_id = var.azurerm_shared_image

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = file(".ssh/id_rsa.pub")
  }
  identity {
    type = "UserAssigned"
    identity_ids = [ var.azurerm_user_assigned_identity ]
  }

}


resource "azurerm_network_interface" "main" {
  name                = "nic-gitlab-runner-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfigvm01"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

