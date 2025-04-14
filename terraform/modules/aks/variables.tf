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
  default     = "1.26.3"
}

variable "subnet_id" {
  description = "The ID of the subnet where the AKS cluster will be deployed"
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for Linux nodes"
  type        = string
  default     = ""
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "tags" {
  description = "Additional tags for the AKS cluster"
  type        = map(string)
  default     = {}
} 