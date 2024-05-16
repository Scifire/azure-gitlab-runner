resource "azurerm_resource_group" "prod-gitlab" {
  name     = "rg-prod-gitlab-runner"
  location = "West Europe"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-prod-gitlab-runner"
  address_space       = ["172.16.10.0/24"]
  location            = azurerm_resource_group.prod-gitlab.location
  resource_group_name = azurerm_resource_group.prod-gitlab.name
}
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.prod-gitlab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.10.0/25"]
}

resource "azurerm_user_assigned_identity" "gitlab" {
  location            = azurerm_resource_group.prod-gitlab.location
  name                = "Gitlab-runners"
  resource_group_name = azurerm_resource_group.prod-gitlab.name
}

resource "azurerm_role_assignment" "gitlab" {
  scope                = azurerm_resource_group.prod-gitlab.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.gitlab.principal_id
}

# This module can be used multiple times. Each time it will deploy the static runner VM and a VMSS which are bound together through the gitlab runner config.
# It could be used to have different types of runners available (e.g small and big ones), for this we also need multiple Gitlab runner tokens.
module "azure-gitlab-runner-D8as_v5" {
  source = "./modules/azure-gitlab-runner"

  vm_instance_type = "Standard_B1ms"
  vmss_innstance_type = "Standard_D8as_v5"
  name_suffix = "D8as-v5"

  resource_group_name = azurerm_resource_group.prod-gitlab.name
  location = azurerm_resource_group.prod-gitlab.location
  subnet_id = azurerm_subnet.internal.id
  azurerm_user_assigned_identity = azurerm_user_assigned_identity.gitlab.id
  azurerm_shared_image = data.azurerm_shared_image.gitlab.id

}