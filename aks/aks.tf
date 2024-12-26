locals {
  rg_name                        = "${var.prefix}-rg"
}

data "azurerm_resource_group" "infra" {
  name = local.rg_name
}

data "azurerm_subnet" "infra" {
  name                 = var.aks_subnet_name
  virtual_network_name = "${var.prefix}-vnet"
  resource_group_name  = local.rg_name
}

data "azurerm_application_gateway" "infra" {
  count = var.custom_application_gateway ? 1 : 0
  #TODO: For IAAS created AppGateway, need to lookup based on ID or Name
  name                = "${var.prefix}-appgw"
  resource_group_name = local.rg_name
}

/**
Create AKS cluster
Reference:
    https://registry.terraform.io/modules/Azure/aks/azurerm/latest
    https://github.com/Azure/terraform-azurerm-aks
**/
## TODO: create variables to parametrize 
module "aks" {
  source  = "Azure/aks/azurerm"
  version = "6.7.0"

  prefix                           = var.prefix
  client_id                        = var.client_id
  client_secret                    = var.client_secret
  resource_group_name              = local.rg_name
  vnet_subnet_id                   = data.azurerm_subnet.infra.id
  kubernetes_version               = var.aks_kubernetes_version
  api_server_authorized_ip_ranges  = var.aks_api_server_authorized_ip_ranges
  log_analytics_workspace_enabled  = false
  agents_pool_name                 = var.aks_agents_pool_name
  agents_count                     = var.aks_agents_count # applicable only when, enable_auto_scaling = false
  agents_min_count                 = var.aks_agents_min_count
  agents_max_count                 = var.aks_agents_max_count
  network_plugin                   = var.aks_network_plugin
  network_policy                   = var.aks_network_policy ## TODO: plan to use AzureCNI
  sku_tier                         = var.aks_sku_tier
  agents_availability_zones        = var.aks_agents_availability_zones
  agents_tags                      = var.aks_agents_tags
  net_profile_dns_service_ip       = var.aks_net_profile_dns_service_ip
  net_profile_service_cidr         = var.aks_net_profile_service_cidr
  net_profile_docker_bridge_cidr   = var.aks_net_profile_docker_bridge_cidr
  attached_acr_id_map              = var.aks_attached_acr_id_map
  http_application_routing_enabled = true

  #TODO: For IAAS created AppGateway, need to lookup based on ID or Name
  ingress_application_gateway_id      = var.custom_application_gateway ? data.azurerm_application_gateway.infra.0.id : null
  ingress_application_gateway_enabled = var.custom_application_gateway ? true : false

  ## TODO: check on need to integrate with AzureAD
  rbac_aad                          = var.aks_rbac_aad
  rbac_aad_managed                  = var.aks_rbac_aad_managed
  role_based_access_control_enabled = var.aks_role_based_access_control_enabled
  rbac_aad_admin_group_object_ids   = var.aks_rbac_aad_admin_group_object_ids
  rbac_aad                           = false
  role_based_access_control_enabled  = false
  tags = var.tags
}

/*
 Create AKS Node Pool
 Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool
*/
resource "azurerm_kubernetes_cluster_node_pool" "infra" {
  name                  = var.utility_node_pool_name
  kubernetes_cluster_id = module.aks.aks_id
  vm_size               = var.utility_vm_size
  node_taints           = var.utility_node_taints
  enable_auto_scaling   = true
  lifecycle {
    ignore_changes = [node_count]
  }
  min_count      = var.utility_node_pool_min
  max_count      = var.utility_node_pool_max
  node_count     = var.utility_node_pool_default_count
  vnet_subnet_id = data.azurerm_subnet.infra.id
  tags           = var.tags

  depends_on = [module.aks]
}

# Look up ACR ID
data "azurerm_container_registry" "infra" {
  name                = "${var.prefix}acr"
  resource_group_name = local.rg_name
}

data "azuread_service_principal" "sp"{
  application_id = var.client_id
}

# Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#example-usage-attaching-a-container-registry-to-a-kubernetes-cluster
resource "azurerm_role_assignment" "infra" {
  #principal_id                     = module.aks.kubelet_identity[0].object_id
  principal_id                     = data.azuread_service_principal.sp.object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.infra.id
  skip_service_principal_aad_check = true
}
