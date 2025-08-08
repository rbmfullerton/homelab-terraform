variable "authentik_host" {
  description = "Authentik host"
  type        = string
  sensitive   = true
}

variable "authentik_token" {
  description = "Authentik token"
  type        = string
  sensitive   = true
}

variable "rancher_api_token" {
  description = "Rancher API Token"
  type        = string
  sensitive   = true
}

variable "pihole1_api_token" {
  description = "pihole1 token"
  type        = string
  sensitive   = true
}

variable "pihole2_api_token" {
  description = "pihole2 token"
  type        = string
  sensitive   = true
}

variable "pihole3_api_token" {
  description = "Pihole3 token"
  type        = string
  sensitive   = true
}

variable "uptimekuma" {
  description = "App name"
  type        = string
  default     = "uptimekuma"
}

variable "pihole" {
  description = "App name"
  type        = string
  default     = "pihole"
}

variable "pihole2" {
  description = "App name"
  type        = string
  default     = "pihole2"
}

variable "homarr" {
  description = "App name"
  type        = string
  default     = "homarr"
}

variable "homarr_envs" {
  description = "Environment variables for Homarr container"
  sensitive   = true
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "openwebui" {
  description = "App name"
  type        = string
  default     = "openwebui"
}

variable "openwebui_envs" {
  description = "Environment variables for container"
  sensitive   = true
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
