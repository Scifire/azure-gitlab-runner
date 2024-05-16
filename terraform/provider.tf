# Define that the Azure provider should be used
# and lock down the version
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}
provider "azurerm" {
  features {}
}
# Configure remote storage of our Terraform state in Azure
# No access keys, subscriptions or similar is needed here
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "ststorageexample"
    container_name       = "tfstate"
    key                  = "prod-gitlab-runner.terraform.tfstate"
  }
}