terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "cst8918-tfstate-rg"
    storage_account_name = "cst8918tfstated366c9f0"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source = "../../modules/network"

  resource_group_name = "cst8918-final-project-group-1"
  location           = "eastus"
}

module "aks" {
  source = "../../modules/aks"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  cluster_name       = "cst8918-aks-test"
  kubernetes_version = "1.26.3"
  node_count        = 1
  subnet_id         = module.network.subnet_id

  depends_on = [module.network]
} 