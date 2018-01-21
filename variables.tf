variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}

variable "private_key_path" {}
variable "key_name"{}

variable "aws_region"{
description="Region to Launch Instance's"
default="us-east-1"
}

variable "aws_amis"{
default = {
us-east-1="ami-2d39803a"
   }
}
