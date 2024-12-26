
output "infra_vnet_id" {
  value = module.vnet.vnet_id
}

output "infra_subnets" {
  value = module.vnet.vnet_subnets_name_id
}

output "infra_acr_login_server" {
  description = "The URL that can be used to log into the container registry"
  value       = var.create_container_registry ? element(coalescelist(azurerm_container_registry.infra.*.login_server, [" "]), 0) : null
}
