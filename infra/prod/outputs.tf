output "products" {
  // products는 사용 가능한 서버 제품에 대한 맵을 반환합니다.
  value = {
    for product in data.ncloud_server_products.small.server_products:
    product.id => product.product_name
  }
}

output "be_public_ip" { 
  // be_public_ip는 백엔드 서버의 공용 IP 주소를 출력합니다.
  value = ncloud_public_ip.be.public_ip
}

output "db_public_ip" { 
  value = ncloud_public_ip.db.public_ip
}

output "loadbalance_domain" { 
  // loadbalance output
  value = ncloud_lb.be-staging.domain
}