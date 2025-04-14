variable "weather_api_key" {
  description = "OpenWeatherMap API key"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment (test, prod)"
  type        = string
  default     = "prod"
} 