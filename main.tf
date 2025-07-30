module "authentik" {
  source = "./modules/authentik"
  app_name_uptimekuma = var.uptimekuma
  app_name_pihole = var.pihole
  app_name_pihole2 = var.pihole2
  app_name_homarr = var.homarr
  # optionally, pass variables expected by your module here
}

module "uptime_kuma_2" {
  source = "./modules/UptimeKuma2"
  app_name = var.uptimekuma
  # optionally, pass variables expected by your module here
}

module "pihole" {
  source = "./modules/pihole"
  app_name_uptimekuma = var.uptimekuma
  app_name_pihole = var.pihole
  app_name_pihole2 = var.pihole2
  app_name_homarr = var.homarr
  providers = {
    pihole.pihole1 = pihole.pihole1
    pihole.pihole2 = pihole.pihole2
    pihole.pihole3 = pihole.pihole3
  }
  # optionally, pass variables expected by your module here
}

module "homarr" {
  source = "./modules/homarr"
  app_name = var.homarr
  envs = var.homarr_envs
}
