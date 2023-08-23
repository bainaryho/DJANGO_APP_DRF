// NCP 관리 main.tf
terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  // ncloud 공급자를 구성
  access_key = var.access_key
  secret_key = var.secret_key
  region = "KR"
  site = "PUBLIC"
  support_vpc = true
}

resource "ncloud_login_key" "loginkey" {
  // ncloud_login_key 리소스 생성
    key_name = "test1-key"
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
