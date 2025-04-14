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
    container_name      = "tfstate"
    key                 = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "cst8918-final-project-group-1"
  location = "eastus"
  
  tags = {
    environment = var.environment
  }
}

module "network" {
  source = "../../modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
}

module "aks" {
  source = "../../modules/aks"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  cluster_name       = "cst8918-aks-prod"
  kubernetes_version = "1.26.3"
  node_count        = 2
  subnet_id         = module.network.subnet_id

  depends_on = [module.network]
}

module "monitoring" {
  source = "../../modules/monitoring"

  resource_group_name = module.network.resource_group_name
  location           = "eastus"
  environment        = "prod"
}

module "redis" {
  source = "../../modules/redis"

  resource_group_name = module.network.resource_group_name
  location           = "eastus"
  environment        = "prod"
  
  # Production-specific Redis settings
  capacity            = 2
  family              = "P"
  sku_name            = "Premium"
  enable_non_ssl_port = false
}

module "app" {
  source = "../../modules/app"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  aks_cluster_name   = module.aks.cluster_name

  depends_on = [module.aks]
} 