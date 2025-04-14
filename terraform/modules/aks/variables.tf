variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "The location where the AKS cluster will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "node_count" {
  description = "The initial number of nodes in the AKS cluster"
  type        = number
  default     = 1
}

variable "environment" {
  description = "The environment (e.g., dev, test, prod)"
  type        = string
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry"
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use"
  type        = string
  default     = "1.25.6"
}

variable "subnet_id" {
  description = "The ID of the subnet where the AKS cluster will be deployed"
  type        = string
}

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for API server access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Default to all IPs, should be restricted in production
} 