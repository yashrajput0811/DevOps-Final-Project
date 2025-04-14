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

  cluster_name         = "cst8918-aks-test"
  resource_group_name  = module.network.resource_group_name
  location            = "eastus"
  node_count          = 1
  environment         = "test"
  subnet_id           = module.network.subnet_id
} 