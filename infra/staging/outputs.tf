output "be_public_ip" { 
  // be_public_ip는 백엔드 서버의 공용 IP 주소를 출력합니다.
  value = module.servers.be_public_ip
}

output "db_public_ip" { 
  value = module.servers.db_public_ip
}

output "lb_dns" {
  value = module.load_balancer.lb_dns
}