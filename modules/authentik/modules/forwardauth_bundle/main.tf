terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.6.0" # or latest
    }
  }
}

# Create a proxy provider
data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "default_invalidation_flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_group" "homelab" {
  name = "HomeLab"
}

resource "authentik_provider_proxy" "name" {
  name               =  var.app_slug
  mode               = "forward_single"
  external_host      = var.app_external_host
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow = data.authentik_flow.default_invalidation_flow.id
  access_token_validity = var.token_validity
}

resource "authentik_application" "name" {
  name              = var.app_name
  slug              = var.app_slug
  protocol_provider = authentik_provider_proxy.name.id
  group             = var.app_group
}

resource "authentik_application_entitlement" "homelab_ent" {
  application = authentik_application.name.uuid
  name       = "homelab-access"
}

resource "authentik_policy_binding" "restrict_app_to_ent" {
  target = authentik_application.name.uuid
  policy = var.require_homelab_ent_policy_id
  order  = 1
}

resource "authentik_policy_binding" "homelab_ent_group_binding" {
  target = authentik_application_entitlement.homelab_ent.id
  group  = data.authentik_group.homelab.id
  order  = 0
}

# Outputs
output "proxy_id" {
  value = authentik_provider_proxy.name.id
}

output "application_id" {
  value = authentik_application.name.id
}

output "policy_group_id" {
  value = authentik_policy_binding.restrict_app_to_ent.id
}