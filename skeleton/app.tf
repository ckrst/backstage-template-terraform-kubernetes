

resource "kubernetes_config_map" "app_config_map" {
  metadata {
    name = "${var.app_name}-config"
    namespace = "${kubernetes_namespace.app_namespace.metadata.0.name}"

  }

  data = {
    "app-config.yaml" = file("${path.module}/config/app-config.yaml")
    "postgres-host" = "${var.postgres_host}"
    "postgres-port" = "${var.postgres_port}"
    "postgres-user" = "${var.postgres_user}"
    "postgres-password" = "${var.postgres_password}"
  }

}

resource "kubernetes_deployment" "app_deployment" {
  lifecycle {
    ignore_changes = [
      spec[0].replicas,
      metadata[0].annotations["kubectl.kubernetes.io/last-applied-configuration"],
    ]

  }
  metadata {
    name = "${var.app_name}-app"
    namespace = "${kubernetes_namespace.app_namespace.metadata.0.name}"
    labels = {
      App = "${var.app_name}App"
    }
  }

  spec {
    replicas = 0

    selector {
      match_labels = {
        App = "${var.app_name}App"
      }
    }

    template {
      metadata {
        labels = {
          App = "${var.app_name}App"
        }
      }

      spec {
        container {
          image = var.app_image
          name  = "${var.app_name}-app"
          port {
            container_port = var.app_port
          }

          env {
            name = "POSTGRES_HOST"
            value = "${var.postgres_host}"
          }

          env {
            name = "POSTGRES_PORT"
            value = "${var.postgres_port}"
          }
          env {
            name = "POSTGRES_USERNAME"
            value = "${var.postgres_user}"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value = "${var.postgres_password}"
          }

          volume_mount {
            name = "config"
            mount_path = "/app/app-config.yaml"
            sub_path = "app-config.yaml"
  

          }

          command = [ "node", "packages/backend", "--config", "/app/app-config.yaml" ]


        }
        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.app_config_map.metadata[0].name
          }
        }

      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name = "${var.app_name}-app-service"
    namespace = "${kubernetes_namespace.app_namespace.metadata.0.name}"
  }
  spec {
    selector = {
      App = "${kubernetes_deployment.app_deployment.spec.0.template.0.metadata.0.labels.App}"
    }
    type = var.app_service_type
    port {
      port        = 80
      target_port = var.app_port
    }
  }
}
