resource "ncloud_vpc" "main" {
    ipv4_cidr_block = "10.10.0.0/16"
    name = "lion-prod-tf"
}

resource "ncloud_subnet" "main" {
  // ncloud_subnet 리소스 생성
    vpc_no         = ncloud_vpc.main.vpc_no
    subnet         = cidrsubnet(ncloud_vpc.main.ipv4_cidr_block, 8, 1)
    zone           = "KR-2"
    network_acl_no = ncloud_vpc.main.default_network_acl_no
    subnet_type    = "PUBLIC"
    usage_type     = "GEN"
    name = "lion-prod-tf-sub"
}

resource "ncloud_public_ip" "be" {
   //공용 IP 주소를 할당하고, 이 주소를 be서버 인스턴스와 연결하고 있습니다.
    server_instance_no = ncloud_server.be.instance_no
}


resource "ncloud_public_ip" "db" {
  #공용 IP 주소를 할당하고, 이 주소를 db서버 인스턴스와 연결하고 있습니다.
    server_instance_no = ncloud_server.db.instance_no 
}

# loadBalancer subnet
resource "ncloud_subnet" "be-lb" {
  vpc_no = ncloud_vpc.main.id
  subnet = cidrsubnet(ncloud_vpc.main.ipv4_cidr_block,8,2)
  zone = "KR-2"
  network_acl_no = ncloud_vpc.main.default_network_acl_no
  subnet_type = "PRIVATE"
  name = "be-prod-lb-subnet"
  usage_type = "LOADB"
}
