## Change the values to customize for your needs and 
## initialize additional variables as defined in variables.tf each folder core|appgw|aks

# variables that are used across core|appgw|aks 
subscription_id = "" #   
tenant_id       = "" #
client_id       = ""
client_secret   = ""
prefix          = "" # change this to customize and keep resource names unique in the subsricption
location        = "eastus"
tags = {
  "resourceowner" = "", # could be your name or email
  "project_name"  = "",
  "environment"   = "dev" # dev/staging/prod
}

## variables for 'core' (Azure Resource Group, VNet, Subnets)
core_source_address_prefixes = ["149.173.0.0/16", "106.120.85.32/28"]
create_container_registry    = true
core_acr_sku                 = "Basic"

## variables for 'appgw'(Azure Application Gateway)
appgw_source_address_prefixes = ["149.173.0.0/16", "106.120.85.32/28"]

## variables for 'aks' (Azure AKS cluster, node pool)
custom_application_gateway          = true # set to false to by-pass AppGateway for testing AKS/nodepool
aks_kubernetes_version              = 1.25
aks_api_server_authorized_ip_ranges = ["","",..] # If you want to restrict access to your AKS, you can specify the allowed source IP addresses here.
utility_node_pool_name              = "utility"
utility_vm_size                     = "Standard_D2s_v3"
utility_node_taints                 = ["utility=true:NoSchedule"]
utility_node_pool_min               = 1
utility_node_pool_max               = 1
utility_node_pool_default_count     = 1


