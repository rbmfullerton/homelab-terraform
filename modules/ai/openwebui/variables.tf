variable "app_name" {
  description = "The name of the app/deployment"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for app"
  type        = string
  default     = "ai"
}

variable "storage_size" {
  description = "Storage required for persistent volume"
  type        = string
  default     = "4Gi"
}

variable "storage_class" {
  description = "StorageClass for PVC"
  type        = string
  default     = "longhorn"
}

variable "image" {
  description = "Image for container"
  type        = string
  default     = "ghcr.io/open-webui/open-webui"
}

variable "image_version" {
  description = "Version of container image"
  type        = string
  default     = "cuda"
}

variable "mount_path" {
  description = "Mount Path for container's data"
  type        = string
  default     = "/app/backend/data"
}

variable "port" {
  description = "Port for WebUi"
  type        = string
  default     = "8080"
}

variable "protocol" {
  description = "Protocol for WebUi"
  type        = string
  default     = "TCP"
}


# envs if required
variable "envs" {
  description = "List of environment variables for the container"
  sensitive   = true
  type        = list(object({
    name  = string
    value = string
  }))
  default     = []
}
