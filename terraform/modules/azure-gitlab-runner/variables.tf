# Input variable definition
variable "resource_group_name" {
  type =   string
}
variable "location" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "azurerm_user_assigned_identity" {
  type = string
}
variable "azurerm_shared_image" {
  type = string
}

variable "vmss_innstance_type" {
  description = "Virtual Machine Scale Set instance type (scaling runners)"
  type = string
}

variable "vm_instance_type" {
  description = "Virtual machine instance type (static runner)"
  type = string
}

variable "name_suffix" {
  description = "name suffix which will be added to VM and VMSS (e.g. 'D8as_v5')"
  type = string  
}
