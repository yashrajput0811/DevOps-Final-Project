terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_redis_cache" "main" {
  name                = "cst8918-redis-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 1
  family              = "C"
  sku_name            = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"

  redis_configuration {
  }
}

resource "azurerm_container_registry" "main" {
  name                = "cst8918acr${substr(md5(var.resource_group_name), 0, 8)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "kubernetes_namespace" "weather" {
  metadata {
    name = "weather-app"
  }
}

resource "kubernetes_deployment" "weather" {
  metadata {
    name      = "weather-app"
    namespace = kubernetes_namespace.weather.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "weather-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "weather-app"
        }
      }

      spec {
        container {
          name  = "weather-app"
          image = "${azurerm_container_registry.main.login_server}/weather-app:latest"

          env {
            name  = "REDIS_HOST"
            value = azurerm_redis_cache.main.hostname
          }

          env {
            name  = "REDIS_PORT"
            value = "6380"
          }

          env {
            name  = "REDIS_PASSWORD"
            value = azurerm_redis_cache.main.primary_access_key
          }

          env {
            name  = "WEATHER_API_KEY"
            value = "62166fa8269680001c0a4e9818f5bae9"
          }
        }

        image_pull_secrets {
          name = kubernetes_secret.acr.metadata[0].name
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.acr
  ]
}

resource "kubernetes_service" "weather" {
  metadata {
    name      = "weather-app"
    namespace = kubernetes_namespace.weather.metadata[0].name
  }

  spec {
    selector = {
      app = "weather-app"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_secret" "acr" {
  metadata {
    name      = "acr-auth"
    namespace = kubernetes_namespace.weather.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${azurerm_container_registry.main.login_server}" = {
          username = azurerm_container_registry.main.admin_username
          password = azurerm_container_registry.main.admin_password
          auth     = base64encode("${azurerm_container_registry.main.admin_username}:${azurerm_container_registry.main.admin_password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
} 