 terraform {
   required_providers {
     aws ={
        source = "hashicorp/aws"
        version = "~> 5.0"
     }
   }
 }

 provider "aws" {
   region = "ap-northeast-2"
 }

 resource "aws_vpc" "example" {
   cidr_block = "10.1.0.0/16"
   
   tags = {
    Name = "lion-vpc"
   }
 }

#  # Create IAM user list로 작성시 data lion_or남기고 주석
# resource "aws_ian_user" "dev" {
#   for_each = toset(["monkey", "hippo", "horse"])
#   name = each.key
#   path = "/dev/"
# }

resource "aws_iam_user" "lion" {
  name = "lion-tf"
  path = "/"
}

resource "aws_iam_access_key" "lion" {
  user = aws_iam_user.lion.name
}

data "aws_iam_policy_document" "lion_ro" { #이거빼고 다 주석
  statement {
    effect = "Allow"
    actions = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lion_ro" {
  name = "tf-test"
  user = aws_iam_user.lion.name
  policy = data.aws_iam_policy_document.lion_ro.json
}

resource "aws_iam_user_login_profile" "example" {
  user = aws_iam_user.lion.name
}

output "password"{
  value = aws_iam_user_login_profile.example.password
}

resource "local_file" "users" {
  content = "${aws_iam_user_login_profile.example.password}"
  filename = "${path.module}/users.txt"
}

