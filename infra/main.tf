// NCP 관리 main.tf
terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

variable "NCP_ACCESS_KEY" {
  type = string
}

variable "NCP_SECRET_KEY" {
  type = string
  sensitive = true
}

// Configure the ncloud provider
provider "ncloud" {
  NCP_ACCESS_KEY = var.access_key
  NCP_SECRET_KEY = var.secret_key
  region = "KR"
  site = "PUBLIC"
  support_vpc = true
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

// init이후 가능한 리소스 설정, 서버를 만들 준비
resource "ncloud_login_key" "loginkey" {
    key_name = "test-key"
}

resource "ncloud_vpc" "main" {
    ipv4_cidr_block = "10.1.0.0/16" #10.1.0.0 으로
    name = "lion-tf"
}

resource "ncloud_subnet" "main" {
    vpc_no         = ncloud_vpc.main.vpc_no
    subnet         = cidrsubnet(ncloud_vpc.main.ipv4_cidr_block, 8, 1)
    zone           = "KR-2"
    network_acl_no = ncloud_vpc.main.default_network_acl_no
    subnet_type    = "PUBLIC"
    usage_type     = "GEN"
    name = "lion-tf-sub"
}

resource "ncloud_server" "be" {
    subnet_no                 = ncloud_subnet.main.id
    name                      = "be-server"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050" #이미지 변경
    //server_product_code 이게 서버 스펙 정해주는거인데 코드를 찾아야함
    server_product_code = data.ncloud_server_products.small.server_products[0].product_code
    login_key_name            = ncloud_login_key.loginkey.key_name
    init_script_no = ncloud_init_script.main.init_script_no
    
    network_interface { // ncloud_network_interface
      network_interface_no = ncloud_network_interface.be.id
      order = 0
    }
  }

resource "ncloud_init_script" "main" {
  name = "set-server-tf"
  content = templatefile("${path.module}/main_init_script.tftpl",{
    username = var.username
    password = var.password
  })
}

resource "ncloud_public_ip" "be" {
    server_instance_no = ncloud_server.be.instance_no #vpc 퍼블릭 ip와 서버 인스턴스 연결
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

output "products" {
  value = {
    for product in data.ncloud_server_products.small.server_products:
    product.id => product.product_name
  }
}

output "be_public_ip" { 
  value = ncloud_public_ip.be.public_ip
}

## db인스턴스 생성
resource "ncloud_server" "db" {
    subnet_no                 = ncloud_subnet.main.id
    name                      = "db-staging"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050" #이미지 변경
    //server_product_code 이게 서버 스펙 정해주는거인데 코드를 찾아야함
    server_product_code = data.ncloud_server_products.small.server_products[0].product_code
    login_key_name            = ncloud_login_key.loginkey.key_name
    init_script_no = ncloud_init_script.main.init_script_no
    
    network_interface {
      network_interface_no = ncloud_network_interface.db.id
      order = 0
    }
}

resource "ncloud_public_ip" "db" {
    server_instance_no = ncloud_server.db.instance_no #vpc 퍼블릭 ip와 서버 인스턴스 연결
}

output "db_public_ip" { 
  value = ncloud_public_ip.db.public_ip
}


#be ACG 설정
resource "ncloud_access_control_group" "be" {
  vpc_no      = ncloud_vpc.main.vpc_no
  name = "be-staging"
} #set acg

data "ncloud_access_control_group" "default"{
  id="124481" #lion-tf-default-acg
}

resource "ncloud_access_control_group_rule" "be" {
  access_control_group_no = ncloud_access_control_group.be.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "8000"
    description = "accept 8000 port"
  }
}

resource "ncloud_network_interface" "be" {
    name                  = "be-nic"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
      ncloud_vpc.main.default_access_control_group_no,
      ncloud_access_control_group.be.id,
      ]
}


#db ACG 설정
resource "ncloud_access_control_group" "db" {
  name = "db-staging"
  vpc_no      = ncloud_vpc.main.vpc_no
} #set acg


resource "ncloud_access_control_group_rule" "db" {
  access_control_group_no = ncloud_access_control_group.db.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "5432"
    description = "accept 5432 port for postgresql"
  }
}

resource "ncloud_network_interface" "db" {
    name                  = "db-nic"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
      ncloud_vpc.main.default_access_control_group_no,
      ncloud_access_control_group.db.id,
      ]
}

# subnet
resource "ncloud_subnet" "be-lb" {
  vpc_no = ncloud_vpc.main.id
  subnet = cidrsubnet(ncloud_vpc.main.ipv4_cidr_block,8,2)
  zone = "KR-2"
  network_acl_no = ncloud_vpc.main.default_network_acl_no
  subnet_type = "PRIVATE"
  name = "be-lb-subnet"
  usage_type = "LOADB"
}

## load Balancer 설정
resource "ncloud_lb" "be-staging" {
  name = "be-lb-staging"
  network_type = "PUBLIC"
  type = "NETWORK_PROXY"
  subnet_no_list = [ ncloud_subnet.be-lb.subnet_no]
}

# load Balancer와 target그룹 연결하는 lestener
resource "ncloud_lb_listener" "be" {
  load_balancer_no = ncloud_lb.be-staging.load_balancer_no
  protocol = "TCP"
  port = 80
  target_group_no = ncloud_lb_target_group.be.target_group_no
}

# target group 설정
resource "ncloud_lb_target_group" "be" {
  vpc_no   = ncloud_vpc.main.vpc_no
  protocol = "PROXY_TCP"
  target_type = "VSVR"
  port        = 8000
  description = "for django be"
  health_check {
    protocol = "TCP"
    http_method = "GET"
    port           = 8000
    url_path       = "/admin"
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }
  algorithm_type = "RR"
}

# target group attachment
resource "ncloud_lb_target_group_attachment" "be" {
  target_group_no = ncloud_lb_target_group.be.target_group_no
  target_no_list = [ncloud_server.be.instance_no]
}

# loadbalance output
output "loadbalance_domain" { 
  value = ncloud_lb.be-staging.domain
}
