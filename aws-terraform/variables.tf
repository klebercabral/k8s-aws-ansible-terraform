variable "region" { default = "us-east-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "vpc_azs" { default = ["us-east-1a"] }
variable "vpc_public_subnets" { default = ["10.0.101.0/24"] }
variable "ec2_ami" { default = "ami-07ebfd5b3428b6f4d" }
variable "ec2_instance_type" { default = "t2.medium" }
variable "key_pair_name" { default = "lab" }