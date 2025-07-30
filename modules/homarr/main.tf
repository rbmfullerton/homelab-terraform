# PersistentVolumeClaim
resource "kubernetes_manifest" "persistentvolumeclaim" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolumeClaim"
    metadata = {
      annotations = {
        "longhorn.io/volume-name" = "${var.app_name}-data"
      }
      name      = "${var.app_name}-claim"
      namespace = var.namespace
    }
    spec = {
      accessModes = [
        "ReadWriteOnce"
      ]
      resources = {
        requests = {
          storage = var.storage_size
        }
      }
      storageClassName = var.storage_class
    }
  }
}

# Deployment
resource "kubernetes_manifest" "deployment" {
  depends_on = [kubernetes_manifest.persistentvolumeclaim]
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      labels = {
        app = var.app_name
      }
      name      = var.app_name
      namespace = var.namespace
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = var.app_name
        }
      }
      template = {
        metadata = {
          labels = {
            app = var.app_name
          }
        }
        spec = {
          containers = [
            {
              image           = "${var.image}:${var.image_version}"
              imagePullPolicy = "IfNotPresent"
              name            = var.app_name
              ports = [
                {
                  containerPort = var.port
                  name          = "ui"
                  protocol      =  var.protocol
                }
              ]
              securityContext = {
                capabilities = {
                  add = ["NET_ADMIN"]
                }
              }
              volumeMounts = [
                {
                  mountPath = var.mount_path
                  name      = "${var.app_name}-data"
                }
              ]
              env = var.envs
            }
          ]
          nodeSelector = {
            worker = "true"
          }
          volumes = [
            {
              name = "${var.app_name}-data"
              persistentVolumeClaim = {
                claimName = "${var.app_name}-claim"
              }
            }
          ]
        }
      }
    }
  }
}

# Service
resource "kubernetes_manifest" "service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      labels = {
        app = var.app_name
      }
      name      = var.app_name
      namespace = var.namespace
    }
    spec = {
      ports = [
        {
          name       = "ui"
          port       = var.port
          protocol   = var.protocol
          targetPort = var.port
        }
      ]
      selector = {
        app = var.app_name
      }
      type = "ClusterIP"
    }
  }
}
