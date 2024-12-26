variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {
  default     = ""
  description = "(Optional) The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable"
}

variable "client_secret" {
  default     = ""
  description = "(Optional) The Client Secret which should be used. This can also be sourced from the ARM_CLIENT_SECRET Environment Variable"
}

variable "prefix" {
  type        = string
  description = "(Required) The prefix for the resources created in the specified Azure Resource Group"
  default     = "infra"
}

variable "tags" {
  description = "Map of common tags to be placed on the Resources"
  type        = map(any)
  default     = {}
}

variable "appgw_vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.23.0.0/18"]
}

variable "appgw_vnet_subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.23.0.0/24", "10.23.1.0/24"]
}

variable "appgw_source_address_prefixes" {
  description = "Destination address prefix to be applied to all predefined rules. Example [\"10.0.3.0/32\",\"10.0.3.128/32\"]"
  type        = list(string)
  default     = ["149.173.0.0/16"] #TODO: add other network CIDRs if needs.
}

variable "appgw_fe_nsg_predefined_rules" {
  description = "Predefined rules"
  type        = any
  default = [
    {
      name     = "HTTP"
      priority = 501
    },
    {
      name     = "HTTPS"
      priority = 502
    },
  ]
}

variable "appgw_be_nsg_predefined_rules" {
  description = "Predefined rules"
  type        = any
  default = [
    {
      name     = "HTTP"
      priority = 501
    },
    {
      name     = "HTTPS"
      priority = 502
    },
  ]
}

variable "appgw_fe_nsg_custom_rules" {
  description = "Custom NSG rules"
  type        = any
  default = [
    {
      name                       = "AppGwy"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "65200-65535"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  ]
}

variable "appgw_be_nsg_custom_rules" {
  description = "Custom NSG rules"
  type        = any
  default = [
    {
      name                       = "AppGwy"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "65200-65535"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  ]
}

variable "appgw_pip_allocation_method" {
  type        = string
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  default     = "Static"
}

variable "appgw_pip_sku" {
  type        = string
  description = "The SKU of the Public IP. Accepted values are Basic and Standard"
  default     = "Standard"
}

variable "appgw_sku_name" {
  type        = string
  description = "(Required) The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2"
  default     = "Standard_v2"
}

variable "appgw_sku_tier" {
  type        = string
  description = "(Required) The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2"
  default     = "Standard_v2"
}

variable "appgw_sku_capacity" {
  type        = number
  description = "(Optional) The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set."
  default     = 2
}

variable "appgw_frontend_port_number" {
  type        = number
  description = "(Required) The port used for this Frontend Port"
  default     = 80
}

variable "appgw_gateway_ip_config_name" {
  default     = "gateway-ip-configuration"
  type        = string
  description = "The Name of this Gateway IP Configuration"
}

variable "appgw_be_http_setting_cookie" {
  type        = string
  description = "Is Cookie-Based Affinity enabled? Possible values are Enabled and Disabled"
  default     = "Disabled"
}

variable "appgw_http_setting_port_number" {
  type        = number
  description = "(Required) The port used for this Frontend Port"
  default     = 80
}

variable "appgw_http_setting_protocol" {
  type        = string
  description = "The Protocol which should be used. Possible values are Http and Https"
  default     = "Http"
}

variable "appgw_be_http_setting_req_timeout" {
  type        = number
  description = "The request timeout in seconds, which must be between 1 and 86400 seconds. Defaults to 30"
  default     = 60
}

variable "appgw_request_routing_rule_type" {
  type        = string
  description = "The Type of Routing that should be used for this Rule. Possible values are Basic and PathBasedRouting"
  default     = "Basic"
}
