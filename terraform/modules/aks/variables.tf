variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "acr_id" {
  description = "ID of the Azure Container Registry"
  type        = string
  default     = null
} 