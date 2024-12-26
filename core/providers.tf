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
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.35.0"
    }
  }
}
