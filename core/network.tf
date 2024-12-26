
module "aks_nsg" {
  source  = "Azure/network-security-group/azurerm"
  version = "4.0.1"

  resource_group_name     = local.rg_name
  location                = var.location
  security_group_name     = "${var.prefix}-aks-nsg"
  source_address_prefixes = var.core_source_address_prefixes
  predefined_rules        = var.core_aks_predefined_rules
  custom_rules            = var.core_aks_custom_rules
  tags                    = var.tags

  depends_on = [azurerm_resource_group.infra]
}

module "db_nsg" {
  source  = "Azure/network-security-group/azurerm"
  version = "4.0.1"

  resource_group_name     = local.rg_name
  location                = var.location
  security_group_name     = "${var.prefix}-db-nsg"
  source_address_prefixes = var.core_source_address_prefixes
  predefined_rules        = var.core_db_predefined_rules
  custom_rules            = var.core_db_custom_rules
  tags                    = var.tags

  depends_on = [azurerm_resource_group.infra]
}

/**
Create Azure Vnet and Subnets
Reference:
    https://registry.terraform.io/modules/Azure/vnet/azurerm/latest
    https://github.com/Azure/terraform-azurerm-vnet
**/

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.0.0"

  vnet_name           = "${var.prefix}-vnet"
  vnet_location       = var.location
  resource_group_name = local.rg_name
  use_for_each        = true
  address_space       = var.core_address_space
  subnet_prefixes     = var.core_subnet_prefixes
  subnet_names        = var.core_subnet_names
  nsg_ids = {
    aks = module.aks_nsg.network_security_group_id
    db  = module.db_nsg.network_security_group_id
  }
  subnet_service_endpoints = var.core_subnet_service_endpoints

  depends_on = [azurerm_resource_group.infra]
}



