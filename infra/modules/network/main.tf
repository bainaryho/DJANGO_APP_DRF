terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "KR"
  site = "PUBLIC"
  support_vpc = true
}

resource "ncloud_vpc" "main" {
  ipv4_cidr_block = "10.1.0.0/16"
  name = "tf-vpc-${var.env}"
}


#서버에서 이사옴
resource "ncloud_subnet" "main" {
  // ncloud_subnet 리소스 생성
    vpc_no         = data.ncloud_vpc.main.vpc_no
    subnet         = cidrsubnet(data.ncloud_vpc.main.ipv4_cidr_block, 8, 1)
    zone           = "KR-2"
    network_acl_no = data.ncloud_vpc.main.default_network_acl_no
    subnet_type    = "PUBLIC"
    usage_type     = "GEN"
    name = "lion-tf-sub-${var.env}"
}

