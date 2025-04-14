output "redis_host" {
  description = "Redis cache hostname"
  value       = azurerm_redis_cache.main.hostname
}

output "redis_port" {
  description = "Redis cache port"
  value       = "6380"
}

output "redis_password" {
  description = "Redis cache primary access key"
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}

output "acr_name" {
  description = "Azure Container Registry name"
  value       = azurerm_container_registry.main.name
}

output "acr_login_server" {
  description = "Azure Container Registry login server"
  value       = azurerm_container_registry.main.login_server
}

output "acr_username" {
  description = "Azure Container Registry username"
  value       = azurerm_container_registry.main.admin_username
}

output "acr_password" {
  description = "Azure Container Registry password"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "service_ip" {
  description = "LoadBalancer IP address"
  value       = kubernetes_service.weather.status[0].load_balancer[0].ingress[0].ip
} 