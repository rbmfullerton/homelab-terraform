terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.6.0" # or latest
    }
    pihole = {
      source  = "ryanwholey/pihole"
      version = "2.0.0-beta.1"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "authentik" {
  url     = var.authentik_host
  token    = var.authentik_token
  insecure = false
}

provider "pihole" {
  alias     = "pihole1"
  url       = "https://pihole-api.hozzlab.ca"
  password = var.pihole1_api_token
}

provider "pihole" {
  alias     = "pihole2"
  url       = "https://pihole2-api.hozzlab.ca"
  password = var.pihole2_api_token
}

provider "pihole" {
  alias     = "pihole3"
  url       = "http://192.168.0.45:20720"
  password = var.pihole3_api_token
}
