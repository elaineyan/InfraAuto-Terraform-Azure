# InfraAuto-Terraform-Azure
This repo contains Terraform configurations for provisioning Azure infrastructure resources, including an Azure Kubernetes cluster, networking, security, and more, along with related configurations.
    
You will need [Terraform CLI installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to run. Use the included consolidated `terraform.tfvars` file to customize values for any variables in `variales.tf` under each sub-directory. Once these requirements have been met, then run these commands:

## Azure Login

```bash
az login --allow-no-subscriptions
```
See additional info on [logging into Azure CLI](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/azure_cli#logging-into-the-azure-cli)

## Run Terraform commands
```bash
# setup TF_WORK_DIR to one of these directories and run terraform commands below
# 1. core - to create core Azure resources - Resource Group, Virtual Network and optionally, Container Registry
# 2. appgw - optionally create Application Gateway, after 'core' run is successful
# 3. aks - to create AKS cluster and utility nodepool, after 'core' run is successful

export TF_WORK_DIR=<enter Terraform work directory e.g., [core|appgw|aks] >

export PREFIX=[dev|staging|prod|others]

# to initialize Terraform environment
# creates .terraform directory in $TF_WORK_DIR and intializes provider modules and plugins
terraform -chdir=${TF_WORK_DIR} init

# to show the resources that will be created with 'apply' 
terraform -chdir=${TF_WORK_DIR} plan -var-file=$(PWD)/terraform.tfvars -var="prefix=${PREFIX}"

# to create resources
terraform -chdir=${TF_WORK_DIR} apply -auto-approve -var-file=$(PWD)/terraform.tfvars -var="prefix=${PREFIX}"
# this command can take few minutes to complete

# to list Terraform outputs
terraform -chdir=${TF_WORK_DIR} output

# to get kubeconfig output and write to local ~/.kube/config to run kubectl commands
# NOTE: TF_WORK_DIR must be set to 'aks' in this case
terraform -chdir=${TF_WORK_DIR} output -raw infra_aks_kubeconfig > ~/.kube/config

# To destroy resources deployed with terraform apply
terraform -chdir=${TF_WORK_DIR} destroy -auto-approve -var-file=$(PWD)/terraform.tfvars -var="prefix=${PREFIX}"

```
