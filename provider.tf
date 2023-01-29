terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}

<<<<<<< HEAD
  subscription_id = "7d916e23-9568-4b0d-93f9-fb59905603ec"
  tenant_id       = "4a92cb1c-6470-45cc-9de5-8111336e4d98"
  client_id       = "b75138be-cca0-4cb6-80f3-983c1d2fc043"
  client_secret   = "uEV8Q~_vMQKV2QpT_1Autfx20Oxv4RWGZ~DWgaVZ"
}
=======
  subscription_id = "HERE"
  tenant_id       = "HERE"
  client_id       = "HERE"
  client_secret   = "HERE"
}
>>>>>>> 730828ee0b385664df2522a3e5a42155ee536a22
