terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-group-1"
    storage_account_name = "cst8918tfstateprod"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks.cluster_name
  resource_group_name = module.network.resource_group_name
  depends_on          = [module.aks]
}

module "network" {
  source = "../../modules/network"

  resource_group_name = "cst8918-final-project-group-1"
  location           = "eastus"
  
  # Production-specific network settings
  network_security_rules = [
    {
      name                       = "allow-https"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "deny-all"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

module "aks" {
  source = "../../modules/aks"

  cluster_name        = "cst8918-aks-prod"
  resource_group_name = module.network.resource_group_name
  location           = "eastus"
  environment        = "prod"
  
  # Production-specific AKS settings
  node_count         = 3
  node_size          = "Standard_D4s_v3"
  enable_auto_scaling = true
  min_count          = 3
  max_count          = 10
  
  # Enable monitoring and logging
  enable_log_analytics = true
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
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

  resource_group_name = module.network.resource_group_name
  location           = "eastus"
  environment        = "prod"
  
  # Production-specific app settings
  replica_count      = 3
  cpu_limit          = "1"
  memory_limit       = "1Gi"
  cpu_request        = "500m"
  memory_request     = "512Mi"
  
  # Enable production features
  enable_https       = true
  enable_monitoring  = true
  
  depends_on = [
    module.aks,
    module.redis,
    module.monitoring
  ]
} 