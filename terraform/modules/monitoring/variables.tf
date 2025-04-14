variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}

variable "aks_cluster_id" {
  description = "ID of the AKS cluster to monitor"
  type        = string
} 