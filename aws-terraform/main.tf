provider "aws" {
  region                    = "us-east-1"
  version                   = "~> 2.0"
}
module "network" {
  source                    = "terraform-aws-modules/vpc/aws"
  name                      = "k8s-descomplicando-ansible-vpc"
  cidr                      = "10.0.0.0/16"
  azs                       = ["us-east-1a"]
  public_subnets            = ["10.0.101.0/24"]
}
module "firewall" {
  source                    = "terraform-aws-modules/security-group/aws"
  name                      = "k8s-descomplicando-ansible-sg"
  vpc_id                    = module.network.vpc_id
  ingress_with_cidr_blocks  = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    description = "etcd server API"
    cidr_blocks = "0.0.0.0/0"
  },
  ]
}
module "ec2" {
  source                    = "terraform-aws-modules/ec2-instance/aws"
  name                      = "k8s-descomplicando-ansible"
  instance_count            = 3
  ami                       = "ami-07ebfd5b3428b6f4d"
  instance_type             = "t2.micro"
  key_name                  = "lab"
  vpc_security_group_ids    = [module.firewall.this_security_group_id]
  subnet_id                 = module.network.public_subnets[0]
}
output "public1" {
  value = module.ec2.public_ip[0]
}
output "public2" {
  value = module.ec2.public_ip[1]
}
output "public3" {
  value = module.ec2.public_ip[2]
}
output "private1" {
  value = module.ec2.private_ip[0]
}