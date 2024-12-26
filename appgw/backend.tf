terraform {
  backend "azurerm" {
    container_name       = "${var.prefix}-tfstate"
    key                  = "appgwy-terraform.tfstate"
    storage_account_name = "terraformststore"
    resource_group_name  = "terraform-st-rg"
  }
}
