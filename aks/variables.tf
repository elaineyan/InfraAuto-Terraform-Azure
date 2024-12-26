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
  default     = "dev"
}

variable "aks_subnet_name" {
  type        = string
  description = "Subnet ID for AKS"
  default     = "aks" # change this to match the name used to create in 'core'
}

variable "tags" {
  description = "Map of common tags to be placed on the Resources"
  type        = map(any)
  default     = {}
}

variable "custom_application_gateway" {
  type        = bool
  description = "Flag to create Azure Application Gateway"
  default     = false
}

variable "aks_kubernetes_version" {
  type        = string
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  default     = "1.25"
}

variable "aks_agents_availability_zones" {
  type        = list(string)
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  default     = null
}

variable "aks_net_profile_dns_service_ip" {
  type        = string
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  default     = null
}

variable "aks_net_profile_docker_bridge_cidr" {
  type        = string
  description = "(Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  default     = null
}

variable "aks_net_profile_outbound_type" {
  type        = string
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer."
  default     = "loadBalancer"
}

variable "aks_net_profile_pod_cidr" {
  type        = string
  description = " (Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created."
  default     = null
}

variable "aks_net_profile_service_cidr" {
  type        = string
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  default     = null
}

variable "aks_network_plugin" {
  type        = string
  description = "Network plugin to use for networking."
  default     = "kubenet"
  #default     = "azure"
  nullable    = false
}

variable "aks_network_policy" {
  type        = string
  description = " (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  default     = null
}

variable "aks_agents_count" {
  type        = number
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
  default     = 1
}

variable "aks_agents_labels" {
  type        = map(string)
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created."
  default     = {}
}

variable "aks_agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool"
  default     = null
}

variable "aks_agents_max_pods" {
  type        = number
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  default     = null
}

variable "aks_agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
  default     = null
}

variable "aks_agents_pool_name" {
  type        = string
  description = "The default Azure AKS agentpool (nodepool) name."
  default     = "automation"
  nullable    = false
}

variable "aks_agents_size" {
  type        = string
  description = "The default virtual machine size for the Kubernetes agents"
  default     = "Standard_D2s_v3"
}

variable "aks_agents_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the Node Pool."
  default     = {}
}

variable "aks_agents_taints" {
  type        = list(string)
  description = "(Optional) A list of the taints added to new nodes during node pool create and scale. Changing this forces a new resource to be created."
  default     = null
}

variable "aks_api_server_authorized_ip_ranges" {
  type        = set(string)
  description = "(Optional) The IP ranges to allow for incoming traffic to the server nodes."
  default     = ["149.173.0.0/16"]
}

variable "aks_attached_acr_id_map" {
  type        = map(string)
  description = "Azure Container Registry ids that need an authentication mechanism with Azure Kubernetes Service (AKS). Map key must be static string as acr's name, the value is acr's resource id. Changing this forces some new resources to be created."
  default     = {}
  nullable    = false
}

variable "aks_sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`"
  default     = "Free"
}

variable "utility_node_pool_name" {
  type        = string
  description = "The name of the Node Pool which should be created within the Kubernetes Cluster. Changing this forces a new resource to be created"
  default     = "utility"
}

variable "utility_vm_size" {
  description = "Utility Node Pool VM Size"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "utility_node_taints" {
  description = "A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g [\"key=value:NoSchedule\"]). Changing this forces a new resource to be created."
  type        = list(string)
  default     = []
}

variable "utility_node_pool_min" {
  description = "Utility Node Pool Min Node Count for Utility Scale Set"
  type        = number
  default     = 1
}

variable "utility_node_pool_max" {
  description = "Utility Node Pool Max Node Count for Utility Scale Set"
  type        = number
  default     = 1
}

variable "utility_node_pool_default_count" {
  description = "Utility Node Pool Default Node Count for Utility Scale Set"
  type        = number
  default     = 1
}

variable "aks_rbac_aad" {
  description = "(Optional) Is Azure Active Directory integration enabled?"
  type        = bool
  default     = true
}
variable "aks_rbac_aad_managed" {
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  type        = bool
  default     = true
}
variable "aks_role_based_access_control_enabled" {
  type        = bool
  default     = true
  description = "Enable Role Based Access Control."
}

variable "aks_rbac_aad_admin_group_object_ids" {
  description = "Object ID of groups with admin access"
  type        = list(string)
  default     = []
}
