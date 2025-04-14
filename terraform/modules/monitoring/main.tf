resource "azurerm_log_analytics_workspace" "main" {
  name                = "cst8918-${var.environment}-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment
  }
}

resource "azurerm_monitor_action_group" "main" {
  name                = "cst8918-${var.environment}-action-group"
  resource_group_name = var.resource_group_name
  short_name          = "cst8918ag"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }
}

resource "azurerm_monitor_metric_alert" "cpu" {
  name                = "cst8918-${var.environment}-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes             = [var.aks_cluster_id]
  description        = "Alert when CPU usage exceeds threshold"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
} 