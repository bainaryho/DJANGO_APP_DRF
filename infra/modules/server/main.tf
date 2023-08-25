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

data "ncloud_subnet" "main"{
  id = var.subnet_id
}

########vpc subnet
data "ncloud_vpc" "main"{
  id = var.vpc_id
}

#### server
resource "ncloud_login_key" "loginkey" {
    key_name = "lion-${var.servername}-key-${var.env}"
}

#be ACG 설정
resource "ncloud_access_control_group" "main" {
  vpc_no      = data.ncloud_vpc.main.vpc_no
  name = "${var.servername}-acg-${var.env}"
} #set acg

resource "ncloud_access_control_group_rule" "main" {
  access_control_group_no = ncloud_access_control_group.main.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = var.acg_port_range
    description = "accept ${var.acg_port_range}port ${var.servername}"
  }
}

resource "ncloud_network_interface" "main" {
    name                  = "${var.servername}-nic-${var.env}"
    subnet_no             = data.ncloud_subnet.main.id
    access_control_groups = [
      data.ncloud_vpc.main.default_access_control_group_no,
      ncloud_access_control_group.main.id,
      ]
}

## 인스턴스 생성
resource "ncloud_server" "main" {
    subnet_no                 = data.ncloud_subnet.main.id
    name                      = "${var.servername}-server-${var.env}"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    server_product_code = var.server_product_code// server_product_code는 서버 스펙을 정해주는 것인데 해당 코드를 찾아야 합니다.
    #data.ncloud_server_products.small.server_products[0].product_code
    login_key_name            = ncloud_login_key.loginkey.key_name// login_key_name은 SSH 접속에 사용할 로그인 키의 이름입니다.
    init_script_no = ncloud_init_script.main.init_script_no// init_script_no는 서버 초기화 스크립트의 번호입니다
    
    network_interface { // ncloud_network_interface
      network_interface_no = ncloud_network_interface.main.id
      order = 0 // order는 네트워크 인터페이스의 우선 순위를 나타냅니다.
    }
  }

resource "ncloud_init_script" "main" {
   // set-be-tf는 백앤드 서버 초기화 스크립트 리소스를 정의합니다.
  name = "set-${var.servername}-tf-${var.env}"
  // be_init_script.tftpl 템플릿에 전달할 변수들을 설정합니다.
  content = templatefile(
    "${path.module}/${var.init_script_name}",
    var.init_script_envs
    )
}

# {
#     username = var.username
#     password = var.password
#     db = var.db
#     db_user = var.db_user
#     db_password = var.db_password
#     db_port = var.db_port
#     db_host = ncloud_public_ip.db.public_ip #db의 public_ip가 host
#     django_settings_module = var.django_settings_module
#     django_secret = var.django_secret
#     env = var.env
#   })
# }