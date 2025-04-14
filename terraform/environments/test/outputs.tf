output "acr_login_server" {
  description = "The login server of the ACR"
  value       = module.app.acr_login_server
}

output "acr_username" {
  description = "The username of the ACR"
  value       = module.app.acr_username
}

output "acr_password" {
  description = "The password of the ACR"
  value       = module.app.acr_password
  sensitive   = true
}

output "service_ip" {
  description = "The IP address of the weather service"
  value       = module.app.service_ip
} 