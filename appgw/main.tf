locals {
  rg_name                        = "${var.prefix}-rg"
  location                       = data.azurerm_resource_group.appgw.location
  backend_address_pool_name      = "${module.appgw_vnet.vnet_name}-beap"
  frontend_port_name             = "${module.appgw_vnet.vnet_name}-feport"
  frontend_ip_configuration_name = "${module.appgw_vnet.vnet_name}-feip"
  http_setting_name              = "${module.appgw_vnet.vnet_name}-be-htst"
  listener_name                  = "${module.appgw_vnet.vnet_name}-httplstn"
  request_routing_rule_name      = "${module.appgw_vnet.vnet_name}-rqrt"
}

data "azurerm_resource_group" "appgw" {
  name = local.rg_name
}

module "appgw_fe_nsg" {
  source  = "Azure/network-security-group/azurerm"
  version = "4.0.1"

  resource_group_name     = local.rg_name
  security_group_name     = "${var.prefix}-appgw-fe-nsg"
  source_address_prefixes = var.appgw_source_address_prefixes
  predefined_rules        = var.appgw_fe_nsg_predefined_rules
  custom_rules            = var.appgw_fe_nsg_custom_rules # Reference: https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-faq#how-do-i-use-application-gateway-v2-with-only-private-frontend-ip-address

  tags = var.tags
}

module "appgw_be_nsg" {
  source  = "Azure/network-security-group/azurerm"
  version = "4.0.1"

  resource_group_name     = local.rg_name
  security_group_name     = "${var.prefix}-appgw-be-nsg"
  source_address_prefixes = var.appgw_source_address_prefixes
  predefined_rules        = var.appgw_be_nsg_predefined_rules
  custom_rules            = var.appgw_be_nsg_custom_rules
  tags                    = var.tags
}

module "appgw_vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.0.0"

  vnet_name           = "${var.prefix}-appgw-vnet"
  vnet_location       = local.location
  resource_group_name = local.rg_name
  use_for_each        = true
  address_space       = var.appgw_vnet_address_space #TODO: need to discuss with IAAS
  subnet_prefixes     = var.appgw_vnet_subnet_prefixes
  subnet_names        = ["${var.prefix}-appgw-fe-snet", "${var.prefix}-appgw-be-snet"] #var.appgw_vnet_subnet_names

  nsg_ids = {
    "${var.prefix}-appgw-fe-snet" = module.appgw_fe_nsg.network_security_group_id
    "${var.prefix}-appgw-be-snet" = module.appgw_be_nsg.network_security_group_id
  }
}

# VNet peering : from core vnet ----> AppGw vnet
resource "azurerm_virtual_network_peering" "core2appgw" {
  name                      = "core2appgw"
  resource_group_name       = local.rg_name
  virtual_network_name      = "${var.prefix}-vnet"
  remote_virtual_network_id = module.appgw_vnet.vnet_id
}

# Look up VNet ID created in 'core' based on name
data "azurerm_virtual_network" "core" {
  name                = "${var.prefix}-vnet"
  resource_group_name = local.rg_name
}

# VNet peering : from AppGw vnet ----> core vnet
resource "azurerm_virtual_network_peering" "appgw2core" {
  name                      = "appgw2core"
  resource_group_name       = local.rg_name
  virtual_network_name      = "${var.prefix}-appgw-vnet"
  remote_virtual_network_id = data.azurerm_virtual_network.core.id

  depends_on = [module.appgw_vnet]
}

# Private IP only is not supported with AppGateway V2, hence public IP
resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-appgw-pip"
  resource_group_name = local.rg_name
  location            = local.location
  allocation_method   = var.appgw_pip_allocation_method
  sku                 = var.appgw_pip_sku
  domain_name_label = "${var.prefix}"
}

