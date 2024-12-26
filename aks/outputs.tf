output "infra_aks_kubeconfig" {
  sensitive = true
  value     = module.aks.kube_config_raw
}

output "infra_aks_fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  value       = module.aks.cluster_fqdn
}
