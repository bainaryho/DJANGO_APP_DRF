terraform {
  backend "local"{
    path = "/Users/rkswl/workspace/terraform_study/states/staging.tfstate"
  }
  
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
    access_key = var.access_key
    secret_key = var.secret_key
    username = var.username
    password = var.password
    env = local.env
    vpc_id = module.vpc.vpc_id
    servername = var.servername
    init_script_envs = {
     db = "postgres"
     db_user = var.db_user
     db_password = var.db_password
     db_port = "5432"
     db_host = ""
     django_secret = var.django_secret
     django_settings_module = "lion_app.settings.staging"
    }
    init_script_name = "be_init_script.tftpl"
    subnet_id = ""
    server_product_code = ""
    name = "be"
    acg_port_range = "5432"

}
# module "db_server"{
#     source = "../modules/server"

#     db = "postgres"
#     db_user = var.db_user
#     db_password = var.db_password
#     django_secret = var.django_secret
#     django_settings_module = "lion_app.settings.staging"
#     access_key = var.access_key
#     secret_key = var.secret_key
#     username = var.username
#     password = var.password
#     env = local.env
#     vpc_id = module.vpc.vpc_id
#     servername = var.servername

# }

module "load_balancer"{
  source = "../modules/loadBalancer"

  env = local.env
  access_key = var.access_key
  secret_key = var.secret_key
  vpc_id = module.vpc.vpc_id
  be_instance_no = module.servers.be_instance_no
}

resource "ncloud_public_ip" "be" {
   //공용 IP 주소를 할당하고, 이 주소를 be서버 인스턴스와 연결하고 있습니다.
    server_instance_no = ncloud_server.be.instance_no
}

resource "ncloud_public_ip" "db" {
  #공용 IP 주소를 할당하고, 이 주소를 db서버 인스턴스와 연결하고 있습니다.
    server_instance_no = ncloud_server.db.instance_no 
}

data "ncloud_server_products" "small" {
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  filter {
    name   = "product_code"
    values = ["SSD"]
    regex  = true
  }
  filter {
    name   = "cpu_count"
    values = ["2"]
  }
  filter {
    name   = "memory_size"
    values = ["4GB"]
  }
  filter {
    name   = "base_block_storage_size"
    values = ["50GB"]
  }
  filter {
    name   = "product_type"
    values = ["HICPU"]
  }
  output_file = "product.json"
}
