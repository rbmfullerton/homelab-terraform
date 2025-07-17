variable "app_name" {
  type = string
  description = "Human friendly application name."
}

variable "app_slug" {
  type = string
  description = "Machine friendly application name."
}

variable "app_external_host" {
  type = string
  description = "External URL for the application."
}

variable "app_group" {
  default = "HomeLab"
  description = "Group to assign the application to. {Optional}"
}

variable "require_homelab_ent_policy_id" {}

# variable "allow_trusted_ip_policy_id" {}
