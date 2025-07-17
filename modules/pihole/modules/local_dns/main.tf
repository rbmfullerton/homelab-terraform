terraform {
  required_providers {
    pihole = {
      source  = "ryanwholey/pihole"
      version = "2.0.0-beta.1"
      configuration_aliases = [pihole.pihole1, pihole.pihole2, pihole.pihole3]
    }
  }
}

resource "pihole_dns_record" "myapp1" {
  provider = pihole.pihole1
  domain   = var.domain
  ip       = var.ip
}

resource "pihole_dns_record" "myapp2" {
  provider = pihole.pihole2
  domain   = var.domain
  ip       = var.ip
}

resource "pihole_dns_record" "myapp3" {
  provider = pihole.pihole3
  domain   = var.domain
  ip       = var.ip
}
