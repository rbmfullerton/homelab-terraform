#PVC
resource "kubernetes_persistent_volume_claim" "pvclaim" {
  metadata {
    name      = "${var.app_name}-claim"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}

# Deployment
resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }
      spec {
        node_selector = {
          worker = "true"
        }
        container {
          image           = "${var.image}:${var.image_version}"
          image_pull_policy = "IfNotPresent"
          name            = var.app_name
          port {
            container_port  = var.port
            name              = "ui"
            protocol          = var.protocol
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
          volume_mount {
              mount_path = var.mount_path
              name       = "${var.app_name}-data"
          }
#          dynamic "env" {
#            for_each = var.envs
#            content {
#              name  = env.value.name
#              value = env.value.value
#            }
#          }
        }
        volume {
          name = "${var.app_name}-data"
          persistent_volume_claim {
            claim_name = "${var.app_name}-claim"
          }
        }
      }
    }
  }
}

# Service
resource "kubernetes_service" "service" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }
  spec {
    port {
      name       = "ui"
      port       = var.port
      protocol   = var.protocol
      target_port = var.port
    }
    selector = {
      app = var.app_name
    }
    type = "ClusterIP"
  }
}