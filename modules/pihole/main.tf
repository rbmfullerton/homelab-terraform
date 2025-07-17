terraform {
  required_providers {
    pihole = {
      source  = "ryanwholey/pihole"
      version = "2.0.0-beta.1"
      configuration_aliases = [pihole.pihole1, pihole.pihole2, pihole.pihole3]
    }
  }
}

# Do modules here
module uptimekuma {
  source = "./modules/local_dns"
  domain = "${var.app_name_uptimekuma}.hozzlab.ca"
  ip = "192.168.0.122"
  providers = {
    pihole.pihole1 = pihole.pihole1
    pihole.pihole2 = pihole.pihole2
    pihole.pihole3 = pihole.pihole3
  }
}

module pihole {
  source = "./modules/local_dns"
  domain = "${var.app_name_pihole}.hozzlab.ca"
  ip = "192.168.0.122"
  providers = {
    pihole.pihole1 = pihole.pihole1
    pihole.pihole2 = pihole.pihole2
    pihole.pihole3 = pihole.pihole3
  }
}

module pihole2 {
  source = "./modules/local_dns"
  domain = "${var.app_name_pihole2}.hozzlab.ca"
  ip = "192.168.0.122"
  providers = {
    pihole.pihole1 = pihole.pihole1
    pihole.pihole2 = pihole.pihole2
    pihole.pihole3 = pihole.pihole3
  }
}
