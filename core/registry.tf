/**
Create Azure Container Registry (ACR)
Reference:
    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry
**/
resource "azurerm_container_registry" "infra" {
  count               = var.create_container_registry ? 1 : 0
  location            = var.location
  name                = "${var.prefix}acr"
  resource_group_name = local.rg_name
  sku                 = var.core_acr_sku

  # TODO: For Prod env, udpate as needed 
  # Only applicable for Premium SKU 
  #   retention_policy {
  #     days                            = 7
  #     enabled                         = true
  #   }
}
