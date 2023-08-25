// NCP 액세스 키와 시크릿 키를 변수로 설정
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
  sensitive = true
}
// 사용자 이름과 패스워드 변수 정의
variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "servername" {
  type = string
}

variable "init_script_name" {
  type = string
}

variable "init_script_envs" {
  type = map(any)
}

variable "server_product_code" {
  type = string
}

variable "acg_port_range" {
  type = string
}