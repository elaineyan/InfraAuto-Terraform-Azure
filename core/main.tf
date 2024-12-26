
provider "azuread" {
  tenant_id     = var.tenant_id
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

locals {
  rg_name    = "${var.prefix}-rg"
  aks_subnet = lookup(module.vnet.vnet_subnets_name_id, "aks")
}

resource "azurerm_resource_group" "infra" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}
