// NCP 관리 main.tf
terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

// Configure the ncloud provider
provider "ncloud" {
  region      = "KR"
  site = "PUBLIC"
  support_vpc = true
}

// init이후 가능한 리소스 설정, 서버를 만들 준비
resource "ncloud_login_key" "loginkey" {
    key_name = "test-key"
}

resource "ncloud_vpc" "test" {
    ipv4_cidr_block = "10.1.0.0/16" #10.1.0.0 으로
}

resource "ncloud_subnet" "test" {
    vpc_no         = ncloud_vpc.test.vpc_no
    subnet         = cidrsubnet(ncloud_vpc.test.ipv4_cidr_block, 8, 1)
    zone           = "KR-2"
    network_acl_no = ncloud_vpc.test.default_network_acl_no
    subnet_type    = "PUBLIC"
    usage_type     = "GEN"
}

resource "ncloud_server" "server" {
    subnet_no                 = ncloud_subnet.test.id
    name                      = "my-tf-server"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    login_key_name            = ncloud_login_key.loginkey.key_name
    }