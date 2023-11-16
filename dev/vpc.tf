#Default Network ACL
resource "aws_default_network_acl" "default" {
  default_network_acl_id = module.vpc.default_network_acl_id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.my_ip}"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = -1
    rule_no    = 101
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "main"
  }
}


#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.stack}-vpc1"
  cidr                 = "${var.cidr_block}"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  private_subnet_tags = {
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
     Terraform = "true"
     Environment = "${var.stack}"
     "kubernetes.io/role/internal-elb" = 1
   }

  public_subnet_tags = {
   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Terraform = "true"
    Environment = "${var.stack}"
    "kubernetes.io/role/elb" = 1
  }
}

# resource "aws_security_group" "vpc_default_sg" {
#   vpc_id      = module.vpc.vpc_id  

#   name        = "vpc_default_sg"
#   description = "vpc_default_sg"

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["${var.my_ip}"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "vpc_default_sg"
#     // Add more tags as needed
#   }
# }

