resource "azurerm_shared_image_gallery" "image_gallery" {
  name                = "gal_prod_gitlab_runner"
  resource_group_name = azurerm_resource_group.prod-gitlab.name
  location            = azurerm_resource_group.prod-gitlab.location
  description         = "Images for Gitlab runners in Azure"

}

resource "azurerm_shared_image" "image" {
  name                = "Gitlab-Runner"
  gallery_name        = azurerm_shared_image_gallery.image_gallery.name
  resource_group_name = azurerm_resource_group.prod-gitlab.name
  location            = azurerm_resource_group.prod-gitlab.location
  os_type             = "Linux"

  identifier {
    publisher = "publisher"
    offer     = "Gitlab-Runner"
    sku       = "22_04-lts"
  }
}

resource "azurerm_shared_image_version" "version01" {
  name                = "0.0.2"
  gallery_name        = azurerm_shared_image_gallery.image_gallery.name
  image_name          = azurerm_shared_image.image.name
  resource_group_name = azurerm_resource_group.prod-gitlab.name
  location            = azurerm_resource_group.prod-gitlab.location
  managed_image_id    = "/subscriptions/<subscription-id>/resourceGroups/rg-prod-gitlab-runner/providers/Microsoft.Compute/images/img_gitlab_runner"

  target_region {
    name                   = azurerm_resource_group.prod-gitlab.location
    regional_replica_count = 1
    storage_account_type   = "Standard_LRS"
  }
}

data "azurerm_shared_image" "gitlab" {
  resource_group_name  = azurerm_resource_group.prod-gitlab.name
  name                 = "Gitlab-Runner"
  gallery_name         = "gal_prod_gitlab_runner"
}