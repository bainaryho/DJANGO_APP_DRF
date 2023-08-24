terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  access_key  = var.access_key
  secret_key  = var.secret_key
  region      = "KR"
  site        = "PUBLIC"
  support_vpc = true
}

locals{
  env = "staging"
}

module "vpc" {
  source = "../modules/network"

  env = local.env
  access_key = var.access_key
  secret_key = var.secret_key
}

module "servers"{
    source = "../modules/server"

    db = "postgres"
    db_user = var.db_user
    db_password = var.db_password
    django_secret = var.django_secret
    django_settings_module = "lion.app.settings.staging"
    access_key = var.access_key
    secret_key = var.secret_key
    username = var.username
    password = var.password
    env = local.env
    vpc_id = module.vpc.vpc_id

}

module "load_balancer"{
  source = "../modules/loadBalancer"

  env = local.env
  access_key = var.access_key
  secret_key = var.secret_key
  vpc_id = module.vpc.vpc_id
  be_instance_no = module.servers.be_instance_no
}