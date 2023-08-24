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

