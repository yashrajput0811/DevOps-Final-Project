data "azurerm_kubernetes_cluster" "main" {
  name                = "cst8918-aks-test"
  resource_group_name = "cst8918-final-project-group-1"
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.main.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
}

module "app" {
  source = "../../modules/app"

  resource_group_name = "cst8918-final-project-group-1"
  location           = "eastus"
  environment        = "test"
} 