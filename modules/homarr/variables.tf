variable "app_name" {
  description = "The name of the app/deployment"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for app"
  type        = string
  default     = "servarr-internal"
}

variable "storage_size" {
  description = "Storage required for persistent volume"
  type        = string
  default     = "1Gi"
}

variable "storage_class" {
  description = "StorageClass for PVC"
  type        = string
  default     = "longhorn"
}

variable "image" {
  description = "Image for container"
  type        = string
  default     = "ghcr.io/homarr-labs/homarr"
}

variable "image_version" {
  description = "Version of container image"
  type        = string
  default     = "v1.30.1"
}

variable "mount_path" {
  description = "Mount Path for container's data"
  type        = string
  default     = "/appdata"
}

variable "port" {
  description = "Port for WebUi"
  type        = string
  default     = "7575"
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
