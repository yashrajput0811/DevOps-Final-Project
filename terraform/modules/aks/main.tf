terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.cluster_name}-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix         = var.cluster_name
  kubernetes_version = var.kubernetes_version

  api_server_authorized_ip_ranges = var.authorized_ip_ranges

  default_node_pool {
    name                = "default"
    node_count         = var.node_count
    vm_size            = "Standard_D2_v2"
    os_disk_size_gb    = 30
    enable_auto_scaling = true
    min_count          = 1
    max_count          = 3
    vnet_subnet_id     = var.subnet_id
    
    tags = {
      Environment = var.environment
    }
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true
  azure_policy_enabled = true

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [0, 1, 2]
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups = true
    max_graceful_termination_sec = 600
    scale_down_delay_after_add = "10m"
    scale_down_unneeded = "10m"
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Yash"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
} 