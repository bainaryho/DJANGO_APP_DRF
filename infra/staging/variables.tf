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

variable "db" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "db_port" {
  type = string
  default = "5432"
}

variable "django_settings_module" {
  type = string
}

variable "django_secret" {
  type = string
  sensitive = true
}