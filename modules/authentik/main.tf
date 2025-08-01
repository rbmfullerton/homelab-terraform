﻿terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.6.0" # or latest
    }
  }
}

# Shared config

# Declare policy expressions
resource "authentik_policy_expression" "require_homelab_ent" {
  name       = "require-homelab-entitlement"
  expression = <<EOT
return ak_is_group_member(request.user, name="HomeLab")
EOT
}

#resource "authentik_policy_expression" "allow_trusted_ip" {
#  name       = "allow-trusted-ip"
#  expression = <<EOT
#return ak_client_ip in ip_network('192.168.0.110/32')
#EOT
#}

output "all_proxies" {
  value = [
    module.uptimekuma.proxy_id,
    module.pihole.proxy_id,
    module.pihole2.proxy_id
  ]
}

resource "authentik_outpost" "outpost" {
  name               = "Apps"
  protocol_providers = [
    module.uptimekuma.proxy_id,
    module.homarr.proxy_id,
    module.pihole.proxy_id,
    module.pihole2.proxy_id
  ]
  service_connection = authentik_service_connection_kubernetes.local.id
}

resource "authentik_service_connection_kubernetes" "local" {
  name  = "local-k3s"
  local = true
}

# Do modules here. Don’t forget to add them to the outpost.
module uptimekuma {
  source = "./modules/forwardauth_bundle"
  app_name = var.app_name_uptimekuma
  app_slug = var.app_name_uptimekuma
  app_external_host = "https://${var.app_name_uptimekuma}.hozzlab.ca"
  require_homelab_ent_policy_id = authentik_policy_expression.require_homelab_ent.id
#  allow_trusted_ip_policy_id    = authentik_policy_expression.allow_trusted_ip.id
}

module homarr {
  source = "./modules/forwardauth_bundle"
  app_name = var.app_name_homarr
  app_slug = var.app_name_homarr
  app_external_host = "https://${var.app_name_homarr}.hozzlab.ca"
  require_homelab_ent_policy_id = authentik_policy_expression.require_homelab_ent.id
#  allow_trusted_ip_policy_id    = authentik_policy_expression.allow_trusted_ip.id
}


module pihole {
  source = "./modules/forwardauth_bundle"
  app_name = var.app_name_pihole
  app_slug = var.app_name_pihole
  app_external_host = "https://${var.app_name_pihole}.hozzlab.ca"
  require_homelab_ent_policy_id = authentik_policy_expression.require_homelab_ent.id
#  allow_trusted_ip_policy_id    = authentik_policy_expression.allow_trusted_ip.id
}

module pihole2 {
  source = "./modules/forwardauth_bundle"
  app_name = var.app_name_pihole2
  app_slug = var.app_name_pihole2
  app_external_host = "https://${var.app_name_pihole2}.hozzlab.ca"
  require_homelab_ent_policy_id = authentik_policy_expression.require_homelab_ent.id
#  allow_trusted_ip_policy_id    = authentik_policy_expression.allow_trusted_ip.id
}
