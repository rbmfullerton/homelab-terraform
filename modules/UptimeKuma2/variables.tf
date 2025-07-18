﻿variable "app_name" {
  description = "The name of the app/deployment"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for app"
  type        = string
  default     = "uptimekuma"
}

variable "storage_size" {
  description = "Storage required for persistent volume"
  type        = string
  default     = "5Gi"
}

variable "storage_class" {
  description = "StorageClass for PVC"
  type        = string
  default     = "longhorn"
}

variable "image" {
  description = "Image for container"
  type        = string
  default     = "louislam/uptime-kuma"
}

variable "image_version" {
  description = "Version of container image"
  type        = string
  default     = "1.23.16"
}

variable "mount_path" {
  description = "Mount Path for container's data"
  type        = string
  default     = "/app/data"
}

variable "port" {
  description = "Port for WebUi"
  type        = string
  default     = "3001"
}

variable "protocol" {
  description = "Protocol for WebUi"
  type        = string
  default     = "TCP"
}
