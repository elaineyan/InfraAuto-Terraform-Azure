/** 
Reference: 
    AzureRM TF provider - https://registry.terraform.io/providers/hashicorp/azurerm/latest
    Azure CLI authentication https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli
*/
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.40, < 4.0"
    }
  }
}

provider "azuread" {
  tenant_id     = var.tenant_id
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
