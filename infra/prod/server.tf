## be인스턴스 생성
resource "ncloud_server" "be" {
    subnet_no                 = ncloud_subnet.main.id
    name                      = "be-prod-server"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    server_product_code = data.ncloud_server_products.small.server_products[0].product_code// server_product_code는 서버 스펙을 정해주는 것인데 해당 코드를 찾아야 합니다.
    login_key_name            = ncloud_login_key.loginkey.key_name// login_key_name은 SSH 접속에 사용할 로그인 키의 이름입니다.
    init_script_no = ncloud_init_script.be.init_script_no// init_script_no는 서버 초기화 스크립트의 번호입니다
    
    network_interface { // ncloud_network_interface
      network_interface_no = ncloud_network_interface.be.id
      order = 0 // order는 네트워크 인터페이스의 우선 순위를 나타냅니다.
    }
  }
resource "ncloud_init_script" "be" {
   // set-be-tf는 백앤드 서버 초기화 스크립트 리소스를 정의합니다.
  name = "set-be-prod-tf"
  // be_init_script.tftpl 템플릿에 전달할 변수들을 설정합니다.
  content = templatefile("${path.module}/be_pro_init_script.tftpl",{
    username = var.username
    password = var.password
    db = var.db
    db_user = var.db_user
    db_password = var.db_password
    db_port = var.db_port
    db_host = ncloud_public_ip.db.public_ip #db의 public_ip가 host
    django_settings_module = var.django_settings_module
    django_secret = var.django_secret
  })
}

#be ACG 설정
resource "ncloud_access_control_group" "be" {
  vpc_no      = ncloud_vpc.main.vpc_no
  name = "be-prod-staging"
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
    name                  = "be-prod-nic"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
      ncloud_vpc.main.default_access_control_group_no,
      ncloud_access_control_group.be.id,
      ]
}

## db인스턴스 생성
resource "ncloud_server" "db" {
    subnet_no                 = ncloud_subnet.main.id
    name                      = "db-prod-staging"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050" #이미지 변경
    //server_product_code 이게 서버 스펙 정해주는거인데 코드를 찾아야함
    server_product_code = data.ncloud_server_products.small.server_products[0].product_code
    login_key_name            = ncloud_login_key.loginkey.key_name
    init_script_no = ncloud_init_script.db.init_script_no
    
    network_interface {
      network_interface_no = ncloud_network_interface.db.id
      order = 0
    }
}
resource "ncloud_init_script" "db" {
   // set-db-tf는 데이터베이스 서버 초기화 스크립트 리소스를 정의합니다.
  name    = "set-db-prod-tf"
  content = templatefile("${path.module}/db_pro_init_script.tftpl", {
    username = var.username
    password = var.password
    db = var.db
    db_user = var.db_user
    db_password = var.db_password
    db_port = var.db_port
  })
}
#db ACG 설정
resource "ncloud_access_control_group" "db" {
  name = "db-prod-staging"
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
    name                  = "db-prod-nic"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
      ncloud_vpc.main.default_access_control_group_no,
      ncloud_access_control_group.db.id,
      ]
}
