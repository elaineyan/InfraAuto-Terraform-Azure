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

variable "location" {
  description = "The Azure Region to provision all resources in this script"
  default     = "eastus"
}

variable "tags" {
  description = "Map of common tags to be placed on the Resources"
  type        = map(any)
  default     = {}
}

variable "create_container_registry" {
  type        = bool
  description = "Flag to create Azure Container Registry"
  default     = false
}

/**
 </------------------ NSG variables ---------------------
**/
variable "core_aks_custom_rules" {
  description = "Security rules for the network security group using this format name = [name, priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = any
  default     = []
}

variable "core_aks_predefined_rules" {
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

variable "core_db_custom_rules" {
  description = "Security rules for the network security group using this format name = [name, priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = any
  default     = []
}

variable "core_db_predefined_rules" {
  description = "Predefined rules"
  type        = any
  default = [
    {
      name     = "PostgreSQL"
      priority = 601
    },
  ]
}
variable "core_source_address_prefixes" {
  description = "Destination address prefix to be applied to all predefined rules. Example [\"10.0.3.0/32\",\"10.0.3.128/32\"]"
  type        = list(string)
  default     = ["149.173.0.0/16"] #TODO: add more network CIDRs if needs
}

/**
 ------------------ NSG variables ---------------------/>
**/
variable "core_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.52.0.0/16"]
}

variable "core_subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["aks", "db"]
}

variable "core_subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.52.0.0/24", "10.52.1.0/24"]
}

variable "core_subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
  default = {
    db = ["Microsoft.Sql"]
  }
}

variable "core_acr_sku" {
  type        = string
  description = "(Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium"
  default     = "Basic"
}
