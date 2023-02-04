variable "resource_group_name_prefix" {
  default     = "pl"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "azurerm_resource_group" {
  type    = string
  default = "Terraform"
}

variable "resource_group_location" {
  type    = string
  default = "Korea Central"
}

variable "azurerm_virtual_network" {
  type    = string
  default = "terraform_vpc"
}

variable "azurerm_subnet" {
  type    = string
  default = "tf-network-interface"
}

variable "azurerm_network_security_group_bak" {
  type = any
  default = {
    sg_name_0 = "SSH",
    sg_name_1 = "HTTP"
  }
}

variable "azurerm_network_security_group" {
  type    = string
  default = "tf-network-sg"
}