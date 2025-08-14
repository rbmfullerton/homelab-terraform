resource "kubernetes_persistent_volume" "sd_local_pv" {
  metadata {
    name = "sd-local-pv"
  }
  spec {
    capacity = {
      storage = "15Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "local-storage"
    persistent_volume_source {
      host_path {
        path = "/mnt/stable-diffusion-data"
        type = "DirectoryOrCreate"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key = "kubernetes.io/hostname"
            operator = "In"
            values = ["k3s-worker-01"]
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "sd_pvc" {
  metadata {
    name = "sd-pvc"
    namespace = "ai"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "15Gi"
      }
    }
    storage_class_name = "local-storage"
    volume_name = "sd-local-pv"
  }
}

resource "kubernetes_deployment" "stable_diffusion_webui" {
  metadata {
    name = "stable-diffusion-webui"
    namespace = "ai"
  }
  spec {
    replicas = 0
    selector {
      match_labels = {
        app = "stable-diffusion-webui"
      }
    }
    template {
      metadata {
        labels = {
          app = "stable-diffusion-webui"
        }
      }
      spec {
        runtime_class_name = "nvidia"
        node_selector = {
          gpu = "true"
        }
        container {
          name = "stable-diffusion-webui"
          image = "ghcr.io/neggles/sd-webui-docker:latest"
          port {
            container_port = 7860
          }
          resources {
            limits = {
              "nvidia.com/gpu" = 1
            }
          }
          volume_mount {
            name = "sd-data"
            mount_path = "/data"
          }
          env {
            name = "CLI_ARGS"
            value = "--api"
          }
          env {
            name = "SD_WEBUI_VARIANT"
            value = "latest"
          }
        }
        volume {
          name = "sd-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.sd_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "stable_diffusion_webui" {
  metadata {
    name = "stable-diffusion-webui"
    namespace = "ai"
  }
  spec {
    selector = {
      app = "stable-diffusion-webui"
    }
    port {
      port = 7860
      target_port = 7860
    }
    type = "ClusterIP"
  }
}
