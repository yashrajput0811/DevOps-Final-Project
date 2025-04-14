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

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  cluster_name       = "cst8918-aks-prod"
  kubernetes_version = "1.26.3"  # Updated to supported version
  node_count        = 2  # Production uses 2 nodes for high availability
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