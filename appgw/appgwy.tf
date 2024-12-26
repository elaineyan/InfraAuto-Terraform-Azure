
/**
Create Azure Application Gateway
Reference:
  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
  https://github.com/Azure/terraform/tree/master/quickstart/101-application-gateway
  https://github.com/Azure/terraform/tree/master/quickstart/201-k8s-cluster-with-aks-applicationgateway-ingress

  https://learn.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress
  https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-expose-service-over-http-https
**/
resource "azurerm_application_gateway" "infra" {
  name                = "${var.prefix}-appgw"
  resource_group_name = local.rg_name
  location            = local.location

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.appgw_sku_capacity
  }

  gateway_ip_configuration {
    name      = var.appgw_gateway_ip_config_name
    subnet_id = lookup(module.appgw_vnet.vnet_subnets_name_id, "${var.prefix}-appgw-fe-snet")
  }

  frontend_port {
    name = local.frontend_port_name
    port = var.appgw_frontend_port_number
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = var.appgw_be_http_setting_cookie
    port                  = var.appgw_http_setting_port_number
    protocol              = var.appgw_http_setting_protocol
    request_timeout       = var.appgw_be_http_setting_req_timeout
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = var.appgw_http_setting_protocol
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = var.appgw_request_routing_rule_type
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

  depends_on = [module.appgw_fe_nsg, module.appgw_be_nsg]
}
