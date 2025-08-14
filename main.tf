module "authentik" {
  source = "./modules/authentik"
  app_name_uptimekuma = var.uptimekuma
  app_name_pihole = var.pihole
  app_name_pihole2 = var.pihole2
  app_name_homarr = var.homarr
  app_name_openwebui = var.openwebui
  # optionally, pass variables expected by your module here
}

module "uptimekuma" {
  source = "./modules/uptimekuma"
  app_name = var.uptimekuma
  # optionally, pass variables expected by your module here
}

module "pihole" {
  source = "./modules/pihole"
  app_name_uptimekuma = var.uptimekuma
  app_name_pihole = var.pihole
  app_name_pihole2 = var.pihole2
  app_name_homarr = var.homarr
  app_name_openwebui = var.openwebui
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

module "ai" {
  source = "./modules/ai"
}

module "ollama" {
  source = "./modules/ai/ollama"
}

module "automatic1111" {
  source = "./modules/ai/automatic1111"
}

module "openwebui" {
  source = "./modules/ai/openwebui"
  app_name = var.openwebui
  envs = var.openwebui_envs
}
